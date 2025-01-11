{
  lib,
  stdenv,
  pythonAtLeast,
  fetchPypi,
  buildPythonPackage,
  greenlet,
}:

buildPythonPackage rec {
  pname = "meinheld";
  version = "1.0.2";
  format = "setuptools";

  disabled = pythonAtLeast "3.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "008c76937ac2117cc69e032dc69cea9f85fc605de9bac1417f447c41c16a56d6";
  };

  patchPhase = ''
    # Allow greenlet-1.0.0.
    # See https://github.com/mopemope/meinheld/pull/123
    substituteInPlace setup.py --replace "greenlet>=0.4.5,<0.5" "greenlet>=0.4.5"
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-Wno-error=implicit-function-declaration";

  propagatedBuildInputs = [ greenlet ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "meinheld" ];

  meta = with lib; {
    description = "High performance asynchronous Python WSGI Web Server";
    homepage = "https://meinheld.org/";
    license = licenses.bsd3;
  };
}
