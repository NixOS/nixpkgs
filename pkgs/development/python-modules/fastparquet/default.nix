{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,
  setuptools-scm,

  # nativeBuildInputs
  gitMinimal,

  # dependencies
  cramjam,
  fsspec,
  numpy,
  packaging,
  pandas,

  # optional-dependencies
  python-lzo,

  # tests
  pytestCheckHook,
  python,
=======
  cramjam,
  cython,
  fetchFromGitHub,
  fsspec,
  git,
  numpy,
  packaging,
  pandas,
  pytestCheckHook,
  python-lzo,
  python,
  pythonOlder,
  setuptools-scm,
  setuptools,
  wheel,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "fastparquet";
<<<<<<< HEAD
  version = "2025.12.0";
  pyproject = true;

=======
  version = "2024.11.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "dask";
    repo = "fastparquet";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-cebu3E2sbVWRUYbSeuslCZhaF+zWV7E56iSwB7Ms3ts=";
  };

  build-system = [
    cython
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    gitMinimal
=======
    hash = "sha256-GJ6dr36hGjpfEKcA96RpEqY8I1vXooLDGwc0A57yFTY=";
  };

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  nativeBuildInputs = [
    cython
    git
    numpy
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  dependencies = [
    cramjam
    fsspec
    numpy
    packaging
    pandas
  ];

  optional-dependencies = {
    lzo = [ python-lzo ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  # Workaround https://github.com/NixOS/nixpkgs/issues/123561
  preCheck = ''
    mv fastparquet/test .
    rm -r fastparquet
    fastparquet_test="$out"/${python.sitePackages}/fastparquet/test
    ln -s `pwd`/test "$fastparquet_test"
  '';

  postCheck = ''
    rm "$fastparquet_test"
  '';

  pythonImportsCheck = [ "fastparquet" ];

<<<<<<< HEAD
  meta = {
    description = "Implementation of the parquet format";
    homepage = "https://github.com/dask/fastparquet";
    changelog = "https://github.com/dask/fastparquet/blob/${version}/docs/source/releasenotes.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ veprbl ];
=======
  meta = with lib; {
    description = "Implementation of the parquet format";
    homepage = "https://github.com/dask/fastparquet";
    changelog = "https://github.com/dask/fastparquet/blob/${version}/docs/source/releasenotes.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ veprbl ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
