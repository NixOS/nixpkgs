{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, sgmllib3k
}:

buildPythonPackage rec {
  pname = "feedparser";
  version = "6.0.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0k77c66ia4m64kmdfa2yv8z8887hhwx91pv8b4s2ix23mbf8xa3c";
  };

  propagatedBuildInputs = [ sgmllib3k ];

  # lots of networking failures
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/kurtmckee/feedparser";
    description = "Universal feed parser";
    license = licenses.bsd2;
    maintainers = with maintainers; [ domenkozar ];
  };

}
