import os
import sys
from importlib.metadata import version

import angr
import archinfo
import claripy
import cle
import pypcode
import pyvex
import sqlalchemy
import unicorn
from angr.angrdb import AngrDB
from angr.protos import primitives_pb2

binary = os.path.realpath(sys.argv[1])
expected_version = sys.argv[2]

for distribution in ("angr", "archinfo", "claripy", "cle", "pyvex"):
    assert version(distribution) == expected_version
assert angr.__version__ == expected_version
assert archinfo.ArchAMD64().bits == 64
assert unicorn.__version__

# Claripy and the nixpkgs Z3 binding.
x = claripy.BVS("x", 32)
solver = claripy.Solver()
solver.add((x * 3) + 1 == 22)
assert solver.eval(x, 1) == (7,)

# Native Rust extension and generated protobuf modules.
assert angr.rustylib.__file__.endswith(".so")
edge = primitives_pb2.Edge()
edge_bytes = edge.SerializeToString()
assert primitives_pb2.Edge.FromString(edge_bytes) == edge

# ELF loading, symbol lookup, VEX lifting, disassembly, and CFG recovery.
project = angr.Project(binary, auto_load_libs=False)
assert isinstance(project.loader.main_object, cle.ELF)
choose_symbol = project.loader.find_symbol("choose")
assert choose_symbol is not None
choose_addr = choose_symbol.rebased_addr
block = project.factory.block(choose_addr)
assert isinstance(block.vex, pyvex.IRSB)
assert block.vex.statements
assert block.capstone.insns

cfg = project.analyses.CFGFast(normalize=True)
choose_function = cfg.kb.functions.function(addr=choose_addr)
assert choose_function is not None
assert choose_function.name == "choose"

# Execute the recovered function with a symbolic argument and solve for the
# branch returning 42.
symbolic_arg = claripy.BVS("symbolic_arg", 32)
state = project.factory.call_state(choose_addr, symbolic_arg)
simgr = project.factory.simulation_manager(state)
simgr.run()
return_value = project.factory.cc().RETURN_VAL
winning = [
    deadended
    for deadended in simgr.deadended
    if deadended.solver.satisfiable(
        extra_constraints=[return_value.get_value(deadended) == 42]
    )
]
assert winning
assert (
    winning[0].solver.eval(
        symbolic_arg, extra_constraints=[return_value.get_value(winning[0]) == 42]
    )
    == 0x1337
)

# Exercise Unicorn acceleration for a real binary block.
unicorn_state = project.factory.entry_state(add_options=angr.options.unicorn)
unicorn_state.unicorn.cooldown_nonunicorn_blocks = 0
unicorn_simgr = project.factory.simulation_manager(unicorn_state)
unicorn_simgr.run(n=1)
assert unicorn_simgr.active
assert any(
    "Unicorn" in description
    for description in unicorn_simgr.active[0].history.descriptions
)

# Exercise pypcode independently of the VEX engine.
pcode = pypcode.Context("x86:LE:64:default")
translation = pcode.translate(b"\x90\xc3", 0x1000)
assert translation.ops

# Exercise the optional angrDB dependency used by angr-management.
assert sqlalchemy.__version__
assert AngrDB is not None

print(
    "angr loader, VEX, CFG, symbolic execution, Unicorn, p-code, "
    "Rust, protobuf, and angrDB: OK"
)
