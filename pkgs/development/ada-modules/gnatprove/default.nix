{ stdenv
, lib
, fetchFromGitHub
, gnat
, gnatcoll-core
, gprbuild
, python3
, ocamlPackages
, makeWrapper
, gpr2
}:
let
  gnat_version = lib.versions.major gnat.version;

  # gnatprove fsf-14 requires gpr2 from a special branch
  gpr2_24_2_next = (gpr2.override {
    # pregenerated kb db is not included
    gpr2kbdir = "${gprbuild}/share/gprconfig";
  }).overrideAttrs(old: rec {
    version = "24.2.0-next";
    src = fetchFromGitHub {
      owner = "AdaCore";
      repo = "gpr";
      rev = "v${version}";
      hash = "sha256-Tp+N9VLKjVWs1VRPYE0mQY3rl4E5iGb8xDoNatEYBg4=";
    };
  });

  fetchSpark2014 = { rev, hash } : fetchFromGitHub {
    owner = "AdaCore";
    repo = "spark2014";
    fetchSubmodules = true;
    inherit rev hash;
  };

  spark2014 = {
    "12" = {
      src = fetchSpark2014 {
        rev = "ab34e07080a769b63beacc141707b5885c49d375"; # branch fsf-12
        hash = "sha256-7pe3eWitpxmqzjW6qEIEuN0qr2IR+kJ7Ssc9pTBcCD8=";
      };
      commit_date = "2022-05-25";
    };
    "13" = {
      src = fetchSpark2014 {
        rev = "12db22e854defa9d1c993ef904af1e72330a68ca"; # branch fsf-13
        hash = "sha256-mZWP9yF1O4knCiXx8CqolnS+93bM+hTQy40cd0HZmwI=";
      };
      commit_date = "2023-01-05";
    };
    "14" = {
      src = fetchSpark2014 {
        rev = "ce5fad038790d5dc18f9b5345dc604f1ccf45b06"; # branch fsf-14
        hash = "sha256-WprJJIe/GpcdabzR2xC2dAV7kIYdNTaTpNYoR3UYTVo=";
      };
      patches = [
        # Disable Coq related targets which are missing in the fsf-14 branch
        ./0001-fix-install.patch
      ];
      commit_date = "2024-01-11";
    };
  };

  thisSpark = spark2014.${gnat_version} or
    (builtins.throw "GNATprove depends on a specific GNAT version and can't be built using GNAT ${gnat_version}.");

in
stdenv.mkDerivation rec {
  pname = "gnatprove";
  version = "fsf-${gnat_version}_${thisSpark.commit_date}";

  src = thisSpark.src;

  patches = thisSpark.patches or [];

  nativeBuildInputs = [
    gnat
    gprbuild
    python3
    makeWrapper
  ] ++ (with ocamlPackages; [
    ocaml
    findlib
    menhir
  ]);

  buildInputs = [
    gnatcoll-core
  ] ++ (with ocamlPackages; [
    ocamlgraph
    zarith
    ppx_deriving
    ppx_sexp_conv
    camlzip
    menhirLib
    num
    re
    sexplib
    yojson
  ]) ++ (lib.optionals (gnat_version == "14")[
    gpr2_24_2_next
  ]);

  propagatedBuildInputs = [
    gprbuild
  ];

  postPatch = ''
    # gnat2why/gnat_src points to the GNAT sources
    tar xf ${gnat.cc.src} gcc-${gnat.cc.version}/gcc/ada
    mv gcc-${gnat.cc.version}/gcc/ada gnat2why/gnat_src
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

  meta = with lib; {
    description = "Software development technology specifically designed for engineering high-reliability applications";
    homepage = "https://github.com/AdaCore/spark2014";
    maintainers = [ maintainers.jiegec ];
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}

