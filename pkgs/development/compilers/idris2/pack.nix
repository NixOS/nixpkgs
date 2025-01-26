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
  toml = buildIdris {
    ipkgName = "toml";
    version = "2022-05-05";
    src = fetchFromGitHub {
      owner = "cuddlefishie";
      repo = "toml-idr";
      rev = "b4f5a4bd874fa32f20d02311a62a1910dc48123f";
      hash = "sha256-+bqfCE6m0aJ+S65urT+zQLuZUtUkC1qcuSsefML/fAE=";
    };
    idrisLibraries = [ ];
  };
  filepath = buildIdris {
    ipkgName = "filepath";
    version = "2023-12-04";
    src = fetchFromGitHub {
      owner = "stefan-hoeck";
      repo = "idris2-filepath";
      rev = "eac02d51b631633f32330c788bcebeb24221fa09";
      hash = "sha256-noylxQvT2h50H0xmAiwe/cI6vz5gkbOhSD7mXuhJGfU=";
    };
    idrisLibraries = [ ];
  };
  packPkg = buildIdris {
    ipkgName = "pack";
    version = "2024-02-07";
    src = fetchFromGitHub {
      owner = "stefan-hoeck";
      repo = "idris2-pack";
      rev = "305123401a28a57b02f750c589c35af628b2a5eb";
      hash = "sha256-IPAkwe6fEYWT3mpyKKkUPU0qFJX9gGIM1f7OeNWyB9w=";
    };
    idrisLibraries = [
      idris2Api
      toml
      filepath
    ];

    nativeBuildInputs = [ makeBinaryWrapper ];

    buildInputs = [
      gmp
      clang
      chez
    ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ zsh ];

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
      description = "An Idris2 Package Manager with Curated Package Collections";
      mainProgram = "pack";
      homepage = "https://github.com/stefan-hoeck/idris2-pack";
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [ mattpolzin ];
      inherit (idris2Packages.idris2.meta) platforms;
    };
  };
in
packPkg.executable
