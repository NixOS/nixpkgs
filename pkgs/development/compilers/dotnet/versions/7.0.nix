{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v7.0 (maintenance)
{
  aspnetcore_7_0 = buildAspNetCore {
    version = "7.0.14";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7a1d3e1e-ede9-4b28-a9c8-3023858b7f01/c9214ad6a85286f4abd026d23dca5d3c/aspnetcore-runtime-7.0.14-linux-x64.tar.gz";
        sha512  = "00f55556cb580d81bf0059a61a642ed8b405452d55e94460c03a0edec9a4f608fd78561560e5fc5bf6e42fb1f45420eba75f8d102d8bd46686379dab7ffde6f6";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d7ed165d-32b2-435f-a747-9683d4f89354/3372ce43201a1977c30bc8236bf0443d/aspnetcore-runtime-7.0.14-linux-arm64.tar.gz";
        sha512  = "577d927686639241c00e2f07fcb11eb878d671e926c6fc058f879619452ab0af675db4c2dfd8aa9290f03cb11afcf5094be1beeb5fae491f50520e171e732a71";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9d6a0fb7-65bd-4f61-8558-e545af46fee5/f16d3fccf91fde1481c04314fe851e2a/aspnetcore-runtime-7.0.14-osx-x64.tar.gz";
        sha512  = "37f526b1192f67792aa413f6035a6e67bb42cbbab7b240ec0194a0640ca08e98546796e751fe1700990b2c2c0b71ddc3516571536f1110b4db47b2a1b44301d3";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c3308f4f-65c9-4855-99d3-21657f401854/d12446cf25f3fca12438881117d5b292/aspnetcore-runtime-7.0.14-osx-arm64.tar.gz";
        sha512  = "17f0c996b2e5586385b2e6cdcb187fce27e0c18f235c4198df9a2bac5475467fe6c9df6405e7cd75ad4bb1a5f6ce380e23330cb1a047c5930aeac9c6c89772ab";
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
    version = "7.0.14";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bece81ac-e35d-40e3-8b07-cf5b0c4872d9/d571e657adc85ec66141a82dd3ef8fea/dotnet-runtime-7.0.14-linux-x64.tar.gz";
        sha512  = "02fd66ef2059d124d9c4f3fbfd0d5b0375b83610cdf51a2972567e4bdaf1d55e532478533509ec2408c371e7fdd6efea8e9b9aec9eb5cd703e8e5d2814ef319b";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6c6534cc-0798-4fc7-bc45-1101fd627181/4846e3b3bfd3570d2c6f3e3b6711efef/dotnet-runtime-7.0.14-linux-arm64.tar.gz";
        sha512  = "cf2dc2997b10148b558f78b2f2401acc83921a6b721c11199ac7dc77d8c9fb5500d7be092281f13f3c9b4287dedc6fdb56f242d9340568a0fc021055983f9cd8";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/49878be9-1cba-4e7d-943c-b0f6cf5abd71/1f4d396b60584080d4bfee86269a5e0f/dotnet-runtime-7.0.14-osx-x64.tar.gz";
        sha512  = "74f66428fdc77ae9d801e1f7559d99436c6d1fbee7a64d587e46637466873a32d76b867f5cf56c0951bb01450419b8f25e851e5ed0abe69444df8979312cf9a0";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/dcede156-7e96-4b45-b750-c0a4893448d7/8ab02359114d9f4930baea23f3b418be/dotnet-runtime-7.0.14-osx-arm64.tar.gz";
        sha512  = "0de7be8aa01c837ef587e9ed8b2944ef600466a2b68c6f0a4c63e1d4473b92a09667a31a412cc2535b8ca44a0f768cd1a1daa419ad152f2d42c3513fab35eaf5";
      };
    };
  };

  sdk_7_0 = buildNetSdk {
    version = "7.0.404";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9c3e1dcb-485a-44cf-b1cb-d6c0b643d805/d4b2a46283254b6d68f61ee3f1a06952/dotnet-sdk-7.0.404-linux-x64.tar.gz";
        sha512  = "f5c122044e9a107968af1a534051e28242f45307c3db760fbb4f3a003d92d8ea5a856ad4c4e8e4b88a3b6a825fe5e3c9e596c9d2cfa0eca8d5d9ee2c5dad0053";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/2157e304-6f7a-4646-8886-05cc0dba157d/4cecdaeec9fd4715d0eee8987f406c21/dotnet-sdk-7.0.404-linux-arm64.tar.gz";
        sha512  = "b7131829d08dadbfd3b55a509e2d9a9de90b7447e27187bd717cebf1b134bd0ddfcb9285032f2ce08bd427487125e8b3e9cdc99b7f92436901e803e65f1581de";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/555d267c-fd4f-4431-93b6-d135cc1b1753/de1e43b9ade16f748a7e0c528bdc1498/dotnet-sdk-7.0.404-osx-x64.tar.gz";
        sha512  = "6e04e1d262c23bc0fbd6be9b1f847c1a47142438b330c004e46b49aaf0a520df3f3c0a576b2fd0ed88567be572280e5f5a98908c920108c58e65aef22c1332d0";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f2df5209-a44a-4567-9a8e-56ad008fe383/c851463feae2305adeaf9466890deea9/dotnet-sdk-7.0.404-osx-arm64.tar.gz";
        sha512  = "ca2dc7a126aeb8ab6c919bab535eccc47817666feaf0cde7418cab0a2cee238ec44d229b3f4d1f7550d121748f1e0abc5e4900b33edd57f2cccd89b58fe84f49";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "7.0.14"; sha256 = "107az2qmdalwcxn844n0fck9dfxh40yc4040rqv1a1xabx324z11"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "7.0.14"; sha256 = "1hlhcs1qyvfnx96mp4v5p7i0kx4az87q2x8fpz7xvdaqa8xwkbri"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "7.0.14"; sha256 = "0mdgi323jdi731m31c3mw641h7538cb6zjpkrv30cq6rr2k7gasy"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "7.0.14"; sha256 = "0pc12zlglwn0vs8r5hfawj9ks2sjz8j78ry7hrwrj1l8nf0fpnw5"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "7.0.14"; sha256 = "1wjs8jq6d96q8rpwlimgw18krlc7lyf7apid16ajr8r6brwwb3fh"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "7.0.14"; sha256 = "0pkmp49ibwkw3y8ry6f7kj22k2qay8b2f7m5pf4kkz2pgzqpvnc4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "7.0.14"; sha256 = "09855lccxh5vxf4px2mrs3rkbn2shmxmgz9kgr18bqfrbvgs9kzq"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "7.0.14"; sha256 = "0i828farfmkwdn8hqil04ry3hcmrvkg8gik9s2sh4046gjaix3n9"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "7.0.14"; sha256 = "1j17fy7l566wcfa06ina88lzkdvygmgg9612f1zvj8vgdhvl8lfc"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "7.0.14"; sha256 = "0ihqd2rdpvksvy3zkbpnwnirz5npgsini04q980ksxk95pwkplw1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "7.0.14"; sha256 = "0kpjb8qxj3z8iiwy23b6xqkqvrfr5ljnb220m9ms2q2sd2n2x4iq"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "7.0.14"; sha256 = "11qvhy96q9c1ijpr68r43xhz6b4i72a84bnzc4l8jy69v98n4whj"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "7.0.14"; sha256 = "1ksrwhfip4v7j73536khsia1ilprqxi3saaqfgfjb0qwv8pb3y9l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "7.0.14"; sha256 = "07n17hq5ais05dc7703b8q0i5bla85349vrfacdif8lk3iyj1qr2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "7.0.14"; sha256 = "1qx1za7ywcpvfljcznhh0rbpsw645c002cg3v55dpq4ripyn51g5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "7.0.14"; sha256 = "0xlpfwgcka15nrc1c84k0fawryggd4mcny4lygxdz2gb2m0kx4s9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "7.0.14"; sha256 = "09iqfjmpf1bin8k02fnrjlrr0wv0bv5m7mpg24hp180d5nvyzvnx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "7.0.14"; sha256 = "12b5g4v4kdq3a28ky3khfbpgdrwf8rwihia0gclcxrmb35dah15f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "7.0.14"; sha256 = "1c82ii5czjp3nvckcipi4fxn9rw6yriy2x830ww0v8w65bphbl0k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "7.0.14"; sha256 = "06py83nc6gciyhsjqxf78rc46bms9ayyah2jm28yr399lkr61faj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "7.0.14"; sha256 = "0iphqhpgkznfzhxcnkqs3sw84dvl8s96aqpn86n31yf1r1wlh629"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "7.0.14"; sha256 = "070y20fg2iq1mphwyfgxb7qnf82yvxa5sjw03c70kv7wgcfdcf3n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "7.0.14"; sha256 = "1v2wvzypnb28y7g7v53qy7bdzxy8iqdqmxns1y2xgzlb3fmq48q1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "7.0.14"; sha256 = "1gjqqwpnjv5asg5gglj9zy9ip66ykl9ll82ymxxmpxwc4z4hww27"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "7.0.14"; sha256 = "1vdwgh4jymiz1a390s4j2dkdf1zzqi8k0ns96cbna62plq6jpd56"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "7.0.14"; sha256 = "05bi4ijkycfl6gzca3bwh999k4zms9prdrhf2gkfi2z247chrz7n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "7.0.14"; sha256 = "0pjk3w09bq92g72xcn9hjkl6fml57aj2jfinlc88621ylrn4d25r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "7.0.14"; sha256 = "0ggy2jfnz2i03zlccbxzhdw8dpfhjznzmqq4bf4i7l4mq22z54hf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "7.0.14"; sha256 = "196rmkm44nvqx8b2ng6z2jy3j0xjasz2rqms8c4blwa6zws0ag4m"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "7.0.14"; sha256 = "0zf43l0qrj8cvz32qzdp2jdsnjmd0gn1rsdpbc7ljr32svnqc6ix"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "7.0.14"; sha256 = "1q7r1pcq0fga0ypxvn061hrdgjcqs57z4r9m9nnmdbziabnph09s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "7.0.14"; sha256 = "0nw08igwqcrcqynfmzvs5shhq2ndj2hvgnlb559ggqfh08iwb51y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "7.0.14"; sha256 = "0ivapnc1jik4j09wlprf5lw5l7gdf7q8ll7hb7h7mqzydsjqxk15"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.14"; sha256 = "1n2vb34y85k5krhp8jk04y2x6cxs34iwswfaj47ccam1kj2wv0c6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "7.0.14"; sha256 = "0kgmf87f5hpil3ybyamzy1kv4hpf38nfvgldq3v7kq9zjmzpkzz4"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.14"; sha256 = "09nqj1k0ix1ap7gsnmd8wr9qpyn4hnqlpcln7y5fkvdsf1wlcaa9"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.14"; sha256 = "0irn2x5v4h9b5zyp7s7ssiz1qv36960ihr9a66ciscrh035vnnnd"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.14"; sha256 = "0fxmj4gpr8hy4zpbk3nvkadsaly825figdjm7gchg3gwhi5mhxzb"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.14"; sha256 = "04xgdqnxikrx2mg2pv7lpkgspybvg0ki0waw3nfiqkkgb8kbyrg1"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.14"; sha256 = "1d60x86pwxaa4mss7pmcinp739rd0k1d4y19khc3n2wg1dghj5k7"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.14"; sha256 = "0zb9bnnw5n1cc4479linkssi6yby1kwswyx79d4kjmzh11wjby76"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.14"; sha256 = "0chpz5yri9a5yp405jqjzq9ab67jff5znnz6l64ngc4527751s89"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.14"; sha256 = "0zpkyv2y8kgw0x95fvg74wa038gbz9z9n38fw24gzwmsfcyp6ljy"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.14"; sha256 = "0hy3py0pdips2a0apfa21mc5lsd7a9b3cwr0g4whnlbs5k1pank1"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.14"; sha256 = "0lmqh7q72l444hsz2gp7zixw65dfvdck7hqkrv3s7isswzlq3y10"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.14"; sha256 = "0h47vaxj3iqn85nc1wq28jbgc4bharv7aa2mg0rzwnqgi5d5w9fy"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.14"; sha256 = "0w3pnv9hp7irn8q1riy03np9kr4x2lqaqzwph23rb57i9nqdka0v"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.14"; sha256 = "0zdrzr0p81ib37pjq8zgcqcglav2cqsh7g0kzj2q0mj2dy2alhf5"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.14"; sha256 = "0cn5ij2knr8bgms074qfxgvclv1256a37913siyay3zdfvg865xp"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.14"; sha256 = "1cdphyh9xpck36wbm0ddwqh8rskm005gf26qs6zg06qpjw9aar9i"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.14"; sha256 = "14bklwakn40qsdbc6c2nr3vx74dycd966zbv0b2y5n43f8f1bbhq"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.14"; sha256 = "097fjbz4zainbk32x16dlg0824m2f7v6szw41kfg8bf7jc09kiwp"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.14"; sha256 = "0k30ynxinsc5ywdpik5xs7vhbiz4njj12s8c4yab71vcyv6w9v62"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.14"; sha256 = "1dkgp02ibkybslw39lhbw9bpbml18ffh9lvva8ax31yi385ysp66"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.14"; sha256 = "1gr1l12d0vzip3m357dd2y1qm0g4492a3jzpgzj5471nzp8jwzwi"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.14"; sha256 = "08nz1gnpixqq2n7sh0zib07fb840v9pb02f4pawy8rn0lrc81cba"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.14"; sha256 = "1lg0lyi2s0p7wij5p5z8fcywixvahmd1irwci7irj8va32yvhsn4"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.14"; sha256 = "00lalibv06crlixilkdfi15x1n8x18r9g4y3l1flv2ckrvycc40j"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.14"; sha256 = "0vgwsk6vrwh4vgx13alyrnc8ij2197njjjwgk6jdb9ca3jfjmhqs"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.14"; sha256 = "1ai77vk8micf10mwni8l6lsbph0xspbr2fz02119c4jg7lwg4mvq"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.14"; sha256 = "0bwc39ypgih189ai1snhqd0jilqkckzxgq9c7jcgkm88gg7z4hbr"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.14"; sha256 = "1aifsf25a096liaqq7zwlc8vvx5k6ddhjfdjnk023ypjs568331q"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.14"; sha256 = "04n17q4ap1rvf1qp06w511qh2qadabsvgh9cj4b71gipzg38qkqn"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.14"; sha256 = "0wjs88z39swrm88rh2xsm5nx37172v5hyyqvczjx06p4qpr51qmy"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.14"; sha256 = "1qfbzckf6yfykimsdn995wma3gigksr8007h4hjy3zb8sz082liz"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.14"; sha256 = "1xadbj6mgymcrww2lqrski0wgi7mjv9sxwy28j5gkv4y2ihh56id"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.14"; sha256 = "0yp6vwvja267if743hp2aaj8jngxyzja1r7kf3v1hkfbxvl61gyq"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "7.0.14"; sha256 = "16mp3x0q3bilfbc879am9faimi8zdzinffn66wyz6nhgbhx866n2"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "7.0.14"; sha256 = "13x1gvsg1hf9li9mjpzlcjalw8p7mzrxyjb8xaw2xqrs7bj3cp6p"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.14"; sha256 = "172nzwp0xhqd866ij23mgz542pc90b6ciqsk3i3a8dgz3bvipfdf"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.14"; sha256 = "0yp8kcykppcign62fy1r0mfnr250647nwc7fgcbhaqgj4rj4gimh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "7.0.14"; sha256 = "13m9gvzfg0da9z73mqwfznzj0gaygm8fd2bwc9zjdjqgzmxi66yh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "7.0.14"; sha256 = "1wcmqf9r0r8n9v8x8wflpz87n0yjmi8dzffxfh8qspd2rrpzjjrj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "7.0.14"; sha256 = "0p0cmqr1dag8nknqq2iy5whaln3xfq9vj9smi616imniyapzcyr7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "7.0.14"; sha256 = "1dcyk8bwfgmkwkk9vldzwnvdh0r7gfbnk0b2wk8mzybgdscb94b0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "7.0.14"; sha256 = "18y62gi42z26zphbvs670rm56avkahs65qvrvchz7hr8mbdm7sa3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "7.0.14"; sha256 = "1j475isp86l1788fgyxagjaf13sz8haabrfq8mzdgars5jrsl86k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "7.0.14"; sha256 = "1s2r6hpd9p7fm07rcxzr3fyiv744r7b17csz18vi1z2x6px91w0b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "7.0.14"; sha256 = "133wqsr9qvamvgfan9zwjng74hr3s4m3x6f8g83l86nxvxfwwsvx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "7.0.14"; sha256 = "053ignhdfxxw1kqbfkr4dr8ibmyibdv54wvfzfvg1sfvfa366445"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "7.0.14"; sha256 = "02pi0nvbkqs1bib0dajmnss43f1bg20wprfr67vd06b4y34vf7mr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "7.0.14"; sha256 = "05w4yld1gjlasc1k25cxin1vdys52qrad8h68v12bika4x4gxmin"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "7.0.14"; sha256 = "0mwsi1m96j68l9n57hpkb0brqgl5v8gr987mwcknwwir9vx47jpx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "7.0.14"; sha256 = "1idhh33ns1s2f82pn78pn56gr9lpg8v71j3346cnakhbvnmfzagn"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.14"; sha256 = "1hkyd2877bbki78c99qndpb6f3l33r3zkw1nsnk8isj69kp9bxyj"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.14"; sha256 = "0b59s4j34by2hc2ssybq4w6290kg9w7ppl8m3h0ymc8qr5v4b59l"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.14"; sha256 = "13pigd7ymbdp3id1ay7yzdvilmbnhww9xbqah34wrygcbqdv3054"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.14"; sha256 = "1diddcp7zkibg6j0ysmy3q1zjp4zwglp072mill53vbr6fwayyfy"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.14"; sha256 = "160wkzz2xvv0vhfa7m17bafnpjq58z6sifxj0ypr8d7v3mzf2v0x"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.14"; sha256 = "1sidsbr4wcnv6xkzldwc2gmb9qvzsyq0dcdqfwxqq7r1ycywdfsf"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.14"; sha256 = "06h9sq9fwvd5na6snkyga092ixv7fb514hpkpidhra5dma61x046"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.14"; sha256 = "0pr66yi67iv3s1pb7ldc1ip3hihx41l483s72sfam4adrnh010sj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "7.0.14"; sha256 = "0jmjk7jg4ifv9hba4q2f0lqni2a32gsv670ygfqazyy7r17r7l8a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "7.0.14"; sha256 = "0a981fxkxfvcck66xys3xs98vib5jqrwz9kmmvspw8db4kmhwgmn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "7.0.14"; sha256 = "0dhy85hx7vd4qgal3c9qpl8dlw4d267g0a65brpnih87z028c981"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "7.0.14"; sha256 = "1a204pwfrmrbknpf6k6f5al66lm9m8n1b69nya2n4da9rsm9fq32"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "7.0.14"; sha256 = "0vdqb7p3xy1rszs51bsr8rn17681vpa3zmsmwlhvfz6vcn7d9g69"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "7.0.14"; sha256 = "1ypamwbw7rhfap7hsfjqm4piaz0fl5am5jw351i9vdl22fljbni0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "7.0.14"; sha256 = "0x00f97rk63rlhbcnjc6bpwk52rbryrch8c5hkna2xkbxhzr8cp7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "7.0.14"; sha256 = "05v16jy2bijij1rmnx1s302gsbrk807jqmz0igi9fqz7bg6dp6ck"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "7.0.14"; sha256 = "1gg68bvv9098wj58y4375whjj8gzi5da4mi86q727r2a7dcc0phd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "7.0.14"; sha256 = "112al7hnp81lrqhdbsnk6a0yc5gppmj85m9z74xdh5y7pvnk18ly"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.14"; sha256 = "1fikhh8q93x7yn07sc594cz83453d00aqigs2m256p0if512vz2b"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.14"; sha256 = "15x1b63dgn7l6brnb95ry6534xyc8abkghaq7kxf5bnv6jh9n4zh"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.14"; sha256 = "0z8ai3rwdrsfmnq9m1x7w1xsl3kk5dii9bv4ixdhb5jzj3qc50lf"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.14"; sha256 = "12dspbfbmvqc96sfhf79dw068hbiibli6j6hkzcv6p9kb68ic2g0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "7.0.14"; sha256 = "0hmfasvfk1jia3ghci5kip9nf2vjkr8v60php4qaa0yx0nxdf2al"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.14"; sha256 = "0gvh51snh0rn72mhpjfq3l62fh3rjlqrqdxf50q2lil1xmfc7hba"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.14"; sha256 = "1w0swg846wqd8ry1ymmyg683d88jdawdxdl6a6cfy0sr37s9j6gn"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.14"; sha256 = "1hhfc91bi9gnk2malz6ix4cxagsfvj2kkgx84z9xyzw3pxd0g7is"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.14"; sha256 = "1zr7mnyfdvhcwizshbclgd6blk9iwg4gfkh1afii02547qa8xjir"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.14"; sha256 = "0dkjvvnzwv26hxcgp4jfs1ybi3i22x7bdbg06a2bb5aj3sin5sk4"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.14"; sha256 = "0b2bawi3kwymjkrkbahpygqkimjk23r215gvhcc7sylr4snz6alw"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.14"; sha256 = "0xnqcm8k9w4180xc2ji94dnqisvj2mr99syj5ykvv600lp60k31m"; })
    ];
  };
}
