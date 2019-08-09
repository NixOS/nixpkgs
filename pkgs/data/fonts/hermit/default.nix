{ lib, fetchzip }:

let
  pname = "hermit";
  version = "2.0";
in fetchzip rec {
  name = "${pname}-${version}";

  url = "https://pcaro.es/d/otf-${name}.tar.gz";

  postFetch = ''
    tar xf $downloadedFile
    install -m444 -Dt $out/share/fonts/opentype *.otf
  '';
  sha256 = "127hnpxicqya7v1wmzxxqafq3aj1n33i4j5ncflbw6gj5g3bizwl";

  meta = with lib; {
    description = "monospace font designed to be clear, pragmatic and very readable";
    homepage = https://pcaro.es/p/hermit;
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

