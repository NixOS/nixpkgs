{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "utf8cpp";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "nemtrif";
    repo = "utfcpp";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-VDfJchuXksm5L5knBnthhrj9fqOb+RWUd/yZCeV6LPU=";
  };

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  nativeBuildInputs = [ cmake ];

  # Tests fail on darwin, probably due to a bug in the test framework:
  # https://github.com/nemtrif/utfcpp/issues/84
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    homepage = "https://github.com/nemtrif/utfcpp";
    changelog = "https://github.com/nemtrif/utfcpp/releases/tag/v${version}";
    description = "UTF-8 with C++ in a Portable Way";
    license = licenses.boost;
    maintainers = with maintainers; [ jobojeha ];
    platforms = platforms.all;
  };
}
