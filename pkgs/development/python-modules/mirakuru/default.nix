{ lib, buildPythonPackage, fetchFromGitHub, netcat, ps, psutil, pytest, pytestcov, python-daemon }:

buildPythonPackage rec {
  pname = "mirakuru";
  version = "2.1.2";
  
  src = fetchFromGitHub {
    owner = "ClearcodeHQ";
    repo = pname;
    rev = "v" + version;
    sha256 = "0nhf3i1yav3nwddcv4pdrj8f7mm5hzfi2ps1d7vrimxr9knkny2c";
  };
  
  propagatedBuildInputs = [ psutil ];
  
  checkInputs = [ netcat ps pytest pytestcov python-daemon ];
  
  checkPhase = ''
    pytest tests
  '';
  
  meta = with lib; {
    description = "Process orchestration tool designed for functional and integration tests";
    homepage = "https://github.com/ClearcodeHQ/mirakuru";
    license = licenses.lgpl3;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
