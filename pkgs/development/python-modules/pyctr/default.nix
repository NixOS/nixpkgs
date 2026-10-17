{
  lib,
  buildPythonPackage,
  fetchPypi,
  pycryptodomex,
}:

buildPythonPackage rec {
  pname = "pyctr";
  version = "0.7.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8Vgesn/uLe9rq2JqdUy0qL9FOmglJ7vxr5gRsGNGhAI=";
  };

  propagatedBuildInputs = [ pycryptodomex ];

  pythonImportsCheck = [ "pyctr" ];

  meta = {
    description = "Python library to interact with Nintendo 3DS files";
    homepage = "https://github.com/ihaveamac/pyctr";
    changelog = "https://github.com/ihaveamac/pyctr/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
