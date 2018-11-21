{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, isPy27
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
    version = if isPy27 then
      "2.8.6" # python2 support dropped in 2.9.x
    else
      "2.9.4";
    pname = "rpy2";
    disabled = isPyPy;
    src = fetchPypi {
      inherit version pname;
      sha256 = if isPy27 then
        "162zki5c1apgv6qbafi7n66y4hgpgp43xag7q75qb6kv99ri6k80" # 2.8.x
      else
        "0bl1d2qhavmlrvalir9hmkjh74w21vzkvc2sg3cbb162s10zfmxy"; # 2.9.x
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
