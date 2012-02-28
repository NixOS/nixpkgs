{stdenv, fetchurl, zlib, python ? null, pythonSupport ? true }:

assert pythonSupport -> python != null;

stdenv.mkDerivation {
  name = "libxml2-2.7.7";

  src = fetchurl {
    url = ftp://xmlsoft.org/libxml2/libxml2-sources-2.7.7.tar.gz;
    sha256 = "03kkknm7xl77qfdig8mzalsi8ljsyblzin18gy3h8zranffrpyzs";
  };

  configureFlags = ''                                                  
    ${if pythonSupport then "--with-python=${python}" else ""}         
  '';
  
  propagatedBuildInputs = [zlib];

  setupHook = ./setup-hook.sh;

  passthru = {inherit pythonSupport;};

  meta = {
    homepage = http://xmlsoft.org/;
    description = "A XML parsing library for C";
    license = "bsd";
  };
}
