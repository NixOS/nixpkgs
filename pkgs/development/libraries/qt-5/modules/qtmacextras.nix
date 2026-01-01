{
  lib,
  qtModule,
  qtbase,
}:

qtModule {
  pname = "qtmacextras";
  propagatedBuildInputs = [ qtbase ];
<<<<<<< HEAD
  meta = {
    maintainers = [ ];
    platforms = lib.platforms.darwin;
=======
  meta = with lib; {
    maintainers = with maintainers; [ periklis ];
    platforms = platforms.darwin;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
