{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pythonOlder
, setuptools
, versioningit
, wheel
, numpy
, matplotlib
, schema
, hypothesis
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "broadbean";
  version = "0.11.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-e+LAcmWxT+SkaWtToPgg+x3QRu5fCSm+w4dLCcyZrw8=";
  };

  patches = [
    # https://github.com/QCoDeS/broadbean/pull/538
    (fetchpatch {
      name = "drop-wheel-from-pyproject.patch";
      url = "https://github.com/QCoDeS/broadbean/commit/31a2147e4f452fef1ca2b56b1cb0b10ac85ac867.patch";
      hash = "sha256-lBikIRhaf3ecwE7NZrYWeHkQCHQdfS9eeOcFExGIsVk=";
    })
    # https://github.com/QCoDeS/broadbean/pull/638
    (fetchpatch {
      name = "unpin-versioningit-dependency.patch";
      url = "https://github.com/QCoDeS/broadbean/commit/e4fd6c38d076aa3a6542dcd8fa7d2eb9d7a9b789.patch";
      hash = "sha256-mw68pWAjztWBw22MeoWVbwIwjzMOJRtv6HctN3v6A2A=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    versioningit
    wheel
  ];

  propagatedBuildInputs = [
    numpy
    matplotlib
    schema
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "broadbean" ];

  meta = {
    homepage = "https://qcodes.github.io/broadbean";
    description = "A library for making pulses that can be leveraged with QCoDeS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ evilmav ];
  };
}
