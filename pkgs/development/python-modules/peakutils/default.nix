{ lib, buildPythonPackage, fetchPypi
, numpy
, scipy
, pandas
}:

buildPythonPackage rec {
  pname = "peakutils";
  version = "1.3.2";

  src = fetchPypi {
    pname = "PeakUtils";
    inherit version;
    sha256 = "2cf1f609132f0219e2fc9c7e221b62d1c82c9a502ec9a4c1195823423275c954";
  };

    propagatedBuildInputs = [
      numpy
      scipy
      pandas
    ];

  # https://bitbucket.org/lucashnegri/peakutils/issues/36/exp-not-found
  doCheck = false;

  meta = with lib; {
    description = "Peak detection utilities for 1D data";
    homepage = https://bitbucket.org/lucashnegri/peakutils;
    license = licenses.mit;
    maintainers = [ maintainers.tbenst ];
  };
}