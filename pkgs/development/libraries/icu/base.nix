{ version, sha256, patches ? [], patchFlags ? "" }:
{ stdenv, fetchurl, fetchpatch, fixDarwinDylibNames }:

let
  pname = "icu4c";
in
stdenv.mkDerivation {
  name = pname + "-" + version;

  src = fetchurl {
    url = "http://download.icu-project.org/files/${pname}/${version}/${pname}-"
      + (stdenv.lib.replaceChars ["."] ["_"] version) + "-src.tgz";
    inherit sha256;
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  # FIXME: This fixes dylib references in the dylibs themselves, but
  # not in the programs in $out/bin.
  buildInputs = stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  postUnpack = ''
    sourceRoot=''${sourceRoot}/source
    echo Source root reset to ''${sourceRoot}
  '';

  # https://sourceware.org/glibc/wiki/Release/2.26#Removal_of_.27xlocale.h.27
  postPatch = if stdenv ? glibc
    then "substituteInPlace i18n/digitlst.cpp --replace '<xlocale.h>' '<locale.h>'"
    else null; # won't find locale_t on darwin

  inherit patchFlags patches;

  preConfigure = ''
    sed -i -e "s|/bin/sh|${stdenv.shell}|" configure
  '' + stdenv.lib.optionalString stdenv.isArm ''
    # From https://archlinuxarm.org/packages/armv7h/icu/files/icudata-stdlibs.patch
    sed -e 's/LDFLAGSICUDT=-nodefaultlibs -nostdlib/LDFLAGSICUDT=/' -i config/mh-linux
  '';

  configureFlags = "--disable-debug" +
    stdenv.lib.optionalString (stdenv.isFreeBSD || stdenv.isDarwin) " --enable-rpath";

  # remove dependency on bootstrap-tools in early stdenv build
  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's/INSTALL_CMD=.*install/INSTALL_CMD=install/' $out/lib/icu/${version}/pkgdata.inc
  '';

  postFixup = ''moveToOutput lib/icu "$dev" '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Unicode and globalization support library";
    homepage = http://site.icu-project.org/;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.all;
  };
}
