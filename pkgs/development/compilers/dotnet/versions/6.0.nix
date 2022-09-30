{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v6.0 (lts)
{
  aspnetcore_6_0 = buildAspNetCore {
    inherit icu;
    version = "6.0.9";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1a2bca2e-f525-4ecf-9c46-06889b4ce3a4/1a7ad60df284ca6b00ca5d31cc1b1c7c/aspnetcore-runtime-6.0.9-linux-x64.tar.gz";
        sha512  = "e808036155bc324335c309aaf948b2be1940a62eaf0135752989644698653c8f3a5ce310c3ee6742e3af73dbe175c6e529298eedf6eeb31cc38bfeab628f6d7b";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bff2e771-8180-47eb-b12a-757a67001e21/63a7f79af649efe65c20f2ca56834048/aspnetcore-runtime-6.0.9-linux-arm64.tar.gz";
        sha512  = "ed3315276f918f52188430b0d84d843e938c770e0be06afaec6de0b398a1268bae0195c71a29971923b5b7331b6bb64a623a27f48e21a4c8538fde2a543b2dd2";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5d9f409c-0fd2-477f-8a80-44eb18f9ccdb/3dc6bc3edf033ab3d84b36889f1253cf/aspnetcore-runtime-6.0.9-osx-x64.tar.gz";
        sha512  = "d67dd72cfd0fb9d96077bc6c3518fabbde107d97b4645c13dc82ec99abdfb4030e10638e4fb0c52aa5246d90628348fd877625469f14fb45e4467934229749d7";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e13f930a-a71a-4cea-8f3a-2280505fa0aa/cdd56e3fbfadbed989b2acbf7d3aae3f/aspnetcore-runtime-6.0.9-osx-arm64.tar.gz";
        sha512  = "d47e828c160b7e162f26d0074a47a1646863fc63fde393758d020546d03843e3f98adb92e3c0041a9088ad31043314317a2e8be616f8079d8c98754f94eb55cc";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    inherit icu;
    version = "6.0.9";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/05f1a3dd-75f2-49f4-a976-25ce08f77cbb/b6e8e327a84b91513c2744bfccf90140/dotnet-runtime-6.0.9-linux-x64.tar.gz";
        sha512  = "a6df2cfef73047247bd36f51eaf696f616c6aa9b428e42f219bf91dcf05c03dff817a8ec826740002c8aa83df2fce8a7ace562ad2e2956789542f0b8ab8b1173";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/2dc40bad-57b6-42ae-b9dd-bd457af4e73e/b95f86d6f9cf49e156227bad231d4aa0/dotnet-runtime-6.0.9-linux-arm64.tar.gz";
        sha512  = "a4ce5ec71c60690e577e96a2cd821c05d5f05b7c1754fb753353db77e938349a53d4cc55596f7384813bc44f74eac8f991a1c00cbee60483f552663cf4d8ac31";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/cd4ba3ed-7f37-46d5-ab1c-dc479a08333d/f27d3ab52b0830861bed594be6da86a8/dotnet-runtime-6.0.9-osx-x64.tar.gz";
        sha512  = "b52542c1850c14b409c0938a31188821b428199a7f3f55779f4986867a78eedfe06478f8ea79e8b20d078fcfd9201dc10d4a73146ef8fd56753f0cd23c5328ac";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c7c51353-ded6-4846-87ac-d840b1ac2f9f/88641f913c8e886b4e38fc5b0c547ed4/dotnet-runtime-6.0.9-osx-arm64.tar.gz";
        sha512  = "07dfd194fdc67bd096db0edc691fc2a2d0e41d8a3023582ef1ff7348eb0fca3a58d97b79c454e5c67339f6d9c9b0f3b997d68f6ec7bd0e8c86d584da6d94cd8c";
      };
    };
  };

  sdk_6_0 = buildNetSdk {
    inherit icu;
    version = "6.0.401";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8159607a-e686-4ead-ac99-b4c97290a5fd/ec6070b1b2cc0651ebe57cf1bd411315/dotnet-sdk-6.0.401-linux-x64.tar.gz";
        sha512  = "6fce5f29e6cfc80da1df86d2de3a637108023397d275e0dcfa0b79ef36eb85c2c3433db467aa5d8fda7e32bc21205a126636b53d56c4eb4c547d9d3b2370cb31";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a567a07f-af9d-451a-834c-a746ac299e6b/1d9d74b54cf580f93cad71a6bf7b32be/dotnet-sdk-6.0.401-linux-arm64.tar.gz";
        sha512  = "8c05f9e02e0a48fcc3e4534fa7225fe5b974c07f1a4788c46207e18e94031194e1c881e40452ee6c432764e92331c50ae47305d4aec5afa363fab3a8a6727cdf";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e79e447d-20fd-4ed9-992d-39165aaf964a/1f101c161bc4a931e16c697e3934e413/dotnet-sdk-6.0.401-osx-x64.tar.gz";
        sha512  = "6cc47bd279ba3d5e2df9f41b14b25662c8a3d61d5dee0fe021ad54a8709aa8a34430deb644c3525d66124a6a1bdf6a273008ea5fcbddccee238f4c470bac3e05";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/dfeaba35-b5b0-4299-b4fa-56735e3f224e/80cc6c2404d0319fb3eab5d0f407b169/dotnet-sdk-6.0.401-osx-arm64.tar.gz";
        sha512  = "0e1974a99863afe0b2c03fe52874ad388c3e019e34c7e0a1dc29955dfa9783a946082270fbd767272817509b30d1928d0c9f12cda43777292587693e0b0fc604";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.9"; sha256 = "1grw9xypa4wlpqdjbgn73j4vlsz1xsrzil0pzb86r4902pcvvf37"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.9"; sha256 = "0xjhg58dzsqajl5y24rb4kwq87l6qplnffvr34bi2w94kw0s5kjc"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.9"; sha256 = "1ycidvr1h7k3i1fijw8nfsvhrj3vqggyz82jykllmxwligx5fpm5"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.9"; sha256 = "1imicpzyyr1dhiqqnx6klkqmi1jr56lfiqgjzwjbv49d1jjx1m1j"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.9"; sha256 = "1a2fw406dmffdl75046qc7z3rj76jbc74xgml7gis109i1s693pq"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.9"; sha256 = "10dmgv1rd4rac58xvhggkv2icq78ci0c8jfmnri3z32p14brlqwd"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "6.0.9"; sha256 = "1z268bp615g4k9bq7hscq418i9k8f126lf8w60yq88rh0phslvyk"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.9"; sha256 = "0j2wxpvdgvipzy2qbpil8rbxszbp8wwgr28n3gn2r23gnsbkqpwq"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.9"; sha256 = "0w3mrb1c21w0ri2pi9pxrpazxm94pbh6glfknjbc45awalqc94xq"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.9"; sha256 = "1ws4x3l82m3kdrmaj67g6s9cc6p03rkg0pfaj11k4vmin5xbn9c4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.9"; sha256 = "16zdir94cacz2qrndspkyvwq7gp0cp20wdixkazfzxk8h5fhgbzw"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.9"; sha256 = "12flsql4wzgq1pp6w2xdc0ar493s9znzx17fvk9kz9kpbiwfivlh"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.9"; sha256 = "0zhsvrydnhzxjmc2jjm95lzx93w8x4hh2wckcr8rpmvrlpr6gs9y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.9"; sha256 = "1lq8gdmkl1a68fr7ra74q4rlcc28fs0krsymhpiki5vch0jphjlw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.9"; sha256 = "145viis984mdg29wdm21r13kd9dhiapjfxvm2wlvfdn617aymrkk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.9"; sha256 = "0ncw5kilaq3gl9smd4jy32z63kqaqagmxiii0hyp3ai3cg6zpwj3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.9"; sha256 = "1rxi40ikai558dgy8n9izgkl4xbvqgyyh4pf0865a5qg1hhbis4w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.9"; sha256 = "07mkd56q2285izciy5dcc4y38dpl16xmpsz7401lg7drkwwkxxn9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.9"; sha256 = "11nxvyf51c78hhjrjd9zmjb70nrp4iqg6gm2p30gsviii91y3gry"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "6.0.9"; sha256 = "1l51bnw559mas6rza92wfdwksr59y105rpkjlhq2q2ymf3klys8z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.9"; sha256 = "1iqs93klibsy08zw147zflajizkih1p748q3c37y9gp8glwqxcd5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.9"; sha256 = "18cmj54f39albhmkpisrwvzdjv5hxc6bc8fjfcs4hh79clxhb6pk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.9"; sha256 = "11zsyjn5smg797alfzzk0ilw5b8jiffsy9f734djpkpkykh4dvgy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.9"; sha256 = "0rn22v2hxr7a1rzbrwml9wbjh2s3356lm28ks4aqah9iaj607q27"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.9"; sha256 = "0jq73m9gzph7a91xgs9h683n2y552d1shhhr4h1ihiwm2nnwdkqm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.9"; sha256 = "13kk1k1011bi2fmzfrg4vhv480kbl7yc9zdk09d7660xxqavxgyc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.9"; sha256 = "1wrgdv2av0v4wpxw2fv8ryfaha8yg3yaf5zynz67pbb5r3yimkmd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.9"; sha256 = "0bzfymrni9vibimpi85pggz3d0k625dl35sigjmn0lgpn2w53f01"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.9"; sha256 = "0ggh4iargpjsgjjcisi4bgfqlv9h3gkwff14cfw34lnficqykm8p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "6.0.9"; sha256 = "089bpm0yh0n59a4fn6abbwc4c6imgr9msrscbjaqas8v5amisg6y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.9"; sha256 = "0hmb4ysplch0lms8s2v2hs9lh3gk3pidvpv0h2qxbbfq2qwhjz7r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.9"; sha256 = "0yka0ymd36qksgrl94m300yiy803daf4vr1lns06ybr39dlgwvan"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.9"; sha256 = "15kw84wvy0g6q16293yj4blr0i1yvj1w7rgq9fqxgfmjgakrqg0z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.9"; sha256 = "1gfl347dxcfc0y4a5a171cn040pb6llvg9vxpgab4l33asgph5gb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.9"; sha256 = "0qf05pl6b5xgcwk42cph9baxqmfim6kzxxck4imh645js0bhkl6r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.9"; sha256 = "0a6c83s7lr7vrw170cigxw83ffxjsnzgxc652ig73pbi0y4p7d9g"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.9"; sha256 = "0mhbsh4p118nwja0v5di1la7h49hjws6nnvjd799cp65ybqap986"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.9"; sha256 = "1ncc1x9paky7380z4djzx8i881ks56izkfb10pzigb2azm87knhs"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.9"; sha256 = "1ywscs59f0qvmy9w5ls1dkqzk5lg0a5p0nvhlzkxc4zmwr65vq5n"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.9"; sha256 = "0qj4ns9f8yf5wk4h0n6dnz3banix1jhgn3bd57x62cghfpwr7jn9"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.9"; sha256 = "1g7mvb5js3kdcmylnn22z9vcvwndzrqps23klnz7cjs207pldhw6"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.9"; sha256 = "172pxzsxr0x4nvyslm4gh6ar4mhy85fd9bmwqqja9k395rc9vh48"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.9"; sha256 = "1zwlc5y7zis93jzyixpgnhx1cjxi76mawxvcwcf215shrq80i5r8"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.9"; sha256 = "04hxa7924vaabqiw2imwn4d4jbxxyg950wpss420g6jxshv19zcy"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.9"; sha256 = "0srwj2xgxi0w8hfgpfbqjrsm79kghb9x6fkkfwqjxsa7v95jh4bc"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.9"; sha256 = "0b45wvpidp5zcchn5qspdqc9b60ivj67ic2a210px8vf57973a3b"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.9"; sha256 = "0jhflmmih4dhazyd7dqqiy207i3d153080hdy5bqqs21zl5ipc5v"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.9"; sha256 = "04dpv282hibxlq23g75sji7f9k4w4z64azl8j399ny4l409vw339"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.9"; sha256 = "11b4p88jbx5amzb3y04yziq3wmrm9kqzhwmrhlsw0n8aa0fwc633"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.9"; sha256 = "1cxrww0m61l883jmrjx5f6kgmk75p0jf4dwv8jkb5jnpq5lncjwk"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.9"; sha256 = "03wgcvxyrm6hk5z8m87m1n0idgsyv54lsgbk8iz4qiww89r8xq61"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.9"; sha256 = "1b4b3751jjh87g62w6fkrpfk3h92wh6927lwi0k2yxgdsbvadabv"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.9"; sha256 = "1vk22ff2jhaf3di1p2pkz0il1knl3hpfyhqw10b9mpxg3pk4ap3p"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.9"; sha256 = "09q38lwkx53fdl09ariv1d14md4brib9f0azah0bqhldkrjk92kv"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.9"; sha256 = "1mxi37xq6ghafg174x527xsv8l6r9cvrpskkf9h9lhk4lr9y2z67"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.9"; sha256 = "0cyddk0ylsa48xwjhi5cy498ys9y92r8kad1x7kqb0qkrzkjpzvv"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.9"; sha256 = "1jvilnvibx13hnkygfgkgkn3r1n549f67qzyg6z6ycd3cp8l915q"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.9"; sha256 = "1cb29wz495fwrbm7kwg8h4cmblsaqjff4f7kzmhw6qin56bvcw6r"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.9"; sha256 = "1q8fnyl6yzgjb1pmilgj0hnwkg482py7avpsfc7fsvygpk8izipz"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.9"; sha256 = "04az20nar6n43vrg131ppwnwzgij8781lb9wb113af5q323j94xk"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.9"; sha256 = "1h5hk3mfz730960hj86v6f1sqwb1kg2pfnp14l42cfdhjjs20zlv"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.9"; sha256 = "14xm25ynrjymrp2xmmblv523zsgggn35qzl88qcs4gbvp2j25hn8"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.9"; sha256 = "1kz2shcfhhy9aswzja1hk4lyrvicfppzkz4ggbn32vsbxlfaxyzx"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.9"; sha256 = "1a6k4gww8752pll4jz0wing1sqsplp9w0jxl5s5mfwj3p0laywly"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.9"; sha256 = "0kkbb6dxwgjnaazvhs81qbp6g0bc6w11mmrbx7cz65ps1hks1gl9"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.9"; sha256 = "1kzvyncbqdn9vn6lbvqzw1i3fzzdbj5xp5yzasdf843qi60vzv37"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.9"; sha256 = "12dxp96s115xrhh18q7bf5r2rk1d485dqcbiwfhqi9xcbs11hlqg"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.9"; sha256 = "1b6hzkn9pflbdr2lzrmdqpw93g23817ga5g4zbjdz05rd2ar2j95"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.9"; sha256 = "06va78yd32rhrylmy7hfkf6a92zaj9vkn3kmqzzzzisjzzrwws2d"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.9"; sha256 = "0k7kyqdm2mlb2w7q5fpzj3sc20dqc1yc3bdzgx0qy5sfp3n2qdkq"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.9"; sha256 = "1dcc9kf1abkdcq7n09s1vjyl39kbnpi8cqgmnhkhzlzh3l3xgvaa"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.9"; sha256 = "15zlpkf4ms616whp251q387fwabfmbvcxkhnx8m1jvfjc40smm0k"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.9"; sha256 = "1i2fzw6d8kpn8jrl0zmz0l6sxyaahs15f97xymkhv9xfj7w87ipr"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.9"; sha256 = "0dyrizlh0vyvjjrjzn7p4wqzsr7360ppizifjl4y3fjxsixc7r76"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.9"; sha256 = "1jsn0nadpnnlhn7y3s8zrkkm6fl1fsl4xxcf157m483qlswmlf9j"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.9"; sha256 = "114a4y1xn6n0qwn9ssz510yq634liw5nkzyg8qqwka3d61g9vxap"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.9"; sha256 = "0qvhh2qzj0676vcbls6pmx0yydlm2fyb4pr1393siag7rn59ivhr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.9"; sha256 = "1wll6y5jg3f24pf6zs2aygmnz2lc71436svfqn6kxrfk6v3c32zq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.9"; sha256 = "1kxql8yzi47prsl0ymjgyplfkxdfv1a048wghi7mc94zzjapz67w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.9"; sha256 = "1mf7xgjqn2d4pcvdy6g1igihygfjlplmfr2c88y8vq75l42bj641"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.9"; sha256 = "0djmb6i7jn9qgc9cv52c3jvkzqhm7688xcj9wb19594dcrdmrq9y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.9"; sha256 = "1ia7g6rx6jka54c0b5bvy45yr0nfs0cd64vwq1hkd5fq4wq0pmsc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.9"; sha256 = "0mrpvpvyxvkbk3q2ngs5ls3j4nq0pr2zhd0vls9bcv2sysby8yw0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.9"; sha256 = "0p8a9001f9bv85k4fm76skc1zam4k1damxk8k8cyrg11m3p1m4zp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.9"; sha256 = "04fndyh42irxgxk99y6bvay415ikb63xr0hqjsg1l2ympzv0n19f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.9"; sha256 = "1d7alkqfbh58jdj1m9r99ppf5bm8br40a8xqd6p64mj88iwmz2i5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.9"; sha256 = "0bqr8sgd7d1lwyyyclrpyi4p0d5nm7jk4hkapna142mxl1gckc8r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.9"; sha256 = "0cp47v4xjyjfwmm2r6spgiys60qsjkah9pf4ynl02jhyfncv4rdp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.9"; sha256 = "06xi0hknlpwbxkdr8rj3paw5gigyp16m8r4w9ghwgdzigszwfcb2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.9"; sha256 = "1sp1zwld1kdcaax177laqfdgc8yma54w1k84xnjxrb8w2qkyw1wr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.9"; sha256 = "1didb5656m40g0h42ldw4qzwzvnfxsgyp90qlm8z2f4xjr2z2vvk"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.9"; sha256 = "1lk2afw5x6dyfj88jk5a7iwnf5p1g2zs1xp9vbgqqcfw64lxw04s"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.9"; sha256 = "0n87srqrh1xrlj9xz1q7fb6l1yzvcbajy5p6906iasvshyrj90aq"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.9"; sha256 = "1jksa2j7v33lj0rdpcrmj4ibjafs7qm60knfxxa7xsp4zvqyhwx0"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.9"; sha256 = "0qdrx14chj6yx78cn2zxxfp9qs90alqb718z4y9ca1ix49wld8kh"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.9"; sha256 = "0afrgd5l531jlgf3s93cqxphiirnifiw6rlqp3zaz3ijxwlikzkz"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.9"; sha256 = "1gb4cr6f8ridwg8krh6fd6lygl7d3kcv5a3jda47ppvwi1kc6i4m"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.9"; sha256 = "1yqmq0raafi7i8s8v3mjwdl45gxfs3gb6dm2cb4n19w2jihrn7nl"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.9"; sha256 = "09pr6llr1zy9l74lhrla7aa1mxw444qn817kxkwrfqdj0nq0aqx3"; })
    ];
  };
}
