{ lib
, fetchPypi
, buildPythonPackage
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-rng";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nZ7pZVckZ1YHITP/m5kFiPKPEtPoA1fK2VnvCwWu2fo=";
  };

  builtInputs = [ pytest ];

  nativeBuiltInputs = [ pytest ];

  propagatedBuiltInputs = [ pytest ];

  meta = with lib; {
    description = "Fixtures for seeding tests and making randomness reproducible";
    homepage = "https://www.nengo.ai/pytest-rng";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
