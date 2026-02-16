{
  buildPythonPackage,
  django,
  django-rest-framework,
  fetchFromGitHub,
  lib,
  nix-update-script,
  setuptools,
}:

buildPythonPackage rec {
  pname = "drf_dynamic_fields";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbrgn";
    repo = "drf-dynamic-fields";
    tag = "v${version}";
    hash = "sha256-TD6NNiJ9kZJgtSjnKrXnWvmeXBcR10776Hh4JzECLY8=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    django
    django-rest-framework
  ];

  checkPhase = ''
    python runtests.py
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dynamically select only a subset of fields per DRF resource";
    homepage = "https://github.com/dbrgn/drf-dynamic-fields";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mrtipson ];
  };
}
