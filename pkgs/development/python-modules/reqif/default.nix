{ lib
, buildPythonPackage
, python
, fetchFromGitHub
, hatchling
, beautifulsoup4
, lxml
, jinja2
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "reqif";
  version = "0.0.27";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "strictdoc-project";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-K+su1fhXf/fzL+AI/me2imCNI9aWMcv9Qo1dDRNypso=";
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
    license = licenses.asl20;
    maintainers = with maintainers; [ yuu ];
  };
}
