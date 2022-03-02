{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "EasyProcess";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-iFiYMCpXqrlIlz6LXTKkIpOSufstmGqx1P/VkOW6kOw=";
  };

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Easy to use python subprocess interface";
    homepage = "https://github.com/ponty/EasyProcess";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ layus ];
  };
}
