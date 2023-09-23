{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  python3,
  gtest,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "numcpp";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "dpilger26";
    repo = "NumCpp";
    rev = "Version_${finalAttrs.version}";
    hash = "sha256-IAku1bcaMkawZxpQbvxcS6VX07ogw4UGo1DX2Wa8xwU=";
  };

  nativeCheckInputs = [gtest python3];

  nativeBuildInputs = [cmake];

  buildInputs = [boost];

  cmakeFlags = lib.optionals finalAttrs.finalPackage.doCheck [
    "-DBUILD_TESTS=ON"
    "-DBUILD_MULTIPLE_TEST=ON"
  ];

  doCheck = !stdenv.isDarwin && !stdenv.hostPlatform.isStatic;

  postInstall = ''
    substituteInPlace $out/share/NumCpp/cmake/NumCppConfig.cmake \
      --replace "\''${PACKAGE_PREFIX_DIR}/" ""
  '';

  NIX_CFLAGS_COMPILE="-Wno-error";

  meta = with lib; {
    description = "A Templatized Header Only C++ Implementation of the Python NumPy Library";
    homepage = "https://github.com/dpilger26/NumCpp";
    license = licenses.mit;
    maintainers = with maintainers; [spalf];
    platforms = platforms.unix;
  };
})
