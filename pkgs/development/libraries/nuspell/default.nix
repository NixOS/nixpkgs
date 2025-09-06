{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  buildPackages,
  pkg-config,
  icu,
  catch2_3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nuspell";
  version = "5.1.6";

  src = fetchFromGitHub {
    owner = "nuspell";
    repo = "nuspell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U/lHSxpKsBnamf4ikE2aIjEPSU5fxjtuSmhZR0jxMAI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ catch2_3 ];

  propagatedBuildInputs = [ icu ];

  cmakeFlags = [
    "-DBUILD_TESTING=YES"
    "-DBUILD_DOCS=OFF"
  ];

  doCheck = true;

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  passthru = lib.optionalAttrs buildPackages.pandoc.compiler.bootstrapAvailable {
    man = stdenv.mkDerivation {
      pname = "${finalAttrs.pname}-man";
      inherit (finalAttrs) version src meta;
      sourceRoot = "${finalAttrs.src.name}/docs";
      nativeBuildInputs = [
        cmake
        buildPackages.pandoc
      ];
      cmakeFlags = [
        "-DBUILD_MAN=YES"
        "-DBUILD_TOOLS=YES"
      ];
    };
  };

  meta = {
    description = "Free and open source C++ spell checking library";
    mainProgram = "nuspell";
    homepage = "https://nuspell.github.io/";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ fpletz ];
    license = lib.licenses.lgpl3Plus;
    changelog = "https://github.com/nuspell/nuspell/blob/${finalAttrs.src.tag}/CHANGELOG.md";
  };
})
