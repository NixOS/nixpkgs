{stdenv, fetchurl
, libtool, autoconf, automake
, gmp, mpfr, libffi, makeWrapper
, noUnicode ? false, 
}:
let
  s = # Generated upstream information
  rec {
    baseName="ecl";
    version="16.1.2";
    name="${baseName}-${version}";
    hash="16ab8qs3awvdxy8xs8jy82v8r04x4wr70l9l2j45vgag18d2nj1d";
    url="https://common-lisp.net/project/ecl/files/release/16.1.2/ecl-16.1.2.tgz";
    sha256="16ab8qs3awvdxy8xs8jy82v8r04x4wr70l9l2j45vgag18d2nj1d";
  };
  buildInputs = [
    libtool autoconf automake makeWrapper
  ];
  propagatedBuildInputs = [
    libffi gmp mpfr
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs propagatedBuildInputs;

  src = fetchurl {
    inherit (s) url sha256;
  };

  configureFlags = [
    "--enable-threads"
    "--with-gmp-prefix=${gmp}"
    "--with-libffi-prefix=${libffi}"
    ]
    ++
    (stdenv.lib.optional (! noUnicode)
      "--enable-unicode")
    ;

  hardeningDisable = [ "format" ];

  postInstall = ''
    sed -e 's/@[-a-zA-Z_]*@//g' -i $out/bin/ecl-config
    wrapProgram "$out/bin/ecl" \
      --prefix NIX_LDFLAGS ' ' "-L${gmp.lib or gmp.out or gmp}/lib" \
      --prefix NIX_LDFLAGS ' ' "-L${libffi.lib or libffi.out or libffi}/lib"
  '';

  meta = {
    inherit (s) version;
    description = "Lisp implementation aiming to be small, fast and easy to embed";
    license = stdenv.lib.licenses.mit ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
