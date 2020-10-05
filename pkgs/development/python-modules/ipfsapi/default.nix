{ stdenv
, buildPythonPackage
, fetchFromGitHub
, isPy27
, six
, requests
}:

buildPythonPackage {
  pname = "ipfsapi";
  version = "0.6.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "ipfs";
    repo = "py-ipfs-api";
    rev = version;
    sha256 = "0asxl1wjp1g91an3s44rvma1xq2yxcdn94ridpjaazl6mghli9y2";
  };

  propagatedBuildInputs = [ six requests ];

  meta = with stdenv.lib; {
    description = "A python client library for the IPFS API";
    license = licenses.mit;
    maintainers = with maintainers; [ mguentner ];
    homepage = "https://pypi.python.org/pypi/ipfsapi";
  };

}
