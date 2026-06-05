{
  stdenv,
  lib,
  fetchurl,
  fetchFromGitHub,
  gnat,
  gnatcoll-core,
  gnatcoll-gmp,
  gnatcoll-iconv,
  gprbuild,
  sarif-ada,
  vss-extra,
  python3,
  ocamlPackages,
  makeWrapper,
  gpr2,
}:
let
  gnat_version = lib.versions.major gnat.version;

  # gnatprove fsf-14 requires gpr2 from a special branch
  gpr2_24_2_next = gpr2.overrideAttrs (
    final: _: {
      version = "24.2.0-next";
      src = fetchFromGitHub {
        owner = "AdaCore";
        repo = "gpr";
        tag = "v${final.version}";
        hash = "sha256-Tp+N9VLKjVWs1VRPYE0mQY3rl4E5iGb8xDoNatEYBg4=";
      };
      patches = [ ];
    }
  );

  # gnatprove fsf-15 requires gnatcoll/gpr2 version 25.0.0
  gnatcoll-core_25 = gnatcoll-core.overrideAttrs (
    final: _: {
      version = "25.0.0";

      src = fetchFromGitHub {
        owner = "AdaCore";
        repo = "gnatcoll-core";
        tag = "v${final.version}";
        hash = "sha256-z7zwPUHDKgmmQOzsS7+DL1+gwLvEM0j8F8wQDfeBNus=";
      };
    }
  );
  gnatcoll-iconv_25 =
    (gnatcoll-iconv.override {
      gnatcoll-core = gnatcoll-core_25;
    }).overrideAttrs
      (
        final: _: {
          version = "25.0.0";

          src = fetchFromGitHub {
            owner = "AdaCore";
            repo = "gnatcoll-bindings";
            tag = "v${final.version}";
            hash = "sha256-s8VinVPm0syS8kdU1rswU+ePUBdTZvg72CBxtPc/zCs=";
          };
        }
      );
  gnatcoll-gmp_25 =
    (gnatcoll-gmp.override {
      gnatcoll-core = gnatcoll-core_25;
    }).overrideAttrs
      (
        final: _: {
          version = "25.0.0";

          src = fetchFromGitHub {
            owner = "AdaCore";
            repo = "gnatcoll-bindings";
            tag = "v${final.version}";
            hash = "sha256-s8VinVPm0syS8kdU1rswU+ePUBdTZvg72CBxtPc/zCs=";
          };
        }
      );
  gpr2_25 =
    (gpr2.override {
      # Comes with a pre-generated kb config
      gpr2kbdir = null;
      gnatcoll-core = gnatcoll-core_25;
      gnatcoll-iconv = gnatcoll-iconv_25;
      gnatcoll-gmp = gnatcoll-gmp_25;
    }).overrideAttrs
      (
        final: _: {
          version = "25.0.0";
          src = fetchurl {
            url = "https://github.com/AdaCore/gpr/releases/download/v25.0.0/gpr2-with-gprconfig_kb-25.0.tgz";
            hash = "sha256-bhOJvAALpbZUbxer370M2h7vbJby3gOOJdwuWERe3rY=";
          };
          patches = [ ];
        }
      );

  gpr2' =
    {
      "14" = gpr2_24_2_next;
      "15" = gpr2_25;
      "16" = gpr2;
    }
    ."${gnat_version}" or null;
  gnatcoll-core' = if gnat_version == "15" then gnatcoll-core_25 else gnatcoll-core;

  # TODO:
  # Build why3 (github.com/AdaCore/why3) as separate package and not as submodule.
  # The relevant tags on why3 may get changed without the submodule pointer being updated.

  fetchSpark2014 =
    { rev, hash }:
    fetchFromGitHub {
      owner = "AdaCore";
      repo = "spark2014";
      fetchSubmodules = true;
      inherit rev hash;
    };

  spark2014 = {
    "13" = {
      src = fetchSpark2014 {
        rev = "12db22e854defa9d1c993ef904af1e72330a68ca"; # branch fsf-13
        hash = "sha256-mZWP9yF1O4knCiXx8CqolnS+93bM+hTQy40cd0HZmwI=";
      };
      commit_date = "2023-01-05";
      patches = [
        # Changes to the GNAT frontend: https://github.com/AdaCore/spark2014/issues/58
        ./0003-Adjust-after-category-change-for-N_Formal_Package_De.patch
      ];
    };
    "14" = {
      src = fetchSpark2014 {
        rev = "ce5fad038790d5dc18f9b5345dc604f1ccf45b06"; # branch fsf-14
        hash = "sha256-WprJJIe/GpcdabzR2xC2dAV7kIYdNTaTpNYoR3UYTVo=";
      };
      patches = [
        # Disable Coq related targets which are missing in the fsf-14 branch
        ./0001-fix-install-fsf-14.patch

        # Suppress warnings on aarch64: https://github.com/AdaCore/spark2014/issues/54
        ./0002-mute-aarch64-warnings.patch

        # Changes to the GNAT frontend: https://github.com/AdaCore/spark2014/issues/58
        ./0003-Adjust-after-category-change-for-N_Formal_Package_De.patch
      ];
      commit_date = "2024-01-11";
    };
    "15" = {
      src = fetchSpark2014 {
        rev = "22bf1510e0829ba74f9d8d686badb65c7365ee91"; # branch fsf-15
        hash = "sha256-KjAWMgMT3Tp/s/DQ20ZZajty9Zrv8aPFocwgv5LkjSw=";
      };
      patches = [
        # Disable Coq related targets which are missing in the fsf-15 branch
        ./0001-fix-install-fsf-15.patch

        # Suppress warnings on aarch64: https://github.com/AdaCore/spark2014/issues/54
        ./0002-mute-aarch64-warnings.patch
      ];
      commit_date = "2025-06-10";
    };
    "16" = {
      src = fetchSpark2014 {
        rev = "42554fc241fcd1fdf08d3a2feccb3f86912acbc0"; # branch fsf-16
        hash = "sha256-3dkEVrgBu5ks4O/08DEaVfbeQ9qaDo2DJA9mH1XnI+0=";
      };
      patches = [
        # Disable Coq related targets which are missing in the fsf-16 branch
        ./0001-fix-install-fsf-16.patch

        # Suppress warnings on aarch64: https://github.com/AdaCore/spark2014/issues/54
        ./0002-mute-aarch64-warnings.patch
      ];
      commit_date = "2026-01-05";
    };
  };

  thisSpark =
    spark2014.${gnat_version}
      or (throw "GNATprove depends on a specific GNAT version and can't be built using GNAT ${gnat_version}.");

