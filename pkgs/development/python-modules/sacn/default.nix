{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "sacn";
  version = "1.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FIs5yn891haHinCmK3QQ0JQICXfnhPimMC81LXOV4Oo=";
  };

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "sacn" ];

  meta = with lib; {
    description = "Simple ANSI E1.31 (aka sACN) module";
    homepage = "https://github.com/Hundemeier/sacn";
    changelog = "https://github.com/Hundemeier/sacn/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
