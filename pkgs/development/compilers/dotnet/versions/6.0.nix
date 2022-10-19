{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v6.0 (lts)
{
  aspnetcore_6_0 = buildAspNetCore {
    inherit icu;
    version = "6.0.10";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7d44ddeb-ad35-41a8-a581-03b151afbd80/6888586c28836b1e1f71df879184550b/aspnetcore-runtime-6.0.10-linux-x64.tar.gz";
        sha512  = "85fd0e7e8bcf371fe3234b46089382fae7418930daec8c5232347c08ebd44542924eaf628264335473467066512df36c3213949e56f0d0dae4cf387f2c5c6d0c";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c37e7250-886d-47e1-840e-fc0ae2aad195/81f019f66f158b7ccb3511d2fa5dec53/aspnetcore-runtime-6.0.10-linux-arm64.tar.gz";
        sha512  = "254796814f5810c416361046aada833a151c946b0dda12d10d1ac792db8528b64eed4bb8195d99081639f22b2114489df0d4bae20da3fe6c63987cafe0349b2d";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/38af6f1b-7b6b-40dc-8f0c-1f2025bea76e/795b0e4dff571fc01702d9cfbad359c0/aspnetcore-runtime-6.0.10-osx-x64.tar.gz";
        sha512  = "9449b3f71813d2af75c3e2439aa22a639140f0c3f58c0e55fd1d66d660a603fb71f9f538d48087c113301d30f373be7aa8683e79af66427d3c70bc1713ae305c";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/49c2a919-5162-4314-9010-a8da201e965e/f346ee2fc7ff046045edcca0778c625c/aspnetcore-runtime-6.0.10-osx-arm64.tar.gz";
        sha512  = "549745d9d41329f12572025317ad40addd00bce64cf15181df5c0c5f5b29c96830397cf97eec315770c8e1b7dfce5909368b213b359f465d679390a0b741a021";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    inherit icu;
    version = "6.0.10";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/48fbc600-8228-424e-aaed-52b7e601c277/c493b8ac4629341f1e5acc4ff515fead/dotnet-runtime-6.0.10-linux-x64.tar.gz";
        sha512  = "8a074c93845416f69f035f2d0e16251dd2bd5abcdfcb7863afd59a5ddc78fa03aede8f79b42c7ca857fc19c8dea53d43da4e4a311f35f6f2eaf9fd64afc8f9e4";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/21bc0b9c-669f-4d59-9e6b-d16d1917afc0/fd3fce1337cef07b2e3763d754becb05/dotnet-runtime-6.0.10-linux-arm64.tar.gz";
        sha512  = "94d182d2d80f3cc9caabbd12e3afeef4af93269a331b64276985496e4a77040785c25b85c58cfc8093f4199e8c6da6de8128157dadfed41c82d991f57df7afdd";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f088e65a-26aa-4da3-a3e5-b4e7e419add8/79a7a79a56eeb08b0646f34952a00091/dotnet-runtime-6.0.10-osx-x64.tar.gz";
        sha512  = "dbd077f32b2fe22a6672f702f42b1f0af963082d9e4f4907d60951b16b70fc9827ba29773728870b1d59c9c538cbf4092fc823641677da96476059dcace57d5c";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f48a8f09-4b5a-40b4-ac4d-197d6ac53038/3cdc2003e07ccf4b22e9bf9a0313a5dc/dotnet-runtime-6.0.10-osx-arm64.tar.gz";
        sha512  = "0b9eef6d820b86b64969de1d45b8201fded72b4a6339883c3f7180c1a97b19e1962cfe8664c7868fd1a20998deba7cb00f8f35f6b2d6ff6d414f1cc4ff2fcf07";
      };
    };
  };

  sdk_6_0 = buildNetSdk {
    inherit icu;
    version = "6.0.402";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d3e46476-4494-41b7-a628-c517794c5a6a/6066215f6c0a18b070e8e6e8b715de0b/dotnet-sdk-6.0.402-linux-x64.tar.gz";
        sha512  = "972c2d9fff6a09ef8f2e6bbaa36ae5869f4f7f509ae5d28c4611532eb34be10c629af98cdf211d86dc4bc6edebb04a2672a97f78c3e0f2ff267017f8c9c59d4e";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/234daf6a-5e12-4fa3-a73b-b12db44a3154/df7c012e5e4e2cc510de9226425dad88/dotnet-sdk-6.0.402-linux-arm64.tar.gz";
        sha512  = "2f5351192e87c2dd196d975e7618bd7b0b542034d0b1bc932fe944d8cbabb0ed2599e98e88d9757e68f198559961ab3350d8eddfacc2951df00fbf6a7e44f244";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/2601dfcb-7d2f-4186-9a08-d121e63a06dd/cd89903b769b1d6e3bdc1e7cd5fcc19a/dotnet-sdk-6.0.402-osx-x64.tar.gz";
        sha512  = "b6cbb3fefdb43282f83f69cf5a7c4cc9f74bf64f1008a4a33368cf9ee1d5fa186e324549005942c1ec48778efc2ba0b33a19b5b802920c84aa636b663697cf6b";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8857cf39-5c46-413c-875b-e091f4b00c9b/19f79f518af3e91ddce328db7f4e1910/dotnet-sdk-6.0.402-osx-arm64.tar.gz";
        sha512  = "e9e73aa815f4af93ba7325c2904c191bb731b5a4048db2529da7b2472f1a140603f22d2a7d4e35b2f301d046388109116af2c9efb33e1ece43fe39cb96b83d48";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.10"; sha256 = "12i4im5jywy06bprfifckkp9f0clyygms97xkmy5m1cjapsbzcb0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.10"; sha256 = "0ry6pcngzdj7b3cw2khj01z6fbam6x6qkvdvcx3dwvgs6ab77207"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.10"; sha256 = "1jlfqh0x19m2pafnr3qw9x2zrfy3pnzfxn4k66hlld51jxhc6v0z"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.10"; sha256 = "0ycx91kd8bzvwzqdzj58s5krqv6dwb9w6xi0gaf99mmg8086rb5f"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.10"; sha256 = "17wjr04wqjnc6cvc7fw4a2m1a27mn51j0hzbw4906x98b1bn2cs0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.10"; sha256 = "174mdikwjda35x63x6rc89mx7knqp3z6g2vb00qxa166vfny70nv"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "6.0.10"; sha256 = "1zjj9yp9frij2zwwqvjqhb09xfampwf5y9winldcbbajf7riw8p7"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.10"; sha256 = "0n62h1kqj419497vpfibf0rixsm6mylxwvbrbmhmzhd1g0w4z1k4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.10"; sha256 = "1ddjwdw6r6zd657f87mr2mkg79x3h8sc0yd3a3ddmhsyma6vr37k"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.10"; sha256 = "0chjqx49w4c80fbs8p4his64ys0lldwzyanlc2808m8n3g7bdg4h"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.10"; sha256 = "15al7gj48b4rm8rkn0kh3b5lmqgqzy9pr10jvcn30rlbn6j1jhsd"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.10"; sha256 = "1x4qpxf5vv99mnkzcv6yjlrfy5lkqyk934f4566sps6xiiq2q27s"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.10"; sha256 = "0ln1724g8lhpljhznflr9xm2xz5plngrsd7l6i0q9zailgywbs3h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.10"; sha256 = "0cf7456qbakq045if42dsd9yxc47svc3gd5dbq3i4na21inyg0ib"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.10"; sha256 = "1k5zyzqhd7jkx34s8fnix5gr6nnc1ppckdibz14ixlhghzjhlp9h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.10"; sha256 = "0fn9asxpjirzvsd6l6v7jq2bxq1a7wn2d6bzc8rln11is3xxlw67"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.10"; sha256 = "0nvddg4lvk2qgwpggbgm1di33b6lcvj722ww5ra2naksznhhbqpp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.10"; sha256 = "06fkh8sbkypccjnp6kxkmkywq6aik5xssrc6910lk7kfiyidri0k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.10"; sha256 = "0kvsm4j3l5ldv8zdwhigfn7yzmlhfm8yhqbvr05j6gvfqjx924vs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "6.0.10"; sha256 = "0gk08p2fg00vl8jm28hmrvm5yvrzk171f9zxbp3fwf3i8az2yxcq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.10"; sha256 = "137i5xl1zcawpvxha4837j6nmkv0ffs3f3693s6v7zlsym23zdqz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.10"; sha256 = "0079z39n0n20kmzsvwg6znjvkh4aailg6a0qqy2dpr8bqqjqbg8k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.10"; sha256 = "0wh6npbflgh1dyxdp9n4dmd5h585maj4sg19dffb5km275bpsmrw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.10"; sha256 = "04lx2hj114wissij56zywcb3f0n9vkm3gsjbdvvz4dqbvmg34mi8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.10"; sha256 = "1h7b172ng7770gabb9h9xb6c0crrbnllsjbwqr7hh1dmffl9r4yc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.10"; sha256 = "1iymv6bxqrwp38pygqq05zkc53brzk3767wkv03gpxmva59qmjc4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.10"; sha256 = "0k9cn8vnjdpip8rrqg30kjsqpmcqycm4ixy1z3ygbn3drf6h96zx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.10"; sha256 = "0csyazxrnsvi200mqh22326idg85qzcfr2xvp3xa9gd04ihs708i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.10"; sha256 = "1glgsfrdw0309x613px0ad7pig6mx4s84pgl8vr8yg6qgfhp9xd6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "6.0.10"; sha256 = "10ry5mnsrp13nvkpc4r34f5yx2lximnns9si56frd5igky4z3nhc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.10"; sha256 = "1s37k7sfk9wnffcms4rh2vmcywzhaywvxkn19bp2vgbb6qsfynra"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.10"; sha256 = "1l3gskn49lggysr7500jyrnfvr1d39x83skx2sccqpql5f31gg5g"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.10"; sha256 = "08nld3092zj8fqwdvnmmaysyjmm6xnw1ixnis2cr770fh2vgnrqc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.10"; sha256 = "1vv0ivfjrvlcrsjpdx3piw5dzjdyw6qa9gfnwswrrf4bglmhjg7i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.10"; sha256 = "0881cil3p9jnfx7gpwkdxz65c5kiapym9f32fpphc7vzfg3jqpgx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.10"; sha256 = "085j91gm8g5smxapa4228k6492yz7yj5g38fdq3pljvw8zknhpwk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.10"; sha256 = "0k8j74qg4mdmk4cwdxdp3vrdwwsmxx7r35mqff4ig1sd4vnqxh2l"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.10"; sha256 = "1b5yl53hrinngms1ry87z1aqv9v68nkiqqqipj4020p41014pga3"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.10"; sha256 = "0hidhhhshsz460h4nyx0h3kcfvck4jx4axf9mv8awbkb1lxvy44p"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.10"; sha256 = "0bi9f2sv2zjkkqyfd7sw7yl0gdkyla6r3f9synzg6nhl8wplnkvm"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.10"; sha256 = "0jdfpipkrdw6d9z035k1ikrq5cxfrnw4fvjxkak00x5c24dalmwk"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.10"; sha256 = "1a6w2gfk0v56hm897w393r4yv4wka1zaxaavj78yy130y6rzvrg0"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.10"; sha256 = "171lskfgrqvgbfm8pbf60mqia9m6v67msxcy5ibkjzcf8n4v1yqf"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.10"; sha256 = "0sjmi4fkbhp7z40l7cjl956vha4428nafzjd7sx7a6yp0jiig9s6"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.10"; sha256 = "0ya56k47xk3gscx025kidnqp4f9hwbzrw680fa2kdvnmjwd9j87d"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.10"; sha256 = "11hac6qqwsrvbrq2r1ixmxqza1w84kdq6wmiq3qd7nsc5jq953zg"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.10"; sha256 = "18vhx34465xbs6ivkafpd1zhz2a81zifkfcdwzw09zfcj023m8hg"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.10"; sha256 = "0cnk3j1vy9sr876jm5l8f2bjxx4fhva9n6g0rv4zly5p21g865fr"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.10"; sha256 = "0z1i89r0dyj6hizx7w6v7dd0rx2wg2ss2jzk9c1ajd93jq19sbf1"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.10"; sha256 = "1vk6dp7syp471kwmf26hk4x35a5x5fp86wgan8gqnlfl2dvx48cf"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.10"; sha256 = "1zyz1brv0ynqi7mvik32lcr4z1fs6gf5hl6nwv7ajz2kgdxpyv1d"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.10"; sha256 = "1dxn703vzaiz42dligk28517z4444mkfjzx52jafxfpxx7dnrg4j"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.10"; sha256 = "1nanrnflwbfvy5b3h3mqq07p19zwc8a7x5qgar8xwadlg933c7jq"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.10"; sha256 = "1dwp3a4qj2wqaxg1ql8asxgqjj5rfw4721x94a4i0xp7kj8ml33j"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.10"; sha256 = "1lay1lkdyb409afs73pq5nj189lbj2agk3icspliv9a67bsy93zd"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.10"; sha256 = "1pyr42lk8l7crissswxscd69vymv9yr3dmzxf93g01ah436j3js5"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.10"; sha256 = "0yg79plw57af4jwpg02d6mi90nhxwhxlrdbpr07m65rqfljcmk3q"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.10"; sha256 = "1k6v0z6i1k25ngrv0xrb0fa6m62ghxnv1xq8k2p7w063b08v5qdb"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.10"; sha256 = "1mcdpdxvlrag4hyl9z0yvbb0a8rmwnvbvn2877466k2zdp00cpam"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.10"; sha256 = "05nygdw5dkl3y3jbvsa5p2lw6s07npz6ac7jvs4sq6h56qi69vic"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.10"; sha256 = "0m4jzs80c3253wqb341k9vcsxsd7kf4cg5aqgpivpl0xl44w506b"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.10"; sha256 = "1j07ibnkvxqqy0wn0xlzib9rx5qv8agznl8z7iplvw73bpka189d"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.10"; sha256 = "0l092p9myf711wdzglrifd1mxvn5kcclcz4spb7n47bazxayk5xm"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.10"; sha256 = "156bnrc9ay7f7xllyh7456nyx9wqn03hasyph1m9z47wg9rfrszb"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.10"; sha256 = "1mjwjj8y0qjgqpmhivpzlx0m2rq1llrdc2crg630mcny6bmxw5aq"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.10"; sha256 = "0hy4sqp66ywhc06s4iviymibia9950n2zjxzqnqgrcq9am10x1nz"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.10"; sha256 = "1297ildclz82aczk92q5raab61g0vaak65yx54w7kg5fd2py9aay"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.10"; sha256 = "18sd8j73ms5488ik9ysg4qdmm2zgqpry3cn8ca5cpbpwqhqk4gbq"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.10"; sha256 = "0lb5v7zf9x2hbcvvv5wc13b85jqjjvza42pqa2v5bpj81qy5zyrl"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.10"; sha256 = "1x47nr7vyrm8jw4ydr7affd92im4m22i35mp2ab4j4zsls9yppcy"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.10"; sha256 = "0993w6b3svwjf0w05v53xb9xzjndmm66zyg2m3rs12i26blisbfc"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.10"; sha256 = "1ygp3nnjzaxi1rgc66xss3071wpyv0363460dv5v5yrc37ip0apy"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.10"; sha256 = "0n0v4fz359c38qm799s3521q5abk114kw6if3ddg4hi4xpny3g9f"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.10"; sha256 = "1mz7ijiv0kcqkhxzmmmaig5h7i1gj24rfi5x76hd4xgj4vvl65lw"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.10"; sha256 = "0jch3ms8khfplvbzn11bl935pqfy9b04qm2w9nfsxl6997pa0aby"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.10"; sha256 = "0k5lb2pqqyigyfj4sya2qiz8mpwfxi1glsf53r84zbh6yyabq8hj"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.10"; sha256 = "1yls6r3rlqik4prcavawprpphzkzbf76bwqx9bb642mbks22gh9a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.10"; sha256 = "1ifwfg8sbpividcfxlg0qaphpk0vis0g3r5w4s0d210j2w4v0gdm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.10"; sha256 = "1nvk7jyb06nl37sw08381g2gha5m01adwshdfz5xsfj5zb3gpv4d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.10"; sha256 = "0qkh04cj8gl6rq4138gvj6r1hwzplwaqpadjyz44ylgmksxz19is"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.10"; sha256 = "1yssdxkaay3zqffaihqsqvx8g89xj8vm7ys1rs951p6g3b2zq8v9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.10"; sha256 = "0mjy93cfm5vfjyx39yixybpvj0xn07agjczfhhycmprbrd208zwn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.10"; sha256 = "07wzx9xqw4lzwsvbvr984s40v9j04hwlzglc6p6w2s30l9h72mhd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.10"; sha256 = "0mimm8apwpyfhi6fvlzpps4gzaf3jf40r72hv9hpnn68h735rs44"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.10"; sha256 = "1371z778w7zzaha4c8w1xygd3qdiw7rdy260pjmhw9dj46jywl67"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.10"; sha256 = "1y5rbqnqz00vw5azhzzbnwi677gsjcs2zvmc5j1v7vn8nwnqpv24"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.10"; sha256 = "1my83z2wmirqh3gnsm3faz60fydw5jcgplybx2qffs59x0qsyv7a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.10"; sha256 = "102xpqvp1allfnvygyvky3vyq2b91i5bfpw6r5shmqmvq6v83299"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.10"; sha256 = "1hg18fcgnnwn89siqmsm07pw7pz1r3dcd7l8hihpf33w1550mcyb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.10"; sha256 = "1wgzcgl4qx2nnfl3x09vac0gj1hi6fdggbzag29n8dgsh52gskz1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.10"; sha256 = "1gdiydnn6p339hgy3sd0kg2smcfxg8axi3l3kfiwmi41y4i9n7i0"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.10"; sha256 = "1ib5cpqk4fa9nskr1c5k2qp25b2j413736b4wvy0av9v6lrszjbw"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.10"; sha256 = "1d3jk2f1mnqv27ih4qipq0c3nh63gwd27d2d1d280rsyf8k7rsl0"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.10"; sha256 = "0kv221vyzf2864spbl95rv30znkvsf8kq5gg3523xijpny74wijv"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.10"; sha256 = "1i6vzk0y48g229jcfgjnry0cg3al3m7c3kvyjprr38grbs2vibsb"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.10"; sha256 = "0fk3yz4zcpfvqx581l828f4d5hlsgilb34ygn029lyn3i8gllgda"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.10"; sha256 = "12qn7y375yppkc8v9jkvv97ihgwz7j9hwphm163i0jd7rafvxrcw"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.10"; sha256 = "1rbn66ns870anjlrghyfpsb6vxk3rqsqzha5f7i2cjrpy0d6qn2i"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.10"; sha256 = "0jlaablf9hzwylmsd5cvzi4p70xnznxsml6xg3cjfcb771hpqr6c"; })
    ];
  };
}
