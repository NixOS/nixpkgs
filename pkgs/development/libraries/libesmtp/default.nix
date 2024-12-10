{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "libESMTP";
  version = "1.1.0";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [ openssl ];

  src = fetchFromGitHub {
    owner = "libesmtp";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bhh8hlsl9597x0bnfl563k2c09b61qnkb9mfyqcmzlq63m1zw5y";
  };

  meta = with lib; {
    description = "A Library for Posting Electronic Mail";
    longDescription = ''
      libESMTP is an SMTP client library which manages submission of electronic mail
      via a preconfigured Mail Transport Agent (MTA) such as Exim or Postfix.
      It implements many SMTP extensions including TLS for security
      and PIPELINING for high performance.
    '';
    homepage = "https://libesmtp.github.io/";
    license = licenses.lgpl21Plus;
  };
}
