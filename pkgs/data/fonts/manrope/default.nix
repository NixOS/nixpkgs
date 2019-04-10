{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "manrope";
  version = "3";
  src = fetchFromGitHub {
    owner = "sharanda";
    repo = pname;
    rev = "3bd68c0c325861e32704470a90dfc1868a5c37e9";
    sha256 = "1k6nmczbl97b9j2a8vx6a1r3q4gd1c2qydv0y9gn8xyl7x8fcvhs";
  };
  dontBuild = true;
  installPhase = ''
    install -Dm644 -t $out/share/fonts/opentype "desktop font"/*
  '';
  meta = with stdenv.lib; {
    description = "Open-source modern sans-serif font family";
    homepage = https://github.com/sharanda/manrope;
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
