{ lib
, stdenv
, fetchFromGitHub

, cmake
, boost179
, eigen
, opencv
, tbb

, avx2Support ? stdenv.hostPlatform.avx2Support
}:

stdenv.mkDerivation rec {
  pname = "cctag";
  version = "1.0.3";

  outputs = [ "lib" "dev" "out" ];

  src = fetchFromGitHub {
    owner = "alicevision";
    repo = "CCTag";
    rev = "v${version}";
    hash = "sha256-foB+e7BCuUucyhN8FsI6BIT3/fsNLTjY6QmjkMWZu6A=";
  };

  cmakeFlags = [
    # Feel free to create a PR to add CUDA support
    "-DCCTAG_WITH_CUDA=OFF"

    "-DCCTAG_ENABLE_SIMD_AVX2=${if avx2Support then "ON" else "OFF"}"

    "-DCCTAG_BUILD_TESTS=${if doCheck then "ON" else "OFF"}"
    "-DCCTAG_BUILD_APPS=OFF"
  ];

  patches = [
    ./cmake-install-include-dir.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    tbb
  ];

  buildInputs = [
    boost179
    eigen
    opencv.cxxdev
  ];

  # Tests are broken on Darwin (linking issue)
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "Detection of CCTag markers made up of concentric circles";
    homepage = "https://cctag.readthedocs.io";
    downloadPage = "https://github.com/alicevision/CCTag";
    license = licenses.mpl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ tmarkus ];
  };
}
