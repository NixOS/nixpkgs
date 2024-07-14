{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "addict";
  version = "2.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s7IhDg4GeigfVkbIxduS6ZtyMeqLDrX3Tb354lnU5JQ=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "addict" ];

  meta = with lib; {
    description = "Module that exposes a dictionary subclass that allows items to be set like attributes";
    homepage = "https://github.com/mewwts/addict";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ veprbl ];
  };
}
