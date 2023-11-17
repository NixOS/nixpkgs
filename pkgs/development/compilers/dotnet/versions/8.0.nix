{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v8.0 (go-live)
{
  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.0-rc.2.23480.2";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0d7fb51b-f30e-4b84-b4c2-b739ec8f7978/68e9fc71fb2c4f01a9c7f25672caf1d1/aspnetcore-runtime-8.0.0-rc.2.23480.2-linux-x64.tar.gz";
        sha512  = "5d8d50498be52ee4c8ae83e9ca82ab947b187f27b56047cc8a09f6ca2ba6bb7532fdd30bc035d518ce636965371f2ed16c9f97398f04d836f4f67b11b5ce50a9";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c5d92a9c-c318-422e-b66a-7849199de735/6c3bc3f5958917851fe7dacd383bcaea/aspnetcore-runtime-8.0.0-rc.2.23480.2-linux-arm64.tar.gz";
        sha512  = "a539170e9f0cc07801142b4f301554bbb76f22c3bc8dc4c421ca5c9be4dad93931acbb5a1d516f5fca57d739d33d10bccd33a480eb9e0d40e0f7594c38e405ea";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/76affdcb-9294-41e4-a5c7-91629309e11b/75a24f3cf07097a94c58e22acf1e709a/aspnetcore-runtime-8.0.0-rc.2.23480.2-osx-x64.tar.gz";
        sha512  = "b798c397e2ddd8564024859f8aca2b9043863376b8327661ed83fb626bb51c26b1d5ef5a0ce6848031f14c480d4ba936aa0c4bddde8f38aea993d72ade10153b";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/32f5d2b8-3b63-4d4d-8a7f-876adad4efc0/c1f62a3e480fb0e38faa957d34c0be54/aspnetcore-runtime-8.0.0-rc.2.23480.2-osx-arm64.tar.gz";
        sha512  = "9cf9dce54fa4d1ca27955170c5378b826400e4ae45a9312f97f3a9d87ec31bd3231d70e482c36499fdc0d83f80af8860cd87d70dbbbf614f0312c6f73f71e744";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.0-rc.2.23479.6";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4fb768da-b0ff-495f-8673-869c2f7e59bf/527c1e1d55a9fbcdd86018bc62b07a03/dotnet-runtime-8.0.0-rc.2.23479.6-linux-x64.tar.gz";
        sha512  = "f1565aa5a5a98b3ab2cd92376b0b1bcf4420b6377047bdf2324a7dd86b82f5b4776a2795395bb777a3f7d6f6f9b8dc89721c2fcf93b4c7532b42b263f9fdc828";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d16acf4b-d37e-4e3e-8f8c-73c7eff96bf0/ceb8eee1c24d194d8614f3b0a885e9ce/dotnet-runtime-8.0.0-rc.2.23479.6-linux-arm64.tar.gz";
        sha512  = "7f92e7d5f51d1623e2ebccb79da1f047c4a125b565cedb0a4be3d9deb2010c1f8c03276a926eb9a7866bc1ef9c6585724c41d268e9d2fda8012613aa6fa4f95d";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d8b1d5c7-2328-49bb-92d4-7c3db905a1bf/500d836a2747b281059ff025cac9a79e/dotnet-runtime-8.0.0-rc.2.23479.6-osx-x64.tar.gz";
        sha512  = "50ab2233f01534784759439752312749731f5e3a46947da40052186bd87459fb19162c0354fb9c44feb8e3693b6dcd6d791782f63c86add4179c6ed6f6c4ff28";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/148f6949-ee92-475f-b45c-814139f2bccb/1e031945c3524f31abac2c8442794875/dotnet-runtime-8.0.0-rc.2.23479.6-osx-arm64.tar.gz";
        sha512  = "8c9b86c1dc4fc0c6d5086d3a1f5fd28b38e2d94746a1529f3d9783e7240e067fd830098be81052629253c1548b43f4937cea92370212a556448320e294ef887e";
      };
    };
  };

  sdk_8_0 = buildNetSdk {
    version = "8.0.100-rc.2.23502.2";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9144f37e-b370-41ee-a86f-2d2a69251652/bc1d544112ec134184a5aec7f7a1eaf9/dotnet-sdk-8.0.100-rc.2.23502.2-linux-x64.tar.gz";
        sha512  = "45f09e7b031f4cf5b4dcead240fe47e2e3731d97d22aa96d3a02a087322658606cc22792053c3784c44f15d7c9bad0ac9dbda90def7b4e197f2955dca9a5bb6c";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0247681a-1a4a-4a32-a1a6-4149d56af27e/5bcbf1d8189c2649b16d27f5199e04a4/dotnet-sdk-8.0.100-rc.2.23502.2-linux-arm64.tar.gz";
        sha512  = "b07059a8b6b5586134a63a20c952f4f029372791d53e4a3a1363d39b8beb62b4c7dbc23c7de202397310c79aaaa110d35d0dd5d996420eaed0ed7f77e2dbc669";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/2cb4fcbd-ba5d-41c4-9907-8120aa4b5f23/98fd104ada4105462cefb1123a0df533/dotnet-sdk-8.0.100-rc.2.23502.2-osx-x64.tar.gz";
        sha512  = "48268afc73335c19c96bd77bea49eedd461056b1b640703ebae39b3003875ba0b0dbdc13ce7aec0c74ae842bd01647cd1c225ec555439972f3e16300245a48fc";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6c9084b3-c512-41be-afe5-84e156f250b1/6e1c12684b4c5b95f122f0659f337ab3/dotnet-sdk-8.0.100-rc.2.23502.2-osx-arm64.tar.gz";
        sha512  = "c7f955ba587cb00aa688dbba987acfd4203519da0dc5914ae7e1ecdf8f95089a84402b4d833c7b6186bdc1f70215e399646117242a054c1555087aced61d119a";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "8.0.0-rc.2.23480.2"; sha256 = "0406jvshxa3j1bc7ss9d717ybbjnf5n6260i9ir231nzmkdw4ich"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "8.0.0-rc.2.23480.2"; sha256 = "150ja9f96yw7j4mf39kxa541xkmgzmfjgm7jwdmlaln2v97chsk4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "8.0.0-rc.2.23480.2"; sha256 = "1z6lj26cqf3qg3xhhlp8g8k9q93ysr1j2ly41xwi5sccd2x8vwil"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "8.0.0-rc.2.23480.2"; sha256 = "10a4pvibil5slnca0bzzpf6nbvan219yg6d6srr9hnqwi2a2la62"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "8.0.0-rc.2.23480.2"; sha256 = "1qcmw41rbk56y7l79f9xqli44f8xa7rqi2bnncfngfbd54q3ijcj"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "8.0.0-rc.2.23480.2"; sha256 = "0zq25xvypv6fnyy3gx7ivk41z5nyz89x52bf9ayry3391hc5avd1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "8.0.0-rc.2.23480.2"; sha256 = "18rwiycm6nhm7mz2gk22yaqmq1sdfsvq971li08czyia2lgxk6wz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "8.0.0-rc.2.23480.2"; sha256 = "1qiigv37ikmpbb8j0j2zp1asly13xb8bxj45zh58paycaks01sss"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "8.0.0-rc.2.23480.2"; sha256 = "1f8d7mc4kil4xfyj1ki53yqm30cbpms8v1kxpv3harp5dkkgykwi"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "8.0.0-rc.2.23480.2"; sha256 = "0za8iyskzp7f9mjn8nizz3wjmrpylyv24a70vwavbq0h0h8rplsm"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "8.0.0-rc.2.23480.2"; sha256 = "1vac7gcv8nqyjn4jylfh5yix8282siarbm5dwvnrsw41ngndgcff"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "8.0.0-rc.2.23480.2"; sha256 = "0cx4606hlbi9x55vbd99vrbkmhnaz3dcqc7x3sh3ih9f2mpzv5q2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "8.0.0-rc.2.23479.6"; sha256 = "1l1n2wb374mlwpbk5ivka3j073l8mi89fh92p503iaa47xf95ixl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "8.0.0-rc.2.23479.6"; sha256 = "1xc9hkx2qam19nfnkanm5yvd3iycvw1npql2limskf20qrwr5f7v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "8.0.0-rc.2.23479.6"; sha256 = "06rk4p7p4ypx7xd2c0dxb142frv9w4gv8720j99392rpzrp1qnmi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "8.0.0-rc.2.23479.6"; sha256 = "0ib3f4wqzx10298gd47j6sqak80f6idrqw37crvgfixsggik23wi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "8.0.0-rc.2.23479.6"; sha256 = "12yxilcrlwkwrjiyl72sdryjwh1ilxnqq51zm5r10gadips2rzqq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "8.0.0-rc.2.23479.6"; sha256 = "1mbzfbh023xlx2mghhm2f0d4hx9bl9b09d0lfhvf9zlcxhwj8wni"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "8.0.0-rc.2.23479.6"; sha256 = "05csm5zlrssg94p2vg8zicjxqbx92l5igglsjbwb5dqbvdihz1ih"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "8.0.0-rc.2.23479.6"; sha256 = "08ify83j27lx0pgjkz4kcg88a2rv89bxqd8fagaafqrjw3s0d68x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "8.0.0-rc.2.23479.6"; sha256 = "00lhcw22qfskdljfnk5amfy2j5x8c3mfvgam1s91awh3p4iizx1d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "8.0.0-rc.2.23479.6"; sha256 = "1pmxwyaynv50fp32b4g2nhys1shpajnpc0q43kgsfs31hmrq32z4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "8.0.0-rc.2.23479.6"; sha256 = "0shzhwgpp35vi2y3fvd0rs458lnwn1wk2361x9q50wcpadiv72hw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "8.0.0-rc.2.23479.6"; sha256 = "1w9j05l8n1r40liq6i04cmc74hbxj4p2j04yqsfww6rx8r4ls241"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "8.0.0-rc.2.23479.6"; sha256 = "1j17rgswixgbli421sgd17cfsrykdv46jmd0337mdgxf2xj99c37"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "8.0.0-rc.2.23479.6"; sha256 = "04h64nkpxrkp63p52csb4nrkyg8l1gg6r0m3xzl0h8303w88wwi3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "8.0.0-rc.2.23479.6"; sha256 = "0d84yjd67fpl8j1j9dccqqfpg8n717qvxk5y8mhp4rahfi53zk58"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "8.0.0-rc.2.23479.6"; sha256 = "1q6mqcjj4cf3x1mlh0ca5pd1vglq5i9ci0irrm45xqaz8n5190cx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "8.0.0-rc.2.23479.6"; sha256 = "0l9i4y94lmv9m4m44i1gff6a1s8fhdmznz015yf177pbsymm1kjv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "8.0.0-rc.2.23479.6"; sha256 = "1bzh85sps3i0ga6pbdrcbd4a0knpq0n41pnknfz6fhyqn9xchpcy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "1h36s9sk8dx8dj5g0dkpcnl2g31jbibjal7344zcs6s7d7zjifc5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "1zggzn0z7clh6sic4hja5arhhraaldna4pyprxk88hkfs2h7k3s5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.2.23479.6"; sha256 = "1m8rvvlglivcrqadqjfggrh55c1sm1xyw3fd354v7xxpyd7nsak2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.2.23479.6"; sha256 = "0rr4xpy6l7pm4zqr2faqihx7qpia9w3y81bzk0zn9rs2wa2g3pj1"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "0mdavjwsl7g080ik8brjnxvzvsznqva02854nsba4i8qkrmgq63x"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "0a1pnyc8hg1x6q9i0fg1zp5aip7rqxwirnjw7vshdqacadcr86wi"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.2.23479.6"; sha256 = "00v40ws0qhl87injb20dszay6cz0ig1ralqz0n2v2bymgcdbh1bx"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.2.23479.6"; sha256 = "0qiqj1i4z3smgpza66cpr1ad8ycbbk9iqs150ribwz350ypa5b00"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "0ir0njnhcig7b9drq3qjlid38111h7810b1i8nz0qs1hjza3iryg"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "0x7yvqh099bhvsb5zg1mjxyglf1hahz7w36cvz1x5i4d6z63639m"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.2.23479.6"; sha256 = "0nw4gmjndfnlxaxji31k9llgn6cf4csxzjfpp01qkn7v2wmfl5jx"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.2.23479.6"; sha256 = "1kx93ay2gx48llqd6l4l8ii29im1ilp5axz99ggfarbsvz8iw648"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "0rbhkxhd1aias78dqhyj3h0byw0pj72nvqydsl3s6zzb44a42v1l"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "0dzcdapx5pi24zc2zrxgbz82y0p06s7hg7wh56waa4kbgc7rzfbx"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.2.23479.6"; sha256 = "0crsvb0hdp0c5a7d0mrc3i0dwvlvfv1hw44acf3z832q41py3gid"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.2.23479.6"; sha256 = "1ps9lwwnww8s877sx8lpp6m03kgxgv3bvi9d3rxhfq83yzhawg2v"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "068s9idrwapxsfv169chsdrsw3v74ihhing3x8mvyfwjkswnfm1p"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "1qqphry16s89i7dwnb6n65vkc18mpivin2mdjp357a3jgi2c8z2m"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.2.23479.6"; sha256 = "0m7qph06wxhsw8id1xshyp1bdfk04bdiwfrz3j6ayk6ihg2mw2fg"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.2.23479.6"; sha256 = "06khkpzfhscsrw7bcvq1ag6by6n2296w8ik0zbi5mq2jm5lx4h4s"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "06sq2dsxg1gl3g5g2x9y2snh9xczi09ci90mb4im21x2dd5i91m2"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "0bmhncabzz56r2ac46k1jqsjzgaflvnycbwkh9ksdywm91fcca8k"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.2.23479.6"; sha256 = "01q00rdyg4dby0zvfkzc8sgyn2434bpzfzjxv3xpc4am05n7nikf"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.2.23479.6"; sha256 = "1n55lqdriy3kvxmcg2kfgri6si4avf6hi7hxl3pxi3y7ki2aqgq6"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "04yzid7r8ahscjsbphi1272vwjwy6frz1817w15wwby2szprwhqm"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "17xkhj0c41zwpfxm0yvllp12f3zqvl85kg0kwjjfi6z3v3grw9wa"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.2.23479.6"; sha256 = "1lcbw3yvrm5iha9wjnsvw79nhjcb1px3h5pwhhy3dqcr9l09jnql"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.2.23479.6"; sha256 = "114s3bqv2diclr44mgshpsvybcldjprh40i51ibz7n4i0kf43km3"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "1a068b45d9wh489mv3cnkxk64qb7piqf4nbc6li37mnk5vqkkkan"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "08p6d8h7sfliy3ynzz9wnrp3b4gvdn9ldkyrqgph57kyjgvalk1k"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.2.23479.6"; sha256 = "17zrq7cvbmd89rfyhykllijhdlbb9yf90rfv8bkb3cwm12mxibdn"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.2.23479.6"; sha256 = "0698kzvm0fpgyq1m4h09x3d0nzzf9xvypds1zbn32nynil2wrfi1"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "15wbakil6wmcbq65zdn6lsnslzi3lcpsxqiycqk97s9h735n7r88"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "0vvfd9rw5xbhxvid2qsbssnvfjimjadpckkh1cjh2wwb5phx2za6"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.2.23479.6"; sha256 = "1j6cvvgxjpqzvf81i0daizcr01fxabbvggba1ljsvzn08ky14azg"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.2.23479.6"; sha256 = "1s0b8aphk0yzikfsfd40mnq70x5izx9gwxk3rh5q52fk2h7p8vn0"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "0vv5a04q6k5ch1xacz96dgvj9174fbmq03i6lfj1pkmvmknxwmk3"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "1kwm3zwwijqf52piv867463injdnajx8hhv2bszbl569v0mpyald"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.2.23479.6"; sha256 = "06zl77hfg9ha54xmwqmd4nvjzj1zfpdl3gxw72wqi98w1imfakjj"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.2.23479.6"; sha256 = "0fnx3ig9mx68kwcqp3hqzxys6vqfwc4iz1acxqbs1h0r7k83ka40"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "8.0.0-rc.2.23479.6"; sha256 = "0n54h4b8l7xhxz6vx3qbz7b466dvlc7sjyrw9v4p3axzpgaz63yp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "8.0.0-rc.2.23479.6"; sha256 = "1cyacd6297nm6cw8w0wxkwl06khb4ng94qdwlzfx5hs2gday34mc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "8.0.0-rc.2.23479.6"; sha256 = "15ldwj8r25lric5hnyp0kgj3fi1rzlhbvzr1pyzndhb79kqmw9h5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "8.0.0-rc.2.23479.6"; sha256 = "1r3lssmrxjs4r1qfkxm4hq60n9hzdalv8637fzyrp0gqxd7nzl2f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "8.0.0-rc.2.23479.6"; sha256 = "1l9a6flcj2ysxp0msvdz3p9zj6rc3r8dvr7gngn0qh17nklifk4x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "8.0.0-rc.2.23479.6"; sha256 = "0vds01dh5wzwiicjx9zvbhf9sdn6g22y5vy46w6c8vyr5kj9bhw5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "8.0.0-rc.2.23479.6"; sha256 = "1qza3phfq6hmiig4qy0x14ghcsr9ha69yabsds84fpa7mx2w8xsd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "8.0.0-rc.2.23479.6"; sha256 = "1d106zdvv90z6da6w5lxn31x79hnb7in3mm1c0hxmy7lfs2nx33j"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "8.0.0-rc.2.23479.6"; sha256 = "1bykc1r1ljvqqz6v5qzvh2zqzbiav8983657fn1yn5qwdqrfc19l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "8.0.0-rc.2.23479.6"; sha256 = "0cac6scv56d4l8bfni7nan7jkj6c79c0vipxl3pabdpsyhkpw7fb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "8.0.0-rc.2.23479.6"; sha256 = "0i1wkbi0ld3a8mnk809z1vw9zla0w2b5q1gkxj9p59jgyp4hvgy2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "8.0.0-rc.2.23479.6"; sha256 = "0h70028z3dvvdh2r0v3m21w8zqi4w6x6fcqb58k2981dcrvgfzza"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "8.0.0-rc.2.23479.6"; sha256 = "0y8fr3940y8w4qz2pm07h3kv0gvjmygpij6h0nshkmbvhmx76ccw"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "0mf4vmh7sx8lshrc8b6al3nnx9lzylrz8xklngqnskbdw25a6z0i"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "0z0z98zx7b146lbyl5rhf9vx8sq8qmra0sf9yh99k83dxi17lcgl"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.2.23479.6"; sha256 = "1rs79c6lw9clp735p8bh48wwfiz93kwb8d8dj2zksa4hp1s5am31"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.2.23479.6"; sha256 = "108qga3arini479gpr5l4abgrg9aiqshj2iyyrsn4g39b3k2kys7"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "1fn7hqmlqihxprqkig3kpi7mm7qiqm0knrpn1pj94r5bf089jhyl"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.2.23479.6"; sha256 = "0x45ii2slpfbh2ln3d6bdmvl1dmqm0m282lfk57fxlp89ra2n37v"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.2.23479.6"; sha256 = "1ph3lijgmj9n1ah1s88h4509l20ljlylzra8fl2397nrk5nampnj"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.2.23479.6"; sha256 = "0biam46326xx3f07vbz2pa0xvcs6j7v6hy9sdzvvzjdlbr2vkxch"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "8.0.0-rc.2.23479.6"; sha256 = "1ln1sqw852h2aamksl4xbrxn8rpsf9v0f302nj86rlnkcd36nvgg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "8.0.0-rc.2.23479.6"; sha256 = "1vkdzpsma3h6fkd2q6p7igffhiih2w33mnmihjjcqyg0abxcrisf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "8.0.0-rc.2.23479.6"; sha256 = "1c9c4sdz7ijywj1h2lrqh0g66kwphawh9wz4n1liqdc8iczq5s33"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "8.0.0-rc.2.23479.6"; sha256 = "0c6waw5dwkj0s9l51bbgk1m31a89a6w40m7sq2h4my5pa0fc646p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "8.0.0-rc.2.23479.6"; sha256 = "02ajhidm312xy397rmw6vvwc84jj59gdv9qwimhkwj3jli51cc5s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "8.0.0-rc.2.23479.6"; sha256 = "07p2gz8j3pvq6fj1ikp65hzyhw8f76qbsap7ri90myhzy92cfqd7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "8.0.0-rc.2.23479.6"; sha256 = "11wdcm9wf2674l3pybv83pi95d7103xh1psq5kkx72zahwjc40sm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "8.0.0-rc.2.23479.6"; sha256 = "19v4j3p17hdadgsc6gzqb86iy3ndrkslqfnyvskypcczrk4d272z"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-rc.2.23479.6"; sha256 = "1rl7n1v9zv6fgxv4g8jrm8b2siic8bglwwylacq9mvmfk4ckcnd2"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-rc.2.23479.6"; sha256 = "1gc5ilas07492zc5fb5iqrhhas4mx86xx3ga7p1dwgwlmhbpzq6l"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-rc.2.23479.6"; sha256 = "0qb1rz9qxdjs9ig68chxxjcgnya8aff4c0ipd66afn9q1k7faw7r"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-rc.2.23479.6"; sha256 = "1fipxybzd7vah2y5rndb5kpn2n8mqcizp2m1lbi4fwi4mlmc6mqf"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-rc.2.23479.6"; sha256 = "0fgfvrxz02p1w1i0s0a5i8xq1cvd4l9pj40m1rj8dr7b2sck45xy"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-rc.2.23479.6"; sha256 = "0yhql04nzmfawp8qy5m2byx2b768vpf0lj4l88gyjkblpacr37hi"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-rc.2.23479.6"; sha256 = "0mmdhddwx8xa1rspcmfakiv4lyk3h8y64yizir252r2pf5knh40q"; })
    ];
  };
}
