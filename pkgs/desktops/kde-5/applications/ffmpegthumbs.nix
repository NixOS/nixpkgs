{ kdeApp
, lib
, extra-cmake-modules
, ffmpeg
, kio
}:

kdeApp {
  name = "ffmpegthumbs";
  meta = {
    license = with lib.licenses; [ gpl2 bsd3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  propagatedBuildInputs = [
    ffmpeg
    kio
  ];
}
