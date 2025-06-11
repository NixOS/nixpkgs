{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libXmu,
}:

stdenv.mkDerivation rec {
  pname = "xclip";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "astrand";
    repo = "xclip";
    rev = version;
    sha256 = "0q0hmvcjlv8arhh1pzhja2wglyj6n7z209jnpnzd281kqqv4czcs";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ libXmu ];

  meta = {
    description = "Tool to access the X clipboard from a console application";
    homepage = "https://github.com/astrand/xclip";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    mainProgram = "xclip";
  };
}
