{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, cython
, numpy
}:

buildPythonPackage rec {
  version = "0.13";
  pname = "hdmedians";

  src = fetchPypi {
    inherit pname version;
    sha256 = "230f80e064d905c49a1941af1b7e806e2f22b3c9a90ad5c21fd17d72636ea277";
  };

  # nose was specified in setup.py as a build dependency...
  buildInputs = [ cython nose ];
  propagatedBuildInputs = [ numpy ];

  # cannot resolve path for packages in tests
  doCheck = false;

  checkPhase = ''
    nosetests
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/daleroberts/hdmedians;
    description = "High-dimensional medians";
    license = licenses.gpl3;
    maintainers = [ maintainers.costrouc ];
  };
}
