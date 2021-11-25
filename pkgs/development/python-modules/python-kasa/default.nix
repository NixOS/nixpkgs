{ lib
, asyncclick
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, importlib-metadata
, poetry-core
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, voluptuous
}:

buildPythonPackage rec {
  pname = "python-kasa";
  version = "0.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "08blmz5kg826l08pf6yrvl8gc8iz3hfb6wsfqih606dal08kdhdi";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    asyncclick
    importlib-metadata
  ];

  checkInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    voluptuous
  ];

  patches = [
    # Switch to poetry-core, https://github.com/python-kasa/python-kasa/pull/226
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/python-kasa/python-kasa/commit/05c2a4a7dedbd60038e177b4d3f5ac5798544d11.patch";
      sha256 = "0cla11yqx88wj2s50s3xxxhv4nz4h3wd9pi12v79778hzdlg58rr";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'asyncclick = "^7"' 'asyncclick = "*"'
  '';

  disabledTestPaths = [
    # Skip the examples tests
    "kasa/tests/test_readme_examples.py"
  ];

  pythonImportsCheck = [ "kasa" ];

  meta = with lib; {
    description = "Python API for TP-Link Kasa Smarthome products";
    homepage = "https://python-kasa.readthedocs.io/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
