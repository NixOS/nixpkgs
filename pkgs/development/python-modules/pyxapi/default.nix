{ stdenv, buildPythonPackage, fetchurl, isPy3k }:

buildPythonPackage rec {
  name = "PyXAPI-0.1";
  disabled = isPy3k; # Module is only for Python2

  src = fetchurl {
    url = "http://www.pps.univ-paris-diderot.fr/~ylg/PyXAPI/${name}.tar.gz";
    sha256 = "19lblwfq24bgsgfy7hhqkxdf4bxl40chcxdlpma7a0wfa0ngbn26";
  };
  configurePhase = "./configure";

  meta = with stdenv.lib; {
    description = "Python socket module extension & RFC3542 IPv6 Advanced Sockets API";
    longDescription = ''
        PyXAPI consists of two modules: `socket_ext' and `rfc3542'.
        `socket_ext' extends the Python module `socket'. `socket' objects have
        two new methods: `recvmsg' and `sendmsg'. It defines `ancillary data'
        objects and some functions related to. `socket_ext' module also provides
        functions to manage interfaces indexes defined in RFC3494 and not
        available from standard Python module `socket'.
        `rfc3542' is a full implementation of RFC3542 (Advanced Sockets
        Application Program Interface (API) for IPv6).
    '';
    homepage = http://www.pps.univ-paris-diderot.fr/~ylg/PyXAPI/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nckx ];
  };
}
