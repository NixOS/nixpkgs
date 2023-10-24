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
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "scikit-misc";
  version = "0.3.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "scikit_misc";
    inherit version;
    hash = "sha256-mom0Ch+b3bViErh9ueVYiGfVz5SQUSqCCcGsBJ7+Nrg=";
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
