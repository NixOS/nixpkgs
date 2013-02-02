{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "gwt-java-2.4.0";

  src = fetchurl {
    url=http://google-web-toolkit.googlecode.com/files/gwt-2.4.0.zip;
    sha1 = "a91ac20db0ddd5994ac3cbfb0e8061d5bbf66f88";
  };

  buildInputs = [ unzip ];

  installPhase = ''
    ensureDir $out
    unzip $src
    mv gwt-2.4.0 $out/bin
  '';

  meta = {
    homepage = http://code.google.com/webtoolkit/;
    description = "Google Web Toolkit (GWT) is a development toolkit for building and optimizing complex browser-based applications.";
  };
}
