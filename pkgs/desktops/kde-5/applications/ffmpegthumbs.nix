{
  kdeApp, lib,
  ecm,
  ffmpeg, kio
}:

kdeApp {
  name = "ffmpegthumbs";
  meta = {
    license = with lib.licenses; [ gpl2 bsd3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ ffmpeg kio ];
}
