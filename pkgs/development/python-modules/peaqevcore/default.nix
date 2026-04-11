{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "peaqevcore";
  version = "19.11.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v4VoRzQIeqKlxjMYveYL/B6p+2HcmpTkLq/8grl0wtY=";
  };

  postPatch = ''
    sed -i "/extras_require/d" setup.py
  '';

  build-system = [ setuptools ];

  # Tests are not shipped and source is not tagged
  # https://github.com/elden1337/peaqev-core/issues/4
  doCheck = false;

  pythonImportsCheck = [ "peaqevcore" ];

  meta = {
    description = "Library for interacting with Peaqev car charging";
    homepage = "https://github.com/elden1337/peaqev-core";
    changelog = "https://github.com/elden1337/peaqev-core/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
