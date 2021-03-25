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
  version = "3.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ed250dbd291947d1a298e89f39afcc477d5a6624770503034b72588601bcc05";
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
