{ lib
, buildPythonPackage
, fetchPypi
, autoconf
, cython
}:

buildPythonPackage rec {
  pname = "dtlssocket";
  version = "0.1.12";

  src = fetchPypi {
    pname = "DTLSSocket";
    inherit version;
    sha256 = "909a8f52f1890ec9e92fd46ef609daa8875c2a1c262c0b61200e73c6c2dd5099";
  };

  nativeBuildInputs = [
    autoconf
    cython
  ];

  # no tests on PyPI, no tags on GitLab
  doCheck = false;

  pythonImportsCheck = [ "DTLSSocket" ];

  meta = with lib; {
    description = "Cython wrapper for tinydtls with a Socket like interface";
    homepage = "https://git.fslab.de/jkonra2m/tinydtls-cython";
    license = licenses.epl10;
    maintainers = with maintainers; [ dotlambda ];
  };
}
