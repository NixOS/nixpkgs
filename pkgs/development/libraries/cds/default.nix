{
  cmake,
  fetchurl,
  lib,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "cds";
  version = "2.3.3";

  src = fetchurl {
    url = "https://github.com/khizmax/libcds/archive/v${version}.tar.gz";
    sha256 = "1273wk370nqpq5yg9xvf90icnb6yc1rb5gghnb1a6qvbrl73i47h";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    homepage = "http://libcds.sourceforge.net/";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ kevincox ];
    description = "CDS is a C++ template library of lock-free and fine-grained algorithms.";
  };
}
