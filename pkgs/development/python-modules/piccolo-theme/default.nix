{ lib, buildPythonPackage, fetchPypi, sphinx }:

buildPythonPackage rec {
  pname = "piccolo-theme";
  version = "0.14.0";

  src = fetchPypi {
    pname = "piccolo_theme";
    inherit version;
    sha256 = "sha256-PGPf05TQfC6Somn2PR07Y2qiOuyg+37U1l16m2LKykU=";
  };

  propagatedBuildInputs = [
    sphinx
  ];

  pythonImportsCheck = [ "piccolo_theme" ];

  meta = with lib; {
    description = "Clean and modern Sphinx theme";
    homepage = "https://piccolo-theme.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [ loicreynier ];
    platforms = platforms.unix;
  };
}
