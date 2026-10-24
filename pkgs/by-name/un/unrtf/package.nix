{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  automake,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unrtf";
  version = "0.21.13";

  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  src = fetchurl {
    url = "https://ftp.gnu.org/gnu/unrtf/unrtf-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-/yJ9GgrbhKnhpRteXDzsvaPWfIox29foWToECkOPtEw=";
  };

  nativeBuildInputs = [
    autoconf
    automake
  ];

  buildInputs = [ libiconv ];

  preConfigure = "./bootstrap";

  outputs = [
    "out"
    "man"
  ];

  meta = {
    description = "Converter from Rich Text Format to other formats";
    mainProgram = "unrtf";
    longDescription = ''
      UnRTF converts documents in Rich Text Format to other
      formats, including HTML, LaTeX, and RTF itself.
    '';
    homepage = "https://www.gnu.org/software/unrtf/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
