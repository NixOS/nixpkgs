{
  lib,
  buildPythonPackage,
  fetchPypi,

  # optional dependencies
  eventlet,
  gevent,
  pure-sasl,
}:

buildPythonPackage rec {
  pname = "kazoo";
  version = "2.10.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kFeWrk9MEr1OSukubl0BhDnmtWyM+7JIJTYuebIw2rE=";
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
}
