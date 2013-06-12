{stdenv, fetchurl
, gmp, mpfr, libffi
, noUnicode ? false, 
}:
let
  s = # Generated upstream information
  rec {
    baseName="ecl";
    version="13.5.1";
    name="${baseName}-${version}";
    hash="18ic8w9sdl0dh3kmyc9lsrafikrd9cg1jkhhr25p9saz0v75f77r";
    url="mirror://sourceforge/project/ecls/ecls/13.5/ecl-13.5.1.tgz";
    sha256="18ic8w9sdl0dh3kmyc9lsrafikrd9cg1jkhhr25p9saz0v75f77r";
  };
  buildInputs = [
    libffi
  ];
  propagatedBuildInputs = [
    gmp mpfr
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
    ]
    ++
    (stdenv.lib.optional (! noUnicode)
      "--enable-unicode")
    ;
  postInstall = ''
    sed -e 's/@[-a-zA-Z_]*@//g' -i $out/bin/ecl-config
  '';
  meta = {
    inherit (s) version;
    description = "Lisp implementation aiming to be small, fast and easy to embed";
    license = stdenv.lib.licenses.mit ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
