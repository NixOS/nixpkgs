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
  version = "0.7.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ULPXCJyGJQTCKyVu9R/kWFGzRhbbFMDr/FU2AByZYBU=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libjpeg
    libpng
    libtiff
    libwebp
  ];

  dependencies = [ numpy ];

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
    homepage = "https://imread.readthedocs.io/";
    changelog = "https://github.com/luispedro/imread/blob/v${version}/ChangeLog";
    maintainers = with maintainers; [ luispedro ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