in
stdenv.mkDerivation {
  pname = "gnatprove";
  version = "${gnat_version}-fsf-${thisSpark.commit_date}";

  src = thisSpark.src;

  patches = thisSpark.patches or [ ];

  nativeBuildInputs = [
    gnat
    gprbuild
    python3
    makeWrapper
  ]
  ++ (with ocamlPackages; [
    ocaml
    findlib
    menhir
  ]);

  buildInputs = [
    gnatcoll-core'
    gpr2'
  ]
  ++ (with ocamlPackages; [
    ocamlgraph
    zarith
    ppx_deriving
    ppx_sexp_conv
    camlzip
    menhirLib
    num
    re
    sexplib
    yojson_2
  ])
  ++ lib.optionals (lib.versionAtLeast gnat.version "16") [
    sarif-ada
    vss-extra
  ];

  propagatedBuildInputs = [
    gprbuild
  ];

  postPatch = ''
    # gnat2why/gnat_src points to the GNAT sources
    tar xf ${gnat.cc.src} --wildcards 'gcc-*/gcc/ada'
    mv gcc-*/gcc/ada gnat2why/gnat_src
  '';

  configurePhase = ''
    runHook preConfigure
    make setup
    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall
    make install-all
    cp -a ./install/. $out
    mkdir $out/share/gpr
    ln -s $out/lib/gnat/* $out/share/gpr/
    runHook postInstall
  '';

  meta = {
    description = "Software development technology specifically designed for engineering high-reliability applications";
    homepage = "https://github.com/AdaCore/spark2014";
    maintainers = with lib.maintainers; [
      jiegec
      sempiternal-aurora
    ];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
  };
}
