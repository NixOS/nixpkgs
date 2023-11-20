{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, cython
, gfortran
, git
, meson-python
, pkg-config
, blas
, lapack
, numpy
, setuptools
, wheel
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "scikit-misc";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "has2k1";
    repo = "scikit-misc";
    rev = "refs/tags/v${version}";
    hash = "sha256-XV3s+y3JdMr1770S91ek6Y7MqvTg7/2cphLQldUPe5s=";
  };

  postPatch = ''
    patchShebangs .

    # unbound numpy and disable coverage testing in pytest
    substituteInPlace pyproject.toml \
      --replace 'numpy==' 'numpy>=' \
      --replace 'addopts = "' '#addopts = "'

    # provide a version to use when git fails to get the tag
    [[ -f skmisc/_version.py ]] || \
      echo '__version__ = "${version}"' > skmisc/_version.py
  '';

  nativeBuildInputs = [
    cython
    gfortran
    git
    meson-python
    numpy
    pkg-config
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    numpy
  ];

  buildInputs = [
    blas
    lapack
  ];

  mesonFlags = [
    "-Dblas=${blas.pname}"
    "-Dlapack=${lapack.pname}"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # can not run tests from source directory
  preCheck = ''
    cd "$(mktemp -d)"
  '';

  pytestFlagsArray = [
    "--pyargs skmisc"
  ];

  pythonImportsCheck = [
    "skmisc"
  ];

  meta = with lib; {
    description = "Miscellaneous tools for scientific computing";
    homepage = "https://github.com/has2k1/scikit-misc";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
