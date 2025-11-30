{
  lib,
  idris2Packages,
  fetchFromGitHub,
  clang,
  chez,
  gmp,
  zsh,
  makeBinaryWrapper,
  stdenv,
}:
let
  inherit (idris2Packages) idris2Api buildIdris;

  elab-util = buildIdris {
    ipkgName = "elab-util";
    version = "2025-08-14";
    src = fetchFromGitHub {
      owner = "stefan-hoeck";
      repo = "idris2-elab-util";
      rev = "6786ac7ef9931b1c8321a83e007f36a66e139e86";
      hash = "sha256-qInoAE28tEJIP8/R0Yjgn/+DoIDzI3GU8BAyWaIrrJE=";
    };
    idrisLibraries = [ ];
  };

  filepath = buildIdris {
    ipkgName = "filepath";
    version = "2024-10-06";
    src = fetchFromGitHub {
      owner = "stefan-hoeck";
      repo = "idris2-filepath";
      rev = "0441eaee9ff1d921fc3f4619c2a8d542588c0e99";
      hash = "sha256-HiaT1Ggbzm7aAEMnCobhhavdheKbYyMA5D9BO0cdG7Y=";
    };
    idrisLibraries = [ ];
  };

  getopts = buildIdris {
    ipkgName = "getopts";
    version = "2023-10-28";
    src = fetchFromGitHub {
      owner = "idris-community";
      repo = "idris2-getopts";
      rev = "0d41b98f83f3707deb0ffbc595ef36b7d9cb9eab";
      hash = "sha256-CthWByg4uFic0ktri1AuFqkHtyRzIUrreCTegQgdpVo=";
    };
    idrisLibraries = [ ];
  };

  algebra = buildIdris {
    ipkgName = "algebra";
    version = "2024-04-05";
    src = fetchFromGitHub {
      owner = "stefan-hoeck";
      repo = "idris2-algebra";
      rev = "829f44b7fd961e3f0a7ad9174b395f97ebc33336";
      hash = "sha256-etsWqF07j/XBgfnlaA8pyF06BeoXqg7iViG0o09s4Zc=";
    };
    idrisLibraries = [ ];
  };

  ref1 = buildIdris {
    ipkgName = "ref1";
    version = "2025-10-30";
    src = fetchFromGitHub {
      owner = "stefan-hoeck";
      repo = "idris2-ref1";
      rev = "ef6d4265deaa6a4f1b5228932102847a4e54e4d2";
      hash = "sha256-NwA6KezZFdF/ZGTOf3Z1zDjsGiy2hgYinGPeeofhZfw=";
    };
    idrisLibraries = [ ];
  };

  array = buildIdris {
    ipkgName = "array";
    version = "2025-10-30";
    src = fetchFromGitHub {
      owner = "stefan-hoeck";
      repo = "idris2-array";
      rev = "cecbd1dd3bae94669a2ed3689ee91ce1616cc34f";
      hash = "sha256-fRhIzkvL7n7wyXNQE3LHalexqYmTt6RVPoVEOqTb7d4=";
    };
    idrisLibraries = [
      algebra
      ref1
    ];
  };

  bytestring = buildIdris {
    ipkgName = "bytestring";
    version = "2025-10-02";
    src = fetchFromGitHub {
      owner = "stefan-hoeck";
      repo = "idris2-bytestring";
      rev = "082c5114b4016425c9957e955e22fcb0b194ada4";
      hash = "sha256-KuHa1pDfsR4BmBiaw7k6ghZMf2/b+5AQc5I+NuQqbyw=";
    };
    idrisLibraries = [
      algebra
      array
    ];
  };

  refined = buildIdris {
    ipkgName = "refined";
    version = "2024-04-05";
    src = fetchFromGitHub {
      owner = "stefan-hoeck";
      repo = "idris2-refined";
      rev = "c585013c33ad5398c91beed71fec61a5b721a8da";
      hash = "sha256-9YQjVpJ5McpgjJx6hXCaXMKyEAFCnynw4ahHdY3Kz8Y=";
    };
    idrisLibraries = [
      elab-util
      algebra
    ];
  };

  ilex-core = buildIdris {
    ipkgName = "core/ilex-core";
    version = "2025-10-31";
    src = fetchFromGitHub {
      owner = "stefan-hoeck";
      repo = "idris2-ilex";
      rev = "c2d5a219c701a8f694aa95e8d34c7a58d58e5795";
      hash = "sha256-EseTOCNr0EuYqrjEd2SLqSz5ONOO3hRYghrHul0ccPA=";
    };
    idrisLibraries = [
      elab-util
      bytestring
    ];
  };

  ilex = buildIdris {
    ipkgName = "ilex";
    version = "2025-10-31";
    src = fetchFromGitHub {
      owner = "stefan-hoeck";
      repo = "idris2-ilex";
      rev = "c2d5a219c701a8f694aa95e8d34c7a58d58e5795";
      hash = "sha256-EseTOCNr0EuYqrjEd2SLqSz5ONOO3hRYghrHul0ccPA=";
    };
    idrisLibraries = [
      elab-util
      algebra
      array
      bytestring
      ilex-core
      refined
    ];
  };

  ilex-toml = buildIdris {
    ipkgName = "toml/ilex-toml";
    version = "2025-10-31";
    src = fetchFromGitHub {
      owner = "stefan-hoeck";
      repo = "idris2-ilex";
      rev = "c2d5a219c701a8f694aa95e8d34c7a58d58e5795";
      hash = "sha256-EseTOCNr0EuYqrjEd2SLqSz5ONOO3hRYghrHul0ccPA=";
    };
    idrisLibraries = [
      ilex
      refined
    ];
  };

  packPkg = buildIdris {
    ipkgName = "pack";
    version = "2025-11-06";
    src = fetchFromGitHub {
      owner = "stefan-hoeck";
      repo = "idris2-pack";
      rev = "37787fa16550ef761d3242bf8ccb8ab672d9f2d1";
      hash = "sha256-pvunaZSXj5Ee0utBFZfagxRKFuoSBxeU0IN7VTc56rY=";
    };
    idrisLibraries = [
      idris2Api
      elab-util
      filepath
      getopts
      ilex-toml
    ];

    nativeBuildInputs = [ makeBinaryWrapper ];

    buildInputs = [
      gmp
      clang
      chez
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ zsh ];

    postInstall = ''
      wrapProgram $out/bin/pack \
        --suffix C_INCLUDE_PATH : ${lib.makeIncludePath [ gmp ]} \
        --suffix PATH : ${
          lib.makeBinPath (
            [
              clang
              chez
            ]
            ++ lib.optionals stdenv.hostPlatform.isDarwin [ zsh ]
          )
        }
    '';

    meta = {
      description = "Idris2 Package Manager with Curated Package Collections";
      mainProgram = "pack";
      homepage = "https://github.com/stefan-hoeck/idris2-pack";
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [
        mattpolzin
        mithicspirit
      ];
      inherit (idris2Packages.idris2.meta) platforms;
    };
  };
in
packPkg.executable
