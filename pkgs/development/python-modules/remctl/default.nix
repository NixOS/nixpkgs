{ lib, buildPythonPackage, isPy27, remctl, pytestCheckHook, pytestrunner, typing }:

buildPythonPackage {
  inherit (remctl) pname version meta;
  src = remctl.pythonsrc;
  postPatch = ''
    sed -i '/install_requires/d' setup.py
  '';
  buildInputs = [ remctl ];
  checkInputs = [ pytestCheckHook ];
  patches = [
    ./no-setup-requires-pytestrunner.patch
  ];
  propagatedBuildInputs = lib.optionals (isPy27) [ typing ];
}
