{ stdenv, fetchurl, fetchpatch, fixDarwinDylibNames }:

let
  pname = "icu4c";
  version = "58.2";

  # this patch should no longer be needed in 58.3
  # https://bugs.gentoo.org/show_bug.cgi?id=599142#c14
  keywordFix = fetchurl {
    url = "http://bugs.icu-project.org/trac/changeset/39484?format=diff";
    name = "icu-changeset-39484.diff";
    sha256 = "0hxhpgydalyxacaaxlmaddc1sjwh65rsnpmg0j414mnblq74vmm8";
  };
in
stdenv.mkDerivation {
  name = pname + "-" + version;

  src = fetchurl {
    url = "http://download.icu-project.org/files/${pname}/${version}/${pname}-"
      + (stdenv.lib.replaceChars ["."] ["_"] version) + "-src.tgz";
    sha256 = "036shcb3f8bm1lynhlsb4kpjm9s9c2vdiir01vg216rs2l8482ib";
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

  patchFlags = "-p4";

  patches = [ keywordFix ];

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
