{stdenv, fetchurl, unzip, ant, jre}: 

stdenv.mkDerivation {
  name = "ecj-3.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://sunsite.informatik.rwth-aachen.de/pub/mirror/eclipse/R-3.1-200506271435/eclipse-sourceBuild-srcIncluded-3.1.zip;
    md5 = "19ad65d52005da5eaa1d3687b3a50de2";
  };

  inherit jre;
  buildInputs = [unzip ant jre];
}
