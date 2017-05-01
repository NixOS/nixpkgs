{ stdenv, buildPythonPackage, fetchPypi,
  dogpile_core, pytest
 }:

buildPythonPackage rec {
  pname = "dogpile.cache";
  version = "0.6.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "73793471af07af6dc5b3ee015abfaca4220caaa34c615537f5ab007ed150726d";
  };

  propagatedBuildInputs = [ dogpile_core ];
  buildInputs = [ pytest ];

  meta = with stdenv.lib; {
    description = "A caching front-end based on the Dogpile lock";
    homepage = http://bitbucket.org/zzzeek/dogpile.cache;
    platforms = platforms.linux; # Can only test linux
    license = licenses.bsd3;
  };
}
