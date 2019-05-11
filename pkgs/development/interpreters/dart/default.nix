{ stdenv, fetchurl, unzip, version ? "2.3.0" }:

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
    "2.0.0-x86_64-linux" = fetchurl {
      url = "${stable}/${version}/sdk/dartsdk-linux-x64-release.zip";
      sha256 = "4014a1e8755d2d32cc1573b731a4a53acdf6dfca3e26ee437f63fe768501d336";
    };
    "2.0.0-i686-linux" = fetchurl {
      url = "${stable}/${version}/sdk/dartsdk-linux-ia32-release.zip";
      sha256 = "3164a9de70bf11ab5b20af0d51c8b3303f2dce584604dce33bea0040bdc0bbba";
    };
    "2.0.0-dev.26.0-x86_64-linux" = fetchurl {
      url = "${dev}/${version}/sdk/dartsdk-linux-x64-release.zip";
      sha256 = "18360489a7914d5df09b34934393e16c7627ba673c1e9ab5cfd11cd1d58fd7df";
    };
    "2.0.0-dev.26.0-i686-linux" = fetchurl {
      url = "${dev}/${version}/sdk/dartsdk-linux-ia32-release.zip";
      sha256 = "83ba8b64c76f48d8de4e0eb887e49b7960053f570d27e7ea438cc0bac789955e";
    };
    "2.1.0-x86_64-linux" = fetchurl {
      url = "${stable}/${version}/sdk/dartsdk-linux-x64-release.zip";
      sha256 = "24673028fbc506dbded6c273b3f5fb8f0f169bd900083d0113ddd5ce0a8adcb6";
    };
    "2.1.0-i686-linux" = fetchurl {
      url = "${stable}/${version}/sdk/dartsdk-linux-ia32-release.zip";
      sha256 = "db84d4fe7671f61d95797362b63e0588a721d8a3086d77517f4e1619e1a9318c";
    };
    "2.1.1-x86_64-linux" = fetchurl {
      url = "${stable}/${version}/sdk/dartsdk-linux-x64-release.zip";
      sha256 = "b223f095e2eb836481b6d5041d23a627745f0b45f70f9ce31cc1fbc68e9a9f90";
    };
    "2.1.1-i686-linux" = fetchurl {
      url = "${stable}/${version}/sdk/dartsdk-linux-ia32-release.zip";
      sha256 = "8c7d359f00f3569dffd9d02fc213cd895a5c3e524d386cf65c89c2373630ca7e";
    };
    "2.2.0-x86_64-linux" = fetchurl {
      url = "${stable}/${version}/sdk/dartsdk-linux-x64-release.zip";
      sha256 = "89777ceba8227d4dad6081c44bc70d301a259f3c2fdb4c1391961e376ec3af68";
    };
    "2.2.0-i686-linux" = fetchurl {
      url = "${stable}/${version}/sdk/dartsdk-linux-ia32-release.zip";
      sha256 = "d6d5edab837301bde218c97b074af8390d5dbe00a99961605159fa9e53609b81";
    };
    "2.3.0-dev.0.3-x86_64-linux" = fetchurl {
      url = "${dev}/${version}/sdk/dartsdk-linux-x64-release.zip";
      sha256 = "5feebfd7ba3274222e22f1d1990883b6c3acaf0e26eae057a4a8667a5c9041cd";
    };
    "2.3.0-dev.0.3-i686-linux" = fetchurl {
      url = "${dev}/${version}/sdk/dartsdk-linux-ia32-release.zip";
      sha256 = "41cba9b8ef03c7f8d2ec3f54aedf7ac1eb7ad379871fc69d23060e94653d572e";
    };
    "2.3.0-x86_64-linux" = fetchurl {
      url = "${stable}/${version}/sdk/dartsdk-linux-x64-release.zip";
      sha256 = "f2b9a2ba51ba71b025075b60dc31ccf5161c7a5a7061ed8e073efb309b718524";
    };
    "2.3.0-i686-linux" = fetchurl {
      url = "${stable}/${version}/sdk/dartsdk-linux-ia32-release.zip";
      sha256 = "b55626c0f855088c04e85fc7856012db281ea68846e9466e1cc0151c2508b432";
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
