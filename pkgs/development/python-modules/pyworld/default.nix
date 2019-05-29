{ stdenv, lib
, buildPythonPackage, fetchPypi
, numpy, cython
}:

buildPythonPackage rec {
  pname = "pyworld";
  version = "0.2.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b25bc84efb1bfe1fa0e10b19b391ef40b6e1a330a8e31d676befa58614880bb3";
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    numpy
  ];

  # There are not any tests.
  doCheck = false;

  meta = with lib; {
    description = "A Python wrapper for the high-quality vocoder \"World\"";
    homepage = https://github.com/JeremyCCHsu/Python-Wrapper-for-World-Vocoder;
    license = licenses.mit;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
