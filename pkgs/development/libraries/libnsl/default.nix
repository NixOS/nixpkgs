{ lib, stdenv, fetchFromGitHub, autoreconfHook, libtirpc, pkg-config }:

stdenv.mkDerivation rec {
  pname = "libnsl";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "thkukuk";
    repo = pname;
    rev = "v${version}";
    sha256 = "1dayj5i4bh65gn7zkciacnwv2a0ghm6nn58d78rsi4zby4lyj5w5";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libtirpc ];

  meta = with lib; {
    description = "Client interface library for NIS(YP) and NIS+";
    homepage = "https://github.com/thkukuk/libnsl";
    license = licenses.lgpl21;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
