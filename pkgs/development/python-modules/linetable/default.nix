{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "linetable";
  version = "0.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "amol-";
    repo = "linetable";
    tag = version;
    hash = "sha256-nVZVxK6uB5TP0pReaEya3/lFXFkiqpnnaWqYzxzO6bM=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "linetable" ];

<<<<<<< HEAD
  meta = {
    description = "Library to parse and generate co_linetable attributes in Python code objects";
    homepage = "https://github.com/amol-/linetable";
    changelog = "https://github.com/amol-/linetable/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Library to parse and generate co_linetable attributes in Python code objects";
    homepage = "https://github.com/amol-/linetable";
    changelog = "https://github.com/amol-/linetable/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
