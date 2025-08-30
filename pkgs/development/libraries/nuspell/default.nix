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

stdenv.mkDerivation rec {
  pname = "nuspell";
  version = "5.1.6";

  src = fetchFromGitHub {
    owner = "nuspell";
    repo = "nuspell";
    rev = "v${version}";
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
      pname = "${pname}-man";
      inherit version src meta;
      sourceRoot = "${src.name}/docs";
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

  meta = with lib; {
    description = "Free and open source C++ spell checking library";
    mainProgram = "nuspell";
    homepage = "https://nuspell.github.io/";
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
    license = licenses.lgpl3Plus;
    changelog = "https://github.com/nuspell/nuspell/blob/v${version}/CHANGELOG.md";
  };
}
