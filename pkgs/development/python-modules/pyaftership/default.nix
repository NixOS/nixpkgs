{ aiohttp, async-timeout, buildPythonPackage, fetchPypi, isPy3k, lib }:

buildPythonPackage rec {
  pname = "pyaftership";
  version = "0.1.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "057dwzacc0lmsq00ipfbnxkq4rc2by8glmza6s8i6dzi1cc68v98";
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
