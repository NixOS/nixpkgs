{stdenv, fetchurl, zlib, python ? null, pythonSupport ? true
  , ...}:

assert pythonSupport -> python != null;

stdenv.mkDerivation {
  name = "libxml2-2.7.6";

  src = fetchurl {
    url = ftp://xmlsoft.org/libxml2/libxml2-sources-2.7.6.tar.gz;
    sha256 = "0n61rqqfiv0m64p01cwx205i6hb0mmzf7r0ya40s4fiqd2nhkkg0";
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
