{ lib, fetchFromGitHub }:

let
  pname = "manrope";
  version = "3";
in fetchFromGitHub {
  name = "${pname}-${version}";
  owner = "sharanda";
  repo = pname;
  rev = "3bd68c0c325861e32704470a90dfc1868a5c37e9";
  sha256 = "1h4chkfbp75hrrqqarf28ld4yb7hfrr7q4w5yz96ivg94lbwlnld";
  postFetch = ''
    tar xf $downloadedFile --strip=1
    install -Dm644 -t $out/share/fonts/opentype "desktop font"/*
  '';
  meta = with lib; {
    description = "Open-source modern sans-serif font family";
    homepage = https://github.com/sharanda/manrope;
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
