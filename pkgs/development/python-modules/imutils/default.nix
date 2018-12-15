{ stdenv
, buildPythonPackage
, fetchPypi
, opencv3
}:

buildPythonPackage rec {
  version = "0.5.1";
  pname = "imutils";

  src = fetchPypi {
    inherit pname version;
    sha256 = "37d17adc9e71386c59b28f4ef5972ef6fe0023714fa1a652b8edc83f7ce0654c";
  };

  propagatedBuildInputs = [ opencv3 ];

  # no tests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/jrosebr1/imutils;
    description = "A series of convenience functions to make basic image processing functions";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
