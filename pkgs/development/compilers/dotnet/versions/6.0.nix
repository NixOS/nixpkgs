{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v6.0 (lts)
{
  aspnetcore_6_0 = buildAspNetCore {
    inherit icu;
    version = "6.0.8";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5cc06c3a-4d8a-4fb2-8f7a-ecd23cd8c4e0/dd386c0e3a41ea54f459907c834acedf/aspnetcore-runtime-6.0.8-linux-x64.tar.gz";
        sha512  = "b74676ca0d2f47a95533739fd36977bb1552890a81820ee51b29b3d6514398f0952362417bbb31fad4bdf031803cb3e8d2aaf065dfb154a78a1b471a536d4abd";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/83695c9b-c954-459e-b9bf-2f1ac269e34e/1316ff4a6fe4c6916e7ecb3623d67cee/aspnetcore-runtime-6.0.8-linux-arm64.tar.gz";
        sha512  = "07babe85c8872ca303a17268b0d23c382a9ac49f8b923c45c496db039f6c01094303cd18cd31f964ba7369bb993c896eeadbb7e458a77d5b86992222b91db52c";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0601cae2-aa41-4318-a996-36633cd641f3/ffc290161ae37b28894ff7465dd50c17/aspnetcore-runtime-6.0.8-osx-x64.tar.gz";
        sha512  = "73d3569c13965de927e9d1eb02ce7d31b44643335a351ddc6392be1a693837263287d9bc5e82a89f2456b7a9cf1bd6c217d9f98cf9fa8da1b6c820e9ddf43933";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7859a31f-74c9-4756-a9ab-f040550666ac/3c4ad4317e732436f8c092eb9cdb4168/aspnetcore-runtime-6.0.8-osx-arm64.tar.gz";
        sha512  = "a6cabc3b4c7350deb141e122c194c7eefaf99127cee726ee227e4218add7155b8decdb2a5cd217f757410e267f2370a78806c22a0294098f245105cea925a7b2";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    inherit icu;
    version = "6.0.8";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5596ef6f-a174-4fba-aef1-99173e3f3c67/77edd755d605688885ca7114bc4f9ae9/dotnet-runtime-6.0.8-linux-x64.tar.gz";
        sha512  = "c776813bf87c25766b31a3a514d124d0526086ceea514a10f104d70ba435c91a6bd3c8bf10c6662b4df2b13ffcdf385518f3418e51d05cccec6a2cf2c26099de";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/866ce4df-8aaa-417d-ad81-26131a2b8734/7ba8391188bc194156ee7d82f494ee00/dotnet-runtime-6.0.8-linux-arm64.tar.gz";
        sha512  = "7cd60eda5219a6b882e53e85e2b6543dedc91605503ce8085f447835382fd1b6abd7c8810e0fd865ecaa33167cedf2a33884dd4eb2bdd2857fe69d509cd62a9c";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1c11dcab-2b1b-4f89-88a8-32665c56a131/c1654a9f3d01805033b7fd8d505050e8/dotnet-runtime-6.0.8-osx-x64.tar.gz";
        sha512  = "8100003430b073e9f1f16910eef8af5a5ea806754a1818971ba15f4ba44e12455330334bd1488088880f7ed3ff67c2a4c4a3d8037f4202c95e6bc029806c8b15";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0b8a7b71-8f77-439b-a4d8-b4fd863466d3/7a852ca4536bdef2e63d9f5e98731777/dotnet-runtime-6.0.8-osx-arm64.tar.gz";
        sha512  = "99264f4e34e2b6e1a82f3716cce5753967f3386348593e7f51085d96dbec4acf1400a451e9320afbfb45a9b777df1f8bbed8e78d7c4810336f3d226bdfd4343f";
      };
    };
  };

  sdk_6_0 = buildNetSdk {
    inherit icu;
    version = "6.0.400";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/cd0d0a4d-2a6a-4d0d-b42e-dfd3b880e222/008a93f83aba6d1acf75ded3d2cfba24/dotnet-sdk-6.0.400-linux-x64.tar.gz";
        sha512  = "8decbba0a6b09501daede52cbb5a9ae9e5f31ade201918c03efcd1b4cc345ec934f88321704ec3beb1f90f2204934be7259c76f66d9204cbdd15933582602763";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/901f7928-5479-4d32-a9e5-ba66162ca0e4/d00b935ec4dc79a27f5bde00712ed3d7/dotnet-sdk-6.0.400-linux-arm64.tar.gz";
        sha512  = "a21010f9e0e091bf0a4df9dfc4ec9893c056c2b07b10be093ea392a4fa5c8a38bad9535f66e570b45dc25165b685199fb729434b845bcfb35f8b79cceb22c632";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f52fb2f4-a0a3-4094-9f75-add72fcbc21e/d46eda7abf39baf278c0b0b040c7b81d/dotnet-sdk-6.0.400-osx-x64.tar.gz";
        sha512  = "35b80347e31baefdbd42e7434ffa0df1069367a4f8deec8b4051a44658b3ed531832f0e92357887a2f5a27c6433304537c846cdd4793aac874bace82a899053e";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0e45597f-a72d-42fa-95c5-85a811a7a8b6/1d77d2eeb8c08815edd1a6e9e9dfda4a/dotnet-sdk-6.0.400-osx-arm64.tar.gz";
        sha512  = "c3b016bc558f42fba29a8aebcc04be7b3aa3b0290755b6ee2fea1f48f921da78b86cb31913c4b7e32c0421b45a617b551ba593f98f349fae43ea1faa38348412";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.8"; sha256 = "1sxl6nsv8magamqbykdr6jnd9q6r1afavc7pzm2jmcqyxv121hv3"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.8"; sha256 = "1qksplqav4nrjbib6hrbdqg8rd8lxr63ljq57p4h7lbgw0wpxa5c"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.8"; sha256 = "049s2617s3aqcqxbvb0idrmjw6vnwjjfnqrn7s6hi2w4w5f4z10x"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.8"; sha256 = "0pphpvag4i0zq7c51r72b9zjlj726wv2hn1vxd1mdsj85f2q77zz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.8"; sha256 = "00hhv36d8wjdhnz10jjdv3nikpd4x0sj6v2jfi5p3firl64p5wf2"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.8"; sha256 = "1lcvphg7s6iwh3dkl9c2c0h5mx9gsp0aic7v2xaqgaq3sz0jalnk"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.8"; sha256 = "1lmcy66m1yrm0ii1agydn8zmvydjf2sdvng5x07vda574shrr39h"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.8"; sha256 = "14q6sjbcs1xvd1lz670bnq4pgi1cgayih2bpsjbv33z6w1wshay5"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.8"; sha256 = "14968kh3c0028nyyxivx01wj1k6a6mk2wm4fk0sbh6p2g7wpaqdp"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "6.0.8"; sha256 = "1dmajf3hqs5njm6yd6g9vy72sndf93g4p6ghsjkxizgz46z3qsxh"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.8"; sha256 = "1cyczl8a4b3plb7f1w0jp06v65yd1fk7mcx2y1jr8qpcmxrad3gl"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.8"; sha256 = "1qcg7awjd9xf6bvn5wsbd8kiy3vf6iag8q2myzzzy5jj4azbl2wd"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.8"; sha256 = "1dm953nh7d1k9cpclxxf3831rlx739skrxxw1whqnczffd8rjfmd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.8"; sha256 = "1g21mp68ljpvv6g4xgzihpfn96szchpny1h0g9g71bwbgp93aad8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.8"; sha256 = "0gp93f4ch0h95wl30xbz60xn7i752hvjkiivn3q7wnkary2g8mpr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.8"; sha256 = "1bdfpxs31x0a6cbb911vl3ncy26gsffgba3v598k6ki4662xlawv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.8"; sha256 = "0w5pxahcgxr4826hv6b72aq60gpbbrj6va2hvj4gzi917dkqdb94"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.8"; sha256 = "03x0zz9ig1m78gmf2r8wny1y1ripyzsdxak6cqha1zl8gbf0bcck"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.8"; sha256 = "167kc0766ppkfrv66b0xg844cm7vj7q6p3bm695j8m0gakz71kx3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.8"; sha256 = "0a0zrk6lcmbjyl0wkal9p0xw3n5qzvbc72by492vi3cwl8j6qv6d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.8"; sha256 = "04l1smar1hrg0r5pzqa5580aw17jx4cbk7i2mrgj7yy2m86m3d4s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.8"; sha256 = "0j1qdixwxj2bwgcfxf6fbs2krw6gcm7s9mcx41z9l9q4lq9qh1gc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "6.0.8"; sha256 = "17ji5vjqw59dkrjqfrdbmwf318x9f61ch855l6z3099g84bp9nqk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.8"; sha256 = "0c9pxqsi99m91c25n7j2pq9gmyl88k9bf4a5bisqv7v5w7mi2h9x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.8"; sha256 = "1k8jh8s2rqyp7rr2vdwqfj35zkr77vnba4jnmgx5ank87z24vmhd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.8"; sha256 = "1z5ja82jxmlndivxrm4abapg41zkgs5bjc7ks2azzn8znghksvya"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.8"; sha256 = "1654jcqp80i3gkasf9axnfrjnk8iaxkhgfkbrgv5fi5vz0lbgi2h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.8"; sha256 = "0999pi4dyr4l7grrw47xip8prqsc3inpz9gkxjd34dzi7wcpfy47"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.8"; sha256 = "040c6505idayhym3j90ixw85h4l6m23nlwp5g9zf4p9dl2mfgicv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.8"; sha256 = "0qd9pz33wibc3db2sn452wd5vipzq6kf7gclc6lfzz4cavlzqxc4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.8"; sha256 = "0qzkybsfx4pps97kzyy8325brljdi4h9vqapcgyfb2rmkvvfqsby"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.8"; sha256 = "0fxp7zz6pjxhmasy7xza9gi83zag81b2gpp08cam69kjn1razlq1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.8"; sha256 = "01fci2411qhi6gxp0jddmy4pb248n08ng8wxap37ysh5zc1qmjcm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.8"; sha256 = "06ahjlsr43vx3dnw28fpkk2vmagrrn1m8jds8pdgj44jpn57lc8r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.8"; sha256 = "0bz6qja5lbi1a7iqkbin4p97dinn9iykw0x0nmmjs4ihx33ic1jr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "6.0.8"; sha256 = "080jaw5y9zwfsj3b0ziw3s75whankyn99q5sjhq7pmpi6763xw48"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.8"; sha256 = "0wmb4jx6l9dg17ng5cf4k3s54s08lf220gzphdgrcl0w1jihg7n5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.8"; sha256 = "067blnpwccsfp201803yrb4j4gp9vzkppgc4h7s13dxjz78cf7ss"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.8"; sha256 = "1ws1sbsly7n7p6p5k057m063vk5by88fxfkkqw5i61vh6iwkcbnd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.8"; sha256 = "04dknyln95q0qx0h374d3xxs5rwh4sm0j489p370bkv0czl0ha4b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.8"; sha256 = "1rav7v08nc01b443cy58gk32n6d30zkjx99m8hpsz17vcxw8jiqq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.8"; sha256 = "1g03lm7ckqa67m9l701lmw6pwxym8l390zlf8km02gfq0x1g2fyj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.8"; sha256 = "1wb9db76nnm9sr2kj8q53j8wamybkrk7x6gwqw17xk6cxq2fgxq4"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.8"; sha256 = "02l7ahcrhq8lnxnf323d6qk3saha73d2sbmgjmp1rcy5q2mqly05"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.8"; sha256 = "0cinkimphbrpjmz38acrmjqr9md4vi7ad7r757gm363z0hal2783"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.8"; sha256 = "1dr2a2bgia8i5pwk8b8z3jwlbkshh9pb8hhzbkhjmc56sx49h0lx"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.8"; sha256 = "1kj8a9l65slgb3r45b8x5qnhcs80bx8437cfisyfbhjkw17i5cgg"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.8"; sha256 = "1v06qri2f6h2ndbaydgsnpas6nfhvi58yx68v3w4gdbdablnycvb"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.8"; sha256 = "0vskm16p0aj7jlwsp5mfbilszwvfaglp6p69196v7kdqmskwxw8c"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.8"; sha256 = "1j1j81az67rwdnqfapjnvxx35fjr1n035pwb2nlg6kz2r2mfw4ph"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.8"; sha256 = "0sfqc7v6zi3ma446jgrd4bjfjl0d48wpyb40wc1frcsvms9zskwr"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.8"; sha256 = "0sp90fz8qyz7gn2fmgavsq909dpk44ymq3cs1mxdwfp3v9dssmyh"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.8"; sha256 = "08k90llf2p1bg62w1mk7vv5lk8s4ymfq5j6hdl1al5an4gl7niif"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.8"; sha256 = "1akvfw5p9s7w9jr09s20ph4x82kfbabsbd5dafpvakd4zw7cawfx"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.8"; sha256 = "0r4fbkjqy1g9cmaa55rpbsphslcmlpzmag5w47kmq4hxz0ll68d2"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.8"; sha256 = "015dadmlghkbvxz7d7m3fanrq2lqls094immxdv0laxl3smkg7pw"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.8"; sha256 = "0gnnpxv0pnbrsx4zf28agwrgra7y3zm0z4lsr09i0wvrz97n65p7"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.8"; sha256 = "136kjcl98n019764sy3pck9v4pmrz6q68qi8a2cdqm6hw7canc05"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.8"; sha256 = "0ibrah9jzcs7i27z9alllg1d46dx0px0m3mgvnsg34zhbpqfbilp"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.8"; sha256 = "0i4vmdgrvnr9fkmk2h88h1x37m4g4ksz7c24l585q6sg0343p0hp"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.8"; sha256 = "0rpb7py9j40jqhi9ndfpvspdkrbl4vwqq8r6hva7kfjva61x9ky2"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.8"; sha256 = "06jf5qv6ldsapbjd8g01pwm0yw20w7slpi9yrgxr8q2y0f9fqnhy"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.8"; sha256 = "1mj8gzvnk5f16vchwc94bp6726m6n8j6bi9d3rzbly8k63xdnnv3"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.8"; sha256 = "05491m5xzd6sbbpad6v7z1apkf00ip13sl23d9r2g5hv22i61qr9"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.8"; sha256 = "1wsafi273xsh9q9cbfq123p33k2kgvrqz7hvkj4hlshl0dzlky7z"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.8"; sha256 = "1661dn6v40g8yzwxdfskv0llvwf422zs5b5ndrhbs15cihh10axw"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.8"; sha256 = "17dicgyc24x4krjy37j36cln0770cl52ihyyrg40n8l1b6q3hcdx"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.8"; sha256 = "0pjhfxkzbgf0zxibrwrkzjhqz163qhczc476pzvd5fy9cxcdnkl5"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.8"; sha256 = "145zkswksir8q0n83jw1kv2xsg5x4sf6w80hyynfjmpfhv7klmcw"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.8"; sha256 = "1r473bl4g9xgn69q9jp1mfxrvllsg7a2z4lan7nv58anwsz1bfyl"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.8"; sha256 = "1kcx09jsklbnjl6mhdarg0c2j84553q6zj9bs73n70idczzn6iyp"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.8"; sha256 = "1g7vb2dba007aqw51k1ab962d63xh549zd3j9jsrnrmwpbk7yp58"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.8"; sha256 = "0p2rv3n9pkv27q20jmps4xl29dmraqc1wgcyw78wm5pgz1717wr4"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.8"; sha256 = "0153c9n7zx4cpxwa71yddgjpy021c98r7h2w6mxg4fqnb8hrk23b"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.8"; sha256 = "199qscm2is4xrbhnvyjp0lb4wwgw71c436vfxn7g6qmq7c4y1cyz"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.8"; sha256 = "1h5ndqz2djp21d3qj2rqcf41z7y6njb5gjflvhzgjgpqb2xmsqaz"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.8"; sha256 = "0d10q75a645gdfk2krcwyhj3ncivmgbdkr1j7p7varl38ml1631i"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.8"; sha256 = "1lb78gjg28r3s0wwjsz3hvannlhqafc5jf8aqlyfk6w92c7p9y3z"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.8"; sha256 = "05nay2zf8fp2y2ki232pkgwb29119fkhhg3z5dgbqn44dpsk7x1h"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.8"; sha256 = "14yn29p83il7jympnnl34srqcygvlzn797702vg1qfdjs18iy6j9"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.8"; sha256 = "1d8z4yk06qcqzfhs1424bwvvpy07m4dafilgxl3qlnynfb2i4jzi"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.8"; sha256 = "1np746181wn7mzf424qg4j68bs7nwr2iylq18hi1jcl2ysrdcfn3"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.8"; sha256 = "1b4qb36sgqbp5mpfni3iz2qs2kvvj341xn6w2rncvjajvgl73mpx"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.8"; sha256 = "19ha49v8wfn48v011jhrg9mlpalmb254rvkv409s4zj089612nfc"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.8"; sha256 = "1g6raxhpx7vlwl68xcw4r0xjra95zcbwifnj95w21wzv0nndna91"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.8"; sha256 = "1imhc4a3yb9q0cslp0mnsvrvjm152kmj8iiw58c9j8g8sypxcw5g"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.8"; sha256 = "1ynn1apan8czndb4n8pdvday2jw6jc19zx8nsla8rv6m7q3vc23r"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.8"; sha256 = "03xkg1yg2h4k2y774vc438ahs0mlrbgh0w7nxyzn15pvlp95yyc6"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.8"; sha256 = "0dgcnlsmjhqz8m2y8lpyd0s626pj48whb8fzsxv51l125acinsn7"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.8"; sha256 = "05xisaphkmpfx2w1irb7vhc0f2rfycxkicbyjhgmpqq9cbdxg09l"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.8"; sha256 = "1p5h36si87c461k854ky7hn5h5354mh9cprlkf6k814bhi4hjx7y"; })
    ];
  };
}
