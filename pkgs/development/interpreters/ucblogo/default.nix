{
        wxGTK32
,       wrapGAppsHook
,       autoreconfHook
,       autoconf-archive
,       texinfo
,       tetex
,       stdenv
,       fetchFromGitHub
,       gtk3
,       lib
}:
stdenv.mkDerivation {
  pname = "ucblogo";
  version = "6.2.2";
  src = fetchTarball {
    url = "https://github.com/jrincayc/ucblogo-code/archive/refs/tags/version_6.2.2.zip";
    sha256 = "0vzzic9x1kclc2pn57cjwpb2q71h5pvn8cy2ancwww9l8i8qsb0p";
  };
  nativeBuildInputs = [
        autoreconfHook
        texinfo
        tetex
        autoconf-archive
  ];
  buildInputs = [
        gtk3
        wxGTK32
        wrapGAppsHook
      ];
  meta = with lib; {
      description = "Berkeley Logo interpreter";
      maintainers = with maintainers; [hllizi];
      license = lib.licenses.gpl3 ;
      platforms = lib.platforms.linux;
      homepage = "https://people.eecs.berkeley.edu/~bh/logo.html";
    };
}
