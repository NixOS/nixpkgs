{ stdenv
, buildPythonPackage
, fetchPypi
, html5lib
, isPy3k
}:

buildPythonPackage rec {
  pname = "mechanize";
  version = "0.4.3";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gyxkwjnabqf8xxnkj787xh2dpcnm858g369fnahdcz1wn5hdmyp";
  };

  propagatedBuildInputs = [ html5lib ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Stateful programmatic web browsing in Python";
    homepage = http://wwwsearch.sourceforge.net/;
    license = "BSD-style";
  };

}
