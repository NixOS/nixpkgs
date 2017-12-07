{ stdenv, fetchurl, fetchpatch, zeromq }:

stdenv.mkDerivation rec {
  version = "4.0.2";
  name = "czmq-${version}";

  src = fetchurl {
    url = "https://github.com/zeromq/czmq/releases/download/v${version}/${name}.tar.gz";
    sha256 = "12gbh57xnz2v82x1g80gv4bwapmyzl00lbin5ix3swyac8i7m340";
  };

  patches = [
    (fetchpatch {
      url = https://patch-diff.githubusercontent.com/raw/zeromq/czmq/pull/1618.patch;
      sha256 = "1dssy7k0fni6djail8rz0lk8p777158jvrqhgn500i636gkxaxhp";
    })
  ];

  # Needs to be propagated for the .pc file to work
  propagatedBuildInputs = [ zeromq ];

  meta = with stdenv.lib; {
    homepage = http://czmq.zeromq.org/;
    description = "High-level C Binding for ZeroMQ";
    license = licenses.mpl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
