{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
}:

buildPythonPackage rec {
  pname = "pyngrok";
  version = "5.2.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MfpuafEUhFNtEegvihCLmsnHYFBu8kKghfPRp3oqlb8=";
  };

  propagatedBuildInputs = [
    pyyaml
  ];

  pythonImportsCheck = [ "pyngrok" ];

  meta = with lib; {
    homepage = "https://github.com/alexdlaird/pyngrok";
    description = "A Python wrapper for ngrok";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
  };
}
