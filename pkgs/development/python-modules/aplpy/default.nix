{
  lib,
  astropy,
  buildPythonPackage,
  fetchpatch,
  fetchPypi,
  matplotlib,
  numpy,
  pillow,
  pyavm,
  pyregion,
  pytest-astropy,
  pytestCheckHook,
  pythonOlder,
  reproject,
  scikit-image,
  setuptools,
  setuptools-scm,
  shapely,
  wheel,
}:

buildPythonPackage rec {
  pname = "aplpy";
  version = "2.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "aplpy";
    inherit version;
    hash = "sha256-KCdmBwQWt7IfHsjq7pWlbSISEpfQZDyt+SQSTDaUCV4=";
  };

  # Fix build with Astropy 6.1, Python 3.12 and matplotlib 3.9
  patches = [
    # https://github.com/aplpy/aplpy/pull/496
    (fetchpatch {
      url = "https://github.com/aplpy/aplpy/commit/d232a4984bc6a83ec86dfdc3ab3bc1b05de44c48.patch";
      hash = "sha256-jGUTzIrVdGNPy0BV8w46jzz045fDXBisiwIn90bn7oY=";
    })
    # https://github.com/aplpy/aplpy/pull/497
    (fetchpatch {
      url = "https://github.com/aplpy/aplpy/commit/468be394970b39f1aaa6debef51eb674e2dd86d8.patch";
      hash = "sha256-/ovLrFOKb3RQ8TZSviuOV6EYNgz0gtrhVWZLFJBrzFg=";
    })
    # https://github.com/aplpy/aplpy/pull/500
    (fetchpatch {
      url = "https://github.com/aplpy/aplpy/commit/c9049261b3724821f4d309d85fe73cabcc04d890.patch";
      hash = "sha256-ivdXLh1Z+WG3EL5u1wO+lqz6X1AP6WpyoZix5YiqW0w=";
    })
    # https://github.com/aplpy/aplpy/pull/503
    (fetchpatch {
      url = "https://github.com/aplpy/aplpy/commit/edc2aa9770b72bd3ac42db95a6e027b276be9c31.patch";
      hash = "sha256-QUZenY3XQ/T2tl5apxZUqjf4ACjOzJWb+1AUp5limi4=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    astropy
    matplotlib
    numpy
    pillow
    pyavm
    pyregion
    reproject
    scikit-image
    shapely
  ];

  nativeCheckInputs = [
    pytest-astropy
    pytestCheckHook
  ];

  preCheck = ''
    OPENMP_EXPECTED=0
  '';

  pythonImportsCheck = [ "aplpy" ];

  meta = with lib; {
    description = "Astronomical Plotting Library in Python";
    homepage = "http://aplpy.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ smaret ];
  };
}
