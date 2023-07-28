{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v7.0 (active)
{
  aspnetcore_7_0 = buildAspNetCore {
    version = "7.0.9";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c1348fca-4ef4-46bc-9f6e-04f2315e0d3e/50fe6b7c2df482cdc880b66bd46834c7/aspnetcore-runtime-7.0.9-linux-x64.tar.gz";
        sha512  = "aabf4fa5ca726dc52774e5d644800ef7477815b22a982b7a2752dec6569186aabca93d5386e195e7ead377144601a786ae6a5d76ff28435bdabfad495cfe554b";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9aca092c-f9c0-48d7-a01f-3c1c2eaac903/01b345ddecc7a90d5c99d016fa5180a6/aspnetcore-runtime-7.0.9-linux-arm64.tar.gz";
        sha512  = "447ebbd115b8d38eeba70f531010832db535cf3a17404491f552e99a5a59c8c63525640694a6753d27e9a7ed5bf1064998491c1983361c1c37b152b01a3b8f8a";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7e6cb756-70e3-4974-b96c-dc9b9d138306/9b0ea50c629660a565db33e74a69fe8c/aspnetcore-runtime-7.0.9-osx-x64.tar.gz";
        sha512  = "b2cf51cff120abda9b5ae213e294f73debd620bc8f3e6b12e1bb628df31457a5bb8c6dbb12cb1dcec24a2c04edd5ebe807d6761f6095e7a90441f1930acb8185";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f967c09c-7a90-4da9-b933-926ed7870b16/0e5fbf15f170ceaee7e3d1865b856a99/aspnetcore-runtime-7.0.9-osx-arm64.tar.gz";
        sha512  = "fbe725a764b765f9954ae771b3d043d6d1a53e53149d0b4c89a4138793d9471f2924f68a5b8e1c107d9faa07946f2ac00584ded9b179ed8d40cf230ac7d34750";
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
    version = "7.0.9";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ecc0d5e3-61f5-49b1-ac1f-3b46956e1139/1ec7760b1697363667623f22a16c67b5/dotnet-runtime-7.0.9-linux-x64.tar.gz";
        sha512  = "09552e5ae6ac014dadf17545ff0a30ab32921075a31fb33e7be148c13078e30d097f592ffa1b8d306563aaa3f6302e40c5c0ba815c1473bbd5d72e3bef55d91e";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f693db81-adb6-4481-862a-887993824572/9bd6d12296a5b07d8b4b0190afab4152/dotnet-runtime-7.0.9-linux-arm64.tar.gz";
        sha512  = "271396af3adf881a4c5c8c28a812f9a0a30e11497bb0c9cec12bee4d726ed9151b2d35eb9146b5938611ab60ccc249d5ce5c870f721f791d19a3b08545dbfa97";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f12bda3f-cef0-4d22-8ffe-89f553b0e5ed/a0ff4b2aeae50d5192e0e6f47075345b/dotnet-runtime-7.0.9-osx-x64.tar.gz";
        sha512  = "104e724bcec68fd77e8f07b71ed364cbcb40394c9ca0d8ef52e1eaab867b579f06ed7b0b203a50bad3df45634d52b6be60829d87a48c1800467f242879f8884e";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/20e6ef57-7686-4115-b7e6-ac561dcbf4fa/e2bf64248953cb06d5bafd6919f48905/dotnet-runtime-7.0.9-osx-arm64.tar.gz";
        sha512  = "1aae7726b89c0398f29bc49fe9cc4c2c3f27f1114d5ab140c998fe74b13caa3eed05cf5ae28eb389f37de2023b35c3bb864be64a2e596bde673e27ce749c53a2";
      };
    };
  };

  sdk_7_0 = buildNetSdk {
    version = "7.0.306";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0be7a87e-3a3f-4500-8301-49ccd6f24887/e9e36f35dbaf6625fec3e18f5c2b613f/dotnet-sdk-7.0.306-linux-x64.tar.gz";
        sha512  = "62df9bca9492b3273830e098e787ec3664243989ac03550534599fc331693553660d3cf8bca655f2d1326070dbb7b20b04743eaba77fa9cc69f6f0fddfdebd06";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/fb648e91-a4b9-4fc1-b6a3-acd293668e75/ccdc8a107bdb8b8f59ae6bb66ebecb6e/dotnet-sdk-7.0.306-linux-arm64.tar.gz";
        sha512  = "1500927cd2b1e048de8ee5339937fd41073a85a82b7a175220a411212d22e4906b4e5e6d29b51d068157d2ecde33238d540508c700793dca8b04b4d1dcd5c89e";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3d615bde-bfce-4ee0-a3b9-73dc4ea5a472/907ac9c03d971c7577ce60932456b3e3/dotnet-sdk-7.0.306-osx-x64.tar.gz";
        sha512  = "1ba293a9e07819aeb646c86f0db8280394c4a2b62f828d57a5ae80416cbafb1649a22e27cb12cc315dec1600cb825be645777d15e2f7c8d858fac3c55d0ed057";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0e57f35a-00e6-49ab-aa75-7ae6711f0a8e/f28c04285b8bfd3f975731a186e23c23/dotnet-sdk-7.0.306-osx-arm64.tar.gz";
        sha512  = "ac8c0b6e9d2235c8ee639c6c50b2f412f808a16f1616964f6166c7c57d899be2a0d8e83dd6f3010634f8f252da483c5d99cb083703996a99a6b9238cdc2cda6f";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "7.0.9"; sha256 = "09d86p5r8wbv03f89cylkg6czwf71m50fkxmav9qp3p5cscayzql"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "7.0.9"; sha256 = "01nkzvwgrlmgw57llabdgfxqz7jp54a2p3fd83zdlajqmmf54wi5"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "7.0.9"; sha256 = "1z0cbmff7kmv8yg9x9j4jzga689fy4434z8jy8s3vjsvmcj96wmc"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "7.0.9"; sha256 = "0059ldcym4lwrifibhb8qlra2f3ygzb95laxjgxj3jbdh78fy3i8"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "7.0.9"; sha256 = "12wkvz1mwyxv7zcr18bsyfa93p0wjmxqyz26va34xrfws699ip1v"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "7.0.9"; sha256 = "1spnj5n5l0hksrq89blj0xcsp1cnk2dw8n0giqrmq790yssvzn16"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "7.0.9"; sha256 = "0paqgqbddlnz6p0q1rmc8rdxhgwhs2gqnhbq8b53c0pn8dv554nz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "7.0.9"; sha256 = "0zw8bqj770gzk03ddxxh2y69krgxvrxn646878lf0l8ssllbsp5v"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "7.0.9"; sha256 = "0zm2gly0pkm5x0zngcbbz060i2p5xssrb154pnix9xbhpxf9bab7"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "7.0.9"; sha256 = "019fpgx8vminim43x3j4ym0m3fg42r8igw4yhh6ivbfkzyy5jnkb"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "7.0.9"; sha256 = "1vsrymzxfrsa3dvmia9wgvyyz1s8h3n76qwcysa78dqf6lkas77s"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "7.0.9"; sha256 = "19wzv0rwddcnrkz0g10gqya0l1brpajkg1krpcf8br0ly0n6fddi"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "7.0.9"; sha256 = "1l3g7l5xzcw3hpk3mcwsl6g72qfrs0m3blazrngma73z4cj3k9bi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "7.0.9"; sha256 = "1cl0xj4aafsfsvms4il6nrx8dyfwx0wdykwzrr2azy2yxvymqslr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "7.0.9"; sha256 = "1ckgzrwi67prsab6zrjjm0zmf6mbk7wzjjg197nnrjfd6sp5dpq2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "7.0.9"; sha256 = "0ymj65d1fjn7mm5w2myrhrq465xsr1nggnvpmbfr5md9g9zz78h9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "7.0.9"; sha256 = "0jhcajp4dy3770y5394rapsjl6z7jfdw8c2wnsqdr2cgzwjcjr3s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "7.0.9"; sha256 = "1rprrl8qbdn9v3j7k2dkh0krmr9bak8k3r5lm9v43f1h85gcicsk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "7.0.9"; sha256 = "0vgn0gd31xfk4j7a8grnnbn3sc8afbncxzcfykzlrpqmzn61plvm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "7.0.9"; sha256 = "00v7yivfj6vl2w0cxnw03pdqwbqz55ds32nanqmni069466x8aya"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "7.0.9"; sha256 = "139lkp92clq50d3jcpdlv79mx72fi46q7bb9skbgc6svz9d40x4y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "7.0.9"; sha256 = "0dbwkh60f4sbfxsfzi5kyhc7aiz6f9bx3p0m5h897pp94xz7gqrl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "7.0.9"; sha256 = "0v6ln2cbh09nsglkcclay9jkxchnlg89qkzxmw2ml353b42an1ca"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "7.0.9"; sha256 = "0kp2zhxq7dhsclb57ah3xw7ahp23n2xx1lxxmqkmw8gqgan99jwf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "7.0.9"; sha256 = "0d380v98ncgbjzhrd3pf6ff2155rbl173sr686ifs8djl1w86q24"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "7.0.9"; sha256 = "1f1cjqw2wxdykynj2vkxlhqk7kw058219yydyjsgpczrxpdqmcqa"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "7.0.9"; sha256 = "1kd4xdwwck1yjb2j4zwj6xq7b6skbc5x565mpzki8s0x2pncid7s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "7.0.9"; sha256 = "15fw7ywbn28asnn6d23rl5bljzx6crxq8nj0iv7l24c96l41pi55"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "7.0.9"; sha256 = "0k5iqm0hq9f9nwq9sazld3ada7zx2wypcf5k2ddhrwr53wr3rb2v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "7.0.9"; sha256 = "1nmb8hjln8y061381rii1q0m8ipbip51wciypdgvngzvjsibhsgs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "7.0.9"; sha256 = "16advlismh4qki0dslnycicy73xlhjm3cv595v8yldrvynam2bdp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "7.0.9"; sha256 = "1lxn13pvg2zynwnzxriw6izdq778w004m5ijxircn1mhzrziipz9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "7.0.9"; sha256 = "1659734dxb42pcyjsbdg1r9m13z59qm1kd6c23dpix2dwfn2jnrw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "7.0.9"; sha256 = "1zyrafkqv54fd03m8pn7gly2svh8lpsfkbf8cr962w56g7m900qd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "7.0.9"; sha256 = "1zsshmfjm8ivh34qgb6jcmrd5lv9c8lb40k9splg0d3vi9769kdk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.9"; sha256 = "0lgfaqqjsijvjspz2as5c5wjcgpl38pqyvy016b6bq0pii3008xg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "7.0.9"; sha256 = "1v1vq51isgmj15x6p9jmilvgh8kv75748ga7ba9d9azjcia6dj18"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.9"; sha256 = "14z8nr5h8aw5090xwd5ll82c9j936fhadf9k0skb8rghkwqlak0n"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.9"; sha256 = "10vkpyfp5v9nv2rcwbi20874a6swqzgzn7w4y5zkx51q9a2r80yb"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.9"; sha256 = "064yry4gplxjsxn46ardi9jzvpmm77b0pgv9izhdlp5jgnxp8hrf"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.9"; sha256 = "1jzasfcy1rmn6vmsm5i96srp04ha6nv4a564p09wam1xjqspm3fc"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.9"; sha256 = "1gri5l2gbxkbhhjxkzwa4wnyrm522pimpl8ad2nhq2mpa62kmk20"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.9"; sha256 = "1jimxwgx5b311y1nxchyxg7yabkns6xlhx9sc0ha6nyv9m9bbn4y"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.9"; sha256 = "1ml6kb8m6l64gvf2igh0cqbhgk51n1alqq1zn1hfcg695wm0ldxy"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.9"; sha256 = "17ls7hkmmiagdfrvrh2w089pi24xjyg5w5xbxzwagv65aff0m50z"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.9"; sha256 = "02n69ki00djz3504sfz26akgyk2m0bqd3cmpl3553sh68igqaqnr"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.9"; sha256 = "1cwsl8abvb5bvkciyb29jv0cbc9yr5gbsv4d16q7sifhmhsj7ccj"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.9"; sha256 = "17vfj41qza3l6vslq5zb8d8wj9mn23d3z6g2flb8spdlvvrc23mn"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.9"; sha256 = "0lcx0zwdryw2jzv61jaqhslc3iglg2kc6lcxqs746vhwsqd40fcd"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.9"; sha256 = "1cmjc993gfrxijk4mkfjvhz2zs146353rhg3948gal2r6gdqnqba"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.9"; sha256 = "1pp2fgk7c0gdjqmdxddj0xw99akrqpw8hx1wsj4x6yx5f3p3hgay"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.9"; sha256 = "0p06lmfip9iz934sdvql4iir9ln6n59f0bwwg40i4fldvpfgrf6x"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.9"; sha256 = "1gzfypb84x6wr3rrywr5m1lv0a77wz56vzczb6c5kgad9dgjxnhz"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.9"; sha256 = "062xbr09j64bh8qmq77mhdpkd12b1xn8282xyvbxb9svpgy5q3in"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.9"; sha256 = "1mjvzpsbr8ikbd6417y81bwfn1fa5g4i1hb6yv3spxgl45rpqy7j"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.9"; sha256 = "1fpl01yq1ha0912sr5wj3rwg29q3jknhdaibw92ql8jdmbwp6z1b"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.9"; sha256 = "1zxcy12nbpfhc7a0p3vmi645p79gnqi7g4jjd9ap7rg57b56wd0b"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.9"; sha256 = "15qvi3x575976hs2xqrr0z68mi8v8cpal64sc669njlfprk0rsw5"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.9"; sha256 = "1zr89aaxz4qlqk0fi4xqwv138k54lskwm219iacpkjvci88brc82"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.9"; sha256 = "07dasy4d7bnirkb61mirnjvgvw7l2266wi4bb69vfiq0gzfzbzr7"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.9"; sha256 = "1iiba4mkvhcbf1lc9ydmafxzd75mfxw16d3q4nm3mravf88hga4j"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.9"; sha256 = "1pvrz3gd1p7ihnhfgl1hlhxy6f90238alw4v0gdwcfqbxlnnfvyh"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.9"; sha256 = "1ammp0lxban03aam1i5mhfqh0lpc31d9qpy08i1qzs8dpy0qy8kc"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.9"; sha256 = "1gl2j9n3h0fhx4dpcq3lwvcnx5xirdsjs4vq0jph01zfxsvn9rh5"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.9"; sha256 = "0zkdalcb30dpv0682cdf0ib5hyz8ic4yksp0kj1ybrgj6wmnhgr7"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.9"; sha256 = "0m0m7cja0s1sza51qz2300c8m4397ii5p5nppm9nvx1cqhhrxyq1"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.9"; sha256 = "0ds54pnkn9x5nyngdkkymwkg8k0wy3g4jpb098h0hm8pv1pikvz8"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.9"; sha256 = "0p20jsz3h5rssiq6wdf1i0m5fb52y3l2a7d83j5s3fllvf1hpv5m"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.9"; sha256 = "0s6i21a8raazrw4cm4cs1jjxmpqmazrdjsa7xgk8j6r71galml9h"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.9"; sha256 = "1zxkvw32d099pjnkdza7jmfyxs8q9j46qhn3i0g2b01m7rla1nh4"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.9"; sha256 = "1ckx746lmb7m952c27hwrnf4ngzx5zk310rpgdk1v74n767n2l4q"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.9"; sha256 = "0jrh9507aa2m82i7b8i4ws7rx3fpbdlcfgr7qrv6046myipx847x"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.9"; sha256 = "1arfqghv2v13knh95k300vllx3rnb6rjfn8h0k5qyvgcha5dxjhs"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "7.0.9"; sha256 = "1qvr9xd8564bg6zq4qzgjvs1yy6cvpb6k6rbzcrffa0ql6mp5whh"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "7.0.9"; sha256 = "1vnb8719i9j1x3nkl7hc6wrcc0w98xiwj2bhaxxwcxjhnqid2kjv"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.9"; sha256 = "0d9czhxn25322iqmn5lhv9bwnznlcnr1rsvq52y6h3ks4lqbpx6d"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.9"; sha256 = "1k3abndg0gxji09wwvnnbi4d8m3xk51yc2hir08vb064i28x0vwd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "7.0.9"; sha256 = "1phh09w8x6i4w15rjrgc74pljaqrrh4cc2g2vaymffx32nbd8b0p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "7.0.9"; sha256 = "10h6gmf8f600qir9b282d9c3890b1jjkqkiv2h1x899cibx3r4xz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "7.0.9"; sha256 = "1199dqdkd9q568scprvbjpqqnjh7476vwykjj3wl242ljc9lzv07"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "7.0.9"; sha256 = "06q2r3sfj2g7r564q1ys0ny11dg3qz6nifrby9phijs1pwcrsf7l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "7.0.9"; sha256 = "1cw4cm7hr4x3niynbxc0z4lwn8lmd78x00vmb1kq52gvy24vnpvz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "7.0.9"; sha256 = "1jkv8a4apfjq7xjlw7mkap3h1znrmwb7kb175krslp9arldh9lc4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "7.0.9"; sha256 = "128gc9zy607ybhs58hc49lvwg1ddlmz3s6ak4qdibpjzxgaxd444"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "7.0.9"; sha256 = "0cgbxm4w10kxdjil8bl04d7py0gbccs5npaxnji0xi45977ajs32"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "7.0.9"; sha256 = "1vz7a4jk3l1xgihv812y198c0kwgbvl9fh21r32jm363dxrd2lrb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "7.0.9"; sha256 = "05vhl80v3m3jql0r72ba15gd1q4p1zzc709klzr3wv50zsjqpcgp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "7.0.9"; sha256 = "1sn6qxc57fr5w9hh9x37v6z0pgwch8hhm5jzjchyflkdj9g60zc6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "7.0.9"; sha256 = "1kxjwrqbrkwyigyynlcl8lip10rmp029qikiifq5mm6j0ifyashr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "7.0.9"; sha256 = "15h20x40x14grk7d9jacgi3kfrrlkszg5mxf5mcm0ycphp9cq4h7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "7.0.9"; sha256 = "0x9zkfp3917wwaz20c1x6yp22iv4zj6778l38m9xbhynsjiak33m"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.9"; sha256 = "025znra1878vbq7ywchjnc2jq1xsqnl3lkij5qacjh13a7zg8jcs"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.9"; sha256 = "1aaxyyg4f7apb5naj8fj72mh3jzh6v0rdmmgjrx467z471y0ccss"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.9"; sha256 = "11gj2kk8h4jpzgs0hyxa1pgsxw29y04q33c3n70bgsnjd6qrrprl"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.9"; sha256 = "0x58n7zl28973w2rbl7zjpwqvfq3vpr639zi78654sj0xjvqgd9f"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.9"; sha256 = "08p00883gf1xinwp36axld678ab039raqj6gbyya0bh8wcybwksz"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.9"; sha256 = "0ck7fqjp6xgnl399lhdp2lqz7zj2awx13dvxbyvql0iv2iyim986"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.9"; sha256 = "1257h215aa87irl6pd64sa1600kmhhdv1l545jlv4x7hm0jqy63p"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.9"; sha256 = "139ccsmjg8bgh7f318h921lv8g4nbhrycj0b3h7r8nxpg484inls"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "7.0.9"; sha256 = "0jg2qnm2wj7bwzgdw656sbvn8radsg9r7nvbsk06w6kn053kpnzs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "7.0.9"; sha256 = "1d633c6a8qyj5lsv6sjl1yb9j8pinkyv4m6qysffzz1swkzg2fn2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "7.0.9"; sha256 = "190n60bzlwsrrs1pr79va4qxbh0vj2zshjpw8wa3ypbfgw9nwfqr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "7.0.9"; sha256 = "0lg0hncd3f79z5rpldk3751q1k08dmn4nyzmg85ivci5xp2glmc4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "7.0.9"; sha256 = "0ldwqi394i7dancwz46d1g5w7w2d681k0qbb21wnn0l8llairmsz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "7.0.9"; sha256 = "1s6g2agg0yjzxppzrq06zg53ik3nk40pv2py3r91vvm9as10l0la"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "7.0.9"; sha256 = "1a3yv46jkpakpd35qbnyx0rik1w90wmpbffd2sx919pl77l262kq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "7.0.9"; sha256 = "1p7rmjsjyginrx6ml3j0pmlvghp6rhi7p2myn6di1lawi4c245sp"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.9"; sha256 = "0hpbb13459izw1c5qw7lh1sy5fbnmg7n8977jci5far584zbf3im"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.9"; sha256 = "162pjnjp7k5y1xckl0l7h06yv2d65lczwspqfcyy1ix7whx8l5fm"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.9"; sha256 = "0kikz4mgymxdjpg3xwlzwb5b7qdq550qf4rknaik2qklwr2xv7xr"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.9"; sha256 = "0crf80nb3pw4wr83bvsx7f48i63f2l1b2zc18sny4xhqlvbcfick"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.9"; sha256 = "1370mahfnshdy63vlxbyqpbhmv5rby5azfbnyc72xb7zglf9aqcb"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.9"; sha256 = "1v3knzlfb6ik4306lhk5d37pfmpxczl0d4h2flvvzs61ap1jpgh6"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.9"; sha256 = "10a0gk0nqx3p9xjaxlwlx6hkvnjps2dyfih91nf10dw31w40q4h9"; })
    ];
  };
}
