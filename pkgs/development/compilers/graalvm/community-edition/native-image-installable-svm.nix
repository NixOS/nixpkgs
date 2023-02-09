{ lib
, stdenv
, graalvmCEPackages
, gcc
, glibc
, javaVersion
, src
, version
, zlib
}:

graalvmCEPackages.buildGraalvmProduct rec {
  inherit src javaVersion version;
  product = "native-image-installable-svm";

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
}
