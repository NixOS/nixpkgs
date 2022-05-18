{
  stdenv, lib, fetchurl,
  cmake, perl,
}:

stdenv.mkDerivation rec {
  pname = "rinutils";
  version = "0.10.0";

  meta = with lib; {
    homepage = "https://github.com/shlomif/rinutils";
    license = licenses.mit;
  };

  src = fetchurl {
    url = "https://github.com/shlomif/${pname}/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-cNifCoRk+PSU8zcEt8k5bn/KOS6Kr6pEZXEMGjiemAY=";
  };

  nativeBuildInputs = [ cmake perl ];

  # https://github.com/shlomif/rinutils/issues/5
  postPatch = ''
    substituteInPlace librinutils.pc.in \
      --replace '$'{exec_prefix}/@RINUTILS_INSTALL_MYLIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';
}
