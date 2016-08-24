{ stdenv, fetchurl, zeromq }:

stdenv.mkDerivation rec {
  version = "3.0.2";
  name = "czmq-${version}";

  src = fetchurl {
    url = "http://download.zeromq.org/${name}.tar.gz";
    sha256 = "16k9awrhdsymx7dnmvqcnkaq8lz8x8zppy6sh7ls8prpd6mkkjlb";
  };

  # Fix build on Glibc 2.24.
  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

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
