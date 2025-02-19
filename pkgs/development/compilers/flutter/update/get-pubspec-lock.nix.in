{ flutterPackages
, stdenv
, cacert
,
}:
let
  flutterCompactVersion = "@flutter_compact_version@";
  inherit (flutterPackages."v${flutterCompactVersion}") dart;
in
stdenv.mkDerivation {
  name = "pubspec-lock";
  src = @flutter_src@;

  nativeBuildInputs = [ dart ];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "@hash@";

  buildPhase = ''
    cd ./packages/flutter_tools

    export HOME="$(mktemp -d)"
    dart --root-certs-file=${cacert}/etc/ssl/certs/ca-bundle.crt pub get -v
  '';

  installPhase = ''
    cp -r ./pubspec.lock $out
  '';
}
