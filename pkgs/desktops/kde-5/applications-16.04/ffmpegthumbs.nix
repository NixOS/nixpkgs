{ kdeApp
, lib
, extra-cmake-modules
, ffmpeg
, kio
}:

kdeApp {
  name = "ffmpegthumbs";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    ffmpeg
    kio
  ];
  meta = {
    license = with lib.licenses; [ gpl2 bsd3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
