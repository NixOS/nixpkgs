{ lib
, fetchzip
, buildPythonPackage
, setuptools
, ecdsa
, fastecdsa
, sympy
, frozendict
, marshmallow
, marshmallow-enum
, marshmallow-dataclass
, marshmallow-oneofschema
, pipdeptree
, eth-hash
, web3
, aiohttp
, cachetools
, mpmath
, numpy
, prometheus-client
, typeguard
, lark
, pyyaml
, pytest-asyncio
, pytest
, pytestCheckHook
, gmp
}:

buildPythonPackage rec {
  pname = "cairo-lang";
  version = "0.9.1";

  src = fetchzip {
    url = "https://github.com/starkware-libs/cairo-lang/releases/download/v${version}/cairo-lang-${version}.zip";
    sha256 = "sha256-i4030QLG6PssfKD5FO4VrZxap19obMZ3Aa77p5MXlNY=";
  };

  # TODO: remove a substantial part when https://github.com/starkware-libs/cairo-lang/pull/88/files is merged.
  # TODO: pytest and pytest-asyncio must be removed as they are check inputs in fact.
  postPatch = ''
    substituteInPlace requirements.txt \
      --replace 'frozendict==1.2' 'frozendict>=1.2' \
      --replace 'lark-parser' 'lark' \
      --replace 'pytest-asyncio' ''' \
      --replace "pytest" '''

    substituteInPlace starkware/cairo/lang/compiler/parser_transformer.py \
      --replace 'value, meta' 'meta, value' \
      --replace 'value: Tuple[CommaSeparatedWithNotes], meta' 'meta, value: Tuple[CommaSeparatedWithNotes]'
    substituteInPlace starkware/cairo/lang/compiler/parser.py \
      --replace 'standard' 'basic'
  '';

  buildInputs = [ gmp ];

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
    eth-hash.optional-dependencies.pycryptodome
    pyyaml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # There seems to be no test included in the ZIP release…
  # Cloning from GitHub is harder because they use a custom CMake setup
  # TODO(raitobezarius): upstream was pinged out of band about it.
  doCheck = false;

  meta = {
    homepage = "https://github.com/starkware/cairo-lang";
    description = "Tooling for Cairo language";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ raitobezarius ];
  };
}
