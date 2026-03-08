{
  buildPerlPackage,
  fetchFromGitHub,
  gitUpdater,
  lib,
  versionCheckHook,
  ArchiveZip,
  CompressRawLzma,
  IOCompress,
  IOCompressBrotli,
}:

buildPerlPackage rec {
  pname = "Image-ExifTool";
  version = "13.52";

  src = fetchFromGitHub {
    owner = "exiftool";
    repo = "exiftool";
    tag = version;
    hash = "sha256-vsIktUk93fA8lqmphl2xk0Hqgh7VJ08LCP98NnD2o/Q=";
  };

  postPatch = ''
    patchShebangs exiftool
  '';

  propagatedBuildInputs = [
    ArchiveZip
    CompressRawLzma
    IOCompress
    IOCompressBrotli
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-ver";

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Tool to read, write and edit EXIF meta information";
    longDescription = ''
      ExifTool is a platform-independent Perl library plus a command-line
      application for reading, writing and editing meta information in a wide
      variety of files. ExifTool supports many different metadata formats
      including EXIF, GPS, IPTC, XMP, JFIF, GeoTIFF, ICC Profile, Photoshop
      IRB, FlashPix, AFCP and ID3, as well as the maker notes of many digital
      cameras by Canon, Casio, DJI, FLIR, FujiFilm, GE, GoPro, HP,
      JVC/Victor, Kodak, Leaf, Minolta/Konica-Minolta, Motorola, Nikon,
      Nintendo, Olympus/Epson, Panasonic/Leica, Pentax/Asahi, Phase One,
      Reconyx, Ricoh, Samsung, Sanyo, Sigma/Foveon and Sony.
    '';
    homepage = "https://exiftool.org/";
    changelog = "https://exiftool.org/history.html";
    license = with lib.licenses; [
      gpl1Plus # or
      artistic2
    ];
    maintainers = with lib.maintainers; [
      anthonyroussel
    ];
    mainProgram = "exiftool";
  };
}
