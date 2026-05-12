{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cocotb,
  cocotb-bus,
}:

buildPythonPackage {
  pname = "cocotbext-axi";
  version = "0.1.26";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alexforencich";
    repo = "cocotbext-axi";
    rev = "33f510688ab9ab7aa5f01f9c04430b7ce4885cb5";
    hash = "sha256-NmYN87b754GxaRePLDZihns6G6hhcx3deScn5+7e7nU=";
  };

  dependencies = [
    cocotb
    cocotb-bus
  ];

  doCheck = true;

  meta = with lib; {
    description = "AXI interface modules for Cocotb";
    homepage = "https://github.com/alexforencich/cocotbext-axi";
    license = licenses.mit;
    maintainers = with maintainers; [ oskarwires ];
  };
}
