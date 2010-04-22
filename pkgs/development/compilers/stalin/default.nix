{ fetchurl, stdenv, ncompress, libX11 }:

stdenv.mkDerivation rec {
  name = "stalin-0.11";

  src = fetchurl {
    url = "ftp://ftp.ecn.purdue.edu/qobi/stalin.tar.Z";
    sha256 = "0lz8riccpigdixwf6dswwva6s4kxaz3dzxhkqhcxgwmffy30vw8s";
  };

  buildInputs = [ ncompress libX11 ];

  buildPhase = '' ./build '';

  installPhase = ''
    ensureDir "$out/bin"
    cp stalin "$out/bin"

    ensureDir "$out/man/man1"
    cp stalin.1 "$out/man/man1"

    ensureDir "$out/share/emacs/site-lisp"
    cp stalin.el "$out/share/emacs/site-lisp"

    ensureDir "$out/doc/${name}"
    cp README "$out/doc/${name}"

    ensureDir "$out/share/${name}/include"
    cp "include/"* "$out/share/${name}/include"

    substituteInPlace "$out/bin/stalin" \
      --replace "$PWD/include/stalin" "$out/share/${name}/include/stalin"
    substituteInPlace "$out/bin/stalin" \
      --replace "$PWD/include" "$out/share/${name}/include"
  '';

  meta = {
    homepage = http://www.ece.purdue.edu/~qobi/software.html;
    license = "GPLv2+";
    description = "Stalin, an optimizing Scheme compiler";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
