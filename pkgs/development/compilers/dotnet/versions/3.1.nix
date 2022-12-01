{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v3.1 (maintenance)
{
  aspnetcore_3_1 = buildAspNetCore {
    inherit icu;
    version = "3.1.31";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/2fc0069c-e99a-4296-99ee-a422b3cf50de/df8aee91eeaf50a12c810c3845341eb3/aspnetcore-runtime-3.1.31-linux-x64.tar.gz";
        sha512  = "9ea1fb4c9a656de8392b8f92c608c2f927fd03ad8e8b195f3f0b69c1433cfbf2679827b1ce2fac783f8ef77307c7b1b36563d0813f914b75b025b5cca6c773f9";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/216fe20f-6c45-4a87-b206-6c22360567fd/902208836df9ddcf4eb177771b2c6fea/aspnetcore-runtime-3.1.31-linux-arm64.tar.gz";
        sha512  = "970def9298bfe39c00054ae45231e2c632d4364a311349b3594bef5dd3739af2db33329f314f29a3956c271745948df88076e39bd2fa80e8a4dbb9723e3493ec";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/25282f2c-c43e-4c0f-aa09-f72c565e009e/b581cf1c97879ca4913a1763c7d1fe8d/aspnetcore-runtime-3.1.31-osx-x64.tar.gz";
        sha512  = "25d395435ddc17b8155c6d9b06c6b280e462da3e86a8c2b0b0549cfb80d2770b0df33a0a87845b442e89295000a872fce12a5949b4f1b123f802e8e2d071d504";
      };
    };
  };

  runtime_3_1 = buildNetRuntime {
    inherit icu;
    version = "3.1.31";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/046afe25-7b88-48ad-a06c-1c3625115c63/6814f9ca777bc7e2cb4b373027dcdd76/dotnet-runtime-3.1.31-linux-x64.tar.gz";
        sha512  = "fb2ac1a1e3b9b1eceb37587535d96a5a3c0b01edd07182ed57d4725e067678988a3fcdf22f3f49d21bc35760d69398af85a6449e6c3a8ed401ad85df920be4df";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/dbdcd07a-e519-470a-a03e-702f4cbf65d7/e1bc1991aa91cc52582d446ae4b63691/dotnet-runtime-3.1.31-linux-arm64.tar.gz";
        sha512  = "bb9594cdf3b1f8005005d12055fe5e1ae6ba40ed56c2f6f41e36b2c04c9a7fa4630da594c7d93fe587d75d9a00638818fb14228e188fb7f1b7b5eff96d53bc7f";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3a01bc5f-4deb-4cf5-bbdd-19a1dc406b2c/1c66b68807fe87cda620898c088000c4/dotnet-runtime-3.1.31-osx-x64.tar.gz";
        sha512  = "8890441bd64911656e34a824f3d4abdbcbe4337887efc90fc8eba62189be161bcedd0d0f0e1168dadbc25bc616c462ab1c8499b9a52f05be19173f2af8ea09e7";
      };
    };
  };

  sdk_3_1 = buildNetSdk {
    inherit icu;
    version = "3.1.425";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c2574deb-9c23-4851-89bd-211243ecd85b/046fc7e68a8e7e6e5854fc0b3b56e59c/dotnet-sdk-3.1.425-linux-x64.tar.gz";
        sha512  = "3d31c6bb578f668111d0f124db6a1222b5d186450380bfd4f42bc8030f156055b025697eabc8c2672791c96e247f6fc499ff0281388e452fcc16fbd1f8a36de1";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d4a8d050-e3d0-4f07-b222-5cadb21320f2/05d4d832757a78ec88fb56d8f9f4cc65/dotnet-sdk-3.1.425-linux-arm64.tar.gz";
        sha512  = "f3c18acc094c19f3887f6598c34c9a2e1cfa94055f77aa4deae7e51e8d760ca87af7185cc9ed102e08f04d35f9a558894f04f7a44fa56b91232ccc895f4e5a5c";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8d52dd3a-13f9-4b1e-ae1b-7afc8896bf08/f01ed5a9f1eb3d425daec9e900a334cf/dotnet-sdk-3.1.425-osx-x64.tar.gz";
        sha512  = "dbe560c6d052333f2922c8337ca84cb4cd1de614de53be8bc3c52537c32bc4d074b8af832f5a1660bf0bc07204c74b3f0610a12ce6b192eae6503f76bb5ce40a";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "3.1.31"; sha256 = "0s8rnj81b04w1lbgwirsv9xzmpkx9ffr8wyzgwwyvb2y2r39w6pg"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "3.1.31"; sha256 = "12w3gka0k2z309jaxwhrqlhjfhag0pn26k44528k6039r5vrc62r"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "3.1.31"; sha256 = "1gbiwdhsfns4pkcpvl1kdpzynkplal0binfawxhzx0mjp66447rf"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "3.1.31"; sha256 = "1k5zjvak7pp4rzcv3p4jp2ic23xyk89342mna3i9kp20qn4c36mv"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "3.1.31"; sha256 = "0kilp89vmcqs6yznvx2wpxafhpjbzybrvdbfqpmlxjbbbbsgfi7v"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "3.1.31"; sha256 = "021a8xn4haa8vha9ypvldnmp8v519snjm9za67vscd2kkvifcxnl"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "3.1.31"; sha256 = "1qmd1zx54khnsqwrlq76m70xbw6dv1qrz3f9nva89prjgkqmqag4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "3.1.31"; sha256 = "0dm0prvl1qsws22rwgkbdbb8jkgvgxw8zf88rf7rw3xp1dnhql74"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "3.1.31"; sha256 = "1i6ldw55wqck3nxh9bpw0czv2y7zqbckxky8ih1r35nf08yw6dld"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "3.1.31"; sha256 = "0pyssa4mhm3ik9w261kkmnhxri4l6kli20qg3fmfp5rb9yp99faz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "3.1.31"; sha256 = "14hrfingvks7x5y796dsfkhpjp4zszv7gvmd4ycczjfhrywfxzis"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "3.1.31"; sha256 = "1savp0v2b63sj6qj4qq30vbjgx8bynvvgadmgbgj42sk2p6sgll9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "3.1.31"; sha256 = "13plrsf4bgdqv5v8jha1n2jz0nj7jdggjpc7w7ipc3gxw42w0z1a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "3.1.31"; sha256 = "1r59z5nwdxrwsqy2k4bvisqs2q0chr6wv9kxgsniqsz26vdp163w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "3.1.31"; sha256 = "176575973yg2b6ls2c02ysb101xxamlgqkrbxhgbdkfh4w5clf6k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "3.1.31"; sha256 = "0nvirb5hfk0swxm92isg3r9czcbsa95lb071k3adfqw7lfz8mqzz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "3.1.31"; sha256 = "09akjvppv6xvg3yyc84jx0yrcxn3kfg27vls71zxa539yvjkh29d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "3.1.31"; sha256 = "03dsvrfb3jyrfril4d6w9z25rgl7ldbiqab5n6s7fjajz6qpmgj8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "3.1.31"; sha256 = "0j2p5110qagrl5lb1j6zll9h0x3d17ad7r2h89ndjfrzs8awj9sp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "3.1.31"; sha256 = "1s5fkl5102ar9kl6w5nibkc71q49yx9jdqr5dgx8zmh88klaqc6s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "3.1.31"; sha256 = "1p74kp59a6f8gvnkqvl9qfgav08lisjdsi882i4dpipxmsizbvn6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "3.1.31"; sha256 = "00vlrk33nrxdjvjxrb1ck5hxv8ybjwscx9v3y3vnffias9dmg5dc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "3.1.31"; sha256 = "037npznm0b3i4dl5ciif0l2cx98b4010633xjsahyfsnzszz6rxb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "3.1.31"; sha256 = "0626jfv9f0rbqp25x8sqdjcpqbbrr0mn7zlggz8lzkdfw3nj91pm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "3.1.31"; sha256 = "1rnvh65wav9ah7qs5a5anqb35z04wqp2lf1awzmam4jsmfqd666x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "3.1.31"; sha256 = "0zgwx8yl2y7hdc0xdlbmni55gq2fl1ni8xhdzknzyz5pwzr5fghl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "3.1.31"; sha256 = "1n85hrndj8kb9hi95jb7mfd197d17a79gl9mzv0xfb4zwfd3jb26"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "3.1.31"; sha256 = "19ssb0366lcs8w3wfq7nvbc2ja8530vfhps7yrwy3j46p2jl0x1m"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "3.1.31"; sha256 = "1i2das9gpk6lbvc4bjaarrgrmk29086zpqxkasgswqd17kdvpyfq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "3.1.31"; sha256 = "0s2x3ybfkj65p9b5wm0bvn2gfj442ylc44hbp2r4zgxabq0lghh4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "3.1.31"; sha256 = "0j31jicc7107wfims5f7sgwi97vywcmdrqc7y6qc5gkc2djqbslr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "3.1.31"; sha256 = "0afclz46pdy9pbfjzlg9vkyyacy8ymmsq3jp6r161x0d5k2444vw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.31"; sha256 = "0c7yhq57gy004k6fhsl3adb9nqz8cn019dy9gaddp6qlkiidirg9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "3.1.31"; sha256 = "01qirfj6ydwyasr7ggbhymv8c9bmk61vl44cdz9xq8cfvd6yq5bl"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.31"; sha256 = "00x9ldx2906b2z35diihb7z8q5a3a537rak1yyif27pw5s20s6iw"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "3.1.31"; sha256 = "0kpnlygnah6761iiqsdixzgb1sgfrvsqv0jjraz8bdda1778f22d"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.31"; sha256 = "1y9w7yzq47sd9i1wz1hl91s3yzz6vlhb3acwm58yv91r73h6dgy2"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.31"; sha256 = "0fpqmin2mx99ndzzf2l633dlq8xxwgnn7qws3rcsn6kid7hn1kw3"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "3.1.31"; sha256 = "02hyzxi4414z1clxhfni5x9dwmih5aww9wpcv8vjp9r33xigi6d9"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "3.1.31"; sha256 = "0mi3rwjjsgrr8c5yci1sg1yg57f8vhmmcdcyr9zsgwnq8rwrqn91"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.31"; sha256 = "1xbxgsi75xg0yrrpymkvh7fplrrrlw8k47knbgh8824bd7hvdq1b"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.31"; sha256 = "0r12z7z5pkwcjm1zq6dav3axnahl9nvp72lg4a6ds39jz6a94mds"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.31"; sha256 = "15vann79nyz4iayx10gcqwlf0frqqsmw26v9xakfbckha4pjhy1x"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "3.1.31"; sha256 = "13j2graqr5a5jimvzsvd1i5cnnmrzqxfcvax8r385gbav0xr0d0s"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.31"; sha256 = "0v6h1rj25i0cpvk78845wzxa4yffwjcnqkhpwdafj8glac633242"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.31"; sha256 = "0qbn4zzx8fxap4546y3i5zwl6rv0rfdphkns4gmh1fjnkfb7zvjw"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.31"; sha256 = "1ix4w2v5ajq6c4n6l7jrjxky7mx9lynsarfx0byxj4x5qlps1z56"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "3.1.31"; sha256 = "1bkvz6n741dgrh9q57db9jdnlgccp9gcsivw8555n4zqkwx3bwkc"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.31"; sha256 = "0zfhjqya1lnqz1zd9pw9c9w6ldvv8hgg76rh3qaxwfgmnp808vn0"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.31"; sha256 = "1fx08byahkjv797jnql3c7j9ldgb2w4pm9vhb326mpna28x3qgmm"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.31"; sha256 = "0m339qyn21782x2fr73bbxk6aa6dngfav0aqlpbx1gpr0k6xb26b"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "3.1.31"; sha256 = "1wwnzqb9xjadkgz4h6fmi7n0prp8v56cjfx1si79v96f3l9qrasd"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.31"; sha256 = "0zwvrnqn4w38xgall1791msd9z0nr9xv6rk2xy6i1qbkavz4fn8p"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.31"; sha256 = "0dyvsidj5g6rj0khakzimzn193vkgzzciyfs6jqa03mp99zvdl8p"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.31"; sha256 = "0ch5a8xpw89maq8lhncwp1izy16mwpjn1x60bfhzyskib9w931vw"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "3.1.31"; sha256 = "0zxfclfjjcxr33ialjxwihpxvp28by1zrv6cmja0jp71kr882lq1"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.31"; sha256 = "1is7azrlb222wfljhhnrwyhmrrc16d5hy8dadrx3s3h73bnmfl7g"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.31"; sha256 = "101ws6l12rcf08r80d02bya2wmwsaajnhvl4bjprakfiy4pz4laz"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.31"; sha256 = "0k4fx1bnkh3420234pnqm227l30rih8s9ld0zpb7rzpby14dclar"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "3.1.31"; sha256 = "1lsf021hw8ikwic1wdv0r1sdm4bypia9xcl7j01mllihs1idkadb"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.31"; sha256 = "1ccf8zdc1h6ri79qhj7gnclw7pyi08qa5kb2fr0m26zdd8xsgqbb"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.31"; sha256 = "19ffjzqvdfmz5pfrk5pya2wvw6734mn5dg424sxgpbr1228bayai"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "3.1.31"; sha256 = "0pra9gpjlndzh8hhjpxsqjl2awqb7lkp868jiljbv7a0hhrj7aiq"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "3.1.31"; sha256 = "0yj7lw8w74cfc2q2dsz1qhqdw9glxs6narsqk48r80ahfvrbc5kr"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.31"; sha256 = "1mh44i5b204q8kf70ywvhgggqf68b48j9y0d06wvzadnswakqd56"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.31"; sha256 = "11rysifqiysmajaipjg3hcrp3glwf6zg6ijvld0nsxwf3w4pxlvj"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.31"; sha256 = "15hz945p1wr4j9b7qp2vqwd5mah464l938d14ldckhjr3di5c6si"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "3.1.31"; sha256 = "0y7mqvxyhhannk11ky2i4gr60wcxaybv3ni4y7ydfd31k2baywf3"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.31"; sha256 = "1njd0xvn780rg2jvlyvsw7kaxi80qfx1crhsbihhgjnjx4199vgn"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.31"; sha256 = "162589081jp4nn8f2cq2d8mnzppmdw1zclnd66ablxm4dwz2xrij"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "3.1.31"; sha256 = "0nnd9kcz05j83qyyz9xbsyxmc6x872ai4bc45ificxh0rqa7zk9n"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "3.1.31"; sha256 = "1s5p5iby2866zzfmzd0x35aclgzmdmghp9yqn5am7bklhza4dls8"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.31"; sha256 = "0h1nhmmjs55alphb1x51namkaivr64611bn0080hi3kizrmiwnxf"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.31"; sha256 = "0sijpj15qjamyc9s8rxbqazi469525fzc7q81v9jw866x4laj4ms"; })
    ];
  };
}
