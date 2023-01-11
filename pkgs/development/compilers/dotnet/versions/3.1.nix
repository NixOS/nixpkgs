{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v3.1 (eol)
{
  aspnetcore_3_1 = buildAspNetCore {
    inherit icu;
    version = "3.1.32";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/39c3ef4c-73c7-4248-8c54-0865d5feb8b2/3420b1ff6b0f36e63044d6f7a794b579/aspnetcore-runtime-3.1.32-linux-x64.tar.gz";
        sha512  = "0aa2aceda3d0b9f6bf02456d4e4b917c221c4f18eff30c8b6418e7514681baa9bb9ccc6b8c78949a92664922db4fb2b2a0dac9da11f775aaef618d9c491bb319";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7a713b60-c2fb-4dc9-ad35-df86c4bfac0c/fff24659d0a2ad9c6b622be1722b8f72/aspnetcore-runtime-3.1.32-linux-arm64.tar.gz";
        sha512  = "34b9ec241cd0047cb23f0b8416d3a009476e511c3dd5854636c11cfd078117faf095f32f06e7c97d810af94fde43621117414f983d3b2041ad40260f50dc330d";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/70cd4d7b-0186-4ce2-a710-f50d6dec246f/84c5b21b8a487127589095336c5158b5/aspnetcore-runtime-3.1.32-osx-x64.tar.gz";
        sha512  = "21f77b64b527af41bbba0f8887c71be631f37d7bbabe9119fe39961c2600a90075f60768173097c9fffe32e40f8db309544837055cb70fe428195682b85fb9a0";
      };
    };
  };

  runtime_3_1 = buildNetRuntime {
    inherit icu;
    version = "3.1.32";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/fea239ad-fd47-4764-aa71-6a147a82f632/20ee58b0bf08ae9f6e76e37ba3765c57/dotnet-runtime-3.1.32-linux-x64.tar.gz";
        sha512  = "a1de9bbc3d2e3a4f5f52b7742c678b182a58a724d36232997511e390027044d60144a7e010a29d6ee016ec91f2911daef28ac5712a827fff8bdde73314b7e002";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/edfb706e-83fe-4a81-804c-23d80b041b70/4f98b067bd2817976a4362c25fbf70e7/dotnet-runtime-3.1.32-linux-arm64.tar.gz";
        sha512  = "ff311df0db488f3b5cc03c7f6724f8442de7e60fa0a503ec8f536361ce7a357ad26d09d2499d68c50ebdfa751a5520bba4aaa77a38b191c892d5a018561ce422";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/09f14240-76bf-43df-bdf1-636aa56cbd5c/4898c400f81d0bac651bcf84dc487b6f/dotnet-runtime-3.1.32-osx-x64.tar.gz";
        sha512  = "9fd385812e770525856d734ca62e5d01ddb534ff317bb09e1091ded38ce2c16dc4bd02b5eebad8ea6e01b21755fe6f5ce6ca5183ebbbee04fa1aed956da4c58a";
      };
    };
  };

  sdk_3_1 = buildNetSdk {
    inherit icu;
    version = "3.1.426";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e89c4f00-5cbb-4810-897d-f5300165ee60/027ace0fdcfb834ae0a13469f0b1a4c8/dotnet-sdk-3.1.426-linux-x64.tar.gz";
        sha512  = "6c3f9541557feb5d5b93f5c10b28264878948e8540f2b8bb7fb966c32bd38191e6b310dcb5f87a4a8f7c67a7046fa932cde3cce9dc8341c1365ae6c9fcc481ec";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/79f1cf3e-ccc7-4de4-9f4c-1a6e061cb867/68cab78b3f9a5a8ce2f275b983204376/dotnet-sdk-3.1.426-linux-arm64.tar.gz";
        sha512  = "300e154fba3123644910bbb89a6e61f67569677efa359aa110871cbbb62afad059709dc362f0af27ece0b9a30bc3e6ef57c3cb7c6f75377b20d48636605f30f7";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e45c25b7-623f-4b98-8918-13a671884860/d6e4526d0dd31d388b36a749f90ae6e2/dotnet-sdk-3.1.426-osx-x64.tar.gz";
        sha512  = "be1c29ffe8ddec6051d7529796dae35fe18036af89d5e7285fcdad46316fec557f4b15c15eed4d676071d187b363c2e16cb3bcbf708b920b5614340a6e51ab3d";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "3.1.32"; sha256 = "06ws70zb4p4wbxx6f9bxk8dmighk8h57m82bnsss5cajabhrs9ss"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "3.1.32"; sha256 = "00ha2sl4gvqv68mbrsizd6ngqy0vv6vamngzjxr338k1w7a276dx"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "3.1.32"; sha256 = "0rvyv3mnb2fgj619rnqixfngzybhgqfr5mnw3s43v9mlg45la8hp"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "3.1.32"; sha256 = "06xbkmplw7vkcsacrcddnma3hawqgdk2hj9ayjs0mhb31n407j3j"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "3.1.32"; sha256 = "0ywz63q8vrdp25ix2j9b7h2jp5grc68hqfl64c6lqk26q9xwhp9r"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "3.1.32"; sha256 = "1crk54a1wvj76s9gnh46pi7wk8ryympm9xh2jq4s4rpp329fqgic"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "3.1.32"; sha256 = "148pspjlx85yk95i6svhv37g483wmbinngd460p1ak2di26qbvk8"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "3.1.32"; sha256 = "17hbn0qvnclhhp6pdygia124qi46lm7r3ixkgsnbsmh7a5l02f84"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "3.1.32"; sha256 = "0m6qq8va2fd1zns85wlm5arhcg57hf1rfj3801v27hvijfsmcad3"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "3.1.32"; sha256 = "0868nlkxi7sy74g6xrvlaiqzs2h846gq52wcmgapsq202lirnjzh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "3.1.32"; sha256 = "1yip3i79ljg2p23r8ph6p77rdmwm6h6gnlc3q2cikz07vib41042"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "3.1.32"; sha256 = "1zygp70xrk5zggs3q4a6yc6jfdwzcsjjsapqpwn6qyx35m69b72p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "3.1.32"; sha256 = "1cj8wspslr17pbkh50xfbmwcicy9n2z9ha027ssfrah8r488d9sx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "3.1.32"; sha256 = "0r5m0837zx2shp9bfgllnhz85h5792pbsacnk7lmmpgld32crzdx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "3.1.32"; sha256 = "08sar3s7j6z1q5prjmz2jrbsq5ms81mrsi1c1zbfrkplkfjpld3a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "3.1.32"; sha256 = "186gjn8sbhp4z6pq8fw4g8nqk9dwyaplwvdz2y3fbbvg36lggsh0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "3.1.32"; sha256 = "1pbrqyd43b3fmd6vk2wph726z6yddazp04ycyxbn5dh9zw8f2k55"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "3.1.32"; sha256 = "0i7vv4zvv4aixgdkskza8x8js4bnj5q4mnw0qdb7dmdypf34s2fm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "3.1.32"; sha256 = "0fk77ij5k33gjydk51gw7k639mppqkyhgarch2701i5wciap2h32"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "3.1.32"; sha256 = "1q36zbrkbgwg5wl7gpzmac79xvwd74zzqg13hrsldwfajmnwvdkj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "3.1.32"; sha256 = "16pgzx3gxgvcgb54z2sd48x8jlz4w242gf68s10ghlnqiiggpl4v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "3.1.32"; sha256 = "13pcn74z1swz73s72zjl07f118j35wacnzgk7kbjqn83nwgqdgvq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "3.1.32"; sha256 = "1lxvj597rw4srkhmx83p1hnf71dcmgg93k982vnvv89xmyvvyy42"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "3.1.32"; sha256 = "07rmk5l0k66x2ilm3r2cpl7icgdzpqjcnrhw89afm9z9w06zz78g"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "3.1.32"; sha256 = "0mmc57dl8plrspdxwb7209wz29vhiwqds4nfbdfws7zg35yy70c7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "3.1.32"; sha256 = "06bk39zcv27cwshjsxfg5d6wzkkzdhfk08sipdc7mr1s8pk7ihi1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "3.1.32"; sha256 = "00n05mi9zws7v88jklyw1a8cjjslx8nnbby1nyxmi6p2acbx6pxp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "3.1.32"; sha256 = "035rs89y8j9v0mshqhaiyydv979x3w1204gcdp2kv2zhvfx1gnp2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "3.1.32"; sha256 = "0qsm03gx86fqx8vadnq3nsin3m3falidib94pc3mb3fy87mapvqw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "3.1.32"; sha256 = "09r2776wbcmn5jh3nksd5ilzv6rrlic938b87xy77awqg251y017"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "3.1.32"; sha256 = "1q09dbbx9kd3k4v8wg75llvz4332b5qsvblva7mhslbmyv47vfiq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "3.1.32"; sha256 = "0biy6p7kvcjxdn67wcmwyrfvv7pmd5249fj3410pw4xi8svjpxnj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.32"; sha256 = "1hs2czpqwa92x11d49m5dprjzr8n8zi5cx6cq8rcnacpynr19ldm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "3.1.32"; sha256 = "1kk8116pvl1jc8k59338hqhbhs8mbnb7kv108xmzbqzygsfgcvb5"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.32"; sha256 = "05yqaxrd981aw4mjg80n19506ls6ni3sy3w0fwiygblaffidj8h3"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "3.1.32"; sha256 = "0p82n92njjahhndawz40jq8bf2smw1c61zm4hq3zi6m5f3x0qc4l"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.32"; sha256 = "0x43pjvd7c58c7230i6ga7d4hidd258aahd9d1z9590z4d32v320"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.32"; sha256 = "05mm56j8391rh8zghrdyrnxnbxvrmwqxy3gn4blyf8rb9xgsy78j"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "3.1.32"; sha256 = "1pz1p935k4y06q8v9z44qwnc96anmg1r2kfrs3a0fbyqn0qkc4i3"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "3.1.32"; sha256 = "0vznqq540gb9idxb4f0l26c2g8500z2fkx0sxrmnla91c3yf9f6c"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.32"; sha256 = "0844r0h1pvb5mvl5939z37nxjb380kbjjf92g64d110bs8397dw3"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.32"; sha256 = "0zr31wppl255hwlhrab78h7r2l4pfz8nz20s66j3xi2w9pvlsprd"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.32"; sha256 = "1g3gxzn035gyq7kq2xwn51vz6wk0473qcq0yi3blakfrmjwdbiax"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "3.1.32"; sha256 = "0a3kq34dk5lj0w7g3v3x78vkcs4jw4wjdxigyc3xwwc29rjwmy0x"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.32"; sha256 = "0gygjx90ibi3xi514mll2jfnq8siy8gvmkj9ckwc904pvzy3q5z5"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.32"; sha256 = "0cg209fkmmm0jfr1vj4454v482y4s4971xcnfsyx5ldvqhvq1nj0"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.32"; sha256 = "05qrs75q38x0r542cgjyjm2l9nxbxmqp75nd3m2zny2wbm9zfqcl"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "3.1.32"; sha256 = "0zb3qlb2c8s953ja4s8a3q26ips96czxm9xd16mair3fb8z4yvf2"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.32"; sha256 = "05z3rxm7fgsmjmx5lzlihxhfyzvp16r888i4jj5v4kb5hb6y3xfw"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.32"; sha256 = "17xyhgf0d3lhvyb0j6mzfv278l9iy800l1l0i5a72ihvjm4ld40r"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.32"; sha256 = "0k0fng7fxssqkcywf4czpiqrfv60qmjf8pw686rmn9gqyd9y6wbw"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "3.1.32"; sha256 = "1hjxa5rld8b1qx8avkc1gd7492vz51r6zqmbqadv1kklg4bf68zq"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.32"; sha256 = "1kdcjy2c02qm0rkqq262iky40vmn1gnz0p1817js4b8a0ha13nl1"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.32"; sha256 = "1q31a7gwl5nl0m4wizbqdd67k0xgrmdbf2wdsx9vx9i3xfcjj7js"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.32"; sha256 = "11p5g8ar7x1czkl32f2s046zlibqqx28b499yiv7snngjcs9fgzq"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "3.1.32"; sha256 = "1paagjfdsg9q0aknwipcds4chn8nfk2y83yhcz3qhi28pzpgih53"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.32"; sha256 = "028kccjihxlyfv2i988g88fw98lhsidf7jj525w96wf9rgkl3m2d"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.32"; sha256 = "1jc46wlga8r2nlmy0rhqcrxa2vp677340wiwl8nskp1sb3ci0p8m"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.32"; sha256 = "1m92b4z727178lnvyh9sq1gx2ncs74q5vwaz4nivjh3fdq1qn9dz"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "3.1.32"; sha256 = "0grk5axlpzwks3p42km6jy0r82ahcmgybgq1vh61xj1nzna1l3fs"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.32"; sha256 = "0hhk71dqy5plq64ml3jc810y2lyq404k4aynv6y4g5j5y1wycx3s"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.32"; sha256 = "0j50g2gjb6qsm1mp6g9bkvjjrih6jbisns74mghx92hk8q9cbq6v"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "3.1.32"; sha256 = "042bjis2yrvsnaviijlpfi0lgp2ds8igsy8cdhbk3mzi9hcgmilg"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "3.1.32"; sha256 = "1y7m9awpcg2ilwkn712sg2hbhqq97yf5s0j9bvrpgb6xh0pzk1f3"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.32"; sha256 = "04rspzr88n1dy86v2n5i8vxkyyxqvw9qfgizzxav8dqsvd9yja41"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.32"; sha256 = "105zgdvfx7w1wxbxjxhwjai72gwk1hhi0hjjrky261ga63j5akgg"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.32"; sha256 = "08mizsssb84saw1sd51qvh8inacf6m6xbhpp6dfnmxszpamrzc09"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "3.1.32"; sha256 = "02k2fhdb9p6vrn1v4d8fjpqy6a89gmrmlpf477i0pir42kwx7766"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.32"; sha256 = "07jx0syqg5833g3rlmca692cry24iq9mxh6fa3w3p76qxx8aqlmg"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.32"; sha256 = "1lhjckbf4679k8fmg7piqizix6d9rs9dgm83kjd3c9cd3m7xg0ky"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "3.1.32"; sha256 = "03s5x7b38mx5s4684jmdlrh6cj5pjyxhs37bwq5jdsip9a24yk5g"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "3.1.32"; sha256 = "0pa43dy3fmsgwmhp8xxsdvfbm3qagj4wlqcbcdm3rhk4i3ww88p3"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.32"; sha256 = "1mhzxyahgqabc4gxmnxfyjpb7bp4asac1qcjja891fp23w4fg0gn"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.32"; sha256 = "0c80n8gwzj5dp1ss1hcb8ah8ah0acx2k277pxzji6i7jxaq9wpdv"; })
    ];
  };
}
