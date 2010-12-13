{stdenv, fetchurl}:

let
  pname = "icu4c";
  version = "4.6";
in

stdenv.mkDerivation {
  name = pname + "-" + version;
  
  src = fetchurl {
    url = "http://download.icu-project.org/files/${pname}/${version}/${pname}-"
      + (stdenv.lib.replaceChars ["."] ["_"] version) + "-src.tgz";
    sha256 = "1z6zklqdf6pq7fckk8ar4vmfrnw79bih6yc8gwc7k2vx2alav8dm";
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
