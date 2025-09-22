{
  stdenv,
  lib,
  buildPythonPackage,
  fetchurl,
  isPyPy,
  R,
  rWrapper,
  xz,
  bzip2,
  zlib,
  zstd,
  icu,
  pytestCheckHook,
  setuptools,
  cffi,
}:

buildPythonPackage rec {
  version = "3.6.3";
  format = "pyproject";
  pname = "rpy2-rinterface";

  disabled = isPyPy;
  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${
      builtins.replaceStrings [ "-" ] [ "_" ] pname
    }-${version}.tar.gz";
    hash = "sha256-R3vC9R0AetG4VnxdS6GvD1mVFobufxBXagbQg03ld28=";
  };

  patches = [
    # https://github.com/rpy2/rpy2/pull/1171#issuecomment-3263994962
    ./restore-initr-simple.patch

    # R_LIBS_SITE is used by the nix r package to point to the installed R libraries.
    # This patch sets R_LIBS_SITE when rpy2 is imported.
    ./rpy2-3.x-r-libs-site.patch
  ];

  postPatch = ''
    substituteInPlace 'src/rpy2/rinterface_lib/embedded.py' --replace '@NIX_R_LIBS_SITE@' "$R_LIBS_SITE"
  '';

  buildInputs = [
    xz
    bzip2
    zlib
    zstd
    icu
  ]
  ++ rWrapper.recommendedPackages;

  nativeBuildInputs = [
    R # needed at setup time to detect R_HOME (alternatively set R_HOME explicitly)
  ];

  propagatedBuildInputs = [
    cffi
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # https://github.com/rpy2/rpy2/issues/1111
  disabledTests = [
    "test_parse_incomplete_error"
    "test_parse_error"
    "test_parse_error_when_evaluting"
  ];

  meta = {
    homepage = "https://rpy2.github.io/";
    description = "Python interface to R";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib; [ teams.sage ];
  };
}
