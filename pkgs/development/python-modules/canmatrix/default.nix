{
  lib,
  attrs,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  ldfparser,
  lxml,
  openpyxl,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
  pyyaml,
  setuptools,
  xlrd,
  xlwt,
}:

buildPythonPackage (finalAttrs: {
  pname = "canmatrix";
  version = "1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ebroecker";
    repo = "canmatrix";
    tag = finalAttrs.version;
    hash = "sha256-PfegsFha7ernSqnMeaDoLf1jLx1CiOoiYi34dESEgBY=";
  };

  postPatch = ''
    # Allows to skip versioneer and use the version from nixpkgs instead
    substituteInPlace setup.py \
      --replace-fail 'version = versioneer.get_version(),' 'version = "${finalAttrs.version}",'
  '';

  build-system = [ setuptools ];

  dependencies = [
    attrs
    click
  ];

  optional-dependencies = {
    arxml = [ lxml ];
    fibex = [ lxml ];
    kcd = [ lxml ];
    ldf = [ ldfparser ];
    odx = [ lxml ];
    xls = [
      xlrd
      xlwt
    ];
    xlsx = [ openpyxl ];
    yaml = [ pyyaml ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pytestFlags = [
    # long_envvar_name_imports requires stable key value pair ordering
    "-s"
  ];

  enabledTestPaths = [
    "src/canmatrix"
    "tests/"
  ];

  disabledTests = [ "long_envvar_name_imports" ];

  pythonImportsCheck = [ "canmatrix" ];

  meta = {
    description = "Support and convert several CAN (Controller Area Network) database formats";
    homepage = "https://github.com/ebroecker/canmatrix";
    changelog = "https://github.com/ebroecker/canmatrix/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ sorki ];
  };
})
