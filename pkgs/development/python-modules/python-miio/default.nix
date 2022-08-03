{ lib
, android-backup
, appdirs
, attrs
, buildPythonPackage
, click
, construct
, croniter
, cryptography
, defusedxml
, fetchPypi
, importlib-metadata
, micloud
, netifaces
, poetry-core
, pytest-mock
, pytestCheckHook
, pythonOlder
, pytz
, pyyaml
, tqdm
, zeroconf
}:


buildPythonPackage rec {
  pname = "python-miio";
  version = "0.5.12";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BJw1Gg3FO2R6WWKjkrpxDN4fTMTug5AIj0SNq1gEbBY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    android-backup
    appdirs
    attrs
    click
    construct
    croniter
    cryptography
    defusedxml
    micloud
    netifaces
    pytz
    pyyaml
    tqdm
    zeroconf
  ] ++ lib.optional (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    pytest-mock
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'defusedxml = "^0"' 'defusedxml = "*"'
    # Will be fixed with the next release, https://github.com/rytilahti/python-miio/pull/1378
    substituteInPlace miio/integrations/vacuum/roborock/vacuum_cli.py \
      --replace "resultcallback" "result_callback"
  '';

  pythonImportsCheck = [
    "miio"
  ];

  meta = with lib; {
    description = "Python library for interfacing with Xiaomi smart appliances";
    homepage = "https://github.com/rytilahti/python-miio";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ flyfloh ];
  };
}
