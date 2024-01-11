{ lib
, buildPythonPackage
, fetchPypi

# build-system
, setuptools-scm

# dependencies
, pytest
, starlette
, sniffio
, setuptools

# tests
, trio
 }:

buildPythonPackage rec {
  pname = "asgi-lifespan";
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Xi7/rwv+OYKc8tZOfsxHx9htZ2plmfevujeMMfXjowg=";
  };

  nativeBuildInputs = [
    setuptools-scm
    sniffio
  ];

  propagatedBuildInputs = [
    setuptools
    starlette
    sniffio
  ];

  nativeCheckInputs = [
    pytest
    trio
  ];

  doCheck = true;

  pythonImportsCheck = [ "asgi_lifespan" ];

  meta = with lib; {
    changelog = "https://github.com/florimondmanca/asgi-lifespan/releases/tag/${version}";
    description = "Programmatically send startup/shutdown lifespan events into ASGI applications";
    homepage = "https://github.com/florimondmanca/asgi-lifespan/";
    license = licenses.mit;
    maintainers = with maintainers; [ nviets ];
  };
}
