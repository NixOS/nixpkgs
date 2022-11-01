{ lib
, stdenv
, fetchzip
, buildDocs ? false, tex
}:

stdenv.mkDerivation rec {
  pname = "asl";
  version = "142-bld211";

  src = fetchzip {
    name = "${pname}-${version}";
    url = "http://john.ccac.rwth-aachen.de:8000/ftp/as/source/c_version/asl-current-${version}.tar.bz2";
    hash = "sha256-Sbm16JX7kC/7Ws7YgNBUXNqOCl6u+RXgfNjTODhCzSM=";
  };

  nativeBuildInputs = lib.optionals buildDocs [ tex ];

  postPatch = lib.optionalString (!buildDocs) ''
    substituteInPlace Makefile --replace "all: binaries docs" "all: binaries"
  '' + lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
    substituteInPlace sysdefs.h --replace "x86_64" "aarch64"
  '';

  dontConfigure = true;

  preBuild = ''
    bindir="${placeholder "out"}/bin" \
    docdir="${placeholder "out"}/doc/asl" \
    incdir="${placeholder "out"}/include/asl" \
    libdir="${placeholder "out"}/lib/asl" \
    mandir="${placeholder "out"}/share/man" \
    substituteAll ${./Makefile-nixos.def} Makefile.def
    mkdir -p .objdir
  '';

  meta = with lib; {
    homepage = "http://john.ccac.rwth-aachen.de:8000/as/index.html";
    description = "Portable macro cross assembler";
    longDescription = ''
      AS is a portable macro cross assembler for a variety of microprocessors
      and -controllers. Though it is mainly targeted at embedded processors and
      single-board computers, you also find CPU families in the target list that
      are used in workstations and PCs.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
# TODO: multiple outputs
# TODO: cross-compilation support
# TODO: customize TeX input
# TODO: report upstream about `mkdir -p .objdir/`
# TODO: suggest upstream about building docs as an option
