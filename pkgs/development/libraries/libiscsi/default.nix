{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libiscsi";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "sahlberg";
    repo = "libiscsi";
    rev = version;
    sha256 = "sha256-idiK9JowKhGAk5F5qJ57X14Q2Y0TbIKRI02onzLPkas=";
  };

  postPatch = ''
    substituteInPlace lib/socket.c \
      --replace "void iscsi_decrement_iface_rr() {" "void iscsi_decrement_iface_rr(void) {"
  '';

  nativeBuildInputs = [ autoreconfHook ];

  # This problem is gone on libiscsi master.
  env.NIX_CFLAGS_COMPILE = toString (lib.optional stdenv.hostPlatform.is32bit "-Wno-error=sign-compare");

  meta = with lib; {
    description = "iscsi client library and utilities";
    homepage = "https://github.com/sahlberg/libiscsi";
    license = licenses.lgpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ misuzu ];
  };
}
