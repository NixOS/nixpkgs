{stdenv, fetchurl
, libtool, autoconf, automake
, texinfo
, gmp, mpfr, libffi, makeWrapper
, noUnicode ? false
, gcc
, threadSupport ? true
, useBoehmgc ? false, boehmgc
}:
let
  s = # Generated upstream information
  rec {
    baseName="ecl";
    version="20.4.24";
    name="${baseName}-${version}";
    url="https://common-lisp.net/project/ecl/static/files/release/${name}.tgz";
    sha256="01qgdmr54wkj854f69qdm9sybrvd6gd21dpx4askdaaqybnkh237";
  };
  buildInputs = [
    libtool autoconf automake texinfo makeWrapper
  ];
  propagatedBuildInputs = [
    libffi gmp mpfr gcc
    # replaces ecl's own gc which other packages can depend on, thus propagated
  ] ++ stdenv.lib.optionals useBoehmgc [
    # replaces ecl's own gc which other packages can depend on, thus propagated
    boehmgc
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs propagatedBuildInputs;

  src = fetchurl {
    inherit (s) url sha256;
  };

  patches = [
    # https://trac.sagemath.org/ticket/22191#comment:237
    (fetchurl {
      name = "ECL_WITH_LISP_FPE.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/ecl/patches/ECL_WITH_LISP_FPE.patch?h=9.2";
      sha256 = "0b194613avcmzr1k9gq725z41wdkg5rsa0q21kdw050iqpprcj1c";
    })

    # https://gitlab.com/embeddable-common-lisp/ecl/-/merge_requests/1
    (fetchurl {
      name = "write_error.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/ecl/patches/write_error.patch?h=9.2";
      sha256 = "1lvdvh77blnxp0zbd27dsbq1ljkb5qblabf1illszn4j7qgq88fh";
    })

    # Three patches to fix ecl's unicode handling (https://trac.sagemath.org/ticket/30122)
    (fetchurl {
      name = "0001-unicode-fix-ecl_string_case-for-non-ascii-characters.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/ecl/patches/0001-unicode-fix-ecl_string_case-for-non-ascii-characters.patch?h=9.2";
      sha256 = "0z8pnhawivrrbg4vz144nr2sz64jxp7764hn6df13bgkz84iqbmk";
    })

    (fetchurl {
      name = "0002-cosmetic-fix-some-compiler-warnings.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/ecl/patches/0002-cosmetic-fix-some-compiler-warnings.patch?h=9.2";
      sha256 = "0msx3say9igwr9z5ywnr3gs6vsndnzlx47fmzwzh4l0m274cnia8";
    })

    (fetchurl {
      name = "0003-printer-fix-printing-of-symbols-with-non-ascii-names.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/ecl/patches/0003-printer-fix-printing-of-symbols-with-non-ascii-names.patch?h=9.2";
      sha256 = "0ln5dsx6p265fkph3bl5wblgfi3f7frb4jl6v473wz3ibvcx1x9a";
    })
  ];

  configureFlags = [
    (if threadSupport then "--enable-threads" else "--disable-threads")
    "--with-gmp-prefix=${gmp.dev}"
    "--with-libffi-prefix=${libffi.dev}"
    ]
    ++
    (stdenv.lib.optional (! noUnicode)
      "--enable-unicode")
    ;

  hardeningDisable = [ "format" ];

  postInstall = ''
    sed -e 's/@[-a-zA-Z_]*@//g' -i $out/bin/ecl-config
    wrapProgram "$out/bin/ecl" \
      --prefix PATH ':' "${gcc}/bin" \
      --prefix NIX_LDFLAGS ' ' "-L${gmp.lib or gmp.out or gmp}/lib" \
      --prefix NIX_LDFLAGS ' ' "-L${libffi.lib or libffi.out or libffi}/lib"
  '';

  meta = {
    inherit (s) version;
    description = "Lisp implementation aiming to be small, fast and easy to embed";
    homepage = "https://common-lisp.net/project/ecl/";
    license = stdenv.lib.licenses.mit ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
