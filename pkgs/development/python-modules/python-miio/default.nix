{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, poetry-core
, click
, cryptography
, construct
, zeroconf
, attrs
, pytz
, appdirs
, tqdm
, netifaces
, android-backup
, importlib-metadata
, croniter
, defusedxml
, pytestCheckHook
, pytest-mock
, pyyaml
}:


buildPythonPackage rec {
  pname = "python-miio";
  version = "0.5.10";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6iV+uIdVi0Z3FeM9xnp1Ss3VzFVEOm7wykxjSTXUIGM=";
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
    netifaces
    pytz
    pyyaml
    tqdm
    zeroconf
  ] ++ lib.optional (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mock
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'defusedxml = "^0"' 'defusedxml = "*"' \
  '';

  pythonImportsCheck = [
    "miio"
  ];

  disabledTestPaths = [
    "miio/tests/test_vacuums.py"
  ];

  meta = with lib; {
    description = "Python library for interfacing with Xiaomi smart appliances";
    homepage = "https://github.com/rytilahti/python-miio";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ flyfloh ];
  };
}
