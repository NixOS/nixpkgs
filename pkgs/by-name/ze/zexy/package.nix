{
  lib,
  stdenv,
  fetchFromGitLab,
  puredata,
}:

stdenv.mkDerivation rec {
  pname = "zexy";
  version = "2.4.3";

  src = fetchFromGitLab {
    domain = "git.iem.at";
    owner = "pd";
    repo = "zexy";
    tag = "v${version}";
    hash = "sha256-9f0uYBDBq5lcN/N0uJwC/HBEFcj9b8ZtBHnPAce2s/A=";
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
}
