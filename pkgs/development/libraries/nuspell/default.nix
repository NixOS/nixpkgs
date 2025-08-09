{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  buildPackages,
  pkg-config,
  icu,
  catch2_3,
  enableManpages ? buildPackages.pandoc.compiler.bootstrapAvailable,
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
  ]
  ++ lib.optionals enableManpages [
    buildPackages.pandoc
  ];

  buildInputs = [ catch2_3 ];

  propagatedBuildInputs = [ icu ];

  cmakeFlags = [
    "-DBUILD_TESTING=YES"
  ]
  ++ lib.optionals (!enableManpages) [
    "-DBUILD_DOCS=OFF"
  ];

  doCheck = true;

  outputs = [
    "out"
    "lib"
    "dev"
  ];

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
