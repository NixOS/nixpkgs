{ lib, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libglut
, lapack
, libusb1
, blas
, zlib
, eigen
}:

stdenv.mkDerivation rec {
  pname = "libsurvive";
  version = "1.01";

  src = fetchFromGitHub {
    owner = "cntools";
    repo = pname;
    rev = "v${version}";
    # Fixes 'Unknown CMake command "cnkalman_generate_code"'
    fetchSubmodules = true;
    hash = "sha256-NcxdTKra+YkLt/iu9+1QCeQZLV3/qlhma2Ns/+ZYVsk=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    libglut
    lapack
    libusb1
    blas
    zlib
    eigen
  ];

  # https://github.com/cntools/libsurvive/issues/272
  postPatch = ''
    substituteInPlace survive.pc.in \
      libs/cnkalman/cnkalman.pc.in libs/cnkalman/libs/cnmatrix/cnmatrix.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';

  meta = with lib; {
    description = "Open Source Lighthouse Tracking System";
    homepage = "https://github.com/cntools/libsurvive";
    license = licenses.mit;
    maintainers = with maintainers; [ expipiplus1 prusnak ];
    platforms = platforms.linux;
  };
}
