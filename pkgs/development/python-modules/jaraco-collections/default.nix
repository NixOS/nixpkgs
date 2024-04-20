{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, setuptools-scm
, jaraco-classes
, jaraco-text
}:

buildPythonPackage rec {
  pname = "jaraco-collections";
  version = "5.0.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "jaraco.collections";
    inherit version;
    hash = "sha256-FoDo0J8pX2Jce6kmiAF1om/b5wkrTHbRmOMEdrIc/mg=";
  };

  postPatch = ''
    # break dependency cycle
    sed -i "/'jaraco.text',/d" setup.cfg
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    jaraco-classes
    jaraco-text
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
