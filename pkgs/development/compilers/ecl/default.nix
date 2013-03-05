{stdenv, fetchurl
, gmp, mpfr, libffi
, noUnicode ? false, 
}:
let
  s = # Generated upstream information
  rec {
    baseName="ecl";
    version="12.12.1";
    name="${baseName}-${version}";
    hash="15y2dgj95li6mxiz9pnllj9x88km0z8gfh46kysfllkp2pl7rrsl";
    url="mirror://sourceforge/project/ecls/ecls/12.12/ecl-12.12.1.tgz";
    sha256="15y2dgj95li6mxiz9pnllj9x88km0z8gfh46kysfllkp2pl7rrsl";
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
