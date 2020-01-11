{ lib, fetchFromGitHub }:

fetchFromGitHub rec {
  name = "dosis-1.007";

  owner = "impallari";
  repo = "Dosis";
  rev = "12df1e13e58768f20e0d48ff15651b703f9dd9dc";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    find . -name '*.otf' -exec install -m444 -Dt $out/share/fonts/opentype {} \;
    install -m444 -Dt $out/share/doc/${name} README.md FONTLOG.txt
  '';

  sha256 = "0vz25w45i8flfvppymr5h83pa2n1r37da20v7691p44018fdsdny";

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
    homepage = http://www.impallari.com/dosis;
    license = licenses.ofl;
    maintainers = with maintainers; [ cmfwyp ];
    platforms = platforms.all;
  };
}
