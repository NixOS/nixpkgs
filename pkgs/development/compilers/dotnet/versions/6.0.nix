{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v6.0 (active)
{
  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.18";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/503c4325-104f-41e0-8dc6-1a8b55e0651a/3dcd8a5d03d3a04bb4111296b12cd11d/aspnetcore-runtime-6.0.18-linux-x64.tar.gz";
        sha512  = "8adbd7c6f303d69410c34ebc4a8df0afb340c6283ee18ca5e213ad502c8df15ef4db35023a5f9ef88a20ec41c733ec5006ad80dc4d31df5c32e5665f7f8b0563";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f60912b4-b50d-4d85-b3aa-3b69504a426b/190ebc4012cd4da240e4d5247b484b15/aspnetcore-runtime-6.0.18-linux-arm64.tar.gz";
        sha512  = "f39b5d333eb096e681fd2b6481a41fe3a1b794c2655d56d84dc79321f767a67d968718b6cf08cf14574af9ff7625c76728be5c70a860fd3df14e40463a8ac6db";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/29f05258-1233-44dd-8810-89401619064b/9e3ab81867221289c6ef76216fcc0a70/aspnetcore-runtime-6.0.18-osx-x64.tar.gz";
        sha512  = "82205097e4d2c4a17ce3d6997bfc05c3aaa28359dd71807eb0d2bf3f4c5b2142e05f21a50e5b2f994b62836cd5f4c73d1c98b1f8f2662afc43b5e70040d9ef3f";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8727a27f-8715-4651-89d9-dd8f431928fa/4f11488f22cbe8a052991b00ba2a99df/aspnetcore-runtime-6.0.18-osx-arm64.tar.gz";
        sha512  = "ccdf62da6470d1b74f0c866a69503e63ebca2f580156a64a3f82c1a8663e9003088eab0740654f2f0119107ec25d204c5b279cf036b1067ef110fc3eda84794b";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.18";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/53fce0ba-88f8-44e0-8174-16fb7d6f1a33/7e4ee56d0aa754deed6cf4db31dd9e25/dotnet-runtime-6.0.18-linux-x64.tar.gz";
        sha512  = "bcfc88238f901c14d203a33eff036106fcbcfc40de7e3717f61434dffd86b5444c176dec5beeddcf80e7193f77bf793ab1e2284c91d54b93931a4668ba77c634";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/29fb12f4-03c2-450c-99d4-6c94fb47a6b2/18e308e40e503f02696f00b719ce581a/dotnet-runtime-6.0.18-linux-arm64.tar.gz";
        sha512  = "7c9006feb7fcc22510ef99841e55b0737fc3cb7404f3aa0f56eb4dfd82da62dcdae3fecf0125ba1f1b5d17607ed595741e802dc2234c79ef1047a9e99e61b6ec";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8b68e217-8a0a-4398-9559-7767c973b26c/e322082fa4280a2b1f0904d74750aeec/dotnet-runtime-6.0.18-osx-x64.tar.gz";
        sha512  = "67d7a3a5ef59ae16c76c82fdefbdf5dad8920500f03bf868eed30aa21029ae06e3951a7a5337638cb7449ffe643a6e7307bf94984ba7dcab5c50f4194c484ca2";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9dc8fb0b-74d4-4c1e-8eea-b4cf02151db9/e5e72a0e4773f5542d3bedc735736774/dotnet-runtime-6.0.18-osx-arm64.tar.gz";
        sha512  = "3183a2ac94c2e33637e8e193dacedadafd49e7b39b10a9429f0d9b4f1b7beca1eb72539574edbc2a9c6f97b36c157635bb4b765adb791fdbc4a477ed890aeeab";
      };
    };
  };

  sdk_6_0 = buildNetSdk {
    version = "6.0.410";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ac5809b0-7930-4ae9-9005-58f2fd7912f3/4cf0cb18d22a162b33149b1f28a8e045/dotnet-sdk-6.0.410-linux-x64.tar.gz";
        sha512  = "8c85f5b10eb786c8cf31bf268131a2345a295d88d318310dc8457d831f0a587ec1600e43beb7f55aec2248483b9a95e905a468b592f0c910443b4aaa9baeb2e3";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bf758689-351e-4857-8e9d-b2f155577bcf/759401b27c3c68d3ae344d2112bf9057/dotnet-sdk-6.0.410-linux-arm64.tar.gz";
        sha512  = "75776b101672714f4e919b71313c3abba6f9b8a14d36751b31fb5400106e87d55e3aa45c1bf25be26a40847637f583815e40d61a837bebda66f30b88294f7e49";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/190b69f8-f50a-4d68-bd44-8bfc5271265a/a29b1769b5e5d73366cb34ba3bccf9d9/dotnet-sdk-6.0.410-osx-x64.tar.gz";
        sha512  = "dc9aa3a04b3da513311b385f28e2982879432a79e6de3da8d7e339fcb02e2a6684e12be35c6b193cda1ce02a9979c91eda5d2e7295cdd264f1e09ae5651d1b22";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c9f8cecc-df92-4720-bb4f-273c55762b68/7abd1ebeb6241949dae538dc72532190/dotnet-sdk-6.0.410-osx-arm64.tar.gz";
        sha512  = "c52d9bcf96605b2cd76eaa7c09455d8fea29bce119c7072c94b4c51dacc171ffd3ee3d38ffa4a84f1d1c750ac8d957447aa4c77c71c4a90af4407ac9a1afa6ad";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.18"; sha256 = "1k7hqyyg12478kq0y2r44vqm8xbdci7hpqgs7aa1yxs4n9i4iqjx"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.18"; sha256 = "0g3hyhafmhyp58plsw4vzirpjy854qn1hmnwkq53hg7rbxwqyz6r"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.18"; sha256 = "1yrw2wpxhvb9l4xbzs3f4ykapav4van5ibv6bpqnq1f4l5l7vm0g"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.18"; sha256 = "1kgzlasbsjpkc2q08hh7ck02d3ib3yjfgir2q9vxm8k9np20i3w1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.18"; sha256 = "002jll4a28j1rxn1sbhnfp0rlkx70hh0i91y2yzxj10hbnpvylbq"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.18"; sha256 = "0n8xf6znd4sr0gc29s234hgdviygwzpsn13nh8czkvrpy1cnl2qs"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "6.0.18"; sha256 = "0zwh8rp233kd0z7ldbgr9hv5xgcv7rm4kak6z2m99r8k7qfs2n0p"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.18"; sha256 = "0s2n8l206cjvzkvjqbzrnfwzpd0x8xgarw9hqrda7vj9yy7a0x80"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.18"; sha256 = "0qhnlwksn0ijaqlk8n9yhf6r0g1i73kdizmmndibbqynnl2vci5c"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.18"; sha256 = "0hn9kdcmbbpzi2kmjancarq42in77f14jfjn3axj869x5w205lgf"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.18"; sha256 = "16rydr6kc2hhnn9ws1kf4rqm0a001i56f3ayv5l4bn3z95rvdm0l"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.18"; sha256 = "1ls4xcsx7s635kj6mdffrabrn8gwyz0lnqdfbc90pmnh4ddaf7il"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.18"; sha256 = "06vgbl96pqrd39wdxypvm3nr9gzp4ddwqxryv5z97dp9prc5kmn0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.18"; sha256 = "1f9f8vz65fkv65m4p36wlisl7vzw6s27g4pzmcp5gliv8cb8bjbq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.18"; sha256 = "1qal9m4q24rfx4qps2x9b8ivl0kkfy7jwi4x6cm8zwhlk79zkdr5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.18"; sha256 = "0mcyyxji1kpw92svgag6lvgg8x0h50p8gnganrcw6fhp1xfrd2wf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.18"; sha256 = "04by204995rwhsp868sc4zbrfx73zffjd5pcmzdvqywyp9dh5cgg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.18"; sha256 = "1mhs8f7k7rc562yrr9h320jfbjlys3715d60x1h6822ywrc4qfv4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.18"; sha256 = "1y5p2jq8v26nqzblapkblpmnc5hlanvqn68dpi1nd3j9n34ixjws"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "6.0.18"; sha256 = "16sq63639mp1vp2cjm7nnwjyw6r0xparwdx672hrjyml19k5h4fx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.18"; sha256 = "14yi7ks31lmb7y4j393pgcjfm5wsz7v5a6l90lnqxlmfp99whmgf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.18"; sha256 = "0r1l8x2v0i4s2yv8n8fzj9nbpcpjd8fcvkx1df12lgscjzh72dvn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.18"; sha256 = "1r68bsj35pjlxb1gizq004g4yv2dc4hfz96i4d7i9dvi9i8smr9y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.18"; sha256 = "01mimhz0vnbhz4w7rpx21qchql4jb2lzgl6ij9n4ifa69dl936vj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.18"; sha256 = "12vzd75hfy433l9y2mncybbffsk93rcbvbfmb9rs354yan9phjsw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.18"; sha256 = "1hwkh1525gb20xybcx2fwk3ycqhjkafgmyczgp7p76y4l3can6fb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.18"; sha256 = "1fvcqnxrishcyrgix02ib86wgsjqmld5nhxspjb29j64f6ywgdsq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.18"; sha256 = "0p77flwzh7002yl88270b05l549mk708h4bqpaa28j556l9jri2b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.18"; sha256 = "1bkiv4b18zz399zk4sa8gnfl5vmm8an24q9llmic13svfcv1k7ag"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "6.0.18"; sha256 = "09v7zm429mafbsa8a0sqaawbvzf52bl2fb51v40k8vdznwn9791b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.18"; sha256 = "16whips03k4gczvsga5yfhg2g5vpc80zwnlz6wgs53wx7lbpl37l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.18"; sha256 = "1p8827cj7jl4g72fapvkzf27077v127x46r9g94qh7m69r292bl4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.18"; sha256 = "1pc9b2fvv7fl72x8ckf5n00998ip2wagw3sxfx8jsqf74d2j8qih"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.18"; sha256 = "0cs10j6g6r3k3zrwpfz4h0jn68pdl88ik9xbsdlvfv6v73npyfwf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.18"; sha256 = "0lh8a1ch6pd2gfn48kwbpaca6ry1rk7l25m5k8hpgbaw0qq0sw92"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.18"; sha256 = "0bv4dyzhy288j22x16x5qrjh8m9va4kxmbjhlhc2ql9bhw1g000m"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.18"; sha256 = "0ljnajylmyc5b9s2zb5khrzniq0qqrrcy6apkkd51x6fqyyn3cb9"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.18"; sha256 = "01sfdl4a6mwisicpf7by3b3kyhp2i0zc30s7jrkwx8zd5kjxb49b"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.18"; sha256 = "06lsffnpa104mn1scqrcbxpb3wiri73vz2msnanfljnhdyssk29p"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.18"; sha256 = "1assfk42xn1fwkj39lqv2z57rcqj88wk4w81f5y2xjmrzrdcxmka"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.18"; sha256 = "094vxdlj5pq83vvai9vfrp1d5fz8wddy17nhcs0h6wrfnznkvz1y"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.18"; sha256 = "054hfb98wmmaanz2z7kfjmw5xjdf6lwhxzg6d6lbr4x81l2mgs1z"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.18"; sha256 = "11di1pk966j9dlzdfmhl5h3h1cjng2mjjwh7mpddnj96pxpkc4hk"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.18"; sha256 = "1nbyk4fbrv1aad0n77a4ha1csrp9zlcwqjx5536vpiaqjf5sfbvl"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.18"; sha256 = "1rdnqhn984vvci076g9w1im8mjxay9dvbjnxj87kwl41mvnljk9g"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.18"; sha256 = "0cxg0fymvzrghfwilbrgqxmk4xp5cp7395y9f2jaxz22jdnv7kpv"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.18"; sha256 = "05bx3zdsahfbvrk36hyxbqc08d72222pvz8g87cafxif8md7fkl9"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.18"; sha256 = "1j9rk58g2my11f0pna7gd97l40wfklkmmlj0qsklbxjqjl3xk5qa"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.18"; sha256 = "113fxlvg4k9jiy0ycwafwn8grxjl695r46z5gm4d6i9cp659h9c0"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.18"; sha256 = "1fzqyxp53jf8yqslv9y068pf6id0dkrfz7jiv1qjgiypkanp8ynj"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.18"; sha256 = "0d1m71j9p846bgcw6wcqc0dx8v9p66a0z69pfkqkrra0r9lp1qn3"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.18"; sha256 = "0p6ggwq33vsdglcl3ws13l1lqjymqpn716impk44lbrnbyrm9k83"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.18"; sha256 = "11v94hivxl6qczc92g6xihlzm0dphj7alr5q691sdlix1jswxjyb"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.18"; sha256 = "09y96wran7cx4wyyhkf1vbmsfd8934ichbaa410p9m4ncqhnrk9p"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.18"; sha256 = "0b18v2fxalvbsk5s30nlj3xxph2iwr06n2dh2ixas5f835xx1wfp"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.18"; sha256 = "1jp0xhd18y5ghkbzbghl5nn7wzvg58if8rh867h4r7m1qhv67vnn"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.18"; sha256 = "17nc83sb16k6dzlawp1hpfc050gqhdngndzr131fsay9iwmzir7m"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.18"; sha256 = "0g88jm1n0ydnf5zflmsf526dyjqhs470y5rg2xl7v00l63m7ad2w"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.18"; sha256 = "09nmx6fx49x459k7mycpg12jkkpgfrmss83byqwlisl333dzm11q"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.18"; sha256 = "0054vq9vc6469yk2z7mdr6yklkjmmzkl07kpf8h2i5crdpwk36jj"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.18"; sha256 = "10pvb6l3zfdqxibh3v510yb2n4p8c557dk69jfdv6s2zi1qy120m"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.18"; sha256 = "1d0jaz4cbzk7jc2f0x3sikm9l4j3d67nsnyrakz4vlb8jlwwzs0v"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.18"; sha256 = "02r2z3f6dzagkfs2zdlsfwmff8hps0kw32a7dqj8mfcadv6wsalw"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.18"; sha256 = "1z65b6gch6pa7gsnc7vqy5xarx040a5zh5brq5sinh18hayl4npj"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.18"; sha256 = "0fivivvxah8k868hwh2knldbl75wamhagvjjys4s1jhqq4zbyd3f"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.18"; sha256 = "15gf2xc93lnqcrxfknf5yi7qpm2k8j7i15l977rnjf4nk83v9jvm"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.18"; sha256 = "0dhnqgjfz0qkci6s3s5ffv5616d1mqnn0c9n2ny4ky4p898z4yg1"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.18"; sha256 = "11mla7ryfw2iff7zl9bj3hv3cwgxdy6r091l7pg46m140ygskrd5"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.18"; sha256 = "130p2d546zjfdzw8ffjbx67z5kdw4psmk8qqxcyl2337sb5nliyd"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.18"; sha256 = "1k7l5aa0kwfhp7910d7kniibpj1injc5wplpi1ij91w1m061q2j0"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.18"; sha256 = "0x89vimghn10ba6xj7h6wbg8l58lya1wzay5cpqv41dfl6670dsi"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.18"; sha256 = "05597cq78zw5fvza47gwb70rmv8ipq75197fs84p436w6x7kvs5q"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.18"; sha256 = "0dqvdrv0kza7d9bajnxfgryymhjx7ili28j0a6dkqmyrxhppyx35"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.18"; sha256 = "0kxks9v18r87hjl5bbk868zl90fyq8ln8dkkg7mp5d4xyfbc8kjl"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.18"; sha256 = "08qnzlcn8r2njll6c9bzvn8kx7zhaa8rx4f189161jlnxkaajcwv"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.18"; sha256 = "1viy6i3zxjljyfkjm8djkjzqs4943kcj0x4kim5nwwc1b0ra98qy"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.18"; sha256 = "0xddz7bb8f8a1hiynvyjfbiw4gvacl5gm86024z1rbxqdvbd33b4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.18"; sha256 = "0vkgishankfvynr2lpxmjygiba7pzpk10vkbq0vv97qj07pr6jg6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.18"; sha256 = "0wgkcqfp4f8fvfynjmwxyqk7qi59xyz5gl64kkfav3l8mhh0fc7w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.18"; sha256 = "1j0vyig0ycl5b1g527jjd8901s0qqsc9i9k71bjvjfixlj5n2r2d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.18"; sha256 = "04h09mdr2bgh9sx8134sdxk29h41lj0ss6ds7p7x6pvi7x5358wk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.18"; sha256 = "077z0m9mysp1qnx4wy2iaf71zah92fh4r1ipivx57gp6588jm3mh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.18"; sha256 = "1riq1f8ah0lmaxxnqhw9hdlwlxg8q4dqzkqvkain0sxjxzky7akz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.18"; sha256 = "1ngdjryqk8nrxvhk6hmwl2x8hgc8mxqhdkh55y55vd1kzivd21sv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.18"; sha256 = "0xlpqnn98sjmr9lr9kb1whi7mb3y2rjzx4kw6zdbksax87riwsfv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.18"; sha256 = "1iwr7cxpc9i460r39adcxlic9axcf1llhhrkhika7pwc0b8x170i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.18"; sha256 = "0nmf8i3vn9sbcfl4szdgvqp3jqzbys0lm45fsasyddw8q7mxgds3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.18"; sha256 = "01gvxwqz52f00hfb36np36wvj52rdwmx8yl42hahym9y74nficwv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.18"; sha256 = "0346jb9g6m0ycd39wkl5bn3djrd9jh9jw0n86cb51nm031b2cbpp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.18"; sha256 = "1slmdnw7skplp7wz3vfn9yc5qqp92j3xl68accxv3xlf33l7nc65"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.18"; sha256 = "1pxvx13jxcywjc23lcy3aw5khjyakyxizy4acmb2qq23rkpsgi7r"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.18"; sha256 = "1drxcbsdq094vskmxdja5s63wvd7ifj27ccahb42hn7qgskkklrv"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.18"; sha256 = "1ngall365y0ya501hv3gszj7x5rwpgyxmv82v7y2zgs2fjmi7jyx"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.18"; sha256 = "0iva4c7y2bxypn06k8x74pia98lx1sda2w47m74mnw22bqchvgjb"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.18"; sha256 = "1g6x9815l1pidg1hxhv0pdqq27bksq7fwrx3r0zkd6bggfpdjrf0"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.18"; sha256 = "1kjnksa602dc3j16zgck3dlbrd6sp7mwsc65f4ps3s8b1yjf3khq"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.18"; sha256 = "0c95g1kapwsrbz51myhzpd1wviwlhvknhyfl3q5jy03z1kymxscj"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.18"; sha256 = "1iy2n5b3wwarsrkhm937f87rir7md45m5hm51qfzr5i3bx5vabcg"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.18"; sha256 = "09f5dcdvnfs9ax5i4b6kqpj7frhw66madla71i2m3azayqd0kis1"; })
    ];
  };
}
