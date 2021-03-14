{ lib, stdenv, fetchFromGitHub, cmake, ninja, libuuid, libossp_uuid, gtest }:

stdenv.mkDerivation rec {
  pname = "lib3mf";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "3MFConsortium";
    repo = pname;
    rev = "v${version}";
    sha256 = "0w4d9zvl95g1x3r5nyd6cr27g6fwhhwaivh8a5r1xs5l6if21x19";
  };

  nativeBuildInputs = [ cmake ninja ];

  buildInputs = if stdenv.isDarwin then [ libossp_uuid ] else [ libuuid ];

  postPatch = ''
    rmdir Tests/googletest
    ln -s ${gtest.src} Tests/googletest

    # fix libdir=''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@
    sed -i 's,=''${\(exec_\)\?prefix}/,=,' lib3MF.pc.in
  '';

  meta = with lib; {
    description = "Reference implementation of the 3D Manufacturing Format file standard";
    homepage = "https://3mf.io/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
