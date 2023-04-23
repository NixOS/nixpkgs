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
  version = "2.21.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ivRsweaIvkiBceTfAI457wN+tbntJ3t4HTynWf29vAI=";
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
