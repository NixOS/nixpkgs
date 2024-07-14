{
  lib,
  buildPythonPackage,
  fetchPypi,
  redis,
  python-memcached,
  msgpack,
}:

buildPythonPackage rec {
  pname = "cachy";
  version = "0.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GGWB9M60Kgu+BAxAfac8FAkjebHkwOMn/bcq5KmyabE=";
  };

  propagatedBuildInputs = [
    redis
    python-memcached
    msgpack
  ];

  # The Pypi tarball doesn't include tests, and the GitHub source isn't
  # buildable until we bootstrap poetry, see
  # https://github.com/NixOS/nixpkgs/pull/53599#discussion_r245855665
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/sdispater/cachy";
    description = "Cachy provides a simple yet effective caching library";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
