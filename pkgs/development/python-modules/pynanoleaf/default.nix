{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  requests,
}:

buildPythonPackage rec {
  pname = "pynanoleaf";
  version = "0.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MqCDdZxPmeAZ4AE2cEh4Qfjt+AfHoHdCqXH6GHBwcqc=";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ requests ];

  # pynanoleaf does not contain tests
  doCheck = false;

  pythonImportsCheck = [ "pynanoleaf" ];

  meta = with lib; {
    homepage = "https://github.com/Oro/pynanoleaf";
    description = "Python3 wrapper for the Nanoleaf API, capable of controlling both Nanoleaf Aurora and Nanoleaf Canvas";
    license = licenses.mit;
    maintainers = with maintainers; [ oro ];
  };
}
