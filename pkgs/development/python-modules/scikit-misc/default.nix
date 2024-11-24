{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  gfortran,
  git,
  meson-python,
  pkg-config,
  numpy,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "scikit-misc";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "has2k1";
    repo = "scikit-misc";
    rev = "refs/tags/v${version}";
    hash = "sha256-w6RHmVxJjLx9ov2LxXvicxmY8jixfkIRfbfVnV2yhOU=";
  };

  postPatch = ''
    patchShebangs .

    # unbound numpy and disable coverage testing in pytest
    substituteInPlace pyproject.toml \
      --replace-fail 'numpy>=2.0' 'numpy' \
      --replace-fail 'addopts = "' '#addopts = "'

    # provide a version to use when git fails to get the tag
    [[ -f skmisc/_version.py ]] || \
      echo '__version__ = "${version}"' > skmisc/_version.py
  '';

  nativeBuildInputs = [
    gfortran
    git
    pkg-config
  ];

  build-system = [
    cython
    meson-python
    numpy
    setuptools
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  # can not run tests from source directory
  preCheck = ''
    cd "$(mktemp -d)"
  '';

  pytestFlagsArray = [ "--pyargs skmisc" ];

  pythonImportsCheck = [ "skmisc" ];

  meta = with lib; {
    description = "Miscellaneous tools for scientific computing";
    homepage = "https://github.com/has2k1/scikit-misc";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
