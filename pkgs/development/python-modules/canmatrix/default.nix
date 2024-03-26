{ lib
, attrs
, buildPythonPackage
, click
, fetchFromGitHub
, future
, importlib-metadata
, ldfparser
, lxml
, openpyxl
, pytestCheckHook
, pythonOlder
, pyyaml
, six
, xlrd
, xlwt
}:

buildPythonPackage rec {
  pname = "canmatrix";
  version = "1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ebroecker";
    repo = "canmatrix";
    rev = "refs/tags/${version}";
    hash = "sha256-UUJnLVt+uOj8Eav162btprkUeTemItGrSnBBB9UhJJI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version = versioneer.get_version()" 'version = "${version}"'
  '';

  propagatedBuildInputs = [
    attrs
    click
    future
    six
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  passthru.optional-dependencies = {
    arxml = [
      lxml
    ];
    fibex = [
      lxml
    ];
    kcd = [
      lxml
    ];
    ldf = [
      ldfparser
    ];
    odx = [
      lxml
    ];
    xls = [
      xlrd
      xlwt
    ];
    xlsx = [
      openpyxl
    ];
    yaml = [
      pyyaml
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pytestFlagsArray = [
    # long_envvar_name_imports requires stable key value pair ordering
    "-s src/canmatrix"
  ];

  disabledTests = [
    "long_envvar_name_imports"
  ];

  pythonImportsCheck = [
    "canmatrix"
  ];

  meta = with lib; {
    description = "Support and convert several CAN (Controller Area Network) database formats";
    homepage = "https://github.com/ebroecker/canmatrix";
    changelog = "https://github.com/ebroecker/canmatrix/releases/tag/${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sorki ];
  };
}
