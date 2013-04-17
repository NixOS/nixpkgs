{ stdenv, fetchurl }:
 
assert stdenv.system == "x86_64-linux" || stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "dart-0.4";
 
  installPhase = ''
    mkdir -p $out
    cp -R * $out/
    echo $libPath
    patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
             --set-rpath $libPath \
             $out/bin/dart
    
    # Hack around weird dart2js resolving bug
    mv $out/bin/dart2js $out/bin/.dart2js
    echo "#!/bin/sh" > $out/bin/dart2js
    echo "$out/bin/.dart2js \$*" >> $out/bin/dart2js
    chmod +x $out/bin/dart2js
  '';
  
  
  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = http://download.zef.s3.amazonaws.com/dartsdk-m4-linux-64.tar.gz;
        sha256 = "1riwxxczskfsaax7n03m7isnbxf3walky0cac1w8j5apr1xvg5ma";
      }
    else
      fetchurl {
        url = http://download.zef.s3.amazonaws.com/dartsdk-m4-linux-32.tar.gz;
        sha256 = "00935c4vxfj2h3x354g75qdazswwissbwc7kj5k05l1m3lizikf6";
      };
 
  libPath = stdenv.lib.makeLibraryPath [ stdenv.gcc.gcc ];
 
  dontStrip = true;
}