{ stdenv, fetchFromGitHub, autoreconfHook, which, pkgconfig, libiconv
, libffi, libtasn1 }:

stdenv.mkDerivation rec {
  name = "p11-kit-${version}";
  version = "0.23.10";

  src = fetchFromGitHub {
    owner = "p11-glue";
    repo = "p11-kit";
    rev = version;
    sha256 = "0n0wqv028flzvnxllqv8i6x9nv705csl7ddzi0fzvppc9fp2yinp";
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

  meta = with stdenv.lib; {
    homepage = https://p11-glue.freedesktop.org/;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
    license = licenses.mit;
  };
}
