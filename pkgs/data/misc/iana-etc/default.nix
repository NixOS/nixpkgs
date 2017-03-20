{ stdenv, cacert, curl }:


stdenv.mkDerivation rec {

  name = "iana-etc-${version}";
  version = "20170321";
  
  phases = [ "buildPhase" ];
  buildInputs = [ cacert curl ];
  builder = ./builder.sh;
  
  
  meta = {
    homepage = https://www.iana.org/;
    description = "IANA protocol and port number assignments (/etc/protocols and /etc/services)";
    platforms = stdenv.lib.platforms.unix;
  };
}
