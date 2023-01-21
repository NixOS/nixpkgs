{ lib
, adslib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyads";
  version = "3.3.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "stlehmann";
    repo = pname;
    rev = version;
    sha256 = "sha256-eNouFJQDgp56fgkA7wZKfosKWOKU6OvXRjFwjCMvZqI=";
  };

  buildInputs = [
    adslib
  ];

  patchPhase = ''
    substituteInPlace pyads/pyads_ex.py \
      --replace "ctypes.CDLL(adslib)" "ctypes.CDLL(\"${adslib}/lib/adslib.so\")"
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyads"
  ];

  meta = with lib; {
    description = "Python wrapper for TwinCAT ADS library";
    homepage = "https://github.com/MrLeeh/pyads";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
