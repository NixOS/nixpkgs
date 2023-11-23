{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "utf8cpp";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "nemtrif";
    repo = "utfcpp";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-RzrQ62QEKgEL6rbvLd8nHQQPYb0pkQp/97Jt9CkqpLE=";
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
