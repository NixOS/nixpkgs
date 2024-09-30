{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  prometheus-client,
  pyserial,
  pythonOlder,
  pyyaml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "finitude";
  version = "0.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dulitz";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yCI5UCRDhw+dJoTKyjmHbAGBm3by2AyxHKlqCywnLcs=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    pyserial
    prometheus-client
    pyyaml
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "finitude" ];

  meta = with lib; {
    description = "Python module to get data from ABCD bus (RS-485) used by Carrier Infinity and Bryant Evolution HVAC systems";
    homepage = "https://github.com/dulitz/finitude";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
