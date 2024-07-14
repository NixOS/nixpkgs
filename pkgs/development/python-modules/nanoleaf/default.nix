{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nanoleaf";
  version = "0.4.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GmnwW/IleBlvsGj1YwSPZrOho9uVlWeNzpZX6VbstZ0=";
  };

  prePatch = ''
    sed -i '/^gitVersion =/d' setup.py
    substituteInPlace setup.py \
      --replace-fail 'gitVersion' '"${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [ "nanoleaf" ];

  meta = with lib; {
    description = "Module for interacting with Nanoleaf Aurora lighting";
    homepage = "https://github.com/software-2/nanoleaf";
    changelog = "https://github.com/software-2/nanoleaf/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
