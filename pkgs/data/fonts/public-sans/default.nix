{ stdenv, fetchzip }:

let
  version = "1.002";
in fetchzip rec {
  name = "public-sans-${version}";

  url = "https://github.com/uswds/public-sans/releases/download/v${version}/public-sans-v${version}.zip";

  postFetch = ''
    mkdir -p $out/share
    unzip $downloadedFile fonts/{otf,variable}/\*.\[ot\]tf -d $out/share/
  '';

  sha256 = "1j792i6350sp63l04jww5rpnsfz9zkj97rd378yxnpnwf2a8nv4k";

  meta = with stdenv.lib; {
    description = "A strong, neutral, principles-driven, open source typeface for text or display";
    homepage = https://public-sans.digital.gov/;
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
