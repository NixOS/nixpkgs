{ lib
, python
, buildPythonPackage
, fetchPypi
, isPyPy
, isPy27
, readline
, R
, rWrapper
, rPackages
, pcre
, lzma
, bzip2
, zlib
, icu
, singledispatch
, six
, jinja2
, pytz
, numpy
, pytest
, mock
, extraRPackages ? []
}:

buildPythonPackage rec {
    version = "2.8.6"; # python2 support dropped in 2.9.x
    pname = "rpy2";
    disabled = isPyPy;
    src = fetchPypi {
      inherit version pname;
      sha256 = "162zki5c1apgv6qbafi7n66y4hgpgp43xag7q75qb6kv99ri6k80";
    };
    buildInputs = [
      readline
      R
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
      lme4
      tidyr

      # is in upstream's `requires` although it shouldn't be -- this is easier than patching it away
      pytest
    ]) ++ extraRPackages ++ rWrapper.recommendedPackages;

    nativeBuildInputs = [
      R # needed at setup time to detect R_HOME (alternatively set R_HOME explicitly)
    ];

    patches = [
      # R_LIBS_SITE is used by the nix r package to point to the installed R libraries.
      # This patch sets R_LIBS_SITE when rpy2 is imported.
      ./r-libs-site.patch
    ];
    postPatch = ''
      substituteInPlace ${ if isPy27 then "rpy/rinterface/__init__.py" else "rpy2/rinterface_lib/embedded.py" } --replace '@NIX_R_LIBS_SITE@' "$R_LIBS_SITE"
    '';

    doPatchelf = false; # fails because of "missing filename"
    patchelfPhase = "";

    propagatedBuildInputs = [
      singledispatch
      six
      jinja2
      pytz
      numpy
    ];

    checkInputs = [
      pytest
      mock
    ];
    # One remaining test failure caused by different unicode encoding.
    # https://bitbucket.org/rpy2/rpy2/issues/488
    doCheck = false;
    checkPhase = ''
      ${python.interpreter} -m 'rpy2'
    '';

    # For some reason libreadline.so is not found. Curiously `ldd _rinterface.so | grep readline` shows two readline entries:
    # libreadline.so.6 => not found
    # libreadline.so.6 => /nix/store/z2zhmrg6jcrn5iq2779mav0nnq4vm2q6-readline-6.3p08/lib/libreadline.so.6 (0x00007f333ac43000)
    # There must be a better way to fix this, but I don't know it.
    postFixup = ''
      patchelf --add-needed ${readline}/lib/libreadline.so "$out/${python.sitePackages}/rpy2/rinterface/"_rinterface*.so
    '';

    meta = {
      homepage = "http://rpy.sourceforge.net/rpy2";
      description = "Python interface to R";
      license = lib.licenses.gpl2Plus;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ joelmo ];
    };
  }
