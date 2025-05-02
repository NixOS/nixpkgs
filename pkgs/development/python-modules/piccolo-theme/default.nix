{ lib, buildPythonPackage, fetchPypi, sphinx }:

buildPythonPackage rec {
  pname = "piccolo-theme";
  version = "0.21.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "piccolo_theme";
    inherit version;
    hash = "sha256-mQqZ6Rwx0VoDBVQ0zbvCOmAMKAMv67Xd1ksYW6w2QPM=";
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
