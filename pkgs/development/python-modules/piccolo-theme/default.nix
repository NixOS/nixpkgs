{ lib, buildPythonPackage, fetchPypi, sphinx }:

buildPythonPackage rec {
  pname = "piccolo-theme";
  version = "0.16.1";

  src = fetchPypi {
    pname = "piccolo_theme";
    inherit version;
    hash = "sha256-4VOJ7l6tBhMBZ2x+T5Bl5WdnMg4JEBkwaGDA/9XUmc8=";
  };

  propagatedBuildInputs = [
    sphinx
  ];

  pythonImportsCheck = [ "piccolo_theme" ];

  meta = with lib; {
    description = "Clean and modern Sphinx theme";
    homepage = "https://piccolo-theme.readthedocs.io";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ loicreynier ];
    platforms = platforms.unix;
  };
}
