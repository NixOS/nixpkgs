{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, isPyPy
, R
, rWrapper
, rPackages
, pcre
, xz
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
    version = "3.5.15";
    format = "setuptools";
    pname = "rpy2";

    disabled = isPyPy;
    src = fetchPypi {
      inherit version pname;
      hash = "sha256-RE+uSoTcfyM7cOqrCqgTmO4BR8ThrjjdRSTXedbyWys=";
    };

    patches = [
      # R_LIBS_SITE is used by the nix r package to point to the installed R libraries.
      # This patch sets R_LIBS_SITE when rpy2 is imported.
      ./rpy2-3.x-r-libs-site.patch

      # https://github.com/rpy2/rpy2/pull/1094
      (fetchpatch {
        url = "https://github.com/rpy2/rpy2/commit/026d069a008163a62d12567bcb938410d0f9bf7a.diff";
        hash = "sha256-x778upSY3zab5EiRyOcsbDpPj7vN/7XzefEs+wvkNg0=";
      })
    ];

    postPatch = ''
      substituteInPlace 'rpy2/rinterface_lib/embedded.py' --replace '@NIX_R_LIBS_SITE@' "$R_LIBS_SITE"
      substituteInPlace 'requirements.txt' --replace 'pytest' ""
    '';

    buildInputs = [
      pcre
      xz
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

    nativeCheckInputs = [
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
