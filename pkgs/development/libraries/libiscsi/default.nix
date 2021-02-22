{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libiscsi";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "sahlberg";
    repo = "libiscsi";
    rev = version;
    sha256 = "0ajrkkg5awmi8m4b3mha7h07ylg18k252qprvk1sgq0qbyd66zy7";
  };

  nativeBuildInputs = [ autoreconfHook ];

  # This problem is gone on libiscsi master.
  NIX_CFLAGS_COMPILE = if stdenv.hostPlatform.is32bit then "-Wno-error=sign-compare" else null;

  meta = with lib; {
    description = "iscsi client library and utilities";
    homepage = "https://github.com/sahlberg/libiscsi";
    license = licenses.lgpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ misuzu ];
  };
}
