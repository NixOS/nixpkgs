{ stdenv, fetchurl, fetchpatch, libX11, libXaw }:

let
  getPatch = { name, sha256 }: fetchpatch {
    inherit name sha256;
    url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/${name}"
      + "?h=packages/t1lib&id=643a4c2c58e70072b5bc1e9e4624162517b58357";
  };

  patches = map getPatch [
    { name = "lib-cleanup.diff"; sha256 = "1w3q1y4zk0y4mf2s2x9z4cd8d4af8i868c8837p40mz3dqrai4zp"; }
    { name = "format-security.diff"; sha256 = "0cca94bif9dsc6iwpcnk1504gb3sl3nsqhni85c21q9aywyz26l3"; }
    { name = "CVE-2011-0764.diff"; sha256 = "1j0y3f38im7srpqjg9jvx8as6sxkz8gw7hglcxnxl9qylx8mr2jh"; }
    { name = "CVE-2011-1552_1553_1554.patch"; sha256 = "16cyq6jhyhh8912j8hapx9pq4rzxk36ljlkxlnyi7i3wr8iz1dir"; }
    { name = "CVE-2010-2642.patch"; sha256 = "175zvyr9v1xs22k2svgxqjcpz5nihfa7j46hn9nzvkqcrhm5m9y8"; }
  ];
in
stdenv.mkDerivation {
  name = "t1lib-5.1.2";

  src = fetchurl {
    url = "mirror://metalab/libs/graphics/t1lib-5.1.2.tar.gz";
    sha256 = "0nbvjpnmcznib1nlgg8xckrmsw3haa154byds2h90y2g0nsjh4w2";
  };
  inherit patches;

  buildInputs = [ libX11 libXaw ];
  buildFlags = "without_doc";

  postInstall = stdenv.lib.optional (!stdenv.isDarwin) "chmod +x $out/lib/*.so.*"; # ??

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
