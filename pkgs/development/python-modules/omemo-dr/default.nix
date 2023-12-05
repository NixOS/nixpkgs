{ lib
, buildPythonPackage
, cryptography
, fetchPypi
, protobuf
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "omemo-dr";
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KoqMdyMdc5Sb3TdSeNTVomElK9ruUstiQayyUcIC02E=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cryptography
    protobuf
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "omemo_dr"
  ];

  meta = with lib; {
    description = "OMEMO Double Ratchet";
    homepage = "https://dev.gajim.org/gajim/omemo-dr/";
    changelog = "https://dev.gajim.org/gajim/omemo-dr/-/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}
