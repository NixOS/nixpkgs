{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v6.0 (active)
{
  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.15";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4518a0d8-9a6b-4836-ada9-096afa24efd0/ad0d8ccefb6b6a36dc108417b74775cb/aspnetcore-runtime-6.0.15-linux-x64.tar.gz";
        sha512  = "db41bbd6ffb061402acee12f498f41fe5987d355c9004091ff63010303cc9ea969ab233986dc11556bc6def5194883f50fdf216e1c50b26bb60cacd4f2ecd98a";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0d9619a1-af06-40c6-9816-46d08c9e42d6/744ecc09a1058822dc08ae17a3dc9c77/aspnetcore-runtime-6.0.15-linux-arm64.tar.gz";
        sha512  = "3968cc6984627a521e68658f61dd0d97caf061a2582b3a133e4d13ff90718954e881f1dd1180f48458550fb02e2122a71fb2bc0463bba38f6812e173202c2c68";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/183c7035-79ba-4438-a96f-39cebae901c7/14358a3d95afb3af618abea80a8106db/aspnetcore-runtime-6.0.15-osx-x64.tar.gz";
        sha512  = "2e73fc14f85e6cf01fd53439fdbb451496391530cf9af0b4775445383b6f70b5bacd78a0408a8cd6fda23569999fec5809a5cb6325f353fcf72cbb0524e0444e";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8c038a1c-2c5a-4223-b863-3c7ace6b96f0/92b7538b884350b055a22c7877775fa1/aspnetcore-runtime-6.0.15-osx-arm64.tar.gz";
        sha512  = "9295d3931af3b7b74c5fa2c61d49f0c270d00fbf0ab15d130f5b70e28297051341b390d36a1f09cc79a46f044099a3830f652d8a294239821d473f946d82ee25";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.15";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a8db1a39-3418-4bd3-871e-5d13509ee724/2fac3893cffd4948c67dc3a2ef96a99d/dotnet-runtime-6.0.15-linux-x64.tar.gz";
        sha512  = "681928ab5050da89302518445f4e7e00738530b3941434fad363724ad5b1f9bcdc52717332613d2e33733ebf835eb550628e87cebba1a12ffb4f881c8e767749";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/2151a562-4991-4496-afac-12ae22e4710d/90644d83484758da592719d9946ca1b8/dotnet-runtime-6.0.15-linux-arm64.tar.gz";
        sha512  = "639153616c316832970b57faebb95a405d52549d60588a2e515323640a9ec0b7d5826a8434a7759ac890c841541f52551ae21895320749b80ab5ce29290d0c8f";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/002ce092-a45c-4c52-baae-067879173e64/a6b706f9b30cb74210ce87ca651b3f4b/dotnet-runtime-6.0.15-osx-x64.tar.gz";
        sha512  = "7aff9d90424433d35f4152dc6e31b974d35bf636547d4d1c93e7ada25703023a915a232010267842defcbeec95be0a0e0a11f568a07b225ee23dfcbff85cf898";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b809e06f-b836-45d4-b080-06b263579478/4690f65020f04e6579085df1aad7421d/dotnet-runtime-6.0.15-osx-arm64.tar.gz";
        sha512  = "23043de9e69ee01570d7a99be997a38d43da69dc77a59945df780eae772b9f02d8d427062a3c9d0468a41f3783ce9755c1ebc5986f3e02bd661113ca3a3051e8";
      };
    };
  };

  sdk_6_0 = buildNetSdk {
    version = "6.0.407";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/868b2f38-62ca-4fd8-93ea-e640cf4d2c5b/1e615b6044c0cf99806b8f6e19c97e03/dotnet-sdk-6.0.407-linux-x64.tar.gz";
        sha512  = "3cc230f21c0d60ffa4955c01d79cbb41887a41f4e97d0708170e4be8e4dc5bc261269c788c738416c28bbc7e8c6940a89cf3d010f16d1dc4cf25bbb0e2c033c1";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/72d1f83c-ad2c-4c9b-88b1-15196f411b9d/a0b863cabea9ac0fe7b92dc70c8d4ef0/dotnet-sdk-6.0.407-linux-arm64.tar.gz";
        sha512  = "7d48d8a3814694a978b09a7c4b61c8e0dae9b5efe8195c15339d2f777fa4b85084d386117ee03b05f543d3d64b9484942e1e212001382b2e67277b30f5254b9f";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3309662c-cf75-4bae-9317-b0441971084a/91c1112b15c070c03a0d5e6f61434fc7/dotnet-sdk-6.0.407-osx-x64.tar.gz";
        sha512  = "3e4cfbd15ee138c8d1582ebd33a443edc7d8e055d579abc0335a288b2c26bac15d7e4fe3b80f91d56513c82318b6a62803558e3d41a28b6716d2296d12d3003c";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a23756f7-af64-424e-824f-35fd816a5144/0c7789d67cef2037efba35649d643004/dotnet-sdk-6.0.407-osx-arm64.tar.gz";
        sha512  = "75b2cd3a679c3d156ec9f7fdefa9637f8684be17254636acfdddb3bb3d56da4dbac05e9f178acf46a631a21ab96a270aa20256bb3518d89fdcdf6a8d3d21e73d";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.15"; sha256 = "03gcvmkxpwgw3mfpcwc4mpfaqvjzvj3gvn1gc360bzs9ivd49ipp"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.15"; sha256 = "0wdw9f122byk3m1gcw5zdq2024iqc4r0q8l1bsgjxqmldsdd6rl1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.15"; sha256 = "0bg352cbgb5dc12h3c0rsb2zl66f6vh0280s23z3kqy0q474g1fv"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.15"; sha256 = "1zn25wpq7lq1y45m4ipv17yrr4k6dd7ckdx21js9pny0dbrbvyhb"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.15"; sha256 = "1swlzfnxs81cxkrbwp7dw25n5yl4wyn5iy4mxkalcpzvr5br1ayg"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.15"; sha256 = "1dk03n8gpc7lpd8bhv88pdv83j9mp5l2mvqbrli0s493rdrklhi0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "6.0.15"; sha256 = "1agmcldhb8hmrha2bsibpqy3j11q4l8jmqyb13a1llq5bykhkcaj"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.15"; sha256 = "19l7pw2rnkyb6davphi4m04s88vf2x1kskxi0ic9nv2k11lm46rz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.15"; sha256 = "0x7jxdk8ayijv90cph06dmhl3jvsd2gkcj8rigl5lsawc58w13hz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.15"; sha256 = "1gvbmba1dnas4qa5bnkb0d3wks4jfjnh8y09a42ccr3h7pl1h3hm"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.15"; sha256 = "0w3y8pazgsa17m8zwjwjhnz37r9pxkssrbi4rg18l7rk4bjd1c91"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.15"; sha256 = "1xbzj0yi39kh8rdllw0diycv3k87isklyyw932gmryf9bdf2v8jl"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.15"; sha256 = "15p3b8qpzg84f18kk55ddvd07apkjy54q1gkcslp5b985r2anrda"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.15"; sha256 = "0d6s4m03v21b2gqlp6mm5hr5rdig6hl5344c3jg7kczsxx75fzya"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.15"; sha256 = "1h9x9k6pyqf822z44nawyi2hz4fia1nzgwzxm4xxyy26cav425zy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.15"; sha256 = "0jrnd1v8j5nlzcg20mgn21by7yfdjpmn5fmacqj63dvq65mfz2i6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.15"; sha256 = "02lrxi3cx5lbzsgvd51bccpqcxs3l358l07436whal3hzz45sh7x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.15"; sha256 = "1wf8dmhb9yvlic0rf2d24zj2rzasr679vpf0r7vy9iggvl8gsw25"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.15"; sha256 = "0k470z95phdc57f7jqmj1x69qwj3s44nzai0j42q4al2wh047bqa"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "6.0.15"; sha256 = "00j0jcfj23qray0y8ahz3s5v0g3bkazkygn68s8r79rw1ddlyhcs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.15"; sha256 = "0i7v5wpfmx2kizhrwplgq636dcsrrhqpib3w04z91a0ckvva73if"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.15"; sha256 = "05ykar9ymvm68szzznc30yf5jfg2galqd7lzyxjmkz61bfx7q3h1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.15"; sha256 = "1cv3vclygi5mfci9d2i9wxzq1m0g9nxgmfbf38kpcyyrvrwx692n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.15"; sha256 = "1d4s9j3lpa647bfblfh578pj5h0irg4vk471j47b7l4qlgzhi5bl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.15"; sha256 = "1x5wkrlc9j1bsg90nrb2ag26ncwljxwcsi2ca1hhaphb18kzr09a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.15"; sha256 = "10dr4i9x6gqbrni52053ywnrvaq0s9cf71wxy7yzxjn8q0lwhi7c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.15"; sha256 = "1gncnrfl8aawa7b8qf8klfk8dvnpac6zm5ck9ak0vd7n4lzblc58"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.15"; sha256 = "0x8mg0nlylmp0wfnkmx3l70q83nda7dhlzc7xr3i83ds32mcjzjw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.15"; sha256 = "1y5aijd2jagiql8h2xq7zjmmfpl9icq0nm15vm7m1rpcszi6sdn0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "6.0.15"; sha256 = "070gk1r6p7wsgbclv68xjsm3lsyg04yvjb1smpnldq0r4s9qz88x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.15"; sha256 = "0rzsacp91ci2phikfwlbkch6fw38hgabqfqirs82a3y4h0cn4n6j"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.15"; sha256 = "0y9sd4ni56irwr4dhmvf502554frcn0hqc23al9hld016wcmk6kp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.15"; sha256 = "16y63km1gch1v009b3hwzfyvbqn53ilfjw9vmx3qyxjmxmd9jjp0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.15"; sha256 = "0mri7888cbxybsqw6j7vc59ly1bgyczyapzsvvmjqmmzc81bwcac"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.15"; sha256 = "0y0qb98i7456v9k9l31pzilrlvflgk3nwidqqnj8df45i6sid7b8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.15"; sha256 = "090dw123n6pchiphknvfgc310nk5gljljf2km1lkpyr3gsmqphkh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.15"; sha256 = "0dbh8839kd07x7ss1m9clslhr96bdlgz7ylk0b9bcqfbrsbd300x"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.15"; sha256 = "01195cqvw3hbix5wxgifpz4qbc8cgh3gfab909m03y4j3a9mi31y"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.15"; sha256 = "131b2rh22lyq7n4pf4vbr7n66a9hqjryys8s20rgqkx9bcrrn955"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.15"; sha256 = "0hcwrqf6vnjccjxpy5dwzxfqk225rabj3y21jzkd0i07c166piw5"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.15"; sha256 = "04j9is7xl6bpn9y2fi5bh3q77960xsqbydlx6b8nqyw35b5cyacf"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.15"; sha256 = "0gji6ayia67nq3zdccny6jbqqw4bmip9jzh8whlkf1ajim74719v"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.15"; sha256 = "10drlw56pn10mi5v2wrhsg5cj1l03myf089hq2dp7blp4ia0g7zz"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.15"; sha256 = "0sxfrsqrpx5iibaw5xh6lxyzm8qcql0cp8v3c0rv1zfzsx7g140y"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.15"; sha256 = "1xygx7jqvf7fr2b884djzfxv89kbm683ziddzyzbh2mlf32g5ki9"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.15"; sha256 = "0g1d96xklajf5xm75538sna28d8a3vdlws95f43r1ql1cd76bmrr"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.15"; sha256 = "0d7wa63nlh94imi0gl6fs7l09gj275gqj9gln3bbn240anycyhz7"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.15"; sha256 = "1h6dk3dgvffr59ryxkavzz3xf46jkswp31wgdadqkn7j88yga8mr"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.15"; sha256 = "0pcllj60xahcp6y7dhgdx0zbcc89f0ciqa43a2bk7nl3l9vbf3gn"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.15"; sha256 = "0rrqdms8fgjlwspip557w6i7db7r5dnl0ifdh7qmwrviblapxgmw"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.15"; sha256 = "1zh4rw7xyzwmamd6rbh7z4057mahz1fs2l34vy0wvl50zrca754l"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.15"; sha256 = "0nlw7hjnchfq5rq13pd9vdpmggq15k8jsnfkjmpyyrnkx3gf3kw2"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.15"; sha256 = "0w3zpbaqfcf1grn3z71539v6b5r7b6rn8v4bgkm2wgv8bw0nylfc"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.15"; sha256 = "169whcllarss487v10gh1n1i03mcs9py38n4w60k3v6dir5z6wq7"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.15"; sha256 = "05fx9gssyig1a1vdnrj8k9xwxa9v17j53xyl0ppcl2gl07ykhghz"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.15"; sha256 = "17vv8pqc76yb2ag45f08az2rys48v69an3vihbmlf1nsqld51idb"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.15"; sha256 = "1y3hxrla2j8l6g1n0p00i25xnvw4l207390q87aqx98i61xi9hxy"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.15"; sha256 = "0kbjmpbwjpfb5r4zplx76lgljc06mbqb7rg77vgw6j0wjmlsjb6q"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.15"; sha256 = "1x3nyi61zp9808rha84s74cvv6ps0lcs61jdm3m1gg38ci6dc3ad"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.15"; sha256 = "0nzdnl3p8jgpzn3vdfjgq7n6i9vj2lq860k45x87lihmdqzjbvcy"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.15"; sha256 = "0rz0cfdpjwwac6hhk793n113g52g3v6wcgp2qyiyjb31fz9kyfmh"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.15"; sha256 = "17p0ms06jhhmsk190j23khywyzgxmg2qzrc0hw8x2y2n84fq6sgm"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.15"; sha256 = "0bypmkg429ksdssghlvlv4k2ca8bdrgmmkmhjvpg77ravq3g5n5f"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.15"; sha256 = "14jl9gykh5i84jpxb57nmybq0p6zrw8xmlqzjnd5gb7scnxrcn15"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.15"; sha256 = "11f2g2mhd66y9s2f9xibdvb7wwvggkcwb6w5fm0c7y96vc17xjn1"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.15"; sha256 = "1f9pkkz3f7hq46vwxjgxvdy0ky5pv6fj4jnrpyi9hw25q9305fg7"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.15"; sha256 = "0y951cnsk1qpqsmb7chqpfmjdpg190vvph7lpqp3hhxmazia6pax"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.15"; sha256 = "0fqylsxnkmd2v2v4xsh1xid7hjv4zgajj84fgav7d9a5znqfy0cr"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.15"; sha256 = "15nsmqcfda845vj2x1rhxv938bgr3x2ifdyfdi7vvhcv4p1ff1vq"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.15"; sha256 = "1frhmlvii5xhgb3zr93k2slwmx248cgxcmhnn5az71za2m2mpb3m"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.15"; sha256 = "04gbrfk2kbpjibgdm7nqmdk8c8p33ykx51pjs4p1imda5zppbvf0"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.15"; sha256 = "08qbgcr77xhscxq1qcv63qadlvr0d1wv56ghxiz06fwzih7j5208"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.15"; sha256 = "0c19dlxx9z76z737zb9z5cxfma5mv9hg7f15mcchmapj3bbbc793"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.15"; sha256 = "0val73zagng2sfsd3s8q3850ajp1qm2pcsa14fyrzbpnj0c8rcp5"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.15"; sha256 = "0kknq7nblz0i007lfbxmbhvndwlknc8gx154awdc3kbw45qim9fh"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.15"; sha256 = "1b60lfq35z04jrynhnr8266a405hrkrw191cdnxfjprqprj0p11p"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.15"; sha256 = "0ca5lfgnl2f668iplv1r04aw8790s31x4qpg1ip0i4hb7bdparmp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.15"; sha256 = "05z03an4j2h8bwnr0n7yzf968w2bfr2vfrmw8m6yp1cs1m64w9vk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.15"; sha256 = "0gm95gqlnbnc729jli18if9y5l4fkkf9fwqisjz4shvk6gc05isl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.15"; sha256 = "1jbkd72q5wv6266lyb7fhrbvj2n2qf4m0zqxkbba5zxrm0ndj01s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.15"; sha256 = "17bza5p3nahcc1bzyv9avwmb5mgpf1w8mz8z6j8nrpsjnbaq5kjl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.15"; sha256 = "1gm088agn762mzimhq9yg6d5qr5l5zya9hzw9k6mkbmp7jwdsy4p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.15"; sha256 = "1apmjy7gg6lrc6p5v33qh4b65gp05ypy0g1gbz8r0wn00yjbv5n5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.15"; sha256 = "0sg37vd0jwmjl8yfy3pxx81zw82ra0fbz3g31gdcbq7mz2g39rfm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.15"; sha256 = "1vjnnzbdb5rwq7izkn6icy9fwk5rq5qxhp9zxj2p2zk270cz4ss3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.15"; sha256 = "1pszxiialajv1zzlpqqvg5l3yyn0w87yya5wmav7cxvijcm49rmf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.15"; sha256 = "0mfdqp6x13c5r3bmwy1pkj1gvmmi80rgaaghigm0yps3816vrf63"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.15"; sha256 = "0l679nzyhmyn3i0fixv5pgk5lbqwf5ql5xs15vqmrfbha2l800js"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.15"; sha256 = "0zxpmdwb7kvzgwis94k2ffayf0lih5h0i4lzqyf3zfj4mxif9ady"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.15"; sha256 = "1fpbq5gc42llk1iiyvsxcv694rcjnd5yg5y15vy71b0yf6l4sf31"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.15"; sha256 = "017czf4ysdd9iyb5v00v2s6765gd9iz3a2hqcpv06hyzpdkfasf5"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.15"; sha256 = "192mh75vxi2yss1hfhlw4zbp7b38i1d7vmp1dbamqjxc6dficrlp"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.15"; sha256 = "09xqyhgilh9zw656jx523njl9dkmn2lwhqc6pwfqx3ajmfrc3d6g"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.15"; sha256 = "1fb8kklr4zbh8b36icvfbny26whd1094j1hmmx1fgi1xphx7js80"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.15"; sha256 = "1d19hfkd3y89i49i82f7r42fsv6y8vgvwalffjbkqa83iwynp88b"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.15"; sha256 = "1hq40bdi3734wwfc8kncsdhwsanyhmad1w6d1ff4b6jqjy0i299v"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.15"; sha256 = "11sllp5qyvzqaicandm6az48xhrj2q8skq44adcc5xjdqpyknwcc"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.15"; sha256 = "0n84rxd63gkpkdsw2zbv6xyiynzivpb6cpvqi28xn6jpx6d25d87"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.15"; sha256 = "1hrizmq240qwqm5hjfy15h0y1blxhg03ygxcxbpkjgi7zc4v9fsi"; })
    ];
  };
}
