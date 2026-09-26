{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "utf8cpp";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "nemtrif";
    repo = "utfcpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vc7nKVVZ/h6q+dQUNiuXnkcqX7L2CkG6WUiybLNXAjU=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "UTF8CPP_ENABLE_TESTS" true)
  ];
  doCheck = true;

  meta = {
    homepage = "https://github.com/nemtrif/utfcpp";
    changelog = "https://github.com/nemtrif/utfcpp/releases/tag/v${finalAttrs.version}";
    description = "UTF-8 with C++ in a Portable Way";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [
      jobojeha
      doronbehar
    ];
    platforms = lib.platforms.all;
  };
})
