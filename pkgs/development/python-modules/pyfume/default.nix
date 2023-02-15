{ buildPythonPackage
, fetchPypi
, fst-pso
, lib
, numpy
, pandas
, scipy
, simpful
}:

buildPythonPackage rec {
  pname = "pyFUME";
  version = "0.2.25";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uD1IHFyNd9yv3eyHPZ4pg6X2+rLTY5sYsQysuIXbvfA=";
  };

  propagatedBuildInputs = [
    fst-pso
    numpy
    pandas
    scipy
    simpful
  ];

  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "pyfume" ];

  meta = with lib; {
    description = "Software to estimate fuzzy models from data using the Simpful library.";
    license = licenses.gpl3;
    homepage = "https://github.com/CaroFuchs/pyFUME";
    platforms = platforms.all;
  };
}
