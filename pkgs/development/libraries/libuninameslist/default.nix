{ stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "libuninameslist";
  version = "20190701";

  src = fetchFromGitHub {
    owner = "fontforge";
    repo = pname;
    rev = version;
    sha256 = "sha256:034c8clnskvqbwyiq7si4dad1kbngi3jmnrj064i39msqixmpdzb";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/fontforge/libuninameslist/;
    description = "A Library of Unicode names and annotation data";
    license = licenses.bsd3;
    maintainers = with maintainers; [ erictapen ];
    platforms = platforms.all;
  };
}
