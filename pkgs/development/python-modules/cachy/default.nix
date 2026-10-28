{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  redis,
  python-memcached,
  msgpack,
}:

buildPythonPackage (finalAttrs: {
  pname = "cachy";
  version = "0.3.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-GGWB9M60Kgu+BAxAfac8FAkjebHkwOMn/bcq5KmyabE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    redis
    python-memcached
    msgpack
  ];

  # The Pypi tarball doesn't include tests, and the GitHub source isn't
  # buildable until we bootstrap poetry, see
  # https://github.com/NixOS/nixpkgs/pull/53599#discussion_r245855665
  doCheck = false;

  pythonImportsCheck = [ "cachy" ];

  meta = {
    homepage = "https://github.com/sdispater/cachy";
    description = "Cachy provides a simple yet effective caching library";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jakewaksbaum ];
  };
})
