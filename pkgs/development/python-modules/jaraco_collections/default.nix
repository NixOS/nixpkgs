{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, jaraco_classes
, jaraco_text
}:

buildPythonPackage rec {
  pname = "jaraco.collections";
  version = "3.8.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VjBP1L1OuNWFzgys4KyAQYeRsUCFHjdIElQbCqJ8kdA=";
  };

  postPatch = ''
    # break dependency cycle
    sed -i "/'jaraco.text',/d" setup.cfg
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

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
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
