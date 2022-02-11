{ lib, stdenv, fetchurl, pkg-config, pure, fcgi }:

stdenv.mkDerivation rec {
  pname = "pure-fastcgi";
  version = "0.6";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-fastcgi-${version}.tar.gz";
    sha256 = "aa5789cc1e17521c01f349ee82ce2a00500e025b3f8494f89a7ebe165b5aabc7";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ pure fcgi ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "Lets you write FastCGI scripts with Pure, to be run by web servers like Apache";
    homepage = "http://puredocs.bitbucket.org/pure-fastcgi.html";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
