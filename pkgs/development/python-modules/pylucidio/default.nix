{
  lib,
  buildPythonPackage,
  fetchzip,
  pdm-backend,
  pyserial,
}:

let
  version = "2.4.0";
  majorMinor = lib.versions.majorMinor version;
in
buildPythonPackage rec {
  pname = "pylucidio";
  inherit version;
  pyproject = true;

  src = fetchzip {
    url = "https://www.lucid-control.com/wp-content/uploads/Software/LucidControlAPI/PyLucidIo/${majorMinor}/pyLucidIo-${majorMinor}.zip";
    hash = "sha256-//TkFhHQorTRCF1ucLGf0/1B/6thmXWhnB7pwXpw1QE=";
    stripRoot = false;
    postFetch = ''
      cd $out
      tar -xf pylucidio-${version}.tar.gz --strip-components=1
      rm pylucidio-${version}.tar.gz *.whl
    '';
  };

  build-system = [ pdm-backend ];

  dependencies = [ pyserial ];

  pythonImportsCheck = [ "lucidIo" ];

  meta = {
    description = "LucidControl USB IO Module Package";
    homepage = "https://www.lucid-control.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kvik ];
  };
}
