{
  stdenv,
  lib,
  swift,
  swiftpm,
  swiftpm2nix,
  fetchFromGitHub,
  pkg-config,
  gd,
  libexif,
  libiptcdata,
  zlib,
  libpng,
  nix-update-script,
  nixosTests,
}:

let
  # Pass the generated files to the helper.
  generated = swiftpm2nix.helpers ./nix;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vernissage-server";
  version = "1.43.0";

  src = fetchFromGitHub {
    owner = "VernissageApp";
    repo = "VernissageServer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q0jnEnI5vm3RzODqpmk6vN31nOAu+UFsx+wWsv94/xE=";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      commit=$(git rev-parse --short HEAD) && sed -i -e "s/buildx/$commit/g" Sources/VernissageServer/Constants.swift
    '';
  };

  strictDeps = true;

  # Including SwiftPM as a nativeBuildInput provides a buildPhase for you.
  # This by default performs a release build using SwiftPM, essentially:
  # swift build -c release
  nativeBuildInputs = [
    swift
    swiftpm
    pkg-config
    gd
    libexif
    libiptcdata
    zlib
    libpng
  ];

  buildInputs = [
    gd
    libexif
    libiptcdata
    zlib
  ];

  # The helper provides a configure snippet that will prepare all dependencies
  # in the correct place, where SwiftPM expects them.
  configurePhase = ''
    runHook preConfigure

    ${generated.configure}

    runHook postConfigure
  '';

  # Including swiftpm in your nativeBuildInputs also provides a default checkPhase.
  # This essentially runs:
  # swift test -c release
  # doCheck = true;
  # Tests are not passing

  installPhase = ''
    runHook preInstall

    # This is a special function that invokes swiftpm to find the location
    # of the binaries it produced.
    binPath="$(swiftpmBinPath)"
    # Now perform any installation steps.
    mkdir -p $out/bin
    cp -r Resources $out/Resources
    cp $binPath/VernissageServer $out/bin/

    runHook postInstall
  '';

  __structuredAttrs = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests) vernissage;
    };
  };

  meta = {
    description = "Vernissage API server";
    homepage = "https://github.com/VernissageApp/VernissageServer";
    changelog = "https://github.com/VernissageApp/VernissageServer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Cameo007 ];
    mainProgram = "VernissageServer";
  };
})
