{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest7CheckHook,
  six,
}:

buildPythonPackage rec {
  pname = "nocasedict";
  version = "2.0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TKk09l31exDQ/KtfDDnp3MuTV3/58ivvmCZd2/EvivE=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytest7CheckHook ];

  pythonImportsCheck = [ "nocasedict" ];

  meta = with lib; {
    description = "Case-insensitive ordered dictionary for Python";
    homepage = "https://github.com/pywbem/nocasedict";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ freezeboy ];
  };
}
