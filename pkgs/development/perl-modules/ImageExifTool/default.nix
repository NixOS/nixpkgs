{
  buildPerlPackage,
  exiftool,
  fetchurl,
  gitUpdater,
  lib,
  shortenPerlShebang,
  stdenv,
  testers,
}:

buildPerlPackage rec {
  pname = "Image-ExifTool";
  version = "13.00";

  src = fetchurl {
    url = "https://exiftool.org/Image-ExifTool-${version}.tar.gz";
    hash = "sha256-SJV4jzT4NHZfhr5KWtWjJDP1ctdXFg7Ne2Eur17TfoQ=";
  };

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin shortenPerlShebang;

  postPatch = ''
    patchShebangs exiftool
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    shortenPerlShebang $out/bin/exiftool
  '';

  passthru = {
    tests.version = testers.testVersion {
      inherit version;
      command = "${lib.getExe exiftool} -ver";
      package = exiftool;
    };
    updateScript = gitUpdater { url = "https://github.com/exiftool/exiftool.git"; };
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
