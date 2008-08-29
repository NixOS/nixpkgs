{stdenv, fetchurl, rLang}:

let

  /* Function to compile Bioconductor packages */

  buildBioConductor =
    { pname, pver, src, postInstall ? ""}:

    stdenv.mkDerivation {
      name = "${pname}-${pver}";

      inherit src;

      buildInputs = [rLang];

      # dontAddPrefix = true;

      # preBuild = "makeFlagsArray=(dictdir=$out/lib/aspell datadir=$out/lib/aspell)";

      inherit postInstall;
      installPhase = ''
        R CMD INSTALL ${affyioSrc}
      '';

      meta = {
        description = "Bioconductor package for ${pname}";
      };
    };

in {

   affyio = buildBioC {
     pname = "affyio";
     pver  = "1.8.1";
     src = fetchurl {
       url = http://www.bioconductor.org/packages/release/bioc/src/contrib/affyio_1.8.1.tar.gz;
       sha256 = "136nkpq870vrwf9z5gq32xjzrp8bjfbk9pn8fki2a5w2lr0qc8nh";
     };
  };

    
}
