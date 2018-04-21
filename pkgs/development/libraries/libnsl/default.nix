{ stdenv, fetchFromGitHub, autoreconfHook, libtirpc, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libnsl-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "thkukuk";
    repo = "libnsl";
    rev = "libnsl-${version}";
    sha256 = "0h8br0gmgw3fp5fmy6bfbj1qlk9hry1ssg25ssjgxbd8spczpscs";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libtirpc ];

  patches = stdenv.lib.optionals stdenv.hostPlatform.isMusl [ ./cdefs.patch ./nis_h.patch ];

  meta = with stdenv.lib; {
    description = "Client interface library for NIS(YP) and NIS+";
    homepage = https://github.com/thkukuk/libnsl;
    license = licenses.lgpl21;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
