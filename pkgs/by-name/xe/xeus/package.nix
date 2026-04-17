{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doctest,
  nlohmann_json,
  libuuid,
  nix-update-script,
  xtl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xeus";
  version = "6.0.5";

  src = fetchFromGitHub {
    owner = "jupyter-xeus";
    repo = "xeus";
    tag = finalAttrs.version;
    hash = "sha256-nbjq4dzrukVsZI6X3lWpr9oCZV5IUu/vkqSNKD7o3vo=";
  };

  nativeBuildInputs = [
    cmake
    doctest
  ];

  buildInputs = [
    nlohmann_json
    libuuid
  ];

  cmakeFlags = [
    "-DXEUS_BUILD_TESTS=ON"
  ];

  doCheck = true;
  preCheck = "export LD_LIBRARY_PATH=$PWD";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://xeus.readthedocs.io";
    description = "C++ implementation of the Jupyter Kernel protocol";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ serge_sans_paille ];
    platforms = lib.platforms.all;
  };
})
