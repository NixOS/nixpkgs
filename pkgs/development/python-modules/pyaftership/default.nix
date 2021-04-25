{ aiohttp, async-timeout, buildPythonPackage, fetchPypi, isPy3k, lib }:

buildPythonPackage rec {
  pname = "pyaftership";
  version = "21.1.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "28b62c323d06492399b60d8135a58d6feaa1d60837eddc14e57ea2b69d356c0a";
  };

  propagatedBuildInputs = [ aiohttp async-timeout ];

  # No tests
  doCheck = false;
  pythonImportsCheck = [ "pyaftership.tracker" ];

  meta = with lib; {
    description = "Python wrapper package for the AfterShip API";
    homepage = "https://github.com/ludeeus/pyaftership";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
