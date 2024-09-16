{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v9.0 (preview)

let
  packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "9.0.0-preview.7.24406.2"; sha256 = "1jr7mhmjxc1cdxi21isz5g545yzxfv0pjxr1zrjnsfa7vanv8dyy"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "9.0.0-preview.7.24406.2"; sha256 = "16adkc5yc1xd47q0bvg8zyhmyyqy8zli7gi8c1fmigxppyr214jr"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-preview.7.24406.2"; sha256 = "1xqlfafqljnqnqy8524yfw7h17xby0qlqjj5fgb6bpx325v2n8rs"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "9.0.0-preview.7.24406.2"; sha256 = "0mw4l8hb8bhb0hnx6jvz7989602qldsr1hb1xcfhw1d8xismgbii"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "9.0.0-preview.7.24406.2"; sha256 = "17l0nkr6pgr5wi7md5kj0avvr3hgz8b67krccdmpi2x094ircl18"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "9.0.0-preview.7.24406.2"; sha256 = "111n5jhak4lf9c5rdak0nbb6zvxzjvrvhy26k49ar6jg4narp88l"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "9.0.0-preview.7.24406.2"; sha256 = "1bm9xqrmr4qnrsvzdq5w0fi76dndb70b3n9ampkq2gic87kl1cci"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "9.0.0-preview.7.24406.2"; sha256 = "0gvnabw0i6vy3iir3bqwvg1vy93q5ifkpy3ax6vxlfqzf8pxrb9p"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "9.0.0-preview.7.24406.2"; sha256 = "1qhyj7nhj4mjj4hfhmfn7pgfz17h74wzaq5366qz5ibl45xrbi6k"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "9.0.0-preview.7.24406.2"; sha256 = "1vl88ywvl33mn9iz0x1mm8wiq7aviimpb2sjsb55dy53g4k86z4x"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "9.0.0-preview.7.24406.2"; sha256 = "0j183nvfqf4d5sd0cza9zj273j2x744yjzv785d0xchqxlps0n2l"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "9.0.0-preview.7.24406.2"; sha256 = "11iwchmhklaks9wf8df100p0hicwm2in88id4bb9g9syjyc7jg6v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "9.0.0-preview.7.24405.7"; sha256 = "1aw9smdvpr0fx52zk7nr23mi2l5z7v7d6r7ycvldm7bdp44gn2w6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0hn3kpy5wswk7ndgwzjjvnf1w92ss6lcdgy79ackfx7mn7japyw5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0ri5pn0x6rh6g9g2m165c4wlj2hlnchjh9l5jp7q6ccnjaqkp55j"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "1kvwg5c4x849lw6dip9v9fxr3iwk6siwi80lla08jpkysshwjkwn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0kldzbdcg3lhb4adgriq6v875cpq4b43v8nj39lr7s98q9sb5lx4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "1hpvw1nxpinsdihp0n12ap7m66qjbhq95cls7wbg44n6nyd1yaq8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0ax6xw2ikz95nszwwn1ra77inlyzkmdcxcbg95qc0i3clf18d33m"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0apgg5lalz2r3bgvx6sg2pd20mgnyphpgfqw21g9wqq19fyx2kn5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "9.0.0-preview.7.24405.7"; sha256 = "0qnlq06cagbzza3di41pv9mxcl9rqhkclqrdwfy0zwz8k0a9jj7a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "9.0.0-preview.7.24405.7"; sha256 = "025s5mss3jr7cnmsqqnv3spqv11a1240x34pwrbb50j250r7zyr3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "1g7rsqybpaifq5vr00pak029bg6gwyi33mvxkxr2wgawfbkggf34"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "18may21khp4m55d2r4w1j2b4p5wg319c8d9z9x0d9c3qlvv4rjl6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0mnqqz1bwfv8a5c7agcmpr4rckdlllavsv91k387jh2lc5g503cv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "1h3kkqv33mzmng14b3h1fqqh777xck65ifmdzarma1v6r8hqw57n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0kmdivwynf9m4al61kggv7iz6hph2sa2n9v0vyh5hrgls7k401lk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "1zx29hrcfzv01mr37qkm5ax43g2zyd1lslb5smy8mgwyjf4nvhzs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "1cm8ki8hkk7vmjsb7cwi61q30rjc0cjffcn95qzxppvb7rb3393y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "9.0.0-preview.7.24405.7"; sha256 = "02v2dxs355cskcjb80k4vmxdw0g4g5v316h9rp0jmblm8kjvdnhz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "0mb9kvi2whvbd3b2ny1z4cy93z3i6cr0b833dkn2w480hgkcksbn"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "0qlgx6byb3l534k5gw9jhpzcrnldcyix4gd46v3kz8a4g007bxw0"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "0fs86sapdib43p8pza2pb1qzdinvk8vzzh2mxhwia90mlxq9nmm3"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "0rcqhx7kaifcy0k3np3xar2pma8cs16d4626m4wnas0ndd6z4k6n"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "1zn4cam3fkzv8wr52sdrsi1bbqp8z2m1y7vs10s20f9va0k2yl7k"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "1lqs32l1bh74mbiyank4b2lzfvxrrm4ynj0hrlvl80hzrmq06ckm"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "1ah2bfaqcvwdazh4hyaxdjmlkx33kcmc722cblgasc9ybff5x41p"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "0i3kdgglwjq7spsynpvzc3bq9kxaa3b4jzm5zas09icqxvx7jvd5"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "1ayavdmw3883vdpr0lhs0kcav9f7ijnyh5h3m5ky38964bh5km8v"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "03a3b21cx8yyb0d85q2f24sbzqahbyx7nyq08q834372ip8hyxw0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "9.0.0-preview.7.24405.7"; sha256 = "06iphzybm88nf890xficcjqyg5cmdp4jaiad1rikfjqn2g83gdf3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0b4zp49xznypmv0ndh0vm2hnbkdnd0kh2i5gl3mjbmhjmmqbfwc3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "9.0.0-preview.7.24405.7"; sha256 = "0cs2krwqxrv7rdiiqrkvlfk37x6g5j7z6pp6xm149yfs12gkxdrz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0mzdrim92ni6pgki7cslpz3w0f3048r2840bgpirdljbdz61hlyx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "9.0.0-preview.7.24405.7"; sha256 = "1bxzzdsdb0xh63yx2vdns9s6i44nw7z1snqmzhg229v8srcz31md"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "9.0.0-preview.7.24405.7"; sha256 = "1021rjnh4k86s30m50czgnypxxhlsdzldd3rl82915fjkj62wsy2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0x4nm5cz6vqkyxs981y0c19crpbmlh3d70smch5mx3gipd3sy215"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0iaq2bw9mfga0c941vbkrd8lnlhzbvv62nifh2gc2nng19jwnmwl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0fs8kwvfnhhr28lmsxa9rvncxbqi9pl74m8n3lasw413gnad59ix"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "16gw1hrnnfq4i5n0axz1nwx87nns7nsd48albdbp0c6x81rf9h1v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "1kf3hr2bcczx2g55zxa0p0lwfwgaj8hxi58f6alswn9520f46a6c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "162g502facbqh1kzfc6m1n2hbwvxjc247vzy2hq7i1b2ii7qqllg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "9.0.0-preview.7.24405.7"; sha256 = "1wzv5gs7ndiw890b6hc3xa1wmk2657q8dd8jkn10vpfvz1nwm3n1"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "1dfjyi7fbzw0apidc27liy48zqjrgs5m88dz1221wnsnnlb5smc6"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.7.24405.7"; sha256 = "1pyhhj2ypi4308ylq4qpaad95c92lqrp8cif5xi7vzfvakhimmfq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "9.0.0-preview.7.24405.7"; sha256 = "0shpgkbf94mq6nj3q8alrx7iciavm6w5sa3iyvkkm63zgls8ny32"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "1dx8rwyhxq8hnqci835vvs8zbxainp08fq99ij77nzpbi6zqhpc8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0cnk150d4cwcwc1dfnhlyyb6rvjyhl7vrvvi6xby1g5fcvrwni30"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "9.0.0-preview.7.24405.7"; sha256 = "1labhjgjr9zgm632c76a2a7x7p17jzs0xspcbl90mw65bacy125j"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0ijcdszw57mfsacq57q7wmjnknfla5jhcj1xda9zskz7by5yrb1w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "1511lkh212ra48mdkb0glmzs46ha4hyvw4w3amqsnldgv0cg826j"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "9.0.0-preview.7.24405.7"; sha256 = "0riza61a8x3wmpvns95d8lvfqdwlvs6ha7hja4jakxkdpjdq71p6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "9.0.0-preview.7.24405.7"; sha256 = "17kvzypc53k03i65vj0841qhw6zgagpfnags7gjph6pv5drgh6a7"; })
      (fetchNuGet { pname = "Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; sha256 = "011lklbi7ymjybihsfv5d2ldmqk3jwawcgy9119pk4igd4vzvrmd"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; sha256 = "191iam6az00fd1y0r5fvxwj6wc7qm2hwhm2va5f9fkwlhsq2088j"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; sha256 = "174pd1ja3cxxgvbd1hrk2samwmgazx2cjsi6irj2nlrc2vlh2swj"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; sha256 = "0p2cml2avj3qlrwyyiky6ajlbhrb14870xvnj3n4avxp9xb773bp"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; sha256 = "0pf46ym3kgll1vkap8f4syc2d36yfj8sb9596gm0hycv8kd5xrqj"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; sha256 = "1anqzv6qg7i25izxgx081237rlqd8dfvk97cybcyjaazlygjn502"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; sha256 = "0l5xpyibs38yh5ra9q8jl4mzj5mybmfhid1f5p9yhzrsswcp3y8s"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; sha256 = "0pyych7c5j7fhd4f9gsfgkz9ncdsvaj8bp61c755lj1si34aa71l"; })
      (fetchNuGet { pname = "Microsoft.NET.ILLink.Tasks"; version = "9.0.0-preview.7.24405.7"; sha256 = "1l96la9apwnpgbgsbhgkd5v56aysr15x0v26fg0xcw79ms6vgpkc"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.7.24405.7"; sha256 = "1ihwyj3s5rah4q59kgdj21k4varjnc1khahlwf5x76k9smc56908"; })
  ];
in rec {
  release_9_0 = "9.0.0-preview.7";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.0-preview.7.24406.2";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bdb8a419-432c-4f1c-b5ad-ae6e27617b5c/65b26a64e3dda62c456a7a45df73dc1e/aspnetcore-runtime-9.0.0-preview.7.24406.2-linux-x64.tar.gz";
        sha512  = "44f86c407b501a700aaeae2ce95cf544d85c08b41cdd12cee22bfcfdd03c4f6a16e495d9f8315f5e56a66b7e6187a4fc39d899f967a65f73883e40172343275c";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/28370706-3338-4dd5-9992-6cd1d86ba666/354c9434538f587c3198fe57fa0d2e00/aspnetcore-runtime-9.0.0-preview.7.24406.2-linux-arm64.tar.gz";
        sha512  = "706925fde5bb93b98e347540fe0983ce0819a2ca2520ed2d5bfc4515cb6852587a30f29852b512509b660daf8ee76ff3c8bb2d2fd78e47c6ae156e6f00cde918";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d0813855-fdde-47df-8d71-119af034e409/40989f36db96de19bc682d62cbadd8e3/aspnetcore-runtime-9.0.0-preview.7.24406.2-osx-x64.tar.gz";
        sha512  = "0f309d6b849ccec8e13812de9ff70fac5cc78785b71f356fc63e5070296305766892a3dfd74bae9b4775ec4449335d03d046494a416304f56e5ba7746f3316ca";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b2836c76-8c1d-4030-b7f6-0cd5ec1b640b/ea922caf251b0245b96ba2afd7ebb2b4/aspnetcore-runtime-9.0.0-preview.7.24406.2-osx-arm64.tar.gz";
        sha512  = "8200af559c76f5bf12f5e0495c285a837dbe29c7ac2d6c562540f7077aa68fa65dc05205b4b219e72f78d55c20a75a514f6ccf3f53d6ecf34fd2cea0817a7ede";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.0-preview.7.24405.7";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/41a47c9d-c08b-4abe-a2d1-920b51fe16b0/f6af3aa0615cc1625bfc77cd38e16d02/dotnet-runtime-9.0.0-preview.7.24405.7-linux-x64.tar.gz";
        sha512  = "9ede46bc2e6f87a9f592f888562a4cdda6ffa01ca9822f6d4ae586a7c478d3e4fe6c70758a4e9ecbba86445978c68f805d1d6d6f4d37fc653a2b7510309dd5dc";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/248e66b8-594d-4738-8b01-2aa045faf3fd/686e989ba0365848fb4f81f8d780812c/dotnet-runtime-9.0.0-preview.7.24405.7-linux-arm64.tar.gz";
        sha512  = "f7440b679315c6d35b12d839a1cf52c961784d56524f52e96a7834bbda7bf4e5bfd726081148cf71fb19b3107c7b1f39681a2fae7e87f1d9fa0634b70a47f4b2";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/dc29a044-d48d-43cd-a56c-2b8cba456df2/888138574a36ee8c2fe1af2e33c1119d/dotnet-runtime-9.0.0-preview.7.24405.7-osx-x64.tar.gz";
        sha512  = "17352746d1b780272766c6ea20bdb0961f8004bafc529877644fa536bc0e7441eb48d65cd05c4eb9017249651361c773d89b1ec1c1720bd4fce0fe965614d48a";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a71e7742-36b6-4f68-a573-b3437fc53a77/571d8fff000e17abd5d820cafc600b63/dotnet-runtime-9.0.0-preview.7.24405.7-osx-arm64.tar.gz";
        sha512  = "ade75303e39c33af6d7ea10369bb87d5d446619d2ffa630db1e8342b1577efe6831d8f32316fb0e0536e56e0adb7978c4e1b75ddef9a2d1cda8657b8fc457356";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.100-preview.7.24407.12";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/84a39cad-2147-4a3e-b8fd-ec6fca0f80dd/d86fc06f750e758770f5a2237e01f5c5/dotnet-sdk-9.0.100-preview.7.24407.12-linux-x64.tar.gz";
        sha512  = "3bc1bddb8bebbfa9e256487871c3984ebe2c9bc77b644dd25e4660f12c76042f500931135a080a97f265bc4c5504433150bde0a3ca19c3f7ad7127835076fc8e";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9dce0bb1-16ab-4670-9af4-57b6bd1c0c21/ba6055b1ad714158742dd1b2373adaed/dotnet-sdk-9.0.100-preview.7.24407.12-linux-arm64.tar.gz";
        sha512  = "c8ae08858c9ccf16d7b4879b7201ea22bd59e97f1924d4ff2b25079168c906d88a2864e6796244b67db612a36170969fef212879aa3b2232418795c7e7e6d526";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4a7fc24d-481e-4202-8654-06cf5fba0ebd/a4084481acd9aa803ad1ebf3cd668646/dotnet-sdk-9.0.100-preview.7.24407.12-osx-x64.tar.gz";
        sha512  = "b410a65d69f991ea55c81e5f7ea58c98ceef309d63ddd21a7689848a4a4516cdb898f8e36702a554a51fc22420cfbffe7a662a785175bbc1ebe1c33fcf6ffbf8";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/49e6076a-438d-44de-a34d-6ad47af02423/f20bca6b909e3bd42679c14c8288fd0f/dotnet-sdk-9.0.100-preview.7.24407.12-osx-arm64.tar.gz";
        sha512  = "0af77ffeb27e44b2e695caabfa85254f94c77807be6d96fc6abdda1d71be266857320c5dc02d5df968da8963a52cd2aea4b4cad6dfc6540ad26b7b532bf83fd9";
      };
    };
    inherit packages;
  };

  sdk_9_0 = sdk_9_0_1xx;
}
