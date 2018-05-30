{ stdenv, fetchFromGitHub, autoreconfHook, which, pkgconfig, libiconv
, libffi, libtasn1 }:

stdenv.mkDerivation rec {
  name = "p11-kit-${version}";
  version = "0.23.11";

  src = fetchFromGitHub {
    owner = "p11-glue";
    repo = "p11-kit";
    rev = version;
    sha256 = "08jfxml3w8gn85qz19ps1z8yb66k921z0cgzizqn1ipl9pp5pxyd";
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

  meta = with stdenv.lib; {
    homepage = https://p11-glue.freedesktop.org/;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
    license = licenses.mit;
  };
}
