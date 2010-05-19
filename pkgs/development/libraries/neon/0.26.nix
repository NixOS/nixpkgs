{ stdenv, fetchurl, libxml2, pkgconfig
, compressionSupport ? true, zlib ? null
, sslSupport ? true, openssl ? null
}:

assert compressionSupport -> zlib != null;
assert sslSupport -> openssl != null;

stdenv.mkDerivation {
  name = "neon-0.26.4";
  
  src = fetchurl {
    url = http://www.webdav.org/neon/neon-0.26.4.tar.gz;
    sha256 = "1pjrn5wb18gy419293hmwd02blmh36aaxsrgajm9nkkkjzqakncj";
  };
   
  buildInputs = [libxml2]
    ++ stdenv.lib.optional compressionSupport zlib
    ++ (if sslSupport then [ openssl pkgconfig ] else []);

  configureFlags = ''
    ${if compressionSupport then "--with-zlib" else "--without-zlib"}
    ${if sslSupport then "--with-ssl" else "--without-ssl"}
    --enable-shared
  '';

  passthru = {inherit compressionSupport sslSupport;};

  meta = {
    description = "An HTTP and WebDAV client library";
    homepage = http://www.webdav.org/neon/;
  };
}
