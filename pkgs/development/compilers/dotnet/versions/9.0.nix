{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v9.0 (preview)

let
  packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "9.0.0-preview.6.24328.4"; sha256 = "1f48vfy1r5c40swlf44ippd2zhpy7mgpk08yisvn62yslf9wqqin"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "9.0.0-preview.6.24328.4"; sha256 = "1ay99zj073hj5wcy7igzmr6mi106rscqhbqp3d9agx61j899ysnd"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-preview.6.24328.4"; sha256 = "04pmm083fnq3yzxr5fm9ygfvfvqvvhdlr00rcgmd73223bs4xr8d"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "9.0.0-preview.6.24328.4"; sha256 = "023m314504r08b0bqc7amzksmh0abk42mwvlzaxfv3qk85zs7cw6"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "9.0.0-preview.6.24328.4"; sha256 = "0caqwqr8drbpvmmkgb6k57qgh9wyn38nxdqz8a0skcgahy6pq9m2"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "9.0.0-preview.6.24328.4"; sha256 = "1v556hjhar64vz133q2lqw62b1jdn9iiicdqsvgqk0r5jqm8jdr4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "9.0.0-preview.6.24328.4"; sha256 = "10hdf27nchw6hard88wxq4hngnix4iwqnxi38lpiykgh0vlh49nh"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "9.0.0-preview.6.24328.4"; sha256 = "0phwx3chh6sikq1sms9dwrf256g8n635cjvizp7q2xw7l6b0p340"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "9.0.0-preview.6.24328.4"; sha256 = "069n01fvpq82hyfz9wrr5cv0l35ngs1dayh25nzq5irk8qhjiqjc"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "9.0.0-preview.6.24328.4"; sha256 = "00k2kdk94x36lwhi2i3pvxzg5ry6xi3z5b3bs49b79hfj1vggf9g"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "9.0.0-preview.6.24328.4"; sha256 = "1nzcjv16pilfvplcqyxnr42vmq70kzaih2756gjkqph6yivqcday"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "9.0.0-preview.6.24328.4"; sha256 = "0jhh0bxrh05102c638vpsjn0fm4hjnkkb2l7j7q5f30gim94w6bm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "9.0.0-preview.6.24327.7"; sha256 = "0571v4nn1fxx9mvp0qx8h80qblk6v37y4pr17k18kkcn3jvadig7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "9.0.0-preview.6.24327.7"; sha256 = "0i1az3knmh7cn1cz56s0ggplfmaga6a5fki2p1hxalxc6by1f819"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "9.0.0-preview.6.24327.7"; sha256 = "07jc58k33wfq9999f0m64k6hccjnri27zpzpwyjdkrwgxxc9rdfg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "9.0.0-preview.6.24327.7"; sha256 = "1jgml4ixy6qkjlc4rk5dncjxfranxr0xv8qikwdplllksarn2bvi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "9.0.0-preview.6.24327.7"; sha256 = "0mxjv98kxjamrl8y8hl9adskczhwk33l8k36v1lfn4w9lfqxrjmf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "9.0.0-preview.6.24327.7"; sha256 = "0kvprnbrymkyp4yg8vrrsackys7fc56ngqbf112mvwi56gacc2cy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "9.0.0-preview.6.24327.7"; sha256 = "1jbc2zxgasdk9vbjh8bb8s4i5kqbgpfklijcqy8ig3af01k8pw67"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "9.0.0-preview.6.24327.7"; sha256 = "1clzwsm180ki0cr5wp1i958phdarnv69zdqxp1bn2wqgd77rkrw6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "9.0.0-preview.6.24327.7"; sha256 = "0dx35jbbdkdbd0377ldgcncwix6857x1kqmn930sj2597z292m0v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "9.0.0-preview.6.24327.7"; sha256 = "1wm6vc3k4jkq1vxxvw3wq9k1b84azq8v2zazscpc44vksiisdxc0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "9.0.0-preview.6.24327.7"; sha256 = "18zkm3mqr7464h0qmn5ighjf2gpfrpyg85cmrdr9jqknz1qd08qx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-preview.6.24327.7"; sha256 = "034ncg45k07v7qfkbw6y8y3n9wzgkhy6gq000if2v71j45kdsa6c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "9.0.0-preview.6.24327.7"; sha256 = "07c1wnbki98sl472z32zhgkhdfzvf1qhhhmdfsfk41qxa6yz56xp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "9.0.0-preview.6.24327.7"; sha256 = "0pn4nx36w1prkg1kjjlhsx3iyqd19n4wiqzd8ck2k92z3l5397d7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "9.0.0-preview.6.24327.7"; sha256 = "0v0sg0sdkjisg7j540bs48ylyaw0yypmnijv4qp4h42hsdgk213w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "9.0.0-preview.6.24327.7"; sha256 = "02hwd80ikxbwikadmiwrybdv5ybp64sbbwkn4kfn7nqvw3q70yh0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "9.0.0-preview.6.24327.7"; sha256 = "1j0v5p9w7d9h1cl43ys29qh601zqw4nh5z827xyi0mqn69dz086s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "9.0.0-preview.6.24327.7"; sha256 = "1v2xidnjq70ivprdqf365kjdi1wm27dh7jgmlmjwrj65zbkkrp8n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.6.24327.7"; sha256 = "016snk92jhgdixmv1nms2qqlx5myr1cj8qmxcm8851scv1k1hl7g"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.6.24327.7"; sha256 = "0m4jc8v22byj1r2fn9mh7sv5hn1ygrw8njazfffqcn90pv0gs5xf"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.6.24327.7"; sha256 = "1cp05rqz5bgw0h7vxf1gzwpmjbglrmwx8q9crn8mykvq0lmgwqim"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.6.24327.7"; sha256 = "1wld5vlag0rhi82f2h6hkkx4w5m5wpc5zpn70zyd0k17kg79iaqj"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.6.24327.7"; sha256 = "0n45l47iy12d49igzangz2ljbij52frvsxfniji5lzx40d97jkji"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.6.24327.7"; sha256 = "17g6qsaiazn001y5qhngmii0mfjlh2wj372g8682alxblgbb5zcm"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.6.24327.7"; sha256 = "1pmzakkq1ckhfsqb1a1s10gfj75nfkii2axwhb0rkyh1gm99iib2"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.6.24327.7"; sha256 = "1in2g348vacz1n59h2ivi9b4kh8fqlrbplg4hpajamz9az16dxlp"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.6.24327.7"; sha256 = "0n8w7lq4xd7vj9rvd4nb7c7vzjmzsl6rcad3gmqzrlkf7chp80s8"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.6.24327.7"; sha256 = "0ryyx1g8rb1fr3j3vxwww3fbfi4dpilddaq8nssa7pzcxbd7fwj7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "9.0.0-preview.6.24327.7"; sha256 = "1hw84f1n8imsy7xijmblwxpmzig11aphqn74dn7cjggdc6rhbjcw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "9.0.0-preview.6.24327.7"; sha256 = "0ypfvrl9dgsxkk36aixzk8n0kbwa766pihly46aq21rz2dwcnskw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "9.0.0-preview.6.24327.7"; sha256 = "19i9rih610mynm7d5b1kx6vdyynmx3853sz7ky69yg2ppyin4xy5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "9.0.0-preview.6.24327.7"; sha256 = "0gfqkjvalws82474wqd672xxpf0lhwq18vdxjpxm50fj1nl8sa35"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "9.0.0-preview.6.24327.7"; sha256 = "08w7j5qs6nh7aa2nfslkmj4avbl4aqwh0z0r4qs309rlpa5q4i7l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "9.0.0-preview.6.24327.7"; sha256 = "0c1g6sb50gg69fs8jhclal3izkf9xrzhi4bhi0l6w3df1nx0m6mv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "9.0.0-preview.6.24327.7"; sha256 = "1crp6qd0la8qmk1iks3s9n2mhml4474w4pr26ahmpp50j0dxv8cx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "9.0.0-preview.6.24327.7"; sha256 = "0cd3838jm19q6izzp7vzi10hjsjsn31l579zz49hnnlpqxssnkd1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "9.0.0-preview.6.24327.7"; sha256 = "1xgivx8s3z03mqh6bwi8aapshzf9h7n5108k1adiff4xsvqbz7q7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "9.0.0-preview.6.24327.7"; sha256 = "0fnyk76w1fwwz9iscwqjxigpyslibm56fbxlbffpwmdaibhwrpx3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "9.0.0-preview.6.24327.7"; sha256 = "08899x6by57wdgzbxs9sgajvn0cqjs2hqn70y3yisykgf3pis67c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "9.0.0-preview.6.24327.7"; sha256 = "01aml04jlslzxfmh8zhv1agapwm6cy57mb5v1iaqivrczny0c9kf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "9.0.0-preview.6.24327.7"; sha256 = "1j2m1hhimd85mm1nxz2qd4vswlxpx37a1kw2haa5w9dmn6wkahr3"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.6.24327.7"; sha256 = "033cjqzpph7rfhf4pv04xla5xbdz84416rdbra9na520apz2lsfx"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.6.24327.7"; sha256 = "1h5cv3vi9mzm41dmncdn9v78n3ihiyyvgsrw974xqspw9j6pmcwh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "9.0.0-preview.6.24327.7"; sha256 = "0x7rady0vb8lazb0kxn2yyp5f4kylg76xb1ha8pmgd0wkc6k00s0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "9.0.0-preview.6.24327.7"; sha256 = "1apmjwkvdvpfq56wmlm7140ffqjykfwr0vz5c3ji6ps19gw7flp6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "9.0.0-preview.6.24327.7"; sha256 = "0anp07fypi7ah4g15p73bw3fmgpnq2cczws9r2s9hshx51kdn5ld"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "9.0.0-preview.6.24327.7"; sha256 = "1qggl537v0kfd1nv14jbiqks2l7khzm937gc72a1vpcjlvv217xj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "9.0.0-preview.6.24327.7"; sha256 = "06wibvavjggqldaifz26ykj6rk3wigxcm4gc8j75kxh5nd20ymra"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "9.0.0-preview.6.24327.7"; sha256 = "0p3aff8018arm0rrkhbdqwbcz6mc70zvld068alr8r3rpaj2xrqk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "9.0.0-preview.6.24327.7"; sha256 = "1gyr83lwzb0s327jjk26whcys45gkk7cgk2gc0p1rpaahxpb9ryc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "9.0.0-preview.6.24327.7"; sha256 = "1zwg4q8crmk1ldrdf3n2r3z0jrdgcyfcm9l1wl5x9nkn2f65r334"; })
      (fetchNuGet { pname = "Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.6.24327.7"; sha256 = "0jq5k1gn9ni5sxcnr3xsr7ns9pyicc529v60nwdfsv4343majshb"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.6.24327.7"; sha256 = "1zcapqvghq17zb2z1f38p7lblkf34m3nl5jqza0rjppvkqg0wcrr"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.6.24327.7"; sha256 = "1fwr4lk7a6pwpa6qhy1lnbkn3r81x9rishp43hpdzhra6ks6fma8"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.6.24327.7"; sha256 = "0rlcmp2h9dxh76a59aq91cxlrz558c04l5xf4yfgg2c5hihqpgbq"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.6.24327.7"; sha256 = "1rxlkz33095yk593r8mr4cx9883q9pfwj4w36lgim9kkqnv6cmb1"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.6.24327.7"; sha256 = "0gvcfa2w7zdd35fnkjch9mn0zysz6jjnmmv2ibwng84xjma5104v"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.6.24327.7"; sha256 = "18k4frx0vwsnm6wypcdiijvaa45gav3cjq8drirb01m5kaghn7ks"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.6.24327.7"; sha256 = "0s6pq4zbgmzp30zw6ria5zflcz58ix6amm9bhxz73m85hwaiq5nj"; })
      (fetchNuGet { pname = "Microsoft.NET.ILLink.Tasks"; version = "9.0.0-preview.6.24327.7"; sha256 = "0dqslmn9nfrpi821y28cli3n4j2rvn4m9kp78qwpa8a9k3f1x8cb"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.6.24327.7"; sha256 = "0gwidi14v21fvr15pgjhfy4x5611q32r52cyz1y18wff84vn6888"; })
  ];
in rec {
  release_9_0 = "9.0.0-preview.6";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.0-preview.6.24328.4";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/2ca1c5cb-12bd-49f5-8924-b1ca8031a856/ed898523c59ab06231f833b15b46006d/aspnetcore-runtime-9.0.0-preview.6.24328.4-linux-x64.tar.gz";
        sha512  = "4e178bbd26c70a3f1690c2b84b01c5a43cbf546adc878617fdf4c39d10e8063684420126261aacabcaa7f72c697290c1c06d3e93d9f3babe57c72d5fe98346fb";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9c7b5592-95fd-4d00-8515-3d6a5c24264f/59f528496c3ab6576bac71982f2dcd98/aspnetcore-runtime-9.0.0-preview.6.24328.4-linux-arm64.tar.gz";
        sha512  = "55e5ea839ddf9cb40d538af961e26959a2dbeaa2dac5de3c85ea50b15927fd5f132ce614e2e4abeb2c8f46f13902cc5f04591f4d12196ae0f8761822e107972e";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b37e6088-911d-48ae-9bb1-920c5c784e44/eec60edf24e317a9df244a48a73f6ba3/aspnetcore-runtime-9.0.0-preview.6.24328.4-osx-x64.tar.gz";
        sha512  = "b80a2ab4ed45878a7817fb0a60da2e1a0f1a4f4477e8e15a6245e5b94fd4cf4fb57dc57a6daa9c8256648e42f1d33a7680a4b8b8eeb41a0d4fcd020b0e216e06";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/62ec355f-dbe5-4674-a3c8-a745079e11cc/f50999d4b748511662feb80dc3950f3e/aspnetcore-runtime-9.0.0-preview.6.24328.4-osx-arm64.tar.gz";
        sha512  = "181c501df6e92ecf85d4c81df755eb06b1734d1814653818164175977a40ac94044341d97c8d40b185dd70685eb55212e9fbb93c4538dbc48529433a336d6af2";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.0-preview.6.24327.7";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/484c439d-3a87-4eb9-9a08-683a1c2bb334/0edb0aa500ff6bfa446940e1773ff203/dotnet-runtime-9.0.0-preview.6.24327.7-linux-x64.tar.gz";
        sha512  = "09aa8c4e6ae3ada1a265a5cd2b46779a763163e4dd9a1892b44606b89cf147339e10b7c584dbcaf5404af0553f0ef6c5801436c217f4fe1a5d3bdb6d74aef1d1";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c19fa925-faec-409e-8a8d-2c106581014a/ad8f61c688682647a6a2daa4fac8fdd3/dotnet-runtime-9.0.0-preview.6.24327.7-linux-arm64.tar.gz";
        sha512  = "755961903291c262a1f5f7b70543016c8f85f6993e861a6f83f8509fd2a828f4a34f4161a3b9f15114663e8073b37937748befeef9ea9818d513aea1b27f944c";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0bee7cca-fd9f-4769-8409-30bfea40aa07/e6e565aa83cbf8fc8a27cb054e83d45d/dotnet-runtime-9.0.0-preview.6.24327.7-osx-x64.tar.gz";
        sha512  = "53d7fd172cc4bfd0a380847b7d38cfdab03f469579458e3c7ab26dbad82b54a663261b60ebc35009f232509e486657ebc4b8516866016510f66e9a3fbec53eb2";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/866edb84-2362-4941-b63c-8480b2133c5f/2750c6b8cdf26e9214f040c86b040d33/dotnet-runtime-9.0.0-preview.6.24327.7-osx-arm64.tar.gz";
        sha512  = "9f038f1ddf51a6fdb96081932c889d63d9ee818de8b5e71af905ede052c17bb22293599baaf9295f42e560d8073d41785507f752fbba316b446664fb762a60f7";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.100-preview.6.24328.19";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a01db0ce-d997-41c7-83de-08ddbb1bad67/49da8a4fae2e0e803854738e5098d89e/dotnet-sdk-9.0.100-preview.6.24328.19-linux-x64.tar.gz";
        sha512  = "ff040c456b096aeac707053517d5f9f5f0df92b6754a4af6b6fe635fd8f4a569589b8241cbad0c5db998dc5bc54682b2f1e4dc4f3d88024a3ef56c1ecc9f4c97";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4129d95b-c724-43cc-b1f5-f394c6fddf5d/24f44d474f12d33f4f74f6913d9b233e/dotnet-sdk-9.0.100-preview.6.24328.19-linux-arm64.tar.gz";
        sha512  = "f4822637ed89f856736bb947cfc1fd4f1c81452016884cdf10ca9ac97c36d5bf810316d534263b3219843096fd5ffc15972714041f85caab243efb5fb910d7fe";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a856c115-c1e0-4050-bcc2-5a2e8840a60d/dd16b2fd886ab6e66ce56f6e7c08beb3/dotnet-sdk-9.0.100-preview.6.24328.19-osx-x64.tar.gz";
        sha512  = "db4e9122cb0ba6d4560a6396cef194735ad41c22ee8cebbfedd41c7b8eca049209e9eedb5013927d6a1f76fea134b78e637c0b3d02523fa7f7a7d4311a059c18";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4dec7038-6ff5-4490-a383-4e98596b3265/671e5c37c62486c331a3c2cea7c8572a/dotnet-sdk-9.0.100-preview.6.24328.19-osx-arm64.tar.gz";
        sha512  = "0aee16fc9a8e9729a5016d12e656ea2f8f0703116a778d3e33cc05c7f2d9870239fb3a0f4e5d7152cd7d6942c41853855fced70f777cbb7d40b5a3e03da2b4c8";
      };
    };
    inherit packages;
  };

  sdk_9_0 = sdk_9_0_1xx;
}
