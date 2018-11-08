{ stdenv
, buildPythonPackage
, fetchPypi
, html5lib
, isPy3k
}:

buildPythonPackage rec {
  pname = "mechanize";
  version = "0.3.7";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1licf3wiy21pncg8hkx58r7xj4ylrqa8jcfh9n4rh23rmykf2rpf";
  };

  propagatedBuildInputs = [ html5lib ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Stateful programmatic web browsing in Python";
    homepage = http://wwwsearch.sourceforge.net/;
    license = "BSD-style";
  };

}
