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
    mkdir -p "$out/bin"
    cp stalin "$out/bin"

    mkdir -p "$out/man/man1"
    cp stalin.1 "$out/man/man1"

    mkdir -p "$out/share/emacs/site-lisp"
    cp stalin.el "$out/share/emacs/site-lisp"

    mkdir -p "$out/doc/${name}"
    cp README "$out/doc/${name}"

    mkdir -p "$out/share/${name}/include"
    cp "include/"* "$out/share/${name}/include"

    substituteInPlace "$out/bin/stalin" \
      --replace "$PWD/include/stalin" "$out/share/${name}/include/stalin"
    substituteInPlace "$out/bin/stalin" \
      --replace "$PWD/include" "$out/share/${name}/include"
  '';

  meta = {
    homepage = http://www.ece.purdue.edu/~qobi/software.html;
    license = stdenv.lib.licenses.gpl2Plus;
    description = "Stalin, an optimizing Scheme compiler";

    maintainers = [ ];
    platforms = ["i686-linux"];  # doesn't want to work on 64-bit platforms
  };
}
