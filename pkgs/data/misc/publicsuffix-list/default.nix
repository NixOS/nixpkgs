{ lib, fetchFromGitHub }:

let
  pname = "publicsuffix-list";
  version = "2023-02-16";
in fetchFromGitHub {
  name = "${pname}-${version}";
  owner = "publicsuffix";
  repo = "list";
  rev = "8ec4d3049fe139f92937b6137155c33b81dcaf18";
  sha256 = "sha256-wA8zk0iADFNP33veIf+Mfx22zdMzHsMNWEizMp1SnuA=";

  postFetch = ''
    install -Dm0444 $out/public_suffix_list.dat $out/tests/test_psl.txt -t $out/share/publicsuffix
    shopt -s extglob dotglob
    rm -rf $out/!(share)
    shopt -u extglob dotglob
  '';

  meta = with lib; {
    homepage = "https://publicsuffix.org/";
    description = "Cross-vendor public domain suffix database";
    platforms = platforms.all;
    license = licenses.mpl20;
    maintainers = [ maintainers.c0bw3b ];
  };
}
