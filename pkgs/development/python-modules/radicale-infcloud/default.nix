{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  radicale,
  setuptools,
}:

buildPythonPackage {
  pname = "radicale-infcloud";
  version = "unstable-2022-04-18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Unrud";
    repo = "RadicaleInfCloud";
    rev = "53d3a95af5b58cfa3242cef645f8d40c731a7d95";
    hash = "sha256-xzBWIx2OOkCtBjlff1Z0VqgMhxWtgiOKutXUadT3tIo=";
  };

  build-system = [ setuptools ];

  dependencies = [ radicale ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "radicale" ];

  meta = with lib; {
    homepage = "https://github.com/Unrud/RadicaleInfCloud/";
    description = "Integrate InfCloud into Radicale's web interface";
    license = with licenses; [
      agpl3Plus
      gpl3Plus
    ];
    maintainers = with maintainers; [ erictapen ];
  };
}
