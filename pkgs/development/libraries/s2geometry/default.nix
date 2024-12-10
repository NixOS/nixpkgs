{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  openssl,
  gtest,
}:

stdenv.mkDerivation rec {
  pname = "s2geometry";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "s2geometry";
    rev = "v${version}";
    sha256 = "1mx61bnn2f6bd281qlhn667q6yfg1pxzd2js88l5wpkqlfzzhfaz";
  };

  patches = [
    # Fix build https://github.com/google/s2geometry/issues/165
    (fetchpatch {
      url = "https://github.com/google/s2geometry/commit/a4dddf40647c68cd0104eafc31e9c8fb247a6308.patch";
      sha256 = "0fp3w4bg7pgf5vv4vacp9g06rbqzhxc2fg6i5appp93q6phiinvi";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    openssl
    gtest
  ];

  # Default of C++11 is too low for gtest.
  # In newer versions of s2geometry this can be done with cmakeFlags.
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "CMAKE_CXX_STANDARD 11" "CMAKE_CXX_STANDARD 14"
  '';

  meta = with lib; {
    description = "Computational geometry and spatial indexing on the sphere";
    homepage = "http://s2geometry.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.linux;
  };
}
