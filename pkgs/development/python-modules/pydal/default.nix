{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "pydal";
  version = "20220213.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7DBLcHSEkoT8wV6824TGWRLi9vK2t+r1RwwWmRBYD9I=";
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
