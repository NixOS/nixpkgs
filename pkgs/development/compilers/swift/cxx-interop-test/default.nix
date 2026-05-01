{
  lib,
  stdenv,
  swift,
  swiftpm,
  swiftPackages,
}:

swiftPackages.stdenv.mkDerivation (finalAttrs: {
  name = "swift-cxx-interop-test";

  src = ./src;

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  installPhase = ''
    runHook preInstall

    binPath="$(swiftpmBinPath)"
    mkdir -p -- "$out/bin"
    cp -- "$binPath/${finalAttrs.meta.mainProgram}" "$out/bin"

    runHook postInstall
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    "$out/bin/${finalAttrs.meta.mainProgram}" | grep 'Hello, world!'

    runHook postInstallCheck
  '';

  doInstallCheck = true;

  env = {
    # Gross hack copied from `protoc-gen-swift` :(
    LD_LIBRARY_PATH = lib.optionalString stdenv.hostPlatform.isLinux (
      lib.makeLibraryPath [
        swiftPackages.Dispatch
      ]
    );
  };

  meta = {
    inherit (swift.meta)
      team
      platforms
      badPlatforms
      ;
    license = lib.licenses.mit;
    mainProgram = "CxxInteropTest";
  };
})
