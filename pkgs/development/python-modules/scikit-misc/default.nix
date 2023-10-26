{ lib
, buildPythonPackage
, fetchFromGitHub
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
