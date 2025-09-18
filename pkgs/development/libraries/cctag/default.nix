{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  boost,
  eigen,
  opencv,
  tbb,

  avx2Support ? stdenv.hostPlatform.avx2Support,
}:

stdenv.mkDerivation rec {
  pname = "cctag";
  version = "1.0.4";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "alicevision";
    repo = "CCTag";
    rev = "v${version}";
    hash = "sha256-M35KGTTmwGwXefsFWB2UKAKveUQyZBW7V8ejgOAJpXk=";
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
    ./cmake-no-apple-rpath.patch
  ];

  # darwin boost doesn't have math_c99 libraries
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace CMakeLists.txt --replace-warn ";math_c99" ""
    substituteInPlace src/CMakeLists.txt --replace-warn "Boost::math_c99" ""
  '';

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    tbb
  ];

  buildInputs = [
    boost
    eigen
    opencv.cxxdev
  ];

  doCheck = true;

  meta = with lib; {
    description = "Detection of CCTag markers made up of concentric circles";
    homepage = "https://cctag.readthedocs.io";
    downloadPage = "https://github.com/alicevision/CCTag";
    license = licenses.mpl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ tmarkus ];
  };
}
