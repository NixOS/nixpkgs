{ stdenv
, fetchurl
, bison
, pkgconfig
, multipleOutputs ? false #Uses incomplete features of nix!
}:

stdenv.mkDerivation (rec {
  name = "sphinxbase-0.8";

  src = fetchurl {
    url = "mirror://sourceforge/cmusphinx/${name}.tar.gz";
    sha256 = "1a3c91g6rcfb2k8qyfhnd7s68ds6pxwv61xfp0ai1arbhx28jw2m";
  };

  buildInputs = [ pkgconfig bison ];

  meta = {
    description = "Support Library for Pocketsphinx";
    homepage = http://cmusphinx.sourceforge.net;
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };

} // (stdenv.lib.optionalAttrs multipleOutputs {
  outputs = [ "out" "lib" "headers" ];

  postInstall = ''
    mkdir -p $lib
    cp -av $out/lib* $lib

    mkdir -p $headers
    cp -av $out/include $headers
  '';
}))
