{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, googletest
, cereal
, arrayfire
, oneDNN
, mkl
, mpi
, opencl
}:

stdenv.mkDerivation rec {
  pname = "flashlight";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "flashlight";
    repo = "flashlight";
    rev = "v${version}";
    sha256 = "sha256-1RgEBA59SydmwSoNlkaO5lwAwcHlgzI4viSkji8I1U8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    pkg-config
    googletest
    cereal
    arrayfire
    oneDNN
    mkl
    mpi
    opencl
  ];

  # workaround for https://github.com/NixOS/nixpkgs/issues/213585
  # cmake would replace "/opt" with "/var/empty" in
  # https://github.com/flashlight/flashlight/blob/a97cf69db1a2d8a10b61dbf7f900ed3804525e77/flashlight/fl/tensor/backend/jit/CMakeLists.txt#L7
  preConfigure = ''
    fixCmakeFiles() { return; }
  '';

  meta = {
    homepage = "https://github.com/flashlight/wav2letter";
    description = "A C++ standalone library for machine learning";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ milahu ];
    platforms = lib.platforms.unix;
  };
}
