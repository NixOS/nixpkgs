{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "tinyobjloader";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "tinyobjloader";
    repo = "tinyobjloader";
    rev = "v${version}";
    sha256 = "sha256-BNffbicnLTGK2GQ2/bB328LFU9fqHxrpAVj2hJaekWc=";
  };

  nativeBuildInputs = [ cmake ];

  # https://github.com/tinyobjloader/tinyobjloader/issues/336
  postPatch = ''
    substituteInPlace tinyobjloader.pc.in \
      --replace '$'{prefix}/@TINYOBJLOADER_LIBRARY_DIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@TINYOBJLOADER_INCLUDE_DIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  meta = with lib; {
    homepage = "https://github.com/tinyobjloader/tinyobjloader";
    description = "Tiny but powerful single file wavefront obj loader";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
