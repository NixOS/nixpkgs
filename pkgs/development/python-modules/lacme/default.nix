{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  cryptography,
  acme,
  httpx,
}:

buildPythonPackage rec {
  pname = "lacme";
  version = "1.0.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1375hprc5fy9lr0crg84y2nd03rp9z8zpmzpk8k1r7wah1kbgkf1";
  };

  build-system = [ hatchling ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatchling>=1.29" "hatchling>=1.28"
  '';

  dependencies = [
    cryptography
    acme
    httpx
  ];

  doCheck = false;

  meta = {
    description = "A lightweight ACME client for Python";
    homepage = "https://github.com/turnstonelabs/lacme";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
