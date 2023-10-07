{ lib, buildPythonPackage, fetchPypi, sphinx }:

buildPythonPackage rec {
  pname = "piccolo-theme";
  version = "0.18.0";

  src = fetchPypi {
    pname = "piccolo_theme";
    inherit version;
    hash = "sha256-tEgYrQaVcWZadmhV6JRuXnk8m9oJLNSfb0hA309bX1U=";
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
