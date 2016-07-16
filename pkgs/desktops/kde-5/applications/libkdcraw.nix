{ kdeApp
, lib
, extra-cmake-modules
, libraw
}:

kdeApp {
  name = "libkdcraw";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 bsd3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  propagatedBuildInputs = [
    libraw
  ];
}
