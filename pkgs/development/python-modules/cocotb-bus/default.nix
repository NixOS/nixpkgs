{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "cocotb-bus";
  version = "0.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oZeqSw4K0oRpyId7QbP7LsAgban0kbknbRV4zm3Yqo0=";
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
