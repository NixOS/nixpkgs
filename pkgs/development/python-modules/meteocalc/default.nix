{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "meteocalc";
  version = "1.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "malexer";
    repo = "meteocalc";
    rev = version;
    hash = "sha256-WuIW6hROQkjMfbCLUouECIrp4s6oCd2/N79hsrTbVTk=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "meteocalc" ];

  meta = {
    description = "Module for calculation of meteorological variables";
    homepage = "https://github.com/malexer/meteocalc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
