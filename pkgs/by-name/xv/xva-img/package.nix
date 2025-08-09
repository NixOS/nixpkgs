{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  openssl,
  xxHash,
}:

stdenv.mkDerivation rec {
  pname = "xva-img";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "eriklax";
    repo = "xva-img";
    tag = version;
    hash = "sha256-YyWfN6VcEABmzHkkoA/kRehLum1UxsNJ58XBs1pl+c8=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    openssl
    xxHash
  ];

  meta = {
    maintainers = [ ];
    description = "Tool for converting Xen images to raw and back";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "xva-img";
  };
}
