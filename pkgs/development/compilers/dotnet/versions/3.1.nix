{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v3.1 (maintenance)
{
  aspnetcore_3_1 = buildAspNetCore {
    inherit icu;
    version = "3.1.30";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/12f61df9-e5d2-4cc2-b992-80d30ee3fc43/0087f4e0b8b3a94effa890ee3ebba0b1/aspnetcore-runtime-3.1.30-linux-x64.tar.gz";
        sha512  = "afae1f5ab022b81636a0d6fe3956d491c3f28206f8177787013f309841dcb9f1134b33677a9cf3fd68a5c86cff7fcb0694eb597dc99a96dacd704e89120375a7";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4e1115da-a8e7-41b3-a5e7-54d8d0bf516f/e81152a855fa9ba69fa59c741fb4ef77/aspnetcore-runtime-3.1.30-linux-arm64.tar.gz";
        sha512  = "327116926ed9d4a86664c6d3687d59261353639b67beafa8d451d8546eb800804ace64d40a05e14db5dc6ec638fc041efbd209ee58430fb539d02799c1a33c55";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/095f69b9-439e-4d3c-9927-c0bac5924730/f1d0b61643ae84745cf23de375eed37b/aspnetcore-runtime-3.1.30-osx-x64.tar.gz";
        sha512  = "dd02798cff8ceea809789532584e104a8e06addbd7327cc35a2b220bee3ae92f8a8172d69208604682153131a4fc158fe860f2d4c62b1aaa120e832a4801cbe3";
      };
    };
  };

  runtime_3_1 = buildNetRuntime {
    inherit icu;
    version = "3.1.30";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9f6128a8-3962-4018-b9b0-9608b9aecec8/f46a672e0117d9128acdbc82cc314e20/dotnet-runtime-3.1.30-linux-x64.tar.gz";
        sha512  = "febe026170101a4fd033a37395215c408fd0764786157c2cb70dc2ac8fd2f41e9e8659c3f8f9a034190b70df056ce9809abf083f59dded73d4cd5253dd0bac57";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5400dc4c-6b15-4cab-b8cd-7ed7ea6f87bf/a409c6dbf2c866217cfc1ef4c449e30b/dotnet-runtime-3.1.30-linux-arm64.tar.gz";
        sha512  = "e94b4f9dc1bae62f2577f5c6dada8ae111936eeb535010afb4d838c993b372be7dda2dfd84caf9e86d6b6a688757c63c18b73b547934023f058e5d75b099a912";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9e891fa6-2faf-42ef-8331-dbffe526de7f/7b4b639d7bd08587ce0d0a2b90b6196e/dotnet-runtime-3.1.30-osx-x64.tar.gz";
        sha512  = "43b8f60e9b963a673e0fdd4122a9b36ef54bacdcce7c396a61a99a969e18908bf63c4b092c0661d7ff17fbb138ee68b9d046c2c6e22886d3908c94cc08c35976";
      };
    };
  };

  sdk_3_1 = buildNetSdk {
    inherit icu;
    version = "3.1.424";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/28fd6fc0-f484-43d0-90cf-5e297a784e44/09c0612bb1cc46378546dfbdfd83014e/dotnet-sdk-3.1.424-linux-x64.tar.gz";
        sha512  = "5f9fc353eb826c99952582a27b31c495a9cffae544fbb9b52752d2ff9ca0563876bbeab6dc8fe04366c23c783a82d080914ebc1f0c8d6d20c4f48983c303bf18";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/dfe62f78-d4c1-4190-9d9d-44249e83a0c5/1fb0e84fb45e4e5d3207de6db85d99c3/dotnet-sdk-3.1.424-linux-arm64.tar.gz";
        sha512  = "3bfd29233a3e0dfdbdc967f07808d4e239651f0f4f23f7c9e74f09271c9ded8044539ea4278bad070504ad782c4638a493bd9026ddbc97bbc657c5c12c27ccd2";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/32689e88-7340-47c7-8a67-d8e19a38c618/89d4815dfcc0c611cb0c599d0cefc71a/dotnet-sdk-3.1.424-osx-x64.tar.gz";
        sha512  = "3e6bf0116afd20828c5b1420e70b5840df029f144ed7cfe8c133b02f43d7b2a5d17566e1815f166179f51299768d73bce43740f9862ac8384f2c8bd06e1b8d09";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "3.1.30"; sha256 = "0m7kwk8nl9d6698y9598x3bp57m5gb6l7lc5mhws0sgd3ky1awgp"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "3.1.30"; sha256 = "1c9jr2pag5adwdz6j1b2jb8w47271zd2xzfqs3hiivrj4nh35l1g"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "3.1.30"; sha256 = "0jmgyl0kks2ichma2zbaj1x4j4bj20jn636z8vd1n46dlszas0gp"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "3.1.30"; sha256 = "0jgvzh8vzx4x6bx9xbd1h936p1kzr8pva9di4qwcwc8f7rb4wsjw"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "3.1.30"; sha256 = "156f18l9nk357slcfygdsy02xdvlgys0h6z94y8f2vs09vv7ifx1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "3.1.30"; sha256 = "0j65fw8j3bzbj0f36yvr2l75j05zd22491w0aalhls950r6qzgzj"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "3.1.30"; sha256 = "1a3240apw4c8kz6xpy6749h2iks6fw9lcxzca53jx8c876grm5fx"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "3.1.30"; sha256 = "1s3w2lqhs7lcdqdhjdyh66cb0gpbi0qj3zln9l0g0zcl6imlrcf2"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "3.1.30"; sha256 = "0q650j7bp0f3aqsdw6imvdkbxwvad2lridwxd87xw3i1mn56gk1n"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "3.1.30"; sha256 = "0a6jz0larf8dasqfhi51lgfk94nc7ak1nvvhf8mpfrwfb1nqigcq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "3.1.30"; sha256 = "1zwsywsmpv1zc9wm4p46wvhsw2qx3imwnr3rky1p7mbb8azrjqxl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "3.1.30"; sha256 = "1v687i04v3xa1by0011qhb32i6rr6ibidsgyx21s1mwblzh6kibd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "3.1.30"; sha256 = "1qc3ghz737hbrrkb5cpjiz6cvm5nwylaz5jnkxy2i7i9gwaagjjl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "3.1.30"; sha256 = "1mzkbg5x8flgc2kvhdli6i2mxd9nifv8axf5g9kvg4qmj61i0ddc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "3.1.30"; sha256 = "0rsn6mrkvpg82089i8f7wkzhb57vzyrz502s2sfl5yknhnf40sx9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "3.1.30"; sha256 = "1fm9z02y15y64kswn2khc5gb428bm27i5jsdmap333q1ai712ba7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "3.1.30"; sha256 = "0dykzasg077zwzimc6r7j1df8awnjksfssir1a1dlh2wxbch5x67"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "3.1.30"; sha256 = "104xr70jx28j45l43mq8smr3ndjcvyfl77jw9pzs8phfc30fh0sx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "3.1.30"; sha256 = "1c8s21gh3igxw0wsnw1zx41d8winfy0l5f9l33mgm87l8bkdld5p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "3.1.30"; sha256 = "1n7az6x692aw6ng1pank1snm1r1s4v2cx20bchz2anbp68yi6g07"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "3.1.30"; sha256 = "0fnlipf0n677p8cfm503ywr59cchl9jf8044ndyr1j55zdbzlq2k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "3.1.30"; sha256 = "16vjwadxwvg109f6q816dni09r3i77g9z32x4m4nn6bahb6bm1lr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "3.1.30"; sha256 = "13ij3qycqvapnc70a8g1grd7c9jv7ps0r96cb7lvyfvz2yb5x1w7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "3.1.30"; sha256 = "0fhj8s8z4khxkvicabhbs9ilrwn3v73xp12zlm3ba9pi4nnlja8s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "3.1.30"; sha256 = "0b0zxdviryp6gl7nik3mivx9wq6xmwrk9vbbjw0fnjwwmiy5ms6z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "3.1.30"; sha256 = "1vxd0n05ai00rxzcxnix9w6wqxxdadscamqkxhy79pj8n782gp0b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "3.1.30"; sha256 = "1lrm0sa030i5cqggl0n89q5a878qiilgpp8in6z4p7fwkhama7yl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "3.1.30"; sha256 = "0bapgpqm1n7wasffr5qb2rk01xi0j51xfg4dhjk0f9zv080lrv52"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "3.1.30"; sha256 = "0qhzz0g6ymlrdx27w0a87caa44fcvi2nq8glgb2x6lphpwm78q7c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "3.1.30"; sha256 = "1379znk80lkvrlqrnxp6r4b6487pn575d1kw6p250av22qxwx8vy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "3.1.30"; sha256 = "1vwmkxxjvbi3sk219lg9ha8vxv6gnn9pqs4nlmzdd03p9pafphvb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "3.1.30"; sha256 = "0h6isr6kwf70cyn75dkn59bwzizmbvmlpsr8rqa4vxank28f6zaz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.30"; sha256 = "0j1bm6f4m8l4qi65yf0kjq5zb28mx02q3xqsmy6jqqkwvqp2n5cw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "3.1.30"; sha256 = "0glsj3hs22h4jhpd3cx0jr1qzf8akjdqqjb5sb1k0a5zzk2f59r3"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.30"; sha256 = "14fzkyzb6wdk2j6jzsr7ilnlwrlyybx8cf7b4lf9whj98rlch7lf"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "3.1.30"; sha256 = "0ag0nmwpwh1pjmc32b7i6pdsvmgrjg09ns175s5hik9gcl77016j"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.30"; sha256 = "1h0mhj1qp76hb59sx4hhlc5x4m8hhqpcl0lza2czdwp9ki1zyvpm"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.30"; sha256 = "1i7nqxz6f23xph734ylaa7zwaa4xj2hfg50q1dfr6ia8ywnkcnz4"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "3.1.30"; sha256 = "06ch8vaysrls4k8ainpinww3i46y63p98qhy0i01f3by59iz52gw"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "3.1.30"; sha256 = "1vwcffg9627l6j7bfgrvkzxwf44lbwk86yfnh6z0hgjx50f4gmx3"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.30"; sha256 = "0myr6yzjadih70wf4hbqxr94cppnx877825hfqc7pjhpxkj0hslr"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.30"; sha256 = "051rngyjkk835fq50f336pcvh02ya3hs1drcrz20iic3l4akbj5y"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.30"; sha256 = "0hhfizvmxj011pdwsb7837z8cxd4knm4lmq63m3zg6xackbmacvn"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "3.1.30"; sha256 = "1sjkgpiwbg39vypvk2yldkxpjdbn0mwnsk7mwcdpq4g5294v0ag9"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.30"; sha256 = "1hcf4a79ngfjy8dv9bpha9m50j3disyfrd5qmgjkrwwkvp8l1qgc"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.30"; sha256 = "081hqdj3qwa3bijlxizr8988nsf3mkd4xl4x8rxbi3z68d4d0yiq"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.30"; sha256 = "0r1hq4psfjs9zh19hiz03dcx7bxbc8fyv3jc4cgy5czdl0diyhq8"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "3.1.30"; sha256 = "13gzg16zmaq9n2dqllksi68dfvary72rdqs95aq4zargji59h4xl"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.30"; sha256 = "0565lxbq9jz8n4z0q5pfbibfwixv1nqnhv8d8k5zm4xqxyxrrsi4"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.30"; sha256 = "06f66vwwbav8pvm1kylfhvvzq7kjs888wycsv49cl9h48bzygll9"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.30"; sha256 = "1lxh2gw6rc80g458cbfcvwr38xa012q5pgvr464qjcx902p1z9gj"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "3.1.30"; sha256 = "10x928nmvsvsm30ma6jps5wz42hyfvih71ch1sbjhymxcgyqc2rq"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.30"; sha256 = "0q7sv59f44bsyjc1sg4c7s587d1k9slk09gf6fh06zl1xqyrdi1f"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.30"; sha256 = "0q9g8p8jwscvc1l3l944dscgvmxgxprjv138gjvw1ykg8q6hhqb3"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.30"; sha256 = "1gnc1dlc4lnnqbna3pzp7a1zrrvbv13hj4pxvncb92aid1dznri3"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "3.1.30"; sha256 = "1gy39l2nixwby853sk8ng9cc17lc3msw0ap937v7wkqqvgkvrzgx"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.30"; sha256 = "168szn1y403vzzc3fg3a79aqfzsxxyxl8sarfllk2f6hcqn1piaf"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.30"; sha256 = "0s742k62nll49r7xmzq7fng6dzqgzvgqx7hqgby77kq2a6cv0735"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.30"; sha256 = "1zpdzbvmxfqv2zps86fxa350bj2y2vjydy2gwm6ghdq5yn3jg7y5"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "3.1.30"; sha256 = "0vygl1iicns07862ch8yxv2z6nsv31ndwcn2qz8qp52xsy6qbfgh"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.30"; sha256 = "02zfw7gzk309avrpkj00ykg7by37f594fwmkgkycd0iz1xy2l4xd"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.30"; sha256 = "12aq86vfjkwvxk81lnd77v2h4ndjpi21mkyagg01pdfhixbapdq2"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "3.1.30"; sha256 = "1fp1jr9l9fhr0vmw98j45r1b4xbxhds55r09lmd3hx0wamxa7qxz"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "3.1.30"; sha256 = "149vmmcc7v0xf78qkipch84v00lywgf0dwgqw3ghl1rpqndqq3wa"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.30"; sha256 = "1f6924670aw19hmw209iagjfny5p3kpi95z3j3crd0jkk2bgxv90"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.30"; sha256 = "1wg52hjh95yjnd1fk2mnlyl66dhcqr3f8lqi699sq7fk8ffbs2az"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.30"; sha256 = "0g5pbvw63c48djybdpq638hgr421c5b1bjfk2c0c0ic8aw3qajh3"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "3.1.30"; sha256 = "196hcvpb5xw97589f45xb4wa3pzmzhxhw9flgaiifp4z97xjfnp6"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.30"; sha256 = "0grh28f4w854i8pxmcslwknwz6wxs9v31i6dnzlrz2m6f2rqgrnk"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.30"; sha256 = "0nqr5ws3jqniv7s9np91gnyvl2n3334sky7i8p1v71r5ypp4p5kd"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "3.1.30"; sha256 = "16fwvp6c04x3p05flwvnwa8najginhyxn9q57ml4pfya7b879nb9"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "3.1.30"; sha256 = "1v3qki82flkpxmxml2n4a91mjz2x107rf4zcidslpf09ym95rv36"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.30"; sha256 = "0wf7l5kp5njpszk6xrkbh4kr13rdvdfiblqrhdx0xqyzxmi36g2h"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.30"; sha256 = "108iv13yh640gjx7hvwb2617cn71rgkl7g953mniwpdhisaikz43"; })
    ];
  };
}
