{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libmilter,
  berkeleydb,
  pydns,
  iana-etc,
  libredirect,
  pyasyncore,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pymilter";
  version = "1.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sdgathman";
    repo = "pymilter";
    rev = "refs/tags/pymilter-${version}";
    hash = "sha256-plaWXwDAIsVzEtrabZuZj7T4WNfz2ntQHgcMCVf5S70=";
  };

  build-system = [
    setuptools
  ];
  buildInputs = [ libmilter ];
  nativeCheckInputs = [ pyasyncore ];
  dependencies = [
    berkeleydb
    pydns
  ];

  preBuild = ''
    sed -i 's/import thread/import _thread as thread/' Milter/greylist.py
  '';

  # requires /etc/resolv.conf
  # testpolicy: requires makemap (#100419)
  #   using exec -a makemap smtpctl results in "unknown group smtpq"
  preCheck = ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf)
    export LD_PRELOAD=${libredirect}/lib/libredirect.so
    sed -i '/testpolicy/d' test.py
    rm testpolicy.py
  '';

  pythonImportsCheck = [ "Milter" ];

  meta = with lib; {
    homepage = "http://bmsi.com/python/milter.html";
    description = "Python bindings for libmilter api";
    maintainers = with maintainers; [ yorickvp ];
    license = licenses.gpl2;
  };
}
