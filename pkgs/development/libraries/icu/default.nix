{stdenv, fetchurl}:

let
  pname = "icu4c";
  version = "4.4.1";
in

stdenv.mkDerivation {
  name = pname + "-" + version;
  
  src = fetchurl {
    url = "http://download.icu-project.org/files/${pname}/${version}/${pname}-"
      + (stdenv.lib.replaceChars ["."] ["_"] version) + "-src.tgz";
    sha256 = "0qrhf9gsj38saxfzpzvlwp1jwdsxr06npdds5dbsc86shg0lz69l";
  };

  postUnpack = "
    sourceRoot=\${sourceRoot}/source
    echo Source root reset to \${sourceRoot}
  ";
  
  configureFlags = "--disable-debug";

  meta = {
    description = "Unicode and globalization support library";
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.all;
  };
}
