{ stdenv
, lib
, fetchurl
, unzip
, version ? "2.17.3"
, sources ? let
    base = "https://storage.googleapis.com/dart-archive/channels";
    x86_64 = "x64";
    i686 = "ia32";
    aarch64 = "arm64";
    # Make sure that if the user overrides version parameter they're
    # also need to override sources, to avoid mistakes
    version = "2.17.3";
  in
  {
    "${version}-aarch64-darwin" = fetchurl {
      url = "${base}/stable/release/${version}/sdk/dartsdk-macos-${aarch64}-release.zip";
      sha256 = "sha256-NjkqC9DaaFGN47Qe46xUlsEx2O2bQrKhb1eJyxfr7Vg=";
    };
    "${version}-x86_64-darwin" = fetchurl {
      url = "${base}/stable/release/${version}/sdk/dartsdk-macos-${x86_64}-release.zip";
      sha256 = "sha256-+6y4lOGS8VyWrZCMSgLFun0E/WOCGlHEE8J5cQiVpUY=";
    };
    "${version}-x86_64-linux" = fetchurl {
      url = "${base}/stable/release/${version}/sdk/dartsdk-linux-${x86_64}-release.zip";
      sha256 = "sha256-aPmgmsYaqxwTWtLmSjm/rAiJANQ5lB3uJ12OqMhUG5U=";
    };
    "${version}-i686-linux" = fetchurl {
      url = "${base}/stable/release/${version}/sdk/dartsdk-linux-${i686}-release.zip";
      sha256 = "sha256-BFIN36OURaWIgBUiO35GkMkhCBHnqtKYPJVetdJ5cZI=";
    };
    "${version}-aarch64-linux" = fetchurl {
      url = "${base}/stable/release/${version}/sdk/dartsdk-linux-${aarch64}-release.zip";
      sha256 = "sha256-yZMke1raq0Mvu01LFE1aUsTEARZWMS0rAI727FHq6ts=";
    };
  }
}:

assert version != null && version != "";
assert sources != null && (builtins.isAttrs sources);

stdenv.mkDerivation {
  pname = "dart";
  inherit version;

  nativeBuildInputs = [ unzip ];

  src = sources."${version}-${stdenv.hostPlatform.system}" or (throw "unsupported version/system: ${version}/${stdenv.hostPlatform.system}");

  installPhase = ''
    mkdir -p $out
    cp -R * $out/
    echo $libPath
  '' + lib.optionalString(stdenv.isLinux) ''
    find $out/bin -executable -type f -exec patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) {} \;
  '';

  libPath = lib.makeLibraryPath [ stdenv.cc.cc ];

  dontStrip = true;

  meta = with lib; {
    homepage = "https://www.dartlang.org/";
    maintainers = with maintainers; [ grburst flexagoon ];
    description = "Scalable programming language, with robust libraries and runtimes, for building web, server, and mobile apps";
    longDescription = ''
      Dart is a class-based, single inheritance, object-oriented language
      with C-style syntax. It offers compilation to JavaScript, interfaces,
      mixins, abstract classes, reified generics, and optional typing.
    '';
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    license = licenses.bsd3;
  };
}
