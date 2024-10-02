{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  setuptools-scm,
  sniffio,
}:

buildPythonPackage rec {
  pname = "asgi-lifespan";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "florimondmanca";
    repo = "asgi-lifespan";
    rev = "refs/tags/${version}";
    hash = "sha256-Jgmd/4c1lxHM/qi3MJNN1aSSUJrI7CRNwwHrFwwcCkc=";
  };

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ sniffio ];

  # Circular dependencies, starlette
  doCheck = false;

  pythonImportsCheck = [ "asgi_lifespan" ];

  meta = with lib; {
    description = "Programmatic startup/shutdown of ASGI apps";
    homepage = "https://github.com/florimondmanca/asgi-lifespan";
    changelog = "https://github.com/florimondmanca/asgi-lifespan/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
