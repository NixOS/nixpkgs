{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libmilter,
  berkeleydb,
  py3dns,
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
    tag = "pymilter-${version}";
    hash = "sha256-plaWXwDAIsVzEtrabZuZj7T4WNfz2ntQHgcMCVf5S70=";
  };

  build-system = [
    setuptools
  ];

  buildInputs = [ libmilter ];

  nativeCheckInputs = [
    pyasyncore
  ];

  dependencies = [
    berkeleydb
    py3dns
  ];

  preBuild = ''
    substituteInPlace Milter/greylist.py \
      --replace-fail "import thread" "import _thread as thread"
  '';

  # testpolicy: requires makemap (#100419)
  #   using exec -a makemap smtpctl results in "unknown group smtpq"
  preCheck = ''
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
