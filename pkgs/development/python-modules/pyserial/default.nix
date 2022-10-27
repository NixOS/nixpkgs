{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, unittestCheckHook
, pythonOlder
, isPy3k
}:

buildPythonPackage rec {
  pname = "pyserial";
  version = "3.5";
  format = "setuptools";

  # Supports Python 2.7 and 3.4+
  disabled = isPy3k && pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PHfgFBcN//vYFub/wgXphC77EL6fWOwW0+hnW0klzds=";
  };

  patches = [
    ./001-rfc2217-only-negotiate-on-value-change.patch
    ./002-rfc2217-timeout-setter-for-rfc2217.patch
  ];

  doCheck = !stdenv.hostPlatform.isDarwin; # broken on darwin

  checkInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "-s" "test" ];

  pythonImportsCheck = [
    "serial"
  ];

  meta = with lib; {
    description = "Python serial port extension";
    homepage = "https://github.com/pyserial/pyserial";
    license = licenses.bsd3;
    maintainers = with maintainers; [ makefu ];
  };
}
