{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "xml2";
  version = "0.5";

  src = fetchurl {
    url = "https://web.archive.org/web/20160427221603/http://download.ofb.net/gale/xml2-${version}.tar.gz";
    sha256 = "01cps980m99y99cnmvydihga9zh3pvdsqag2fi1n6k2x7rfkl873";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libxml2 ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    echo -n 'checking csv2 and 2csv...'
    $out/bin/csv2 -f <<< $'a,b\n1,2' \
      | $out/bin/2csv record a b \
      | grep -qF '1,2'
    echo ' ok'

    echo -n 'checking xml2 and 2xml...'
    $out/bin/xml2 <<< $'<a>abc</a>' \
      | $out/bin/2xml \
      | grep -qF '<a>abc</a>'
    echo ' ok'

    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://web.archive.org/web/20160515005047/http://dan.egnor.name:80/xml2";
    description = "Tools for command line processing of XML, HTML, and CSV";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
