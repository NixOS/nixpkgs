{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  openssl,
  xxhash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xva-img";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "eriklax";
    repo = "xva-img";
    tag = finalAttrs.version;
    hash = "sha256-YyWfN6VcEABmzHkkoA/kRehLum1UxsNJ58XBs1pl+c8=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    openssl
    xxhash
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "CMAKE_MINIMUM_REQUIRED(VERSION 3.0)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    maintainers = [ ];
    description = "Tool for converting Xen images to raw and back";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "xva-img";
  };
})
