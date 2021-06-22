{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, sgmllib3k
}:

buildPythonPackage rec {
  pname = "feedparser";
  version = "6.0.6";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1syd15460a6m397rajdpbr9q0hgxm1j6xf9ba18z9pighxdjmxkq";
  };

  propagatedBuildInputs = [ sgmllib3k ];

  checkPhase = ''
    python -Wd tests/runtests.py
  '';

  meta = with lib; {
    homepage = "https://github.com/kurtmckee/feedparser";
    description = "Universal feed parser";
    license = licenses.bsd2;
    maintainers = with maintainers; [ domenkozar ];
  };

}
