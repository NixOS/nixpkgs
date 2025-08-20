{
  lib,
  buildPythonPackage,
  fetchPypi,
  rich,
  rclone,
}:

buildPythonPackage rec {
  pname = "rclone-python";
  version = "0.1.12";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "kqHSHF4iVXTbQ4kIpCUi7/l+Rn8L/uvSAHyDcjqDSos=";
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
