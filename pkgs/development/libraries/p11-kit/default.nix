{ stdenv, fetchurl, libiconv, pkgconfig, libffi, libtasn1 }:

stdenv.mkDerivation rec {
  name = "p11-kit-0.23.2";

  src = fetchurl {
    url = "${meta.homepage}releases/${name}.tar.gz";
    sha256 = "1w7szm190phlkg7qx05ychlj2dbvkgkhx9gw6dx4d5rw62l6wwms";
  };

  outputs = [ "dev" "out" "docdev" ];
  outputBin = "dev";

  buildInputs = [ pkgconfig libffi libtasn1 libiconv ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--without-trust-paths"
  ];

  installFlags = [ "exampledir=\${out}/etc/pkcs11" ];

  meta = with stdenv.lib; {
    homepage = https://p11-glue.freedesktop.org/;
    platforms = platforms.all;
    maintainers = with maintainers; [ urkud wkennington ];
    license = licenses.mit;
  };
}
