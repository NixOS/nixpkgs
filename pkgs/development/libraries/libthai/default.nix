{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  installShellFiles,
  pkg-config,
  libdatrie,
}:

stdenv.mkDerivation rec {
  pname = "libthai";
  version = "0.1.29";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://github.com/tlwg/libthai/releases/download/v${version}/libthai-${version}.tar.xz";
    sha256 = "sha256-/IDMfctQ4RMCtBfOvSTy0wqLmHKS534AMme5EA0PS80=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
    (lib.getBin libdatrie)
    pkg-config
  ];

  buildInputs = [ libdatrie ];

  postInstall = ''
    installManPage man/man3/*.3
  '';

  meta = with lib; {
    homepage = "https://linux.thai.net/projects/libthai/";
    description = "Set of Thai language support routines";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
    pkgConfigModules = [ "libthai" ];
  };
}
