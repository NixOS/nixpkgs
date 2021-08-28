{ aiohttp, buildPythonPackage, fetchPypi, lib, pythonOlder }:

buildPythonPackage rec {
  pname = "advantage_air";
  version = "0.2.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version pname;
    sha256 = "04q2sjw9r50c00m4sfv98w9cwmmr970830c97m32p5j8ijb10j5x";
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
