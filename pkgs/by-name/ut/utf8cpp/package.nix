{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "utf8cpp";
  version = "4.0.9";

  src = fetchFromGitHub {
    owner = "nemtrif";
    repo = "utfcpp";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-0FgMKHymFOA3BM7VS8US2is8TmQlL/wWj4nSRihqcDo=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/nemtrif/utfcpp";
    changelog = "https://github.com/nemtrif/utfcpp/releases/tag/v${finalAttrs.version}";
    description = "UTF-8 with C++ in a Portable Way";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ jobojeha ];
    platforms = lib.platforms.all;
  };
})
