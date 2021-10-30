{ lib
, adslib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyads";
  version = "3.3.8";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "stlehmann";
    repo = pname;
    rev = version;
    sha256 = "sha256-jhEVBndUOKM8rBX0LEqPTMLqbpizCiD7T+OCzbVgLM8=";
  };

  buildInputs = [
    adslib
  ];

  patchPhase = ''
    substituteInPlace pyads/pyads_ex.py \
      --replace "ctypes.CDLL(adslib)" "ctypes.CDLL(\"${adslib}/lib/adslib.so\")"
  '';

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyads" ];

  meta = with lib; {
    description = "Python wrapper for TwinCAT ADS library";
    homepage = "https://github.com/MrLeeh/pyads";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
