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
    sha256 = "1lz3q3q9lw8qxxb8jyrak77v6hkxwi39akyx96j8hd5jjaq2k5qc";
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
