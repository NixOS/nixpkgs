{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, libgcrypt, libbaseencode }:

stdenv.mkDerivation rec {
  pname = "libcotp";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "paolostivanin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AMLnUFLDL592zcbVN8yaQeOJQWDLUUG+6aKh4paPGlE=";
  };

  buildInputs = [ libbaseencode libgcrypt ];
  nativeBuildInputs = [ cmake pkg-config ];

  # https://github.com/paolostivanin/libcotp/issues/32
  postPatch = ''
    substituteInPlace cotp.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  meta = with lib; {
    description = "C library that generates TOTP and HOTP";
    homepage = "https://github.com/paolostivanin/libcotp";
    license = licenses.asl20;
    maintainers = with maintainers; [ alexbakker ];
  };
}
