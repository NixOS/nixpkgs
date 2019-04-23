{ stdenv
, buildPythonPackage
, fetchPypi
, html5lib
, isPy3k
}:

buildPythonPackage rec {
  pname = "mechanize";
  version = "0.4.1";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fl6zb36cqsdiay1mn3nmjv5jw4jys5av7hb1y9995qlycg0hm49";
  };

  propagatedBuildInputs = [ html5lib ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Stateful programmatic web browsing in Python";
    homepage = http://wwwsearch.sourceforge.net/;
    license = "BSD-style";
  };

}
