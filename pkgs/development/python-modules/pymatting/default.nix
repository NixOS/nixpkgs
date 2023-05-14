{ buildPythonPackage
, fetchPypi
, lib
, numpy
, pillow
, numba
, scipy
}:

buildPythonPackage rec {
  pname = "PyMatting";

  version = "1.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pzUI7wh0mWgx39KE47xjFRoJSE14n9EO3AP0mzFTKsw=";
  };

  propagatedBuildInputs = [
    numba
    numpy
    pillow
    scipy
  ];

  doCheck = false;

  meta = with lib; {
    description = "PyMatting: A Python Library for Alpha Matting";
    platforms = platforms.all;
    homepage = "https://github.com/pymatting/pymatting";
    downloadPage = "https://github.com/pymatting/pymatting/releases";
    license = licenses.mit;
    maintainers = [ maintainers.jayrovacsek ];
  };

}
