{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "figcan";
  version = "0.0.4";
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    sha256 = "WPOMIfIUzF4m1jE5HCGf6+llAtv0OJIRFF7mmkS8Xr4=";
  };

  # Tests not part of the wheel.
  doCheck = false;

  pythonImportsChecks = [
    "figcan"
  ];

  meta = with lib; {
    homepage = "https://github.com/shoppimon/figcan";
    description = "Minimalistic Configuration Handling Library";
    maintainers = with maintainers; [ jtojnar ];
    license = licenses.asl20;
  };
}
