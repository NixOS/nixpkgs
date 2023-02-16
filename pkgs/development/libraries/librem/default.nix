{ lib, stdenv, fetchFromGitHub, zlib, openssl, libre }:
stdenv.mkDerivation rec {
  version = "2.10.0";
  pname = "librem";
  src = fetchFromGitHub {
    owner = "baresip";
    repo = "rem";
    rev = "v${version}";
    sha256 = "sha256-wyzpx0WjQLA8UKx4S6QOETMehf51Af5napZsxMXttmM=";
  };
  buildInputs = [ zlib openssl libre ];
  makeFlags = [
    "LIBRE_MK=${libre}/share/re/re.mk"
    "LIBRE_INC=${libre}/include/re"
    "PREFIX=$(out)"
  ]
  ++ lib.optional (stdenv.cc.cc != null) "SYSROOT_ALT=${lib.getDev stdenv.cc.cc}"
  ++ lib.optional (stdenv.cc.libc != null) "SYSROOT=${lib.getDev stdenv.cc.libc}"
  ;
  meta = {
    description = "A library for real-time audio and video processing";
    homepage = "https://github.com/baresip/rem";
    maintainers = with lib.maintainers; [ elohmeier raskin ];
    license = lib.licenses.bsd3;
  };
}
