{ lib
, stdenv
, graalvmCEPackages
, gcc
, glibc
, javaVersion
, musl
, src
, version
, writeShellScriptBin
, zlib
, useMusl ? false
, extraCLibs ? [ ]
}:

assert useMusl -> stdenv.isLinux;
let
  cLibs = [ glibc zlib.static ]
    ++ lib.optionals (!useMusl) [ glibc.static ]
    ++ lib.optionals useMusl [ musl ]
    ++ extraCLibs;
  # GraalVM 21.3.0+ expects musl-gcc as <system>-musl-gcc
  musl-gcc = (writeShellScriptBin "${stdenv.hostPlatform.system}-musl-gcc" ''${lib.getDev musl}/bin/musl-gcc "$@"'');
  binPath = lib.makeBinPath ([ gcc ] ++ lib.optionals useMusl [ musl-gcc ]);
in
graalvmCEPackages.buildGraalvmProduct rec {
  inherit src javaVersion version;
  product = "native-image-installable-svm";

  graalvmPhases.postInstall = lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/native-image \
      --prefix PATH : ${binPath} \
      ${lib.concatStringsSep " "
        (map (l: "--add-flags '-H:CLibraryPath=${l}/lib'") cLibs)}
  '';

  graalvmPhases.installCheckPhase = ''
    echo "Ahead-Of-Time compilation"
    $out/bin/native-image -H:-CheckToolchain -H:+ReportExceptionStackTraces HelloWorld
    ./helloworld | fgrep 'Hello World'

    ${# --static is only available in Linux
      lib.optionalString (stdenv.isLinux && !useMusl) ''
      echo "Ahead-Of-Time compilation with -H:+StaticExecutableWithDynamicLibC"
      $out/bin/native-image -H:+StaticExecutableWithDynamicLibC HelloWorld
      ./helloworld | fgrep 'Hello World'

      echo "Ahead-Of-Time compilation with --static"
      $out/bin/native-image --static HelloWorld
      ./helloworld | fgrep 'Hello World'
    ''}

    ${# --static is only available in Linux
      lib.optionalString (stdenv.isLinux && useMusl) ''
      echo "Ahead-Of-Time compilation with --static and --libc=musl"
      $out/bin/native-image --static HelloWorld --libc=musl
      ./helloworld | fgrep 'Hello World'
    ''}
  '';
}
