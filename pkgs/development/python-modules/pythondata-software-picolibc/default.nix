{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pythondata-software-picolibc";
  version = "2023.04";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "litex-hub";
    repo = "pythondata-software-picolibc";
    rev = version;
    hash = "sha256-0OpEdBGu/tkFFPUi1RLsTqF2tKwLSfYIi+vPqgfLMd8=";
    fetchSubmodules = true;
  };

  pythonImportsCheck = [ "pythondata_software_picolibc" ];

  doCheck = false;

  meta = with lib; {
    description = "Python module containing data files for picolibc software (for use with LiteX";
    homepage = "https://github.com/litex-hub/pythondata-software-picolibc";
    license = licenses.bsd3;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
