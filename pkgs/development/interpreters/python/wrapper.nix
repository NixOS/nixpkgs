# Create a python that knows about additional python packages via
# PYTHONPATH

{ stdenv, python, makeWrapper, recursivePthLoader, extraLibs ? [] }:

stdenv.mkDerivation {
  name = "python-${python.version}-wrapper";

  propagatedBuildInputs = extraLibs ++ [ python makeWrapper recursivePthLoader ];

  unpackPhase = "true";
  installPhase = ''
    mkdir -p "$out/bin"
    for prg in 2to3 idle pdb pdb${python.majorVersion} pydoc python python-config python${python.majorVersion} python${python.majorVersion}-config smtpd.py; do
      makeWrapper "$python/bin/$prg" "$out/bin/$prg" --suffix PYTHONPATH : "$PYTHONPATH"
    done
    ensureDir "$out/share"
    ln -s "$python/share/man" "$out/share/man"
  '';

  inherit python;
  inherit (python) meta;
}
