{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "utf8cpp";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "nemtrif";
    repo = "utfcpp";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-l5sneFsuvPDIRni2x+aR9fmQ9bzXNnIiP9EzZ63sNtg=";
  };

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=None"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DINSTALL_GTEST=OFF"
  ];

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/nemtrif/utfcpp";
    description = "UTF-8 with C++ in a Portable Way";
    license = licenses.free;
    maintainers = with maintainers; [ jobojeha ];
    platforms = platforms.all;
  };
}
