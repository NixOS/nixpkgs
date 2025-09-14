{
  stdenv,
  lib,
  buildPythonPackage,
  fetchurl,
  fetchpatch2,
  isPyPy,
  R,
  rpy2-rinterface,
  ipython,
  jinja2,
  numpy,
  pandas,
  tzlocal,
  pytestCheckHook,
}:

buildPythonPackage rec {
  version = "3.6.2";
  format = "pyproject";
  pname = "rpy2-robjects";

  disabled = isPyPy;
  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${
      builtins.replaceStrings [ "-" ] [ "_" ] pname
    }-${version}.tar.gz";
    hash = "sha256-rJGvMtXE2iNrBaPNaNr7JM2PWogPAHhim48r8CUFQjs=";
  };

  patches = [
    # https://github.com/rpy2/rpy2/pull/1171#issuecomment-3263994962
    (fetchpatch2 {
      url = "https://github.com/rpy2/rpy2/commit/524546eef9b8f7f3d61aeb76d7e7fa7beeabd2d2.patch?full_index=1";
      hash = "sha256-aR44E8wIBlD7UpQKm7B+aMn2p3FQ8dwBwLwkibIpcuM=";
      relative = "rpy2-robjects";
      revert = true;
    })
  ];

  nativeBuildInputs = [
    R # needed at setup time to detect R_HOME (alternatively set R_HOME explicitly)
  ];

  propagatedBuildInputs = [
    ipython
    jinja2
    numpy
    pandas
    rpy2-rinterface
    tzlocal
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://rpy2.github.io/";
    description = "Python interface to R";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ joelmo ];
  };
}
