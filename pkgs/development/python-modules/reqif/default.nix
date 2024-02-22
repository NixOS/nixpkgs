{ lib
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, hatchling
, jinja2
, lxml
, pytestCheckHook
, python
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "reqif";
  version = "0.0.35";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "strictdoc-project";
    repo = "reqif";
    rev = "refs/tags/${version}";
    hash = "sha256-3yOLOflPqzJRv3qCQXFK3rIFftBq8FkYy7XhOfWH82Y=";
  };

  postPatch = ''
    substituteInPlace ./tests/unit/conftest.py \
      --replace-fail "os.path.abspath(os.path.join(__file__, \"../../../../reqif\"))" \
      "\"${placeholder "out"}/${python.sitePackages}/reqif\""
  '';

  nativeBuildInputs = [
    hatchling
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    lxml
    jinja2
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "reqif"
  ];

  meta = with lib; {
    description = "Python library for ReqIF format";
    homepage = "https://github.com/strictdoc-project/reqif";
    changelog = "https://github.com/strictdoc-project/reqif/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ yuu ];
  };
}
