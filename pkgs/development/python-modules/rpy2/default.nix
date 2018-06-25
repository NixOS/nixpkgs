{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, readline
, R
, pcre
, lzma
, bzip2
, zlib
, icu
, singledispatch
, six
, jinja2
, pytest
}:

buildPythonPackage rec {
    version = "2.9.3";
    pname = "rpy2";
    disabled = isPyPy;
    src = fetchPypi {
      inherit version pname;
      sha256 = "1b72958e683339ea0c3bd9f73738e9ece2da8da8008a10e2e0c68fc7864e9361";
    };
    buildInputs = [
      readline
      R
      pcre
      lzma
      bzip2
      zlib
      icu
    ];
    propagatedBuildInputs = [
      singledispatch
      six
      jinja2
    ];
    checkInputs = [ pytest ];
    # Tests fail with `assert not _relpath.startswith('..'), "Path must be within the project"`
    # in the unittest `loader.py`. I don't know what causes this.
    doCheck = false;
    # without this tests fail when looking for libreadline.so
    LD_LIBRARY_PATH = lib.makeLibraryPath buildInputs;

    meta = {
      homepage = http://rpy.sourceforge.net/rpy2;
      description = "Python interface to R";
      license = lib.licenses.gpl2Plus;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ joelmo ];
    };
  }
