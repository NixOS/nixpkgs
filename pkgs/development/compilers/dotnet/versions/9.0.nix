{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v9.0 (preview)

let
  packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "9.0.0-preview.1.24081.5"; sha256 = "1li21dfibwmzrcnf1jlaybhrxjk3cb9vqyy700s5bqwcw69px7dh"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "9.0.0-preview.1.24081.5"; sha256 = "1gnilvb9ys76snhlv2vnv3h6xp9a6hb6pjjvlaawvl71y2cpjy4q"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-preview.1.24081.5"; sha256 = "05gvwi0i1s3rsi43cb3v8cd2pzr0qzccq8vhf4wm9rj63j0flz9y"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "9.0.0-preview.1.24081.5"; sha256 = "0ivnyyjd38fwma2426bxxnbm033ai9f857n04gs73vybm3fs0f4v"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "9.0.0-preview.1.24081.5"; sha256 = "1bc5bh3qfsx4xdsmr6a6lxc58kqb7y68w12r872zfq5isz5hpq75"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "9.0.0-preview.1.24081.5"; sha256 = "1lqwczkgi972clvplj8clcdprlh5ydjsdv7343k3f1i32g8s57cq"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "9.0.0-preview.1.24081.5"; sha256 = "1z5fplrqr4k2lddjk2yzjxd398v21w2lxwb5q3hc2ll65f6grmhz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "9.0.0-preview.1.24081.5"; sha256 = "15zl1ah878wdd4xxywj1kj110vjizmyvbnyq3fgb87cq9rl4b7fi"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "9.0.0-preview.1.24081.5"; sha256 = "0cqx20qpy35nc6hyzi8j2l96bliia5ks9dkvbjx5cykhar2bnqrl"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "9.0.0-preview.1.24081.5"; sha256 = "0nfzz7ibpmrsmzivs8ja7w8qw103bv34d69jw1704m5ha4ybca8v"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "9.0.0-preview.1.24081.5"; sha256 = "0a7sj4f6b9337xxdr1ckrnmar189bg8j6zx82qi6vppwsiwsgqz0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "9.0.0-preview.1.24081.5"; sha256 = "06s1zpp5l3x7fxbrm78bnq26p1wfqn2282py7f26d3fn6hx692gg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "9.0.0-preview.1.24080.9"; sha256 = "1qh7988cdbvmr7zqfwidpw8fx7hhjym1cfsyxf2hvzv7srbkhmr4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "9.0.0-preview.1.24080.9"; sha256 = "13x14l513qhgs2dspkqkmxy6f0jr8ajsvkpm0apcs3xp2yz4p761"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "9.0.0-preview.1.24080.9"; sha256 = "14azy981h13ngwipn2k2nf0p09sqmv0j79xpg2nv1hrznwxvfckk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "9.0.0-preview.1.24080.9"; sha256 = "1qssmhwlpp0hcbml2vh2flxhmmmvnllvkgczbrv7pmq0h38r3ydl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "9.0.0-preview.1.24080.9"; sha256 = "1ql0prr6md6dm3dgxxyfvlw773klnlhd2hk6r73fd0s68xkd1qr2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "9.0.0-preview.1.24080.9"; sha256 = "0a6dl6m93xx9c0yx574zx4cfyvvxaj41yw43d2g3sclsrrn4b9pp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "9.0.0-preview.1.24080.9"; sha256 = "0962lnkfdp6bv7rv4ji5wsrcs0hjjp4yzlnf4hmz90mqd3i05w4p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "9.0.0-preview.1.24080.9"; sha256 = "1dxdax2z2bdwlwjm6nxiwk252d0fi9rdx0rhx7d8vam5gm336mhr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "9.0.0-preview.1.24080.9"; sha256 = "1d9pfs06hip5d80zsmgbsfffbzmdmc29h7bl92cqf3p5hkj53zf7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "9.0.0-preview.1.24080.9"; sha256 = "0nsdhf5pr2id2i3l7fhqn24d234isfd0kv3dr89pgfh3zprs67zd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "9.0.0-preview.1.24080.9"; sha256 = "0nzzf2m4wy66cyp0by0594xdq090b2rzhz6f9yadf3mj3427v9lr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-preview.1.24080.9"; sha256 = "1sk76h47fdbp2dlh9gqd89fa9gdhycsq1im6l2va30x9yj4909qa"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "9.0.0-preview.1.24080.9"; sha256 = "0dchamrhqb4bml9p1dhq92wykm6b3swqnqax8ficnxpy0i2qd01q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "9.0.0-preview.1.24080.9"; sha256 = "0k235sbrrx3hyl13qvri779l20l9bl2534g8rxl5gvxicfjz25kp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "9.0.0-preview.1.24080.9"; sha256 = "1sn8k2isahx2vkiwb94ry4cs96f71y2q8x5p6k8zql9j1v7vqaij"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "9.0.0-preview.1.24080.9"; sha256 = "05448mdb2sqvxlfipfaj3zjc4pkn2q55jxjyynhg94v0rxssm8fx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "9.0.0-preview.1.24080.9"; sha256 = "1xj7hs7v76fjyr4lldipf8wslxf36a9l8g2czpsz3bjfcaydj1nb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "9.0.0-preview.1.24080.9"; sha256 = "0g9zgql716iwh76jp9bj5h0jp935chnxv5ah0i7fa4g4k84y45ww"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.1.24080.9"; sha256 = "122nia5gmq0riqdpgrz3aqfm7yp02xn0lxpljmah682h06mynvl7"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.1.24080.9"; sha256 = "0clh5mphnai7xqb4f9r0dn23i6n4h73xf1hxi3hmxw6zjnplngpj"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.1.24080.9"; sha256 = "141ffygbqny0x6k4lkndfi2z545c2r41rlc5hjw8b2sy99rfpjny"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.1.24080.9"; sha256 = "0ddl3kgff8b3np6axnl7gyhhzwic6vhy0b5bz4a0dvapwlpjb0a6"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.1.24080.9"; sha256 = "1vmpl25sp4hrkx6hrrqnp0ifqr9w9vdim4sb5igflwggdmdyqlif"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.1.24080.9"; sha256 = "0id7j171maci60wnvy41gibl4x9fn8gl6cg787dy4a9rnn2452m6"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.1.24080.9"; sha256 = "0d0ynkczks7birpj5n3bka1fh998syci3h30wdqh68b00svqfvd2"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.1.24080.9"; sha256 = "1hbm9ng1j2gia5rpynmhyk404041bbkdc6y483n4wzyyl538b6wq"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.1.24080.9"; sha256 = "0k24rw258glp3mihxwb0r2pnp6a4bcsjb21asa9jsa1w2dsvlisf"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.1.24080.9"; sha256 = "1plgpd6q1q8xifr40hv67amvmq4sl9hirh1r2i7rd2bybga301fs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "9.0.0-preview.1.24080.9"; sha256 = "122wyzf8ky7h6qhaj4nhffgb51xnix9fhh1niqcli0j7n8qcx6p1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "9.0.0-preview.1.24080.9"; sha256 = "0af0fpwv3vk0v8448kl3z13xs3063qm7901wx919qmb4a9gkw6x2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "9.0.0-preview.1.24080.9"; sha256 = "06zh10z4ij5rsnnvsbixp99y5ss6jsb5yy78il5axby9kny75r0p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "9.0.0-preview.1.24080.9"; sha256 = "0p9rnp355q9hbl88wjkx4cjkagwz87ggxnrc823qkcxxkf56wscj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "9.0.0-preview.1.24080.9"; sha256 = "1gbb7h757ilffgg35smqa890rzz0667nml2ybdrii2a35prh537b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "9.0.0-preview.1.24080.9"; sha256 = "1n8q387aqj7vr7frlmwj8ikm67kamlk5fdj788cpspg4pr473g5y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "9.0.0-preview.1.24080.9"; sha256 = "19sc62mm0abmzr55nmk32ygxfqbc2jm0xydsap714b2hgl3b4lq3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "9.0.0-preview.1.24080.9"; sha256 = "0602a6qybccsyif6qd6k8xyrkwd4vw8yj12jl910vj2ba0anzhjp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "9.0.0-preview.1.24080.9"; sha256 = "0fgn04vzb1821ii7d2k4zzhf0k4x4zkz01c90z0dsazjna80nyav"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "9.0.0-preview.1.24080.9"; sha256 = "0868zrfwa4lhqrq5nxc97n0i36w97ydl8k97w25d6iqlbs43pq4r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "9.0.0-preview.1.24080.9"; sha256 = "0a1c9f9nwwlai7lzg331as5rnzk2wrnks9wx0azh4z4l6sag5r9v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "9.0.0-preview.1.24080.9"; sha256 = "1xlfqpnkkxbsw3wylvxcy406lkb3qlfn6kisa6l50zxklxw11xsv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "9.0.0-preview.1.24080.9"; sha256 = "1shnmvbmf0rl7ch92sf561hrwvahgiicral5m6wrhifnnzadjajv"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.1.24080.9"; sha256 = "02dq65n6kcpbkk38ic4g1rq38qfhxj7rx5aj2174qs9kq477rmsm"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.1.24080.9"; sha256 = "1xqpfdgsdzafyfds021cl1sc5bcg146gg1hn7xln68j965im02yr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "9.0.0-preview.1.24080.9"; sha256 = "17yp1b13l3b3arivms1b2ydg8mlysyjqnk50b2qfhp5l3i0y1sqr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "9.0.0-preview.1.24080.9"; sha256 = "191qbl3zjwghwjlv958cdv0cslz4xkhb1k3cq7bi071zlmvs6yph"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "9.0.0-preview.1.24080.9"; sha256 = "05ay8n84f1f7vrhv71z6zjn7qm5vjgqn6flk9h6k4c1ld9w2nx8l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "9.0.0-preview.1.24080.9"; sha256 = "1a01xb92qgg0304z9z7xllnawi73b3pp2aczvchjsyj94ifx07zb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "9.0.0-preview.1.24080.9"; sha256 = "0mjl5l56a2kdcdnjnmaaw4rw0ijfcffq7qjcva1n6fzfzw45pdpl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "9.0.0-preview.1.24080.9"; sha256 = "06hdjvnmqnxi621s2fg4n60sipa5660g2hik0pnmyppcp9218n5z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "9.0.0-preview.1.24080.9"; sha256 = "0y9506n271qaqvkasmfqnk83bxgi53hzcwdn6dqlkbdh2drsq7f4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "9.0.0-preview.1.24080.9"; sha256 = "133rjr7cd18srl4d7rp3kadbwczwb8kj2z46hhim5v4zz3w3hk15"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.1.24080.9"; sha256 = "1cv4prjb7qij28j8qv5psgxjkfwhgcpkgwq56c8c1lajzabyblgw"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.1.24080.9"; sha256 = "09qs0xzv91lscwarjgr089mx8sgrqhafi5r38gvr1q2brpgz13qi"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.1.24080.9"; sha256 = "1yby7m761232izvi60m13b2w4ar0ww4r8g9q61glgac36lqgbw0b"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.1.24080.9"; sha256 = "1ms7rv2ww8cdrzr6vq5rr7ysac4znfbyp8c6sd887vy2a6g5kc9p"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.1.24080.9"; sha256 = "13ra7s6hhfi8yszcf45c3wml1jhjjrh6r49linpwaz8p71rpr748"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.1.24080.9"; sha256 = "13411aghpjxkip2ddq0pkg7b4gmy1qr9migfbpd2nc7287gngd72"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.1.24080.9"; sha256 = "16dw2qixs6bn16inplwc57x4kbwkd0amaqzhsrf1wsaajal4fh5q"; })
      (fetchNuGet { pname = "Microsoft.NET.ILLink.Tasks"; version = "9.0.0-preview.1.24080.9"; sha256 = "0sxas6zxpfwrz6bvkw9jyraprksvrgm92hccispxp7yh8mjkhcr0"; })
  ];
