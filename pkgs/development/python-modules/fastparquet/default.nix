{
  lib,
  buildPythonPackage,
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
}:

buildPythonPackage rec {
  pname = "fastparquet";
  version = "2024.11.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "dask";
    repo = "fastparquet";
    tag = version;
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

  meta = with lib; {
    description = "Implementation of the parquet format";
    homepage = "https://github.com/dask/fastparquet";
    changelog = "https://github.com/dask/fastparquet/blob/${version}/docs/source/releasenotes.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ veprbl ];
  };
}
