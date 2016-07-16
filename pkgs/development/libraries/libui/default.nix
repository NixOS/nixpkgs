{ stdenv, fetchgit, cmake, pkgconfig, gtk3 }:

stdenv.mkDerivation rec {
  version = "3.1.a";
  name = "libui-${version}";
  src  = fetchgit {
    url    = "https://github.com/andlabs/libui.git";
    rev    = "6ebdc96b93273c3cedf81159e7843025caa83058";
    sha256 = "1lpbfa298c61aarlzgp7vghrmxg1274pzxh1j9isv8x758gk6mfn";
  };

  buildInputs = [ cmake pkgconfig gtk3 ];

  installPhase = ''
    mkdir -p $out
    mv ./out/libui.so.0 $out/libui.so.0
  '';

  meta = with stdenv.lib; {
    description = "Simple and portable (but not inflexible) GUI library in C that uses the native GUI technologies of each platform it supports.";
    homepage    = https://github.com/andlabs/libui;
    platforms   = platforms.linux;
    license     = licenses.mit;
  };
}
