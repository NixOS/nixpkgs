{ lib, stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "cmark-gfm";
  version = "0.29.0.gfm.2";

  src = fetchFromGitHub {
    owner = "github";
    repo = "cmark-gfm";
    rev = version;
    sha256 = "sha256-8PjG87hR66ozKx+PSuKi0vHIoKICHSLdl2cKUYf+5m8=";
  };

  nativeBuildInputs = [ cmake ];
  # tests load the library dynamically which for unknown reason failed
  doCheck = false;

  meta = with lib; {
    description = "GitHub's fork of cmark, a CommonMark parsing and rendering library and program in C";
    homepage = "https://github.com/github/cmark-gfm";
    maintainers = with maintainers; [ cyplo ];
    platforms = platforms.unix;
    license = licenses.bsd2;
  };
}
