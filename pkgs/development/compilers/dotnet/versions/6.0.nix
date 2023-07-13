{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v6.0 (active)
{
  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.20";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/972dc929-4c16-4456-a7c8-64014f80678d/a3b62252f98a0d7e0c0a9a01ede18776/aspnetcore-runtime-6.0.20-linux-x64.tar.gz";
        sha512  = "891bad6a52a7bcd5afa2a784fe68044d282f6d53fedab4bde6dff8d7d2138a484e947f7a6be156094324b37e9d7e07e87a67622bcf2ea197c2924389edd1d185";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a8a1a993-ddd9-4bcd-8386-d9defcf0fd29/4b471f72c8253fa1462ea923d0fe39a2/aspnetcore-runtime-6.0.20-linux-arm64.tar.gz";
        sha512  = "83b1825c80cabfa5bbbd8c3e69b3525fa5cebef773957f96fee9319d60285155817973a176d47348c9b22bff5af24044f0f06b59229c067ce8adad4f3d4123de";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5fe2084e-1538-4193-9eb6-54b0f8470574/258915bac675b1dea6aa0b5435f64981/aspnetcore-runtime-6.0.20-osx-x64.tar.gz";
        sha512  = "5f6efea102c20805430815228070461216d8c5b928d090ec9d6d245eecbe23298920d1834276a0ce77bba524a14c83d97464580c72660bf3a2367a02f1872e31";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/14d8afd0-2635-4f3c-96fa-63edccafe16f/317d19d4f625bdae211d428ab880a331/aspnetcore-runtime-6.0.20-osx-arm64.tar.gz";
        sha512  = "fbc4033b79a651923dc205b923ef6c9ef048c862113ebcaeb8fa6388827245039369e261e89ac371e895c538aa78fdfc07a5a1c1cbc41713f54a15bdc0ffdf5d";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.20";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/26b4797f-d3f2-40c7-8f4a-91120ab87469/4677c3c4e3ee7919836c3a5336e04509/dotnet-runtime-6.0.20-linux-x64.tar.gz";
        sha512  = "3688d7170a59015c36d6a5532db67bc22eff66b3eb0a7fc28e1f425791e27a5f467bc7dc593d7f455d72d08c7d27bfcc92b3c8bd30ec3c7c583a8aa82b5afbac";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f45ea605-cd0d-446b-9d79-b9c033c10c11/ba7fd32581bb5f448abdd317d8d55b3f/dotnet-runtime-6.0.20-linux-arm64.tar.gz";
        sha512  = "bf9cd8b13ebe15bbe41d4f3229cc902c3de2eb4f0008f4b239f3d0ec5aa01254adb8a98742c0e32e98f4ba95923611ed9f54963225b462a829c184301bc98ef1";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/810c2cf6-c3a3-4f35-91f4-facf1ac24ef1/3ecedc1a0888b571d272c0dd64080c52/dotnet-runtime-6.0.20-osx-x64.tar.gz";
        sha512  = "f21cb044df7d1f57ad45b7ed65893a103cd6fe15b78ed3865380044207136d42deddde29872458e70fae9c8e7f254dd032f7539b4b9820995a075d92b907d49f";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0f3ecdea-c85c-423b-ab55-d97061a3d9f0/b01dd205c4d6ffdb6266e4540c82621d/dotnet-runtime-6.0.20-osx-arm64.tar.gz";
        sha512  = "27297a16bf1eec0e5a4154d8575b66008227a595cdd77277ae9796a53522b143ff51e063a7aa53a6c57717061cb2e5836c314ee43eeb86d465341fcdf834d773";
      };
    };
  };

  sdk_6_0 = buildNetSdk {
    version = "6.0.412";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/62181759-93ce-4512-8de1-92de74a6ba3f/f83ea41c3161f301d3584598f9c31801/dotnet-sdk-6.0.412-linux-x64.tar.gz";
        sha512  = "ee97aa5258e05aecadc66e844fa8eef97d51e5035492999b974cc8272e4db1a862a1f88a925f38be9e95c71d2e961b56459dcd614475895df608945c8057c311";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/daff8399-d60f-4bde-97bb-c6e350c03e90/5eeb0b21bf1ad11b5f5a7b4ac217c381/dotnet-sdk-6.0.412-linux-arm64.tar.gz";
        sha512  = "669c19665f657de00fda41e5ffff8d80395618dc1cc7d6ec50cd06668b135b5fcca193919172c65394210b7c060eae146fd6d8d57deed889ca8fafddca66d06d";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/094020b2-7fcd-45aa-a122-42ad85b25d15/969de8f0d024a5bee5260271e097519b/dotnet-sdk-6.0.412-osx-x64.tar.gz";
        sha512  = "0aa713780c4b7f4e0ea72a0813715883f57174f04386b85f3a6dda1a66d9cf6d24c76cd1e0fc0a0991b80b7868b39c719d5b98254e4f683b6bc89a9b4043be9c";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6a6555e3-06ff-4124-aad5-497a2940398b/47bda2f1324f867ae0da2099c5702769/dotnet-sdk-6.0.412-osx-arm64.tar.gz";
        sha512  = "3086e027b94ab8bc5b27e2dfaa7d16484efa2f6a7c1e291f420313021b3e6f65a5208de4b0d86271c3b83d05d784f29e231176dc6f5ba04e567336b7d7b7b871";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.20"; sha256 = "1jncn2n75vrhsmh22f5ij5rhdr2ninnz0z8clsi3pmk8ba2jzgsh"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.20"; sha256 = "1ssakq877f2wn51di8v64b3ij0izyr5glc37i238y9jm6l84kpyg"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.20"; sha256 = "0a6d269chp0126sx2igjhsrn7x6q03n5qwhwk7fy6ci1jddrk960"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.20"; sha256 = "13b3yr8y54g5ypnsrr7870csbnl9avwa7r6gk7553sjab255rar4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.20"; sha256 = "1js58646f4233g6a9lkwwwhg0kb2x3r60a66lbzapk253x00fnrm"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.20"; sha256 = "1cwn0dkwk2wvddfraqh28yqy3p5cyrnfkprilgy3bqbnq82mfdxj"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "6.0.20"; sha256 = "1paf9f3kmprw09nh1garni8rswcq7cs5m1ib6hkrkqccdis4hfy8"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.20"; sha256 = "1zr589pkivak83gjd7f15rc9g4whxmywjj1xyymbbaz46ain89gy"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.20"; sha256 = "0azf6q99aplbca8p2ijf9ccwrigz9r2aaplczj8byi0jd5dgya1m"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.20"; sha256 = "134a4yszz8gvba2zm8lrds39qfxrf42mziy4niihd4r9n44ksrdn"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.20"; sha256 = "0ijdgv1yczfppra6p770vf48vjgmrmcjxfnphah8rrlidssja1dj"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.20"; sha256 = "0k4ivzwbj67n4rr56fmi4jh2y3kdjhbgc376gk0ld50qwpghczxh"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.20"; sha256 = "1yiq9ihh71d8zlfsdf9xdnapzilxiyk987z9ld7w605sq6b45719"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.20"; sha256 = "039hs39abf1ngrgw1ali8pgzqqpwl6aiq7hqig85gj6phy5l8wbk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.20"; sha256 = "0xivyv70kzpj4pc4ln1rk48bm9z9zy3bck1m4vg161rrd58ry16a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.20"; sha256 = "06a211fjm9i9ipgh7y6fsp2si41mdr8hp5wpsvd083ybyyfsy32z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.20"; sha256 = "00vz5r4l5p78fkvlglvhhvx80qlv5szzdz9scf0qm8hf1v01wivi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.20"; sha256 = "1g0x96f8i8hiflzpb20h9wkn784zzlvd0413y8xlxgf187hj20yn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.20"; sha256 = "11sdzb1lrpmmfbd14b3may8d1n8smm1rmfsqamp7bni408j16cfc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "6.0.20"; sha256 = "0w69cfyww088v29bs6diy9jq0sl6bpiaildvq6rayl9vwid71qpi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.20"; sha256 = "1bi8bmil8wc42lp5b7a44c70mazycgxn2ag02r3r4wradwawfrmw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.20"; sha256 = "1c3qz6h1w5wfpl52ys7s29kj338n3wy7w5sn9ghdz5x5vgflah9l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.20"; sha256 = "1zzpj7czk28xip45i3fhhlh3ar0hh3ldar34c6w2vp4psvbdkm40"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.20"; sha256 = "06yzy9spp8d9pz7jihsrcx4rq3n9rcq2j0gq23yhfzp9iip2986b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.20"; sha256 = "0bs2hxyjyhnzvcgx4lplwlvlk7rr5lk0xbncbn8in74pvvjw44qn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.20"; sha256 = "0ra55v67748rr0acd22vgg2b31wmkaaghiifi26vwnrhihky9gma"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.20"; sha256 = "1mjj0bfm57anpywknshx8hc1z4xdinjxrxv3zim295w3dpz46y36"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.20"; sha256 = "1rqniyhv0i9zim6plbmrhcd9ykwabm5cm7p3mddxr8cgybm1vyfg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.20"; sha256 = "0wdqbzma9fc5sh74a3mcxlrby33qz2hs47kb5c9834qvbjf38fcz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "6.0.20"; sha256 = "1q5bk01briqlp5bzvkvrq978dzb52np2sp8lv67wjdm7xcbpnfjz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.20"; sha256 = "1zmsd13dd7vzwxqiznffvk99jqc3fdq3l382ixbr440a006splcr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.20"; sha256 = "1s1girqjlrkz2kqijasmbpfh2fngqiz2i3424i7k9snrzjgnn6ml"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.20"; sha256 = "0vmlhgywjhb8k6gi1624fk3q21gy5gsnjxl4f4w8lmaf22zkllvb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.20"; sha256 = "04p7m6csfjqgndi81hpg51gr8pgzqqscnqwgrkkj7nas2ffdxlfd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.20"; sha256 = "0ky38wy91pprdhbvxp64hz2fmf4kkchw9ldk0i68dnwg190lkjqk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.20"; sha256 = "1vs4jirn78v65fn97zx4vz4msq2zrlmiiinh7zl0dpyn0dp68br7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.20"; sha256 = "157z5liy55z3h3qvg9kkmapnldbw7v6qamxdfbk89l3dh7r3m5hw"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.20"; sha256 = "11yv6flr0l49rfa222p35dqv3qbc5jbf7yf28q3x09kv0x2571dn"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.20"; sha256 = "0nc1mbdk3kafgqayq4zmq0gb5ff0hd9bbn660haadmncn8j44njm"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.20"; sha256 = "1xzk2kpmps01srj0zyllfc8m65y2l27gpqcmvkh2llkv881kbdfm"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.20"; sha256 = "0qxiv3a7cgga8xnsq8xkvm5qy1spvgwsk57lm54wc6jyhc13fp2j"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.20"; sha256 = "14xfisjj5yrqcvy84f30jzvmchp2513afg633bq26irbcy6ilslc"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.20"; sha256 = "0zdm7bd1z90hn1rvz2k8vwxrzgl7lirmxx4k2ih0gjyp5yz8pkjp"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.20"; sha256 = "18icvgf5avz03qv26ivnmn01fmz345lls0lzgl8n3qr93v40bjf7"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.20"; sha256 = "00i7adsd6inpgxlr69xgvhsb7sg9g5sscwdmq46z0dp47s1vphli"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.20"; sha256 = "1wf0fgz84n6ag81ry4mydkwdzjrsxsfy7rix73hl8ihfy5f2jhci"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.20"; sha256 = "0aq5yii9i52i70nkgzm4sb2gcv8i3lw61wl3wbws3lak2van75nh"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.20"; sha256 = "0glzhxnd4fjf9qjn6knj9gw8j9svxf265sb3qxyl5wnwyqx7rfdx"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.20"; sha256 = "0ygdldk7xaa12y3y1mrid8v0045j7d2r9gg509m04r2xvan7rhj8"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.20"; sha256 = "18nmnsh51pslli999g99d52ivsld67nq8kqxccylwj9qmj6cs218"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.20"; sha256 = "14iz67jr1xrshb5vqph3wk5ngnx4a6ingcv868fb98gx13r7wfc8"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.20"; sha256 = "00khxrlvfy49s5yxn5611vs24lqhmclzks3pf6wy51rw0fy540q2"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.20"; sha256 = "00ws9fi2b5wy3jly5pxmgxcjkfmjixmy0m4lw4vp9h4rb8q6prja"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.20"; sha256 = "1lp4km2sxjb791srirywf11nyj69654i2s4x4jadbp1kb2r7hp18"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.20"; sha256 = "1hbxd5nyzngynqvj7n0css7xca7kra5zrdz1g40wvz7hgdacd7j3"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.20"; sha256 = "0s3g5610m1asz410pp57rlkbcdnsf6rpr9mp8lz34la34w19gkpw"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.20"; sha256 = "0d509bdgmpjnkxz0gnbssdvdq3rs05k6frs8wpjzm6i5469pxjch"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.20"; sha256 = "1ilbsss1w9940wf2jqfgkirf5hn1lqw0p4hpd68r9yryai2s2wnx"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.20"; sha256 = "16sc3gfc3dd0mh86xh3qg00lbdz3yq7f7iyan33rl01z6ljkb3w8"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.20"; sha256 = "0vd3dh0k192r5wf6k11p44sywjkgg4yag3a14y0v8f3lnxm7zqfm"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.20"; sha256 = "0qdxvknp6ns263r2gvd5iprcdcjvzcwdn2xlkhyy9ihhszkciv3h"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.20"; sha256 = "08pjmzx8qlknq7dci8m5xlldm3jxcj28zlwjs295951zqifzdajb"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.20"; sha256 = "17ygzmbcsj1xv5dx63rxb0rvn0laakng7asx0nxsa5pgx28isqdx"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.20"; sha256 = "0vw0wk0j5alk4ffnp9960cdca2gmlvh9dj553nfxdmnil4vpj7wq"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.20"; sha256 = "0k68kxzr0y113rasi0br3jh2f7qjvay61yk6hyizwiz7hikmg12l"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.20"; sha256 = "0kdb86h8adc5alsfbh7mii69yc1iyn2k21wf2j90izk8g63qdzsb"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.20"; sha256 = "19327qki08nnvvpqd1lkvisy2wrpcaj3v8d3qq10hyyf21in1ly7"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.20"; sha256 = "1b8wsdkhpkkm046v9yj23x3jdqygs64bzi9vjslbxg69h6andf2j"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.20"; sha256 = "0b0w27az1c97ailrjzdwlpzy7255nmq326gic51vp3p5a05pasrj"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.20"; sha256 = "18r7k5m6j7xpz4d0cnk74b0alxcgz6v2nz08zdkz1f473s6hdkvl"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.20"; sha256 = "1hi2kg5ka1biczyvg0pk7rvbfb08z5nib7yd18yxzjs7i7hb385j"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.20"; sha256 = "1w53abjj2cv39lgc8h4xwf42593cjhiah7vmfi4fc6iyl6q91qg3"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.20"; sha256 = "185vk80j81vckacp0hangng9r2rcw884nirwyvi4p1v0jk66i9g9"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.20"; sha256 = "1d01hrwkvf9a64lmv293xf829imghmy4g59s6lkh2dcg96m7byba"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.20"; sha256 = "082zbwg2z2p6fgqy0svd6iahawn1riiqdn4dn63zs6zvjwwc26wg"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.20"; sha256 = "16zmi46nkhld8lq1hm5kqndwm0l0w94g352mzammyvrpwsn0wyhn"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.20"; sha256 = "1i9ghy6hvslnh53xdk0xwiq0j92cjim2nyaw3asrqk7rkcynsxz0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.20"; sha256 = "1xh5yqlpwhv1xwng93kw7v345dsmlwpg651zmi1mj95l3qd0p9km"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.20"; sha256 = "0r8s132mgx3283gf1xsg5m4fhc5yy6rkzmii56g52wxpl4si0i50"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.20"; sha256 = "1m8gi6nfy0x5ha2cja7f37237ybb6hd81dcspsb0shmbgag141ab"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.20"; sha256 = "0n4fkn7g1zknyalzs9vf3z6x19vrw594qxk1pnianw6db39c9qf1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.20"; sha256 = "1nzpshl551sbmpdz8im2rvr8spi0rvdqb2js1kd1988qx2x2jwiz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.20"; sha256 = "00jnmbljs3qhb03d16hh5pqy9na9lij77kgb1wa982lmb80hj7np"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.20"; sha256 = "0c33yyrzfl3p1db7vvd287g7pq3zk14cq1hc8ggpkfr3z3kih8lm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.20"; sha256 = "0fggkfpr591pk5867q01qhijhmj4wks04a77fldjv4iv8azlsn8p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.20"; sha256 = "08fa4s35c08rkj4nk7y2k9flliajvw20i2z7fp4a9dbpsjvkaj9a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.20"; sha256 = "149l8qsjms1zk20xazy6ggcnyhvlbp3rd03lhipd28787jy69d3m"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.20"; sha256 = "1wj9piipky41s5z7zwi76ksf8snzk8z9q4vdbl146kkcnaxrkrkm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.20"; sha256 = "19vxwiakqlp299fj62f2ijh8hv67vlk9iz1dg876gvvp06k9mkyg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.20"; sha256 = "1mb4kl2jlk6zsavl979j4z2xmml8kjxnnp3gfmv6rynk7b9m5cwg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.20"; sha256 = "1nz5krmsx7l087gsfpfsmrbwvjjw8qsmb8wcwn5aynljfl4jq7pz"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.20"; sha256 = "0k9i48w2lh2shfxz0w0qh19yd6y9qg05izhmqb89zpr7m5sccp5v"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.20"; sha256 = "1xvrmb12fdcrd64bqrs111x170p712aazaqdspbbn5v3j1nbzal4"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.20"; sha256 = "0dp54dk7x8zwcgsydfmgn462ynl1809avmn6s22brip0iy7wrz5g"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.20"; sha256 = "05h8bg0655scv6crqkygc9iac5vf18cfa2slm52bcsvfvic8ad6n"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.20"; sha256 = "0yli4v5nxxizxfz24vk504bvjhngcvvk1ab3jcdirrg9z8pcp73j"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.20"; sha256 = "07indvjgrygh674k50k4isjpr3171h06hfxz2gy99bw3fm0y8lm0"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.20"; sha256 = "1qzzxdps0h7dpzz3ks43wzqvb9sqhbrdywzi883ipy7zwndl1avw"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.20"; sha256 = "08hfm9xjj6rl1c7zvcxfwsc8qb0d9l66l5j48k311apdc4jjsgg4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "6.0.20"; sha256 = "0nz759z6sgmrq29vjr2y04brfjmddr4ga7l5vrsv1k16vf39g3fq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "6.0.20"; sha256 = "02wqksvir4r22785w1rrnd4aqjav7asz8wji9v3955acrnhdg81g"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "6.0.20"; sha256 = "07gsm1p1ccb3f1vc4n024ilz9hc7qnqxj6mwk3k8jbvw228nwi89"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "6.0.20"; sha256 = "1p74mcsbq92cbbd5i83clxigcmmhi825q7izpzsypdpd46v73hmv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "6.0.20"; sha256 = "13pya2yy68r247fc4r3dbkq2hwaq5909n8v47cr7bvz07mk8isnb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "6.0.20"; sha256 = "1xidixl08nys9jzi17w5f89kq9wiwc135ddcbnhpfyhllhrn03kc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "6.0.20"; sha256 = "0ypcdzhr3v48iy6c3z6vhi2yfl7rzp85p0smq2pn625c1v1xgmgh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "6.0.20"; sha256 = "0py3ydy5pbxzvgi2lmkgcm1f15p6kikcym0hmlaj58ag796b1kff"; })
    ];
  };
}
