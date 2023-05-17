{ lib
, aiohttp
, buildPythonPackage
, cachetools
, ecdsa
, eth-hash
, fastecdsa
, fetchzip
, frozendict
, gmp
, lark
, marshmallow
, marshmallow-dataclass
, marshmallow-enum
, marshmallow-oneofschema
, mpmath
, numpy
, pipdeptree
, prometheus-client
, pytest
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, pyyaml
, setuptools
, sympy
, typeguard
, web3
}:

buildPythonPackage rec {
  pname = "cairo-lang";
  version = "0.10.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchzip {
    url = "https://github.com/starkware-libs/cairo-lang/releases/download/v${version}/cairo-lang-${version}.zip";
    hash = "sha256-MNbzDqqNhij9JizozLp9hhQjbRGzWxECOErS3TOPlAA=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  buildInputs = [
    gmp
  ];

  propagatedBuildInputs = [
    aiohttp
    cachetools
    setuptools
    ecdsa
    fastecdsa
    sympy
    mpmath
    numpy
    typeguard
    frozendict
    prometheus-client
    marshmallow
    marshmallow-enum
    marshmallow-dataclass
    marshmallow-oneofschema
    pipdeptree
    lark
    web3
    eth-hash
    pyyaml
  ] ++ eth-hash.optional-dependencies.pycryptodome;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonRelaxDeps = [
    "frozendict"
  ];

  pythonRemoveDeps = [
    # TODO: pytest and pytest-asyncio must be removed as they are check inputs
    "pytest"
    "pytest-asyncio"
  ];

  postFixup = ''
    chmod +x $out/bin/*
  '';

  # There seems to be no test included in the ZIP release…
  # Cloning from GitHub is harder because they use a custom CMake setup
  # TODO(raitobezarius): upstream was pinged out of band about it.
  doCheck = false;

  meta = with lib; {
    description = "Tooling for Cairo language";
    homepage = "https://github.com/starkware/cairo-lang";
    license = licenses.mit;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
