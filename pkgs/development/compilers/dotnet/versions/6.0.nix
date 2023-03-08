{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v6.0 (lts)
{
  aspnetcore_6_0 = buildAspNetCore {
    inherit icu;
    version = "6.0.14";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/092f7e69-2e23-40b3-8f36-628d25ac7109/4995e4e141b26ea049163af84592222c/aspnetcore-runtime-6.0.14-linux-x64.tar.gz";
        sha512  = "87f22bef951d00f6d55f30855e947f37f19a44b93e52bebe568d0aa0ace01462e9e6081140a0e771712ef9f032e7ab806d122ff99247a5725ae382828e8b394b";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/10762208-8896-423a-b7f3-5084c7548ce7/620af5c42e5a4087478890294dbe39fb/aspnetcore-runtime-6.0.14-linux-arm64.tar.gz";
        sha512  = "9f60b61c7ff41d4635181f8a361796ec390041a307b131e8b29a97776bf0539ca8991159123ff4bc80e0b88d65d245e0d311c320bca29285d5499d255ff4372f";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/80906b59-d713-4d5f-ae1b-32823ff1aa0b/6ac94e7a5652c33595f393d4941c57d1/aspnetcore-runtime-6.0.14-osx-x64.tar.gz";
        sha512  = "71d1d293e6e1812bfa0f95f0acfd17d1f9cc0545dda3b70e2188c8b2214e94f4b2af2976d71691bd1636bb4c614a55cc9ca1041a56c2902266a12b3285de8dcb";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e5afea43-c8ce-4876-8dad-efb09033baab/2b49d236aa076a9934381d9f7db88738/aspnetcore-runtime-6.0.14-osx-arm64.tar.gz";
        sha512  = "8801c5e80a94d19daea21e30d3365b39124d26e106582814a1d9c06a4d6b27e9e277416acabc28f135b1c95a88625e33521902039a1f56c88520578529842c5e";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    inherit icu;
    version = "6.0.14";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bdd6ca22-dd29-4b4d-a9bf-535a04151a39/cd4e2e686ea044729cfa8eab80ba12a9/dotnet-runtime-6.0.14-linux-x64.tar.gz";
        sha512  = "2eb1d0a35b21c1f03c0dacce94923d77e85c929a813fa9fcc885c7b045bcb6d6755511dee58f41e001aec294ba6e2163934b451c8c66065bb0bd1723c236e470";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/52cef887-8713-4085-a8e1-57e18d9a8c2c/85f217a96356c6cb3553883585f44625/dotnet-runtime-6.0.14-linux-arm64.tar.gz";
        sha512  = "4f559d5da668c67ed61c3e342e5ca77f2059b45bfa84f8c35b5ab4d5acb56ce75daf05713ef7b3ce299c1084fc863d5e43a4c14b1e04ce86db084b1fdd465a1c";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c25fd07e-9ebe-4bef-b53e-8fab7e3cfe0d/87dcc85e499fe8ec272819734822412d/dotnet-runtime-6.0.14-osx-x64.tar.gz";
        sha512  = "dc6ebb5d005c9e524ce99cb2c189d963e4399bbe8845c3c517282c601a884d62b126581e6238bbd83c173ca3fa45aeff119d6a91900780f7c4b1394f28bff803";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d88d581c-66c4-494d-8bea-922886d27a95/9617e9b18e88e1b02fab40c566b480bd/dotnet-runtime-6.0.14-osx-arm64.tar.gz";
        sha512  = "7c1cdab62768c293e2ba0de73400de9f4cdc061cefefcdb22030c367147f979dea241797400768370a68449270222955753d6df099236836889863915d38de7c";
      };
    };
  };

  sdk_6_0 = buildNetSdk {
    inherit icu;
    version = "6.0.406";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/265a56e6-bb98-4b17-948b-bf9884ee3bb3/e2a2587b9a964d155763b706dffaeb8b/dotnet-sdk-6.0.406-linux-x64.tar.gz";
        sha512  = "4553aed8455501e506ee7498a07bff56e434249406266f9fd50eb653743e8fc9c032798f75e34c2a2a2c134ce87a8f05a0288fc8f53ddc1d7a91826c36899692";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0a569135-1e0d-4273-ab56-f732a11f6199/6fb7eb4813c1cc1a7354cb665d2389c3/dotnet-sdk-6.0.406-linux-arm64.tar.gz";
        sha512  = "7653939414bfbd06b4a218fe17c0c8e0af20f7b5e6929949a0adc23ac515a76622fa863bd6c46bbcc0128238f4c1aba6b7ff5ace331fde43e89921737a20eeee";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/61c6fa00-1ebb-4faf-aaf8-30d39ca5c38e/e3d1785f5805093bcb6d778448d3611d/dotnet-sdk-6.0.406-osx-x64.tar.gz";
        sha512  = "e0249710b8dcf380179b4f57559e2f6745b855d387d4bbda861c94605763bf1f4c09293edb31e33b6271395c0211aed9b2b83f9cf5cc1831ccb1bc34b45e58c0";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bd1b3132-b61a-47cf-bacc-130e31003021/002152a1050fbc9eb723bd741453c9d9/dotnet-sdk-6.0.406-osx-arm64.tar.gz";
        sha512  = "1eb56eaafaef3b81593169374e44aa19e16606ec14e24dc2225f9e79466f08f904be052f24a6d2ee231b2f89473922c4386e3f0525570356817b90f9990b7a87";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.14"; sha256 = "0la135plb47d1j2x4di3r1b01aysnlpmxbjdpfpab18yc04gqpa9"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.14"; sha256 = "16qzgzgr4b0pl471mvdd9kzaw77hzgrsqmlj4ry7gq0vcn3vpx1p"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.14"; sha256 = "0qr7xjy08ygz1zw5vn9bqn3ij5dlmf6hvbzm4jsjszfqpna63i9n"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.14"; sha256 = "1dnqyhkx7i850as4nswjmahc2gv7xblqr57rzc019d14gs9ghaf4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.14"; sha256 = "0jq2sk2mmgwxm0c3f6yls2swksmpqdjrr9s3i65g0r001f475dds"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.14"; sha256 = "1xc28c1qh5dmkilfrw1q89ghi5awr505p6dc28qbi5nknkvimbb1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "6.0.14"; sha256 = "16ymdi679vj9inpz5lbsb2wiyw3dkflawhl3aj0lpfgb1d7kb5sf"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.14"; sha256 = "089dlyq9fbaavicxd79iwq5h1xghn2a2x5jjaicy9zbapp5wng7f"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.14"; sha256 = "0z2642jf4sq82mxxp0p9rf74l2qs3qqszq6f10khv1n72aafdaad"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.14"; sha256 = "16fqif9v4wifq5mqkd8vir2j6dsfp14rgv290z8msps6cqx63n5m"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.14"; sha256 = "0q43lxc5wdw5vaypzc068yx8q1s85sj3yw1lcdjr0ps7nzzv4laa"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.14"; sha256 = "05dz56dv8vk07nbpnadarks2ms1sk8a463r7s5a1va8wm7a6rcir"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.14"; sha256 = "0sgxgh84hdkq56vylvkpbas8qbfzzqwg2np04m6fz6hqagmnqv0z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.14"; sha256 = "0ki9yrqk7763b6wxdxy91l8r56gyp63k5kxbjnfidlb1nj84i9d3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.14"; sha256 = "04pnpxxgisy1zqwc0yx6blsbn6v9dyx6hklpf97702xkvc3rnp8n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.14"; sha256 = "1qkx9i8l177r82ywyyxg6nzzz9g8mpjgmis34ix8svr7swf9jl6k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.14"; sha256 = "16v30vgmn0frzm8xwn2inkiwa51jhyn5wlnpw5mplfzfrm5m1gmd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.14"; sha256 = "1mmmv3jlf99qkp2n79v2x20x0c6h7j8vp24qnh3shdcqxmj3b6w7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.14"; sha256 = "04yp0fijjz5l2fqcw7lnmvf8lmgnzwhv1353lnr170cxjn356fhx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "6.0.14"; sha256 = "0gg23k87ln59adbig8yi2i84cxshia61wwjpp9fk8i7fb80n8mgd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.14"; sha256 = "1dpd3kib06ih9j59vavz1f40wm2qb57zj1y0j24b5lilwpki9295"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.14"; sha256 = "083z3gf7ngchkp64gm9yjq94434gb8iz2m7pbimblfgp3gjpfnvg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.14"; sha256 = "0sb97sf4qg5j7c2g9vr1c0fffghfwqpbirxl2x7ynrrj451apl2f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.14"; sha256 = "1jiji4076r8xd3g1wx3h4c8ghsdll9g9qxff717xv4wy7m0vnk4m"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.14"; sha256 = "0z73vf33fj4qya582mzha24c98qhg69y6qkcvbg5zs03h7333zyz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.14"; sha256 = "0kmpsyggqr2m5m2cxb4sszr9jqd0wlvvdiz83270fss5v4l0hm5a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.14"; sha256 = "0dn23cddij0w83wa7rlgq56n4jxbjkd2svimix2lzj9znpdd1i49"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.14"; sha256 = "0jq6xa6pj6fa6sbims848a2gz827az8rks644ml59rj1iylhrr38"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.14"; sha256 = "04xlq5yhbm2i68zzjdgr7y64c91kwyg8hysn1wglijkmrq9w93hb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "6.0.14"; sha256 = "1arw27bfrhxpqaydcqa7mh5viqg2kkhyj92lspm6xgjhz5fncjnv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.14"; sha256 = "1ahs36dw4wz4rbl0sgmnpwiny19h31mb7n0rilfhn61xpyi90xai"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.14"; sha256 = "15flqfm1lmn0h527nh3vwwgmlan5if0y29a58lfk45ck3nsvjp9b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.14"; sha256 = "17j4r0qsm0s8kpj0i538s0w1zn6jlzmgkvdczbddik1cfzl0mgi8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.14"; sha256 = "1hh6mbb25agxkbv0n843jnvxjppq4gp6a3av1gjak7a8k9105k32"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.14"; sha256 = "1q7ssasrzvdjw4sr41m8g9njm9z1r3y5vg65jzan6ahldx315x6g"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.14"; sha256 = "0wqjnzrz0mdpd90naxhbbqws104rlzb0wdg5zk0wpm20y895zqnr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.14"; sha256 = "07qhxawl2rxks0b1iyzhyd201hf7iaf1vaw9k2h5zp9r1pyq743m"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.14"; sha256 = "0q92pv3x83i5h3wd8br8k8gbdcbsmdzdpys1xx5ms383x6197lkc"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.14"; sha256 = "1q41lxiqpmyjb288lpjxa947d2yk03h07grn8w51560yx3h65wsh"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.14"; sha256 = "1dn6mikdwshn7vqvwqsi0p67pw0ssn487k6cxsqm9nsqm54cd5q4"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.14"; sha256 = "03iyj2nlc8a1iw0ablbmmj13vxc5al9r85isg4g014fywx3hysbk"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.14"; sha256 = "1w6454q0q43l2r2qffacxr60m3cl913nxmzi7hwq91pnb7s0rv2f"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.14"; sha256 = "0aaj13rkxgi2544gwrm5h15wrpp1ik3kvpd2zb88mplcknyhhljg"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.14"; sha256 = "1sqsq4bmwg832g63k8k28c6nrvln4sparph7785k7hz0xw44nvb6"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.14"; sha256 = "07dr8zxx05fvxljx5dn71nalq6nvkabf74bwsqy82ibirx5g4adv"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.14"; sha256 = "023c10649nvxlmzb4w4im1r33198dx0kk4rmr4psc1gw1wismz58"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.14"; sha256 = "01872qqfkw2xvh3ngvn3nx80pjkdqdgyq623ippw0wm04kmpqb81"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.14"; sha256 = "1x0z471pjl65p3hrxmv5wbzssp35vki351ryy123z421yww9ackb"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.14"; sha256 = "08p40wk03fzy8dg91psliymzrbl3ypj5d8fkz5rsvxap2dbihi3n"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.14"; sha256 = "0r2hsb16bwnj996hxs64rv2dpwcs20isk2gkzf69061sh76m80hp"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.14"; sha256 = "0a2kz1cm8l7f12n8dyjyd42kii6hg3yp1h41670lwfq8as5mixr4"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.14"; sha256 = "1l8cfpm6ypx75l0sm3v11wqq5mbpyji2hx2q4549m90319lpx19h"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.14"; sha256 = "1srpr3yhjqa81zpimk12jsh0979zglxfhz4jm7jiqf6bmfy3s79i"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.14"; sha256 = "15sjik3krwnypc8vlb3vyi10kgzhvkvrw9lhzl36hbvmzsz65ah8"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.14"; sha256 = "1yxp23xb5md39xz6xh0d0jpy6nyrbwkijsh9ii6vnfdl0jl9wj9p"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.14"; sha256 = "1m8mzcqxndich8z0b4zr3d5nx5n9pxpmi4bv36sv6cvnanikym84"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.14"; sha256 = "0s4v3qnpwm17jp97bkx6qya28jb2vj6z86kg6scrb7r3szw49l00"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.14"; sha256 = "0rq210qyzdyjqn6kjpdw28wcidi4kb14f3wmjb21491p1sqkdx9r"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.14"; sha256 = "0zbsgh9qhn1asmqs3abaxkld2isj9wp3yzcrmx9sfi8sdfwjf8dz"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.14"; sha256 = "0zhl1rxx4l1hwfd829ys231hxh6w5g2q1zi7rbpk980cbrvm8jmg"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.14"; sha256 = "1g8s3v0md0wvqjsmlw9zbz028bm03l3xmqc21v9fys19gfdrsr5z"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.14"; sha256 = "0byix4d873k8v6c0xv3daxdb328g7bj0w9qfzmdwn5y0ps2xj9sd"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.14"; sha256 = "1zv8mqd2kmzildakwcsqvvp1ry11xj9cy5fxrjn52sc7hvcvjzdp"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.14"; sha256 = "0hmpnki3hsgfqmq3vg4jcasx48c3zbif2dm4w8hqh2r6jx83m1n1"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.14"; sha256 = "0wjmq056d9lq89gcprj6bbm7ywdw6ssgnp3mjfm1mmp4r0jk7a2z"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.14"; sha256 = "1884rz8gsa0ck5hrm9dqmir60kzcv1x47mamwl4dcv8ncrwdz61d"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.14"; sha256 = "1nxcc3j2d0s19ys064nvbif07rsi56gfbrc1giiw2l7b2z19zmn4"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.14"; sha256 = "0xx0c6s0v3fylpz9wphd72ay2a09lpnlgswbhjiyb8phymw7jgrv"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.14"; sha256 = "0nn7qmwyh6w5fjhl9nqibvn6h8qjdf7pk1spnmrlll1y48s2wzjw"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.14"; sha256 = "0dp7cgqry8dqpzl2zwj63b7218p0hinhlqz9qaiqzh9c7c2wk121"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.14"; sha256 = "0r5hnv4zck79ml3gxxzn3hk0gpqyzw0f0aqw4wfhgjjbisa6ir4l"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.14"; sha256 = "168jhx2dlj1j95d37d6b4blkwynddbafs4n26cf26x1ibjysr6g5"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.14"; sha256 = "0z8scys0rjba5wgmjq8024r380gcwqr0xcggzi6qm20vxhbfix3k"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.14"; sha256 = "19s13k0v9mb17iyr35i0d75sscdrrgbvcv36rcpygpazy9ydmgsa"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.14"; sha256 = "041kxxa495gn21nfichdi8vsyhyhfy64fm0jzcr9l5z87m4ywf66"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.14"; sha256 = "100hrhb7mgffxm3wc8gcyzpgp6bsz7gjylagpiwazld14yb8c4mq"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.14"; sha256 = "1vzk9pzhqsww427zgcax0bvs2banhs2wgaxc9yn18y6f2fq8whl8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.14"; sha256 = "1k7iss51zfxj17sbxkqfky7f4k63a931v0qzgrmbljwvjhk6xhfz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.14"; sha256 = "19aar4mxraih1vcshnl2sl6y536v4m9a3k7ymnwrl6yhnmmhn3sa"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.14"; sha256 = "0rifg8ibxq2h8z98hrw9xlng7a7zvfzfr5fizgs89brr2ng7s898"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.14"; sha256 = "1hiaanggpc5xk08c29mh3nfdj3il38jd8wr0xiv0r73ld6nfbfxz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.14"; sha256 = "1lpngik3n1knv10lm7h3y7yac5pcbq1if8bim2vvvkjmiqxxybnw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.14"; sha256 = "1047xhl0dxc1b9rrzv7q353v3nb4q6r140ks93gdag24fi0m9qin"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.14"; sha256 = "0lnlmhwff480idav33yss0ii6vlgfjzmnz5h4kx264h48c6jr370"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.14"; sha256 = "1gp6ws83zh3nznrlfr9gh3xnjj9wj2m452y922vkfqhwx9h2w1fy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.14"; sha256 = "0xqmpz5hxdaqzvfbd5yicgsfsql7h84jjqnsdg47cplk2vrd91qf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.14"; sha256 = "0av7q4kbqdkzksh24dmjbfalah6w1mmmshqmpwn78q4xhkyldawi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.14"; sha256 = "0vqrsq8dan5m5jvsd666ri3v8pyxkl300b90jh3k6l0yn2rhwm42"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.14"; sha256 = "1m6lmadlsq878k6cbz4slv0hvng3h04wvj4c87fybywa2fvk0ykn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.14"; sha256 = "151hy2gharkdq6xvzknac55rgn7vd01v61r1by4w1yascw7ppckk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.14"; sha256 = "106nr57pkwp5k4sjv1313wci5fmgajcpkvn1q2sbpglf8bv2rm6p"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.14"; sha256 = "0sii3jvgkgc3w9s9xdn8gjylwdx1bqvi5v92svc7br1l4jrd8yg8"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.14"; sha256 = "0imi5f11zhm548392j44gdw0i7b2yn1k5yqnrfnhgbrfd6mf4dcw"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.14"; sha256 = "0d70ndlwhc60dai1f731miz7s1408dbw8jv8mxdza0z9b8wkww92"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.14"; sha256 = "1j2ydjxngbm8rdpvh34w7qsa54sa0dbqyq5rjxx5kgq85qg1ddv2"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.14"; sha256 = "1bfgpzjpgl5v3av2wlqmxj78yap47gz92lv0zfwvmn3phghhcn5x"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.14"; sha256 = "0nyv8w6m383mw0bnqik9avn1n9f321sy9l6iy1ygv8f6mk85gsim"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.14"; sha256 = "1cf587x7prxbxadv9jl32dz45dp9g5dkrxanq382f7jj96zxwh0z"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.14"; sha256 = "1v8rdvgbh0bq495h4dfjgddls9aa4qa31xzcbx5pnsi0j9b3cf1j"; })
    ];
  };
}
