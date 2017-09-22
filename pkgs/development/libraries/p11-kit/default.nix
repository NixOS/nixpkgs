{ stdenv, fetchFromGitHub, autoreconfHook, which, pkgconfig, libiconv
, libffi, libtasn1, gtk_doc, libxslt, docbook_xsl }:

stdenv.mkDerivation rec {
  name = "p11-kit-${version}";
  version = "0.23.7";

  src = fetchFromGitHub {
    owner = "p11-glue";
    repo = "p11-kit";
    rev = version;
    sha256 = "1l8sg0g74k2mk0y6vz19hc103dzizxa0h579gdhvxifckglb01hy";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  nativeBuildInputs = [ autoreconfHook which pkgconfig gtk_doc libxslt docbook_xsl ];
  buildInputs = [ libffi libtasn1 libiconv ];

  autoreconfPhase = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--without-trust-paths"
    "--enable-doc"
  ];

  installFlags = [ "exampledir=\${out}/etc/pkcs11" ];

  meta = with stdenv.lib; {
    homepage = https://p11-glue.freedesktop.org/;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
    license = licenses.mit;
  };
}
