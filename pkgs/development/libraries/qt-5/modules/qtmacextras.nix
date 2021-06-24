{ lib, qtModule, qtbase }:

qtModule {
  name = "qtmacextras";
  qtInputs = [ qtbase ];
  meta = with lib; {
    maintainers = with maintainers; [ periklis ];
    platforms = platforms.darwin;
  };
}
