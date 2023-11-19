{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, cython
, gfortran
, git
, meson-python
, pkg-config
, numpy
, openblas
, setuptools
, wheel
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

  patches = [
    # check for openblas64 pkg-config
    # remove when patch merged upstream
    # https://github.com/has2k1/scikit-misc/pull/29
    (fetchpatch {
      name = "openblas64-pkg-config.patch";
      url = "https://github.com/has2k1/scikit-misc/commit/6a140de18e5e1276c7aa08bf0a047b1023aa9ae4.patch";
      hash = "sha256-HzKiRISOvoDIUIcgiYVvxhx9klwyfAh/1DDKq7inl+A=";
    })
  ];

  postPatch = ''
    patchShebangs .

    substituteInPlace pyproject.toml \
      --replace 'numpy==' 'numpy>='
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

  buildInputs = [
    numpy
    openblas
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
