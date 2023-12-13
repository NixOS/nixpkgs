{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, fusepy
, ratarmountcore
}:

buildPythonPackage rec {
  pname = "ratarmount";
  version = "0.14.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P+p0h+KuOsunPsXbRwxzAhr1XcEqMjQxHeHmA29+pDQ=";
  };

  propagatedBuildInputs = [ ratarmountcore fusepy ];

  checkPhase = ''
    runHook preCheck

    python tests/tests.py

    runHook postCheck
  '';

  meta = with lib; {
    description = "Mounts archives as read-only file systems by way of indexing";
    homepage = "https://github.com/mxmlnkn/ratarmount";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ mxmlnkn ];
    platforms = platforms.all;
  };
}
