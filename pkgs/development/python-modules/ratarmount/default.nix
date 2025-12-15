{
  lib,
  buildPythonPackage,
  fetchPypi,
  mfusepy,
  indexed-gzip,
  indexed-zstd,
  libarchive-c,
  python-xz,
  pythonOlder,
  rapidgzip,
  rarfile,
  ratarmountcore,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ratarmount";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rMpOWAPHX1D5TUx16tX0SqTEZhyed9UOsl0Ydub03sk=";
  };

  pythonRelaxDeps = [ "python-xz" ];

  build-system = [ setuptools ];

  dependencies = [
    mfusepy
    indexed-gzip
    indexed-zstd
    libarchive-c
    python-xz
    rapidgzip
    rarfile
    ratarmountcore
  ];

  checkPhase = ''
    runHook preCheck

    python tests/tests.py

    runHook postCheck
  '';

  meta = {
    description = "Mounts archives as read-only file systems by way of indexing";
    homepage = "https://github.com/mxmlnkn/ratarmount";
    changelog = "https://github.com/mxmlnkn/ratarmount/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mxmlnkn ];
    mainProgram = "ratarmount";
    platforms = lib.platforms.linux;
  };
}
