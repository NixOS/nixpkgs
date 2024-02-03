{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v7.0 (active)
{
  aspnetcore_7_0 = buildAspNetCore {
    version = "7.0.13";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a4ac0f7a-a65f-4222-bd1a-c1a94f7df32b/2c62b82c325a8c396db10f09cfa952c5/aspnetcore-runtime-7.0.13-linux-x64.tar.gz";
        sha512  = "930c83d7b553529f37b1516848f64ac5bde479bc5dff5e89edaddc4f7b552924f9b51b58367df8cadb9055b4a7220bfa5a4d39e09fb6b51f4bcacf3b82416ba3";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/53990197-c340-4514-b12f-a6c6580cc1b8/c25e55e6e23e7bc94701dc982525d66c/aspnetcore-runtime-7.0.13-linux-arm64.tar.gz";
        sha512  = "a091c7bc7dabf944ad2888908e8becb0b9ed6a8f3f0475c845559804bfb35d6d76fb81ecafac4d9a589b64837258304d94d5c412ef8c75e138582072081f270e";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1858183b-b0ae-4866-86b9-af2efc7bf05b/d69c3f2f527c182a841c7233dedc496a/aspnetcore-runtime-7.0.13-osx-x64.tar.gz";
        sha512  = "d635ac072df5f5cf587470c656b6a55e880eeba2f00c12cb6e239d7cbd0a52d92b094379de80ff60fea426049d96e54e095417f089890eb92630d3c07a20a67e";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a7823689-d818-4744-8bd3-fef504768c3b/7160531d6f935155772e4b0d4a0e3b78/aspnetcore-runtime-7.0.13-osx-arm64.tar.gz";
        sha512  = "6734869eaa22f163d8fed52ea3b1f11f22ceb0876337114a0b9927a96e4fb82f826b6ddea3dd7061ac02da2e13c32c9ae6c946ca5ce53007869a97c0cdae3f94";
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
    version = "7.0.13";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/084709e8-8937-4c46-a361-28212cb2838b/4c5d7393c6e79f816a1591264411c22c/dotnet-runtime-7.0.13-linux-x64.tar.gz";
        sha512  = "00a0b9c101c665ea9e751ce645c68840b02450c4a9f268149e6f59da1f179e85f0932475b8a72162b5271fdfe2ddc88eb21d09aa78bdd7dc285983445503f758";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/08f8d331-b20e-4400-a1b9-ddd7b4977fad/b162a6c808f713914ad3ec65f88521d9/dotnet-runtime-7.0.13-linux-arm64.tar.gz";
        sha512  = "e3a465923ed3325f3d427a4737e0e23bfcd549b1ad2c2374e65a3d865553790e644a57a0aef676893050085a389a846737ce6ddf6f2f53e7bae7d3f6253c06d5";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/30e43cae-eb9e-4d8e-b1ab-bcc4773f9fae/06137966e03cd705d55a86e10d8a6340/dotnet-runtime-7.0.13-osx-x64.tar.gz";
        sha512  = "e28407e6e466ce8708a9648e59df6b574da5794c61418217edcbcd068bb72086761a7a9f09c3c35cca3f7bba9c8aac28c8cb6b64b6fbfefbc3016dc1f6292ab3";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ee9ebef3-f459-4337-bd45-521c818fae52/58efc8c2ea98c0fdcd8ebb15700a0565/dotnet-runtime-7.0.13-osx-arm64.tar.gz";
        sha512  = "d0ebff0a46471ae1450de439b870b775e88901e05d3716261371e2283b5ae469bc03b71f545d08839990e7473517bb583bb6174215e412f10d873c9de5972f06";
      };
    };
  };

  sdk_7_0 = buildNetSdk {
    version = "7.0.403";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ff8c660f-ffa9-4814-ac2d-4089e6ec4eb5/dc806d344844f1d58d8015d105e85c65/dotnet-sdk-7.0.403-linux-x64.tar.gz";
        sha512  = "2e96fa4ee32885a4433be12aac0e10998f9e7f0fe4791f33cd31966c0e0d345d978514787a36c5f0f43c7754e9639a5d52fc96c9f44cf56c0cfc9a8ad2620dd6";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/558bb19a-c08f-4aa4-bcbc-481e9b050031/4de7724688881c9ce6f0e5cfb8a2acb6/dotnet-sdk-7.0.403-linux-arm64.tar.gz";
        sha512  = "0980f3f888f1267a5dee5c916ae8d0931f0c6789f1e7334fb7b4d5ab27a1876ec014d30be8977d314e4aa7302b197dde09ed39cdc5ed84b366307148d5350deb";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ff4be5da-8947-4b41-ad0d-84c98bc6d36d/4a20953b6b2aaa5ffd0f0a37e723698b/dotnet-sdk-7.0.403-osx-x64.tar.gz";
        sha512  = "50a38d89af656ac5a3110761182c1b8b6ca15821eb4fde8d0eaebb6dfbeb4c9046a80c00004cdbdb4e5165c6cca1f2c6ef0ca5ff84fc9c32b4c298a9f620bac6";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ac1ec933-8265-46e4-b725-5843d483aba9/f41605b8581d114a5131f7761f703a20/dotnet-sdk-7.0.403-osx-arm64.tar.gz";
        sha512  = "6083b9f469dccf097a6a1bd4a264ab5438bce653ceceb54cfba25526845783e43e57e6b57eb6c7b4157108d9572ca62d8df2ecdbc1a0a36d9f08310b9bb3c9a1";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "7.0.13"; sha256 = "01iggc6rxg20min4aa3x8v1baqr9qikf99nal80llyb02fq265hs"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "7.0.13"; sha256 = "0x760p4jx5qydsljc2d5r0qkvnghv0axzcpgyzm8pvbfq1kijrj2"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "7.0.13"; sha256 = "0z2qsiccm7hkkdxd8l9yp9ykswggaykzqawjg51wxh7nq5rmz24y"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "7.0.13"; sha256 = "10nks106xh2c6w352bzamba8ags8yvbwkiiw0mj5imrqgi0kvd52"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "7.0.13"; sha256 = "012xh79xc2z79jmqjxmgwjw8pbg1my8v12glx3dm3i5p7syccfq4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "7.0.13"; sha256 = "0nnkr84pr5zrds8mzf8jkcg9aj85ssjybdqj5khmmjjvailljjyn"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "7.0.13"; sha256 = "0jan2ajrdmjgxc4hlany11rmsz6pipn8z10jxl6jrab4zb7xv0jk"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "7.0.13"; sha256 = "106ng227iyydd5sv0b7w0snibyxvgrq8z0jivfbydzng84ijpwnn"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "7.0.13"; sha256 = "1kw6jdvlssj9bpg67lx1xmwpiad1krpldbbab7f5wyq6yvchd30d"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "7.0.13"; sha256 = "0411abg5ay308zgw34p0jdim6n6913mgal41azph3wqakw3fsiks"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "7.0.13"; sha256 = "0rm0jsznzbpp6r8y4hgcy6y1x6460hb38fdxikbbfnppinpdy549"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "7.0.13"; sha256 = "1d2p5phx9rsi960nji298px9idnama424vipjv76vknc4j7qbsvf"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "7.0.13"; sha256 = "1blzmczw1hxxfsifh95p9xxyksyvkgyp808xki2ylyyi69dlz5s6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "7.0.13"; sha256 = "096r8swgq0iw4f7bkcjz85b43qqdzfcsg4qh8xkk4nrfkkilwycw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "7.0.13"; sha256 = "1rfgwi1gr1jyym50yvcw295v3q2333jqfi42bain0xxq3fa539j9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "7.0.13"; sha256 = "0d410mpgv8y0yj7kixxaylw5j2b8f9krravcq8i5zpdbxzjbzxrz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "7.0.13"; sha256 = "1rkfpifnc2n1ijgxpb86rraa7jyl8mj1w65lpwhw777wk039vbz6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "7.0.13"; sha256 = "01miqpbazjc1hmyl9w4shnig3ijga4ddbyjmhr98sin6fkrs4797"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "7.0.13"; sha256 = "17a0lzd7zhvvvx0dw79isri74nhwhdi8hdiaaz9svl03pbs7gybs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "7.0.13"; sha256 = "1d7placw1v8i8n3bq687nvvckq4jxz2kxqj9q0q7nlwjzl3vpyab"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "7.0.13"; sha256 = "1kwy9c5q95kpf1xs2v3mir7qzj1px8rgv0bvlcw3nn3k7bwk9504"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "7.0.13"; sha256 = "14cv63fa1bzlvjfxicj6df3ay0df59a77rmyb0b95582zdm51hyy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "7.0.13"; sha256 = "1c5l1q53k8vrdapk3iafc1njdp9y2lqsyf8k9xzjhxkx2asr3gsb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "7.0.13"; sha256 = "1k6hj6k05gkgbh1pspvbdryzdxchfs6as6509fsm1rp8s327fh33"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "7.0.13"; sha256 = "112nfx12kz48v5izvqbkiv74r4n7293bdgkwcyvbf5nzmkkm49v3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "7.0.13"; sha256 = "0yw489apwhpr36m0450f88ximlj8hmfx4m6fdscxfy7bl9az4y3r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "7.0.13"; sha256 = "1kmwsx7d1pf2ayl44rja1fj3qpd8valpigly9hzv1kgxbq95wp1d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "7.0.13"; sha256 = "0w8iz1qm9lxsfy3vdgq6nhhkkasmdqpp2flbawr4w4z0qs082mp5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "7.0.13"; sha256 = "04rfjbqr89dw631w541z6h1gi7lk7nx6cv25p789hv4289qnkirw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "7.0.13"; sha256 = "1b22qn4j8bdnm8i4mz544cazmz84bxv2xc6cv38qz7rw17fy28hh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "7.0.13"; sha256 = "1bsrfvp7gfga84ks48wjjc0j0y4gsvzp4dmw4xqs3y4f8wc1f1jq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "7.0.13"; sha256 = "04xwjavsgxyhmiq6hw0sb8lcrpsmcfjqvg2i3qgaf85rcy8vsqx9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "7.0.13"; sha256 = "1fwj19yg50j4mkd58b0fg440a939vy9lzfyyx4qapssba9wilv5b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.13"; sha256 = "08y9k3kn5lfdk11vlqnsf87vvl7vi8w2an8mpll0drw9yawf2zws"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "7.0.13"; sha256 = "1j4m58i3dqj3nivnxkh91ic1q0z0visfi9r9aqzf2iwmq7njsxgx"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.13"; sha256 = "0km9sjb6f1s88y8v668wnv3lkls3hn5lrgazagmwgs0hw6x70xpm"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.13"; sha256 = "0swj57pqrh3435s8jcqci86ifkqhf977ipgmsqa6l0dz365nchl9"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.13"; sha256 = "0176s7imvc1fg78xmjxznv7jr99p0nxsariw48axpm6c5fqv5hhx"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.13"; sha256 = "1idvvmbqwg16nxkyblrkxbrbhrz8qwfcw5iyyjpylkjkawklxrc4"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.13"; sha256 = "1gihrv3yny5s98sgsaafgfh7nhr4yw7biyz6kqxi8hbwnyddsx8x"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.13"; sha256 = "1kdywv9r7ij8krz65wpyj5pfffhnqg6s7n2s1bhj249x0ggx31lr"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.13"; sha256 = "0xpiqma99vqq8i8v6szrqxj056sfc1yjwx16hmm7bl30b1a0vzh8"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.13"; sha256 = "13w733b4pxvani3b3yxdpq72jfaj6amvqzg48zl44i52lrbi5a77"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.13"; sha256 = "06j19xdcpw867qn8bfwsafadb1nxzz1wyj2d19dzvhxpxj8vvia5"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.13"; sha256 = "0s6kxlwkwvb3csgibsm8rq30k3mf2vr6qjx72fzzhkw20b1gsazr"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.13"; sha256 = "0mhkylq4mhgm82vlicd6fxrmq90mm6a58k1xjpq6njmzmdy6485l"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.13"; sha256 = "1fs15j6mzn1nx3kjzz47b44sz45vbfjyr34xfq67sh7frba5ka41"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.13"; sha256 = "0p1dhgw2avg0gqy99ykpdzx869rhbbvca6xk9499vyf7sam4k6rr"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.13"; sha256 = "0psmzbjz0pp7k9mrqxzlwhwbr9yxwfnn08yj54yvpafxlwyka413"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.13"; sha256 = "1qgcq5qfhnaxrmcipd4jn8cjy2lm0wf2z82xqfnsamz4p4h0ssln"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.13"; sha256 = "0lk9mlgr3mq5ls6llc92vi7k88wv35x58s80f4gix04dal14jrx2"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.13"; sha256 = "1h4x03zk6qj9pg68xcfxvjg971z7jfhsk0a10wa6iavl979bnyhg"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.13"; sha256 = "0a3dl5laq2zwl5s5gj7lf18l3kh1k2h9x1myfbw8pp5g5pcq1igp"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.13"; sha256 = "0zn7myvbcqrgi4sfcwjxfqd5zhfqp06zzjl3383a8xl2679qf0jz"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.13"; sha256 = "01jqs98r0xazngnrdz7lq7hk047laafmwd8d075k3p132cnafq3y"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.13"; sha256 = "0jjfx2xjcg3kridkdf199yaxcynhglcjq9j5v8z5jlhgwxqy9v0f"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.13"; sha256 = "0gvwiljarc0fgd84gb5zdh4550nbzhd934aba2c4jl5wl1773cla"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.13"; sha256 = "02rv25ssljf5b8jhs8za6hbfh9nab9lk4yfpp7na7izgm4lfaw3w"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.13"; sha256 = "0kslp81hsmqq6m6sa5hdrfch8scw130smn2jixrjqhqx5qvh1srm"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.13"; sha256 = "1wv5xxmygp4spdpzq0g2j0rzr3jjrmvi930gfl4hfpwd9mqmr9qy"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.13"; sha256 = "1r893njy0lr89as72qag659cg4hq0w1r6awby45a3iiyzwj6nc70"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.13"; sha256 = "1znngzk9jlrzq9vmd5qghaji8brjbbyqcg8fcina0gwq427rcvr3"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.13"; sha256 = "1kwfa6637bg7gc6f40aivqnq1g6cwqjjn3xlxl02bsghcn8z16l2"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.13"; sha256 = "0vgql6x47b6fzr4zr6r308znfnrkafp7v8q8f0i7ma23rm38dmjf"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.13"; sha256 = "0gsjmrnrk5v4pp14yzqn0q9lwwlpdlbsb3py626q9zjhlabqz524"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.13"; sha256 = "1z3bnv9892bi4lp08q5i29xiyra2d38dg7ai1ar4cc4z7vphfcw6"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.13"; sha256 = "1fm1y8cdfw30iic0dx3f98gziw0bn4ya0af2g79r1p21arki2lck"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "7.0.13"; sha256 = "0a1ckhf994dnyr8llabi2za8chgzc2pi9kg5kxd4gvah0l4ghbzr"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "7.0.13"; sha256 = "0bxxahlr8xsmyq2n59d0wphrvi0b2qlb2j085mx56zhysj9s9drz"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.13"; sha256 = "0gv0d0lrgbg3h5ldfqyginvi7hy38fpz6573f3r840k0cz5f8m04"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.13"; sha256 = "18s4pdmxv3rwlsr4ygfjs1r6ci4q4znjx0vf5r7n4fbynscr31pn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "7.0.13"; sha256 = "1na7w99yqhp6h6m50fa020fi9qldjwbdp2k6b2dcfw0lfi3f0dl2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "7.0.13"; sha256 = "06cqhkkv4kysgsd31r14axvav3m490lhs5b4mc2ssc4r15g0ym95"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "7.0.13"; sha256 = "0y384akvxkdqij1ywlf2g8afny5ss5wgpfx18xfd0nmcpxbl4fa6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "7.0.13"; sha256 = "0nqqqdkvk3xfjr009kdn30900wgrj2hzpzzrpga7y7c38nlpmsqi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "7.0.13"; sha256 = "1ip83wmb7ldfl02261acgm29ixzv9pxxliddmw3asp02ins45x58"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "7.0.13"; sha256 = "0b8lydw8sf6bcvg5rcvwl8a2x6lwama30h9nc1clsfhd5vljdgzf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "7.0.13"; sha256 = "0jhgwkw13mm744vfz6gbhajx9kajy9n4ph7kykqnnfmz1n7w6ryq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "7.0.13"; sha256 = "15iz2jmlk445193jz9rifc86fcz801x0qg2ikjqxnj7dn1zz24rr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "7.0.13"; sha256 = "02lfq0ifxclr9af5ndfz48ds17a1m8g7a29f6j6m1qhnil29jkj5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "7.0.13"; sha256 = "13z1p7w98gsj1lrqq14p2xjmgj0lm5xl2yqacxlc60gsb91f40s0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "7.0.13"; sha256 = "1xb96ch2k96m48nmgwisk9bi7c49ix3di7yd9zjqci3gp854d8ka"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "7.0.13"; sha256 = "0wj0vv2c0wx0p5wxkcr5hdbqdp08kmp08d7r2rjz6jfdd49h9i7m"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "7.0.13"; sha256 = "1rrgksmcz4fpzwa8yiahk3wdyg7xnng6jmm3kvzh15y4mw8xir7x"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.13"; sha256 = "17f2pgpp560m1pr2n2l4h0b8zbpz8p6nvqigp82k1g1ys95qbhdy"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.13"; sha256 = "1ic5h46g8cskifldj1b8rgzfzkc1scygrqpmw00xnncp3kzwxkl2"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.13"; sha256 = "0crxk42iy7qm13bcpd8ra6kdd3gd2bg88vg5ky9czbm0di57w17d"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.13"; sha256 = "1h643k0g83g3yw8p7s0qvsfpqagp75f98x008qqrw127li716y8g"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.13"; sha256 = "1svvamildi5sw88jllrl0qkb7pdx7g9ccp53ly11lrzls2y1nxc2"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.13"; sha256 = "1q94dzclwp30g3dvw6681djz4pxz0mr2i8w8yb43ikcqm99k6y2n"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.13"; sha256 = "1vrlcqfaxdhmd79lry7nbqa8023vs7zd6728c16rjlkiq69r9yjv"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.13"; sha256 = "17da9plgd1jbdfiqm000xg0aj2c37h8qmm23k96sdg8kl5dkfl2f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "7.0.13"; sha256 = "1cplbbiib4h7x5g0j79ijkj4kvw146vnqrmp7h2pbk5912mprzi8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "7.0.13"; sha256 = "09s2ykhprx49iwqv2bnsa0nvfvjj6hxh40fy13b90kcpkw1d4vjw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "7.0.13"; sha256 = "0dfmwfqb57k5j2b2s4ysg3hm0hzswnrjxilglxcr1r8irk7gr5i3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "7.0.13"; sha256 = "0sb24snynvr1bsrhgy4x45z1rjknjfpfs80r0hkhxj184scqakj3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "7.0.13"; sha256 = "02hhkhl52cpy3cfl3yfjpyxm4bgkmv4yi2y83fzfrfqim44dslx0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "7.0.13"; sha256 = "0g4bn4kv87rln4yjl1igz0mi8rcd90ws1jprn1aqdcxzqqzapzjk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "7.0.13"; sha256 = "0hg6y7fd5kx3c6adssxqmwgr606l9h8b31a282lvsw978dmbybj1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "7.0.13"; sha256 = "1xxd33h6gn2xmcgv5g8q5c2l3gp77pdf1b6dzvfmwm9xnq6ms3ci"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "7.0.13"; sha256 = "1h98p62vh2f5hxziznrd6lljg9p9rc5v72rn6wj1dpgb97zr535r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "7.0.13"; sha256 = "13dd70r5y5k7zniwqzzicg5n10kjjb7an02irw9vxbzw35vhn9nr"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.13"; sha256 = "00gyzw6v3npfppkakq78s73si75jgxcgssz9zwccd8gpa3rg82m9"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.13"; sha256 = "03l7nwkx12k3h883x4wnpnkxwk2h2y44c9z96a5f7xm73idfnppg"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.13"; sha256 = "0b9cmcc5cp6ays7qvb22s9fsw7mmfqyvn7krh7ywihap074ddzrq"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.13"; sha256 = "0nn2advczdrnjl0nfl877876bkimwbblr8wkafr24fjkza7al4s9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "7.0.13"; sha256 = "102rlvqhzkw74gpfn8zip1qwbkpbx6mklgxfis874d5np1x1wql2"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.13"; sha256 = "092bgrnwpzk9y0ar9xcd2n5j8ilba3f7l296n3hkvgz0mmzihc80"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.13"; sha256 = "1p3x1abm40kwqaxhpp3xszpg39hmlqwxw5kml1jf7drmnij79496"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.13"; sha256 = "03l6ykmd3q1f5karl4njbb6977hymg2zdsb6b590267czfh0xap3"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.13"; sha256 = "05xyp2f5fp5j75k6c4v8lp0clq66mbxrlc5l0lja5s502cypvj83"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.13"; sha256 = "0gzsb4hhk82dpwilaiwin3qgp7mj2jhxa7ync68a4m20x1y5d5vi"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.13"; sha256 = "0cbvq87q4pdyvawxq2ix1y6y8mminx9kl6g3nxfmp7ss20qd025f"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.13"; sha256 = "1vn2pv1d0ir01zga0bpahhzmkn2lr7m0c5bf0s1i92acsq0z9z21"; })
    ];
  };
}
