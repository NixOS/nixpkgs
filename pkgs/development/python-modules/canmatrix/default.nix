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
  pythonOlder,
  pyyaml,
  setuptools,
  xlrd,
  xlwt,
}:

buildPythonPackage rec {
  pname = "canmatrix";
  version = "1.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ebroecker";
    repo = "canmatrix";
    tag = version;
    hash = "sha256-PfegsFha7ernSqnMeaDoLf1jLx1CiOoiYi34dESEgBY=";
  };

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
  ++ lib.flatten (builtins.attrValues optional-dependencies);

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

  meta = with lib; {
    description = "Support and convert several CAN (Controller Area Network) database formats";
    homepage = "https://github.com/ebroecker/canmatrix";
    changelog = "https://github.com/ebroecker/canmatrix/releases/tag/${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sorki ];
  };
}
