{
  lib,
  buildPythonPackage,
  fetchPypi,
  typing-extensions,
  uv-build,
}:

buildPythonPackage rec {
  pname = "celery-types";
  version = "0.26.0";
  pyproject = true;

  src = fetchPypi {
    pname = "celery_types";
    inherit version;
    hash = "sha256-+jGBNv2tg/g/FTHe7Nn+Zktd///ynzwx6RIKRrjjkI8=";
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
