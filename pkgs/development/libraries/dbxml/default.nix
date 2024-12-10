{
  lib,
  stdenv,
  fetchurl,
  db62,
  xercesc,
  xqilla,
}:

stdenv.mkDerivation rec {
  pname = "dbxml";
  version = "6.1.4";

  src = fetchurl {
    url = "http://download.oracle.com/berkeley-db/${pname}-${version}.tar.gz";
    sha256 = "a8fc8f5e0c3b6e42741fa4dfc3b878c982ff8f5e5f14843f6a7e20d22e64251a";
  };

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  patches = [
    ./cxx11.patch
    ./incorrect-optimization.patch
  ];

  buildInputs = [
    xercesc
    xqilla
  ];

  propagatedBuildInputs = [
    db62
  ];

  configureFlags = [
    "--with-berkeleydb=${db62.out}"
    "--with-xerces=${xercesc}"
    "--with-xqilla=${xqilla}"
    # code uses register storage specifier
    "CXXFLAGS=-std=c++14"
  ];

  preConfigure = ''
    cd dbxml
  '';

  meta = with lib; {
    homepage = "https://www.oracle.com/database/berkeley-db/xml.html";
    description = "Embeddable XML database based on Berkeley DB";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
