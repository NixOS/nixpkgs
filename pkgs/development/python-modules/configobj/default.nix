{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
  pythonOlder,
  six,
}:

buildPythonPackage rec {
  pname = "configobj";
  version = "5.0.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

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

<<<<<<< HEAD
  meta = {
    description = "Config file reading, writing and validation";
    homepage = "https://github.com/DiffSK/configobj";
    changelog = "https://github.com/DiffSK/configobj/blob/v${version}/CHANGES.rst";
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "Config file reading, writing and validation";
    homepage = "https://github.com/DiffSK/configobj";
    changelog = "https://github.com/DiffSK/configobj/blob/v${version}/CHANGES.rst";
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
