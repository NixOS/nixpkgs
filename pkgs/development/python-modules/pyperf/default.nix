{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pythonOlder
, psutil
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "pyperf";
  version = "2.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n9m+W1ciTmi1pbiPcSbxW2yGZ1c/YqCjn68U1v3ROQk=";
  };

  patches = [
    (fetchpatch {
      name = "fix-pythonpath-in-tests.patch";
      url = "https://github.com/psf/pyperf/commit/d373c5e56c0257d2d7abd705b676bea25cf66566.patch";
      hash = "sha256-2q1fTf+uU3qj3BG8P5otX4f7mSTnQxm4sfmmgIUuszA=";
    })
  ];

  propagatedBuildInputs = [
    psutil
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  unittestFlagsArray = [ "-s" "pyperf/tests/" "-v" ];

  meta = with lib; {
    description = "Python module to generate and modify perf";
    homepage = "https://pyperf.readthedocs.io/";
    license = licenses.mit;
    maintainers = [ ];
  };
}
