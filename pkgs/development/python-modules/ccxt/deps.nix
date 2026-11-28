{
  fetchFromGitHub,
  certifi,
  requests,
  aiohttp,
  aiodns,
  pycares,
  yarl,
  aiohttp-fast-zlib,
  multidict,
  coverage,
  charset-normalizer,
  setuptools,
  idna,
  urllib3,
}:

# https://github.com/ccxt/ccxt/pull/29093
# rerun `nix why-depends --derivation .#python3Packages.{ccxt,<drv>}` until no match
let
  certifi' = certifi.overridePythonAttrs rec {
    # https://github.com/NixOS/nixpkgs/pull/554025/changes/f64b15a4f03d3c7715f713934fd91d3d776daa75
    version = "2026.07.22";
    src = fetchFromGitHub {
      owner = "certifi";
      repo = "python-certifi";
      tag = version;
      hash = "sha256-euVWKJiFsx7F8YRMgRrrHswBmDBmrV/guiuvqtSUnSs=";
    };
  };
  aiohttp' = (
    aiohttp.override {
      multidict = multidict';
      yarl = yarl';
      aiodns = aiodns.override {
        pycares = pycares.override { idna = idna'; };
      };
    }
  );
  yarl' = yarl.override {
    multidict = multidict';
    idna = idna';
  };
  multidict' = multidict.overridePythonAttrs rec {
    version = "6.9.1";
    src = fetchFromGitHub {
      owner = "aio-libs";
      repo = "multidict";
      tag = "v${version}";
      hash = "sha256-Xe8n3Y8x5fOS+xme5pKJuiiU6y+oXosZLoEA1Rkp+Qw=";
    };
    # https://github.com/aio-libs/multidict/commit/ecc83e16512ff380b784294bdddaca169b47b1a4
    # or just remove `python -m coverage` like https://github.com/NixOS/nixpkgs/blob/6efd49fd338b7c7947843d5635620d99d017a9b5/pkgs/development/python-modules/typer/default.nix#L36
    nativeCheckInputs = [ coverage ];
  };
  charset-normalizer' =
    (charset-normalizer.override {
      setuptools = setuptools.overridePythonAttrs rec {
        # https://github.com/jawah/charset_normalizer/blob/b66f922bfbdbdd9dd46af18a8964d4fb888756d4/pyproject.toml#L2
        version = "82.0.1";
        src = fetchFromGitHub {
          owner = "pypa";
          repo = "setuptools";
          tag = "v${version}";
          hash = "sha256-M4fB+R4UNla2VlcWNhfDLvExQMpjLkPkgVsU4vg6ImU=";
        };
      };
    }).overridePythonAttrs # https://github.com/NixOS/nixpkgs/issues/370936#issuecomment-6699941196
      (
        final: prev: {
          # https://github.com/NixOS/nixpkgs/pull/541370/changes/59e6f2bdee0589aa705fa9584a5b81ad0c6cc864
          version = "3.4.7";
          src = fetchFromGitHub {
            owner = "jawah";
            repo = "charset_normalizer";
            tag = final.version;
            hash = "sha256-dOdJ4f98smCYdskp3BwtQG6aOyK+2a73+x580FKRWDk=";
          };
          postPatch = (prev.postPatch or "") + ''
            substituteInPlace _mypyc_hook/backend.py \
              --replace-fail "mypy>=1.4.1,<=1.20" "mypy"
          '';
        }
      );
  idna' = idna.overridePythonAttrs rec {
    # https://github.com/NixOS/nixpkgs/pull/531987/changes/71bf5cc8cb35b23e1bc393533a5177898fabbfbd
    version = "3.18";
    src = fetchFromGitHub {
      owner = "kjd";
      repo = "idna";
      tag = "v${version}";
      hash = "sha256-9nLy/9PNuLSQJsf4Jes0uN695+LGjz2LXlfiZxxvGV4=";
    };
  };
  urllib3' = urllib3.overridePythonAttrs rec {
    version = "2.8.0";
    src = fetchFromGitHub {
      owner = "urllib3";
      repo = "urllib3";
      tag = version;
      hash = "sha256-/EABIEAZDr5936K5Utjlx0nsGHWsHoimqC6dGDuOJAo=";
    };
    postPatch = ""; # https://github.com/NixOS/nixpkgs/pull/523660
  };
in
{
  certifi = certifi';
  requests = requests.override {
    idna = idna';
    urllib3 = urllib3';
    certifi = certifi';
    charset-normalizer = charset-normalizer';
  };
  aiohttp = aiohttp';
  yarl = yarl';
  aiohttp-fast-zlib = aiohttp-fast-zlib.override { aiohttp = aiohttp'; };
  multidict = multidict';
  charset-normalizer = charset-normalizer';
  idna = idna';
  urllib3 = urllib3';
}
