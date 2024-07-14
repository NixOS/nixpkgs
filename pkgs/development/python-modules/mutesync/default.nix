{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "mutesync";
  version = "0.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DJcpsJKyNIikSd1PlUbkfUKzz5kqe4lW7xhxmvDA49M=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Project has not published tests yet
  doCheck = false;

  pythonImportsCheck = [ "mutesync" ];

  meta = with lib; {
    description = "Python module for interacting with mutesync buttons";
    homepage = "https://github.com/currentoor/pymutesync";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
