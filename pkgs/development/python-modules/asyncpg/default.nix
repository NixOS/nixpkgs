{ lib
, fetchPypi
, buildPythonPackage
, uvloop
, postgresql
, pythonOlder
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "asyncpg";
  version = "0.29.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0cSeH0T/+v2aVeGpsQFZCFnYgdY56ikiUW9dnFEtNU4=";
  };

  # sandboxing issues on aarch64-darwin, see https://github.com/NixOS/nixpkgs/issues/198495
  doCheck = postgresql.doCheck;

  nativeCheckInputs = [
    uvloop
    postgresql
    pytest-xdist
    pytestCheckHook
  ];

  preCheck = ''
    rm -rf asyncpg/
  '';

  pythonImportsCheck = [
    "asyncpg"
  ];

  meta = with lib; {
    description = "Asyncio PosgtreSQL driver";
    homepage = "https://github.com/MagicStack/asyncpg";
    changelog = "https://github.com/MagicStack/asyncpg/releases/tag/v${version}";
    longDescription = ''
      Asyncpg is a database interface library designed specifically for
      PostgreSQL and Python/asyncio. asyncpg is an efficient, clean
      implementation of PostgreSQL server binary protocol for use with Python's
      asyncio framework.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ eadwu ];
  };
}
