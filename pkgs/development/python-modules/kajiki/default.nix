{ stdenv
, buildPythonPackage
, fetchPypi
, Babel
, pytz
, nine
}:

buildPythonPackage rec {
  pname = "Kajiki";
  version = "0.5.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "effcae388e25c3358eb0bbd733448509d11a1ec500e46c69241fc673021f0517";
  };

  propagatedBuildInputs = [ Babel pytz nine ];

  meta = with stdenv.lib; {
    description = "Kajiki provides fast well-formed XML templates";
    homepage = "https://github.com/nandoflorestan/kajiki";
    license = licenses.mit;
  };

}
