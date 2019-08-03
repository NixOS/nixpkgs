{ stdenv, fetchFromGitHub, fontforge }:

stdenv.mkDerivation rec {
  pname = "creep";
  version = "0.31";

  src = fetchFromGitHub {
    owner = "romeovs";
    repo = pname;
    rev = version;
    sha256 = "0zs21kznh1q883jfdgz74bb63i4lxlv98hj3ipp0wvsi6zw0vs8n";
  };

  nativeBuildInputs = [ fontforge ];

  dontBuild = true;

  installPhase = ''
    install -D -m644 creep.bdf "$out/usr/share/fonts/misc/creep.bdf"
  '';

  meta = with stdenv.lib; {
    description = "A pretty sweet 4px wide pixel font";
    homepage = https://github.com/romeovs/creep;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ buffet ];
  };
}
