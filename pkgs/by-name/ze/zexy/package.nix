{
  lib,
  stdenv,
  fetchFromGitLab,
  puredata,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zexy";
  version = "2.4.4";

  src = fetchFromGitLab {
    domain = "git.iem.at";
    owner = "pd";
    repo = "zexy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9+kWnfYLSOI2PaFQVzlaq1EjzUeOZvVRomGfWSLNXCw=";
  };

  buildInputs = [ puredata ];

  makeFlags = [ "PDLIBDIR=$(out)" ];

  meta = {
    description = "Swiss army knife for puredata";
    homepage = "https://git.iem.at/pd/zexy";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
})
