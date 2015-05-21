{ stdenv, fetchurl, fixDarwinDylibNames }:

let
  pname = "icu4c";
  version = "55.1";
in
stdenv.mkDerivation {
  name = pname + "-" + version;

  src = fetchurl {
    url = "http://download.icu-project.org/files/${pname}/${version}/${pname}-"
      + (stdenv.lib.replaceChars ["."] ["_"] version) + "-src.tgz";
    sha256 = "0ys5f5spizg45qlaa31j2lhgry0jka2gfha527n4ndfxxz5j4sz1";
  };

  makeFlags = stdenv.lib.optionalString stdenv.isDarwin
    "CXXFLAGS=-headerpad_max_install_names";

  # FIXME: This fixes dylib references in the dylibs themselves, but
  # not in the programs in $out/bin.
  buildInputs = stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  postUnpack = ''
    sourceRoot=''${sourceRoot}/source
    echo Source root reset to ''${sourceRoot}
  '';

  preConfigure = ''
    sed -i -e "s|/bin/sh|${stdenv.shell}|" configure
  '';

  configureFlags = "--disable-debug" +
    stdenv.lib.optionalString stdenv.isDarwin " --enable-rpath";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Unicode and globalization support library";
    homepage = http://site.icu-project.org/;
    maintainers = with maintainers; [ raskin urkud ];
    platforms = platforms.all;
  };
}
