{ lib, fetchFromGitHub }:

let
  pname = "ir-standard-fonts";
  version = "unstable-2017-01-21";
in fetchFromGitHub rec {
  name = "${pname}-${version}";
  owner = "morealaz";
  repo = pname;
  rev = "d36727d6c38c23c01b3074565667a2fe231fe18f";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/ir-standard-fonts {} \;
  '';
  sha256 = "0i2vzhwk77pm6fx5z5gxl026z9f35rhh3cvl003mry2lcg1x5rhp";

  meta = with lib; {
    homepage = https://github.com/morealaz/ir-standard-fonts;
    description = "Iran Supreme Council of Information and Communication Technology (SCICT) standard Persian fonts series";
    # License information is unavailable.
    license = licenses.unfree;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
