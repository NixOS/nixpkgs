{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage {
  pname = "cocotb-bus";
  version = "unstable-2025-11-03";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cocotb";
    repo = "cocotb-bus";
    rev = "f72b989bde036e677d5e9ebab3a6a21bdfe43d09";
    hash = "sha256-4j63kOjBd+iLA2EYqLTM0oKzKksOjH2UqNgDNFvWgYw=";
  };

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
    maintainers = with maintainers; [ oskarwires ];
  };
}
