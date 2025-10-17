{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
}:
stdenv.mkDerivation rec {
  pname = "tango-idl";
  version = "6.0.4";

  src = fetchFromGitLab {
    owner = "tango-controls";
    repo = "tango-idl";
    tag = version;
    hash = "sha256-etXjey4X5mNCHLtu3TyQv0S9uP4BSfZVNN8YDc/fp68=";
  };

  postPatch = ''
    # https://github.com/NixOS/nixpkgs/issues/144170
    substituteInPlace cmake/tangoidl.pc.cmake \
        --replace-fail '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Tango CORBA IDL file";
    homepage = "https://gitlab.com/tango-controls/tango-idl";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.gilice ];
  };
}
