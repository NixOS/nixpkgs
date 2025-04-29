{
  asgiref,
  buildPythonPackage,
  click,
  cryptography,
  fetchgit,
  flask,
  flit-core,
  highctidh,
  ifaddr,
  lib,
  pymonocypher,
  pysocks,
  requests,
  stem,
  toml,
  unittestCheckHook,
}:
buildPythonPackage {
  pname = "rendez";
  version = "1.2.1-unstable-2025-04-20";

  src = fetchgit {
    url = "https://codeberg.org/rendezvous/reunion.git";
    rev = "070fff7bcd233afde008b222413c6d757ee4b9a7";
    hash = "sha256-5aHHSeydDUA/Umf6YCzywVaTdmuLIu6RSCJuypUKWcQ=";
  };

  pyproject = true;
  nativeBuildInputs = [ flit-core ];

  dependencies = [
    asgiref
    click
    cryptography
    flask
    flask.optional-dependencies.async
    highctidh
    ifaddr
    pymonocypher
    pysocks
    requests
    stem
    toml
  ];

  doCheck = true;

  pythonImportsCheck = [ "rendez" ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    description = "The reference implementation of the REUNION cryptographic redezvous protocol";
    homepage = "https://codeberg.org/rendezvous/reunion";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mightyiam ];
  };
}
