{ stdenv, fetchurl, pkgconfig, libxslt, telepathy_glib, loudmouth }:

stdenv.mkDerivation rec {
  name = "telepathy-gabble-0.7.2";

  src = fetchurl {
    url = "${meta.homepage}/releases/telepathy-gabble/${name}.tar.gz";
    sha256 = "0r1j475a5s2a4f10hybmavf4kf6nrnjnv091dpic5nl2asdilb7i";
  };

  propagatedBuildInputs = [telepathy_glib loudmouth];
  
  buildInputs = [pkgconfig libxslt];
  
  meta = {
    homepage = http://telepathy.freedesktop.org;
  };
}
