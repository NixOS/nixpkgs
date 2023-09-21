{ stdenv, lib, buildPythonPackage, fetchFromGitLab, pythonOlder, pytestCheckHook, pybind11, numpy }:

buildPythonPackage rec {
  pname = "ducc0";
  version = "0.31.0";

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    domain = "gitlab.mpcdf.mpg.de";
    owner = "mtr";
    repo = "ducc";
    rev = "ducc0_${lib.replaceStrings ["."] ["_"] version}";
    hash = "sha256-4aNIq5RNo1Qqiqr2wjYB/FXKyvbARsRF1yW1ZzZlAOo=";
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
