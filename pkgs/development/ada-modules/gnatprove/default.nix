{ stdenv
, lib
, fetchFromGitHub
, gnat
, gnatcoll-core
, gprbuild
, python3
, ocamlPackages
, makeWrapper
}:
let
  gnat_version = lib.versions.major gnat.version;

  fetchSpark2014 = { rev, sha256 } : fetchFromGitHub {
    owner = "AdaCore";
    repo = "spark2014";
    fetchSubmodules = true;
    inherit rev sha256;
  };

  spark2014 = {
    "12" = {
      src = fetchSpark2014 {
        rev = "ab34e07080a769b63beacc141707b5885c49d375"; # branch fsf-12
        sha256 = "sha256-7pe3eWitpxmqzjW6qEIEuN0qr2IR+kJ7Ssc9pTBcCD8=";
      };
      commit_date = "2022-05-25";
    };
    "13" = {
      src = fetchSpark2014 {
        rev = "12db22e854defa9d1c993ef904af1e72330a68ca"; # branch fsf-13
        sha256 = "sha256-mZWP9yF1O4knCiXx8CqolnS+93bM+hTQy40cd0HZmwI=";
      };
      commit_date = "2023-01-05";
    };
  };

  thisSpark = spark2014.${gnat_version} or
    (builtins.throw "GNATprove depend on a specific GNAT version and can't be built using GNAT ${gnat_version}.");

in
stdenv.mkDerivation rec {
  pname = "gnatprove";
  version = "fsf-${gnat_version}_${thisSpark.commit_date}";

  src = thisSpark.src;

  nativeBuildInputs = [
    gnat
    gprbuild
    python3
    ocamlPackages.ocaml
    makeWrapper
  ];

  buildInputs = [
    gnatcoll-core
    ocamlPackages.camlzip
    ocamlPackages.findlib
    ocamlPackages.menhir
    ocamlPackages.menhirLib
    ocamlPackages.num
    ocamlPackages.yojson
    ocamlPackages.zarith
  ];

  propagatedBuildInputs = [
    gprbuild
  ];

  postPatch = ''
    # gnat2why/gnat_src points to the GNAT sources
    tar xf ${gnat.cc.src} gcc-${gnat.cc.version}/gcc/ada
    mv gcc-${gnat.cc.version}/gcc/ada gnat2why/gnat_src
  '';

  configurePhase = ''
    make setup
  '';

  installPhase = ''
    make install-all
    cp -a ./install/. $out
    mkdir $out/share/gpr
    ln -s $out/lib/gnat/* $out/share/gpr/
  '';

  meta = with lib; {
    description = "a software development technology specifically designed for engineering high-reliability applications";
    homepage = "https://github.com/AdaCore/spark2014";
    maintainers = [ maintainers.jiegec ];
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}

