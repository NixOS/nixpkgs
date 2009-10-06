{stdenv, fetchurl, zlib, python ? null, pythonSupport ? true, ...}:

assert pythonSupport -> python != null;

stdenv.mkDerivation {
  name = "libxml2-2.7.3";

  src = fetchurl {
    url = ftp://xmlsoft.org/libxml2/libxml2-sources-2.7.3.tar.gz;
    sha256 = "01bgxgvl0gcx97zmlz9f2ivgbiv86kqbs9l93n2cbxywv1pc4jd5";
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
