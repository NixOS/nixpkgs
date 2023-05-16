{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v7.0 (active)
{
  aspnetcore_7_0 = buildAspNetCore {
<<<<<<< HEAD
    version = "7.0.10";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/08af0433-9ec3-4604-9d1c-85e3922a4524/396b340b4ee38765d7462e2fc61a5e3c/aspnetcore-runtime-7.0.10-linux-x64.tar.gz";
        sha512  = "580fdda88824bde6b2d5c09eb009fef64e89705a8aa096dc71338a549969842dff8d9f6d4bb4651e60b38e44ed0910ec18982a062b471ace18c2e22348de11ab";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/712946ec-0b43-436c-abfb-3abab81f6cad/c83ba8df4dab39957ffa5e93604f0b32/aspnetcore-runtime-7.0.10-linux-arm64.tar.gz";
        sha512  = "83d3fc657328f127ea8881844dda2f91fa03f2157f5c76acda64cd091e430fa7d812b3984b803ac624b171f18a5eab3c7b5791a02baa68eddcaf7498709f982d";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d10c9d59-a624-4175-9069-4a13fcf9a1c4/427bb8da02c7907bc2f3115144c1515f/aspnetcore-runtime-7.0.10-osx-x64.tar.gz";
        sha512  = "1f1fbfb0851d62538aa6feacb5c38c14289e7b2d19be62c0e240da6d3c9336f3223eaa2f3e64559e6d8f599a33d9f8dd3d138998386ee9532854139b3275812a";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/516a672c-9216-4592-be66-a628a166b583/fec0aa593bc700a5f5d3860abf1a4af8/aspnetcore-runtime-7.0.10-osx-arm64.tar.gz";
        sha512  = "95c987c38b80b1083016ff360c957ac4cbc2aad406f87095f7350704de8b9a23ae060e551166c396cadeb54f39f176d5a1bbf77704edaf0c0a308d87ca29b838";
=======
    version = "7.0.5";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b936641a-57d6-4069-bd32-280020863326/5793e00ff9e9973a01ca735479ff15b3/aspnetcore-runtime-7.0.5-linux-x64.tar.gz";
        sha512  = "859d48d0f29e014d56e89161d8001f75b3b0b03ee04f86641066570cfbe267b06798232500a86fd7bc31edf022097278dfeb496874778fead4476863aa994928";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/565ed9fc-5ae5-4168-b08c-f4e39acf47ff/f5e3c6cc872681c08ab9aa6deb8a72c2/aspnetcore-runtime-7.0.5-linux-arm64.tar.gz";
        sha512  = "2c35feac6e8a55185767714eca52912bafe5c6255cc0eb0b93aa245255e405ad1076ae018b7a3cd845b159bc2d87d950ebf5305dd52b1215adbb35ea9cfcf551";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b707a1b6-7222-4929-96b6-3525f93cd79e/dfa98874e490e3da4024cd20baca4a22/aspnetcore-runtime-7.0.5-osx-x64.tar.gz";
        sha512  = "69c473ec116de84bd5cfc27972890f545952a83deae1c3d298152a2dac892f1a70b0a3e10269bbd332fa8d95f2616052f07597adf9279a0d2d2ffad7382602b2";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/dfb4f870-e416-459f-bdf5-5362030c6d5f/fb888174a31cea86516a95f60ca8e65c/aspnetcore-runtime-7.0.5-osx-arm64.tar.gz";
        sha512  = "855ae3cad226fe4429073a54825ebadf2c3bff84ef811d602f4d4f259663d6648b7b0d3e1683e50ec5caf82417ffab47599a928cb635f2149661731cf27ff698";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
<<<<<<< HEAD
    version = "7.0.10";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e9cd1834-1370-4458-98f6-d0d035dcd41e/6d2ca4b900398e717287ad0e75eb9a3e/dotnet-runtime-7.0.10-linux-x64.tar.gz";
        sha512  = "f15b6bf0ef0ce48901880bd89a5fa4b3ae6f6614ab416b23451567844448f2510cf5beeeef6c2ac33400ea013cda7b6d2a4477e7aa0f36461b94741161424c3e";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/023e4544-e6f6-4d2a-ab91-ff63eff97db5/26c02c09fe3a5d57248caa0a0d9e8254/dotnet-runtime-7.0.10-linux-arm64.tar.gz";
        sha512  = "e90b68b272d5db7cf8665bf052fb0300d50a69818d70675442dc891654d140f7f84527b849860589bf152de1d00aa55dc15ee32f5678d46ea0069210fd002b03";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b6caa3ca-cb18-4891-b188-aa661741ec01/5df34b59b10e79714bac97cfdd6e86db/dotnet-runtime-7.0.10-osx-x64.tar.gz";
        sha512  = "6b992fbbc673d5005f2412839c632f772f6576c9ff95d44afaca478a79597601b306e1f1c496836549474a2c35238943ba27eef5749b1a2bbdd8f36553ad145d";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/fd4660d9-e747-42b7-abe9-eaedff0356ca/8a6f41f5ee23ed510c442d1350bda8d3/dotnet-runtime-7.0.10-osx-arm64.tar.gz";
        sha512  = "f578e00d5bd144c51e5d71adbd8e0ecc97f7e8ea06263c585785b41ffbb590537f5a18b63a78e45e90e798cd66fa45285059226b1904f4c2d4e2ea40c2c71bbd";
=======
    version = "7.0.5";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e577f9c3-cf57-4f3c-aa2f-2c0c9ce7b9c2/16911adb0b0ac64ece205a8cf96a061d/dotnet-runtime-7.0.5-linux-x64.tar.gz";
        sha512  = "68014bdbf55bf455f59549c7d9d61ccc051e09fe74a975ca6b46d3269278d77c9cd167ba05760aef8ab413df4212f4f5cebdd1533779b49caf517eb4ec50cce5";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8fc09c26-b0b1-4f26-921b-c1378547768a/04088af0b59a80a1fe1d613751d0a2c8/dotnet-runtime-7.0.5-linux-arm64.tar.gz";
        sha512  = "983b8123db0ecddee10c00c455c740e24793c3a7d1d400722cbc6183ca9a8916404d81dde07e43b9a6b1ea6ea160055b871845a789117ddc023eb07f3685f4cd";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e4242cbd-90b1-4fc0-a8a2-44cd251450aa/3d811a2e1d73cf59d077a63099cb8189/dotnet-runtime-7.0.5-osx-x64.tar.gz";
        sha512  = "4053c79ef80dae8f8ae1958215def910490b3c754ef088f02c81263c790eb8658f1845de916827755d62af37c6d090d59c9a2219c961a29b469a7bed74ba950a";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5a4664cc-7009-4b8a-9e6f-e3ae0b2218d0/add2992c737ce7bb70298fc030c84ead/dotnet-runtime-7.0.5-osx-arm64.tar.gz";
        sha512  = "2bbf02e8001b700cf6badcabedad148a3b799ad0404b2e1e17bf80eca5eaa7a7939df135898f2aa5ebe7892f09d6fa7840118d3f360c2f4aacceb2cd8067c15d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    };
  };

  sdk_7_0 = buildNetSdk {
<<<<<<< HEAD
    version = "7.0.400";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/dbfe6cc7-dd82-4cec-b267-31ed988b1652/c60ab4793c3714be878abcb9aa834b63/dotnet-sdk-7.0.400-linux-x64.tar.gz";
        sha512  = "4cfeedb8e99ffd423da7a99159ee3f31535fd142711941b8206542acb6be26638fbd9a184a5d904084ffdbd8362c83b6b2acf9d193b2cd38bf7f061443439e3c";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/16b0b1af-6eab-4f9e-b9a4-9b29f6a1d681/4624e54b61cae05b1025211482f9c5e9/dotnet-sdk-7.0.400-linux-arm64.tar.gz";
        sha512  = "474879abcf40d4a06d54e02997a3fb93dd10c8d5f0dfd5acbf7e1a6f493a6d3421e426431d512b482c62cda92d7cda4eddd8bab80f923d0d2da583edaa8905e8";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1a603c4a-7e79-44ef-8e09-426a2c1c6e60/eb3dea0e50d73fbf28edf88aa8378e38/dotnet-sdk-7.0.400-osx-x64.tar.gz";
        sha512  = "e705c7466c9aa0c1203e0795ced23c6b794285ef60c8f7e1d199a09e596c20180901c2ec9c24483afa6302afb46a6b87ce18533283e2223a2161776f25421f61";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3df92af2-c066-403b-ae65-10b7ec879b32/a4a5a807d92510d5b74ee8fef9b2babd/dotnet-sdk-7.0.400-osx-arm64.tar.gz";
        sha512  = "134f764680336481a67ded13af8f9ce9e89e29937c7998d8e6a3695593dd1246b8d9407649f125032a3057c138b9739aef3bf8e3acdf0220224417c2036bf159";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "7.0.10"; sha256 = "089cpjkfwcwn2ifzbv4dspm84drcn3r3ck9mzxbyyz5vnvppbd0d"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "7.0.10"; sha256 = "0jfy3kjb7q8dsm8k3mnm81n08zfsk0ifjj1i40r71yglfsp8xkzd"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "7.0.10"; sha256 = "00lqqp5h2f4kv6l7jy5zs8l9mqjrqziw86kyf4fghldcpb2g7nmk"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "7.0.10"; sha256 = "1hcxbb0s3v510c64i8jz3dmszvyjyisrn4m3qvnlx6cjcfwpgy4i"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "7.0.10"; sha256 = "1g353xlq04fr7vwm6c4xzpi2mr8w544drch3mh8jz3bpb3km1ms1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "7.0.10"; sha256 = "1mjg5i643dbzkan6bi9b32w1csn24cy7c3zdzn4i2d0jzmfnqzs8"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "7.0.10"; sha256 = "1cbhjqzl836qsagc6lb63vgc2qp7kmi5bdhr8p9spm5kgixw905q"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "7.0.10"; sha256 = "00n5024l9nh3pvip7xc4zrqrfj7yfnc5lr3crv4cyzf513cxi13f"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "7.0.10"; sha256 = "086lrqyd3csrczmi2rwn8hfjva11zmxbs56kgz1hlyyy34007bgc"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "7.0.10"; sha256 = "13kj7b7h8pigcgkmzqzcg148bazxw8440lr7srz27prfkhlj4h70"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "7.0.10"; sha256 = "0dvajqgfb4pcsddgsb6adiaai181a4rfw3gii8nlr9alv38mr1bc"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "7.0.10"; sha256 = "0d3fywij0sinnn4qxjyn9b8nvhmw06c3nqk712f9b4qz6wxhlv3m"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "7.0.10"; sha256 = "0gs7qbwwlp91hb35x2jhr0zpigjpib8bhp9gwc4hfprw7f8431b0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "7.0.10"; sha256 = "19h0cnar01w5f5p50k02z5a1mv4m7ixwaq7dpmb7y4dca56mjx00"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "7.0.10"; sha256 = "130jg9r19dchk8xmxbspcyj8zl3qvikz62ck4bql2biv362alhqn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "7.0.10"; sha256 = "1mi0xmscdix325hzxmqrv3fjnxfanvby7qpq1a3kkkspaijsrlrv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "7.0.10"; sha256 = "0c5rwllrvzwybz47r6pibv9r0bxmx9yplxs6ki0zl8gcx0rvxfzq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "7.0.10"; sha256 = "1nkjw5aw38aah1w750vi5bjvly6c0303nydjfqzwc2ws4c71qdln"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "7.0.10"; sha256 = "04hcs6bq12zqnijp15fwwiqxz447bnsz649h77qvl11hsnqp7k8h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "7.0.10"; sha256 = "0ggk9zlb16pl2126n78lq0j25z8z45wvhb561872mdy8y29hkb6m"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "7.0.10"; sha256 = "1h8wajbb2dz6ms510v8nj9bp5zx9j5vkrs6yv5amyzi4545fd33a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "7.0.10"; sha256 = "01y8wkqjnl6z5dmaz74iw5vgk6jjs9vd7kap6k547irbiy9svhxm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "7.0.10"; sha256 = "18cnvbdgzcm2wg361pwsbzymn8n6lsip9gqh52wcjzf9sjwd177h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "7.0.10"; sha256 = "115g0igv91ysnhsr7pvspma6nyyhjylpppm7aailqn4w3kz1c54f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "7.0.10"; sha256 = "1q4xfaszjwrrvkrnhagmihlixwqgdk28n5wggn9q6l82md2va4ri"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "7.0.10"; sha256 = "0pw90dlbh9pnry98ryr100fvmxrf1ry6y28zjhvga0ig3ql8yc51"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "7.0.10"; sha256 = "11bd713na563dvp10qm1haj4mr4hdhh1bqg8bimfjcgns858pi96"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "7.0.10"; sha256 = "1ldz6gib1hzpbpkh1j48asyx2w73bw1i6chxg5gy5fvig1syajkc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "7.0.10"; sha256 = "0salk1da71sqr85kbqzprjjs1zqfrdfq1fy9il4yajhhk6py3ql8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "7.0.10"; sha256 = "02kb83ipvynf3qd5sb4dwcv2rslngb22091fiqr1b5da5vmmjiwa"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "7.0.10"; sha256 = "11v74j7615z1ir59424aifyfgvc096f7lqip6zkdfbbxqrghjj1a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "7.0.10"; sha256 = "0k4hk176vxf6i8pv9m4564yqc47nav8f1z2fb9br3cw5i1cvzmmg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "7.0.10"; sha256 = "0fj136zcqaybzbhp599i6g63w1xwshl5241lig2v5njb42k4a1c7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "7.0.10"; sha256 = "0bwb00hijg1ca597li1i1gsyw5vzmqxjaqypdrybsdrqph0d12fp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "7.0.10"; sha256 = "17jkfcy29x24kxcf28g89m6mxb33rg5pnhs3ygr7lrg6da9k96xi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.10"; sha256 = "0fldpcg7n07nqzyhajm361sp5y7j44g1lm4f4rky6ccjsd2jhzx6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "7.0.10"; sha256 = "10rqr8706y0jgwk0ng5q6v8lssz7yms3fmbzyz8kmm0b0lskwr1w"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.10"; sha256 = "1f8bhw15nsv4z92q4fcyadbdrzw31iribgni5mv8xphjqwms22x3"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.10"; sha256 = "0kkzah9ha1pfjhd7f06vchndnfzw1cbqrqfizfv7y75is9j24d1k"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.10"; sha256 = "0rxgrd0bv8i0asyxxrvsfbg4qsx2zh47jgn7livrprfs1ih0vfc0"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.10"; sha256 = "05hfkilgm5yv2iw05nwqwp0kv1f2pllkw1hwf73fiqxhc5yi4gzn"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.10"; sha256 = "0x7m0rhslsnqnml5syg98vlrimw5ih7zzgr6c12661i1hcqwpj9h"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.10"; sha256 = "0l698rpwqpa4k1l6ykb0q86j3r9v1j2kibw9yxynkbr61mrnmhqm"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.10"; sha256 = "0265zsc9fwslcr8197gil0s4xsh6ascrllgnjdpy28v26cki0cc9"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.10"; sha256 = "086xnk6i1a7bxczgxb0g6b9jx7qigkkwdbsfrb99wx9hq7bry8qg"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.10"; sha256 = "14y4j9r12dm86qgmhnr6ff289fdh6nigpcg9lya2avfm57p7qang"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.10"; sha256 = "0f3axfrshdr9gcdwyaf24czwfd7nw8py2z14inyzsp79bw87c3w7"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.10"; sha256 = "0jnxwp6xvc0djcwrmsk8xxicxhl82hd9fvmxy9gxw62gsvfzqavh"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.10"; sha256 = "0b5hxgzzjsqfwzqzf2wzbhwv8yr6s05qxcmjlxy92fvn98ywrymv"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.10"; sha256 = "19v459vdsadly3jgwm8qsa2z2qqspjk9n02k39j46m76a72j60hx"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.10"; sha256 = "1cl22hgj2ig4dq80l84ia9nmmrlq3rmns7mvjy2w9gk35qca2534"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.10"; sha256 = "1hj75k6ar3bznaak0m6hadzkp93q96dnhghzqn5lzniqzbxh4cr5"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.10"; sha256 = "02i2jrdkq01zzlx2j925svlsj2fp9wxpyx3q9cvx2r4n4c9qjv6p"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.10"; sha256 = "0s5i1irjnmp9kmn3wcz7j5ppb39lajm6r1ip90vp5677f20r5i3p"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.10"; sha256 = "08mygly5bppfk1sc6v3ff366796cas6ngz30vb1fhkqvdi5mkxkv"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.10"; sha256 = "0wznldd70f4iybkaar23342xm9nfh3g9lqankbrv1bvy7nbrrl47"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.10"; sha256 = "05bb0h54a3k9fjkwzcj4kky9xfv7li3p7lfp35f7cv1mab21yqhv"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.10"; sha256 = "0pdyf0m2jvxzp4qp6r9sbxxssnrpbcw9vv3yhjqiajg4zv537g8f"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.10"; sha256 = "0a3caj9x9lk942kwr6pr6flxbgrjagnn7h9f5hspsb59q08hya8c"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.10"; sha256 = "0zzppp00mvj6y6jfc5ivz6816ab524q8h9h38r4ggrhlswfdqapx"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.10"; sha256 = "0y9kcx7pd1swjhb4skhhj35g11mi0gcm9hfmy0v1llk3cwap95nl"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.10"; sha256 = "19rn0glqnnip0iybcnk48z1rxb2r1nnpka0cskv3phq1aachyh46"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.10"; sha256 = "1skysk6c4flz9x7q7y3vrnwg2hyq7cap0f86qvvw1bgpsf3iqp85"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.10"; sha256 = "1vyyhwmz9996igq74cbivr27xl4gnxnrpd64zgykrxdmiz7wrrh8"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.10"; sha256 = "112i3pbcp6hbjaisz0qwqkq12hpf2xrhv70l06ifgxz6ndpi91s6"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.10"; sha256 = "0bq4x765vglp84l0sak1xzzazj4kcgqjb1l30ywqy6rfylb2ppz5"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.10"; sha256 = "1zpm26zd654jhl1a12dcsq1ml0nc0nl3w9ff3inp5l6da82cd6rz"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.10"; sha256 = "0jxnicdqqkbm32wbyfm7d4c6i522701jagjpl6vsdv9q3i5a44vg"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.10"; sha256 = "1wz04jh2nphs9yvi8zcm0m787wjxgpss3bc8zpmihw17qxwsx9dz"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.10"; sha256 = "1q6k2wa6xknh7v097gl7wx7k1jw6s86fcrl04zxbm4n2s4av59wx"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.10"; sha256 = "15nnv3q2zbqn8jyj3sr97ms31kiwg7660bzdzmch62hagbqggjjj"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.10"; sha256 = "0ajsb8dzidmrhch2j6wdv30c9k79q46lr7zy4v41336423rw867h"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.10"; sha256 = "0dba0d4c2ays2vnk14wd0y2dl72vvqqx99ld2h3ihv38l37idv9z"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "7.0.10"; sha256 = "1467pgxdbm6mnf0nqdcf0sarfcwsp0zdazxbk49lcriid87kiyih"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "7.0.10"; sha256 = "164irrjzcnjzkz0lx5j9hi21mgmp4v4cmb26k961wha68v1z4xcg"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.10"; sha256 = "06bkz36xj5gn3djllbzmzccqagawib988b092gghngibg9fxshlw"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.10"; sha256 = "1s7rjmlvj1j2cy0hd3bvxc8h49vi1vmcm7a00qkv09qdll8varac"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "7.0.10"; sha256 = "11xczi5f9b52hsi0004wx6f5sj2rc2x5kdh5g3ngg3qj3bcqki8r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "7.0.10"; sha256 = "06m28k55v8zjxj2jql38c3j2qsmr0ykgrpv5rf7yvb5v83v7l6js"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "7.0.10"; sha256 = "0idli8p2n1xs5d1d31c692bmmxxkxc3rmywhak6y2kq29d5lrd2i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "7.0.10"; sha256 = "1qr5l2zcv0m9w8xwm2jsk32xzfmszz5v3g6w6px8k5v6cxysaq69"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "7.0.10"; sha256 = "0jm1kmpy5d45svdzn8a29jaxjvw767j338vda2prmnyf2gngikw7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "7.0.10"; sha256 = "1apbhxqq6xnzs3ag8gflwzymb9g6rs19i1kdbds0pp08hviy7gmp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "7.0.10"; sha256 = "14dj7ybbmks7qdih6l7ph052v1yjx7hk6c3s42vwnccvpg06sj1l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "7.0.10"; sha256 = "16s4c1ix3sqqgdc6f2v0ldlw442l2k1c2ybjhkbsspq6pp9xsshj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "7.0.10"; sha256 = "1bms1r0g7acrg7698zws61qswv80n4d79wjxa4r3v6552w4mriwr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "7.0.10"; sha256 = "0yiffw2rcbi9014ngjzqnkp0969gsxnmn9csd921dacrls31fc9h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "7.0.10"; sha256 = "16zifcd3c5xwipvfx3lfva6zk45g6119anlmjlybn8p0i6vgdfly"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "7.0.10"; sha256 = "0bk0hmys42l5wsk6zvgjcj7aynmdymlvc7fmwmffg3z53i4crz0i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "7.0.10"; sha256 = "0y3c6nq9i8d5brsx1wm355bhhcs1kha4aln1aa76bqaj2rhh0j76"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "7.0.10"; sha256 = "16z135yy8xlbbxi2kcmxcqa5s2haysc9f0d998xmwvm3lgpxb76q"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.10"; sha256 = "058vcvc61pidfrpj6zi1hy04ywfrdmczgsrigih23irlhsr7pdh8"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.10"; sha256 = "1hpx1pav1kdlk8asvkskhzqkq47ys0mq8m0bk5vs22ccb9iqkr7m"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.10"; sha256 = "01gigb8p5m85jmp3hc94mb3nmy3bvw0hpjbsls42rxai3v4sx73g"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.10"; sha256 = "1xlzpfzzg4vna9dh75ifli8x5g4jfj6kqkisqx13f0hdzzcj69hx"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.10"; sha256 = "0m4fy8q94ssrsfx3ww9k0rqic9rk8dir7iryrlsbxhqvmp4gwvdh"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.10"; sha256 = "039k2aaaadqr90gpih74mzws8v00ravaz77fy6lp6c37wqqs47sa"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.10"; sha256 = "0zayq28xgj2461h10vrj7mp8qmsffzajj8rr1whkx1kkbw9qb54r"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.10"; sha256 = "01xprbf02jkb50k0r198q12924nya5s60j4v089436yhxy6g48jf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "7.0.10"; sha256 = "096dcwdj68sma7b9kf0wvpxli3w746hl56i2vjwdhgf83hr3g6k3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "7.0.10"; sha256 = "1jh5mfjybj2z1wn8pf1fm0bllanlmd8khipz965pgxzwarfv3n43"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "7.0.10"; sha256 = "0rwdz654c4yd20rnk8hqhai4d7v4xybyigs84qyyxk4w0kp2bz1g"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "7.0.10"; sha256 = "0qyqxp46mv695aiq27vvlwjz71mcsavagnlzmfbpn0310y285bnh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "7.0.10"; sha256 = "0y5b4vrnyxg87v64yypbcbcmj4mqmxvqc4nriqck7ssc022l5rgz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "7.0.10"; sha256 = "1bw2d400qdk2v969w8rl2y1r0090m8h5bzx1r48mn6lpz6wvs6ld"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "7.0.10"; sha256 = "0rnj3jl6yzpg08aw7802qs5s7bfw1vqx24604aizhkhbscf8f4f3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "7.0.10"; sha256 = "06cydadly53jaslvaa9q7jzsyc9fqbd68a2av3ncybl1cngawz9i"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.10"; sha256 = "1kr2ib8kskdp94ckx9bfahwhj6wv48bhck6xy8wgb5d8j8q9mqam"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.10"; sha256 = "1mi8yn7gfv3i01iqgrrsnf7cni1jip13j0b51lrl752pkzv3lynv"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.10"; sha256 = "15ar1vz3wq2pncv964dkcci5mlc1kf2pw8zbyr7ayjyfjhr2nxrj"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.10"; sha256 = "120c4nalbj046bs0q2wg7pxsjgdwazbbjnrs76v0sscwzzaylc01"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.10"; sha256 = "03q8z4lrm538wrsv4isfhzwlxffcngykv45wp58gbg338gxh4ngw"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.10"; sha256 = "1gcqrsindn2avrp4r3lj0bsi4hda0zimmwhicihkh2ykq5xxjyj3"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.10"; sha256 = "1nlkr2yf1rxb0jca5li44br4n95hsmbaxg3wf2nz0iyh4n7b65kw"; })
=======
    version = "7.0.203";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ebfd0bf8-79bd-480a-9e81-0b217463738d/9adc6bf0614ce02670101e278a2d8555/dotnet-sdk-7.0.203-linux-x64.tar.gz";
        sha512  = "ed1ae7cd88591ec52e1515c4a25d9a832eca29e8a0889549fea35a320e6e356e3806a17289f71fc0b04c36b006ae74446c53771d976c170fcbe5977ac7db1cb6";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6cd2eaa7-4c06-4168-b90b-ee2d6bb40b10/4a8387eb07e17d262bfb9965f6d34462/dotnet-sdk-7.0.203-linux-arm64.tar.gz";
        sha512  = "f5e1b5a63b51af664b852435fc5631ff3fbeafbfac9f34c025da016218b0e6fb9a24e816035a44f4b4a16f28bc696821b1aa6f181966754318bc45cde7f439bf";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/de3e24bd-f677-4d9e-9717-859ce6659b5d/80c21bb06ca64d9408d11a32f858c7c6/dotnet-sdk-7.0.203-osx-x64.tar.gz";
        sha512  = "a69ec597bc5b0a59ccfc9cc63c4883037eb9293600e98ea420c879242ec6c3fae6a81a3a08bf7d5d2ab93f750debffb224ad5628c9abd53bc44cfcb02ca77136";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ad0ad533-6970-4099-a0c6-ee1d089a381d/2d7ea966c6d032111389b7686ccc0d9a/dotnet-sdk-7.0.203-osx-arm64.tar.gz";
        sha512  = "e41de76f6be00de587cedaed2b0c6e2c2871b2ebf03c89375b4c69cd3fdd14df0dc49b5fe83970868a25d14aa19deafbfe66ee6790383b77f7da3d8dea939664";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "7.0.5"; sha256 = "168bkqk0v02rwxviqzafhkdmzmmbd4z60sibv3s43byn0d8hvfdl"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "7.0.5"; sha256 = "1f7j3fxfdbin5zh39knsr1icpbdf5zkyjdxds9m8brraw9gj5mlw"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "7.0.5"; sha256 = "0fqhjy5q2j1c44ijgzpl1j4yfkhl7vyijga2y5cnsly42md9k5lz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "7.0.5"; sha256 = "07c87frgxvdgh4v0n02wc8z27x12kywcwjdy2bqa6g45qznnangz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "7.0.5"; sha256 = "01irhwqq80ifrqf87897jlh8v0mr5yls000gryv4v8cagsq648s0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "7.0.5"; sha256 = "1nwlyz0sgykx801fg1lj7la2b3vbgyvk51132v0gnz48m8b62n3w"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "7.0.5"; sha256 = "1zkjvfqz89cc0s25i7acbcqvbs52fach0iqf9098h6ak2pq6241h"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "7.0.5"; sha256 = "0jxrlgb601x1na085pmqyb9r1wp2vbnhly7pd2zmrgqihcxcp86w"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "7.0.5"; sha256 = "0nxyv0bz9c46pmwvvbmpb6c7id8l9ka9lpymi0ljwln01xwhi8fx"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "7.0.5"; sha256 = "1631gy294dkd2fvr7010a1sz6hsrdzvvmpykxp1gjxz242wxqaix"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "7.0.5"; sha256 = "09amylhcl0fgrn08zan5xcsa4wjw5prdnlgypbvsz4z930lm4zf4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "7.0.5"; sha256 = "1c62wlq21lck49a7cfwq6b0lb751151dn1sn9qv11fvc841lkzw6"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "7.0.5"; sha256 = "152dlxn5bqvf0nyhmxbcmaqj95bmm4vhvm4y23ajfwwgh373n00a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "7.0.5"; sha256 = "1vigsv0si95cjicbrpgi3jmpf2a1b4rn13yyxqhqagv1chs60jh5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "7.0.5"; sha256 = "1fq6bjpsmqdgv5z4ncxnxrfn10aw90n2zh8sqw0whhv2kjsq7v8l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "7.0.5"; sha256 = "06pbg6cphf7v39f1nsc7d7wzsl8aanb59dckxay3zazljpbyg80d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "7.0.5"; sha256 = "00nvn3qxhv2rqi35wxj21fwq5q8w1zxki70pnaxpv4b6m2s8jmql"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "7.0.5"; sha256 = "12p3zq5n8pmpscrgz944rkrjb12q702if8510xyf2b4na85r85qh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "7.0.5"; sha256 = "1lnv3z082ijmyzwa3in98wz7jchaxld2gbc3dk2k804pavaamr8r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "7.0.5"; sha256 = "0484mij7i3daag1k6nil5p6bxs5w9hsk2f2f13lnjjgdcnl7znf6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "7.0.5"; sha256 = "0wvjzn6xij7kgdpkb3m7y31p1iz1jzn737r464fqvw778dnnir1h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "7.0.5"; sha256 = "08raqcy32yni373c6kdmxvyndxlwrhnxadfjp4fn7rfqyrgqkifn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "7.0.5"; sha256 = "0g88jgsk0vxwaiil9kcp1cfc5chkb6gsr45m8blmj866qinln3vf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "7.0.5"; sha256 = "1nysbj81wpywh6i39l4agv5rjhdn3bd1jqb6iwlkmriyf1xyshdz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "7.0.5"; sha256 = "08ak2khqcn9dqinb59c5nlpa7imdhi5j7l4g9p2xm62jm6816qlp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "7.0.5"; sha256 = "127bpxp4i902l44b28xmknw59f7smlsc8a3w4q5bykjk1hj18hxz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "7.0.5"; sha256 = "0bba6jzd7bl12wwm5wpnk1nwbn5ylc3jfq16wsqzdf2ymcvnx8vm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "7.0.5"; sha256 = "1cl6g85yaigyzixdqnxqpclf46x32f3ndjl08x9lpypwsv62cd9z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "7.0.5"; sha256 = "1rmim6wrkh9vd0klmlwm5yr6xszrhv2qmw4sh12453khxdsi0xpl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "7.0.5"; sha256 = "0c9p34b55zh490ky338npbga3jkssj7r6h4jwyv1bj9skbp3aayn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "7.0.5"; sha256 = "1x0psxmi1waymxndk38f37aq1lnd8airglq6i0hi38f2yfbmby9h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "7.0.5"; sha256 = "1wd6i75alsj2hv8aich5gjc6979s4shmrdmfraqj2qr51k3jdf0r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "7.0.5"; sha256 = "06vl6l0nkd7iikg98ycb5smsrvw8dz9nzmjqyqksia4hxvhrlzc1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "1y8fqpnfcp04bz0qjsms9dc5cpf8zdkk2vnll4x6w6h8mgsippj0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "1v4n3rb4kcy51z9c19mpwqkymsrw11j5x17hsffj1bdq7ad5ammv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "0yci8wcyliv34pl73gid5f9dilf6fb5hrfwbffgpka19x6yxjni5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "1dl8h9j09lwyc6vq550prwxcz15d7v6c6ii8gzli2c77qk71k6hw"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "11r5944ccwgpzvhqiy9f62a7fyqzszaq2yq9szx31l49hhbiy8bx"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "0k4q546554m8hnlak8300mgydjyp9rrxqm0xwc90hmn42k9zzr21"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "0mrgj2xkc6nk0xchpjyfrvfchx721nc25p796c93vgh60zv388dc"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "10jnaybkq0b8n02lcc6ay2n5s7msghbz96kydphj8fq3bicljggn"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "1ssdj1mgmm4vg8ics072vkbn0a0x5dk958hx7wcvf5966fxjh5l9"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "0xygpaccvszvpbpg144ddbdwfcwmbssp1a53l7nfaippr16c7jc8"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "011kc0d2hmdqzy46x20w4ljq10i0hvlhmna84jid21cinfk2zq8k"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "1sigppl8zjxxs2c7y4gsc03913q7bdgw74rvdkh9vh7hq8kgldb6"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "09jnm9pq7m9wacc640g23i171w1fwmvg103amdyc9ayih66gi6nl"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "0p4izlcdhsd7rnm7iv0s9h7qp8vfvd17dyrn35hjj84147x34dyf"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "0c73xl6ypdjqpq6fw115fdq40pfmj4qm3j5v67mrxgyki2r0m6di"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "0cjsw125syx91d8nm996c03kdv77l1aqx7nwv9gis9mqx6mfb9ij"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "18hxhi8675z52nxwii3zixki3g4k66dm89gnnlsa0bw0n445l44a"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "1mlyrddmdmf3xfh4zfxcv9938xfhyar7yxgin6skxg6n0f1n3qjp"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "1aczpv37c6b2gajwd5b1wp0fx60dzgbpb0r24d2cqkj43rpbynvw"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "0g6z2pcqgi63r70shc4bhy652cjg2phlapscj7niia7nigvj32w4"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "0whgwpb1p8ykpk81z54mqgnfm3dysgfdl85d3idkjzy4a4pjqv0q"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "0zgbl854p26wy3vx0arqm8clbclx23z0q0fvk3117k19r0331kz1"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "0q650bmnl1rn4va86dvdw2gdb0vnlfzdm2jgfph6hk34cdxqdrd6"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "1z32pmdfdpw4ng7z7xqq2ahq9ydgii85cywcixl3rdmxk2fsd9pp"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "176rw7iy5k3rpk63cdi6nzcq00qfmskn8y3dfbrds3qxlqlq123i"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "1xwnpmb7qrzwk2c3vmjrpmwwhpizz8rpx5zm601hkdz458pk9xvj"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "043sg5jfkrvfrc7h2mf2qc9g0l1qz9fifn6dlqx8d6bxl46vqk7d"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "1d6i9dyiml00sr92n5jkp818hibbrmaa1d0wwvczcjqq4r6ajpyw"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "0gxc7jcs1mqbmhz5vwi88pk795f0lbkgk0fvvsy93f9zj70gsc2m"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "1zvlbzfa61i119s98mad7af871f1qkhb832rfkvi2awv103pwccp"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "08gwnsaqgrj61rk0zpd9wbmlfy71jip4fqaavsv350cd1kw76qv4"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "1k27y6mnn2q8pz24bp8ff04lws1jvpdwmadi3a7saqdsxwzs4mas"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "1vxzs20ibj16scg50g28ha5p7yw2csjh8xglqnjfylg2xh8j5g5c"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "1acxvh7g13jq411w3msysmc4ygd6ciw24piprj8zb8vknbrg83z4"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "0saimrqmfg613bpbqsy9f40x8s2rjagzx4x180p3gmwf0sl97qrj"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "0vz8jk7idghnljh8sadl260ndjjnqf04misx1bp847ld0nik97a2"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "0kf5s7gra90g21pc8gimc14vqj6wc9rs5lhhmkpb3w6mr8h25cwl"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "0484f09j66f2gmr4fdsn79xw1mxbvi2b566d6z8kf1702jmd0i53"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "1r6m0933cp0j57lywgaz3vwiswfd04lyh24jxsrvhd62ckywsb78"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "0fwmwpjkv7s18xizcj7psyhm79dy628ksq12hd8w3323rb5696rg"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "10y9rh90a0acqalv348fwf0bx3xlnjya0ni559xi80armbi78l3k"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "1az0l19syxx5nfn3ixykhy43r9hkhwimxf3l9ww60nxhbkx6v72q"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "0licp7y73lkfkkk9zyks5rkahrh3xn0ihz0cs3dvvc9vlnndcnmg"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "166sj8yw8cjnxivhgdwrl5z30wc0004v4gx6k8dl7nr89y71rcqv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "7.0.5"; sha256 = "16vvzp7355l4xi87bq83yvv8s358akdncfqfjk7agj03vbx0qay9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "7.0.5"; sha256 = "16vmhn5xpnbajqbsxd79bppwjyywfza20fkzjd93lsgl36dnxbq9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "7.0.5"; sha256 = "0b87x1r9103fwg3bg6y42hgv4dk40kgysnvksv3wssd9m40v3kqf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "7.0.5"; sha256 = "1pjcd3jnsnsfj1bl60nls8mjfpm0p96jj1jia64l3mfv9lsrgd7v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "7.0.5"; sha256 = "1qw07w5qll6y8rdids8bv3717hmhcv69vs7xbgpddh7ag0xxihr7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "7.0.5"; sha256 = "1sam55nhsa0q6npcx2qa2q2rfqss3lk27djyhp4q7yazsnlihq1d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "7.0.5"; sha256 = "1xdgcrvfiid1njq61cjffhifkw2ix016sz2msfmlyplfmcd9lys3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "7.0.5"; sha256 = "0r6h1rnxaxfalp6msk8wvmlhi5k5gv385c66jgw7vvvq05kq6gk9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "7.0.5"; sha256 = "0bl7ck3hxy34dalpahb0d83f5w1lmp36v0jax18x3lxbn3h5npn6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "7.0.5"; sha256 = "11x0s7zjx7m3q2w0l4sp0gpwzbya6f06iagzkj4y0lm95xsx7pik"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "7.0.5"; sha256 = "1k142050w7m7fqk6cnpa2iin8zp53cq3xfcs3rqwh4g4ng9dzgpy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "7.0.5"; sha256 = "1ap7qlpb2wc5igh08q71i5vh8lgd5p13p9pzz4vpk6gwfqlyiwa3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "7.0.5"; sha256 = "1prrsqcc4maihmgzcc8n9z5qv32svfr9ambfaka86svngif61m28"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "7.0.5"; sha256 = "0w5q19af5f47r8vgpsvh3vxci75v1fhh0hkp1gqj2mrbb3qydnd0"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "0hbndgxbg6q1zwanjl98ybn35w24592bjy935pdf5wa1b7sv1h11"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "1jbvknhwyrpvs81kpi1lbjxlj0zh8nmz61jz7b5dn63ilf3mx9x6"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "0jgzf9dh8zar5xi99qw6qi4yx6cgpvd9g9xzj0yis7cc25h5xbpf"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "0n1fajdm3a925bvzy23g1mvxrpch1v28qwin62bbnl21zk41k7f0"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "1nzgry4ckcbsk36kmn2vqfds4ldqk2hqlkyrm1id12mnxblcrih9"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "0467y44yygx4jia9zmiv63lfn64j7dz8hxn0i0arrw0ai59fzdcz"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "1rzyj8bgcg01pqkww3d2sdv4fk5hsq2ir91xm4kbxkx60zijqfkh"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "0rjz1m2vxw977gl59jdgxzq91kap30jcj2wdbn702im5m1262di1"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.5"; sha256 = "1w4aazcr0qc7sf4mxhkpp1d3x1yvgxwq3i9yak9a94a8mxx9b042"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.5"; sha256 = "1i445i4i15gqa5b2gl92rlj6zww3iwzpx7a3wvjdaf7pyjwcxfd4"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.5"; sha256 = "01bri3hdl9xqkjr8c8krvi2g64csp56jv91rxfspsvy8s1j7mbkp"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.5"; sha256 = "0abidvw000x56fw8vk39645ywynip5rlpwg3ahn4bazm6prjhah0"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.5"; sha256 = "0qwnykfvf136fkzn9iipxmzkrik27xd3zr210jw1m4c2wzd3pwls"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.5"; sha256 = "0330966bldi7x0vxxfl6bb8pd5ysyyvcmn5ll58lwz9b8ihwqji9"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.5"; sha256 = "1fyhsrw7zraf8ml0ibqi26i4y76a5i7hm7155hrlf6g2wh9c2wni"; })
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ];
  };
}
