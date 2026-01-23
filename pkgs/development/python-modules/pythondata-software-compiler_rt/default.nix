{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pythondata-software-compiler-rt";
  version = "2020.04";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "litex-hub";
    repo = "pythondata-software-compiler_rt";
    rev = version;
    hash = "sha256-nE0ZvdlHj4BfbKd1D+AqCHGpVXNMovOIGKMT32WqZ3A=";
  };

  pythonImportsCheck = [ "pythondata_software_compiler_rt" ];

  doCheck = false;

  meta = with lib; {
    description = "Python module containing data files for compiler_rt software (for use with LiteX";
    homepage = "https://github.com/litex-hub/pythondata-software-compiler_rt";
    license = with licenses; [ ];
    maintainers = with maintainers; [ raitobezarius ];
  };
}
