{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  bluez,
}:
stdenv.mkDerivation rec {

  pname = "WiiUse";
  version = "0.15.6";

  src = fetchFromGitHub {
    owner = "wiiuse";
    repo = "wiiuse";
    rev = version;
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

  meta = with lib; {
    description = "Feature complete cross-platform Wii Remote access library";
    mainProgram = "wiiuseexample";
    license = licenses.gpl3Plus;
    homepage = "https://github.com/wiiuse/wiiuse";
    maintainers = with maintainers; [ shamilton ];
    platforms = with platforms; unix;
  };
}
