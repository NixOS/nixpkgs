{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
  six,
}:

buildPythonPackage rec {
  pname = "configobj";
  version = "5.0.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "DiffSK";
    repo = "configobj";
    tag = "v${version}";
    hash = "sha256-duPCGBaHCXp4A6ZHLnyL1SZtR7K4FJ4hs5wCE1V9WB4=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ mock ];

  pythonImportsCheck = [ "configobj" ];

  meta = {
    description = "Config file reading, writing and validation";
    homepage = "https://github.com/DiffSK/configobj";
    changelog = "https://github.com/DiffSK/configobj/blob/v${version}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
