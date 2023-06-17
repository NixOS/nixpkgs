{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "migu";
  version = "20150712";

  srcs = [
    (fetchzip {
      url = "mirror://osdn/mix-mplus-ipa/63545/migu-1p-${version}.zip";
      sha256 = "04wpbk5xbbcv2rzac8yzj4ww7sk2hy2rg8zs96yxc5vzj9q7svf6";
    })
    (fetchzip {
      url = "mirror://osdn/mix-mplus-ipa/63545/migu-1c-${version}.zip";
      sha256 = "1k7ymix14ac5fb44bjvbaaf24784zzpyc1jj2280c0zdnpxksyk6";
    })
    (fetchzip {
      url = "mirror://osdn/mix-mplus-ipa/63545/migu-1m-${version}.zip";
      sha256 = "07r8id83v92hym21vrqmfsfxb646v8258001pkjhgfnfg1yvw8lm";
    })
    (fetchzip {
      url = "mirror://osdn/mix-mplus-ipa/63545/migu-2m-${version}.zip";
      sha256 = "1pvzbrawh43589j8rfxk86y1acjbgzzdy5wllvdkpm1qnx28zwc2";
    })
  ];

  dontUnpack = true;

  installPhase = ''
    find $srcs -name '*.ttf' | xargs install -m644 --target $out/share/fonts/truetype/migu -D
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "0nbpn21cxdd6gsgr3fadzjsnz84f2swpf81wmscmjgvd56ngndzh";

  meta = with lib; {
    description = "A high-quality Japanese font based on modified M+ fonts and IPA fonts";
    homepage = "http://mix-mplus-ipa.osdn.jp/migu/";
    license = licenses.ipa;
    maintainers = [ maintainers.mikoim ];
  };
}
