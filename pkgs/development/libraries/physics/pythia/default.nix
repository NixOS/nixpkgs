{
  lib,
  stdenv,
  fetchurl,
  boost,
  fastjet,
  fixDarwinDylibNames,
  hepmc,
  lhapdf,
  rsync,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "pythia";
  version = "8.311";

  src = fetchurl {
    url = "https://pythia.org/download/pythia83/pythia${
      builtins.replaceStrings [ "." ] [ "" ] version
    }.tgz";
    sha256 = "sha256-J4LV5CnBVDxnN1r+VH/UxMoHIDCd6wCPfbeGJtx9FGQ=";
  };

  nativeBuildInputs = [ rsync ] ++ lib.optionals stdenv.isDarwin [ fixDarwinDylibNames ];
  buildInputs = [
    boost
    fastjet
    hepmc
    zlib
    lhapdf
  ];

  configureFlags =
    [
      "--enable-shared"
      "--with-lhapdf6=${lhapdf}"
    ]
    ++ (
      if lib.versions.major hepmc.version == "3" then
        [
          "--with-hepmc3=${hepmc}"
        ]
      else
        [
          "--with-hepmc2=${hepmc}"
        ]
    );

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A program for the generation of high-energy physics events";
    mainProgram = "pythia8-config";
    license = licenses.gpl2Only;
    homepage = "https://pythia.org";
    platforms = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
