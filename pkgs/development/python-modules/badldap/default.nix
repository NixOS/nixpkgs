{
  lib,
  asn1crypto,
  asysocks,
  badauth,
  buildPythonPackage,
  fetchPypi,
  kerbad,
  prompt-toolkit,
  setuptools,
  tabulate,
  tqdm,
  unicrypto,
  unidns,
  wcwidth,
  winacl,
}:

buildPythonPackage (finalAttrs: {
  pname = "badldap";
  version = "0.7.7";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-goDMe+P72KvUjTRGnb2BWN6ECfrfFy48MTjU4zdwa40=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asn1crypto
    asysocks
    badauth
    kerbad
    prompt-toolkit
    tabulate
    tqdm
    unicrypto
    unidns
    wcwidth
    winacl
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "badldap" ];

  meta = {
    description = "LDAP library for auditing MS AD";
    homepage = "https://github.com/CravateRouge/badldap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
