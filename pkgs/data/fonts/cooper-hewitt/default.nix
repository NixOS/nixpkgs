{ lib, fetchzip }:

fetchzip rec {
  pname = "cooper-hewitt";
  version = "unstable-2014-06-09";

  url = "https://web.archive.org/web/20221004145117/https://www.cooperhewitt.org/wp-content/uploads/fonts/CooperHewitt-OTF-public.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    mv $out/*.otf $out/share/fonts/opentype
    find $out -maxdepth 1 ! -type d -exec rm {} +
  '';

  sha256 = "01iwqmjvqkc6fmc2r0486vk06s6f51n9wxzl1pf9z48n0igj4gqd";

  meta = with lib; {
    homepage = "https://www.cooperhewitt.org/open-source-at-cooper-hewitt/cooper-hewitt-the-typeface-by-chester-jenkins/";
    description = "A contemporary sans serif, with characters composed of modified-geometric curves and arches";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
