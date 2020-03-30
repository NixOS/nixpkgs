{ lib
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
, pytest
, extraRPackages ? []
}:

buildPythonPackage rec {
    version = "3.2.6";
    pname = "rpy2";

    disabled = isPyPy;
    src = fetchPypi {
      inherit version pname;
      sha256 = "1p990cqx3p2pd1rc9wn66m56wahaq8dlr88frz49vb7nv4zw4a8q";
    };

    buildInputs = [
      R
      pcre
      lzma
      bzip2
      zlib
      icu

      # is in the upstream `requires` although it shouldn't be -- this is easier than patching it away
      pytest
    ] ++ (with rPackages; [
      # packages expected by the test framework
      ggplot2
      dplyr
      RSQLite
      broom
      DBI
      dbplyr
      hexbin
      lme4
      tidyr
    ]) ++ extraRPackages ++ rWrapper.recommendedPackages;

    checkPhase = ''
      pytest
    '';

    nativeBuildInputs = [
      R # needed at setup time to detect R_HOME (alternatively set R_HOME explicitly)
    ];

    patches = [
      # R_LIBS_SITE is used by the nix r package to point to the installed R libraries.
      # This patch sets R_LIBS_SITE when rpy2 is imported.
      ./rpy2-3.x-r-libs-site.patch

      # pandas 1.x compatibility, already merged upstream
      # https://github.com/rpy2/rpy2/issues/636
      (fetchpatch {
        name = "pandas-1.x.patch";
        url = "https://github.com/rpy2/rpy2/commit/fbd060e364b70012e8d26cc74df04ee53f769379.patch";
        sha256 = "19rdqydwjmqg25ibmsbx7lggrr9fsyjn283zgvz1wj4iyfjwp1za";
      })
    ];
    postPatch = ''
      substituteInPlace 'rpy2/rinterface_lib/embedded.py' --replace '@NIX_R_LIBS_SITE@' "$R_LIBS_SITE"
    '';

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

    checkInputs = [
      pytest
    ];

    meta = {
      homepage = http://rpy.sourceforge.net/rpy2;
      description = "Python interface to R";
      license = lib.licenses.gpl2Plus;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ joelmo ];
    };
  }
