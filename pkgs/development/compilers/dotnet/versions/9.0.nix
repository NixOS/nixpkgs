{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v9.0 (preview)

let
  packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "9.0.0-preview.4.24267.6"; sha256 = "1mk35a5gq5rl9gmj28qbhq4bpasnarzvv5ahqjj2qg8cvj9pizkg"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "9.0.0-preview.4.24267.6"; sha256 = "0izgyf61gr59zgbxzqlfwkd6by1h7zjksm9y5mgz891m4b6klp71"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-preview.4.24267.6"; sha256 = "1b6dbb5bcxvr40cgqrnmkm6d9bwiy3b7dbfknxsm2dr85bwg6k77"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "9.0.0-preview.4.24267.6"; sha256 = "1fzkp4n1646218i9iqw1cz9sk36wk3s06y7c6lgpml2wxwvkx1vi"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "9.0.0-preview.4.24267.6"; sha256 = "0yknkbjyr6mqjfn8wml6plnkpr3cfcgxa9l4b6ysk9v44x514lh1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "9.0.0-preview.4.24267.6"; sha256 = "1zmzih8276hdk3pr6sqrbdp60z8qzjg1yasviq6jcvbw86jsdpki"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "9.0.0-preview.4.24267.6"; sha256 = "1ffvpw79k306sydlyqi39fchjr7iyl8bkd689vvnqk3y51zq6x30"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "9.0.0-preview.4.24267.6"; sha256 = "0z2vqgkmv41pbqv9s73f1whc995v1pliii7yn1m3jqfmrbjm0mhx"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "9.0.0-preview.4.24267.6"; sha256 = "04ff0iwk09xflmmmmm9vwd87k5gpaqn4xqgr1gfq0kjaf3f38bbw"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "9.0.0-preview.4.24267.6"; sha256 = "1g0kjad0d1drgsm4dqji2fk8npj6grbwsqlqw2xfhjb2v451mssv"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "9.0.0-preview.4.24267.6"; sha256 = "0n4vhg5yzwg7rnly29504inkjp0xygynp29n04wdwxzajwf235gi"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "9.0.0-preview.4.24267.6"; sha256 = "0cygbmv53j9nyy14gxp35a27kbcakvnyzgiyicq6r64n6y4dhdin"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "9.0.0-preview.4.24266.19"; sha256 = "1lskbq8piijz0l80cd4gsplhm4hmqpn432awha0g4qrmk1zlk91x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "9.0.0-preview.4.24266.19"; sha256 = "0aid69wcqyv53nxxvl353j01cfi7l9ywgjxs8q51jkbnd1r499v8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "9.0.0-preview.4.24266.19"; sha256 = "016vdk29s6wgfklr9swbc4c8zba4cyv7f9nh2nbk8c67q3hyqann"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "9.0.0-preview.4.24266.19"; sha256 = "1bffb76snadzpak7z01dxm9ij1ks6xfjg3fc4s1dkfldq4gv3bl4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "9.0.0-preview.4.24266.19"; sha256 = "0jqk8zirqbkxd6dvra7h5alkxx857260d6p13ylw2kwqib5mhym5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "9.0.0-preview.4.24266.19"; sha256 = "04h65p4ckrf4p371jb8zh23p8llc82jyib6rkc9s6nwmz1yfbyvj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "9.0.0-preview.4.24266.19"; sha256 = "089z1g4bw1w78awdpk98h95mdn5j2ngfzryjh0d2s6ypga9r4wib"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "9.0.0-preview.4.24266.19"; sha256 = "0nv1ha9jswpm7ck8ry4g0xdmnssxxiwr13n18yh9645idfdxfjhp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "9.0.0-preview.4.24266.19"; sha256 = "1kch2j544ad5y6akzqpcgidmfrz5yrglw9yblgcaai5d8m6n5sad"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "9.0.0-preview.4.24266.19"; sha256 = "1k6kcbjppxbnv0b205s7i3hjpy9q94q7nvm7ni8zxaw3w6jb9vq0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "9.0.0-preview.4.24266.19"; sha256 = "1c6q5k9bvgr7w5p1908nk7rm68ryzvvdxxb87r06kmr5zwkqrs75"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-preview.4.24266.19"; sha256 = "019vfmirn4asngsays81q0dfnrnlk1mcwbfkvp7p89gqpri8svyp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "9.0.0-preview.4.24266.19"; sha256 = "1d3fr9yn84ib6431k3jhna1iajak2hvkq4jyi3byrlpb7a07hhxm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "9.0.0-preview.4.24266.19"; sha256 = "0l15nnxjsinhccvzp0bziffqs827lbrjk6ivx5lwjn8yj6cgi3y1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "9.0.0-preview.4.24266.19"; sha256 = "1ndga03pksafyprivvib8ma17slmmpk7yfr67n0rg440dzzfv1l2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "9.0.0-preview.4.24266.19"; sha256 = "1cdjh0mc6shs89ai3a713lasmr2bim3r1nrscyqxwhhcca9k9chp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "9.0.0-preview.4.24266.19"; sha256 = "0xga9s2f4xh8c6snlpgyb7w71h1q9xxn1xf1r4mcnzrmlyb3k67j"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "9.0.0-preview.4.24266.19"; sha256 = "0y44nk9jy4pvv7hkrlq0wmzb8r41kmk11ifvjpwh9lvq42ac7knl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.4.24266.19"; sha256 = "1l21vi04yr6f9dw26gmmgch36dp89whl4amrsfn89l3f0qk85ll0"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.4.24266.19"; sha256 = "001zv6cba1pgg5y00nx0pczl3svl0s31xfszar5068kikvqyi4ln"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.4.24266.19"; sha256 = "0n6qvc74qd3w31v32sibl19q37rlfbb5hxsjsiz8kxrjcic280l5"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.4.24266.19"; sha256 = "0whm0c3l91dq2zdh8cqzpnj38lnxcrxdqir994adzgbp67a8r787"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.4.24266.19"; sha256 = "1wsy82wv7vs5g4rx5ak6r7nwbhrdjk1z0svjdnb84xd1kvlqk60a"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.4.24266.19"; sha256 = "0r7n0lbkn3gzxkfr5rs9lj86zzib6ij3sbxq2mjgdgmjs3lldxs8"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.4.24266.19"; sha256 = "06ssvqs6rvzfcj2rvqdhdf2lg5djn2jjzl9jfadkqlci9plf5cbx"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.4.24266.19"; sha256 = "19iglvppa79433676isxhkbcib65mvx7bsx43m91vphp17yai6f4"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.4.24266.19"; sha256 = "0zx8g8hhav0sphrhjqqijh9awybkxgi5q7h00cld5cnf0g7ppjg4"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.4.24266.19"; sha256 = "176vymq9nz41c8g3rcb8d22wm315nz3blww66afl502yx39q0qqr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "9.0.0-preview.4.24266.19"; sha256 = "0ssfhdsdz86d2dpbf3fkzd9020gfbnnj6g83i6dw7h9nrg164lmj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "9.0.0-preview.4.24266.19"; sha256 = "1ni22lfm4c1784hq19qbfjqx8nqpkf4v810qkqjac7nb5lhxch3h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "9.0.0-preview.4.24266.19"; sha256 = "0rc1f7ibvlrwgpyjm3dxnqqxnpwlzyp0b30dm3001rilc4vab6cp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "9.0.0-preview.4.24266.19"; sha256 = "0r0hyq38fpb91rqkvr31490g5ladg5jdb785r6ihybfdf6fx39jx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "9.0.0-preview.4.24266.19"; sha256 = "124rrv9bjvcsgznwyqi7kswr74hjnkag1a4kqvxkg45rhzpry5if"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "9.0.0-preview.4.24266.19"; sha256 = "0l6qkgwfwy4q8w2kbijvxgy4wz87nm83g56amqrjdzsv325sv6n8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "9.0.0-preview.4.24266.19"; sha256 = "1g90ali4yxm4rmb8069k1zbg7w60x8izcm2qawmyggcxyrwi4rmn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "9.0.0-preview.4.24266.19"; sha256 = "0spdpbq357ql7rkzhm5m9c7mcbz12yqq9qy6j199k9n5615b1igl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "9.0.0-preview.4.24266.19"; sha256 = "0426bcfnkd3czshnvk44xiarxibbmzab8lvlk1csl9h0gj1i2lsd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "9.0.0-preview.4.24266.19"; sha256 = "08gphb4pq48qhpwym45j8xd38xd4jn94nqf53ap4kwl6ajinb0kj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "9.0.0-preview.4.24266.19"; sha256 = "12x1j7dyfwb3rvjdkvzip9rilrc3klkj4589n8lr4d736sv8jmd7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "9.0.0-preview.4.24266.19"; sha256 = "10sigmdn5yyah8hp8yd07qi1k7m4s8r20ndnl5fh79kd1slm08cs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "9.0.0-preview.4.24266.19"; sha256 = "1p0spiz588b8wv2rdq65m0l70k62s9g25j346q80dpqqp3gpicvw"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.4.24266.19"; sha256 = "1jb4pps4sg2sb04s8w25nzv17x9hsrnkkgwjcqxc70s59vnva2z8"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.4.24266.19"; sha256 = "14zf89ji0ikp71p9c8ryn51i70v262z3jj3fdjgj27hyrir6mcrv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "9.0.0-preview.4.24266.19"; sha256 = "0c7l5ln186n8v5q5cfnd8dcwk78x8n87slpb0zgk7hci4j00im79"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "9.0.0-preview.4.24266.19"; sha256 = "03g6jcmnzd9f9hzgw8yyvwlbmk5a4lbmi1bjsg8384f69ckiywyh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "9.0.0-preview.4.24266.19"; sha256 = "09v5h6ip89li6b4y58gxjj98m71d4mkshxdm3nh5g91vl0mb5gkl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "9.0.0-preview.4.24266.19"; sha256 = "1qw9ksddn4y8kmf3kl1b4a5bmf86jvbv6yzbqfgmf44m80d6kqgn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "9.0.0-preview.4.24266.19"; sha256 = "0vj734vhq43kc97w87afqnpi0mymj01rfyrwd1cxnkja1csfs3vj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "9.0.0-preview.4.24266.19"; sha256 = "0w70251ril85hk5gyxflmkacy53zscpnnzvj145iz23j3gz392z9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "9.0.0-preview.4.24266.19"; sha256 = "0yh1s8ydnf0h7vyfpbp571pcmk53357x4f2lg277s112nygvq1c2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "9.0.0-preview.4.24266.19"; sha256 = "1q9gizqsyn6viqby3c0f8l4fmv2hiy2kh17g2kbf1krsp6wcxwmv"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.4.24266.19"; sha256 = "0d59q4yc9hbzmpighh9dbpcalrbwwgmzfanvz6sgfr4536pnrb14"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.4.24266.19"; sha256 = "1vza6ylc64pr7ahyh16q8q8ia5q30pm4k02ni9vlb1wcxawmz29c"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.4.24266.19"; sha256 = "03aicxklpi081lm7xnwaii37dfyiy8q9aap77lr92argz5hdf7wk"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.4.24266.19"; sha256 = "0blk1h5gng9nqx5lmidmy9cr3qd80dnlkzrp9fcy3jr3qr11f8aq"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.4.24266.19"; sha256 = "1qrcvby9bq9z3i0an13vmjm33msxalawdv6xr1393nky13zb808j"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.4.24266.19"; sha256 = "0g2hfxa0pdxinffkfcb1nz9qllaraavmrnfyk78gvvysszs441xj"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.4.24266.19"; sha256 = "1a0anv73bw2h5v1mh5h43ixskfh7y8qkgc2bnl7ad3x43ndbnyy0"; })
      (fetchNuGet { pname = "Microsoft.NET.ILLink.Tasks"; version = "9.0.0-preview.4.24266.19"; sha256 = "1h2734krsqjzgid9ha3bcjwbax3cvfvwff35jg01n6ihs9x0d6vb"; })
  ];
