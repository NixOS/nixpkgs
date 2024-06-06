{
  lib,
  aiomysql,
  aiosqlite,
  asyncpg,
  buildPythonPackage,
  databases,
  fetchFromGitHub,
  pythonOlder,
  typesystem,
}:

buildPythonPackage rec {
  pname = "orm";
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "encode";
    repo = "orm";
    rev = version;
    hash = "sha256-nlKEWdqttFnjBnXutlxTy9oILqFzKHKKPJpTtCUbJ5k=";
  };

  propagatedBuildInputs = [
    aiomysql
    aiosqlite
    asyncpg
    databases
    typesystem
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "typesystem==0.3.1" "typesystem"
  '';

  # Tests require databases
  doCheck = false;

  pythonImportsCheck = [ "orm" ];

  meta = with lib; {
    description = "An async ORM";
    homepage = "https://github.com/encode/orm";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
