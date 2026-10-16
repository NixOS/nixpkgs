{
  build-idris-package,
  fetchFromGitHub,
  effects,
  lib,
  pkgs,
}:
build-idris-package {
  pname = "glfw";
  version = "2016-12-05";

  idrisDeps = [ effects ];

  nativeBuildInputs = [ pkgs.pkg-config ];
  extraBuildInputs = [ pkgs.glfw ];

  postPatch = ''
    substituteInPlace src/MakefileGlfw \
      --replace glfw3 "glfw3 gl"
  '';

  src = fetchFromGitHub {
    owner = "eckart";
    repo = "glfw-idris";
    rev = "10220a734b69f3b884683041a1a9c533800b663a";
    hash = "sha256-DWNvf/FEcUX48cGxab88Hvkda1e0Y/i9JrU8Y6SivhA=";
  };

  meta = {
    description = "GLFW bindings for Idris";
    homepage = "https://github.com/eckart/glfw-idris";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
