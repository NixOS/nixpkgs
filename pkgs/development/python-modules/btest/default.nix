{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  multiprocess,
  setuptools,
}:

buildPythonPackage rec {
  pname = "btest";
  version = "1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zeek";
    repo = "btest";
    tag = "v${version}";
    hash = "sha256-hd/o79GFlmSS4u1IeEkK6l+apw8pinINxPkAZUe8U9U=";
  };

  build-system = [ setuptools ];

  dependencies = [ multiprocess ];

  # No tests available and no module to import
  doCheck = false;

  meta = {
    description = "Generic Driver for Powerful System Tests";
    homepage = "https://github.com/zeek/btest";
    changelog = "https://github.com/zeek/btest/blob/${src.tag}/CHANGES";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
