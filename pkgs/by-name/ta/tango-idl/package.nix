{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
}:
stdenv.mkDerivation {
  pname = "tango-idl";
  version = "6.0.4";
  src = fetchFromGitLab {
    owner = "tango-controls";
    repo = "tango-idl";
    rev = "6.0.4";
    hash = "sha256-etXjey4X5mNCHLtu3TyQv0S9uP4BSfZVNN8YDc/fp68=";
  };
  nativeBuildInputs = [ cmake ];
  postPatch = ''
    # https://github.com/NixOS/nixpkgs/issues/144170
    substituteInPlace cmake/tangoidl.pc.cmake \
        --replace-warn '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';

  meta = {
    description = "Tango CORBA IDL file";
    homepage = "https://gitlab.com/tango-controls/tango-idl";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.gilice ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
