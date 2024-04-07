{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, fusepy
, ratarmountcore
}:

buildPythonPackage rec {
  pname = "ratarmount";
  version = "0.14.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CZh27X5EmUiRYfeV0KOnpMrFDfa+qDFHr2pInD90UO8=";
  };

  propagatedBuildInputs = [ ratarmountcore fusepy ];

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
