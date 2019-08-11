{ stdenv, fetchurl, zeromq }:

stdenv.mkDerivation rec {
  version = "4.2.0";
  name = "czmq-${version}";

  src = fetchurl {
    url = "https://github.com/zeromq/czmq/releases/download/v${version}/${name}.tar.gz";
    sha256 = "1szciz62sk3fm4ga9qjpxz0n0lazvphm32km95bq92ncng12kayg";
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
