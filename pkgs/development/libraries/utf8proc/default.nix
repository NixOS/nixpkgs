{ lib, stdenv, fetchFromGitHub, cmake
  # passthru.tests
, tmux
, fcft
, arrow-cpp
}:

stdenv.mkDerivation rec {
  pname = "utf8proc";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "JuliaStrings";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/lSD78kj133rpcSAOh8T8XFW/Z0c3JKkGQM5Z6DcMtU=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DUTF8PROC_ENABLE_TESTING=ON"
  ];

  doCheck = true;

  passthru.tests = {
    inherit fcft tmux arrow-cpp;
  };

  meta = with lib; {
    description = "A clean C library for processing UTF-8 Unicode data";
    homepage = "https://juliastrings.github.io/utf8proc/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.ftrvxmtrx maintainers.sternenseemann ];
  };
}
