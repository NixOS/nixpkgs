{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, importlib-metadata
, typing
, singledispatch
, python
}:

buildPythonPackage rec {
  pname = "importlib-resources";
  version = "3.3.1";

  src = fetchPypi {
    pname = "importlib_resources";
    inherit version;
    sha256 = "0ed250dbd291947d1a298e89f39afcc477d5a6624770503034b72588601bcc05";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [
    importlib-metadata
    singledispatch
    typing
  ];

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
