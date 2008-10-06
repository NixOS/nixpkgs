{ stdenv, fetchurl, apr, expat
, bdbSupport ? false, db4 ? null
}:

assert bdbSupport -> db4 != null;

stdenv.mkDerivation {
  name = "apr-util-1.3.4";
  
  src = fetchurl {
    url = mirror://apache/apr/apr-util-1.3.4.tar.bz2;
    sha256 = "1kin1yh42sk7hw81x3aynjf2g0k07n6707426c2mi6fh6lr0lys4";
  };
  
  configureFlags = ''
    --with-apr=${apr} --with-expat=${expat}
    ${if bdbSupport then "--with-berkeley-db=${db4}" else ""}
  '';
  
  passthru = {
    inherit bdbSupport;
  };

  meta = {
    homepage = http://apr.apache.org/;
    description = "A companion library to APR, the Apache Portable Runtime";
  };
}

