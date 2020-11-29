{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "feedparser";
  version = "6.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b00a105425f492f3954fd346e5b524ca9cef3a4bbf95b8809470e9857aa1074";
  };

  # lots of networking failures
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/kurtmckee/feedparser";
    description = "Universal feed parser";
    license = licenses.bsd2;
    maintainers = with maintainers; [ domenkozar ];
  };

}
