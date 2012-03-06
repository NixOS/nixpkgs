{ stdenv
, fetchurl
, bison
, pkgconfig
, multipleOutputs ? false #Uses incomplete features of nix!
}:

stdenv.mkDerivation (rec {
  name = "sphinxbase-0.7";

  src = fetchurl {
    url = "mirror://sourceforge/cmusphinx/${name}.tar.gz";
    sha256 = "1v3kfzw42ahxmr002i6wqigs832958vgghrv5dd62zazajdbk71q";
  };

  buildInputs = [ pkgconfig bison ];

  meta = {
    description = "Support Library for Pocketsphinx";
    homepage = http://cmusphinx.sourceforge.net;
    license = "free-non-copyleft";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
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

