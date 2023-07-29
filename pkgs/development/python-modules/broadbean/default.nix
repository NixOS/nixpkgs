{ lib
, buildPythonPackage
, fetchPypi
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
    sha256 = "sha256-e+LAcmWxT+SkaWtToPgg+x3QRu5fCSm+w4dLCcyZrw8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'versioningit ~=' 'versioningit >='
  '';

  nativeBuildInputs = [ setuptools versioningit wheel ];

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
