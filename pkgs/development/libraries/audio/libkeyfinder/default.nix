{ lib, stdenv, fetchpatch, fetchFromGitHub, cmake, fftw, catch2 }:

stdenv.mkDerivation rec {
  pname = "libkeyfinder";
  version = "2.2.6";

  src = fetchFromGitHub {
    owner = "mixxxdj";
    repo = "libkeyfinder";
    rev = "v${version}";
    sha256 = "sha256-7w/Wc9ncLinbnM2q3yv5DBtFoJFAM2e9xAUTsqvE9mg=";
  };

  # in main post 2.2.6, see https://github.com/mixxxdj/libkeyfinder/issues/21
  patches = [
    (fetchpatch {
      name = "fix-pkg-config";
      url = "https://github.com/mixxxdj/libkeyfinder/commit/4e1a5022d4c91e3ecfe9be5c3ac7cc488093bd2e.patch";
      sha256 = "08llmgp6r11bq5s820j3fs9bgriaibkhq8r3v2av064w66mwp48x";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ fftw ];

  nativeCheckInputs = [ catch2 ];

  doCheck = true;

  meta = with lib; {
    description = "Musical key detection for digital audio (C++ library)";
    homepage = "https://mixxxdj.github.io/libkeyfinder/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
