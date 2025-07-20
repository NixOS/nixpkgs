{
  lib,
  buildPythonPackage,
  fetchzip,
  pdm-backend,
  pyserial,
}:

buildPythonPackage rec {
  pname = "pylucidio";
  version = "2.4";
  pyproject = true;

  src = fetchzip {
    url = "https://www.lucid-control.com/wp-content/uploads/Software/LucidControlAPI/PyLucidIo/${version}/pyLucidIo-${version}.zip";
    hash = "sha256-uIG5f26oXPSpWkqZSq5Voq7hZwUkQ1oQQutpxDYW834=";
    stripRoot = false;
  };

  unpackPhase = ''
    runHook preUnpack

    tar xf $src/pylucidio-${version}*.tar.gz
    sourceRoot=$(echo pylucidio-${version}*)

    runHook postUnpack
  '';

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
