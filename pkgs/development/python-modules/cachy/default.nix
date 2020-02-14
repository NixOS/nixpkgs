{ lib, buildPythonPackage, fetchPypi
, redis
, memcached
, msgpack
}:

buildPythonPackage rec {
  pname = "cachy";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "186581f4ceb42a0bbe040c407da73c14092379b1e4c0e327fdb72ae4a9b269b1";
  };

  propagatedBuildInputs = [
    redis
    memcached
    msgpack
  ];

  # The Pypi tarball doesn't include tests, and the GitHub source isn't
  # buildable until we bootstrap poetry, see
  # https://github.com/NixOS/nixpkgs/pull/53599#discussion_r245855665
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/sdispater/cachy;
    description = "Cachy provides a simple yet effective caching library";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
