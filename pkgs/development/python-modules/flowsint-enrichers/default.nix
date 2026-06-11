{
  lib,
  buildPythonPackage,
  dnspython,
  fetchFromGitHub,
  flowsint,
  hibpwned,
  holehe,
  httpx,
  ignorant,
  maigret,
  phonenumbers,
  poetry-core,
  pydantic,
  pydig,
  python-whois,
  reconcrawl,
  reconspread,
  recontrack,
  requests-random-user-agent,
  requests,
  sherlock-project,
  spacy,
}:

buildPythonPackage (finalAttrs: {
  pname = "flowsint-enrichers";
  pyproject = true;

  inherit (flowsint) src version;

  sourceRoot = "${finalAttrs.src.name}/${finalAttrs.pname}";

  pythonRelaxDeps = [
    "alembic"
    "bcrypt"
    "cryptography"
    "fastapi"
    "jsonschema"
    "neo4j"
    "networkx"
    "redis"
    "sherlock-project"
    "sse-starlette"
    "uvicorn"
  ];

  pythonRemoveDeps = [
    # Circular dependency
    "flowsint-types"
    "flowsint-core"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    dnspython
    hibpwned
    holehe
    httpx
    ignorant
    maigret
    phonenumbers
    pydantic
    pydig
    python-whois
    reconcrawl
    reconspread
    recontrack
    requests
    requests-random-user-agent
    sherlock-project
    spacy
  ];

  # Circular dependency
  doCheck = false;
  # pythonImportsCheck = [ "flowsint_enrichers" ];

  meta = {
    description = "Enrichers for flowsint";
    homepage = "https://github.com/reconurge/flowsint/blob/main/flowsint-enrichers";
    changelog = "https://github.com/reconurge/flowsint/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
