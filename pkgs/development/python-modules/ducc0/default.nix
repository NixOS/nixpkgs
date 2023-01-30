{ stdenv, lib, buildPythonPackage, fetchFromGitLab, pythonOlder, pytestCheckHook, pybind11, numpy }:

buildPythonPackage rec {
  pname = "ducc0";
  version = "0.28.0";

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    domain = "gitlab.mpcdf.mpg.de";
    owner = "mtr";
    repo = "ducc";
    rev = "ducc0_${lib.replaceStrings ["."] ["_"] version}";
    sha256 = "sha256-yh7L87s3STL2usGBXgIhCS7GKQuau/PV6US3T06bb0M=";
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
