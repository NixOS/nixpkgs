{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  scipy,
  sympy,
  setuptools,
  pytestCheckHook,
  cython,
  fetchpatch2,
}:

buildPythonPackage rec {
  pname = "pydy";
  version = "0.7.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aaRinJMGR8v/OVkeSp1hA4+QLOrmDWq50wvA6b/suvk=";
  };

  build-system = [ setuptools ];

  patches = [
    # Migrate tests to pytest
    (fetchpatch2 {
      url = "https://github.com/pydy/pydy/commit/e679638fecf80def25f5ed20f01c49c5d931e4d8.patch?full_index=1";
      hash = "sha256-wJmYkyc5Yh0152OyNL5ZbZJxmpX7C65Hqrms4gm3zt0=";
      excludes = [
        ".github/workflows/oldest.yml"
        ".github/workflows/tests.yml"
        "bin/test"
      ];
    })
  ];

  dependencies = [
    numpy
    scipy
    sympy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    cython
  ];

  pythonImportsCheck = [ "pydy" ];

  meta = {
    description = "Python tool kit for multi-body dynamics";
    homepage = "http://pydy.org";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
