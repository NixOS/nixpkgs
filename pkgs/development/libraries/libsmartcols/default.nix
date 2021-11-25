{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, python3, gtk-doc}:

stdenv.mkDerivation rec {
  name = "libsmartcols";
  version = "v2.36.1";

  nativeBuildInputs = [ autoreconfHook pkg-config python3 gtk-doc ];

  src = fetchFromGitHub {
    owner = "karelzak";
    repo = "util-linux";
    rev = version;
    sha256 = "0z7nv054pqhlihqiw0vk3h40j0cxk1yxf8zzh0ddmvk6834cnyxs";
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

