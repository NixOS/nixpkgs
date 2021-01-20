{ lib
, buildPythonPackage
, flit
, isPy3k
, toml
}:

buildPythonPackage rec {
  pname = "flit-core";
  version = "2.3.0";
  disabled = !isPy3k;
  format = "pyproject";

  inherit (flit) src patches;

  preConfigure = ''
    cd flit_core
  '';

  propagatedBuildInputs = [
    toml
  ];

  passthru.tests = {
    inherit flit;
  };

  meta = {
    description = "Distribution-building parts of Flit. See flit package for more information";
    homepage = "https://github.com/takluyver/flit";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.fridh ];
  };
}
