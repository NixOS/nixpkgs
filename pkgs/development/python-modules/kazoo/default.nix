{ lib
, buildPythonPackage
, fetchPypi
, six
, eventlet
, gevent
, nose
, mock
, coverage
, pkgs
}:

buildPythonPackage rec {
  pname = "kazoo";
  version = "2.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gAMYx/PatkjN9hbfslvavu+rKmg3qmlR4Po/+A5laWk=";
  };

  propagatedBuildInputs = [ six ];
  buildInputs = [ eventlet gevent nose mock coverage pkgs.openjdk8 ];

  # not really needed
  preBuild = ''
    sed -i '/flake8/d' setup.py
  '';

  preCheck = ''
    sed -i 's/test_unicode_auth/noop/' kazoo/tests/test_client.py
  '';

  # tests take a long time to run and leave threads hanging
  doCheck = false;
  #ZOOKEEPER_PATH = "${pkgs.zookeeper}";

  meta = with lib; {
    homepage = "https://kazoo.readthedocs.org";
    description = "Higher Level Zookeeper Client";
    license = licenses.asl20;
  };

}
