{ stdenv, fetchurl, fonttosfnt, mkfontscale, libfaketime }:

stdenv.mkDerivation rec {
  pname = "clearlyU";
  version = "12-1.9";

  src = fetchurl {
    url = "https://www.math.nmsu.edu/~mleisher/Software/cu/cu${version}.tgz";
    sha256 = "1xn14jbv3m1khy7ydvad9ydkn7yygdbhjy9wm1v000jzjwr3lv21";
  };

  nativeBuildInputs = [ fonttosfnt mkfontscale libfaketime ];

  buildPhase = ''
    # convert bdf fonts to otb
    for i in *.bdf; do
      name=$(basename "$i" .bdf)
      faketime -f "1970-01-01 00:00:01" fonttosfnt -g 2 -m 2 -v -o "$name.otb" "$i"
    done
  '';

  installPhase = ''
    # install bdf fonts
    fontDir="$out/share/fonts"
    install -m 644 -D *.bdf -t "$fontDir"
    mkfontdir "$fontDir"

    # install otb fonts
    fontDir="$otb/share/fonts"
    install -m 644 -D *.otb -t "$fontDir"
    mkfontdir "$fontDir"
  '';

  outputs = [ "out"  "otb" ];

  meta = with stdenv.lib; {
    description = "A Unicode font";
    license = licenses.mit;
    maintainers = [ maintainers.raskin ];
  };
}
