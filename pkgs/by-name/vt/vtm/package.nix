{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vtm";
  version = "0.9.99.55";

  src = fetchFromGitHub {
    owner = "netxs-group";
    repo = "vtm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eF5z+w64uIY7k/g4Z2Ynuz8PGyxpy6cOFIyUtV2VkxU=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Terminal multiplexer with window manager and session sharing";
    homepage = "https://vtm.netxs.online/";
    license = lib.licenses.mit;
    mainProgram = "vtm";
    maintainers = with lib.maintainers; [ ahuzik ];
    platforms = lib.platforms.all;
  };
})
