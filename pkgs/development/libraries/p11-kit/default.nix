{ stdenv, fetchFromGitHub, autoreconfHook, which, pkgconfig, libiconv
, libffi, libtasn1 }:

stdenv.mkDerivation rec {
  name = "p11-kit-${version}";
  version = "0.23.14";

  src = fetchFromGitHub {
    owner = "p11-glue";
    repo = "p11-kit";
    rev = version;
    sha256 = "0zmrw1ciybhnxjlsfb07wnf11ak5vrmy8y8fnz3mwm8v3w8dzlvw";
  };

  outputs = [ "out" "dev"];
  outputBin = "dev";

  nativeBuildInputs = [ autoreconfHook which pkgconfig ];
  buildInputs = [ libffi libtasn1 libiconv ];

  autoreconfPhase = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--without-trust-paths"
  ];

  installFlags = [ "exampledir=\${out}/etc/pkcs11" ];

  doInstallCheck = false; # probably a bug in this derivation
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://p11-glue.freedesktop.org/;
    platforms = platforms.all;
    license = licenses.mit;
  };
}
