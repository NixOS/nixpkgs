{ lib, stdenv, fetchFromGitHub, gfortran
, python3, util-linux, which

, enableStatic ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "libxsmm";
  version = "1.16.3";

  src = fetchFromGitHub {
    owner = "hfp";
    repo = "libxsmm";
    rev = version;
    sha256 = "sha256-PpMiD/PeQ0pe5hqFG6VFHWpR8y3wnO2z1dJfHHeItlQ=";
  };

  outputs = [ "out" "dev" "doc" ];
  nativeBuildInputs = [
    gfortran
    python3
    util-linux
    which
  ];

  enableParallelBuilding = true;

  dontConfigure = true;

  makeFlags = let
    static = if enableStatic then "1" else "0";
  in [
    "OMP=1"
    "PREFIX=$(out)"
    "STATIC=${static}"
  ];

  postInstall = ''
    mkdir -p $dev/lib/pkgconfig
    mv $out/lib/*.pc $dev/lib/pkgconfig

    moveToOutput "share/libxsmm" "$doc"
  '';

  prePatch = ''
    patchShebangs .
  '';

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "Library targeting Intel Architecture for specialized dense and sparse matrix operations, and deep learning primitives";
    license = licenses.bsd3;
    homepage = "https://github.com/hfp/libxsmm";
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ chessai ];
  };
}
