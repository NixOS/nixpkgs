{
  lib,
  pkgs,
  swift,
  swiftpm,
  swiftpm2nix,
  swift-corelibs-libdispatch,
  eventName ? "38C3",
  additionalAwords ? "",
  additionalPatches ? [ ],
  fetchFromGitHub,
  nixosTests,
}:
let
  generated = swiftpm2nix.helpers ./nix;
  stdenv = pkgs.clangStdenv;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xota";
  version = "0.0.1";
  env.LD_LIBRARY_PATH = lib.optionalString (
    !stdenv.hostPlatform.isDarwin
  ) "${pkgs.swiftPackages.Dispatch}/lib";

  src = fetchFromGitHub {
    owner = "nischu";
    repo = "xOTA";
    rev = "main";
    hash = "sha256-XmSvflrvDOYBC68hL/pmc7TKgqcQTFwmCyr4mujYSAM=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
    swift-corelibs-libdispatch
    pkgs.libz
  ];

  patches = [
    ./default.patch
  ]
  ++ additionalPatches;

  postPatch = ''
    substituteInPlace Sources/App/configure.swift --replace-fail "// 38C3 specific:" "${additionalAwords}"
    substituteInPlace Sources/App/configure.swift --replace-fail 38C3 ${eventName}
    substituteInPlace Sources/App/configure.swift --replace-fail 38c3.totawatch.de ${lib.strings.toLower eventName}.totawatch.de
    substituteInPlace Resources/Views/rules.leaf --replace 38C3 ${eventName}
  '';
  configurePhase = ''
    runHook preConfigure

    ${generated.configure}

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    # This is a special function that invokes swiftpm to find the location
    # of the binaries it produced.
    binPath="$(swiftpmBinPath)"
    # Now perform any installation steps.
    mkdir -p $out/bin
    cp $binPath/xOTA_App $out/bin/
    find -L $binPath -regex '.*\.resources$' -exec cp -Ra {} $out/ \;
    [ -d ./Public ] && { mv ./Public $out/Public; } || true
    [ -d ./Resources ] && { mv ./Resources $out/Resources; } || true

    runHook postInstall
  '';

  passthru.tests = { inherit (nixosTests) xota; };

  meta = {
    description = ''
      xOTA is a platform to host temporary amateur radio activies that have similar mechanics as Islands on the Air (IOTA) or Parks on the Air (POTA). It has been used the first time at 37C3 in Hamburg in December 2023 as Toilets on the Air (TOTA).
    '';
    license = lib.licenses.mit;
    homepage = "https://github.com/nischu/xOTA";
    platforms = swift.meta.platforms;
    maintainers = with lib.maintainers; [ haennetz ];
  };
})
