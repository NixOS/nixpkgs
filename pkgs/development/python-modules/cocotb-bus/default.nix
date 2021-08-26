{ lib
, stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "cocotb-bus";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cc9b0bb00c95061a67f650caf96e3a294bb74ef437124dea456dd9e2a9431854";
  };

  postPatch = ''
    # remove circular dependency cocotb from setup.py
    substituteInPlace setup.py --replace '"cocotb>=1.5.0.dev,<2.0"' ""
  '';

  # tests require cocotb, disable for now to avoid circular dependency
  doCheck = false;

  # checkPhase = ''
  #   export PATH=$out/bin:$PATH
  #   make test
  # '';

  meta = with lib; {
    description = "Pre-packaged testbenching tools and reusable bus interfaces for cocotb";
    homepage = "https://github.com/cocotb/cocotb-bus";
    license = licenses.bsd3;
    maintainers = with maintainers; [ prusnak ];
  };
}
