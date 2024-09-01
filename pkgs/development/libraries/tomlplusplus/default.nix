{
  cmake,
  fetchFromGitHub,
  glibcLocales,
  lib,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tomlplusplus";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "marzer";
    repo = "tomlplusplus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-h5tbO0Rv2tZezY58yUbyRVpsfRjY3i+5TPkkxr6La8M=";
  };

  nativeBuildInputs = [
    meson
    cmake
    ninja
    pkg-config
  ];

  checkInputs = [
    glibcLocales
  ];

  doCheck = true;
  mesonFlags = [ "-Dbuild_tests=${lib.boolToString finalAttrs.doCheck}" ];

  passthru = {
    updateScript = nix-update-script { };
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    homepage = "https://github.com/marzer/tomlplusplus";
    description = "Header-only TOML config file parser and serializer for C++17";
    license = licenses.mit;
    maintainers = with maintainers; [ Scrumplex ];
    pkgConfigModules = [ "tomlplusplus" ];
    platforms = platforms.unix;
  };
})
