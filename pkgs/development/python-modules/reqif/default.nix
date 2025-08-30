{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  jinja2,
  lxml,
  pytestCheckHook,
  python,
  xmlschema,
}:

buildPythonPackage rec {
  pname = "reqif";
  version = "0.0.46";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "strictdoc-project";
    repo = "reqif";
    tag = version;
    hash = "sha256-QI+OhhV+jKw3g2erSCdTj10JW+XFQQyXuAC0LAnts7c=";
  };

  postPatch = ''
    substituteInPlace ./tests/unit/conftest.py \
      --replace-fail "os.path.abspath(os.path.join(__file__, \"../../../../reqif\"))" \
      "\"${placeholder "out"}/${python.sitePackages}/reqif\""
  '';

  build-system = [
    hatchling
  ];

  dependencies = with python.pkgs; [
    lxml
    jinja2
    xmlschema
    openpyxl
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "reqif" ];

  meta = with lib; {
    description = "Python library for ReqIF format";
    mainProgram = "reqif";
    homepage = "https://github.com/strictdoc-project/reqif";
    changelog = "https://github.com/strictdoc-project/reqif/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ yuu ];
  };
}
