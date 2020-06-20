{ lib, fetchPypi, fetchpatch, isPy27
, buildPythonPackage
, traits, apptools
, python, ipykernel, ipython
}:

buildPythonPackage rec {
  pname = "envisage";
  version = "4.9.2";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1srjmkhnz84nz5jd72vdsnc4fn7dd9jr8nyf3hzk6yx1dsn815gd";
  };

  propagatedBuildInputs = [ traits apptools ];

  preCheck = ''
    export HOME=$PWD/HOME
  '';

  # fix a test failure; should be merged in next release
  patches = [ (fetchpatch {
    url = "https://github.com/enthought/envisage/pull/248/commits/7b6d2dd615d5cb7455b200eb8f37e030bbf4df9e.patch";
    sha256 = "0a3dmbpxwsn1bkjcjv9v7b751rcmppj6hc9wcgiayg4l9r2nrvyh";
  }) ];

  checkInputs = [
    ipykernel ipython
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m unittest
    runHook postCheck
  '';

  meta = with lib; {
    description = "Framework for building applications whose functionalities can be extended by adding 'plug-ins'";
    homepage = "https://github.com/enthought/envisage";
    maintainers = with lib.maintainers; [ knedlsepp ];
    license = licenses.bsdOriginal;
  };
}
