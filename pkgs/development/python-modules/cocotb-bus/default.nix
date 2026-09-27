{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "cocotb-bus";
  version = "0.3.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "cocotb_bus";
    inherit version;
    sha256 = "sha256-l2KyknP/Bi9SFg5XJ048sQbRTn53ZRXeE3LB1zVGsAU=";
  };

  # tests require cocotb, disable for now to avoid circular dependency
  doCheck = false;

  # checkPhase = ''
  #   export PATH=$out/bin:$PATH
  #   make test
  # '';

  meta = {
    description = "Pre-packaged testbenching tools and reusable bus interfaces for cocotb";
    homepage = "https://github.com/cocotb/cocotb-bus";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ oskarwires ];
  };
}
