{ wxGTK32
, wrapGAppsHook
, autoreconfHook
, autoconf-archive
, texinfo
, tetex
, stdenv
, fetchFromGitHub
, gtk3
, lib
}:
stdenv.mkDerivation {
  pname = "ucblogo";
  version = "6.2.2";
  src = fetchFromGitHub {
    rev = "0ba6ad1629f94a89f98e2bf884c1388c6ee78b6d";
    sha256 = "FyyNUUQ0cc6ZVcIzZPctMBws1uWSnWKvYJTN0BOL/28=";
    owner = "jrincayc";
    repo = "ucblogo-code";
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
    maintainers = with maintainers; [ hllizi ];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    homepage = "https://people.eecs.berkeley.edu/~bh/logo.html";
  };
}
