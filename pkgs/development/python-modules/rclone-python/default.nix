{
  lib,
  buildPythonPackage,
  fetchPypi,
  rich,
  rclone,
}:

buildPythonPackage rec {
  pname = "rclone-python";
  version = "0.1.20";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qkK6Hvitn6v7F1d5E4rX64Tcm81LIDoyPaj/eA/EtHQ=";
  };

  propagatedBuildInputs = [
    rclone
    rich
  ];

  # tests require working internet connection
  doCheck = false;

  pythonImportsCheck = [ "rclone_python" ];

  meta = {
    description = "Python wrapper for rclone";
    homepage = "https://github.com/Johannes11833/rclone_python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ CaptainJawZ ];
  };
}
