{ lib, fetchgit }:

fetchgit {
  name = "fairfax-hd-unstable-2022-09-04";
  url = "https://github.com/kreativekorp/open-relay.git";
  sparseCheckout = "FairfaxHD";
  rev = "cbaca8d9d6d65bddbc05dd3e20b7063639f6664a";

  postFetch = ''
    mv $out/* .
    mkdir -p $out/share/fonts/truetype
    cp ./FairfaxHD/*.ttf $out/share/fonts/truetype
  '';

  hash = "sha256-JpmVFW2tGF34ZpvJlS1txVhuych+THKEsvl25l9k4CQ=";

  meta = with lib; {
    homepage = "https://www.kreativekorp.com/software/fonts/fairfaxhd/";
    description = "Fairfax HD fonts";
    license = licenses.ofl;
    maintainers = with maintainers; [ anselmschueler ];
  };
}
