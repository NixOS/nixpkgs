{ lib
, stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "cocotb-bus";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3afe3abe73464269247263e44f39d59c1258f227298be4118377a8e8c09d7dc1";
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
