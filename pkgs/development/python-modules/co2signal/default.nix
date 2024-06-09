{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "co2signal";
  version = "0.4.2";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "CO2Signal";
    hash = "sha256-8YdYbknLICRrZloGUZuscv5e1LIDZBcCPKZs6EMaNuo=";
  };

  propagatedBuildInputs = [ requests ];
  # Modules has no tests
  doCheck = false;

  pythonImportsCheck = [ "CO2Signal" ];

  meta = with lib; {
    description = "A package to access the CO2 Signal API ";
    homepage = "https://github.com/danielsjf/CO2Signal";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ plabadens ];
  };
}
