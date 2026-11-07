{
  lib,
  buildPythonPackage,
  fetchFromCodeberg,
  python-magic,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pycketcasts";
  version = "1.0.1-unstable-2022-07-12";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "nwithan8";
    repo = "pycketcasts";
    rev = "8211de74fada8854bb0775fac6780a2205bb7cf2";
    hash = "sha256-O4j89fE7fYPthhCH8b2gGskkelEA4mU6GvSbKIl+4Mk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-magic
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pycketcasts" ];

  meta = {
    description = "Module to interact with PocketCast's unofficial API";
    homepage = "https://codeberg.org/nwithan8/pycketcasts";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
