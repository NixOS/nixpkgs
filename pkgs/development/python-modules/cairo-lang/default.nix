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
  version = "0.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchzip {
    url = "https://github.com/starkware-libs/cairo-lang/releases/download/v${version}/cairo-lang-${version}.zip";
    sha256 = "sha256-+PE7RSKEGADbue63FoT6UBOwURJs7lBNkL7aNlpSxP8=";
  };

  # TODO: remove a substantial part when https://github.com/starkware-libs/cairo-lang/pull/88/files is merged.
  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "lark-parser" "lark"

    substituteInPlace starkware/cairo/lang/compiler/parser_transformer.py \
      --replace 'value, meta' 'meta, value' \
      --replace 'value: Tuple[CommaSeparatedWithNotes], meta' 'meta, value: Tuple[CommaSeparatedWithNotes]'
    substituteInPlace starkware/cairo/lang/compiler/parser.py \
      --replace 'standard' 'basic'
  '';

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
