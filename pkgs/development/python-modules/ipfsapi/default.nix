{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, six
, requests
}:

buildPythonPackage rec {
  pname = "ipfsapi";
  version = "0.7.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "py-ipfs-api";
    rev = version;
    sha256 = "02yx7x9pdnfcav4vqd6ygqcisd3483b0zbx2j4brb4gxixk2hlyj";
  };

  propagatedBuildInputs = [ six requests ];

  meta = with lib; {
    description = "A python client library for the IPFS API";
    license = licenses.mit;
    maintainers = with maintainers; [ mguentner ];
    homepage = "https://pypi.python.org/pypi/ipfsapi";
  };

}
