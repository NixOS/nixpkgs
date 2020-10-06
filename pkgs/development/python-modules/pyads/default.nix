{ adslib, buildPythonPackage, fetchFromGitHub, lib, pytestCheckHook, pytest
, pytestcov, pythonOlder }:

buildPythonPackage rec {
  pname = "pyads";
  version = "3.2.2";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "stlehmann";
    repo = pname;
    rev = version;
    sha256 = "1jd727pw0z73y4xhrykqkfcz1acrpy3rks58lr1y4yilfv11p6jb";
  };

  buildInputs = [ adslib ];
  patchPhase = ''
    substituteInPlace pyads/pyads_ex.py \
      --replace "ctypes.CDLL(adslib)" "ctypes.CDLL(\"${adslib}/lib/adslib.so\")"
  '';
  checkInputs = [ pytestCheckHook pytest pytestcov ];

  meta = with lib; {
    description = "Python wrapper for TwinCAT ADS library";
    homepage = "https://github.com/MrLeeh/pyads";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
