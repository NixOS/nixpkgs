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
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jilyxyb2z7hzcjhx1ddni52mq00i728wqh8f5k4469yhdkdz1vg";
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
