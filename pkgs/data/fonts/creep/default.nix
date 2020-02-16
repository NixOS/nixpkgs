{ stdenv, fetchFromGitHub, libfaketime
, fonttosfnt, mkfontscale
}:

stdenv.mkDerivation rec {
  pname = "creep";
  version = "0.31";

  src = fetchFromGitHub {
    owner = "romeovs";
    repo = pname;
    rev = version;
    sha256 = "0zs21kznh1q883jfdgz74bb63i4lxlv98hj3ipp0wvsi6zw0vs8n";
  };

  nativeBuildInputs = [ libfaketime fonttosfnt mkfontscale ];

  buildPhase = ''
    faketime -f "1970-01-01 00:00:01" fonttosfnt -g 2 -m 2 -o creep.otb creep.bdf
  '';

  installPhase = ''
    install -D -m644 creep.bdf "$out/share/fonts/misc/creep.bdf"
    mkfontdir "$out/share/fonts/misc"
    install -D -m644 creep.otb "$otb/share/fonts/misc/creep.otb"
    mkfontdir "$otb/share/fonts/misc"
  '';

  outputs = [ "out" "otb" ];

  meta = with stdenv.lib; {
    description = "A pretty sweet 4px wide pixel font";
    homepage = https://github.com/romeovs/creep;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ buffet ];
  };
}
