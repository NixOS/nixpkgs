{ stdenv, lib, buildPythonPackage, fetchFromGitLab, pythonOlder, pytestCheckHook, pybind11, numpy }:

buildPythonPackage rec {
  pname = "ducc0";
  version = "0.33.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitLab {
    domain = "gitlab.mpcdf.mpg.de";
    owner = "mtr";
    repo = "ducc";
    rev = "ducc0_${lib.replaceStrings ["."] ["_"] version}";
    hash = "sha256-MezcqQRitBkK4/1rRQM2c9w+iZb2kIsDdcNd6I8CPoI=";
  };

  buildInputs = [ pybind11 ];
  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "python/test" ];
  pythonImportsCheck = [ "ducc0" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://gitlab.mpcdf.mpg.de/mtr/ducc";
    description = "Efficient algorithms for Fast Fourier transforms and more";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ parras ];
  };
}
