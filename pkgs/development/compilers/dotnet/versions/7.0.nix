{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v7.0 (rc)
{
  aspnetcore_7_0 = buildAspNetCore {
    inherit icu;
    version = "7.0.0-rc.1.22427.2";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/90a3ef50-f7fa-46d7-8839-1ad7a2d64945/ff0d7ad5aef915e19eb255d708a94a07/aspnetcore-runtime-7.0.0-rc.1.22427.2-linux-x64.tar.gz";
        sha512  = "101898d0921f21c7895a1e015064a5aa5f1ca92bd31bd0d30fb9981e3c4383f14ea25464289e4ef29bf55fea1e2096e4b07bce71c948992a76c5ff0f7005b415";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/120c4609-0fc9-4291-b84a-462315825fc7/dca79b88f966455e82d0b864d990eca2/aspnetcore-runtime-7.0.0-rc.1.22427.2-linux-arm64.tar.gz";
        sha512  = "2c704861aca1b1473d1426f0235606fcff19228902dfa02350413bd5ef97c12f70f6f771eb79a18b98274dcb2b866cf4bbc3f53da8c821fde2057e52c127615b";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/2d65754e-061f-45a9-9f9c-8c3910d4e0c2/8b8527c926c21020748d89922ae84eff/aspnetcore-runtime-7.0.0-rc.1.22427.2-osx-x64.tar.gz";
        sha512  = "668d323f78af57e0c781772951288166c05d75d4aa1259a07944ea0fa6ffc857d121d526c275fcf246a9754a1019bbd018f326962f48a5bf16bf2138540ae503";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0fde6271-9b31-40eb-aee1-6bd4794e0fa9/1e5a72a21e733ab866dfb51a8f3b31a4/aspnetcore-runtime-7.0.0-rc.1.22427.2-osx-arm64.tar.gz";
        sha512  = "1b3328451a5dbf2e90c2e1de17b59764ff0b4e9a9d4cf268b6b5f252f90c0af71683c6e31648fcd8df2c0e529a91e9b93eda6df739aa84863d133ca1e4d3fc7e";
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
    inherit icu;
    version = "7.0.0-rc.1.22426.10";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0d25df01-b918-44f3-9963-2f47a1317437/62142b0f944105ceee2514b00482327e/dotnet-runtime-7.0.0-rc.1.22426.10-linux-x64.tar.gz";
        sha512  = "62145fdaf182581cec5ba6bbafd66e3bb2df28379311f13e6849371a88cc2f428db3663f96ad006bbf4411eba609d486036d3b2aa1e3d86eee53216aec543fc1";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/82211656-7196-4508-90f2-b1adc95814ec/b9b2856e7b2a8788d213fdd29662ed30/dotnet-runtime-7.0.0-rc.1.22426.10-linux-arm64.tar.gz";
        sha512  = "961af783d01882cc7bc4334ea166977de9507d61de74057c39ecfec6c24c64d28c65c4b50ea1826db5c6d28c9134c27edcbfdc8139dd74c8c5732102a02455a1";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/61e5fbb9-341f-425d-8e20-dc97b906a886/c30c401a73339b3161eff6faf13eec0a/dotnet-runtime-7.0.0-rc.1.22426.10-osx-x64.tar.gz";
        sha512  = "c4537e67da894f36a224b7c3ffc45f662c684cdf8179214887c48a8d8341091e33b6a8473876fd3f790f8fd080ff26f3a75ad40d1335eccbc3f1addc61224465";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0b2fbc1d-da1e-446e-a052-8400078593e4/e26d013d79d5c6026755b1ab1f71efd3/dotnet-runtime-7.0.0-rc.1.22426.10-osx-arm64.tar.gz";
        sha512  = "d0759ff95fa9d4466473f17998ec34909567aa6cd4d51639155133ebf242ddee38b78d7ce52d77fc1fe6fd9c737ee071b8cce2929ce1db1f2c52aa95879680ae";
      };
    };
  };

  sdk_7_0 = buildNetSdk {
    inherit icu;
    version = "7.0.100-rc.1.22431.12";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bf594dbb-5ec8-486b-8395-95058e719e1c/42e8bc351654ed4c3ccaed58ea9180a1/dotnet-sdk-7.0.100-rc.1.22431.12-linux-x64.tar.gz";
        sha512  = "7ecebf284bd1546e1575b9561f4e64bbb8d69680a7bbda6f06ff6fbf687d3a6c653b0e6a6c569241455c6f83620f0ddbe193ca5cd52384ac062c8565dd22b859";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/620a7215-63f9-47bb-b88a-7798e958ed2d/539a8c04045ab69efa77504f75f07a23/dotnet-sdk-7.0.100-rc.1.22431.12-linux-arm64.tar.gz";
        sha512  = "095561f9c8aa815e3d8edcbb5c449a162c095e0034fbc091bec0954fc8d1286cd8c3aac615bd84b7d19a3a2d038001676057e4886f26a649c4dbc46cee24c8e8";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8b605689-07ca-40a1-9619-e5e2a26a18e2/869ba34d898a8025ffe16f3e914277ab/dotnet-sdk-7.0.100-rc.1.22431.12-osx-x64.tar.gz";
        sha512  = "8b422411a042551750164d3d35a4dc7a83fc38e0f1ddb57e6b3dfe816796b419cb7e625876811efe2ea10b7255f5ce0597fed32782eabfa6309f47c97b9a472f";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/dbefddef-fd07-4dda-a9a7-e3a1b474d314/52d3b44b2fbb9bd2e0e8f17a01565ab8/dotnet-sdk-7.0.100-rc.1.22431.12-osx-arm64.tar.gz";
        sha512  = "68f31e6fa9486b4d41b932fbeb2c0d383033ab72ef9167e02dedad0444383f1e0349c95049bc8db7e3633de65afb93ddff53bc70e59aa03ad632fcce584c631e";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "7.0.0-rc.1.22427.2"; sha256 = "02ykmq87ky3h9gqkzsxjxqc757p4ka40s663h3m2xdmp28f9ky74"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "7.0.0-rc.1.22427.2"; sha256 = "1l0zmhkf2p4ddv81hjfxw3wxv2aap65kmhd3b84z9biybimr1zhw"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "7.0.0-rc.1.22427.2"; sha256 = "01j9jjn1hhvfqyccshzqrki1gvywrjmxg847ssa2bcmyj6169qai"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "7.0.0-rc.1.22427.2"; sha256 = "1gf3656b99my5nabqsni2z9q2c8qxlh2hbwciaw2mr49mfgp0vhi"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "7.0.0-rc.1.22427.2"; sha256 = "09csrbakqayrmf4212bzfcp4ymyr54xi3b7v45rmvvf3xjnzmfmi"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "7.0.0-rc.1.22427.2"; sha256 = "04p4acha98hr9n7nmbc9y0i90k92l8xi9ivwipmpr4m6xkcf538m"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "7.0.0-rc.1.22427.2"; sha256 = "0y6xrlba4db6p9mjmr100c8wwyff30zwybm4icgdfdzfqh93z60y"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "7.0.0-rc.1.22427.2"; sha256 = "1p9jrl7bb1ja4nvhwid9di7d2wm3myiprixh6v429rz13ijb62zz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "7.0.0-rc.1.22427.2"; sha256 = "1zl0wrbpf6h1fm5g6r3fzq3xnbndh7ip2791r1wf9jp9r1kspq5q"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "7.0.0-rc.1.22427.2"; sha256 = "05gqa9dajnic25ww23c0v938r3f34s9aa2awwxm1jm6fvhp5m0v1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "7.0.0-rc.1.22427.2"; sha256 = "1k061jymaaabyqjzsdxgh0llyqb1la0a4z1grlrl8zm33aqwnrv1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "7.0.0-rc.1.22427.2"; sha256 = "18ds1l3lp87fd28kqvcfc0lpkal8krrn305qd63xwcz68bzyh442"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "7.0.0-rc.1.22427.2"; sha256 = "1zz6wjkks0gvwxia3h9p9jc8gg23yh3c6knyb4dlyq792293aa68"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "7.0.0-rc.1.22426.10"; sha256 = "086q85d0135iryzvzj8qx2s61j0ik5d8frmyq3hg19fqd5rz58b1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "7.0.0-rc.1.22426.10"; sha256 = "0b5kjsfylm9ijcfb000kyzixwc932k5b3jzrqm7n52accz5k2sfj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "7.0.0-rc.1.22426.10"; sha256 = "08ysk6qg0ccw2m6nn16pd1mmrg1sgd877434xa31wkq8hwxs4glq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "7.0.0-rc.1.22426.10"; sha256 = "0wk05q8k9khp82ljdl9j5spwh8vb6vcaaqyxx7dxdr7gwrsjfnr0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "7.0.0-rc.1.22426.10"; sha256 = "1157vcvxzfa0ff2bc6bfj11pskwvzy7dlb9356nxfzfaks97yxjs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "7.0.0-rc.1.22426.10"; sha256 = "09786824hg9jagp6aakhpqwvz31466mbza1iql15njr9a647lhaj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "7.0.0-rc.1.22426.10"; sha256 = "1xswxqcx5yn685ma5ihlbrhi91d6mhnvsa3a0jxy4wh732vy5n02"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "7.0.0-rc.1.22426.10"; sha256 = "06633gxsvc1s7jwmvr5xnskkp36mx65n7rmim0xg3bfh2zna7csp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "7.0.0-rc.1.22426.10"; sha256 = "1kyxrbjwylampyi4x6xdxnjw4kl9pq635hgw4jmzrcxmzrnsyswk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "7.0.0-rc.1.22426.10"; sha256 = "1mf6b5yy690c0dg3b7zaxa1m9cjackrlzw3isyibkd03mpazib9m"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "7.0.0-rc.1.22426.10"; sha256 = "0n7pvadx3j1kml3hwgz8m7kp3xq8abhqivghr3jbiypv2jfgszdk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "7.0.0-rc.1.22426.10"; sha256 = "0g4zha2gdjm0vqi0rdsag39mnhqqjbz3ia7qzkb8krclyq9q895h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "7.0.0-rc.1.22426.10"; sha256 = "0qsq1yb2mwx36p0hnfjxh7rzkvrvy2if15dz64x9cpn73zmxam3i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "7.0.0-rc.1.22426.10"; sha256 = "0vl8k3rb7cmd3z6zl2w0lkwxwri1bl1r0g8y5kk2kx3f28q4pgnq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "7.0.0-rc.1.22426.10"; sha256 = "0i8ab2z3mdbi4qn5fa4scl69gps5ryfmwbkk4fmd599p7zg067x7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "7.0.0-rc.1.22426.10"; sha256 = "0zz0g0fzkvi38zh6fvqv4rl83gr87b5rbk0d9z23a2lnlppq672m"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "7.0.0-rc.1.22426.10"; sha256 = "1lq5i1d56iwmvzw0v8yl5l0df4d21hw7b1ii13pl5ncjf0z7h7z4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "7.0.0-rc.1.22426.10"; sha256 = "0cqada6ndn127wqslh88hanwsmxyg46727l8d3m3kwqwimm83nk8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "7.0.0-rc.1.22426.10"; sha256 = "1vg9ai55f2jv368mm32gn0qifj0y0cym962yjayw8sg3f5p063hh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "7.0.0-rc.1.22426.10"; sha256 = "16r96gn6b7slsairr3a4n0zwh435vakrswvnzxsghryb9zdp0bda"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "0kv8w3k11kfwzxf2bkp2ikq4vn6cw62v1w6nc7bcmbxxvrbf96nf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "17lrsda7abp06vk44bl8325jhis26ibvl4gf0wlyw9qnb8dh825x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.1.22426.10"; sha256 = "0zh18j0ll35c7c8q7vw6s9lbb8yvgspcbvmr05fxy894z4xnv6zr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.1.22426.10"; sha256 = "0a1vkygm8il4p32wjwy3yir31scy5x8ppyd1qbqn5dg3ig4svbv3"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "0yq3ivy9m5i3g0m4fn245wc616k0wgzcj57imqanz4x1cxayi683"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "1yygccwscvwzsx49p0ymmif19n2hibwydbynzh116pj1dznx71a3"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.1.22426.10"; sha256 = "1gi0cgssijgf9d2gcnngnv4zwrypk60nd0iy975bmkn3cf4gdlwk"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.1.22426.10"; sha256 = "1h7pgkdy89380fcw3aycxvh6q94fj95fi83wi4w237xf5ghjzdp7"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "0s2nz7ky9b6yi09x26vr9d5fwpannz5zrdmqmlbm55fx171bmqks"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "0hvr0kyrzfx673vwnj12pbl9y3rrdj3dwfq07ivg4kcl1vzh328z"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.1.22426.10"; sha256 = "110j50xxrqmpmsxg7nx9nv8jn5zzm09abdb9dmlyg9jy9ynca4ra"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.1.22426.10"; sha256 = "0xqvas5zy21as9g8758rbzh551lgawg0lv6kxm0xhc84nz0xmq21"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "0w4knj37chkfdy331dyg39m2hqfkq35yfzjy2zvjx4q4zsy7ycv6"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "1mknyd2yydj48s4367pq9dy32ncjws54frwyf004i950w85vd43m"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.1.22426.10"; sha256 = "1sby69w3x01zlnrj3c63j7da0bjbi9v0l6alyh1lhjhgccr79d4j"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.1.22426.10"; sha256 = "041gh95x3l8g4x77mxn8jr57nyh299rbkdpq8qmav035qcpby1fr"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "1iz3mgmpip6i41q5hgyai44i48r034z0wanz9v1hzdnpr3pkif35"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "0jh1warp63nm49kqv11g6bv9kbg3zahrsr1199pbhd0zz3dk023g"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.1.22426.10"; sha256 = "0chr9f9jbf78aqj5p123hg9wsccfykwhczrw9cvldayx3d2nxjkg"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.1.22426.10"; sha256 = "11mm66x8q1pv2w0s1c0wdh5bv8h6fb4hxbd7d4j5jycnwvvlvz08"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "0gyr77c220d13f8gpg5kj7s1blj40v7izykrqicvn34pc4diikc6"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "05ld37x7mpv3yn7z11fhvgg6bnbfgv8zhss8crkva0yb3ahvhr10"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.1.22426.10"; sha256 = "12if58mxpwrv4w9hlhv37lg1s1rfqlh9w4z31sfb95fvkjgajldp"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.1.22426.10"; sha256 = "0ggjcz6p5a3ac6diiwy67z48d25kbj2p8az3p5wharf9n0bixiln"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "0qfmigd8l3f4xrgcs4sp8xykjg3q118103kj4bmnzazqj9av2vkl"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "12clkz57ncc3iph28miz0309lhfc60qhyyd239pmg0lnkvxpxyjn"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.1.22426.10"; sha256 = "1j7477gdr9m0najykd198fkknyx73hbs37sbsba72ni6yl7dlpyv"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.1.22426.10"; sha256 = "1cscsfb8blrip86kny6fw3hfv9dsa9qwls2jjr3ghadvpnmywkd1"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "1qzp7fb60jq2bby31cyxfhcyflas1ak2jjl95yl8nvhiamphlzvh"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "18lsd2b1hhk5z9ykk7vgn31kf67rfcagcs2md0bj97gwq5akl71c"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.1.22426.10"; sha256 = "03zrd1vvsx2bh9svf2kczqwk26l7vk5adbkf9jx8yy5bp46xhj5n"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.1.22426.10"; sha256 = "1yx45y9wck4jfjz8f7xs3y506fw58hg5a7ph2g2x5hqi8idnmaav"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "05w41gczq2hhizcyv279992y0dgvs1j6zk695y3viqvqyvdffx42"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "0la3a2ppq3dvmfq0ia286isj2v9jcghd00l7g2rw1ijkfjdz1yn0"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.1.22426.10"; sha256 = "07grssm9v31zyymqllbvzl2r2mvcvy941if9irsl8nqq587q3vwg"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.1.22426.10"; sha256 = "10ybz35szg55f83ani3xgc7in3wr0579icyz5lnc4p8n6yin2s1y"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "0mmzaipskdngaifs29dzjs0hcv6v265h0mrfyziz8y3a1nhkc3hr"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "0iygn4z44p0nvnrgry7zw1zj93s51m49fw13yw61zmhkk8cd2fxc"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.1.22426.10"; sha256 = "11ng4yss0f4wma74nj16b7d89skj196z5mc438567r28q96cjgk9"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.1.22426.10"; sha256 = "10lya2rd6sgchlihcz9hz7xly4d86k6nf8bf182lvln26pimvsgk"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "1qbzcick2ygbab8pgmrr7h00690y96fgikcw00mi5zx4694lg7vp"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "0y8vdx0d1aqw0y5bypw512bzd4i9kx1bjl5f96w93l987p555pxd"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.1.22426.10"; sha256 = "0l83lbg5j4qc1nd2qhvi7rwcmr5xgp6pdbs0b8xyhyyd0hw6giz6"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.1.22426.10"; sha256 = "0ddmmiafhxp9zm6s90s5252iydls7rmzxrdsy72f3jnmhg40z0r7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "7.0.0-rc.1.22426.10"; sha256 = "0403p8w4xw2yndrfn44qcxmhycz7sjmbjkspp1kwqsy44pg4sp30"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "7.0.0-rc.1.22426.10"; sha256 = "1k4ikdlw12wrczbl94h79fpl23zi6z6wllgjl4yf5acid6vyn7nb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "7.0.0-rc.1.22426.10"; sha256 = "0rak8xisa2ccz71hnxp29lv3brwgk3g1jki7vrniqyr5h0w3h3xi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "7.0.0-rc.1.22426.10"; sha256 = "080j3kh26yrzw6sg6s86n4h9vj0lqi5mbhvhh9rc3yrvzx688vm9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "7.0.0-rc.1.22426.10"; sha256 = "0pbbydrvddq70cgxw49kbafh553s2axkyqgp22vkc48410pfyyz4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "7.0.0-rc.1.22426.10"; sha256 = "0pd1p3anaa5q9smgwv26cicxvv6v43c2l4gxzhl0s2pya34dw00p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "7.0.0-rc.1.22426.10"; sha256 = "0swlgsbhf9hg5zr97v09xgpwkygs9mnbn7c2sqlysx9246jjbpwv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "7.0.0-rc.1.22426.10"; sha256 = "0vp6kjs2vbk7pk0zm6vhnjwn95sh1ln5m5w6jdvns0pddw1m8w0f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "7.0.0-rc.1.22426.10"; sha256 = "1rx8hjkz1z3ph4prkw0h8lyhikqlny8mpdmd92612dz7y7kqzvnp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "7.0.0-rc.1.22426.10"; sha256 = "05mlzk9vgdfcmfv06k9np3yhpg9magnwhf2faxrb2zinyyvpwqbg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "7.0.0-rc.1.22426.10"; sha256 = "0ppxra9gm9767jnpj5893kk5i5gih45q4c2q9s0vaf2a6s28l8q6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "7.0.0-rc.1.22426.10"; sha256 = "1afv87z501j1kj9dw866qfad0sh7xkgjwp5q2745i77dpn9wn5l8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "7.0.0-rc.1.22426.10"; sha256 = "0xc9pjx41k8574k1dns6r3r0fkdmifsx51ivnh63l6h120wyynd6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "7.0.0-rc.1.22426.10"; sha256 = "0f7m1niwcb4cjladps0kxgq0sqpjzsab1g9j0zsfnfrzxnybibqf"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "0x9lmv694pflmk0f4gj1v1qkc56y338rgb8g9jgyiygrh6cpq2fj"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "04by59n031wrp40zblf7cd09f3j1888cky48zcnabgz0wflgjg8j"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.1.22426.10"; sha256 = "0qw11jl5c9ys87cq02b2hfqsx41raxwkgmbpc8pw1s46ycv9mlr4"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.1.22426.10"; sha256 = "1p04j5nv0rqfhxjlbi3viwwwrxmqgw6s8fsifs8ask0v9l47pnva"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "0kvbbkkf147rlmk089bvi9pklwcphp7kgb79g8ijhg7ndiviic4n"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.1.22426.10"; sha256 = "01hhxf0rac8206lgqkxj0k4kkgqp6cnxgpyk8sr67ry8d05a2j6z"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.1.22426.10"; sha256 = "0qyx9cv7lb9jbrk54s2qyzh6sxrply9c6r1nhqj8qqw898pm262x"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.1.22426.10"; sha256 = "18s2yhzb1mgm26jsawr9wz5963j3c21m93rgp417m8kp80jmna7y"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.0-rc.1.22426.10"; sha256 = "151k4jjyqq2ji0lhccc59jy8ib8qyaxljwgbslhmzfxdwsfazzag"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.0-rc.1.22426.10"; sha256 = "0425yylvlcw1avc7n4mihybzcxhzwhj1jxpdwaz5pi6jdk8l7cal"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.0-rc.1.22426.10"; sha256 = "16lv8ggr383m81i2l0n9ncc1dc7mm00vwafk23j6x36256d5facg"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.0-rc.1.22426.10"; sha256 = "05pyyicgbhv2v81x6zfkbhbwcan7cm9mx4hisjlsixniiaw6k3q2"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.0-rc.1.22426.10"; sha256 = "1wvl0pfpbjkksd08w541skwvfhsqdbh2lk3rds1hfcvvpywvrz0k"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.0-rc.1.22426.10"; sha256 = "0nrini9dq8937g1d81279yj46g4vdf6gml386wyb8n9gw2iwdzq1"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.0-rc.1.22426.10"; sha256 = "0q8q3l5i2cw8qa8nypzs228jsvzqgib2qlb5g02s0f34mgh55y1n"; })
    ];
  };
}
