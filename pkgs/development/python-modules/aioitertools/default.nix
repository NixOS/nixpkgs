{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, pythonAtLeast
, pythonOlder

# native
, flit-core

# propagates
, typing-extensions

# tests
, python
}:

buildPythonPackage rec {
  pname = "aioitertools";
  version = "0.8.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b02facfbc9b0f1867739949a223f3d3267ed8663691cc95abd94e2c1d8c2b46";
  };

  patches = lib.optionals (pythonAtLeast "3.10") [
    (fetchpatch {
      # Fix TypeError: wait() got an unexpected keyword argument 'loop'
      # See https://github.com/omnilib/aioitertools/issues/84
      url = "https://raw.githubusercontent.com/archlinux/svntogit-community/packages/python-aioitertools/trunk/python310.patch";
      sha256 = "sha256-F10sduGaLBcxEoP83N/lGpZIlzkM2JTnQnhHKFwc7P0=";
    })
  ];

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  pythonImportsCheck = [
    "aioitertools"
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with lib; {
    description = "Implementation of itertools, builtins, and more for AsyncIO and mixed-type iterables.";
    license = licenses.mit;
    homepage = "https://pypi.org/project/aioitertools/";
    maintainers = with maintainers; [ teh ];
  };
}
