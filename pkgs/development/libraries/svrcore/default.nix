{ stdenv, fetchurl, pkgconfig, nss, nspr }:

stdenv.mkDerivation rec {
  name = "svrcore-${version}";
  version = "4.0.4";

  src = fetchurl {
    url = "mirror://mozilla/directory/svrcore/releases/${version}/src/${name}.tar.bz2";
    sha256 = "0n3alg6bxml8952fb6h0bi0l29farvq21q6k20gy2ba90m3znwj7";
  };

  buildInputs = [ pkgconfig nss nspr ];

  meta = with stdenv.lib; {
    description = "Secure PIN handling using NSS crypto";
    license = licenses.mpl11;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
