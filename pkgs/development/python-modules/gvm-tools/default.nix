{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  python-gvm,
}:

buildPythonPackage rec {
  pname = "gvm-tools";
<<<<<<< HEAD
  version = "25.4.4";
=======
  version = "25.4.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "gvm-tools";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-htBkQf9rxPXDtcr5w1ECshEKyPxPr6YaS4PtMvK2VQg=";
=======
    hash = "sha256-mhQX9yBH8mQ+ESZzqM2VC4bfktI677Y/dli/YWTYRhE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ python-gvm ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Don't test sending
    "SendTargetTestCase"
    "HelpFormattingParserTestCase"
  ];

  pythonImportsCheck = [ "gvmtools" ];

<<<<<<< HEAD
  meta = {
    description = "Collection of APIs that help with remote controlling a Greenbone Security Manager";
    homepage = "https://github.com/greenbone/gvm-tools";
    changelog = "https://github.com/greenbone/gvm-tools/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Collection of APIs that help with remote controlling a Greenbone Security Manager";
    homepage = "https://github.com/greenbone/gvm-tools";
    changelog = "https://github.com/greenbone/gvm-tools/releases/tag/${src.tag}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
