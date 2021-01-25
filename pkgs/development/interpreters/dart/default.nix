{ stdenv
, lib
, fetchurl
, unzip
, version ? "2.10.5"
, sources ?
  let
    base = "https://storage.googleapis.com/dart-archive/channels";
    x86_64 = "x64";
    i686 = "ia32";
    aarch64 = "arm64";
    # Make sure that if the user overrides version parameter they're
    # also need to override sources, to avoid mistakes
    version = "2.10.5";
  in
  {
    "${version}-x86_64-darwin" = fetchurl {
      url = "${base}/stable/release/${version}/sdk/dartsdk-macos-${x86_64}-release.zip";
      sha256 = "1vb2m25w6v901id9syan9q69fa60sxxd7qpyzq21fn5dpah0g99i";
    };
    "${version}-x86_64-linux" = fetchurl {
      url = "${base}/stable/release/${version}/sdk/dartsdk-linux-${x86_64}-release.zip";
      sha256 = "1mb6m3vxjya1dz47mdna23c2015n3bz8dvz8fwggq6k3zp0a4dsh";
    };
    "${version}-i686-linux" = fetchurl {
      url = "${base}/stable/release/${version}/sdk/dartsdk-linux-${i686}-release.zip";
      sha256 = "10g4qrwvmabrdg4i8y0wq9g7whqcpkdfp05yilflg70ybplrscf7";
    };
    "${version}-aarch64-linux" = fetchurl {
      url = "${base}/stable/release/${version}/sdk/dartsdk-linux-${aarch64}-release.zip";
      sha256 = "0js83wy496swcwia144fhxk872irb5nr6i8558hxabkdrpv1bky5";
    };
  }
}:

assert version != null && version != "";
assert sources != null && (builtins.isAttrs sources);

stdenv.mkDerivation {
  pname = "dart";
  inherit version;

  nativeBuildInputs = [
    unzip
  ];

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
    maintainers = with maintainers; [ grburst thiagokokada ];
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
