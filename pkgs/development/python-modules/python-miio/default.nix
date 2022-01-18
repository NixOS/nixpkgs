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
  version = "0.5.9.2";
  disabled = pythonOlder "3.6.5";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AFwarRhFknfwTSvSDGoWE+/mv1KUD2XnWK/xCBqrN4o=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'defusedxml = "^0"' 'defusedxml = "*"' \
  '';

  nativeBuildInputs = [
    poetry
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
  ] ++ lib.optional (pythonOlder "3.8") importlib-metadata;

  checkInputs = [
    pytestCheckHook
    pytest-mock
  ];

  pythonImportsCheck = [ "miio" ];

  meta = with lib; {
    description = "Python library for interfacing with Xiaomi smart appliances";
    homepage = "https://github.com/rytilahti/python-miio";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ flyfloh ];
  };
}
