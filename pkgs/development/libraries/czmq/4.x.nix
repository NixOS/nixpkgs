{ stdenv, fetchurl, fetchpatch, zeromq }:

stdenv.mkDerivation rec {
  version = "4.1.1";
  name = "czmq-${version}";

  src = fetchurl {
    url = "https://github.com/zeromq/czmq/releases/download/v${version}/${name}.tar.gz";
    sha256 = "1h5hrcsc30fcwb032vy5gxkq4j4vv1y4dj460rfs1hhxi0cz83zh";
  };

  # Needs to be propagated for the .pc file to work
  propagatedBuildInputs = [ zeromq ];

  meta = with stdenv.lib; {
    homepage = http://czmq.zeromq.org/;
    description = "High-level C Binding for ZeroMQ";
    license = licenses.mpl20;
    platforms = platforms.all;
  };
}
