{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v8.0 (preview)
{
  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.0-preview.3.23177.8";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e47f5b95-4eb2-451d-8ec5-2e37b928d91f/e386c9fb8185cd35674fe2a44dedb318/aspnetcore-runtime-8.0.0-preview.3.23177.8-linux-x64.tar.gz";
        sha512  = "f990c63e651d71ef615aa494dc555fdcf66411431d07b7ae9bef50f276e863198212471b90bdd86686426d5907d2426924d1a279262035bbf3ce64d8914e590f";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0d98023b-349e-4893-b717-176eab3ca4fe/ab919484bd5a5a981057f60828c8d8d8/aspnetcore-runtime-8.0.0-preview.3.23177.8-linux-arm64.tar.gz";
        sha512  = "c5826d36daa4fab2779bb3b6bb94886bd98ee018109cf82b994a189cd6675b8f14eab9b11fc2a265a7bb3b8dacbe79b75887b1a81ee65c4ca690cef8a27a400c";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/18fcf656-e2e0-4fb0-8141-ffeaf76b2785/cd4ff90bbf9b25d10cdc9fb8aacf94be/aspnetcore-runtime-8.0.0-preview.3.23177.8-osx-x64.tar.gz";
        sha512  = "b8354eccec9c8b77f6afe7b4ff08f300359dbdc6106731b3e5b9966e1060a6def949174de8edfadd4e90a65e3337f2c03dbf55a4a67e2d8dd51446600605a914";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0e9f855d-b7eb-4641-b859-218d7d61e169/c7ecfeb28526a57668f53d7da4fa0c90/aspnetcore-runtime-8.0.0-preview.3.23177.8-osx-arm64.tar.gz";
        sha512  = "9167ae736f29f49522f6263e6b2698b94fb0c4f21653a81a2ee1c8101d3c176a9b69dceed0c832ce04f2b84aa8fe0b14e7dac54dd965026e472429db739ddebe";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.0-preview.3.23174.8";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6c4d4118-bc92-4601-b42b-2b6e91fc28f6/7b3a642aab860b394982d48bf5681243/dotnet-runtime-8.0.0-preview.3.23174.8-linux-x64.tar.gz";
        sha512  = "d0da20d48448c654ee548668a585b2272c661eb84ec6f845b3a49c0143ba1bfa83865f69da6bb607353a571e8c84b8e63650edf816641b1c5a55fa77a59e09be";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7b272393-da0b-4386-ac78-416ee38195fe/4f0d5a3d43cd7b32ae6051b191edd5e8/dotnet-runtime-8.0.0-preview.3.23174.8-linux-arm64.tar.gz";
        sha512  = "6ec1368fde8d4ffe5eef21e227c93ebe94d44f6bae311c5686d2c710240a025b5bc3716f3ceea18a8b65ef588a811828a0ad8b76db3086512786966fd111c15b";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/962423a9-e286-4a7e-b3a8-4fdcde16d9e2/0b11e7166df8ed292c44d4a7594e482a/dotnet-runtime-8.0.0-preview.3.23174.8-osx-x64.tar.gz";
        sha512  = "53c52fec2fdf5e5cba92f006d2680fa63ae8946ab0a6ec03b4a050e6d52f2e2e94ea01e0b8be63136f0c800907fca6c49dbb180711e8948982205f6c447f9256";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e29d7a01-41b9-4cdb-9c87-640871cd7b31/cfc38e882c713763339265cdfd1e4fac/dotnet-runtime-8.0.0-preview.3.23174.8-osx-arm64.tar.gz";
        sha512  = "73619816e7570bde00105aeba9bd60ddbe868df4d25f4b53679dea01a80d81403215ee7caad7adf7c0128011b687539786e7bb817d652e993064ca5716d1fc1a";
      };
    };
  };

  sdk_8_0 = buildNetSdk {
    version = "8.0.100-preview.3.23178.7";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/103d5e2c-d5c4-4101-bb6e-b82bc73a7d93/284a5cdccbc995f39806a3ba2dc17b93/dotnet-sdk-8.0.100-preview.3.23178.7-linux-x64.tar.gz";
        sha512  = "3b5d72979831256b9340a01db23d3b2dca801672546eeed04385949ed5f4363d3c731f31477ec82c7200ce88502dc45e03986c8acc8f2fc611b0343af5f1c488";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3b23cbd9-f068-408f-8c3c-551a5432ff08/876e15ab4041bde421e96d21e259b3b9/dotnet-sdk-8.0.100-preview.3.23178.7-linux-arm64.tar.gz";
        sha512  = "c48840b3924196a12cc66b07249af37afb2b0f3b139eb304492a2320e7ae06cfc2391abd1da31e6e58287b8b8e564386f82c55eb9a1b16108f53a4d1d59812f7";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1d4d98db-3a0a-4b77-bd3f-5ead1fc106a9/1a3410ec0ce6b08a02947a5541a3b5a7/dotnet-sdk-8.0.100-preview.3.23178.7-osx-x64.tar.gz";
        sha512  = "53ab3f6449438ab6ee0ecdd0ae3759e5fe873b964d0b4e3ee5c8a48197a7c87ec83b956eb1b10aa90297403762eb2ddab0e99e29442db484b7ed3f9d00c8037d";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7fc953e8-4e3f-422b-ae45-719b38eb798e/6559f9ed96b446bbaf2e2fd2af694dd0/dotnet-sdk-8.0.100-preview.3.23178.7-osx-arm64.tar.gz";
        sha512  = "f67ad34c23dca602e08987c12f07a39b6941682e35eae3f50efb95637b252e1e885a259f4df9be5bc0f5d43a14f16ec206a39c899683e22bf7b6a94fb2db1386";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "8.0.0-preview.3.23177.8"; sha256 = "1nfzm2wl5qmjz5ym7aainpj71gxfl7f8kr1p9c1xl5bkc7437h3s"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "8.0.0-preview.3.23177.8"; sha256 = "0a7zd729dcc7fy72z4416nxd8n9srsjfb9mlzkhr7dm1kxn25smj"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "8.0.0-preview.3.23177.8"; sha256 = "1gvh8c0aylqgw6lys7yl5d6ajywmqaz173ak1icjh9x9073bcnq1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "8.0.0-preview.3.23177.8"; sha256 = "0a28avjcqgkr7wdq0g83wf31dshn8jq05aas5y1rwka8hbplyagq"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "8.0.0-preview.3.23177.8"; sha256 = "0ywsi5qaqhfl9987fgb7kdjmzk8fyvql9ay3c2xqhxw3l0sgk9gr"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "8.0.0-preview.3.23177.8"; sha256 = "1gfms15zadmmpl39m81hmnwr537b4jlhivhp290b4zs00bv7lwq1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "8.0.0-preview.3.23177.8"; sha256 = "1fxzpy9sjjfzkg78c0pzyky0ahm2sy95772acnggy23h554qvfm0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "8.0.0-preview.3.23177.8"; sha256 = "1ali5x4k3yvmi5nwc4yq85xj0ywf0jg1b3fsfkjw18ayh9h61ksp"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "8.0.0-preview.3.23177.8"; sha256 = "0ry5405vj93fm5985z89qk3h38dd6q6iij9ada1063b275gkl36j"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "8.0.0-preview.3.23177.8"; sha256 = "04678w1fg1l6jr65vb4x0y4r76rwjz98qriazv9l6f07iskswbpb"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "8.0.0-preview.3.23177.8"; sha256 = "0awgrd1gm4bisf9qxv122iivzzsvr958lyqghip4cq0v6lrwgp8j"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "8.0.0-preview.3.23177.8"; sha256 = "0xacfmnw3sxnwrfx1vikqc5q6hbd4mn2z5kf2gmc38zg26gnd1dm"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "8.0.0-preview.3.23177.8"; sha256 = "0khvlvily96rm88y14by5svpcy0x8jxbkdnlks965lz6685yz5yf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "8.0.0-preview.3.23174.8"; sha256 = "0w297nsnh4w3pi3w5iwnww8nlk00qys82vwzmrhxbw2mpar5mf06"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "8.0.0-preview.3.23174.8"; sha256 = "0ik3lzj1b41vgs878gci8ck1dz5g1fxkb76d6il7zf95dxkivdiq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "8.0.0-preview.3.23174.8"; sha256 = "062x0vzb75m95knk1wql1bk5vk7s1d3sd13sm0jbh1i4mm7a0amh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "19sb0j0j43xl05wazn24x7hk96nljr9qjwahp4flyfdqrhjan72i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "1zlxqh82wxpb2xq808nmfywgziraa3ndb8v6wmh3315asw0l4j0c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "11wr7i7sz5xd9xc7xsy7gynv1jxzyvja2q7c5pnvp9745w02lizd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "8.0.0-preview.3.23174.8"; sha256 = "04m5y009vj943lc0265frz16q5w8zx45zpj8a4q5bpy63fbzkyfc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "8.0.0-preview.3.23174.8"; sha256 = "13f3smijj3d3ifkwik8vlj01pv2bmcsqmqkzrjw3gj7w5ln3xrf1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "1gy1ri66blly0k5wf8mgnfjkc8wnmrj2qf3bhwzlkfgyab85k1ap"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "8.0.0-preview.3.23174.8"; sha256 = "1p280lr4dqajsqz91rhl0jgpii14wnbwl3878kb6l694q9vh9ly1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "8.0.0-preview.3.23174.8"; sha256 = "1ac0jbv9qc5f2br9bgw198gq7lmpy7rj6xs2n2343v9p9wsff9sm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "8.0.0-preview.3.23174.8"; sha256 = "0l3hb17adqqczv24r6jisk70rqlagmmjbsgqp9ndyz0wgq04sb07"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "8.0.0-preview.3.23174.8"; sha256 = "1iwdap9dldpjzvd1gg1mk84z2p24dq7s96w3i3g31rz41xh0yxdi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "0hxk2p4cavnmc3azfpzjx0pmzapzh3ggfmgsapbpk0wc3zrf0ial"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "1p74gc1h353can3f6104qxwfpzy89cmx43dzjh923pknyp673yhr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "0fv23nd0iq18ggyxpainkrwjnclk9lqvx221j3lhq44pa8fv2xvn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "8.0.0-preview.3.23174.8"; sha256 = "1kj0ss21s7h00mhavm83zgjm3vbx27k8n6567liz3c8zk3xyyxvi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "8.0.0-preview.3.23174.8"; sha256 = "1r3ibli433k48q43nbhd94r3cgr4rdnkqj833n89j0xqvicrbk8p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "1lv5xx2jigpg50ywp105ghq3c3lp6x9q99k609gwhmznq0b2piaf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "8.0.0-preview.3.23174.8"; sha256 = "1q5sbwlkw3hk1gazvzhsjw21c578a4mvvm6xcrjf81zwwqhbqdzx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "14g4qrlvgzjixlbika0qc4zyh7rb4jx3xqm3hgjf5zdccfg3wlr1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "1gsm2clshavsws0zdr1qsay6fylchrgjpxmsxhvs2afgw1p5xb43"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "0x3ipigsad980is2c07f6q792am9lzmkahxkbr3f3k3nf9xxihbk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "135anfn6rz3ysdmrvkig64fb37p9gc154ns97n6snwffc6c7xad4"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "1qlyr3aax6pr21kcrfkfp3a4f5yw55dgam09lr8nzxqzqjc9qry3"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "0sq6i4jpaxp8q98fxxf1y72qmrshigpk6kp19ivzk6vs655yzik0"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "0z8wy3ib6abp129dwbzajrn3yvlm3gsa40n3fg01gbckhkgg1fd8"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "0qzj903aw4lrij85hr18l4cxz0qvvvfgspdzx57g81l1l0dd7qaa"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "1zq0zjnd3yq8a8nbj1dm3bblm1qn5gbfv26wglrb0rzsk8vc4rlh"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "1fhb0s8zgq8basmyzsm7h0rkzlkvz8lajkhqfnzmcwamv6i17m0s"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "05p07vmxjv6s619gcb14h1wfazb8zn47bng5m1nijalysp3sr7vb"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "0kxgkx6p1aacz414j5ia2qffzsk3lkbvssaacna4573ymisxa85c"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "0fpwss7dw6hg4ks5rcbx50rqazankcb8cvsnqrk23361p28myqkl"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "0yl27d46mx7iwg47v6di3r5v8sfagc3yksvxcfy93mvm8gpaii2z"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "1v485fdlrchc7f8lxxsxwapzqv8v9q1q0msm54frxa17iivkgc9k"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "1pq7dx4wnl4wlywf6fhfyvxjajygfhr29hzi2z9bwac8i1nrb54f"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "1y0nx36vms6024r8y5ckzscyqrqpbj0hz5dwzfz6am7iaq90iyjd"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "1hnhxp5wjq9xvm721f5amwk6qyncrvfn3scgmd911zn54ms3z2mq"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "0m64ggyqkdbfzpkyz88xssf1qg62z7i349dij8n0sd0i74fj69fi"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "1pnrq3lrnc5kjhfp17mmjviy4jsrvcizszncfkc28y4hq689q27b"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "19aq4fvyg1hd4bi9l1vnfsrki4ppqkk06wx4m7v8158ss2804a1b"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "0pw78b6agg0smc8k6sfhjj5m4w46dg9nvnzy59lhp1lgz6wfn3vj"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "0ix3arsgyxyffwk9b6vbyx58h3mv2hjwvgsc48b986zh4crjk7fq"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "1k7wp6s8fny06rrif74xzyd2fmflv3ckp5bs6zkcmm2ccmdrrm9z"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "198l3h1y2830g84k7j8p9h20c9j3w9yldn9rrpbfkg462y1l4dqs"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "0jmgijsimrg7lnnsb5ja826h8bj1j8ww1z4zhnsgjddp3shb4v61"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "1wfliwrzq2k8cinv81fn45hq6s6b5977z2h5l0b716qcsk5kkdm8"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "1fqs4kspgvpf564qh5cly2x2l7wqnsrzysdl98j7a1nzsy7z8i9a"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "1wkvqsxf23nmaf4mldlc19pvzpnc7jmbinmdsbh4a12h2m8wr9hq"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "0dmmp83w5hqd9jrwyjnm3n1rwjyhvdjwc07gd3m8i9hpbdglyjgc"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "1fyzrhn46wg99yvmpsp3hq5yjxvgza7y5xkfpxsg1qkwlxxyj39l"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "0s3fvj2bhn5iyzasn0d89lfln2j0ksm4zhkr1jz9jmadk0xdf46q"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "14mdp9hamh85vyd318qnxjj8vrnr79hflh19i02kd1l8d3k4gcwb"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "05mz3qb3833rmhwca6xic6wvzvnq7sz4pi3n4sfyz6jnjg87zp1x"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "039ljiz5lf8kc185nhy2mfz7nl34rczj8dxiq7d4j2q193blk1ws"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "1dddrd8z1lq7v69nsjnpr1vlw14gkwwflcag8mggqxj1wp0jri6g"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "0gv7rnl5qvnzly6fa90i5fsd3mxh2sbay35h0dicplzps8d9c436"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "0x86m6gr1zb0i1wg67snin5zzlvg7xhr5gbc2hklzjgs1b8rq03w"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "1424vq65cpz81fkq717ibjk608v7lac4yi8cnfi5rc9a5bzzwiw5"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "1ghg3pywy83qpgq4wmf28mfsl8njvnm959irv4h2in4dfpvg6d07"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "1jg1l6x0dawx5ysa9m1j11a1iqm5q1wridg4qm1dgg99fchc6mfz"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "1k3nkpj49w5092rjfwvjwgdks3sqdljjzrhgqlfhs99yyfl4vymd"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "0q2j765hr9dwwmamrdq6jq1pngnk82zmwpqsnqw4djf9gbphgb4v"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "0k0bnangipr447dx3gbrd6wska4lkhzywcrs5vnpgnq8n6i7zs9j"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "8.0.0-preview.3.23174.8"; sha256 = "1vhsjwc7y0ax39lwj14hdrmw90bb62p369fnc8lf5pb1k88wr5ja"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "8.0.0-preview.3.23174.8"; sha256 = "1d9qf3h9p5bpik2g3qd2vnh4hcz4vaw262nns8fkphzjvyn1rapj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "8.0.0-preview.3.23174.8"; sha256 = "0h0kfqbr23a625wq2ki363092rl8g0xmchwikh86327sfqm0i1qa"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "8.0.0-preview.3.23174.8"; sha256 = "157z2sdmajf24w6y19k7qacqzdlchwzm97i49vzakpjf4rsrhl7l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "8.0.0-preview.3.23174.8"; sha256 = "00rv31rpfa28lhidzlbkbpvc8ij8akrgj2xc26hh63yqrkxw707n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "8.0.0-preview.3.23174.8"; sha256 = "027s6fbk3qm3r39w545xlan5psp1vp7nyy1id4i94krz3r23jr9b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "8.0.0-preview.3.23174.8"; sha256 = "1hg2ws6jbdjiwlnrqpqqd2crw4qn27whriqchxmzmnxprr857a2k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "8.0.0-preview.3.23174.8"; sha256 = "1gipxwapdl6akscxws63fjr3cx2yz6pbh1pmndkaxgqal364j51a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "1n1x01wwvsdm9vb90kj4qx6wv9jra9jph6dbn8nfdk8ikv8jbyyh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "06bmyjmwfq1xrbz6b4vsw1kxf97ylfgsipavgw8hxkmrn4ic7qw8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "8.0.0-preview.3.23174.8"; sha256 = "1sx1l642yqlfmya6671iv7dbzzg2xsd8kwxzp0ylg294zg8zca33"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "0p307ck43xc50zhk3ygxgaqilvihp0w8xfgb1g08jw7h82k4fnad"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "1181xp6vygjvxm3y3ymd0vnq0r67igy77mpby7gfh3yip5ii2j18"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "8.0.0-preview.3.23174.8"; sha256 = "10n3ybn0r0gyndl4yyp60sy6j2s1vc8qpx4ky9d6wv3id80bxfay"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "04xray0vlk2szcms9f8bm66vlaf275lwzxxfdqsr50glhlksn57q"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "1y0b2p4jjdzmicmbzpszs71480sfibmjsmqc52aqclvx5bqzdsvd"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "03i5jf7g8iwp6k5aglbxixkf018ja09jmyjld83f6x8skzc8s6i7"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "0yif5vv4z1z7sy6gh967p9gxiab6srmm94z7y0v69xyzqb9v1ni4"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "0yk0bgs1lrmxdk5fmgdm312kalszvxdv7h3cl4pldqydc7y9pcmk"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "0b5qavnw7n3wi9k5qylq1kvby27svdhzd1lz4vja2i76idpsr18b"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "1biz7yqd04hx8pk67y2n16lrf3n6wy3pxhh5mx5j1mvp5rd4zd4y"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "1k31qi99a26vz4hbpk3qcvgz7wgr492y55sn1lgfl6v29lnicqg1"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.3.23174.8"; sha256 = "0rw21m9yn52iry60aprhy6c3l656kf9q70vxy0qf1xy87vyadaq9"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.3.23174.8"; sha256 = "07dv8xiqkzj21b2r6jav3d4nrb4i8drwa2l0ybramdyynll01687"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.3.23174.8"; sha256 = "0ywg0x5k3826jpajr972b75dzcxvgbl55nwa6v12v8pbi77bnw0m"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.3.23174.8"; sha256 = "1hag4kq25j0mfjc69v4l9vywjcmyp0ya945w34v681ww1akbgm5q"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.3.23174.8"; sha256 = "11swrs1zdvbkvs38xxaqbw928h92qj6hq47i8wmrjx56zcw44iwi"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.3.23174.8"; sha256 = "1wwkhz0y2040bqbgmh8dp6wj48yvq9irmnppfwamznxkqnysc79f"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.3.23174.8"; sha256 = "1pgwp4r2g209lri7fkv94jpgkxddh900pjb39808q7j4s59pn8xk"; })
    ];
  };
}
