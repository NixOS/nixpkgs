{ lib
, buildPythonPackage
, fetchPypi
, cmake
, numpy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "iminuit";
  version = "2.18.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fuLGoLzaxYGzj66NDzQ/3uVfkfH2psyWQ/z7zGwtw+Y=";
  };

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    numpy
  ];

  dontUseCmakeConfigure = true;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/scikit-hep/iminuit";
    description = "Python interface for the Minuit2 C++ library";
    license = with licenses; [ mit lgpl2Only ];
    maintainers = with maintainers; [ veprbl ];
  };
}
