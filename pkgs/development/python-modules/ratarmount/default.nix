{
  lib,
  buildPythonPackage,
  fetchPypi,
<<<<<<< HEAD
  indexed-gzip,
  indexed-zstd,
  libarchive-c,
  mfusepy,
=======
  fusepy,
  indexed-gzip,
  indexed-zstd,
  libarchive-c,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  python-xz,
  pythonOlder,
  rapidgzip,
  rarfile,
  ratarmountcore,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ratarmount";
<<<<<<< HEAD
  version = "1.2.1";
=======
  version = "1.1.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-KL4vG5R3uk0NjXXdvCRo/JBpcNNvSUC9ky0aUYGOBqA=";
=======
    hash = "sha256-XiwtmZ7HGZwjJJrUD3TOP3o19RBwB/Yu09xdwK13+hk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pythonRelaxDeps = [ "python-xz" ];

  build-system = [ setuptools ];

  dependencies = [
<<<<<<< HEAD
    indexed-gzip
    indexed-zstd
    libarchive-c
    mfusepy
=======
    fusepy
    indexed-gzip
    indexed-zstd
    libarchive-c
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Mounts archives as read-only file systems by way of indexing";
    homepage = "https://github.com/mxmlnkn/ratarmount";
    changelog = "https://github.com/mxmlnkn/ratarmount/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Mounts archives as read-only file systems by way of indexing";
    homepage = "https://github.com/mxmlnkn/ratarmount";
    changelog = "https://github.com/mxmlnkn/ratarmount/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = with lib.maintainers; [ mxmlnkn ];
    mainProgram = "ratarmount";
  };
}
