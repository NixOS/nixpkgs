{ lib, buildPythonPackage, isPy27, remctl, pytestCheckHook, pytestrunner, typing }:

buildPythonPackage {
  inherit (remctl) pname version meta;
  src = remctl.pythonsrc;
  postPatch = ''
    sed -i '/install_requires/d' setup.py
  '';
  buildInputs = [ pkgs.remctl ];
  checkInputs = [ pytestCheckHook pytestrunner ];
  propagatedBuildInputs = lib.optionals (isPy27) [ typing ];
}
