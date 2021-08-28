{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, importlib-metadata
, typing ? null
, singledispatch ? null
, pythonOlder
, python
}:

buildPythonPackage rec {
  pname = "importlib-resources";
  version = "5.1.2";

  src = fetchPypi {
    pname = "importlib_resources";
    inherit version;
    sha256 = "642586fc4740bd1cad7690f836b3321309402b20b332529f25617ff18e8e1370";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [
    importlib-metadata
  ] ++ lib.optional (pythonOlder "3.4") singledispatch
    ++ lib.optional (pythonOlder "3.5") typing
  ;

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with lib; {
    description = "Read resources from Python packages";
    homepage = "https://importlib-resources.readthedocs.io/";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
