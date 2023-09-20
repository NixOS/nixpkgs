{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v7.0 (active)
{
  aspnetcore_7_0 = buildAspNetCore {
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
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
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
      };
    };
  };

  sdk_7_0 = buildNetSdk {
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
    ];
  };
}
