{
  lib,
  buildPythonPackage,
  fetchPypi,
  typing-extensions,
  uv-build,
}:

buildPythonPackage rec {
  pname = "celery-types";
  version = "0.24.0";
  pyproject = true;

  src = fetchPypi {
    pname = "celery_types";
    inherit version;
    hash = "sha256-yT+80LBKnpwvVdVUCspKoepMwGqHDAyN7lBi/dWWY/4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.18,<0.10.0" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [ typing-extensions ];

  doCheck = false;

  meta = {
    description = "PEP-484 stubs for Celery";
    homepage = "https://github.com/sbdchd/celery-types";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
