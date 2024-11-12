{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "multitasking";
  version = "0.0.11";
  format = "setuptools";

  # GitHub source releases aren't tagged
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TWvDzGX5stynL7Wnh4UKiNro9iDCs2rptVJI5RvNYCY=";
  };

  doCheck = false; # No tests included
  pythonImportsCheck = [ "multitasking" ];

  meta = with lib; {
    description = "Non-blocking Python methods using decorators";
    homepage = "https://github.com/ranaroussi/multitasking";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
