{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  eventlet,
  gevent,
  mock,
  coverage,
  openjdk8_headless,
}:

buildPythonPackage rec {
  pname = "kazoo";
  version = "2.10.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kFeWrk9MEr1OSukubl0BhDnmtWyM+7JIJTYuebIw2rE=";
  };

  propagatedBuildInputs = [ six ];
  buildInputs = [
    eventlet
    gevent
    mock
    coverage
    openjdk8_headless
  ];

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
    maintainers = [ ];
  };
}
