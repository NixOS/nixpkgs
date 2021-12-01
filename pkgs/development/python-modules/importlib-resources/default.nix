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
  version = "5.4.0";

  src = fetchPypi {
    pname = "importlib_resources";
    inherit version;
    sha256 = "sha256-11bi+F3U3iuom+CyHboqO77C6HGkKjoWcZJYoR+HUGs=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    importlib-metadata
  ] ++ lib.optional (pythonOlder "3.4") [
    singledispatch
  ] ++ lib.optional (pythonOlder "3.5") [
    typing
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  pythonImportsCheck = [
    "importlib_resources"
  ];

  meta = with lib; {
    description = "Read resources from Python packages";
    homepage = "https://importlib-resources.readthedocs.io/";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
