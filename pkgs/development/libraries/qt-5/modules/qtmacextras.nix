{ lib, qtModule, qtbase }:

qtModule {
  pname = "qtmacextras";
  propagatedBuildInputs = [ qtbase ];
  meta = with lib; {
    maintainers = with maintainers; [ periklis ];
    platforms = platforms.darwin;
  };
}
