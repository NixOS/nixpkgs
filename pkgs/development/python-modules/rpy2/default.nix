{ stdenv
, lib
, python
, buildPythonPackage
, fetchpatch
, fetchPypi
, isPyPy
, R
, rWrapper
, rPackages
, pcre
, lzma
, bzip2
, zlib
, icu
, ipython
, jinja2
, pytz
, pandas
, numpy
, cffi
, tzlocal
, simplegeneric
, pytestCheckHook
, extraRPackages ? []
}:

buildPythonPackage rec {
    version = "3.4.1";
    pname = "rpy2";

    disabled = isPyPy;
    src = fetchPypi {
      inherit version pname;
      sha256 = "1qnjjlgh6i31z45jykwd29n1336gq678fn9zw7gh0rv5d6sn0hv4";
    };

    patches = [
      # R_LIBS_SITE is used by the nix r package to point to the installed R libraries.
      # This patch sets R_LIBS_SITE when rpy2 is imported.
      ./rpy2-3.x-r-libs-site.patch
    ];

    postPatch = ''
      substituteInPlace 'rpy2/rinterface_lib/embedded.py' --replace '@NIX_R_LIBS_SITE@' "$R_LIBS_SITE"
      substituteInPlace 'requirements.txt' --replace 'pytest' ""
    '';

    buildInputs = [
      pcre
      lzma
      bzip2
      zlib
      icu
    ] ++ (with rPackages; [
      # packages expected by the test framework
      ggplot2
      dplyr
      RSQLite
      broom
      DBI
      dbplyr
      hexbin
      lazyeval
      lme4
      tidyr
    ]) ++ extraRPackages ++ rWrapper.recommendedPackages;

    nativeBuildInputs = [
      R # needed at setup time to detect R_HOME (alternatively set R_HOME explicitly)
    ];

    propagatedBuildInputs = [
      ipython
      jinja2
      pytz
      pandas
      numpy
      cffi
      tzlocal
      simplegeneric
    ];

    doCheck = !stdenv.isDarwin;

    checkInputs = [
      pytestCheckHook
    ];

    meta = {
      homepage = "https://rpy2.github.io/";
      description = "Python interface to R";
      license = lib.licenses.gpl2Plus;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ joelmo ];
    };
  }
