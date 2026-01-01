{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jsonformatter";
  version = "0.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MyColorfulDays";
    repo = "jsonformatter";
    tag = "v${version}";
    hash = "sha256-A+lsSBrm/64w7yMabmuAbRCLwUUdulGH3jB/DbYJ2QY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jsonformatter" ];

<<<<<<< HEAD
  meta = {
    description = "Formatter to output JSON log, e.g. output LogStash needed log";
    homepage = "https://github.com/MyColorfulDays/jsonformatter";
    changelog = "https://github.com/MyColorfulDays/jsonformatter/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ gador ];
=======
  meta = with lib; {
    description = "Formatter to output JSON log, e.g. output LogStash needed log";
    homepage = "https://github.com/MyColorfulDays/jsonformatter";
    changelog = "https://github.com/MyColorfulDays/jsonformatter/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ gador ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
