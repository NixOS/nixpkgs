{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  capstone,
  future,
  ipython,
  psutil,
  pwntools,
  pycparser,
  pyelftools,
  pygments,
  requests,
  rpyc,
  sortedcontainers,
  tabulate,
  typing-extensions,
  unicorn,
  gdb-pt-dump,
  poetry-core,
}:
let
  # The newest gdb-pt-dump is incompatible with pwndbg 2024.02.14.
  # See https://github.com/martinradev/gdb-pt-dump/issues/29
  gdb-pt-dump' = gdb-pt-dump.overrideAttrs (oldAttrs: {
    version = "0-unstable-2023-11-11";

    src = fetchFromGitHub {
      inherit (oldAttrs.src) owner repo;
      rev = "89ea252f6efc5d75eacca16fc17ff8966a389690";
      hash = "sha256-i+SAcZ/kgfKstJnkyCVMh/lWtrJJOHTYoJH4tVfYHrE=";
    };

    # This revision relies on the package being imported from within GDB, which
    # won't work with pythonImportsCheck.
    pythonImportsCheck = [ ];
  });
in
buildPythonPackage rec {
  pname = "pwndbg";
  version = "2024.02.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pwndbg";
    repo = "pwndbg";
    rev = version;
    hash = "sha256-/pDo2J5EtpWWCurD7H34AlTlQi7WziIRRxHxGm3K2yk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];
  pythonRelaxDeps = true;

  propagatedBuildInputs = [
    capstone
    future
    ipython
    psutil
    pwntools
    pycparser
    pyelftools
    pygments
    requests
    rpyc
    sortedcontainers
    tabulate
    typing-extensions
    unicorn
    gdb-pt-dump'
  ];

  meta = {
    description = "Exploit Development and Reverse Engineering with GDB Made Easy";
    homepage = "https://pwndbg.re";
    changelog = "https://github.com/pwndbg/pwndbg/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ msanft ];
  };
}
