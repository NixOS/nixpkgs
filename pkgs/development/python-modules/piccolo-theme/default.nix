{ lib, buildPythonPackage, fetchPypi, sphinx }:

buildPythonPackage rec {
  pname = "piccolo-theme";
  version = "0.19.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "piccolo_theme";
    inherit version;
    hash = "sha256-pGMOc/GSh3q2HW1mfW+XFgpOyiXd3cdh56cvXatseuc=";
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
