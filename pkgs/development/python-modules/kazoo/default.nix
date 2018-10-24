{ stdenv
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
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10pb864if9qi2pq9lfb9m8f7z7ss6rml80gf1d9h64lap5crjnjj";
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

  meta = with stdenv.lib; {
    homepage = "https://kazoo.readthedocs.org";
    description = "Higher Level Zookeeper Client";
    license = licenses.asl20;
  };

}
