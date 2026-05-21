{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  bluez,
}:
stdenv.mkDerivation (finalAttrs: {

  pname = "WiiUse";
  version = "0.15.6";

  src = fetchFromGitHub {
    owner = "wiiuse";
    repo = "wiiuse";
    rev = finalAttrs.version;
    sha256 = "sha256-l2CS//7rx5J3kI32yTSp0BDtP0T5+riLowtnxnfAotc=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
    "lib"
  ];

  patches = [
    # Fix `.pc` files's double prefixes:
    #   https://github.com/wiiuse/wiiuse/pull/153
    (fetchpatch {
      name = "pc-prefix.patch";
      url = "https://github.com/wiiuse/wiiuse/commit/9c774ec0b71fa5119eabed823c35e4c745f3277c.patch";
      hash = "sha256-WEHumCiNzsWfyMl7qu9xrlsNhgNcawdi+EFXf5w8jiE=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ bluez ];

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ bluez ];

  cmakeFlags = [
    "-DBUILD_EXAMPLE_SDL=OFF"
  ]
  ++ [ (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic)) ];

  # On Darwin (and Windows), upstream's CMakeLists.txt forcibly overrides
  # CMAKE_INSTALL_LIBDIR to "lib", ignoring the value passed by the cmake
  # setup hook, so the libraries end up in $out/lib instead of $lib/lib.
  # Move them into the lib output manually.
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $lib/lib
    mv $out/lib/libwiiuse* $lib/lib/
  '';

  meta = {
    description = "Feature complete cross-platform Wii Remote access library";
    mainProgram = "wiiuseexample";
    license = lib.licenses.gpl3Plus;
    homepage = "https://github.com/wiiuse/wiiuse";
    platforms = with lib.platforms; unix;
  };
})
