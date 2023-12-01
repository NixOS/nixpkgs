{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, jinja2
, oldest-supported-numpy
, setuptools-scm
, wheel
, liberfa
, packaging
, numpy
, pytestCheckHook
, pytest-doctestplus
}:

buildPythonPackage rec {
  pname = "pyerfa";
  format = "pyproject";
  version = "2.0.0.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-13+7+lg1DBlMy5nl2TqgXTwrFNWq2LZi2Txq2f/0Hzk=";
  };

  patches = [
    # Sort of helps maybe for https://github.com/liberfa/pyerfa/issues/112
    (fetchpatch {
      url = "https://github.com/liberfa/pyerfa/commit/4866342b94c5e7344711146f1186a4c3e7534da8.patch";
      hash = "sha256-uPFFdLYfRweQdeEApBAw6Ulqh31NTQwwmnaU+x/M+C0=";
    })
  ];

  nativeBuildInputs = [
    jinja2
    oldest-supported-numpy
    packaging
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    numpy
  ];
  buildInputs = [
    liberfa
  ];

  preBuild = ''
    export PYERFA_USE_SYSTEM_LIBERFA=1
  '';

  # See https://github.com/liberfa/pyerfa/issues/112#issuecomment-1721197483
  NIX_CFLAGS_COMPILE = "-O2";
  nativeCheckInputs = [
    pytestCheckHook
    pytest-doctestplus
  ];
  # Getting circular import errors without this, not clear yet why. This was mentioned to
  # upstream at: https://github.com/liberfa/pyerfa/issues/112 and downstream at
  # https://github.com/NixOS/nixpkgs/issues/255262
  preCheck = ''
    cd $out
  '';
  pythonImportsCheck = [
    "erfa"
  ];

  meta = with lib; {
    description = "Python bindings for ERFA routines";
    longDescription = ''
        PyERFA is the Python wrapper for the ERFA library (Essential Routines
        for Fundamental Astronomy), a C library containing key algorithms for
        astronomy, which is based on the SOFA library published by the
        International Astronomical Union (IAU). All C routines are wrapped as
        Numpy universal functions, so that they can be called with scalar or
        array inputs.
    '';
    homepage = "https://github.com/liberfa/pyerfa";
    license = licenses.bsd3;
    maintainers = [ maintainers.rmcgibbo ];
  };
}
