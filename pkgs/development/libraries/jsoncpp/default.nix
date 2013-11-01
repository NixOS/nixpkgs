{ stdenv, fetchurl, scons}:

let
  basename = "jsoncpp";
  version = "0.6.0-rc2";
  pkgname = "${basename}-src-${version}.tar.gz";
in 
stdenv.mkDerivation rec {
  name = "${basename}-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/${basename}/${pkgname}";
    sha256 = "10xj15nziqpwc6r3yznpb49wm4jqc5wakjsmj65v087mcg8r7lfl";
  };

  buildInputs = [ scons ];

  buildPhase = ''
    mkdir -p $out
    scons platform=linux-gcc check
  '';

  installPhase = ''
    cp -r include $out
    cp -r libs/* $out/lib
  '';

  meta = {
    homepage = http://jsoncpp.sourceforge.net;
    repositories.svn = svn://svn.code.sf.net/p/jsoncpp/code;
    description = "A simple API to manipulate JSON data in C++";
  };
}
