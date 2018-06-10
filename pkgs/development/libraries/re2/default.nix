{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "re2-${version}";
  version = "20140304";

  src = fetchurl {
    url = "https://re2.googlecode.com/files/${name}.tgz";
    sha256 = "19wn0472c9dsxp35d0m98hlwhngx1f2xhxqgr8cb5x72gnjx3zqb";
  };

  preConfigure = ''
    substituteInPlace Makefile --replace "/usr/local" "$out"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    # Fixed in https://github.com/google/re2/commit/b2c9765b4a7afbea8b6be1dae548b6f4d5f39e42
    substituteInPlace Makefile \
        --replace '-dynamiclib' '-dynamiclib -Wl,-install_name,$(libdir)/libre2.so.$(SONAME)'
  '';

  meta = {
    homepage = https://code.google.com/p/re2/;
    description = "An efficient, principled regular expression library";
    license = stdenv.lib.licenses.bsd3;
    platforms = with stdenv.lib.platforms; all;
  };
}
