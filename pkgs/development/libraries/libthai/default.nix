{ lib, stdenv, fetchurl, makeWrapper, installShellFiles, pkg-config, libdatrie }:

stdenv.mkDerivation rec {
  pname = "libthai";
  version = "0.1.28";

  src = fetchurl {
    url = "https://github.com/tlwg/libthai/releases/download/v${version}/libthai-${version}.tar.xz";
    sha256 = "04g93bgxrcnay9fglpq2lj9nr7x1xh06i60m7haip8as9dxs3q7z";
  };

  strictDeps = true;

  nativeBuildInputs = [ installShellFiles libdatrie pkg-config ];

  buildInputs = [ libdatrie ];

  postInstall = ''
    installManPage man/man3/*.3
  '';

  meta = with lib; {
    homepage = "https://linux.thai.net/projects/libthai/";
    description = "Set of Thai language support routines";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
