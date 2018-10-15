{ stdenv
, buildPythonPackage
, fetchPypi
, html5lib
, isPy3k
}:

buildPythonPackage rec {
  pname = "mechanize";
  version = "0.3.5";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rki9nl4y42q694parafcsdcdqvkdjckrbg6n0691302lfsrkyfl";
  };

  propagatedBuildInputs = [ html5lib ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Stateful programmatic web browsing in Python";
    homepage = http://wwwsearch.sourceforge.net/;
    license = "BSD-style";
  };

}
