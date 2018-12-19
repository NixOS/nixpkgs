{ stdenv
, buildPythonPackage
, fetchPypi
, pytestrunner
, pytest
, psutil
, pkgconfig
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "lz4";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ec265f7c3fc3df706e9579bde632ceeef9278858d7ae87c376a2954d11e9ea39";
  };

  buildInputs = [ setuptools_scm pytestrunner pkgconfig ];
  checkInputs = [ pytest psutil ];

  meta = with stdenv.lib; {
    description = "Compression library";
    homepage = https://github.com/python-lz4/python-lz4;
    license = licenses.bsd3;
  };

}
