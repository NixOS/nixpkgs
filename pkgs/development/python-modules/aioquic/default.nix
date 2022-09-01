{ lib
, fetchPypi
, buildPythonPackage
, openssl
, pylsqpack
, certifi
, pytestCheckHook
, pyopenssl
}:

buildPythonPackage rec {
  pname = "aioquic";
  version = "0.9.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7ENqqs6Ze4RrAeUgDtv34+VrkYJqFE77l0j9jd0zK74=";
  };

  propagatedBuildInputs = [
    certifi
    pylsqpack
    pyopenssl
  ];

  buildInputs = [ openssl ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "aioquic" ];

  meta = with lib; {
    description = "Implementation of QUIC and HTTP/3";
    homepage = "https://github.com/aiortc/aioquic";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
