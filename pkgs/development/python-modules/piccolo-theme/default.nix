{ lib, buildPythonPackage, fetchPypi, sphinx }:

buildPythonPackage rec {
  pname = "piccolo-theme";
  version = "0.12.0";

  src = fetchPypi {
    pname = "piccolo_theme";
    inherit version;
    sha256 = "sha256-o6uaqAo/Nb28doByq40XakKJpA4o6/Z/PzMhmb058FE=";
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
