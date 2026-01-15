{
  lib,
  async-timeout,
  buildPythonPackage,
  colorlog,
  fetchPypi,
  pyserial,
}:

buildPythonPackage rec {
  pname = "pyenvisalink";
  version = "4.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IgYOlH0mYqhRLTO3McBAstChqYWHQkwuOVPL8gKdcTo=";
  };

  propagatedBuildInputs = [
    async-timeout
    colorlog
    pyserial
  ];

  # Tests require an Envisalink device
  doCheck = false;

  pythonImportsCheck = [ "pyenvisalink" ];

  meta = {
    description = "Python interface for Envisalink 2DS/3 Alarm API";
    homepage = "https://github.com/Cinntax/pyenvisalink";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
