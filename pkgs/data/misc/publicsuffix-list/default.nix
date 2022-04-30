{ lib, fetchFromGitHub }:

let
  pname = "publicsuffix-list";
  version = "2021-09-03";
in fetchFromGitHub {
  name = "${pname}-${version}";
  owner = "publicsuffix";
  repo = "list";
  rev = "2533d032871e1ef1f410fc0754b848d4587c8021";
  sha256 = "sha256-Q8uIXM1CMu8dlWcVoL17M1XRGu3kG7Y7jpx0oHQh+2I=";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    install -Dm0444 public_suffix_list.dat tests/test_psl.txt -t $out/share/publicsuffix
  '';

  meta = with lib; {
    homepage = "https://publicsuffix.org/";
    description = "Cross-vendor public domain suffix database";
    platforms = platforms.all;
    license = licenses.mpl20;
    maintainers = [ maintainers.c0bw3b ];
  };
}
