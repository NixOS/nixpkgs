{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "utf8cpp";
  version = "4.0.5";

  src = fetchFromGitHub {
    owner = "nemtrif";
    repo = "utfcpp";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-Z27/31obVErsmW1b1SVcr45nKlFu01RqqpTMwS0LqJ8=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/nemtrif/utfcpp";
    changelog = "https://github.com/nemtrif/utfcpp/releases/tag/v${version}";
    description = "UTF-8 with C++ in a Portable Way";
    license = licenses.boost;
    maintainers = with maintainers; [ jobojeha ];
    platforms = platforms.all;
  };
}
