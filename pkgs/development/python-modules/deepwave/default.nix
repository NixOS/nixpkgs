{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  scikit-build-core,
  torch,
  pytestCheckHook,
  scipy,
}:

buildPythonPackage rec {
  pname = "deepwave";
  version = "0.0.26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ar4";
    repo = "deepwave";
    tag = "v${version}";
    hash = "sha256-gjFbBn7fJiLZUm+97xf6xd7C+OkEoeFe3061tFkJhFk=";
  };

  # Return to project root to locate `pyproject.toml` for build
  preBuild = ''
    cd ..
  '';

  nativeBuildInputs = [
    cmake
  ];

  build-system = [
    scikit-build-core
  ];

  dependencies = [
    torch
  ];

  nativeCheckInputs = [
    pytestCheckHook
    scipy
  ];

  pythonImportsCheck = [ "deepwave" ];

  meta = {
    description = "Wave propagation modules for PyTorch";
    homepage = "https://github.com/ar4/deepwave";
    license = lib.licenses.mit;
    platforms = lib.intersectLists lib.platforms.x86_64 lib.platforms.linux;
    maintainers = [ ];
  };
}
