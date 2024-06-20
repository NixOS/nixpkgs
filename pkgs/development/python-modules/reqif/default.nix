{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  jinja2,
  lxml,
  pytestCheckHook,
  python,
  pythonOlder,
  pythonRelaxDepsHook,
  xmlschema,
}:

buildPythonPackage rec {
  pname = "reqif";
  version = "0.0.42";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "strictdoc-project";
    repo = "reqif";
    rev = "refs/tags/${version}";
    hash = "sha256-cQhis7jrcly3cw2LRv7hpPBFAB0Uag69czf+wJvbh/Q=";
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
    xmlschema
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "reqif" ];

  meta = with lib; {
    description = "Python library for ReqIF format";
    mainProgram = "reqif";
    homepage = "https://github.com/strictdoc-project/reqif";
    changelog = "https://github.com/strictdoc-project/reqif/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ yuu ];
  };
}
