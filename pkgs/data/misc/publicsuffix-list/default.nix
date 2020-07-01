{ lib, fetchFromGitHub }:

let
  pname = "publicsuffix-list";
  version = "2019-05-24";
in fetchFromGitHub {
  name = "${pname}-${version}";
  owner = "publicsuffix";
  repo = "list";
  rev = "a1db0e898956e126de65be1a5e977fbbbbeebe33";
  sha256 = "092153w2jr7nx28p9wc9k6b5azi9c39ghnqfnfiwfzv1j8jm3znq";

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
