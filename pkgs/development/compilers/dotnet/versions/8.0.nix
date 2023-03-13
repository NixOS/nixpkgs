{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v8.0 (preview)
{
  aspnetcore_8_0 = buildAspNetCore {
    inherit icu;
    version = "8.0.0-preview.1.23112.2";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bcd36740-4478-4104-aad3-97de2eda3c63/4278c479d008a08a82e6ed799ea4cab6/aspnetcore-runtime-8.0.0-preview.1.23112.2-linux-x64.tar.gz";
        sha512  = "8d7a5fbbd62078d55cd93dadb346e8889b5cf4a7337f864839d2ca32283d592d037b89cb0c9940df4cdd956b527fcd3ce5fe608ef7b77dc9ab6d04390e053495";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/63cbd12f-0328-4828-878c-4970ebe2561d/3b0e89d0e68beb6d09ad2323d64d039c/aspnetcore-runtime-8.0.0-preview.1.23112.2-linux-arm64.tar.gz";
        sha512  = "b8f5eb4087267f84bbea48f7c98f53d09cffdf269792c713c9d02b892ebc1eea075a39af7fc3cc63348ee6adc54179a5145b884fdf5d8853b7018c800073a10e";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/60354a8c-773b-4999-af88-f6232bf5b644/19f1f472670e5625ee6a75d09b95653b/aspnetcore-runtime-8.0.0-preview.1.23112.2-osx-x64.tar.gz";
        sha512  = "8fa6786adfcab090872ade64b742af43d75d973d6800ed5be171ba16324dcff7957e52582136116c1e2708e64c08141d4e095088841146d8e651f1f496757d19";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/00e1ec5d-62c0-4084-bf5d-f5667a77afe5/f4d1ceeb2d51a60323084ef43317b1f2/aspnetcore-runtime-8.0.0-preview.1.23112.2-osx-arm64.tar.gz";
        sha512  = "f816c7a078a6d121e74108a9199dfa235ec27e47222e2d25573f8d417560526d9c1e7792a0efe21e0a65e7db07bdbda942b33e38b656d32e9d00d250d7013092";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    inherit icu;
    version = "8.0.0-preview.1.23110.8";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6c535b62-2132-4f07-90d0-2b172d18e436/b4b8aa2b558e1472c650a40707f25241/dotnet-runtime-8.0.0-preview.1.23110.8-linux-x64.tar.gz";
        sha512  = "76436051d57d602e7d45055c64f5ef4db9a3af3358f880115442b3d7bdcd2a4eaad36c59d51d8508049418d9f62a3f7c0747d989d7d758bd84244806a6f83b02";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/29109381-5068-4e80-a3f8-d0c825202bbc/b4205a8a483c639c0cfdf54bb1fb5ec6/dotnet-runtime-8.0.0-preview.1.23110.8-linux-arm64.tar.gz";
        sha512  = "2a15a8affb01c905e9ab4989f58a36bf9fec4e7395e3c44f143657e7d2e3903d7469ddc06c3fd57d3fcf48db4713d2ecd2c8ad2b3e361e8138e1890ba81adf73";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/02916946-04e0-45d1-b36d-07ebc9bab6c2/c160d7f42df423bd40d7251ee015b440/dotnet-runtime-8.0.0-preview.1.23110.8-osx-x64.tar.gz";
        sha512  = "c07754ca2067f38a37b2e4f35eea1dd8a82757906ae21964a21d2c2eabddfb80cb309a2267e619b6bb2447b917d8b47948c7835063200efded1fa35f89edb4d9";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/13005a07-288f-4c55-b874-71a336d4c687/ba476df7f39fd64214b1911ac4791c97/dotnet-runtime-8.0.0-preview.1.23110.8-osx-arm64.tar.gz";
        sha512  = "415ff6cc4cffc0cb25b92a88cd12f4653d087247b6e81b2e3d2f49b25363301ab239ef82d0d174f7dd7b31989ecfa8b6ed4dbf5e37d659fee864bcc22df0a908";
      };
    };
  };

  sdk_8_0 = buildNetSdk {
    inherit icu;
    version = "8.0.100-preview.1.23115.2";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e2578737-231b-493c-a6ee-f181496fe679/18038808d2621094ebe172ca011a7c22/dotnet-sdk-8.0.100-preview.1.23115.2-linux-x64.tar.gz";
        sha512  = "23a14c92e402161ed8d42ec9cb25a97868a1b72348195d28cffa00a12815f019308b56485e4375c0d0a33d9a683d83cc1e1a2a517eea44af8fb353171b6c3f64";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/57c316ef-4b1d-4b1e-b180-f38302132d3d/b938e1b373897fadfb25ff4b55ca32e6/dotnet-sdk-8.0.100-preview.1.23115.2-linux-arm64.tar.gz";
        sha512  = "98518887927605051312554499e197c14b32e8100fe8d8015a4556fdca3a347a3d2215d14069d33b27d978489f3e958c11baf18ba33e1b98580d2eb64cc1097b";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0b01073d-3861-4fe0-abba-41e271c79725/12150bdbeeeb50e157b91f2adab90c80/dotnet-sdk-8.0.100-preview.1.23115.2-osx-x64.tar.gz";
        sha512  = "fb67f43a8a4e56d6121fadb2e2a8a24157d9cee3ba1b0e0bbeb2997f0574f97a525d22bd40ceee026ae782512d9ef88ced892d94af852681399e7e320c1d642b";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/00476255-fac3-4e26-98a4-c487aa89945c/76550e8fb59f35fcb6b789d570b9ace5/dotnet-sdk-8.0.100-preview.1.23115.2-osx-arm64.tar.gz";
        sha512  = "51164fa4a7353d36bf83126e8a2875152ef55b3d0641d61d143a3572c0e169e9e6026e924209d7b9cca93475b8b9fd6e476f733b1d21944e942f67a43f319aea";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "8.0.0-preview.1.23112.2"; sha256 = "1lbzvxjm9mhbwygvn6rfbih2gsaapb33c9bkr48812jz0n1nj4kk"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "8.0.0-preview.1.23112.2"; sha256 = "0p99wvlr0mpg5600ajcmsxhqcazk1m95vivjrw691a7sqbqibrq6"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "8.0.0-preview.1.23112.2"; sha256 = "07j3asxynyby94qi3ky1yqcmakjd06fyq9354r6mkckn30i4ncs5"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "8.0.0-preview.1.23112.2"; sha256 = "0d3qxg43wz7g5kas3c2mr9hcxzm5bw8cm0q4jv17wzwzwkk4jnfy"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "8.0.0-preview.1.23112.2"; sha256 = "0il697pzhd5ikfc76695i3621bhl469cg0hz50j061bsb06q4dqi"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "8.0.0-preview.1.23112.2"; sha256 = "195qsdbrzv3llb5yq0dfwx3iqiyw7v6f8idwibj43347j4pdi6w9"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "8.0.0-preview.1.23112.2"; sha256 = "1jrc4fjydzqj4ksa0hr51ic4xp1ifrsq2liy1sjzsvvkyifbz9f8"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "8.0.0-preview.1.23112.2"; sha256 = "1b0f760q94x33x4masnz9v643adrdqc5xf8cliphd4g3awspkszf"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "8.0.0-preview.1.23112.2"; sha256 = "0vxndnbgyvjminvssx0qlwiqyapsy7fsjyh8ndkf3g5brvr4id2n"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "8.0.0-preview.1.23112.2"; sha256 = "0li0x59gdzgip7fwkbvcfr4vw9h8hkfh96jpj8wnk66jbmyk6phk"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "8.0.0-preview.1.23112.2"; sha256 = "1r5z6h6c9w1xw4d5fvqplsr2j6k1bkw8kp2a7zkxya0f185g1abl"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "8.0.0-preview.1.23112.2"; sha256 = "1317rfzgc1znrzqjk31ykrnzcpw8835y7vsrxi19fk6m6a2ylx4s"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "8.0.0-preview.1.23112.2"; sha256 = "1l5vh6qz4y31l3mxa7isv6pbhaqfd9j23493c8wci1adqg2lhgfv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "8.0.0-preview.1.23110.8"; sha256 = "09f8ckxyw8mpvypzifk3rmcays4jzypbz61gznvhkk1mxfh47hia"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "8.0.0-preview.1.23110.8"; sha256 = "1d433w5750sf540w2nf4m926yw3mciml4z5w1wiyw4fgq3z329d5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "8.0.0-preview.1.23110.8"; sha256 = "17dla35fn05rn2svkap5j2j6579i3sgarama3ma2s0zsd3qbppbw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "8.0.0-preview.1.23110.8"; sha256 = "1qc8h53yyyryfx9c9wj5zzjm47g4xc57wjrcq4ddr6dbw9spyq7i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "8.0.0-preview.1.23110.8"; sha256 = "0adzrwsccm8wl666haxybrs2x3qm86mjl0ql18sz67gxpdx1lbf2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "8.0.0-preview.1.23110.8"; sha256 = "13m9gzs0dy8nr7k8ha82h04491c932z45lf02xpdw7f30p8wd111"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "8.0.0-preview.1.23110.8"; sha256 = "13wnc79f0kjhq6g5024v2vjn3cc0618117vz9bwbkfpy6bnsz1ny"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "8.0.0-preview.1.23110.8"; sha256 = "1p5jws2bdj5swy7r8z32swzn9c0h2mrwalhd3q9f7n8mgqqr9g5n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "8.0.0-preview.1.23110.8"; sha256 = "08w4mkak0kabbaqv9vw2hy65qmz5967z73cmd901l9sr5gr8k9i0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "8.0.0-preview.1.23110.8"; sha256 = "1vshh5crb100kqpis3qxjffp09mkcha20yps4czl0aqy6rv7nacf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "8.0.0-preview.1.23110.8"; sha256 = "0vwx782gmcgmzid0pync6xwyg4ribcq4yawpssd0jldmy7kr8zvg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "8.0.0-preview.1.23110.8"; sha256 = "1r5f67l3jhiw7hyfawm680aag3wlhqx79rarlbgqmh1gs4z3z2ds"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "8.0.0-preview.1.23110.8"; sha256 = "04y6rks7j3mizg1y5ykdgl8kczl31zr99kn15z1z7ymajldxga4a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "8.0.0-preview.1.23110.8"; sha256 = "1f7hklh9vkzxnr81k1i5rhjwn5q9bi4a7gf5lz6lrjg8w97fh1fy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "8.0.0-preview.1.23110.8"; sha256 = "009l5ykx91zy9inrr0xmqqgjgxj9gr20350j1gzv8n0hwd73n3s1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "8.0.0-preview.1.23110.8"; sha256 = "0jllhxnmpmbspk6p9mwnlac1f0pw42vxy4vgc4dm8y4d8mqpbp9p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "8.0.0-preview.1.23110.8"; sha256 = "0vnwx5607gwnjnzs89c48202jiysb92kby0s7jfv5lvb0r1naacb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "8.0.0-preview.1.23110.8"; sha256 = "08mxpbzdpdj99w3a0mbvb2873kd7gf36w76d6qrix1zcpf4chfih"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "8.0.0-preview.1.23110.8"; sha256 = "0kx86mr5jss54a51iyky4x1j7jy6zmac50yr9hdmzkgg4ilqz82w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "8.0.0-preview.1.23110.8"; sha256 = "12ll7kdgc2v1270lww2ylcrlapzrwr2nbd2jx2wjgsb1q13asas0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "1s5z4p505z9ymf41s247w2f3xy3p433sf8g6a01anmkhyrja0shy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "0x0z37702vw2wwhypjvdfxxrdxyhykv30npm3q9w68d00w7kdaj3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.1.23110.8"; sha256 = "1lwdndszklk7m2pmj9b9s1k2h9cp3a8hsas0nq6kypmpwh473asj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.1.23110.8"; sha256 = "0zmxs0v0r92g3f3680fp4mryi74mza85yknzcg2ygvasw1zq57db"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "1d2xvd54lgfsipv5gpakv8r5qvqhxg47k89qbr62f11clqjp1pbl"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "0bc702a48wpbfya6ffaz3jnzl1b01q915v9aqd07h2km57mimyc8"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.1.23110.8"; sha256 = "1i6l87iqkg4695cbsfchzv74smag9wi5xfz6854k7pqhfx0bmmnn"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.1.23110.8"; sha256 = "1ysiwq6z3xz9b0n8prvgd5a5bwdyl86fcan6fy7h2zj3crbc5hnh"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "14xnzkimq1pf7qcm8dlcwszcx00yy39im064yxj46bak9md0ppfz"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "006f41nqrbq2wh6qfik71pf2zqknmckk8g6pf4hbnckp95jlb9zj"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.1.23110.8"; sha256 = "0kd96jcwmpjb0cvpdaj88rnv99vdb4p0fmy05khq0jk1qyxm4h9i"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.1.23110.8"; sha256 = "0qlm6p4s49w7v911pia35h6dh3ljl0yk8gavb0ij9xmy8zkrjxsk"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "10vrhk52f87q98ixmy642avj5b47dhgnhgd9z0mv063xx31f7z4h"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "0hid6jpg4q1xl5lf0a65pj1x4dn4zvim4j4pyhgsshb0pqj9kzhy"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.1.23110.8"; sha256 = "19rylmrajxcmjpfijgmn64z2v935d4rmq9vnm0187a1h9kyvqz9l"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.1.23110.8"; sha256 = "1a3ckzz5l92hr6rhdv942w16654dldcv8s4g3hiv2snd3ra1qdal"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "06ykyfmj6q65fn5xx6hgr8g83k4pwv118rs02wi5sl2xgl37w60s"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "00ikv949xhyd50ndv58inblggjdzphcky8w9nf84pyiw9vpfgaxr"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.1.23110.8"; sha256 = "1h7qkd30q588lmkr7yw68xmm9cipiwbi7lyardcc7kkqr7v3m2r0"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.1.23110.8"; sha256 = "14kclfm2cg55j94nynrqdy3nby98051lvh5jl0r6aw06380g6z3h"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "1p9p8anr605fmrqzll2qlrryb060lkijnsw6w7rarh724jcx6van"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "1gl523fpl5446h8hds2w38lr05x41fnggkb26d92wrl4av3ymmhm"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.1.23110.8"; sha256 = "0y8gsgzx44zyw5ixacm5sisqmclgvf7qi1dgflfd33mpylzskway"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.1.23110.8"; sha256 = "0534xd1n557s09n1bf88ninp7r6cdj4d27dk1ls6bwq9a1f7wz11"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "1mlcgfxpl7n8p968qxs92mis7yvwcf8zv6ypgj7h3gpzxk7mpyb9"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "0hkxz60p0byc10qi3kmhzfgwr5a94y64z5ijagas0s829y3xg15w"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.1.23110.8"; sha256 = "1blcg6isbcbb0vv1misnhgp8005d4kjs1rpjmssv5r7abvz077wq"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.1.23110.8"; sha256 = "1afsc9a1drr7i1blqcgaphggjpkyfj6amc5wrw8r7q3sx6ix3m9l"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "0mpr88cfi1cqlw0asf43jrh4g5j8brz7bmv5ggzjjskq5s4ijyrz"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "07d3mxprv0szcvj2s0fynzbzhx67iamjdil69cavkwx5lkry07s5"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.1.23110.8"; sha256 = "00iz16i9kdmjg8wax6w6ybm810xi6593rkixawpszjqhiifwd4vh"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.1.23110.8"; sha256 = "0gxpywgcda1z82r8xzcw4xsynlc330r4ms9bnfdm5iq8xbdafkbh"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "0aklxhf1kfn6rk9ifapkrrviamrdr2nvsjniwgz02ihms7d38maz"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "12k9flpf571xz14jg47mra12ssv6s4nscafb3zivlhw949bpz4sd"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.1.23110.8"; sha256 = "0p67vwnhczfz6p8vx1llybwkp9wvvk5piiw9pzwy2qi71913l2nz"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.1.23110.8"; sha256 = "1szg1rgyyj0c1fsnyf0xv5m7c2dp9qs13pdaa0r8l0g2nc79wd59"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "03jwqgr2x9lliz4f96bdbc6h1z02dgq037qhjn48s7a9khp3ky77"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "144sxccrc0m5wwp192csa3byyhbn0s40d6gysh9z1da680m6rmvq"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.1.23110.8"; sha256 = "01i9lifhxsali51j4p7ip9jnpdl30cgx8j0w6ib7l4bq0719s5pm"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.1.23110.8"; sha256 = "1rwn1c22a14fkb5wlap81p0amaa2s19z9xb44zwk844vyfyia9iv"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "0gnhcx2avlr4cvxfnz0rwbdbg7sxpvkn1rq7ff6a8gp9wf9xngp5"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "0b0wc36adbfc31wc2lcwbzlb056pj8x9zcp8h1iikpc1fpxn0dyh"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.1.23110.8"; sha256 = "0ahn58gm3031yy9glhdph0chpixxpjykbgjzk2nxi65b6knvn9lv"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.1.23110.8"; sha256 = "063rf8bc5200vzcdig2pm1qb5y9ihnn35dyv2ws2k487v54mchh5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "8.0.0-preview.1.23110.8"; sha256 = "176gkl0hwgiw6dj5j10gaqi7sra2qshhfsrksh2zrr2askrynkyj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "8.0.0-preview.1.23110.8"; sha256 = "1jrmf89v3596gfv2ihfaahx144yaxy31zy4h6mz7g1d3si18i5d1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "8.0.0-preview.1.23110.8"; sha256 = "0j01372ydb1w1jqydyds175cgcj4gnhwv1swzcbxl6ljp8zpjw0l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "8.0.0-preview.1.23110.8"; sha256 = "1vwfp4xwgbffzihx2sxqwq2ywrd5xrnj9djgchmcscssgix8p6k1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "8.0.0-preview.1.23110.8"; sha256 = "094q704n6np5hiqc75p24frqrzw155194128bhs1frhq4qbyfwxh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "8.0.0-preview.1.23110.8"; sha256 = "1zzjs4wi9i06kfv301ib5pgi631w0ssv1sw5vawk6j20aks098mr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "8.0.0-preview.1.23110.8"; sha256 = "1jdbr2425mvyqcycd257hr75r9b5jfm8g2n8ycdily7viagk37wm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "8.0.0-preview.1.23110.8"; sha256 = "03yzv12bxlix9dag8ik3smxbk9fxyw9agnwdqa68dlacqi515w4r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "8.0.0-preview.1.23110.8"; sha256 = "1dqzg08wililm03qx760cjq56d2q340vsrqk5r5i8y3dvzzbmpb9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "8.0.0-preview.1.23110.8"; sha256 = "18pi9ih1jx2fwkvx6smw1vlcyky2cj981v1fnav983ywz5cm1l5y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "8.0.0-preview.1.23110.8"; sha256 = "0msgs5dvjqcaz59dx4l0fxdfs48vab6nypimq4q8q4az52r6pikl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "8.0.0-preview.1.23110.8"; sha256 = "1inn16z3ms723lanc323b0zbvn0kygh67hyi6y9afvn5l6wjb29j"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "8.0.0-preview.1.23110.8"; sha256 = "1h8ijydxk6qby92vcbj7im1vwsyi7xwcmck7p6iqxmfph06kl02p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "8.0.0-preview.1.23110.8"; sha256 = "11lr9a44m9mxrwr5d8yrhv6pjp11lycd1z8jarx553vjnilqaryr"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "00nki84qrr7nmgvm93ivclj5jmxbnp3i0461s03yi7hcc459qhmz"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "00k4g5nah2dc7iwcd422i793mrkg02fz09yig3kqy1z8q3b5m2ln"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.1.23110.8"; sha256 = "0lgkamn3x004wkq0ijqsw0rdfrkwb68kg6wf8lg9fssikp6r75c2"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.1.23110.8"; sha256 = "05c7cxrg2191v8lnbsg0ygj5qc4mj5x9x6088v9m039wbswc4ggc"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "0p2aqc921666d35hgwc45kn6qxh1qn28jq7ca0pql4v8778pxkln"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.1.23110.8"; sha256 = "1wcw6rzqcdvc14p87d5ip4l9hlnf5cm52sqklakgnv15k9a00i7i"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.1.23110.8"; sha256 = "1qddlbadxfk3jmbm41gry0d4nl8rm6rgb58cya3qvwrp4rizxi5s"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.1.23110.8"; sha256 = "1ryndj04m867fdfn8jvkahkm5mq3bp3z4b4skpf6skq9w994fksk"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.1.23110.8"; sha256 = "1p798z08kyw2mnpps9z8f1q7mj76p1phqrikhxh99l12cdcv69z9"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.1.23110.8"; sha256 = "0bfw4wmwjijm7aimf1zf51ghhxabp4ag27x1sgjx9vbysi0g9fjd"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.1.23110.8"; sha256 = "055snp02x9v4s8kqhyrcmasz0dsjw2mp2wsfyfnyjvyj1nrr47ii"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.1.23110.8"; sha256 = "0w2wciixif3j8l210jvdlk92hxmhzydwy7si8g9509a848s3rppc"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.1.23110.8"; sha256 = "162gb1a7g3y7prcp6k40bj0z7jvs6hhsx063i1m1w8a07ng65mpy"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.1.23110.8"; sha256 = "107sh6dmzpv2jign21r50pg68qq7n8iyrd2ia159p3rlchc6w3qv"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.1.23110.8"; sha256 = "1vgahyzblbvgjfl3dcxhd1d2f1jz7bk9vc7k8bi28sh4hm9xq1av"; })
    ];
  };
}
