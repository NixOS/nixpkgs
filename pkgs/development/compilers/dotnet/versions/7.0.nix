{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v7.0 (active)
{
  aspnetcore_7_0 = buildAspNetCore {
    version = "7.0.4";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f2e33ca2-e597-4d7c-b34d-60e47b5fe2fc/a22feac281b4bf63c8b5195a30e6cce1/aspnetcore-runtime-7.0.4-linux-x64.tar.gz";
        sha512  = "b0d2896928c003abf79c539c1c6be13ad560a34d8fdbe9438d916a977aa59e648d0737b57aafb25fda1c3de7c95997eccbea28ae04e4131ebfcd18c36940bcb4";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/639aae36-b8fe-4bb7-86d7-0216554b6183/3b5caffe27bb78bbb10aff729d65ae03/aspnetcore-runtime-7.0.4-linux-arm64.tar.gz";
        sha512  = "5e149ccdd003dfc4413927f23b07b2f27ce915c63146e514b2f88446bd44f64df51755644b56c316b0a1388c873404fc1d39b24a0bf8066f09fc37d6f32cc03f";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/eb055f27-b58f-47db-b291-91a2700396a4/7b313614b3ba0cd2f9e57b288c82f0b7/aspnetcore-runtime-7.0.4-osx-x64.tar.gz";
        sha512  = "36a573380caeac220cd7d4bb1a008f440f37eee21be4c0156b95974739264ed5b3ae1776462a5dee286f387719d3241b57141d2604463d8367038bc718d9178f";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d70d5370-7f1c-4fd9-88cb-504569112323/32a23f276392a1fb04f2f3cdd35f961b/aspnetcore-runtime-7.0.4-osx-arm64.tar.gz";
        sha512  = "07771022448fbda4248ac153d401c11ff0c9cd33ffd9a6c480e7a8618b802e7e33152673557dd92a5467199c275ff8b0fd007e132ed650d594759743d3da7f8d";
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
    version = "7.0.4";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/08c89e27-b593-438e-8303-af765b90e5da/28b1b06748b86a694ac4ddf43d546a32/dotnet-runtime-7.0.4-linux-x64.tar.gz";
        sha512  = "23e6aa3714410d794bd25af781046757003e3326cb8b13dc256649011815038893718b44ec2162767c7da76f1e16b170656d5726e7c01e99b9577682ecfe281e";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/47a77eda-2e32-4106-bc84-375b873a9839/c6d88de403b103248f67f429507ea269/dotnet-runtime-7.0.4-linux-arm64.tar.gz";
        sha512  = "2726dc5a0b7b97c0e1ad22990b31133a1af46cb62d625778a9864a0047462d12ef705eebe08e73514bd10af50c06b5c9714df070f29c5203cf1c2587645d84ce";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e4dd643a-16b8-4f1e-ba38-cdbe32cc24df/67b307accc4abbbc2238310d6ea3c516/dotnet-runtime-7.0.4-osx-x64.tar.gz";
        sha512  = "3042f6c711da88a669c92101ad3f6bd008e475230d68802f52b2748a8db6eecfd2af40665669a3d846910bcaf63ea27277f6a33bb76ec6fb3e256320e2f6dbf0";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bf2d81d2-d793-43c6-af0f-763a48e1fdea/0457d06cc4e7dea7fff49e944691c72e/dotnet-runtime-7.0.4-osx-arm64.tar.gz";
        sha512  = "4451ef94395eba2dfdc1af4b43f619d58fdfdd444fb122ddf1666d6f9002d792a52c52f64940433797920fde680b999095872edc1233c5721994c2092978cc85";
      };
    };
  };

  sdk_7_0 = buildNetSdk {
    version = "7.0.202";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bda88810-e1a6-4cf0-8139-7fd7fe7b2c7a/7a9ffa3e12e5f1c3d8b640e326c1eb14/dotnet-sdk-7.0.202-linux-x64.tar.gz";
        sha512  = "f415a8e6c078421759a963aa0b232c092ecf2f0a8e014ba72092390aac792ed35e8f3c822b2ce91ed636cdee9342bba2b89fb4fdfd2d28dbb0ac856d828cb29f";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c1fd11b0-186a-4aa1-a578-bb1b6613886e/b67e1c9d6d90b1c99b23935273921fa1/dotnet-sdk-7.0.202-linux-arm64.tar.gz";
        sha512  = "6f03de4ef1d0f67bcf8f794beea1a1497c9b1d31c484675382ad63a686ad3047ba2e12b2739ef2bf70c12e61a462ee8abd87e96a7c48200dceab92094144b332";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d3fe9043-0ff4-4584-aacf-1ad41c47407b/7b84ed341359488cd0de21de1b4df6d0/dotnet-sdk-7.0.202-osx-x64.tar.gz";
        sha512  = "3e99224ecb4a6ad06b96daf7017a749dfab1a9059daed1304a35acab9eb4fcb0a97f8e1b4d8c3074536b9dd8dd98dc89db3603057ae59a59e01d459bf26f4fcc";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4402413a-ef81-4732-a0c0-38f11694b226/e205b8bf48d95902a6dbe1c3cccca272/dotnet-sdk-7.0.202-osx-arm64.tar.gz";
        sha512  = "9f5cc528d5d229cf2f63384afa52176f049c8d9e0d9d9be0ccb1a169be78a65a61dba7a4e74357685d434447b3d2697c062e9f240a8d8ad6b588fd433ee67acf";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "7.0.4"; sha256 = "0frxqid2k3ccz5iyijanyqvcdfw6a13igglg6nw8mjn8yl5r5anz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "7.0.4"; sha256 = "14r8zilwl2242n1dlz83wzaqs27g54a96my8m03x2cfdfpzq3l73"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "7.0.4"; sha256 = "0vxh3fgfzlbr3jk00pjl70269x37nb63x7ginih6rrhxql9qjp90"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "7.0.4"; sha256 = "0f746iqqh3qr74j9a1snj91a4q9vb0aikjsckvagydm4fmrisi5s"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "7.0.4"; sha256 = "03dl7fraly0yfx1fkkdcds87vgw60aqaxzr34pqkv26ac9c980sr"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "7.0.4"; sha256 = "1mf4zb7rhbqhnw6bm5nhrgw4ly9bmk1q8vag30rglp9yb9fkd1i2"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "7.0.4"; sha256 = "1ycf9hwd31mcks6vgdhiicimrhjn3s4ddznyziflrdn2dcayxap4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "7.0.4"; sha256 = "170p3q2mjy31vdz43gw8202lz172ja45fzlwz9y3wz9x0cb9sfly"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "7.0.4"; sha256 = "1jz2gafjhhr34q8fk3qi82jd4x480hpgjz8h217ww9yk94qyw548"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "7.0.4"; sha256 = "1wvlpfjqc395amj6dwfv4sm0299s3hcvnv2yrwmllnrqx9zz6kvf"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "7.0.4"; sha256 = "1hldg057gnlxyzsx57bq1wvsjixf6yc18v9slp71c3f0j5qa2ch8"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "7.0.4"; sha256 = "1g7z7sgs89qmj3q2j21g5bbna1ypsryk6b3vgicbg5laqhi2j2hg"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "7.0.4"; sha256 = "0qvwp5dzbhlmfxy8pmvm2qyma24q1nylp2g9mfjxjb87lgxgf3m6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "7.0.4"; sha256 = "00pqnl8rnyasmzjri9pya19k6w3cis7r8hhg0vpigsyw16daaf5c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "7.0.4"; sha256 = "1w4b1priz3cvxb70p1f4qi01qx22vykxq6wcdcgmwmffgvqw2v36"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "7.0.4"; sha256 = "1wyj7mxwlzs49f50rnm89b13yvcz4a86hfsl1pdcafibww2bdzkn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "7.0.4"; sha256 = "1nrfahgj0zgagc1d0hp6pc5prwwdfd72di5w3vn9cpr2kkiy9dfi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "7.0.4"; sha256 = "0pnrj15q3nmc64r052gmx1b4anxy4ighmy8jsgb9zm0pggc0izgp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "7.0.4"; sha256 = "17pfi66zww58inq7irwhyf6vaa5zaxm59p36z0sv3qg1fz1gi19j"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "7.0.4"; sha256 = "1kh8ryb0gj11d1qm51rnwg6d7flh6dki0vgqhfr863mb6kr95cav"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "7.0.4"; sha256 = "1sk3gki48n3slj91k9fgcpa7ijcsqka77y9wnvc3smkh6zkp0rh4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "7.0.4"; sha256 = "12r0cykaj5fj3zahlnwsf9msnf0j0iwmk8b357q4vm3f3farx49c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "7.0.4"; sha256 = "0k46cf73fsn9n0xf815qwyqlblczx5hfavbazcbllv31s58r3873"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "7.0.4"; sha256 = "1zd2sy71b3yzp9jskr968cpk0klbw48aw973pfaxpxn1az8nsncb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "7.0.4"; sha256 = "1782qv428qmn2xxkcbnc2x1szznxlclpy20bn296sn3cly09kzcx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "7.0.4"; sha256 = "05hfz20xnlxxxz2f28cd6250bvlc0myisp7xwklqk3hl4lf1rpkp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "7.0.4"; sha256 = "03v1ld1vmsiamqv8pl7ddbdv1fywsqgfa35qfpi0gvijya416skp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "7.0.4"; sha256 = "1n17qqnc63g0ggc4j76j1irxii4ykjg7pw4zhy95wd63hn8r46c1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "7.0.4"; sha256 = "1fjzqxi6z0mjk75pigf2k975jchxs86zxa8ymg3j8f400qkx8hv5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "7.0.4"; sha256 = "0q3y5cnliixqcj2690msdm49yf4f4w0wnzzfkgwg0x3zsln98aml"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "7.0.4"; sha256 = "sha256-GtMfaHjEzh1CSQWX+R+sWkyx0gy5LPk9Qk5GuU6nxNc="; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "7.0.4"; sha256 = "19l4fvgapfkqc8bx9mp1b195gzsmwcqxc8913xh1y16hg7byha4q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "7.0.4"; sha256 = "0lkwpypzh8z0c4blqx3dd6s5zbrh4d1xwc6dral4jdl8ajmqvhsv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "7.0.4"; sha256 = "1c3blrivlvjx0v4ijf5wli2iby8kx9ckm5ysnqfbqw3x6yfj048w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "7.0.4"; sha256 = "0hzkf49nq149xywpgf0k8yya5krq5wlxxncmslf9sdznahkbv75x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.4"; sha256 = "1vshi2j7vxhl805nr2z1cc0h0dyi3d31nakk70y1zbsl9k0a3zil"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "7.0.4"; sha256 = "1nk336rzmcbg46d9lq71w0r9x5nra69x9vz8ggv6bqk58d6ghrr1"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.4"; sha256 = "1p8aya13an835n6ddgjjhbap4v4xagikfpp3laiq0kxjwwrc3rln"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.4"; sha256 = "1raw3wscfqwxb5sb05sl9hx886j3s9s31i8dgnmyjbcns92413hm"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.4"; sha256 = "0xylj1sr8qqn5zqy0hg4xq23by1fn8kbjrlls4zl695h348b611f"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.4"; sha256 = "1s9m0gmg02zjlnrxylqys5lydj05d7qlha9q2iqyb74aiv32r63c"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.4"; sha256 = "0pfcihbg7yxpw05i2n6cx43y9k1wzyqfqsy12ij1q9ahmzmnxf0j"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.4"; sha256 = "0iks6j0iz6wxghlnzi96jd5kf60g86g15qk887nv8w09c98ydia4"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.4"; sha256 = "02nh00kkijmrbw3815m1jpvj1hz6g1rjhkwd7f73crsaf3q8bqvi"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.4"; sha256 = "0n6c62mzzq19c37ljfr7vl7hx005lc9qs7jc200jb74vmhx0r5n7"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.4"; sha256 = "1ryn34y245fy5hq0mw0c4b0lc35f790kmmym78mmazyvxkla1irc"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.4"; sha256 = "19wy98bbg41rp04sbm0ix8bsl419dqmvz3nv18hc44nk8rn7s5m9"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.4"; sha256 = "1wq1ccqdkbr0j90crs6fixvigqcq4axkwabbfzii2zqszpzj24n5"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.4"; sha256 = "15wzkpcdqmzmzkdn5k35b7zhw6pym4g2kx5w8ydbz5yw9hz4maiq"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.4"; sha256 = "0a60h1rgmg051s2kizsy4hxpjl0ic4av668n71hmzyhrckd6g7ir"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.4"; sha256 = "13yfrfi414gkmddandcm974xpk6gwcxvjl17w8h2wjq9irdv4cdh"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.4"; sha256 = "132lj52hfjm42dyrlcmbkfja7zqnpv5x047q4v36nfk6szcz4d2n"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.4"; sha256 = "1nqcvmvmsaz64b9ml5s605yv6ghv9flvn40h4y8mnpc1md5rm0rp"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.4"; sha256 = "0q51v088sfvw89bwfijkn7da21xq2zpgq8b1i6yirngc91511yha"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.4"; sha256 = "0sg3x7cnrr39pymcylbd1sk2q1x8dn09f94d8i103x5jny2mqzvd"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.4"; sha256 = "0a7rjc5g2x21w755mpgjah3m96cw96lvl3hjisn0667ldc2qkmym"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.4"; sha256 = "1kmd8kjj2ncimnyv9npiddxpbw9b65ga6kv0h4nrvwkv8pfh7xsh"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.4"; sha256 = "05wd92drm5rmazv57bbj27y7nvi70ham9574jm28im1fxblysjcd"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.4"; sha256 = "1ivd1wck702igbvnwppvv64pcgqyvfic0wlhd62pykd62ffi2yp5"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.4"; sha256 = "054jl9819fwzxqv3m69icxq0s1fcsfhalfd116pbzv0zwcynaka6"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.4"; sha256 = "146nnyc027my95fn45yi494hli40dgy1w38akw8n2a784276hbf2"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.4"; sha256 = "0d3p7sznr4axlg0klhf47zhbzapn7km7rbmx5837hdkx1c637j8v"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.4"; sha256 = "0iwj64c01nmcwcqmgc1gcz47wn5anh0dl5vq0n5ihj1shp7f4z8p"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.4"; sha256 = "1c5swz49px7akdlijbcsd6dv2km0xyz7i2p8c5915lf4hni5pzvv"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.4"; sha256 = "0cskh5npdchjqdr30csvzflsh82vwr9zp06816243n0kwixlw36k"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.4"; sha256 = "0xmwf15jp14ydzmk4xf16gcpaddx7pjfyqfaadp86mpcny5jb9w4"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.4"; sha256 = "05pcfnq8gyrkrv970zg75yqnc5nc8gxk9qnx5qx9lrds9jjrp6xf"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.4"; sha256 = "1m7p6gwa66f1f1b0rnwja8w4fjh6kw3xvmvbbcfjqhc869knhx7n"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.4"; sha256 = "02y8h66b92sw88xadih2wgqkmb1ndciwkg231xlnb8sjdzsa7ax6"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.4"; sha256 = "12g23wdsv0k8v97ja873gv20asw1m9k76zj57z9knm0iskgc23yz"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.4"; sha256 = "0m43mmlchpaihfp8chhjgbysfvapbhyx69y194yfh86sj4h5yhkk"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.4"; sha256 = "16ygc2rbjank2psnqyb55r87i9y8prw1r1h0qc696wi1cfwwvs60"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.4"; sha256 = "0hlprdbrs4f9799j8ai4dm5ds73pn97513nxq2gh6n8hvy4dvkxp"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "7.0.4"; sha256 = "1sf08lmm6210bmbbn36qswqdxig1s5mpmikz0bqiljk5nqx4h4lk"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "7.0.4"; sha256 = "0knw2cmph9vjwbpjvgg0mb2lc6phjghjprfk1g9ars10g0amwvc8"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.4"; sha256 = "11l360qg8bjd18nkvzsgn9fvbmgpzj8i5g8rdyaic17rqsyqhlb1"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.4"; sha256 = "010z2117rh9a9zycfqxnnbfwyy42aq3fxfqdd1g2aqnrijyaxz5b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "7.0.4"; sha256 = "0zkl287jycd8v43x2s6zrhl97ww7i0h2lr9jbwgf3vl2p5hph3rq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "7.0.4"; sha256 = "1gv4z67ig2k2fm4529l8k255d36j1795nv42a93z1ljdvm00hxck"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "7.0.4"; sha256 = "0ryc1x9h6vy5vpjxswmy3cycqr61d82zz2ipfxywcqzaisfcga5q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "7.0.4"; sha256 = "0ig02wwn9hvxv8v9mgn220bljfdfpar2cjia257cvg7qrpbkmq4v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "7.0.4"; sha256 = "04hlqhav56p9iwbbf0qmkqq4hfc4dvi4az2xf9clyc472a5drzvd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "7.0.4"; sha256 = "0wcla38nsskgd2fh7knc3d1f9hm2hmgw8254c1hrkni97z1fc59b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "7.0.4"; sha256 = "052ddbl11ldq9h1sp139lbhnsw6ykaw6fmplirvv6hjgfiswb62p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "7.0.4"; sha256 = "06mpp52grwzqw2j5nvcmmnd7kwrgk6d3mca8rfypwfdaa2y532dy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "7.0.4"; sha256 = "sha256-BXCVsf43e/1teOcBPdrS5R/dLns7rsQTRLMQsdbB8BQ="; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "7.0.4"; sha256 = "0kangki5hkq4py7xalvh600nc9n11la4dbb7hkak40472hz4mzsz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "7.0.4"; sha256 = "1lzia5py84ksr9i24vm6c31cd5vq5qdbc7m81kmxybbwnlj0nl96"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "7.0.4"; sha256 = "06vszg959k3qib181qxz5q8w4v9di2a2ksvmf9wxgxc8lp285fbz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "7.0.4"; sha256 = "1a642v302cldbvgdygbzix6cj9b6rb9g3iadsaxdsnjhpc9xmmyl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "7.0.4"; sha256 = "1ihl8airysgz4y289ynbnbc4zy4rrckcq4n2c3gf4d33ghh3sq2v"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.4"; sha256 = "0ihw34gp8d2q3wc1vg34pk7p94xll4mib88csv4h9kqynpayfjdr"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.4"; sha256 = "1a1p3r7d7m7441zdvms6g86i5lsfxwkw1rzi6f3kp6av41xrmz07"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.4"; sha256 = "194fj00ksr5pjy2disnxgk4nwyb8cx00dsgq1mrvvm3qvwvw0nlb"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.4"; sha256 = "0gc527gmj7da24880gg3lbxgff7551jbqkzwk9dwvc8b4kvw7b72"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.4"; sha256 = "0095zjp2f2i06ybdm68x7b6ymxk70d1gyrkmwk31k5xv5f4wzh8v"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.4"; sha256 = "01parlmhjdgs5xsg9x87743l5nd6pyprvf9a6y2w0zsj00ijv36s"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.4"; sha256 = "1sky1i97zphj0b2j3b9sbsq22qqs2wlv7ri92cqf4rmp6j8nzxjp"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.4"; sha256 = "1683262zb7wsigjsyb87dyz9rflsmr5p3nlg1nqkshgdl11z8h2c"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.4"; sha256 = "18231pjsfgb62x2ciwz8vdq195firbhha1v4k3w7115d94vqf8nb"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.4"; sha256 = "11liny45arxmlxss93hv58mnx3shqsnh1qdw76kl5hmh7x4cgh73"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.4"; sha256 = "1r5qngcrk6d8h3sivz04mlyly61pzb5z84bjbrgspyvnzqg4dnnj"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.4"; sha256 = "15i5agj7zj026mqni4dbfwfyhglx0kjkqdfl1qnmg5xgyihbj76q"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.4"; sha256 = "03k8045r8br5wyhinq3spriy81gav3157cvh8hb31f651lprz5ij"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.4"; sha256 = "1am7sahsajrlmgp4rj1d79v1ncgaa94b2cw68jhmkx5za7hcssmp"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.4"; sha256 = "1kax8b4l3sxna6lgazzazzfagxawhjm0dhpymdmh9p76ghm101x4"; })
    ];
  };
}
