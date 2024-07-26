{ lib
, buildPythonPackage
, fetchPypi
, autoconf
, cython
, setuptools
}:

buildPythonPackage rec {
  pname = "dtlssocket";
  version = "0.1.16";

  format = "pyproject";

  src = fetchPypi {
    pname = "DTLSSocket";
    inherit version;
    hash = "sha256-MLEIrkX84cAz4+9sLd1+dBgGKuN0Io46f6lpslQ2ajk=";
  };

  nativeBuildInputs = [
    autoconf
    cython
    setuptools
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
