{ stdenv, fetchurl, unzip, version ? "1.24.3" }:

let

  sources = let

    base = "https://storage.googleapis.com/dart-archive/channels";
    stable = "${base}/stable/release";
    dev = "${base}/dev/release";

  in {
    "1.16.1-x86_64-linux" = fetchurl {
      url = "${stable}/${version}/sdk/dartsdk-linux-x64-release.zip";
      sha256 = "01cbnc8hd2wwprmivppmzvld9ps644k16wpgqv31h1596l5p82n2";
    };
    "1.16.1-i686-linux" = fetchurl {
      url = "${stable}/${version}/sdk/dartsdk-linux-ia32-release.zip";
      sha256 = "0jfwzc3jbk4n5j9ka59s9bkb25l5g85fl1nf676mvj36swcfykx3";
    };
    "1.24.3-x86_64-linux" = fetchurl {
      url = "${stable}/${version}/sdk/dartsdk-linux-x64-release.zip";
      sha256 = "e323c97c35e6bc5d955babfe2e235a5484a82bb1e4870fa24562c8b9b800559b";
    };
    "1.24.3-i686-linux" = fetchurl {
      url = "${stable}/${version}/sdk/dartsdk-linux-ia32-release.zip";
      sha256 = "d67b8f8f9186e7d460320e6bce25ab343c014b6af4b2f61369ee83755d4da528";
    };
    "2.0.0-dev.26.0-x86_64-linux" = fetchurl {
      url = "${dev}/${version}/sdk/dartsdk-linux-x64-release.zip";
      sha256 = "18360489a7914d5df09b34934393e16c7627ba673c1e9ab5cfd11cd1d58fd7df";
    };
    "2.0.0-dev.26.0-i686-linux" = fetchurl {
      url = "${dev}/${version}/sdk/dartsdk-linux-ia32-release.zip";
      sha256 = "83ba8b64c76f48d8de4e0eb887e49b7960053f570d27e7ea438cc0bac789955e";
    };
  };

in

stdenv.mkDerivation {

  name = "dart-${version}";

  nativeBuildInputs = [
    unzip
  ];

  src = sources."${version}-${stdenv.hostPlatform.system}" or (throw "unsupported version/system: ${version}/${stdenv.hostPlatform.system}");

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
