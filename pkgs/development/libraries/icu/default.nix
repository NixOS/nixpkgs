{stdenv, fetchurl}:

let

  pname = "icu4c";
  ver_maj = "52";
  ver_min = "1";
  version = "${ver_maj}.${ver_min}";
in

stdenv.mkDerivation {
  name = pname + "-" + version;

  src = fetchurl {
    url = "http://download.icu-project.org/files/icu4c/${version}/icu4c-${ver_maj}_${ver_min}-src.tgz";
    sha256 = "14l0kl17nirc34frcybzg0snknaks23abhdxkmsqg3k9sil5wk9g";
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
