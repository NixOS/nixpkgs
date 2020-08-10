{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "multitasking";
  version = "0.0.9";

  # GitHub source releases aren't tagged
  src = fetchPypi {
    inherit pname version;
    sha256 = "b59d99f709d2e17d60ccaa2be09771b6e9ed9391c63f083c0701e724f624d2e0";
  };

  doCheck = false;  # No tests included
  pythonImportsCheck = [ "multitasking" ];

  meta = with lib; {
    description = "Non-blocking Python methods using decorators";
    homepage = "https://github.com/ranaroussi/multitasking";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
