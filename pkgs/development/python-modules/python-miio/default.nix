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
, fetchpatch
, importlib-metadata
, micloud
, netifaces
, poetry-core
, pytest-asyncio
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

  patches = [
    (fetchpatch {
      # Fix pytest 7.2 compat
      url = "https://github.com/rytilahti/python-miio/commit/67d9d771d04d51f5bd97f361ca1c15ae4a18c274.patch";
      hash = "sha256-Os9vCSKyieCqHs63oX6gcLrtv1N7hbX5WvEurelEp8w=";
    })
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
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

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
