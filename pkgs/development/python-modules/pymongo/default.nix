{
  buildPythonPackage,
  fetchPypi,
  lib,

  # build system
  hatchling,
  hatch-requirements-txt,
  setuptools,

  # dependencies
  dnspython,

  # optional dependencies
  cryptography,
  pykerberos,
  pymongo-auth-aws,
  pyopenssl,
  python-snappy,
  requests,
  service-identity,
  zstandard,

  # for passthru.tests
  celery, # check-input only
  flask-pymongo,
  kombu, # check-input only
  mongoengine,
  motor,
  pymongo-inmemory,
}:

buildPythonPackage rec {
  pname = "pymongo";
  version = "4.13.2";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "pymongo";
    hash = "sha256-D2TGRpwjYpYubOlyWK4Tkau6FWapU6SSVi0pJLRIFcI=";
  };

  build-system = [
    hatchling
    hatch-requirements-txt
    setuptools
  ];

  dependencies = [ dnspython ];

  optional-dependencies = {
    aws = [ pymongo-auth-aws ];
    gssapi = [ pykerberos ];
    ocsp = [
      cryptography
      pyopenssl
      requests
      service-identity
    ];
    snappy = [ python-snappy ];
    zstd = [ zstandard ];
  };

  # Tests call a running mongodb instance
  doCheck = false;

  pythonImportsCheck = [ "pymongo" ];

  passthru.tests = {
    inherit
      celery
      flask-pymongo
      kombu
      mongoengine
      motor
      pymongo-inmemory
      ;
  };

  meta = {
    description = "Python driver for MongoDB";
    homepage = "https://github.com/mongodb/mongo-python-driver";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
