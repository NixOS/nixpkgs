{ stdenv
, buildPythonPackage
, fetchPypi
, opencv3
}:

buildPythonPackage rec {
  version = "0.5.2";
  pname = "imutils";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d2bdf373e3e6cfbdc113d4e91547d3add3774d8722c8d4f225fa39586fb8076";
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
