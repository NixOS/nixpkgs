{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "hack-font-${version}";
  version = "2.020";

  src = let
    version_ = with stdenv.lib;
      concatStringsSep "_" (splitString "." version);
  in fetchurl {
    sha256 = "16kkmc3psckw1b7k07ccn1gi5ymhlg9djh43nqjzg065g6p6d184";
    url = "https://github.com/chrissimpkins/Hack/releases/download/v${version}/Hack-v${version_}-ttf.zip";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/share/fonts/hack
    cp *.ttf $out/share/fonts/hack
  '';

  meta = with stdenv.lib; {
    description = "A typeface designed for source code";
    longDescription = ''
      Hack is hand groomed and optically balanced to be a workhorse face for
      code. It has deep roots in the libre, open source typeface community and
      expands upon the contributions of the Bitstream Vera & DejaVu projects.
      The face has been re-designed with a larger glyph set, modifications of
      the original glyph shapes, and meticulous attention to metrics.
    '';
    homepage = http://sourcefoundry.org/hack/;

    /*
     "The font binaries are released under a license that permits unlimited
      print, desktop, and web use for commercial and non-commercial
      applications. It may be embedded and distributed in documents and
      applications. The source is released in the widely supported UFO format
      and may be modified to derive new typeface branches. The full text of
      the license is available in LICENSE.md" (From the GitHub page)
    */
    license = licenses.free;
    platforms = platforms.all;
    maintainers = with maintainers; [ nckx ];
  };
}
