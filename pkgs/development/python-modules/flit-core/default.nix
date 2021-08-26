{ lib
, buildPythonPackage
, flit
, isPy3k
, toml
, pytestCheckHook
, testpath
}:

buildPythonPackage rec {
  pname = "flit-core";
  version = "3.2.0";
  format = "pyproject";

  inherit (flit) src patches;

  preConfigure = ''
    cd flit_core
  '';

  propagatedBuildInputs = [
    toml
  ];

  checkInputs = [
    pytestCheckHook
    testpath
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
