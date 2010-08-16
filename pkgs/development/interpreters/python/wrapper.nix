{stdenv, python, makeWrapper, extraLibs ? []}:

stdenv.mkDerivation {
  name = "python-${python.version}-wrapper";

  propagatedBuildInputs = [python makeWrapper] ++ extraLibs;

  unpackPhase = "true";
  installPhase = ''
    ensureDir "$out/bin"
    declare -p
    for prg in 2to3 idle pydoc python python-config python${python.majorVersion} python${python.majorVersion}-config smtpd.py; do
      makeWrapper "$python/bin/$prg" "$out/bin/$prg" --set PYTHONPATH "$PYTHONPATH"
    done
  '';

  inherit python;
  inherit (python) meta;
}
