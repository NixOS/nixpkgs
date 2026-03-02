{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "utfcpp";
  version = "4.0.9";

  src = fetchFromGitHub {
    owner = "nemtrif";
    repo = "utfcpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0FgMKHymFOA3BM7VS8US2is8TmQlL/wWj4nSRihqcDo=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    (lib.cmakeBool "UTF8CPP_ENABLE_TESTS" true)
  ];
  doCheck = true;

  meta = {
    description = "UTF-8 with C++ in a Portable Way";
    homepage = "https://github.com/nemtrif/utfcpp";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "utfcpp";
    platforms = lib.platforms.all;
  };
})
