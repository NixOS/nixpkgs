{ stdenv
, lib
, fetchurl
, unzip
, version ? "2.18.0"
, sources ? let
    base = "https://storage.googleapis.com/dart-archive/channels";
    x86_64 = "x64";
    i686 = "ia32";
    aarch64 = "arm64";
    # Make sure that if the user overrides version parameter they're
    # also need to override sources, to avoid mistakes
    version = "2.18.0";
  in
  {
    "${version}-aarch64-darwin" = fetchurl {
      url = "${base}/stable/release/${version}/sdk/dartsdk-macos-${aarch64}-release.zip";
      sha256 = "sha256-wfUh6rXy8jAC0TVQJzXh4SrV2DQs9SvY8PGtNgZx+cA=";
    };
    "${version}-x86_64-darwin" = fetchurl {
      url = "${base}/stable/release/${version}/sdk/dartsdk-macos-${x86_64}-release.zip";
      sha256 = "sha256-zyu6r8akId/AHpBKH95wJXXu1LD9CKShWYKfppnSRx4=";
    };
    "${version}-x86_64-linux" = fetchurl {
      url = "${base}/stable/release/${version}/sdk/dartsdk-linux-${x86_64}-release.zip";
      sha256 = "sha256-45HE7Y9iO5dI+JfLWF1ikFfBFB+er46bK+EYkyuhFjI=";
    };
    "${version}-i686-linux" = fetchurl {
      url = "${base}/stable/release/${version}/sdk/dartsdk-linux-${i686}-release.zip";
      sha256 = "sha256-IkSJWfAocT1l8F2igAkR+Y5PNYD5PZ0j21D8aJk9JCY=";
    };
    "${version}-aarch64-linux" = fetchurl {
      url = "${base}/stable/release/${version}/sdk/dartsdk-linux-${aarch64}-release.zip";
      sha256 = "sha256-Bt18brbJA/XfiyP5o197HDXMuGm+a1AZx92Thoriv78=";
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
  '' + lib.optionalString (stdenv.isLinux) ''
    find $out/bin -executable -type f -exec patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) {} \;
  '';

  libPath = lib.makeLibraryPath [ stdenv.cc.cc ];

  dontStrip = true;

  meta = with lib; {
    homepage = "https://www.dartlang.org/";
    maintainers = with maintainers; [ grburst ];
    description = "Scalable programming language, with robust libraries and runtimes, for building web, server, and mobile apps";
    longDescription = ''
      Dart is a class-based, single inheritance, object-oriented language
      with C-style syntax. It offers compilation to JavaScript, interfaces,
      mixins, abstract classes, reified generics, and optional typing.
    '';
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.bsd3;
  };
}
