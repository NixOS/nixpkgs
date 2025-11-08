{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "utf8cpp";
  version = "4.0.8";

  src = fetchFromGitHub {
    owner = "nemtrif";
    repo = "utfcpp";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-9lfs2tqsSDbf1appDC+S3qdmS4DipHhXoiJQluKytbM=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/nemtrif/utfcpp";
    changelog = "https://github.com/nemtrif/utfcpp/releases/tag/v${version}";
    description = "UTF-8 with C++ in a Portable Way";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ jobojeha ];
    platforms = lib.platforms.all;
  };
}
