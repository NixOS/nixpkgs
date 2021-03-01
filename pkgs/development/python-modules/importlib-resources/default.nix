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
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7b51f0106c8ec564b1bef3d9c588bc694ce2b92125bbb6278f4f2f5b54ec3592";
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
