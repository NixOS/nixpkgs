{ lib
, fetchPypi
, buildPythonPackage
, cython
, gfortran
, git
, meson-python
, pkg-config
, numpy
, openblas
}:

buildPythonPackage rec {
  pname = "scikit-misc";
  version = "0.2.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "scikit_misc";
    inherit version;
    hash = "sha256-rBTdTpNeRC/DSrHFg7ZhHUYD0G9IgoqFx+A+LCxYK7w=";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    cython
    gfortran
    git
    meson-python
    pkg-config
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
