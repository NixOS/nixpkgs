{ lib, stdenv
, fetchurl
, bison
, pkg-config
, python27 # >= 2.6
, swig2 # 2.0
, multipleOutputs ? false #Uses incomplete features of nix!
}:

stdenv.mkDerivation (rec {
  name = "sphinxbase-5prealpha";

  src = fetchurl {
    url = "mirror://sourceforge/cmusphinx/${name}.tar.gz";
    sha256 = "0vr4k8pv5a8nvq9yja7kl13b5lh0f9vha8fc8znqnm8bwmcxnazp";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ swig2 python27 bison ];

  meta = {
    description = "Support Library for Pocketsphinx";
    homepage = "http://cmusphinx.sourceforge.net";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ];
  };

} // (lib.optionalAttrs multipleOutputs {
  outputs = [ "out" "lib" "headers" ];

  postInstall = ''
    mkdir -p $lib
    cp -av $out/lib* $lib

    mkdir -p $headers
    cp -av $out/include $headers
  '';
}))
