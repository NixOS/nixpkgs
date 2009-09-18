{stdenv, fetchurl, zlib, python ? null, pythonSupport ? true}:

assert pythonSupport -> python != null;

stdenv.mkDerivation {
  name = "libxml2-2.7.4";

  src = fetchurl {
    url = ftp://xmlsoft.org/libxml2/libxml2-sources-2.7.4.tar.gz;
    sha256 = "1psk9r69z02cmjpbixs89qj0zprfyi6xc598j51cc0gah0h3wq03";
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
  };
}
