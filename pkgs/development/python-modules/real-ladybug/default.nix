{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  cmake,
}:

buildPythonPackage (finalAttrs: {
  pname = "real-ladybug";
  version = "0.14.1";

  src = fetchPypi {
    pname = "real_ladybug";
    inherit (finalAttrs) version;
    hash = "sha256-lQbHQmvM4utWH7yCwKB4DM3KT+ODe2/HOc28q7lYMe8=";
  };

  pyproject = true;

  nativeBuildInputs = [
    setuptools-scm
    cmake
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "real_ladybug" ];

  meta = {
    description = "Python bindings for LadybugDB, an embeddable property graph database management system (fork of Kuzu)";
    homepage = "https://ladybugdb.com/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hamidr ];
  };
})
