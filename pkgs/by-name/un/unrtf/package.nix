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
  version = "0.21.10";

  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  src = fetchurl {
    url = "https://ftp.gnu.org/gnu/unrtf/unrtf-${finalAttrs.version}.tar.gz";
    sha256 = "1bil6z4niydz9gqm2j861dkxmqnpc8m7hvidsjbzz7x63whj17xl";
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
    maintainers = with lib.maintainers; [ joachifm ];
    platforms = lib.platforms.unix;
  };
})
