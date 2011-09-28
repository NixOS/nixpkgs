{stdenv, fetchurl}:

let
  pname = "icu4c";
  version = "4.8.1";
in

stdenv.mkDerivation {
  name = pname + "-" + version;
  
  src = fetchurl {
    url = "http://download.icu-project.org/files/${pname}/${version}/${pname}-"
      + (stdenv.lib.replaceChars ["."] ["_"] version) + "-src.tgz";
    sha256 = "13zq190gl54zr84f0k48w9knarjsb966jkailyy06yhqjipcv90r";
  };

  postUnpack = "
    sourceRoot=\${sourceRoot}/source
    echo Source root reset to \${sourceRoot}
  ";
  
  configureFlags = "--disable-debug";

  meta = {
    description = "Unicode and globalization support library";
    homepage = http://site.icu-project.org/;
    maintainers = with stdenv.lib.maintainers; [raskin urkud];
    platforms = stdenv.lib.platforms.all;
  };
}
