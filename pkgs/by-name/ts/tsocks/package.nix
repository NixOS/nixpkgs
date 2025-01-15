{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "tsocks";
  version = "1.8beta5";

  src = fetchurl {
    url = "mirror://sourceforge/tsocks/${pname}-${version}.tar.gz";
    sha256 = "0ixkymiph771dcdzvssi9dr2pk1bzaw9zv85riv3xl40mzspx7c4";
  };

  patches = [ ./poll.patch ];

  preConfigure = ''
    sed -i -e "s,\\\/usr,"$(echo $out|sed -e "s,\\/,\\\\\\\/,g")",g" tsocks
    substituteInPlace configure \
      --replace-fail "main(){return(0);}" "int main(){return(0);}"
    substituteInPlace tsocks --replace /usr $out
  '';

  configureFlags = [
    "--libdir=${placeholder "out"}/lib"
  ];

  preBuild = ''
    # We don't need the saveme binary, it is in fact never stored and we're
    # never injecting stuff into ld.so.preload anyway
    sed -i \
      -e "s,TARGETS=\(.*\)..SAVE.\(.*\),TARGETS=\1\2," \
      -e "/SAVE/d" Makefile
  '';

  meta = with lib; {
    description = "Transparent SOCKS v4 proxying library";
    mainProgram = "tsocks";
    homepage = "https://tsocks.sourceforge.net/";
    license = lib.licenses.gpl2;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
