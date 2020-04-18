{ stdenv, qtModule, qtbase }:

qtModule {
  name = "qtmacextras";
  qtInputs = [ qtbase ];
  meta = with stdenv.lib; {
    maintainers = with maintainers; [ periklis ];
    platforms = platforms.darwin;
  };
}
