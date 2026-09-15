{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "mutesync";
  version = "0.0.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "mutesync";
    inherit (finalAttrs) version;
    sha256 = "1lz3q3q9lw8qxxb8jyrak77v6hkxwi39akyx96j8hd5jjaq2k5qc";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    async-timeout
  ];

  # Project has not published tests yet
  doCheck = false;

  pythonImportsCheck = [ "mutesync" ];

  meta = {
    description = "Python module for interacting with mutesync buttons";
    homepage = "https://github.com/currentoor/pymutesync";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
