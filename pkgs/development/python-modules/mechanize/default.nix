{ stdenv
, buildPythonPackage
, fetchPypi
, html5lib
}:

buildPythonPackage rec {
  pname = "mechanize";
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gyxkwjnabqf8xxnkj787xh2dpcnm858g369fnahdcz1wn5hdmyp";
  };

  propagatedBuildInputs = [ html5lib ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Stateful programmatic web browsing in Python";
    homepage = "https://github.com/python-mechanize/mechanize";
    license = "BSD-style";
  };

}
