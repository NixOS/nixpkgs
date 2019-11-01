{ stdenv, fetchFromGitHub, autoreconfHook, libtirpc, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "libnsl";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "thkukuk";
    repo = pname;
    rev = "v${version}";
    sha256 = "1chzqhcgh0yia9js8mh92cmhyka7rh32ql6b3mgdk26n94dqzs8b";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libtirpc ];

  meta = with stdenv.lib; {
    description = "Client interface library for NIS(YP) and NIS+";
    homepage = https://github.com/thkukuk/libnsl;
    license = licenses.lgpl21;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
