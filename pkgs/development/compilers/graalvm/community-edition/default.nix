{ lib
, stdenv
, callPackage
, fetchurl
, gcc
, glibc
, zlib
}:

let
  buildGraalvm = callPackage ./buildGraalvm.nix { };
  buildGraalvmProduct = callPackage ./buildGraalvmProduct.nix { };
  sources = javaVersion: builtins.fromJSON (builtins.readFile (./. + "/graalvm${javaVersion}-ce-sources.json"));
in
rec {
  graalvm11-ce = buildGraalvm rec {
    version = "22.3.0";
    javaVersion = "11";
    src = fetchurl (sources javaVersion).${stdenv.system}.${"graalvm-ce|java${javaVersion}|${version}"};
    meta.platforms = builtins.attrNames (sources javaVersion);
    products = [ native-image-installable-svm-java11 ];
  };

  native-image-installable-svm-java11 = buildGraalvmProduct rec {
    product = "native-image-installable-svm";
    javaVersion = "11";
    version = "22.3.0";
    src = fetchurl (sources javaVersion).${stdenv.system}.${"${product}|java${javaVersion}|${version}"};
    postInstall = lib.optionalString stdenv.isLinux ''
      wrapProgram $out/bin/native-image \
        --prefix PATH : ${lib.makeBinPath [ gcc ]} \
        ${lib.concatStringsSep " "
          (map (l: "--add-flags '-H:CLibraryPath=${l}/lib'") [ glibc glibc.static zlib.static ])}
    '';
    installCheckPhase = ''
      echo "Ahead-Of-Time compilation"
      $out/bin/native-image -H:-CheckToolchain -H:+ReportExceptionStackTraces HelloWorld
      ./helloworld | fgrep 'Hello World'

      ${lib.optionalString stdenv.isLinux ''
        echo "Ahead-Of-Time compilation with -H:+StaticExecutableWithDynamicLibC"
        $out/bin/native-image -H:+StaticExecutableWithDynamicLibC HelloWorld
        ./helloworld | fgrep 'Hello World'

        echo "Ahead-Of-Time compilation with --static"
        $out/bin/native-image --static HelloWorld
        ./helloworld | fgrep 'Hello World'
      ''}
    '';
  };

  graalvm17-ce = buildGraalvm rec {
    version = "22.3.0";
    javaVersion = "17";
    src = fetchurl (sources javaVersion).${stdenv.system}.${"graalvm-ce|java${javaVersion}|${version}"};
    meta.platforms = builtins.attrNames (sources javaVersion);
    products = [ native-image-installable-svm-java11 ];
  };

  native-image-installable-svm-java17 = buildGraalvmProduct rec {
    product = "native-image-installable-svm";
    javaVersion = "17";
    version = "22.3.0";
    src = fetchurl (sources javaVersion).${stdenv.system}.${"${product}|java${javaVersion}|${version}"};
    postInstall = lib.optionalString stdenv.isLinux ''
      wrapProgram $out/bin/native-image \
        --prefix PATH : ${lib.makeBinPath [ gcc ]} \
        ${lib.concatStringsSep " "
          (map (l: "--add-flags '-H:CLibraryPath=${l}/lib'") [ glibc glibc.static zlib.static ])}
    '';
    installCheckPhase = ''
      echo "Ahead-Of-Time compilation"
      $out/bin/native-image -H:-CheckToolchain -H:+ReportExceptionStackTraces HelloWorld
      ./helloworld | fgrep 'Hello World'

      ${lib.optionalString stdenv.isLinux ''
        echo "Ahead-Of-Time compilation with -H:+StaticExecutableWithDynamicLibC"
        $out/bin/native-image -H:+StaticExecutableWithDynamicLibC HelloWorld
        ./helloworld | fgrep 'Hello World'

        echo "Ahead-Of-Time compilation with --static"
        $out/bin/native-image --static HelloWorld
        ./helloworld | fgrep 'Hello World'
      ''}
    '';
  };
}
