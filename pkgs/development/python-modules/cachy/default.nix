{ lib, buildPythonPackage, fetchPypi
, redis
, memcached
, msgpack-python
}:

buildPythonPackage rec {
  pname = "cachy";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0v6mjyhgx6j7ya20bk69cr3gdzdkdf6psay0h090rscclgji65dp";
  };

  propagatedBuildInputs = [
    redis
    memcached
    msgpack-python
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
