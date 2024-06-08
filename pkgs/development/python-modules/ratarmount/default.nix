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
  version = "0.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2slLshH07O+4PIU3dF9vX2ZcXjaUVyTFYc59LL2J5iY=";
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
