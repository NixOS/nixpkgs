{ stdenv
, buildPythonPackage
, fetchFromGitHub
, isPy27
, six
, requests
}:

buildPythonPackage {
  pname = "ipfsapi";
  version = "0.4.2.post1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "py-ipfs-api";
    rev = "0c485544a114f580c65e2ffbb5782efbf7fd9f61";
    sha256 = "1v7f77cv95yv0v80gisdh71mj7jcq41xcfip6bqm57zfdbsa0xpn";
  };

  propagatedBuildInputs = [ six requests ];

  meta = with stdenv.lib; {
    description = "A python client library for the IPFS API";
    license = licenses.mit;
    maintainers = with maintainers; [ mguentner ];
    homepage = "https://pypi.python.org/pypi/ipfsapi";
  };

}