in rec {
  release_9_0 = "9.0.0-preview.4";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.0-preview.4.24267.6";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6f889c70-8c50-44d0-9877-0d0376c031ab/d73ca2ec30f5fc3e537b16f37c029daa/aspnetcore-runtime-9.0.0-preview.4.24267.6-linux-x64.tar.gz";
        sha512  = "ee65f640c894ac6e67589c40682b2fc215f2ab7037695589b9f92801073a0f8a8d071c3caf4608679f61e10830f02d21e916107f77b68c58e59b1f191ec8039a";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bc6ae1a6-a98c-446f-8aa9-fe4bdd18412d/569b1a10883293eaa5aae3275d8a4e2f/aspnetcore-runtime-9.0.0-preview.4.24267.6-linux-arm64.tar.gz";
        sha512  = "6f457cfc870a8ea3a8f9e5cbc6b4554dd98c7380ced6f4c6f05bf918545e22937b1c446cc696125e08f964f78dacb2215c0d9e42fdd86ea1c3a4a57af199dac1";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7ccc886e-61cc-475e-9ab4-b1723078e7e4/093617db718ce4669b6a93f2d8934b1f/aspnetcore-runtime-9.0.0-preview.4.24267.6-osx-x64.tar.gz";
        sha512  = "614fc10a69d3c78a1b1478b1d49d1e5d7dcadb02b6edd1ece510b81075e19f6267a53c7252ee4cdba1c5df1353f17ad64a54a08459d3a3a8a4baf707e4bef7f2";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/57b0954f-d550-42af-b1b5-8c9ef5da0d58/a4c7f9677ac41fa3421050bf9822c56a/aspnetcore-runtime-9.0.0-preview.4.24267.6-osx-arm64.tar.gz";
        sha512  = "2440f43ec72f5298679126527af6c1c410cc542a98ab4e0c5aca0ffda40d29b7dc52e1f1aaa869b2d5b86b7bcd80579bada8fe20d0ba9e48a64ea147ed3b4c0c";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.0-preview.4.24266.19";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bd635e31-a279-4078-ac0d-f82ad8940f84/2e9b04bbe40e28507e8483c73eafdd7c/dotnet-runtime-9.0.0-preview.4.24266.19-linux-x64.tar.gz";
        sha512  = "b366a4f19f25281c5b325e737f8c9fe0fa97ca4e19e0e8f00cd42cac84f4134469d02558b07412c66cde62e53f1cb1a7efd68357713ce4d3e816c19ee538e9b6";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/18801fdd-b1f5-4856-8288-c306b11f0f43/5c62f28b9a269b1a840cfb310a9a9f86/dotnet-runtime-9.0.0-preview.4.24266.19-linux-arm64.tar.gz";
        sha512  = "ce8c21b6c854b6772578e84d42e2df5f5144d5a15aff3e6d48953feb1aad517215b6349c20fc22542364a9c439fe19a562f070f88eabf14b5d95ab50fe1ecc00";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6bd91ad7-ac3c-4027-8674-239367730906/007b8c98680c550fb801c34dea28bc9f/dotnet-runtime-9.0.0-preview.4.24266.19-osx-x64.tar.gz";
        sha512  = "9e7364e1448d98df03922bd315f788ce564dfcbec1a9e83c9e1437c22d8d52f72f061750de2f9e149e7662c168b7a781e7450d2c1e8b7f048cb62b360f12d6f6";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c53cab87-a771-422e-be8e-f33a8a6ca637/6e72c3d16f517c6e692572a5cc9546c2/dotnet-runtime-9.0.0-preview.4.24266.19-osx-arm64.tar.gz";
        sha512  = "f9e8188c71ab47631c28d3fb9314b382eec31ae5592a73eaf8c944fcdc240147ac23ef4530a871e9a5deaf311b84ac5b0d5a1f4b6ff22134a8f4eda4555c43a2";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.100-preview.4.24267.66";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/87f2eabb-8ba2-4677-9f91-526672f51857/9ed7fb997d40a369c038269a514fc4e4/dotnet-sdk-9.0.100-preview.4.24267.66-linux-x64.tar.gz";
        sha512  = "28b63633a1e6f4078ccc60218b9f7b6663eb960f0ab1c41069ed8f7f67757fa22ce9f4c04d88b9015c417aad34a7a57986451682bd7aa7b966eda45ace23d283";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/098a764a-8756-47c5-97e9-118431c31b9f/2e1b737cb4750deadb0136283346c7ed/dotnet-sdk-9.0.100-preview.4.24267.66-linux-arm64.tar.gz";
        sha512  = "519d529c74a972484af49ea72053466e09fbfaec0142cd924705dddc117dc40901ac22ddcb11c05caf7b43ef8cf44ec8a0a9dd4c56fbd329b0f750513ae3100c";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c3cee1ac-1bb3-48b0-8a35-813e511d1d41/dbcba8b2e6d28886d07bec53ab509225/dotnet-sdk-9.0.100-preview.4.24267.66-osx-x64.tar.gz";
        sha512  = "da35a51180e75a238b7a4b5d1a5b7e3e33f1a1c179b40957deee98c8e01a9bfade62e2c909d2e5b377f43cf2dc78687b34b349b27b2f8f841165c3c05b3fe443";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e003d2d1-abfd-45f6-aca2-e3f2199e3633/dcefd0cccdfb48a3fbb20b14fd2fe22c/dotnet-sdk-9.0.100-preview.4.24267.66-osx-arm64.tar.gz";
        sha512  = "3791e2134f7cae53c430ae5306f325eecb84058da07d90f276f8d4045701c6c85567472ffc2c535002bb3066817683c0a8e82d23ba6ce32a52f7217867db30d2";
      };
    };
    inherit packages;
  };

  sdk_9_0 = sdk_9_0_1xx;
}
