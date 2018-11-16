{ stdenv
, buildPythonPackage
, fetchPypi
, coverage
, nose
}:

buildPythonPackage rec {
  pname = "nosexcover";
  version = "1.0.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f5b3a7c936c4f703f15418c1f325775098184b69fa572f868edb8a99f8f144a8";
  };

  propagatedBuildInputs = [ coverage nose ];

  meta = with stdenv.lib; {
    description = "Extends nose.plugins.cover to add Cobertura-style XML reports";
    homepage = https://github.com/cmheisel/nose-xcover/;
    license = licenses.bsd3;
  };

}
