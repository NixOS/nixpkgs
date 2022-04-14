{
  fetchzip,
  symlinkJoin,
  lib,
}: let
  gfs-font = name: sha256:
    fetchzip {
      inherit name sha256;
      url = "http://www.greekfontsociety-gfs.gr/_assets/fonts/${name}.zip";
      postFetch = ''
        mkdir -p $out/share/fonts
        unzip -j -o $downloadedFile "*.otf" -d $out/share/fonts/opentype
        unzip -j -o $downloadedFile "**/*.otf" -d $out/share/fonts/opentype
      '';
    };
  version = "unstable-2022-04-14";
in
  symlinkJoin {
    name = "gfs-fonts-${version}";

    paths = lib.mapAttrsToList gfs-font {
      GFS_Artemisia = "1q39086pr2jhv118fjfv6l1li6japv4pdjnhh1scqw06mqrmydf4";
      GFS_Baskerville = "07gx5b9b43zv74d2lay37sajd4ba2wqn3b7xzvyhn265ds9x7cxk";
      GFS_Bodoni = "0jhl0728ikzha1krm01sk52nz3jzibidwmyvgidg61d87l8nbf2p";
      GFS_Bodoni_Classic = "06jw2irskn75s50mgwkx08rzwqi82gpc6lgjsimsi8p81566gfrh";
      GFS_Complutum = "1q7dxs2z3yrgchd2pz9h72mjrk62kdc2mmqw8kg9q76k28f8n3p0"; # -> GFSPolyglot.otf
      GFS_Decker = "016v1j5n9ph4i2cpmlk26pcxhp3q2fjwlaryppd5akl84dfkpncl";
      GFS_Didot = "0ysvrp527wm0wxfp6wmlgmxfx7ysr5mwpmjmqp1h605cy44jblfm";
      GFS_Didot_Classic = "0n5awqksvday3l3d85yhwmbmfj9bcpxivy4wpd4zrkgl7b85af2c";
      GFS_Didot_Display = "0n2di2zyc76w6f8mc6hfilc2ir6igks7ldjp9fkw1gjp06330fi7";
      GFS_Elpis = "02l7wd3nbn1kpv7ghxh19k4dbvd49ijyxd6gq83gcr9vlmxcq2s2";
      GFS_Gazis = "0x9iwj6pinaykrds0iw6552hf256d0dr41sipdb1jnnlr2d3bf9w";
      GFS_Goschen = "1jvbn33wzq2yj0aygwy9pd2msg3wkmdp0npjzazadrmfjpnpkcy9";
      GFS_NeoHellenic = "1ixm2frdc6i5lbn9h0h4gdsvsw2k4hny75q8ig4kgs28ac3dbzq3";
      GFS_Olga = "1qaxaw3ngnbr1gb1xyk5f2z647zklg6sl3bqwi28l47j9mp0f8aj";
      GFS_Orpheus = "18n6fag4pyr8jdwnsz0vixf47jz4ym8mjmppc1w3k7v27cg1z9dz";
      GFS_Orpheus_Classic = "1rqy1kf7slw56zfhbv264yzarjisnqbqydj4f7hghiknhnmdakps";
      GFS_Orpheus_Sans = "02rh7z8c3h3xyfi52rn47z4finizx636d05bg5g23v0l0mqs6nkg";
      GFS_Philostratos = "0zh3d0cn6b2fjbwnvmg379z20zh7w626w2bnj19xcazjvqkwhzx1";
      GFS_Porson = "0c2axagkm6wxv8na2q11k6c5dmgkwx5hn9sh9qy82gbips9blnda";
      GFS_Pyrsos = "0y0dv7y3n01bbhhnczflx1zcc7by56cffmr2xqixj2rd1nvchx0j";
      GFS_Solomos = "1mpx9mw566awvfjdfx5sbz3wz5gbnjjw56gz30mk1lw06vxf0dxz";
      GFS_Theokritos = "0haasx819x8c8yvna6pqywgi4060av2570jm34cddnz1fgnhv1b8";
    };

    meta = with lib; {
      homepage = "http://www.greekfontsociety-gfs.gr";
      descriptions = "Fonts by the Greek Font Society (GFS)";
      license = licenses.ofl;
      platforms = platforms.all;
      maintainers = [ maintainers.kmein ];
    };
  }
