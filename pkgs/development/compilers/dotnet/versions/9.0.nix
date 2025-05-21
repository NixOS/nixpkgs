{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v9.0 (go-live)

let
  packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "9.0.0-rc.1.24452.1"; sha256 = "05idm7kclnb8nw0nwv9wr40sm5fw7wk3zy2khiaiyvwf5c7klbkq"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "9.0.0-rc.1.24452.1"; sha256 = "1pxyk6yblg9y58w4lp9nb1dwwh0yvis4lq8b5w65ikihfyarm844"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-rc.1.24452.1"; sha256 = "1prajkaxj7j0jdf6s52pkmgxi8d8al6h7kvl9viwgqc3jqz2kib6"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "9.0.0-rc.1.24452.1"; sha256 = "02kz3kagy2zq19vxq2rilnnc8lnal4g6l9zzsba3045daij0gp61"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "9.0.0-rc.1.24452.1"; sha256 = "1r8577sjl8bifagq8cz7lx2jzdhhn3r668h313mz7fxwl2bqwv1a"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "9.0.0-rc.1.24452.1"; sha256 = "1bdjl8kh80p3y51yngzvvz2kc9algsg5mx9givyapkcvj465pvhc"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "9.0.0-rc.1.24452.1"; sha256 = "09ispgilx7ss1b43wqcy7c9k1145p622h22vg6z3c0g90i0n2qgw"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "9.0.0-rc.1.24452.1"; sha256 = "1lnz66r42mrxyfjdv5hswwmxv14fikn5p2il512vq0rmqq3fjwg7"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "9.0.0-rc.1.24452.1"; sha256 = "0l3wb3v7grmpipd6p40dajzc574qmffv01g68n5c5qy38fs5kicl"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "9.0.0-rc.1.24452.1"; sha256 = "1091fxvfq9zicgrx9cnk3x7xsg4389qxnj2cbfa6fq96p6rizhi1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "9.0.0-rc.1.24452.1"; sha256 = "16q6865rwblb2jiqvpiasw6fcq1n4h221pi3xgjdc62vkx0k5xd0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "9.0.0-rc.1.24452.1"; sha256 = "01c2ya9wmf7qkpxyjlnlflihxqpi6wrfq4slp3dylyaylypgha45"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "9.0.0-rc.1.24431.7"; sha256 = "01qlklw2y6ci1mm8p4fcx4f7sx4lzx9rbn7d9pn1j85j2bb88rp9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "9.0.0-rc.1.24431.7"; sha256 = "0qidj6b5qymfggpgflg3173jalzmvxz662g9pkj02cd1kbm6qp5a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "9.0.0-rc.1.24431.7"; sha256 = "0x7vfky0ar1i3521xaai20a08j43cg2azdfghxg5dxaa1ynl53j5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "9.0.0-rc.1.24431.7"; sha256 = "1i597rmx8ab3lbl4xkff5vnvkrikpm1zk1vd5b7bk8jyz1ls2wa2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "9.0.0-rc.1.24431.7"; sha256 = "008w5dlmnpc73mxk580l79a84djxnchyw8cjabh8d0255fk6p3a3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "9.0.0-rc.1.24431.7"; sha256 = "1bcfx38p4zqbvqvp3mrjm8yzcbh88i4vwd5af90z1ikfaml6841r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "9.0.0-rc.1.24431.7"; sha256 = "00lhshwp5gj8ckdq276lrjp7025xhmi33vlj1284xhfvbbfam58c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "9.0.0-rc.1.24431.7"; sha256 = "1wqqq09ixbshswx59fq6ignj88izazw1k8sqp2iarxfv0jkv8fng"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "9.0.0-rc.1.24431.7"; sha256 = "07qgqja3c1f62yfi3lqjjsyazp1hlkk41wkpk117b2xm8hw6yx4q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "9.0.0-rc.1.24431.7"; sha256 = "0a0kmkrq99hk6sm690qwam6i0fdgzpx8yiawa6h4ylpazy8jxfxv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "9.0.0-rc.1.24431.7"; sha256 = "0qbaijdf4k3z71820r01z3sib5l7nlr6mjf75gil39yhd9s6slc7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-rc.1.24431.7"; sha256 = "0v56060wm998yy34pdr8cqp8vbc3m97yzsvc50rm6rkhdld44vql"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "9.0.0-rc.1.24431.7"; sha256 = "08afgp9k7nr02jikd5xaim53qiqdn4r556v2sfmgv17mvix7vhmz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "9.0.0-rc.1.24431.7"; sha256 = "1ldmhq12xka64hn327p503m6ji12djkjax9lnr5lcflx527k5i3f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "9.0.0-rc.1.24431.7"; sha256 = "13qk3ppy0ym4x81jwxa0322hlzxhhg6vkb5n0xzyzy5ks8rfqnx0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "9.0.0-rc.1.24431.7"; sha256 = "17f4wkf7pq1c2hacl1z53am96wg5ydq9z0gsdz5zabkyfgs4knin"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "9.0.0-rc.1.24431.7"; sha256 = "1p39yik8xx87xv3jykljxv9jsazkkgcw47ckppzfzadf6967nh2r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "9.0.0-rc.1.24431.7"; sha256 = "0kqw9hnircqdbgpvk4m634nrn4lxj2p40a6qlscsqvw5yq06qvsz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; sha256 = "05y2i9grw8my2kg2svrrmpk2zflvcqidmkyycf58p9a3bmd2xp32"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; sha256 = "00gsj3xwfpsc02rv4h75hrjq140ppr1bjqz5ics9xygj9gqrf40h"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; sha256 = "12vld4zgmlm1s73vn3csss9v81zh53xv0hhw138rrizsl8sxb0x5"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; sha256 = "09yn2lqvij53mv0w4n6fqpxhh15hp3fap1ymjjv4bv11y0gsml22"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; sha256 = "1xvhiswcni1z6czcmra2q25i6ih4pf5crfajgzb6mhvxxambk50x"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; sha256 = "02mlwynhl24avpyvllsgpmnrp6q05a3q5ia34anfs9fjxdbf31yr"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; sha256 = "1gxvgw12g617vj5gki2ag51ll4bxqfffbg5bkqjbnxig4ilh0xmi"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; sha256 = "0v7fmdv74lgybk7bvighf5i1qwhlsb44lmxmkxn6f5ijc7jd1v5a"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; sha256 = "1ql7115ihqqv09qzd23jd4ng7dnhk0vjiy892w2vnlaghkka1klr"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; sha256 = "02v6yklh3kw6xl8aacxjbsijrh0x8654hnjf3aa0qi5ffpng9czh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "9.0.0-rc.1.24431.7"; sha256 = "0bi1vrf5g26gmwv5js7rc4g5anva0m0gsinr7cvqixd2g13jl708"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "9.0.0-rc.1.24431.7"; sha256 = "1r3p996mj6hvl7gi6kffbnmm744i24smlxb9ay8hbkjmagv7pjp2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "9.0.0-rc.1.24431.7"; sha256 = "0llqrym4z3jrqf79hpl7w25vqnhrjsjmywayp5vr4c0y2bjpl3sk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "9.0.0-rc.1.24431.7"; sha256 = "1hqfam3749yy15fyvqza54vvsx883kk0gq9fs2y78idmj0pr4g95"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "9.0.0-rc.1.24431.7"; sha256 = "109f84rqdqj5vl0fxyb7nhq5lil9s1b7l6cv5y8z4gg139dv0z38"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; sha256 = "08qm6yp5swc7zryk5qkkwbsxybn8if6zmrai280bll8ygn932594"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.1.24431.7"; sha256 = "0n5dgj0lhxcjzy8bbzkavz2d3ixf4d1diyq4i6nysgri81kk8wd6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "9.0.0-rc.1.24431.7"; sha256 = "10lr36pv80c31vpzpnl3jxs655xm2d2b1gj26891hzpwp0v1z9l6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "9.0.0-rc.1.24431.7"; sha256 = "07j0samh7jlkjphj2dlkphj0jrhs694qw2md6hr7mpinjr065ji4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "9.0.0-rc.1.24431.7"; sha256 = "0j1nkhmkg3p9n626j04lqr1vv3xnpnzvnhr39j4cn0ixyr7pbfqd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "9.0.0-rc.1.24431.7"; sha256 = "1rq2ixq8r6r29mn2xi31jpck1xicgwg3zjzlvs5zdib8w7rxiznl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "9.0.0-rc.1.24431.7"; sha256 = "11pxn2gwss6s8rmkgzvrljjwndif3pdlpfy0l3y5fbq60rrv6gy9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "9.0.0-rc.1.24431.7"; sha256 = "044j6xkzylzawfjghqr5fkr63k0xhxvs7azmw8pbgh6mprmva4w9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "9.0.0-rc.1.24431.7"; sha256 = "16izyfqy0d2mvjl45z75ymhvjyrk5njrcfv1k7h223b1c1rn8p8d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "9.0.0-rc.1.24431.7"; sha256 = "1fvhwlyvz0fm9cd0pw7l9a64shc565yk47hp873y7dai4lsch03v"; })
      (fetchNuGet { pname = "Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.1.24431.7"; sha256 = "1fnk9q8iplj70jqy490fgg67z6sx5kyblkwd8z730s9yc3jr3919"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.1.24431.7"; sha256 = "0yxnbm7p8s9s1j7rl7cmvg1j6xnxrp64qp4dsi9c5hzn0fxg3jjk"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.1.24431.7"; sha256 = "1lzfk31aq4kfaypbqrzv74vw1pw27576a1yxpdyxls84lmd10dsy"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.1.24431.7"; sha256 = "0cq9i0cfd4gg5vgywf2jvyn8mbqnwjz6gi20x7ij85bad9hanm82"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.1.24431.7"; sha256 = "0zv3brnkvn8v8ml2597vl7z1ydy71j6q7ycjkygy4l0b053870sw"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.1.24431.7"; sha256 = "0vgr2xnskksrnrwlzk0n7qrajwkmz7cyvaifb0jbcx3kyzchxiz7"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.1.24431.7"; sha256 = "0v22m76v8f5kwd5baww7l81ap33jrw4ccsz0lyki3hj2ssmzvr3i"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.1.24431.7"; sha256 = "0x8nafwsh0y0dycdpwjix1rxfkwk25irsqrbzcbqbdx3aas6jpk5"; })
      (fetchNuGet { pname = "Microsoft.NET.ILLink.Tasks"; version = "9.0.0-rc.1.24431.7"; sha256 = "1bbpncqbd2f73n8nznhi2m2i5z8n2hds0ryz616n0nzcc4y3gnkz"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.1.24431.7"; sha256 = "08k1fzwvqyiqik98r0b03f089y4n06p5nfr73688rijgzm55l8zh"; })
  ];
in rec {
  release_9_0 = "9.0.0-rc.1";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.0-rc.1.24452.1";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/da25731f-e296-4e2a-8f2b-0213d26e1799/859039cd012f8cfba53991f8f5543609/aspnetcore-runtime-9.0.0-rc.1.24452.1-linux-x64.tar.gz";
        sha512  = "f8fd285d67bb044d631596869d6301e10a2a243c81c9a05096a66aff4fb3431529812c7482e6cf0e065e8e065fc50b16b50d7f2a495ab30077a68bd45b3ba376";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c5075cd5-2552-4f77-96ce-31450f9ff8d5/e6ff2b52e2a27a60eb3585cbca01d60b/aspnetcore-runtime-9.0.0-rc.1.24452.1-linux-arm64.tar.gz";
        sha512  = "84610a38fb9a98eb7bd26ba89a9c4998682ec3fffb5eade5bbafbafd63cac7d9a5279618bb5b2575d27feec098da5fe6f7150c67253f3f37762601590396e122";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b0414fd7-20f9-4363-9dbf-072880e97b17/89584fa06e9ba1154a7e02402a28d82f/aspnetcore-runtime-9.0.0-rc.1.24452.1-osx-x64.tar.gz";
        sha512  = "ff4a6e35b41f5200521ea4b257b293e4d48f1786ccaa9cd85b55ba96ad36036dbc149d2ff820f1dff5f2d9acf6c38b6c3540e700c2c2db5fe6d82d4f85f461ae";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0bae8dff-9440-4388-a03e-af44e20673a8/8ab257a4963967970cd59c31c213f38d/aspnetcore-runtime-9.0.0-rc.1.24452.1-osx-arm64.tar.gz";
        sha512  = "03f7e03352d1ad2d54e9de4c1cdd7a94c2311bb36d4c6296661fab286cddebf3f57204f73892efd53f43cfb13ba73cafae95d0522c47be03203d5fb69a0ecfe9";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.0-rc.1.24431.7";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/72048153-7c19-4e69-bcf3-22563060db07/cd181715a0f7cd3cec8c87b115181da9/dotnet-runtime-9.0.0-rc.1.24431.7-linux-x64.tar.gz";
        sha512  = "9f9a85b8d9f6362ed2c2d0edefd04999181b2c386647644fbc1d9f248255387324399edb1c40bc7fa8c47adc22e2d71db5f25ce794521d59e46c40593b5f6cc5";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/54f6fb3b-da5b-4a2d-98f4-ae07c814a586/e5f2a5ba551ffe53ea1c2ae9b7681f0b/dotnet-runtime-9.0.0-rc.1.24431.7-linux-arm64.tar.gz";
        sha512  = "8542bb9381e4eca6f0ebceddec68525cc59e34f7244613cf33cb2151f570c3345cb6d081c492b01070e762d3440f02d4558234532d58ff3dc919057e06b7bdac";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/13d7d905-549f-44e8-9062-a678a742c5fb/94c51ca9c08ef9b5cceabafc2337118f/dotnet-runtime-9.0.0-rc.1.24431.7-osx-x64.tar.gz";
        sha512  = "f62f867eab633737c450ffb0543a726f1ba2f46a4265cb47978d88dad0c6b80a8db5ccf6f583842f85cb613b96d2f7c6806d669826f4b92b906e71d8d10e53e8";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8abf3e03-1ab3-40fd-a9cf-fa22005be2e8/cb0c3c5d130ef8ae76a982860fd3606a/dotnet-runtime-9.0.0-rc.1.24431.7-osx-arm64.tar.gz";
        sha512  = "a825fca9edde53ab6abc0efe0c44d6fb25c5c77aeb2d35b6c414d42f364453ceb069ed9db8865c2bb82523989fceb7cccbf86047699590ff756a6b9c54c21d74";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.100-rc.1.24452.12";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3b2b3c23-574b-45d7-b2b0-c67f0e935308/23ed647eb71a8f07414124422c15927d/dotnet-sdk-9.0.100-rc.1.24452.12-linux-x64.tar.gz";
        sha512  = "e8130817b779d0104a6eee33d98d97c3fad1c336013435f47c0e9e22370172b75da37ade76e49dec7cbe696884390d2e6941cc69e2bad5593d6d1c6b41083051";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f7739964-9e84-4bb7-9435-509458a15f9c/a95ad7f9deb8ce2fd30173dfe86f55ba/dotnet-sdk-9.0.100-rc.1.24452.12-linux-arm64.tar.gz";
        sha512  = "f5742537128801c199a127266175066058788a26e8a603cbd26a1c16e9ef33a5d418e4790a3cea722d7de483eee8b68e0de4bb1dfdf279713369ed3b4d163a11";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e26e36f6-746f-462c-8599-5d0a1f00e786/f1b8264ac10442b40009aa8cea46b23b/dotnet-sdk-9.0.100-rc.1.24452.12-osx-x64.tar.gz";
        sha512  = "0d1f0718eeef006c3ecfbefeebf9df0772ec22c74db4bb635b6463b8aedfd3957274b908b51ec019ced69d3e7af4ae9252f18e87b14a4411e1089a4cc41e37d0";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/930f4eb8-188f-47d5-8a26-28ca393b7d1b/c07a519e3d7e326c3f640ef72ea1193e/dotnet-sdk-9.0.100-rc.1.24452.12-osx-arm64.tar.gz";
        sha512  = "af30b31cd937e9fc97e164b83628c2c1ecd21329b75f742d9f5232aa68427d25b5d702cc565aa860d3c738c8727790569bf66a3ed74e5cef719ae589d302846f";
      };
    };
    inherit packages;
  };

  sdk_9_0 = sdk_9_0_1xx;
}
