{ lib, fetchFromGitHub, buildPythonPackage, radicale }:

buildPythonPackage {
  pname = "radicale_infcloud";
  version = "unstable-2022-04-18";

  src = fetchFromGitHub {
    owner = "Unrud";
    repo = "RadicaleInfCloud";
    rev = "53d3a95af5b58cfa3242cef645f8d40c731a7d95";
    hash = "sha256-xzBWIx2OOkCtBjlff1Z0VqgMhxWtgiOKutXUadT3tIo=";
  };

  propagatedBuildInputs = [ radicale ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "radicale" ];

  meta = with lib; {
    homepage = "https://github.com/Unrud/RadicaleInfCloud/";
    description = "Integrate InfCloud into Radicale's web interface";
    license = with licenses; [ agpl3 gpl3 ];
    maintainers = with maintainers; [ erictapen ];
  };
}
