{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, poetry
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
  version = "0.5.5.2";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-lk7egCyj+vSsaXmxuWxlQuom8n3JEs/RIWwCuwTOXeI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'croniter = "^0"' 'croniter = "*"' \
      --replace 'defusedxml = "^0.6"' 'defusedxml = "*"' \
      --replace 'zeroconf = "^0.28"' 'zeroconf = "*"'
  '';

  nativeBuildInputs = [
    poetry
  ];

  propagatedBuildInputs = [
    click
    cryptography
    construct
    zeroconf
    attrs
    pytz
    appdirs
    tqdm
    netifaces
    android-backup
    croniter
    defusedxml
  ] ++ lib.optional (pythonOlder "3.8") importlib-metadata;

  checkInputs = [
    pytestCheckHook
    pytest-mock
    pyyaml
  ];

  pythonImportsCheck = [ "miio" ];

  meta = with lib; {
    description = "Python library for interfacing with Xiaomi smart appliances";
    homepage = "https://github.com/rytilahti/python-miio";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ flyfloh ];
  };
}

