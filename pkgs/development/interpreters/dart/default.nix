{ stdenv, fetchurl, unzip }:

let
  version = "1.16.1";
in
stdenv.mkDerivation {
  name = "dart-${version}";

  nativeBuildInputs = [
    unzip
  ];
  
  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-x64-release.zip";
        sha256 = "01cbnc8hd2wwprmivppmzvld9ps644k16wpgqv31h1596l5p82n2";
      }
    else
      fetchurl {
        url = "https://storage.googleapis.com/dart-archive/channels/stable/release/${version}/sdk/dartsdk-linux-ia32-release.zip";
        sha256 = "0jfwzc3jbk4n5j9ka59s9bkb25l5g85fl1nf676mvj36swcfykx3";
      };

  installPhase = ''
    mkdir -p $out
    cp -R * $out/
    echo $libPath
    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
             --set-rpath $libPath \
             $out/bin/dart
  '';

  libPath = stdenv.lib.makeLibraryPath [ stdenv.cc.cc ];
 
  dontStrip = true;
  
  meta = {
    platforms = [ "i686-linux" "x86_64-linux" ];
    homepage = https://www.dartlang.org/;
    description = "Scalable programming language, with robust libraries and runtimes, for building web, server, and mobile apps";
    longDescription = ''
      Dart is a class-based, single inheritance, object-oriented language
      with C-style syntax. It offers compilation to JavaScript, interfaces,
      mixins, abstract classes, reified generics, and optional typing.
    '';
    license = stdenv.lib.licenses.bsd3;
  };
}
