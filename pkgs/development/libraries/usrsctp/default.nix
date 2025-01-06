{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "usrsctp";
  version = "0.9.5.0";

  src = fetchFromGitHub {
    owner = "sctplab";
    repo = "usrsctp";
    rev = version;
    sha256 = "10ndzkip8blgkw572n3dicl6mgjaa7kygwn3vls80liq92vf1sa9";
  };

  patches = [
    # usrsctp fails to build with clang 15+ due to set but unused variable and missing prototype
    # errors. These issues are fixed in the master branch, but a new release with them has not
    # been made. The following patch can be dropped once a release has been made.
    ./clang-fix-build.patch
  ];

  nativeBuildInputs = [ cmake ];

  # https://github.com/sctplab/usrsctp/issues/662
  postPatch = ''
    substituteInPlace usrsctplib/CMakeLists.txt \
      --replace '$'{exec_prefix}/'$'{CMAKE_INSTALL_LIBDIR} '$'{CMAKE_INSTALL_FULL_LIBDIR} \
      --replace '$'{prefix}/'$'{CMAKE_INSTALL_INCLUDEDIR} '$'{CMAKE_INSTALL_FULL_INCLUDEDIR}
  '';

  meta = with lib; {
    homepage = "https://github.com/sctplab/usrsctp";
    description = "Portable SCTP userland stack";
    maintainers = with maintainers; [ misuzu ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
