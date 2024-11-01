{
  lib,
  fetchPypi,
  fetchpatch2,
  buildPythonPackage,
  setuptools,
  six,
  numpy,
  scipy, # optional, allows spline-related features (see patsy's docs)
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "patsy";
  version = "0.5.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lcbUenIiU1+Ev/f2PXMD8uKXdHpZjbic9cZ/DAx9LNs=";
  };

  patches = [
    # https://github.com/pydata/patsy/pull/212
    (fetchpatch2 {
      name = "numpy_2-compatibility.patch";
      url = "https://github.com/pydata/patsy/commit/251951dd7a4116be1cd34963780b87b4a67b79ae.patch";
      hash = "sha256-bgHqa8eygf9ADLmDY/8uebuYSFzkKG667BuXvQC4WB4=";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    six
    numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "patsy" ];

  meta = {
    description = "Python package for describing statistical models";
    homepage = "https://github.com/pydata/patsy";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ilya-kolpakov ];
  };
}
