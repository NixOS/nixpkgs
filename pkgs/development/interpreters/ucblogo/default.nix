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
  src = builtins.fetchgit {
    rev = "0ba6ad1629f94a89f98e2bf884c1388c6ee78b6d";
    ref = "master";
    url = "https://github.com/jrincayc/ucblogo-code.git";
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
