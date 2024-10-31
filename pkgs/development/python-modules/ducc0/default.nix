{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  numpy,
  pybind11,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ducc0";
  version = "0.35.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitLab {
    domain = "gitlab.mpcdf.mpg.de";
    owner = "mtr";
    repo = "ducc";
    rev = "ducc0_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-LfN+rwJp5euVpR/5sUBG3XqBhF7/KbgW/485eufJtMQ=";
  };

  buildInputs = [ pybind11 ];
  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [
    pytestCheckHook
    setuptools
  ];
  pytestFlagsArray = [ "python/test" ];
  pythonImportsCheck = [ "ducc0" ];

  DUCC0_OPTIMIZATION = "portable-strip";

  meta = with lib; {
    homepage = "https://gitlab.mpcdf.mpg.de/mtr/ducc";
    description = "Efficient algorithms for Fast Fourier transforms and more";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ parras ];
  };
}
