{
  stdenv,
  fetchurl,
  lib,
  autoPatchelfHook,
  cups,
}:

stdenv.mkDerivation rec {
  pname = "vevor-cups";
  version = "1.0.2";

  src = fetchurl {
    url = "https://document.vevor.online/software/20221128/Vevor_Driver_Linux.run";
    hash = "sha256-jUzRhIN8O+StcVsCb7La/xCsPWxdhJ0MJALurDRCaSg=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ cups ];

  unpackPhase = ''
    runHook preUnpack

    tail +15 $src > Vevor_Driver_Ubuntu.tar.gz
    tar zxf Vevor_Driver_Ubuntu.tar.gz


    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/cups/filter/VevorPrinter/Filter
    cp -rf Vevor_Driver_Ubuntu/VevorPrinter/Filter/rastertolabel $out/lib/cups/filter/VevorPrinter/Filter
    mkdir -p $out/lib/cups/filter/VevorPrinter300/Filter
    cp -rf Vevor_Driver_Ubuntu/VevorPrinter300/Filter/rastertolabel $out/lib/cups/filter/VevorPrinter300/Filter

    mkdir -p $out/share/cups/model
    cp Vevor_Driver_Ubuntu/VevorPrinter/PPDs/Vevor_Label_Printer.ppd $out/share/cups/model
    cp Vevor_Driver_Ubuntu/VevorPrinter300/PPDs/Vevor_Label_Printer300.ppd $out/share/cups/model

    runHook postInstall
  '';

  meta = with lib; {
    description = "CUPS Linux drivers for VEVOR thermal label printers";
    downloadPage = "https://www.vevor.com/pages/download-center-label-printer";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ChocolateLoverRaj ];
    license = licenses.unfree;
  };
}
