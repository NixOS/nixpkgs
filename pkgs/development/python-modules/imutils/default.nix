{ stdenv
, buildPythonPackage
, fetchPypi
, opencv3
}:

buildPythonPackage rec {
  version = "0.5.3";
  pname = "imutils";

  src = fetchPypi {
    inherit pname version;
    sha256 = "857af6169d90e4a0a814130b9b107f5d611150ce440107e1c1233521c6fb1e2b";
  };

  propagatedBuildInputs = [ opencv3 ];

  # no tests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/jrosebr1/imutils";
    description = "A series of convenience functions to make basic image processing functions";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
