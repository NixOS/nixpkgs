{ build-idris-package
, fetchFromGitHub
, prelude
, effects
, lib
, idris
, pkgs
}:

build-idris-package  {
  name = "glfw";
  version = "2016-12-05";

  idrisDeps = [ prelude effects ];

  extraBuildInputs = [ pkgs.glfw ];

  src = fetchFromGitHub {
    owner = "eckart";
    repo = "glfw-idris";
    rev = "10220a734b69f3b884683041a1a9c533800b663a";
    sha256 = "045ylaj66g5m4syzhqxlaxmivy8y7jznkcf1y7w4awa4y5znyqqd";
  };

  meta = {
    description = "GLFW bindings for Idris";
    homepage = https://github.com/eckart/glfw-idris;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
    inherit (idris.meta) platforms;
  };
}
