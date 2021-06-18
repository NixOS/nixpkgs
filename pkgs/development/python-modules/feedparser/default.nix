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
    sha256 = "78f62a5b872fdef451502bb96e64a8fd4180535eb749954f1ad528604809cdeb";
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
