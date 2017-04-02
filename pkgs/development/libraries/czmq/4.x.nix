{ stdenv, fetchurl, zeromq }:

stdenv.mkDerivation rec {
  version = "4.0.2";
  name = "czmq-${version}";

  src = fetchurl {
    url = "https://github.com/zeromq/czmq/releases/download/v${version}/${name}.tar.gz";
    sha256 = "12gbh57xnz2v82x1g80gv4bwapmyzl00lbin5ix3swyac8i7m340";
  };

  # Needs to be propagated for the .pc file to work
  propagatedBuildInputs = [ zeromq ];

  meta = with stdenv.lib; {
    homepage = "http://czmq.zeromq.org/";
    description = "High-level C Binding for ZeroMQ";
    license = licenses.mpl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
