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
  version = "8.316";

  src = fetchurl {
    url = "https://pythia.org/download/pythia83/pythia${
      builtins.replaceStrings [ "." ] [ "" ] version
    }.tgz";
    sha256 = "sha256-HZkwGq/WiWtXQ17dc4UOU/No8AIaZHsSzyVYTXcxNIk=";
  };

  nativeBuildInputs = [ rsync ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ];
  buildInputs = [
    boost
    fastjet
    hepmc
    zlib
    lhapdf
  ];

  configureFlags = [
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

  meta = {
    description = "Program for the generation of high-energy physics events";
    mainProgram = "pythia8-config";
    license = lib.licenses.gpl2Only;
    homepage = "https://pythia.org";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
