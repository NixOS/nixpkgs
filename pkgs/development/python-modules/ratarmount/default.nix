{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  fusepy,
  ratarmountcore,
}:

buildPythonPackage rec {
  pname = "ratarmount";
  version = "0.15.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hprXZGgE2fpg8Km3gWO60e7teUB4Age5skNPc4p+wIg=";
  };

  propagatedBuildInputs = [
    ratarmountcore
    fusepy
  ];

  checkPhase = ''
    runHook preCheck

    python tests/tests.py

    runHook postCheck
  '';

  meta = with lib; {
    description = "Mounts archives as read-only file systems by way of indexing";
    mainProgram = "ratarmount";
    homepage = "https://github.com/mxmlnkn/ratarmount";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ mxmlnkn ];
    platforms = platforms.all;
  };
}
