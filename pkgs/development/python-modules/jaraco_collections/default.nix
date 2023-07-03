{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, setuptools-scm
, jaraco_classes
, jaraco_text
}:

buildPythonPackage rec {
  pname = "jaraco.collections";
  version = "4.3.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dP/CP8z+5N4KLr9VajNnW2o8AD1jNZR9MSKgvIgiyOQ=";
  };

  postPatch = ''
    # break dependency cycle
    sed -i "/'jaraco.text',/d" setup.cfg
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  propagatedBuildInputs = [
    jaraco_classes
    jaraco_text
  ];

  pythonNamespaces = [ "jaraco" ];

  doCheck = false;

  pythonImportsCheck = [ "jaraco.collections" ];

  meta = with lib; {
    description = "Models and classes to supplement the stdlib 'collections' module";
    homepage = "https://github.com/jaraco/jaraco.collections";
    changelog = "https://github.com/jaraco/jaraco.collections/blob/v${version}/NEWS.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
