{ stdenv
, lib
, fetchurl
, unzip
, version ? "2.15.1"
, sources ? let
    base = "https://storage.googleapis.com/dart-archive/channels";
    x86_64 = "x64";
    i686 = "ia32";
    aarch64 = "arm64";
    # Make sure that if the user overrides version parameter they're
    # also need to override sources, to avoid mistakes
    version = "2.15.1";
  in
  {
    "${version}-x86_64-darwin" = fetchurl {
      url = "${base}/stable/release/${version}/sdk/dartsdk-macos-${x86_64}-release.zip";
      sha256 = "sha256-s6bkwh2m5KdRr/WxWXwItO9YaDpp/HI3xjnS2UHmN+I=";
    };
    "${version}-x86_64-linux" = fetchurl {
      url = "${base}/stable/release/${version}/sdk/dartsdk-linux-${x86_64}-release.zip";
      sha256 = "sha256-D0XcqlO0CQtpsne4heqaTLOkFYnJEZET4bl4rVXOM18=";
    };
    "${version}-i686-linux" = fetchurl {
      url = "${base}/stable/release/${version}/sdk/dartsdk-linux-${i686}-release.zip";
      sha256 = "sha256-SRq5TtxS+bwCqVxa0U2Zhn8J1Wtm4Onq+3uQS+951sw=";
    };
    "${version}-aarch64-linux" = fetchurl {
      url = "${base}/stable/release/${version}/sdk/dartsdk-linux-${aarch64}-release.zip";
      sha256 = "sha256-iDbClCNDUsxT6K6koc4EQuu7dppTbOfzCVedpQIKI5U=";
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
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" "x86_64-darwin" ];
    license = licenses.bsd3;
  };
}
