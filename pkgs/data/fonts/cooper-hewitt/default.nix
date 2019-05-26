{ lib, fetchzip }:

fetchzip {
  name = "cooper-hewitt-2014-06-09";

  url = https://www.cooperhewitt.org/wp-content/uploads/fonts/CooperHewitt-OTF-public.zip;

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype/
  '';

  sha256 = "01iwqmjvqkc6fmc2r0486vk06s6f51n9wxzl1pf9z48n0igj4gqd";

  meta = with lib; {
    homepage = https://www.cooperhewitt.org/open-source-at-cooper-hewitt/cooper-hewitt-the-typeface-by-chester-jenkins/;
    description = "A contemporary sans serif, with characters composed of modified-geometric curves and arches";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
