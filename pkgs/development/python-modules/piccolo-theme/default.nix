{ lib, buildPythonPackage, fetchPypi, sphinx }:

buildPythonPackage rec {
  pname = "piccolo-theme";
  version = "0.15.0";

  src = fetchPypi {
    pname = "piccolo_theme";
    inherit version;
    hash = "sha256-8VxkrzADp3yCeb02BxtT6oSP1FCX8GW4oc6OECK2hJw=";
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
