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
  version = "0.5.11";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1hC7yE/hGLx9g3NXqU45yC/6dcW6/0oZwgYW5bj/37c=";
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

  meta = with lib; {
    description = "Python library for interfacing with Xiaomi smart appliances";
    homepage = "https://github.com/rytilahti/python-miio";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ flyfloh ];
  };
}
