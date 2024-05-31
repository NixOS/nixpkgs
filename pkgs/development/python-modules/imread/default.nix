{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pkg-config,
  setuptools,
  libjpeg,
  libpng,
  libtiff,
  libwebp,
  numpy,
}:

buildPythonPackage rec {
  pname = "imread";
  version = "0.7.5";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "imread";
    hash = "sha256-GiWpA128GuLlbBW1CQQHHVVeoZfu9Yyh2RFzSdtHDbc=";
  };

  nativeBuildInputs = [
    pkg-config
    setuptools
  ];

  buildInputs = [
    libjpeg
    libpng
    libtiff
    libwebp
  ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [
    # verbose build outputs needed to debug hard-to-reproduce hydra failures
    "-v"
    "--pyargs"
    "imread"
  ];

  pythonImportsCheck = [ "imread" ];

  preCheck = ''
    cd $TMPDIR
    export HOME=$TMPDIR
    export OMP_NUM_THREADS=1
  '';

  meta = with lib; {
    description = "Python package to load images as numpy arrays";
    homepage = "https://imread.readthedocs.io/en/latest/";
    maintainers = with maintainers; [ luispedro ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
