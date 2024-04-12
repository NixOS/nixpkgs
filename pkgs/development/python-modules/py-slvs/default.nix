{ lib
, buildPythonPackage
, fetchFromGitHub
, cmake
, ninja
, scikit-build
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "py-slvs";
  version = "1.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "realthunder";
    repo = "slvs_py";
    rev = "v${version}";
    hash = "sha256-7uJQq+3eLvAVr+TKbgLfRK099ImzGKeZSTwGMtWugFI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    scikit-build
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "py_slvs" ];

  meta = with lib; {
    description = "SolveSpace Python binding package source";
    homepage = "https://github.com/realthunder/slvs_py";
    license = licenses.mpl20; # FIXME - Not the actual license.
    maintainers = with maintainers; [
      waynevanson
    ];
  };
}
