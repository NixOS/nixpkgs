{ aiohttp, buildPythonPackage, fetchPypi, lib, pythonOlder }:

buildPythonPackage rec {
  pname = "advantage_air";
  version = "0.2.5";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256-38csg1Cvpz4dkRCwlNc8+af7aJ5xDrZO1D8cCaBlePA=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # No tests
  doCheck = false;
  pythonImportsCheck = [ "advantage_air" ];

  meta = with lib; {
    description = "API helper for Advantage Air's MyAir and e-zone API";
    homepage = "https://github.com/Bre77/advantage_air";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
