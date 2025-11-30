{
  buildPerlPackage,
  fetchFromGitHub,
  gitUpdater,
  lib,
  shortenPerlShebang,
  stdenv,
  versionCheckHook,
  ArchiveZip,
  CompressRawLzma,
  IOCompress,
  IOCompressBrotli,
}:

buildPerlPackage rec {
  pname = "Image-ExifTool";
  version = "13.39";

  src = fetchFromGitHub {
    owner = "exiftool";
    repo = "exiftool";
    tag = version;
    hash = "sha256-GPm3HOt7fNMbXRrV5V+ykJAfhww1O6NrD0l/7hA2i28=";
  };

  postPatch = ''
    patchShebangs exiftool
  '';

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin shortenPerlShebang;

  propagatedBuildInputs = [
    ArchiveZip
    CompressRawLzma
    IOCompress
    IOCompressBrotli
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    shortenPerlShebang $out/bin/exiftool
  '';

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
      kiloreux
      anthonyroussel
    ];
    mainProgram = "exiftool";
  };
}
