{ lib
, stdenv
, fetchFromGitHub
, zig_0_11
, testers
, tigerbeetle
, nix-update-script
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tigerbeetle";
  version = "0.14.171";

  src = fetchFromGitHub {
    owner = "tigerbeetle";
    repo = "tigerbeetle";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-MjsNQarRXsrWKJZ2aBi/Wc2HAYm3isLBNw81a75+nhc=";
  };

  nativeBuildInputs = [ zig_0_11.hook ];

  zigBuildFlags = [
    "-Dgit-commit=0000000000000000000000000000000000000000"
    "-Dversion=${finalAttrs.version}"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = tigerbeetle;
      command = "tigerbeetle version";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://tigerbeetle.com/";
    description = "A financial accounting database designed to be distributed and fast";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ danielsidhion ];
    platforms = lib.platforms.unix;
    mainProgram = "tigerbeetle";
  };
})
