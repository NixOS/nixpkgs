{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "cppzmq";

  src = fetchgit {
    url = "git://github.com/zeromq/cppzmq";
    rev = "ac705f604701e2ca1643fa31bae240f9da8b9b9a";
    sha256 = "1bcd5553601a6cdc926aa7a7c89fe54d3b14693cfce85dea97af25cf5a144398";
  };

  installPhase = ''
    install -Dm644 zmq.hpp $out/include/zmq.hpp
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/zeromq/cppzmq;
    license = licenses.bsd2;
    description = "C++ binding for 0MQ";
    maintainers = maintainers.abbradar;
    platforms = platforms.unix;
  };
}
