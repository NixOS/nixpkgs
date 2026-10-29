{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  bluez,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wiiuse";
  version = "0.15.7";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "wiiuse";
    repo = "wiiuse";
    tag = finalAttrs.version;
    hash = "sha256-kB/iGzpO9lin3bTDlXBwZEdEg5UOivU1mnWDj/E44k4=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
    "lib"
  ];

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ bluez ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_EXAMPLE_SDL" false)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  # On Darwin (and Windows), upstream's CMakeLists.txt forcibly overrides
  # CMAKE_INSTALL_LIBDIR to "lib", ignoring the value passed by the cmake
  # setup hook, so the libraries end up in $out/lib instead of $lib/lib.
  # Move them into the lib output manually.
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $lib/lib
    mv $out/lib/libwiiuse* $lib/lib/
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Feature complete cross-platform Wii Remote access library";
    homepage = "https://github.com/wiiuse/wiiuse";
    changelog = "https://github.com/wiiuse/wiiuse/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "wiiuseexample";
  };
})
