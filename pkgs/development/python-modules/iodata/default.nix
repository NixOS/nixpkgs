{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  numpy,
  scipy,
  attrs,
  cython,
  nose,
}:

buildPythonPackage rec {
  pname = "iodata";
  version = "1.0.0a2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "theochem";
    repo = pname;
    rev = version;
    hash = "sha256-GFTCYE19Re7WLhV8eU+0i8OMp/Tsms/Xj9DRTcgjcz4=";
  };

  nativeBuildInputs = [
    cython
    nose
  ];
  propagatedBuildInputs = [
    numpy
    scipy
    attrs
  ];

  pythonImportsCheck = [ "iodata" ];
  doCheck = false; # Requires roberto or nose and a lenghtly setup to find the cython modules

  meta = with lib; {
    description = "Python library for reading, writing, and converting computational chemistry file formats and generating input files";
    mainProgram = "iodata-convert";
    homepage = "https://github.com/theochem/iodata";
    license = licenses.lgpl3Only;
    maintainers = [ maintainers.sheepforce ];
  };
}
