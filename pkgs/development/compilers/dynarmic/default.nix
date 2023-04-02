{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, pkg-config
, xbyak
, zydis
}:

stdenv.mkDerivation rec {
  pname = "dynarmic";
  version = "6.4.6";

  src = fetchFromGitHub {
    owner = "merryhime";
    repo = "dynarmic";
    rev = version;
    hash = "sha256-DIcyI0Sqw+J3Dhqk4MugIXsSZmSS0PaGjSqIfmVuQXc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    xbyak
    zydis
  ];

  cmakeFlags = [
    "-DDYNARMIC_WARNINGS_AS_ERRORS=OFF"
    "-DDYNARMIC_USE_BUNDLED_EXTERNALS=OFF"
  ];

  # We want to provide the dependencies ourselves.
  prePatch = ''
    rm -rf externals/*
    sed -i '/add_subdirectory(externals)/d' CMakeLists.txt
  '';
  dontFixCmake = true;

  meta = with lib; {
    description = "An ARM dynamic recompiler";
    homepage = "https://github.com/merryhime/dynarmic";
    license = licenses.bsd0;
    maintainers = with maintainers; [ kranzes ];
  };
}
