{ stdenv
, lib
, fetchFromGitHub
, gnat12
, gnatcoll-core
, gprbuild
, python3
, ocaml
, ocamlPackages
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "spark2014";
  version = "unstable-2022-05-25";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "spark2014";
    # commit on fsf-12 branch
    rev = "ab34e07080a769b63beacc141707b5885c49d375";
    sha256 = "sha256-7pe3eWitpxmqzjW6qEIEuN0qr2IR+kJ7Ssc9pTBcCD8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    gnat12
    gprbuild
    python3
    ocaml
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

  postPatch = ''
    # gnat2why/gnat_src points to the GNAT sources
    tar xf ${gnat12.cc.src} gcc-${gnat12.cc.version}/gcc/ada
    mv gcc-${gnat12.cc.version}/gcc/ada gnat2why/gnat_src
  '';

  configurePhase = ''
    make setup
  '';

  installPhase = ''
    make install-all
    cp -a ./install/. $out
  '';

  meta = with lib; {
    description = "a software development technology specifically designed for engineering high-reliability applications";
    homepage = "https://github.com/AdaCore/spark2014";
    maintainers = [ maintainers.jiegec ];
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}

