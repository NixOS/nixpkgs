{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  beets,
  httpx,
  packaging,
  pycountry,
}:

let
  pname = "beetcamp";
  version = "0.22.0";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hSmEamRW6LvP6rOh4zzOIJ9Lm2FhykpIFwEOgVcagSU=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    beets
    httpx
    packaging
    pycountry
  ];

  # Note: `pythonImportsCheck` is disabled as importing attempts to create the
  # config directory.

  meta = {
    description = "Bandcamp autotagger source for beets (http://beets.io)";
    homepage = "https://pypi.org/project/beetcamp/";
    license = lib.licenses.gpl2Only;
    maintainers = [
      lib.maintainers._9999years
    ];
  };
}
