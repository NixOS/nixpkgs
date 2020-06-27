{ lib, mkFont, fetchFromGitHub }:

mkFont rec {
  pname = "dosis";
  version = "1.007";

  src = fetchFromGitHub {
    owner = "impallari";
    repo = "Dosis";
    rev = "12df1e13e58768f20e0d48ff15651b703f9dd9dc";
    sha256 = "0glniyg07z5gx5gsa1ymarg2gsncjyf94wi6j9bf68v5s2w3v7md";
  };

  meta = with lib; {
    description = "A very simple, rounded, sans serif family";
    longDescription = ''
      Dosis is a very simple, rounded, sans serif family.

      The lighter weights are minimalist. The bolder weights have more
      personality. The medium weight is nice and balanced. The overall result is
      a family that's clean and modern, and can express a wide range of
      voices & feelings.

      It comes in 7 incremental weights: ExtraLight, Light, Book, Medium,
      Semibold, Bold & ExtraBold
    '';
    homepage = "http://www.impallari.com/dosis";
    license = licenses.ofl;
    maintainers = with maintainers; [ cmfwyp ];
    platforms = platforms.all;
  };
}
