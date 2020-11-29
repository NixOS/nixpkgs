{ stdenv, fetchurl, unzip, channel ? "stable" }:

with stdenv.lib;

let
  source =
    let
      sources = builtins.fromJSON (builtins.readFile ./sources.json);
      matches = x: x.channel == channel && stdenv.hostPlatform.system == x.platform;
    in
      findFirst matches
        (throw "unsupported channel/system: ${channel}/${stdenv.hostPlatform.system}")
        sources;

in

stdenv.mkDerivation {
  pname = "dart";
  inherit (source) version;

  nativeBuildInputs = [
    unzip
  ];

  src = fetchurl {
    inherit (source) url sha256;
  };

  installPhase = ''
    mkdir -p $out
    cp -R * $out/
    echo $libPath
    find $out/bin -executable -type f -exec patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) {} \;
  '';

  libPath = makeLibraryPath [ stdenv.cc.cc ];

  dontStrip = true;

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.dartlang.org/";
    maintainers = with maintainers; [ grburst ];
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
