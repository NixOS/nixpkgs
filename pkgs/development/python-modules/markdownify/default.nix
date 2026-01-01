{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
  six,
}:

buildPythonPackage rec {
  pname = "markdownify";
<<<<<<< HEAD
  version = "1.2.2";
=======
  version = "1.2.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "matthewwithanm";
    repo = "python-markdownify";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-r6nah7QavrMjIHd5hByhy90OoTDb2iIhFZ+YV0h61fU=";
=======
    hash = "sha256-/u9rjbHeBhiqzpudsv2bFSaFbme1zmCv8/jEflEDNkQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    beautifulsoup4
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "markdownify" ];

<<<<<<< HEAD
  meta = {
    description = "HTML to Markdown converter";
    homepage = "https://github.com/matthewwithanm/python-markdownify";
    changelog = "https://github.com/matthewwithanm/python-markdownify/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ McSinyx ];
=======
  meta = with lib; {
    description = "HTML to Markdown converter";
    homepage = "https://github.com/matthewwithanm/python-markdownify";
    changelog = "https://github.com/matthewwithanm/python-markdownify/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ McSinyx ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "markdownify";
  };
}
