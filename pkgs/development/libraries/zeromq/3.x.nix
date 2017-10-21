{ stdenv, fetchurl, libuuid }:

stdenv.mkDerivation rec {
  name = "zeromq-3.2.5";

  src = fetchurl {
    url = "http://download.zeromq.org/${name}.tar.gz";
    sha256 = "0911r7q4i1x9gnfinj39vx08fnz59mf05vl75zdkws36lib3wr89";
  };

  buildInputs = [ libuuid ];

  meta = with stdenv.lib; {
    branch = "3";
    homepage = http://www.zeromq.org;
    description = "The Intelligent Transport Layer";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
