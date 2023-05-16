<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchPypi
, morphys
, pytestCheckHook
, python-baseconv
, pythonOlder
=======
{ buildPythonPackage
, fetchPypi
, isPy27
, lib
, morphys
, pytest
, pytest-runner
, python-baseconv
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, six
}:
buildPythonPackage rec {
  pname = "py-multibase";
  version = "1.0.3";
<<<<<<< HEAD
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0oog78u2Huwo9VgnoL8ynHzqgP/9kzrsrqauhDEmf+Q=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "[pytest]" "" \
      --replace "python_classes = *TestCase" ""
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
  '';

  propagatedBuildInputs = [
    morphys
    python-baseconv
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "multibase"
  ];

  meta = with lib; {
    description = "Module for distinguishing base encodings and other simple string encodings";
    homepage = "https://github.com/multiformats/py-multibase";
    changelog = "https://github.com/multiformats/py-multibase/blob/v${version}/HISTORY.rst";
=======
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version ;
    sha256 = "d28a20efcbb61eec28f55827a0bf329c7cea80fffd933aecaea6ae8431267fe4";
  };

  postPatch = ''
    substituteInPlace setup.cfg --replace "[pytest]" ""
    substituteInPlace setup.cfg --replace "python_classes = *TestCase" ""
  '';

  nativeBuildInputs = [
    pytest-runner
  ];

  propagatedBuildInputs = [
    morphys
    six
    python-baseconv
  ];

  nativeCheckInputs = [
    pytest
  ];

  meta = with lib; {
    description = "Multibase is a protocol for distinguishing base encodings and other simple string encodings";
    homepage = "https://github.com/multiformats/py-multibase";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
