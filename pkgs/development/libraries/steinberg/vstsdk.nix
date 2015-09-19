{ requireFile, fetchzip }:

fetchzip {
  name = "vstsdk-3.6.5";
  url = "file://" + requireFile {
    url = http://www.steinberg.net/sdk_downloads/vstsdk365_28_08_2015_build_66.zip;
    sha256 = "18jd2s31hgbgv3765xl9zmljlikryd0104m34qkpc1jmlxzaclac";
  };
  sha256 = "1vgwdplb1jsa4y4azdc93h3prs2jpqpbw2vzvv105amdizvq0f13";
}
