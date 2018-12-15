{ stdenv, qtModule, qtbase, cf-private }:

qtModule {
  name = "qtmacextras";
  qtInputs = [ qtbase ]
    # Needed for _OBJC_CLASS_$_NSData symbols.
    ++ stdenv.lib.optional stdenv.isDarwin cf-private;
  meta = with stdenv.lib; {
    maintainers = with maintainers; [ periklis ];
    platforms = platforms.darwin;
  };
}
