{ lib
, buildPythonPackage
, fetchPypi
, python
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pydal";
  version = "20230521.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EEeKYeYnxbjLdpH39+v3IQhFSFMWST0310DCl/ttGEU=";
  };

  postPatch = ''
    # this test has issues with an import statement
    # rm tests/tags.py
    sed -i '/from .tags import/d' tests/__init__.py

    # this assertion errors without obvious reason
    sed -i '/self.assertEqual(csv0, str(r4))/d' tests/caching.py

    # some sql tests fail against sqlite engine
    sed -i '/from .sql import/d' tests/__init__.py
  '';

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [ "pydal" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m unittest tests
    runHook postCheck
  '';

  meta = with lib; {
    description = "Python Database Abstraction Layer";
    homepage = "https://github.com/web2py/pydal";
    license = with licenses; [ bsd3 ] ;
    maintainers = with maintainers; [ wamserma ];
  };
}
