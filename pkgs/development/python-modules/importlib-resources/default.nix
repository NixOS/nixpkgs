{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, toml
, importlib-metadata
, typing
, singledispatch
, pythonOlder
, python
}:

buildPythonPackage rec {
  pname = "importlib_resources";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19f745a6eca188b490b1428c8d1d4a0d2368759f32370ea8fb89cad2ab1106c3";
  };

  nativeBuildInputs = [ setuptools_scm toml ];
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
  };
}
