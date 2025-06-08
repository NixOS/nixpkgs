{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "untie";
  version = "0.3";
  src = fetchurl {
    url = "http://guichaz.free.fr/untie/files/untie-${finalAttrs.version}.tar.bz2";
    sha256 = "1334ngvbi4arcch462mzi5vxvxck4sy1nf0m58116d9xmx83ak0m";
  };

  patches = [
    # fix build with gcc14
    ./add-define-gnu-source.patch
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Tool to run processes untied from some of the namespaces";
    mainProgram = "untie";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };

  passthru = {
    updateInfo = {
      downloadPage = "http://guichaz.free.fr/untie";
    };
  };
})
