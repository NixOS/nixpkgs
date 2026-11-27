{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  jinja2,
  lxml,
  openpyxl,
  pytestCheckHook,
  python,
  xmlschema,
}:

buildPythonPackage (finalAttrs: {
  pname = "reqif";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "strictdoc-project";
    repo = "reqif";
    tag = finalAttrs.version;
    hash = "sha256-e6VG3UYx/wbo+noDflHjAywzRgrA7RwC0/kJq55Wjzs=";
  };

  postPatch = ''
    substituteInPlace ./tests/unit/conftest.py \
      --replace-fail "os.path.abspath(os.path.join(__file__, \"../../../../reqif\"))" \
      "\"${placeholder "out"}/${python.sitePackages}/reqif\""
  '';

  build-system = [
    hatchling
  ];

  dependencies = [
    lxml
    jinja2
    xmlschema
    openpyxl
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "reqif" ];

  meta = {
    description = "Python library for ReqIF format";
    mainProgram = "reqif";
    homepage = "https://github.com/strictdoc-project/reqif";
    changelog = "https://github.com/strictdoc-project/reqif/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
