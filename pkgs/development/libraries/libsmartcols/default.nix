{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, python3, gtk-doc}:

stdenv.mkDerivation rec {
  pname = "libsmartcols";
  version = "2.39.3";

  nativeBuildInputs = [ autoreconfHook pkg-config python3 gtk-doc ];

  src = fetchFromGitHub {
    owner = "karelzak";
    repo = "util-linux";
    rev = "v${version}";
    sha256 = "sha256-X39os2iHqSrrYP6HVHPOkuTfc6vNB3pmsOP3VjW50fI=";
  };

  configureFlags = [ "--disable-all-programs" "--enable-libsmartcols" ];

  buildPhase = ''
    make libsmartcols.la
  '';

  installTargets = [ "install-am" "install-pkgconfigDATA" ];

  meta = {
    description = "smart column output alignment library";
    homepage = "https://github.com/karelzak/util-linux/tree/master/libsmartcols";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ rb2k ];
  };
}

