{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  appdirs,
  cachetools,
  diskcache,
  foss-flame,
  license-expression,
  packageurl-python,
  python-magic,
  requests,
  scancode-toolkit,
  xmltodict,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "lookup-license";
  version = "0.1.30";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hesa";
    repo = "lookup-license";
    tag = finalAttrs.version;
    hash = "sha256-zFDqh62bjYkO3Duze3suS8LlrlzuqQes7ZaH+9G+yQ4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    appdirs
    cachetools
    diskcache
    foss-flame
    license-expression
    packageurl-python
    python-magic
    requests
    scancode-toolkit
    xmltodict
  ];

  pythonRelaxDeps = [
    "requests"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # UnboundLocalError: cannot access local variable 'ret' where it is not associated with a value
    "test_lookup_license_url_bad"
    "test_lookup_license_url_good"
  ];

  pythonImportsCheck = [
    "lookup_license"
  ];

  meta = {
    description = "Python tool to identify license from license text";
    homepage = "https://github.com/hesa/lookup-license";
    changelog = "https://github.com/hesa/lookup-license/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "lookup-license";
    license = with lib.licenses; [
      gpl3Only
      asl20
      cc-by-40
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
