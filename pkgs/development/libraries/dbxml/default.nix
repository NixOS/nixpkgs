{ stdenv, fetchurl, db62, xercesc, xqilla }:

stdenv.mkDerivation rec {
  name = "dbxml-${version}";
  version = "6.1.4";

  src = fetchurl {
    url = "http://download.oracle.com/berkeley-db/${name}.tar.gz";
    sha256 = "a8fc8f5e0c3b6e42741fa4dfc3b878c982ff8f5e5f14843f6a7e20d22e64251a";
  };

  patches = [
    ./cxx11.patch
    ./incorrect-optimization.patch
  ];

  buildInputs = [
    xercesc xqilla
  ];

  propagatedBuildInputs = [
    db62
  ];

  configureFlags = [
    "--with-berkeleydb=${db62.out}"
    "--with-xerces=${xercesc}"
    "--with-xqilla=${xqilla}"
  ];

  preConfigure = ''
    cd dbxml
  '';

  meta = with stdenv.lib; {
    homepage = https://www.oracle.com/database/berkeley-db/xml.html;
    description = "Embeddable XML database based on Berkeley DB";
    license = licenses.agpl3;
    maintainers = with maintainers; [ danieldk ];
    platforms = platforms.unix;
  };
}
