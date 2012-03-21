{stdenv, fetchurl, zlib, python ? null, pythonSupport ? true }:

assert pythonSupport -> python != null;

stdenv.mkDerivation {
  name = "libxml2-2.7.8";

  src = fetchurl {
    url = ftp://xmlsoft.org/libxml2/libxml2-sources-2.7.8.tar.gz;
    sha256 = "6a33c3a2d18b902cd049e0faa25dd39f9b554a5b09a3bb56ee07dd7938b11c54";
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
