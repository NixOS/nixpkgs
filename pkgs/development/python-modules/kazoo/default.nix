{
  lib,
  buildPythonPackage,
  fetchPypi,

  # optional dependencies
  eventlet,
  gevent,
  pure-sasl,
}:

buildPythonPackage (finalAttrs: {
  pname = "kazoo";
  version = "2.11.0";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-V+fm9pKVyPkiURSI7reWgHKeFLuOs4LVytg6oRNFw2w=";
  };

  optional-dependencies = {
    eventlet = [ eventlet ];
    gevent = [ gevent ];
    sasl = [ pure-sasl ];
  };

  pythonImportsCheck = [
    "kazoo"
    "kazoo.client"
  ];

  # tests take a long time to run and leave threads hanging
  doCheck = false;

  meta = {
    homepage = "https://kazoo.readthedocs.org";
    description = "Higher Level Zookeeper Client";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
