{ lib, qtModule, qtbase }:

qtModule {
  pname = "qtmacextras";
  qtInputs = [ qtbase ];
  meta = with lib; {
    maintainers = with maintainers; [ periklis ];
    platforms = platforms.darwin;
  };
}
