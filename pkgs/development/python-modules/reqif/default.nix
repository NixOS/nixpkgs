{ lib
, buildPythonPackage
, python
, fetchFromGitHub
, hatchling
, beautifulsoup4
, lxml
, jinja2
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "reqif";
  version = "0.0.35";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "strictdoc-project";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-3yOLOflPqzJRv3qCQXFK3rIFftBq8FkYy7XhOfWH82Y=";
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
    changelog = "https://github.com/strictdoc-project/reqif/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ yuu ];
  };
}
