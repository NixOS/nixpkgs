{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pythondata-cpu-vexriscv";
  version = "2020.04";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "litex-hub";
    repo = "pythondata-cpu-vexriscv";
    rev = version;
    hash = "sha256-6+cLGXhj16rlMRZ3p+qJ4FvIrRtvYUn+DKzqNT522NE=";
    fetchSubmodules = true;
  };

  pythonImportsCheck = [ "pythondata_cpu_vexriscv" ];

  # This is data.
  doCheck = false;

  meta = with lib; {
    description = "Python module containing verilog files for vexriscv cpu (for use with LiteX";
    homepage = "https://github.com/litex-hub/pythondata-cpu-vexriscv.git";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ raitobezarius ];
  };
}