in rec {
  release_9_0 = "9.0.0-preview.1";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.0-preview.1.24081.5";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/14b2b268-4d58-4f7b-9708-46c5a0a5b868/3cfbd27c7e2aabc0ca70f474709a4767/aspnetcore-runtime-9.0.0-preview.1.24081.5-linux-x64.tar.gz";
        sha512  = "29bfe0b5b72608eba97151909308a67a47dc299902a46bf1a22d67bb5f8a0c87c6f4533c0c2d4679f9440f9ccccf549c434a4280c101f7633bdbdcf049c95817";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3f2586f3-89fd-44ad-aae2-4c241f72996f/f973c7140305733792dd25b466e37606/aspnetcore-runtime-9.0.0-preview.1.24081.5-linux-arm64.tar.gz";
        sha512  = "118967e64995d7c242738bf806928ecc52cfae3b0e0429a6951047eaf37d27bdde0adc0c6dc74e32d61b69565f7666cbfd4658396c37988e5d343debcc15bdf6";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/2e9a9af2-f1dd-467a-85f3-430f5142bf0b/6ce0853ee69a127bb767270a737f6467/aspnetcore-runtime-9.0.0-preview.1.24081.5-osx-x64.tar.gz";
        sha512  = "3ed80631a3ca0a4684a70fc0f17d46257a63cc71c7497c958accb4d329eff4a7c832a29c028b608798fbed0b82e2c5b7d5533c57dff2188d4142559b57341192";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a407f4d8-183b-45c9-8153-c889c10630b9/2388fbcc5171e20d05abeb301027df2e/aspnetcore-runtime-9.0.0-preview.1.24081.5-osx-arm64.tar.gz";
        sha512  = "09746054c291b10bacf3fba8ad147443fd41f42b6b04d9559281bc7d919ddc56ebe7402021997f6f24b745b3292368719cc2142d0eebba76226c5603545b6743";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.0-preview.1.24080.9";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5bcb417b-0de3-461c-9ce2-a9ddd5df1aff/73e36aaa7c2e381724a2adac149eb376/dotnet-runtime-9.0.0-preview.1.24080.9-linux-x64.tar.gz";
        sha512  = "68f0b89227c8e0b3239477409708c1b0c5cc7d80afd6661dc2150946c66e2130cf560c2471609f0fd063f01ca1d8e72f74beec45ecb519cf58f1cdc434615054";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7d911f96-acdc-4f5f-b283-cae6d6439bfd/f9e1c8d283ffd1d2e40346926a9c37bc/dotnet-runtime-9.0.0-preview.1.24080.9-linux-arm64.tar.gz";
        sha512  = "265b7bf094730be765bdaadec3215c1a7c51bff6fb18bb51cff383473e32d1ba821b6d046e0f7fa864400dc5cb68e35943057f5b6ae6e8c411375fc15fdbaf3c";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0307fdd7-b398-4e90-a88b-574d853b769b/ab8938a35b03d8308a7a16331fa65cfa/dotnet-runtime-9.0.0-preview.1.24080.9-osx-x64.tar.gz";
        sha512  = "f644ce6ee158bd86a4aba21bdd955a3aebb0367b5af618b6e77dc85922bc790b9c33b572606a15f566b2729a90923f66a933159124e803494105a695c890b775";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/079214b6-0ce6-4d6f-a0ac-9bd9072dad0f/14b558eb20224c345f78ea80f7029e11/dotnet-runtime-9.0.0-preview.1.24080.9-osx-arm64.tar.gz";
        sha512  = "63bf6a57f61c4dcf4e0cdcedb8ff6c76cb702a95d4e0033f17b4cd2a3e800e73ab16c401fb098416404ea5716c725c175f9422250b2a8816c08eed2702cd38e5";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.100-preview.1.24101.2";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f51b05d4-bc43-4290-9b33-aaa212edbba6/e10559d91242409faf5c37cb529de8f3/dotnet-sdk-9.0.100-preview.1.24101.2-linux-x64.tar.gz";
        sha512  = "e176126d9a12075d91a0ad2b4dd50021a564258742d86560bd216ac36482c763087bd8affc68fe9a8d3c46f61f864bc2c7c2e455739d21614516c4f73fd281fd";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e8743929-2c7b-4410-88f5-5f247040b498/ff454c589dc8d5dd9cb42e0950f34a69/dotnet-sdk-9.0.100-preview.1.24101.2-linux-arm64.tar.gz";
        sha512  = "b7c29e4e4baf2d2ba7b29fc5a080df708c5a915e6fb1ce2ff93ffc8f18e7725fae5d569ab1349ef4b067d05d00886a17c8d1a95e211602db1ee5da820b5edefd";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9956af63-be37-43be-a854-01f3a95e12fe/60d97a3f4f53b33376b8df055a14cf39/dotnet-sdk-9.0.100-preview.1.24101.2-osx-x64.tar.gz";
        sha512  = "90c6709c54c0f9f4d7100bbf9c3b8136b6468617034c23f6a60dc17092e311539d54b741e149b70f1b6a6e2c6be0aacc948d4c72abac724f47d5ea05e02a2939";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/cd991bbf-8952-4bd1-83d4-33eb1a810939/3662095e14f91f43c2b3a7e6c55666fa/dotnet-sdk-9.0.100-preview.1.24101.2-osx-arm64.tar.gz";
        sha512  = "901835cfc277c626d38c7a2bc1a6704115d240812631cd32f4b51833b41ddcd3a4a169a1bbda42a9446eb33b2337f6a8c6410bc3d1bae557c8898d427e2fc8c1";
      };
    };
    inherit packages;
  };

  sdk_9_0 = sdk_9_0_1xx;
}
