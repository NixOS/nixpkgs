{ lib
, buildPythonPackage
, python
, fetchFromGitHub
, hatchling
, beautifulsoup4
, lxml
, jinja2
, pytestCheckHook
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "reqif";
<<<<<<< HEAD
  version = "0.0.35";
  format = "pyproject";

  disabled = pythonOlder "3.7";

=======
  version = "0.0.27";
  format = "pyproject";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "strictdoc-project";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-3yOLOflPqzJRv3qCQXFK3rIFftBq8FkYy7XhOfWH82Y=";
=======
    hash = "sha256-K+su1fhXf/fzL+AI/me2imCNI9aWMcv9Qo1dDRNypso=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace ./tests/unit/conftest.py --replace \
       "os.path.abspath(os.path.join(__file__, \"../../../../reqif\"))" \
      "\"${placeholder "out"}/${python.sitePackages}/reqif\""
    substituteInPlace requirements.txt --replace "==" ">="
  '';

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    lxml
    jinja2
  ];

  pythonImportsCheck = [
    "reqif"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Python library for ReqIF format";
    homepage = "https://github.com/strictdoc-project/reqif";
<<<<<<< HEAD
    changelog = "https://github.com/strictdoc-project/reqif/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ yuu ];
  };
}
