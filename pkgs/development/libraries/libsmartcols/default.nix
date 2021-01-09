{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, python3 }:

stdenv.mkDerivation rec {
  name = "libsmartcols";
  version = "v2.36.1";

  nativeBuildInputs = [ autoreconfHook pkgconfig python3 ];

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
    homepage = https://github.com/karelzak/util-linux/tree/master/libsmartcols;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ rb2k ];
  };
}

