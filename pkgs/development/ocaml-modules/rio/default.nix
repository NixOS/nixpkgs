{
  lib,
  buildDunePackage,
  fetchurl,
  cstruct,
}:

buildDunePackage rec {
  pname = "rio";
  version = "0.0.8";

  minimalOCamlVersion = "5.1";

  src = fetchurl {
    url = "https://github.com/riot-ml/riot/releases/download/${version}/riot-${version}.tbz";
    hash = "sha256-SsiDz53b9bMIT9Q3IwDdB3WKy98WSd9fiieU41qZpeE=";
  };

  propagatedBuildInputs = [
    cstruct
  ];

  meta = {
    description = "Ergonomic, composable, efficient read/write streams";
    homepage = "https://github.com/riot-ml/riot";
    changelog = "https://github.com/riot-ml/riot/blob/${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
