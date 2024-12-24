{
  cmake,
  fetchFromGitHub,
  fetchpatch2,
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
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-h5tbO0Rv2tZezY58yUbyRVpsfRjY3i+5TPkkxr6La8M=";
  };

  patches = [
    # TODO: Remove this patch at the next update
    # https://github.com/marzer/tomlplusplus/pull/233
    (fetchpatch2 {
      name = "tomlplusplus-install-example-programs.patch";
      url = "https://github.com/marzer/tomlplusplus/commit/8128eb632325d1820f4d17dd8250dcda6ab07743.patch";
      hash = "sha256-7m2P+e1/OASHrzm9LSy6RnayS/kGxFC82xOyGBGXeG0=";
    })
  ];

  nativeBuildInputs = [
    meson
    cmake
    ninja
    pkg-config
  ];

  checkInputs = [
    glibcLocales
  ];

  mesonFlags = [
    "-Dbuild_tests=${lib.boolToString finalAttrs.doCheck}"
    "-Dbuild_examples=true"
  ];

  # almost all tests fail on Darwin with the following exception:
  # libc++abi: terminating due to uncaught exception of type std::runtime_error: collate_byname<char>::collate_byname failed to construct for
  doCheck = !stdenv.hostPlatform.isDarwin;

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
