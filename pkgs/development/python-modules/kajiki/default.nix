{ stdenv
, buildPythonPackage
, fetchPypi
, Babel
, pytz
, nine
, nose
}:

buildPythonPackage rec {
  pname = "Kajiki";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "85202ff7c2ce2466e9da82f06b25d1d6753d411d0e1b3ab3b145ed1e04c46782";
  };

  propagatedBuildInputs = [ Babel pytz nine ];
  checkInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "Kajiki provides fast well-formed XML templates";
    homepage = "https://github.com/nandoflorestan/kajiki";
    license = licenses.mit;
  };

}
