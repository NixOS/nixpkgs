{
  lib,
  buildPythonPackage,
  fetchPypi,
  fusepy,
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
  version = "1.1.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XiwtmZ7HGZwjJJrUD3TOP3o19RBwB/Yu09xdwK13+hk=";
  };

  pythonRelaxDeps = [ "python-xz" ];

  build-system = [ setuptools ];

  dependencies = [
    fusepy
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

  meta = with lib; {
    description = "Mounts archives as read-only file systems by way of indexing";
    homepage = "https://github.com/mxmlnkn/ratarmount";
    changelog = "https://github.com/mxmlnkn/ratarmount/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ mxmlnkn ];
    mainProgram = "ratarmount";
  };
}
