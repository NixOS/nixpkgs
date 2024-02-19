{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v6.0 (active)
{
  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.27";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d3e6b8a2-f7de-441e-a3af-c18b7584034b/9f15be4d095b7bbb751222b4d68a17e3/aspnetcore-runtime-6.0.27-linux-x64.tar.gz";
        sha512  = "47495e387c63b10f3b52065f40738d58b5b60d260d23cff96fe6beeb290f2f329a538c8065443fa3b10ecbd3456bdae58e443118870e7b5774210caf07c3f688";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6be3e44e-1306-422b-845c-9313589bbeb0/d76f133799f6b2c8e3ea7dc9d92b7a03/aspnetcore-runtime-6.0.27-linux-arm64.tar.gz";
        sha512  = "cafb52efb2bb646459c3d133a6968105867bbe0ef580318def47ff83770e1f180431f53c5a7899563b5c8d7fe44a58d423c8c7a4b3f29054010230fb47b1fa89";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9c3628c1-8221-48e4-aff1-a3eb23bc42f0/4c6717fec81aa31dbc290af683087304/aspnetcore-runtime-6.0.27-osx-x64.tar.gz";
        sha512  = "4cf70618e2f01401a26b05fd287867ba9b23498629d87bd61d3418a0d5191c0e07a16090e149e759072b00ee9860a4cf7260e6bf36e2d10ee19d0d4c2a39a5e2";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7127ff28-48c8-4f40-bd34-be86a2098a67/afad61df9e45650c995b92dd10d2167c/aspnetcore-runtime-6.0.27-osx-arm64.tar.gz";
        sha512  = "1cc3d27ca26edbc30f24ea918a44414f0098481c6ad5ed5f19a5db1c1ea1ec3c412804233cc3e7aea481aee351be4512b40c554fd5b1807204a9dc22a479b9ba";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.27";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b4f214ee-a287-4640-991c-de80de4111d9/2672dee679fc3627949e8efdfff71e6d/dotnet-runtime-6.0.27-linux-x64.tar.gz";
        sha512  = "448c4419e6c5b52e82eebaaf8601bbe668a0c8bb3293a6004125c7305b38072f7d2236ebffcaf4a71901b61b22ce66ae8b077af6321ba14729be385f228be04c";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/559c4240-f5e3-4d3a-a361-99c07c7cad11/a00adbf8edb12c3646ebf57bce84d1c6/dotnet-runtime-6.0.27-linux-arm64.tar.gz";
        sha512  = "2e9772089ca8d548201d02542ba2013506530183ea6f52e8907afa608662ae967579add6d9704b75c22f2639667ef87682a7ce92aff05d51670e9354e52df1ee";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/54b2f9c4-2c1a-4fdf-9054-f295d3ae24f2/bafc4747c493d32bbeab6a5dc3cef4a5/dotnet-runtime-6.0.27-osx-x64.tar.gz";
        sha512  = "c15275726882d2cbbfe8e76b05a9dd6e6764a5889c54b2e40eefd057e39f4c44c2da0909b890e27f463b47b08755a8b83657b6f67c77a460e3009554e85b4942";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ac022bcb-1ccc-4e7d-8b96-6d0379bec761/3ac011081768ec18387dee520e42c540/dotnet-runtime-6.0.27-osx-arm64.tar.gz";
        sha512  = "5394fb21a6c4748ccf12c47c3774ad3a193ab3dec263161bc90522bf3b2de3dd65c0102a33a9c946c2b88588fc1d6083ee4c9c683d173d7f371a98ad78591705";
      };
    };
  };

  sdk_6_0 = buildNetSdk {
    version = "6.0.419";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8828b97b-7bfd-4b1b-a646-e55bddc0d7ad/e2f7d168ad273e78fbae72ffb6d215d3/dotnet-sdk-6.0.419-linux-x64.tar.gz";
        sha512  = "155a9ab33dc11a76502c24b94dbcd188b06e51f56814082f6570fd923cd74b0266baefbcb6becdd34e41c3979f5b21ca333a7fa57f0e41e5435d28e8815d1641";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3b18aefa-0e14-4193-a167-35e1de4cfe46/acf2b230ae3ecfbc4d5f4c20cbf97b2d/dotnet-sdk-6.0.419-linux-arm64.tar.gz";
        sha512  = "c249e5c1d15f040e2e4ce444328ec30dd1097984b1b0c4d48d1beb61c7e35d06f133509500ee63ded86a420e569920809b587ff2abe073da3d8f10d4a03a9d15";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f9e10850-734b-4267-8fd4-27a8e0f83cb9/1ac81544781feb8717c584d991f831c3/dotnet-sdk-6.0.419-osx-x64.tar.gz";
        sha512  = "43d9ee7f63131138b9a8aed10ca6797256c029168a07c340ff7a5b2fb43ebf62efcb62a4bcfe669de2b57749223d89028e68bb45e9dfbc0d5341ad5f1bd0516d";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c4bdba21-86ac-4c0b-8d65-c26459e115ee/8fcb7e012eda317486ad00d095cddba4/dotnet-sdk-6.0.419-osx-arm64.tar.gz";
        sha512  = "9db6455c2bad80f8c8b312630c77700fd845203ba20cb7022671cf6a22b1663a1742e47eed7a384142a1d58388d8d736b4868efc5ce80b205c949e4ed5d71fe9";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.27"; sha256 = "0i70y4jznmwx4yak570mcpy8sg3myrxk32p0183d06614q8vr9bf"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.27"; sha256 = "078vz7l3sw25jxkhxf646hwc1csasna4n04rjq6vcv30c9kx3lp9"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.27"; sha256 = "13jaasca9yn89wn1pm007dmlfjvxf1h9m7wqi1ngjggbxd2cahlg"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.27"; sha256 = "0zqsh0kcnch9n9sg59iqwm5ws1bjg2vh3swlwjppw7fi6xw2w753"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.27"; sha256 = "0cdvdbvvbky0y60732j2n2jjycgpm2ngx38hl6zq198xm1d4g43x"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.27"; sha256 = "0r7qqwkqm9lraqwc25aadbg856v006h17yj8cxmp800iz7288k07"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.27"; sha256 = "15f1p32gkb05xlkv4vl2vnbj6q81r0x65cbyzinxacx736xr1wqm"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.27"; sha256 = "01ghqfpcpf54vw5rj81zjmhl4mrnq1lcwhdzr78wys0pjzdmic8b"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.27"; sha256 = "014m4kz2fx8xqjhyqj01x59y14wb2q6v6n723in3vrvj1a32a69f"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "6.0.27"; sha256 = "1pxpndm99k8cbaxfxwnw0qhsaz84hwkla1q8fd02ym98iqijanm2"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.27"; sha256 = "11sfm0vb8grybwdfzl9y3y1v9jg94rn3fpsf0995xm1qgk57piiv"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.27"; sha256 = "1b6jyx86dv6p2iwc6n2cyjfp11z6nw8x2vm03rdgy2lq7h9jyg7i"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.27"; sha256 = "11l2a80xxinf08m9i6jdy0nkjpdjs9llqb8gs7x0762cnyhds7la"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.27"; sha256 = "1qcbvhg6r7j407q9y5i0srprccpfwww153xrajipk6v3fwykk9rw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.27"; sha256 = "0p0apwm7xpwwvjl453livb8ngvc0izjp5yfpgv116vhig2mxszsa"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.27"; sha256 = "02fl061bfdxcb7md4v1xra0c6pfvsy9x6s05pz28km71p96qyykg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.27"; sha256 = "1ifbyf6rd834k5dzcfxdds2gacg3w3qb1gh1df5xb4262g68ryl6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.27"; sha256 = "1vglh2l7brp6qbdngiiwsjwsp3cyzbzjcjw7dwqhfk0whc7n96kg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.27"; sha256 = "1kf3sm7hkqz5a4y5rb49yna10041f1h3lcqx885xlbhyb4q67gi9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.27"; sha256 = "100557k9hhbldm670fs3p0wx51r0i57i1p3m1jxrhpp07n5rnmax"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.27"; sha256 = "1d217mgqcxkfq3kyxi46rqbfcwswxi1rhm512av99cp4g4i5w2lg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.27"; sha256 = "1pml11hgqmfy21hscracmmvi8y031jdwv89zs4hpiicxangvss9l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.27"; sha256 = "00jl8jxhn9dxii2xf5lmssb03b2kwjsadxw1jwiniwv7l5lkma40"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.27"; sha256 = "1dxvssf7rx05bipj03g8jm36j2mmdm13sg8rdwn6aa6whbwpip0r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.27"; sha256 = "11sy3bp7xzimicns0l8i0ivhvvxdvxbh5virglfhwckpfhz7iydr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.27"; sha256 = "0b4ydsyi5a85vg5awgblblzhk49z8y64n7wqdkgidjq3g97qlvpg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.27"; sha256 = "1j913pm78h35kvcm70276cnfvjn1r7r6jsc3jm1y0vb395qy6nfd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.27"; sha256 = "0dr1y76wgkqnkjxk5m8ps2g086sn4kp3a04v0ynarw5j0cipg994"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.27"; sha256 = "1ig2q3galhs866572nqa2b0vfw91lshaj502w3p5pqy28hvl74m9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.27"; sha256 = "1mwzhgfi98hy65j8f0qwr9f134nfc33ddnj36b050222q4iv66na"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.27"; sha256 = "04dz9a8ddb7cm1mvl9plhsgznvzbq4wgy8dyg8jxvw1zgqa1gikw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.27"; sha256 = "0nhmrbrvll5vqnk6gl8s0kgyg9zfdsmdbxphj0jd9lf096xwahrp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.27"; sha256 = "0xlkc54w9xr3a9xsmkyhk2qjfy9lrirq1xxhl1599ql1yaiph9rk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.27"; sha256 = "1mj57llnfhasnzm9mmgsz8j76bqrkvqw28dzxp007c5qv9dd9jvq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.27"; sha256 = "01x6zj8q3h1ddbsr2idj6acmnxh59bzb1f393fxplknm3naf1da6"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.27"; sha256 = "04si4x3jc24p4nx3bgy7d246k6hyfcp2pzvbwy40p2v4cdcd7x06"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.27"; sha256 = "0k3df5b2aqkhq59apygcji4i9d4k0wjnppsn0hlkqm9pxidgca4r"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.27"; sha256 = "15i0j8rx6n80bpix8x5vxcqpxdhbciib3n22klj0nb5gfhqnd7wj"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.27"; sha256 = "0l9hx0yjw1s7ngcwg9ad18lyd00hhnf12f3sk0mddhixzxljn6f5"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.27"; sha256 = "0y793pg5y7n1gc7w95yd7slakfb8yplzjx186r2ifrad4p7qpd47"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.27"; sha256 = "12xabxnpw1c24psqdd6gi8w7vqvid7p43pc7l2wcjnzggjsqz3wb"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.27"; sha256 = "1xv0kcp6ym5xsw3vkwaz457z0id3k6pyi39z6c20yr6g0cvc9rbc"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.27"; sha256 = "0a80hs753mzzyfab6xl11jdb5kajszrhhxxpi1c6v3ppgi7vggyn"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.27"; sha256 = "0h60p0nz2zpw1r4dcw41v8qh14r48gb0i77ggjqsspnw2xni18x3"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.27"; sha256 = "16kp9g1y4y4zgz9ddcjik27cgsb7ywivyynlkzbnmzgn24hwgyk1"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.27"; sha256 = "1d855rhk8qv4fpzm683ri888s66v43kg6sqxflz4bz405s2a5ysx"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.27"; sha256 = "153rxl7i7grl46mskfsnhhr7v7b5j7m42awr7v0d0c19qx6f5vaw"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.27"; sha256 = "1pn50973cjm1qravx0sqb88k7rc7rgzar0gjlm6cwwgy93ds5bdl"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.27"; sha256 = "04az07rqpiffwdgn90ifxka09wgabgh99bayl8kil595akaqxigz"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.27"; sha256 = "1nsg2pqz51ahgb75gfrqwbvxi49q9q742k40pqslwbwraspjl2nf"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.27"; sha256 = "0z9217d2sfh8984haf064bqa81w4bcia0c3gdf39rjv8ilq664ag"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.27"; sha256 = "1hma20dbppvzqwpfb50lkrdx8g007ix29h6hrimi6382y8v4vg6j"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.27"; sha256 = "14l9dckj8q8rsbpcw6gjl905wrpr1w6rk76gxnxccvxjc28pb66a"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.27"; sha256 = "04131710bvi5qg5qabbw54q34dsr9mg0xfxv6r15nlri31mi8rl5"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.27"; sha256 = "0kh1ri99gndvrbnxqzpd3xlwjdjxdydamgjd5zbplbjsj16z4zlz"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.27"; sha256 = "0sns0j30ppcj9ivz8nlxalxiak28gabb9p98gfnnyhp7izk4yzkr"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.27"; sha256 = "1c7r1fjzkc76ls0qm3kilrq0wgygvyzynlx02r19295f3r601c8k"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.27"; sha256 = "0bicffp7ijvdjiqci924jadf5jka5ddrbzrci46pjxnhrcpgb7vl"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.27"; sha256 = "11dbh0yv0bxnvl713c9awf6hvz8z7xgll7xhawad4a4gv9vz9y87"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.27"; sha256 = "1qdfyyqgr7bfh2bsz27qx4dm1m0cr12bb0x94gvr6wgjyk22hy8k"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.27"; sha256 = "0c7chsjv4rwb1xyk8m0mf9z7csv1j4bpj10v3z5dqzzb7kk90zii"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.27"; sha256 = "1kvlhhwzklbwqz3vvhyi4xkapsl2xw14iincxb050vqzrrwwynrv"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.27"; sha256 = "0f6qyjnnvql2qgqqwf7nm616klhgbnb1w5145nrayzs1z142q6d6"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.27"; sha256 = "0dy3is2dzpwkybqinaa6mm7y9vblqf4bn090pbssshcq6yvqxjph"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.27"; sha256 = "08yx368a44qjr2npjqs66pn3h79chzxmhy10yxjb6szk497mhqsj"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.27"; sha256 = "0j6hpcprib6y6nga3bm2nkq3w6n8y58vzzgxwd3kaaj25b73wqa9"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.27"; sha256 = "1xkaq7bknnjahn3ds3n9iqs8ibzd3k2274sk4366zkprlz5q5n1z"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.27"; sha256 = "1ggc83318n3l5x4vi9p7vqzi9qvvyp8z3lrah9ynw7rp2kiz4094"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.27"; sha256 = "0ih4wdq31g12zxx8799rgzi2wbrsprfsy65042k7vm605rz3f5y8"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.27"; sha256 = "1mpi59an3nifc52dnfgi20fsbc4dbps11l22an59g0gnr3dzd0j8"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.27"; sha256 = "1jv1kaq4r3bqg51r4gvf2d9d079w2c5yq4np0qrib73v824gxp8z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.27"; sha256 = "1i60hm288jaynx9cpgcvhb5spjbvspn8yr583qwyrrfm7hnfybr4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.27"; sha256 = "14zd7mgl866bhqqrcb6q3xbwrllks1nmfzhnbm8rf7h5cqqrqwbn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.27"; sha256 = "0cysxz3ak4wgdb8ba3ggpbdqm4nn0c0wm37gx6cxnqrrz359289h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.27"; sha256 = "1mbjbj9c7sxw0hfq25ypv56hi9kik3vrrvr8ika3wcwv1ilpvczj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.27"; sha256 = "15fwbjq2r406fq175j2lsh4f91iiipmvaq96nsba3q2fh0c433zm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.27"; sha256 = "18hdnp0r5z177fap9qwwwm4lmnv1vcg35k079j11g9d0935916la"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.27"; sha256 = "139hpnq1calf7hgpilkdpzzmzdrbx4fz8svn3y4q1ivgajqzpzj7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.27"; sha256 = "1dmdzmjncjnga8r606g2pcszh3sqlhfgjz8dp62v5i07327l65yl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.27"; sha256 = "0dyjkrvqald4dyabw5a4zvqdn7hz4x37ifjlc16h146vwqmlxrcm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.27"; sha256 = "0bswzvdy8nfd3wraja226j200a7qkpk3shs70hc3kwpr98bf92xv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.27"; sha256 = "072yfx28hynv3hx0jrd47js77k7xlxx55x4yw1cjdzk24x3a2kln"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.27"; sha256 = "0xks0gvjlz4c0ys75yc1a0aivrb49yzvwq2ks06adwp1763h0lnc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.27"; sha256 = "0fw86pzq30iblbqfm2y45r920fhp59ars3sdcn4f2kz9p2xkgd57"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.27"; sha256 = "16fdjdy1lb82llxpsxf98zm2w3r0my46ddgdri7f93q7wwdhiqpn"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.27"; sha256 = "1h82yr6mxjdgsl32mx0pzxlicxknf1sahzbbhmx7xl8fvlxw4f5n"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.27"; sha256 = "0rn1l75ry5k1ph6ykwp3jh5nffvfyd3wv0hnrzrrhp86fpppf45f"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.27"; sha256 = "076g4fwfxfa5b57b9zfwfriw761in9lzjasgk252f9gzx01za6x3"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.27"; sha256 = "0pg2p7499b378gv41c85vkb86kfb4vrhhbsgzcc1w3726f58qsfk"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.27"; sha256 = "0azr1zxg4wl6hz8pyrsrgjjhvrlvc3lzs9ww08vdcvqcjccd8p46"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.27"; sha256 = "1z1hhlqdaikdsh8a20xdpkwivdl3qca656xxx2ldzsg5zfrspyf5"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.27"; sha256 = "0hh92l077fzgwjyy9b1v8vphcqrh0prlrjhvx7siq75ibpqyvk2l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "6.0.27"; sha256 = "0wa03db8292s91sffzwscb07kvkg8zfy645mbflcvi3mi6pk3w66"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "6.0.27"; sha256 = "0hbq38dldjdwny12qy0cs3f68af2d2r5g1niwn8rjw1c4hdjaci6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "6.0.27"; sha256 = "082pf381ayhrwy805w995x55jls3wpgmgqxzsnd63ij8q9l7j6bq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "6.0.27"; sha256 = "14lv78j411q5496lv6nw29ivlnf88882v7264zr2pfvrasms3i0j"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "6.0.27"; sha256 = "1r8g35f2x25nyimd3yrhrm2cbdqcdljmw59jy3mqsjz9h7kcj68h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "6.0.27"; sha256 = "1a2rzh4005lpwv9sdzrvjdr89q0jjh5vg3h6zd008db5hj637hbn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "6.0.27"; sha256 = "14b4nz7qf1rkbr2jrrhhay10qqv8jiz71rq5iymabik16m92664p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "6.0.27"; sha256 = "0v397sn3z136y8dh3q5g1361sxmq15acsv3x86dxhn9rkxj50md8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "6.0.27"; sha256 = "0ra8kr1xkk89lvy9ggkp25dc6l9z0zqi23hfwwqlyy9sc1fhwmwn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "6.0.27"; sha256 = "04q8c0z44iqg3nx2nxc104al1hnmszk2hdirmjnhkm3ilqm8fhx7"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.27"; sha256 = "0ly1m46dm5zfxnjcbd8fv99mnlnzfw8mnlzw59ii7izixixm5a97"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.27"; sha256 = "1f55c522angyng8rd31hwjjyj1vkmxbzvl6nkfqsr8wwzlv7hgpv"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.27"; sha256 = "1s070v08j0vylcdpl6l59p0g5rrkqpbc10c4y16id1g6qfnpgq7w"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.27"; sha256 = "09d8c6mp1d9g3fgdbccvh3z75qc8mnrl1767p2ym2p0c6vin4893"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.27"; sha256 = "1zkmnz2a70ki50j7apgxk7q9b7x9qqcgn04pkdcaya1ig64h53cc"; })
    ];
  };
}
