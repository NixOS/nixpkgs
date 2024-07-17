{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  glm,
}:

buildPythonPackage rec {
  pname = "gsplat";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nerfstudio-project";
    repo = "gsplat";
    rev = "v${version}";
    hash = "sha256-nORMH0KIeK4yQn6RSzF7Wf11WaV8mPPQKgfe5RZEvWU=";
  };

  build-system = [
    setuptools
    wheel
  ];

  buildInputs = [
    glm
  ];

  pythonImportsCheck = [ "gsplat" ];

  meta = with lib; {
    description = "CUDA accelerated rasterization of gaussian splatting";
    homepage = "https://github.com/nerfstudio-project/gsplat";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
