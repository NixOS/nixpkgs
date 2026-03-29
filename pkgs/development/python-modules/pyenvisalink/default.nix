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
  version = "4.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WtBopLUCArWM4JwA517bnYidfOwqU3v7ApZCbsMuY/o=";
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
