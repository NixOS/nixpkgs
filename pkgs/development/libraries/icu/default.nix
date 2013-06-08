{stdenv, fetchurl}:

let
  pname = "icu4c";
  version = "51.1";
in

stdenv.mkDerivation {
  name = pname + "-" + version;

  src = fetchurl {
    url = http://download.icu-project.org/files/icu4c/51.1/icu4c-51_1-src.tgz;
    sha256 = "0sv6hgkm92pm27zgjxgk284lcxxbsl0syi40ckw2b7yj7d8sxrc7";
  };

  postUnpack = ''
    sourceRoot=''${sourceRoot}/source
    echo Source root reset to ''${sourceRoot}
  '';

  configureFlags = "--disable-debug";

  enableParallelBuilding = true;

  meta = {
    description = "Unicode and globalization support library";
    homepage = http://site.icu-project.org/;
    maintainers = with stdenv.lib.maintainers; [raskin urkud];
    platforms = stdenv.lib.platforms.all;
  };
}
