{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v6.0 (active)
{
  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.25";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0cf64d28-dec3-4553-b38d-8f526e6f64b0/0bf8e79d48da8cb4913bc1c969653e9a/aspnetcore-runtime-6.0.25-linux-x64.tar.gz";
        sha512  = "ea1e9ce3f90dbde4241d78422a4ce0f8865f44f870f205be26b99878c13d56903919f052dec6559c4791e9943d3081bc8a9fd2cf2ee6a0283f613b1bdecf69e1";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8f085f4e-ce83-494f-add1-7e6d4e04f90e/398b661de84bda4d74b5c04fa709eadb/aspnetcore-runtime-6.0.25-linux-arm64.tar.gz";
        sha512  = "fdd2e717963f213abbab6dcd367664ebedc2f2ec9c2433fca27c4d2eb7704a73d3f4ec5b354b24d5be77f3683605a56f5675d1d543c5f76d042a1353deab8d73";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/eb5d3ec0-10d3-4ed4-986a-9b350f200d7c/e59374e45f5f1be3c111f53c7e2ebb32/aspnetcore-runtime-6.0.25-osx-x64.tar.gz";
        sha512  = "d58721d8f0a7cf6538446b37ff6399c285e4fbbbc30ac0b550cada361ce2cbc981039e8c90e3d038de1886e91be5457acd5c88bd72008a208c62dd533080864d";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/fab54ac5-5712-4c94-b9a7-68e18533b8ee/8197e36c3a2522e233e4d66c3a7b098b/aspnetcore-runtime-6.0.25-osx-arm64.tar.gz";
        sha512  = "ab9ccefa4d0249aa1ec313e02aa7dfec9b048f3db42881c808050efe3956749fdcadfbb937cfec19ac37fed70c81894dcf428a34b27c52e0cd2911fd98d29e9a";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.25";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0e8de3f9-7fda-46b7-9337-a3709c8e385d/bc29c53eb79fda25abb0fb9be60c6a22/dotnet-runtime-6.0.25-linux-x64.tar.gz";
        sha512  = "9d4cd137353b6340162ca2c381342957e22d6cb419af9198a09f2354ba647ce0ddd007c58e464a47b48ac778ffc2b77569d8ca7921d0819aa92a5ac69d99de27";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c5ebe66a-1815-4cdf-a099-af89dbf370b8/8162d0068512e14f69325d18ce10acb3/dotnet-runtime-6.0.25-linux-arm64.tar.gz";
        sha512  = "d7d5d9460cca02976b01b233e3bfca32f7739910dcbdab34ad035e7e0314204b84289a1ab11f82c36dcd517657749ec1fc4d4ead2c9ee0ab2ffabfc886f0e87a";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bb33d6bf-748c-47b0-8077-962fef12afc8/8a0fbc979b8bded0b4538d08e8f92916/dotnet-runtime-6.0.25-osx-x64.tar.gz";
        sha512  = "b9241a03aaa8ea56d54e3f1b13baabad9e3d6b2b16633f0c6c01d3513ec6ec7aadc455dc1bb7b096c7df75efcf54ef467e1fb8ad9f3777ad3b5236bfb0db0133";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5bb1393b-ffe1-4961-8d42-7272611a0399/6cb74b96d854a95fe4d42c62d359427c/dotnet-runtime-6.0.25-osx-arm64.tar.gz";
        sha512  = "b12e4e08d6f305e88bb7af385e5380b8bffbe190c4a17929d1bec18c37feb21298512dd24aa5b0f19b7cc775e9f54fa088ed0b22bdb05200f95ae6ca04e7d63e";
      };
    };
  };

  sdk_6_0 = buildNetSdk {
    version = "6.0.417";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1cac4d08-3025-4c00-972d-5c7ea446d1d7/a83bc5cbedf8b90495802ccfedaeb2e6/dotnet-sdk-6.0.417-linux-x64.tar.gz";
        sha512  = "997caff60dbad7259db7e3dd89886fc86b733fa6c1bd3864c8199f704eb24ee59395e327c43bb7c0ed74e57ec412bd616ea26f02f8f8668d04423d6f8e0a8a33";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/03972b46-ddcd-4529-b8e0-df5c1264cd98/285a1f545020e3ddc47d15cf95ca7a33/dotnet-sdk-6.0.417-linux-arm64.tar.gz";
        sha512  = "39cada75d9b92797de304987437498d853e1a525b38fa72d0d2949932a092fcf6036b055678686db42682b5b79cdc5ec5995cb01aa186762e081eb1ed38d2364";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c271e475-c02a-4c95-a3d2-d276ede0ba74/8eee5d06d92ed4ae73083aa55b1270a8/dotnet-sdk-6.0.417-osx-x64.tar.gz";
        sha512  = "f252050409f87851f744aa1779a58ebe340d45174aeb13d888068ffae053c5bcd261a89bcc8efc2d9c61751720bb4ca61cf19ac5346e8d23e7960a74d76cf00c";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f82f1323-a530-4dcd-9488-c73443f35198/e59be6f142903e5d562143b1ae8f2155/dotnet-sdk-6.0.417-osx-arm64.tar.gz";
        sha512  = "87aaee2a4047510f2267bbdafd226703066700131e25da95141e77b2725b7d1ec549384c763e0936c7f3162199144072c1b3fedb4cb58bd6864565e98ae1b955";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.25"; sha256 = "0f78x80hdfyjn3hpz5p6whd9f3yimsrqsscx1iqp3iqxp5vbn8hv"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.25"; sha256 = "0mgcs4si7mwd0f555s1vg17pf4nqfaijd1pci359l1pgrmv70rrg"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.25"; sha256 = "0csy841358fyjcls2l9jmnar35wcb1661df7jll9v3i073vg0mg0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.25"; sha256 = "0jf667r72ygnxjmnqjkvqj7vbd8cxj0kikwdjcbpl2sk3jfs2cs5"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.25"; sha256 = "0wvzhqhlmlbnpa18qp8m3wcrlcgj3ckvp3iv2n7g8vb60c3238aq"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.25"; sha256 = "1zlf0w7i6r02719dv3nw4jy14sa0rs53i89an5alz5qmywdy3f1d"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.25"; sha256 = "10gi5dmmjdvvw541azzs92qjcmjyh8srmf8mnjizggj6iic7syr6"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.25"; sha256 = "1fbsnm4056cpd4avgpi5sq05m1yd9k4x229ckxpr4q7yc94sncwy"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.25"; sha256 = "1q45jgx66yv3msir1i5qv4igclpgwsak9jyxbmb60hpjrv7agpx5"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "6.0.25"; sha256 = "0v4ysm020aqbrj7wdagk1gyvmmh2hp24w66fj65bpvwf7d47baa0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.25"; sha256 = "1vrmqn5j6ibwkqasbf7x7n4w5jdclnz3giymiwvym2wa0y5zc59q"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.25"; sha256 = "1iqw18240dnawkdk9awx2hqbz8hvcb6snrksdyw4xhmbkqpllhax"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.25"; sha256 = "1pywgvb8ck1d5aadmijd5s3z6yclchd9pa6dsahijmm55ibplx36"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.25"; sha256 = "152knml839c2cip3maa3rxib69idj2f3088q4njv8rvwk54mz0n7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.25"; sha256 = "052388yjivzkfllkss0nljbzmjx787jqdjsbb6ls855sp6wh9xfd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.25"; sha256 = "01kaff79cp6961pwalx038sj8cywq5kxsx41hy2876lkb5h48qdk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.25"; sha256 = "1knfyq15m4ym19daxi2mlmj8a8xxfaz2609k2gk9024bwkxqpzhj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.25"; sha256 = "103xy6kncjwbbchfnpqvsjpjy92x3dralcg9pw939jp0dwggwarz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.25"; sha256 = "132pgjhv42mqzx4007sd59bkds0fwsv5xaz07y2yffbn3lzr228k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.25"; sha256 = "18b1v6apzk5pgbdwd9gqlyq292i4yil8j9xs5abzrq6qj44zry66"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.25"; sha256 = "039433rm4w37h9qri11v3lrpddpz7zcly9kq8vmk6w1ixzlqwf01"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.25"; sha256 = "1phgqcb2m6l5k1vdwmyaqc3aqhwz0jlfkhl705jailqsj3cxzhmc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.25"; sha256 = "0wfb173m8nn5k8w5ws5a6qmk16jmmg1kk0yabkswmsnz7nsw8wrr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.25"; sha256 = "0jpcmva1l8z36r4phz055l7fz9s6z8pv8pqc4ia69mhhgvr0ks7y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.25"; sha256 = "11ikq7mkwg98v22ln8hgzxz3df2d6jsgv0my1b7ql2rinp1yv8av"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.25"; sha256 = "13vzgfgpx6v11wby4jz62g8knf7s7if341v932jf715m7ynz942n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.25"; sha256 = "012jml0bqxbspahf1j4bvvd91pz85hsbcyhq00gxczcazhxpkhz4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.25"; sha256 = "08vr7c5bg5x3w35l54z1azif7ysfc2yiyz50ip1dl0mpqywvlswr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.25"; sha256 = "15md9mmr75gh4gf9x325z69r05yxap5m2kjmljrdgbp444l1fakq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.25"; sha256 = "03snpmx204xvc9668riisvvdjjgdqhwj7yjp85w5lh8j8ygrqkif"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.25"; sha256 = "1fmjx6nk81np60ixyybmqk0l69l72k42acqzqvyhj92x6s769zxh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.25"; sha256 = "06i076ipih4css0aywdmrilj5jz96r93jph050gab1qg5hm7c1p2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.25"; sha256 = "0yp2amvw0hk5m2df1c2hr9k6j5jxzlk6qckaqcc7bl42vd8cp7h2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.25"; sha256 = "16pzhm6b5kx1z91jg74cbg511c0sk7xdi5y0n6xk5ag6g2x4kr2g"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.25"; sha256 = "1l6l029pzr9w7y5y47cqhiiahhfjz2fg4i8v7xj4qynxxvab00kf"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.25"; sha256 = "1vdl6dfszvvfcar0ynjjk03xzwr5m8yd0xlwqvkykm8z08mws6bl"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.25"; sha256 = "1dxfwb055h0727nf955hw07gdxfz7vd0g3h5ipml1xr6w9bqgksw"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.25"; sha256 = "0b4psb4igc4rp4p9qvr88br5amfrzi849cfc7dpvmhc8xchrplwl"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.25"; sha256 = "0x20irmvpar9bgh9hchxf8cv0hz3ps69gbfrm50qqj7lr30m7gsp"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.25"; sha256 = "1xcmhgic9fc5ic3vsslsf3mkq8lq9srg8zfivmh3qss2093y4g0z"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.25"; sha256 = "1zki2sds5hlhajd4grv98mkhk0dsls3862rgqn1n9p39qxvrk8kr"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.25"; sha256 = "17r83ra8359jvx4f6bnj09ah6xdp5hzva5096kb98vpsr6m3d01l"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.25"; sha256 = "0xxcmmg1f9mqa9fhdw23yficfsh4bbmncwf9jd89wi6qy76r0m9m"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.25"; sha256 = "12dc3y0islfq167v0h2w8vnndqhad089cl1kcbfnsx7rfjwwbaab"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.25"; sha256 = "0vyhdxyi0dqkpiq9r5pyrr3ylzxrghkbv7j5frrccx7gd67ja0q7"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.25"; sha256 = "0fwimdy4d7000a04wjvp3wjaa27rqpn1lw7s1bcqab2c7wx1vaxj"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.25"; sha256 = "05l2rw7p9m3ydn8ir1qr42k9kl814vl6xv51x9v4x9y5n87kkyyc"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.25"; sha256 = "0kphnrg2h4kbyp53i3nc3d3bgnqh3qq5m7dr536zzss5k238kr29"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.25"; sha256 = "13z3k838s0yini9f0ng2c662k5vg016ypniqvmjq5vfcrwfldhw5"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.25"; sha256 = "14vyv9rcl516g9rbl6gvbk5s4x6jrmpcc55x615cw9zivz7kg5m4"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.25"; sha256 = "0lk3a68das04bzmf811yy1xk9l0iaa57fnxlfg56vkypcdbzd3v8"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.25"; sha256 = "098j9zsk35hdp38alkmr7wr9kw3bxhphp043gqm7s2hmf7l49ay9"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.25"; sha256 = "1p00bnfr08ynrd7mr0crx5362g266fz8w0z5hlkbnsywrfpw421m"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.25"; sha256 = "08g5isw9h4aqvsmz20rsy1y978kyvx505whlisq3zdzn855fdii4"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.25"; sha256 = "0gdj5h1993rm772qza9ha77ngvsk7qf6zvagbvp4w1pdibmy1mg8"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.25"; sha256 = "115qdrsgbzqcy7phnrdb9n8xrfbnip7xyag6f4xwnlydd565m3kx"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.25"; sha256 = "0ajd388qhpp578b3cxznnrkswfp3760dv4w47rva8zdh9lhk95cd"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.25"; sha256 = "0fvvf304q71ak117xd5v40iz89v20igxfcanmnxlarks20xs157n"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.25"; sha256 = "16b6cj4zhc8ba9fxgy9ymgdplm371bmi4z1f9gml34zipx6n70c8"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.25"; sha256 = "0ajfjz3qdf0fqrmpxs4sjsn78f99bakj1skkrybk6xz3sd9md8l9"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.25"; sha256 = "1vlrz79kg0v4hlwv09ic7x98g7v17figj81flfwb8aj18rdf64vi"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.25"; sha256 = "0hxxk3n905rjn4dsikhcnnf69gaz741xal9bcgibs8y9y0rpkvqp"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.25"; sha256 = "11khq0551rrliin1i1y5gwa8g2m5rkcx5hl2j77dj4dh259pbj5m"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.25"; sha256 = "1pa4z6xa8zzgfnlp92k00gdhjlaw9zgnjgmxb7x6bkkqp3vng35y"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.25"; sha256 = "170pzxl68w192v1zaijndca2vkrkr2ni1kiw2lkvayvpdbq7kixp"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.25"; sha256 = "0k00k73ij98disxxpklrac6acagnq98sxkbrharxxy2d8r2l9nk0"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.25"; sha256 = "1k8axhlr1f36i3sqgnip6wj5p20yn9z95z5d4awg6lxbjljqqjmh"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.25"; sha256 = "1pqdvbqaz9kswzzka97c793323pjq9z4pacsy527zxkm856a97kf"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.25"; sha256 = "1z4zlmhn9q043gj87ppicm06m48yhcbwbkiyqa627w58k50f074g"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.25"; sha256 = "1jsv4mcvskn07k5qx019az454cn5g06ljwpfwbq5jqvxd3p6qdq8"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.25"; sha256 = "0pqg54lqkjji7h0581vfhqhwy4hs66zzhb5ja31d1x12zhf91ac7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.25"; sha256 = "05f8i1gifd9xp1yd9pzica8yjb7wva8zg4hniw4rpz2i0v48b04r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.25"; sha256 = "13m14pdx5xfxky07xgxf6hjd7g9l4k6k40wvp9znhvn27pa0wdxv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.25"; sha256 = "0a03wf0mhnlg48is9vscqcxw836j5kh6gqjdyjs7bvafkw0701df"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.25"; sha256 = "0wgwxpyy1n550sw7npjg69zpxknwn0ay30m2qybvqb5mj857qzxi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.25"; sha256 = "0jfhmfxpx1h4f3axgf60gc8d4cnlvbb853400kag6nk0875hr0x1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.25"; sha256 = "01xcm1ddmnkpig7wdg85zam1fkp4pc9n8glvvav7rbmsws3137k4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.25"; sha256 = "13p714fr06abigjziy8amswsj9v0105x9sb0s9x2fjbqn3pqdb7c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.25"; sha256 = "1q5yr5ald0mnfrg3m0zxg11myzagricdkfl7m0k8wn6iz99h6znn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.25"; sha256 = "02s1r4i773cfvc81nmvjm44im7a1f7cpsay10ar5vnfyzwd8vinl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.25"; sha256 = "0rvzyl9innv47bfkvw2f6rpwlvrp43cz2xrc0p26rnfzgcyks6pi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.25"; sha256 = "0q015fg3v27xh1a3k5d1m8avysybzi1ldi93vhrywhcg5dqfqbw9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.25"; sha256 = "0i9hdsp3l485j6xsjk2px19780y0l7c0h3lrhvrq6hw4q1hc1h3a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.25"; sha256 = "0rr0bmcn4k953l1snrm7gpdp1y4z06hfvrv4fnjasf3nqr37pbg8"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.25"; sha256 = "0s9hqlpgjswsn91s439jw56rb23cd9s7v3im3vsf3axg7j90h59h"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.25"; sha256 = "01ryk8vzxqz3bz5ymqlxyvrqrxqqspxkl8zkz8c09y9an21720ym"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.25"; sha256 = "0zgm21r6hxqvn3lw5jw3js0mnr14a58zka16zgmbs322qgmym0wn"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.25"; sha256 = "054py8cxnnf9r3yxiznr9d8g318aba7g8qkwy0iw5sqy4a2djlwx"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.25"; sha256 = "1nsrxm99lc1bx0zd557l63yw0s1kcsb69006x7s6qwf65a9zxx5f"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.25"; sha256 = "10v1xr9cgxmvnb10j45b27rmixz0a8z1abqxz4vbwvxpw95llxyp"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.25"; sha256 = "0sklpq84zrd5gsndz2zxabc8l46whcdiiq9dcay49pmq5sq2czyn"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.25"; sha256 = "0m1s5h1qdiy65fp6zqmcilv1a6g67ca2avx6kvafhj486clc8ylx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "6.0.25"; sha256 = "0yqvmc5mmnw5cc6l32yldakkad59qhp54f3fi9danrw1qalrs901"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "6.0.25"; sha256 = "1x8ly0l07b9zad10wvjvrs3i5055796zb90nki8763zszsdh54wd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "6.0.25"; sha256 = "1rghaz6ldhyvql4hg98r3cw31idqpx547lzpsl73m0dl687nwvs6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "6.0.25"; sha256 = "0x57xc4n0aa7wdb5p9kqcnn1g26mdviscn4n2fb00iqyrmzfphgp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "6.0.25"; sha256 = "0a4jg0a06jb1r23xc4g2s3nkivf99fdzmmhpc712lzfz0h5vyp2l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "6.0.25"; sha256 = "0i27sr2six177w7c3nx577i4k9n326s00ynrkh9kcdlzk4rsw4cl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "6.0.25"; sha256 = "0ikfa3mnvpyglq5bj35af55h6dn60gka0b9ljb9yhq90vbpl4wfl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "6.0.25"; sha256 = "0qb9x9pq0zpb8jay3ygn7an0qrjjkr6jzif77gc800dsnigaz91a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "6.0.25"; sha256 = "1p5kdh4kd8ab4f1l3wl3hz7l6k8d2ccm3cjj27hsfgabmkbrziv4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "6.0.25"; sha256 = "0lm940s85m8m7c33hx6gvvsnh08djayj14y9v0kj99pkan9s88di"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.25"; sha256 = "1ckyfkpg2wfibmrc4yvx1m744s8fsbhaivfblgcxd5312vhckhcq"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.25"; sha256 = "1qkgl3mqm6vvxhhwdyl4dngwwjavc5gzhiq339z0967nyz084pwx"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.25"; sha256 = "0kvympxg7xapx44d679rw2w7dq3rz1h0dn6nir5fvscrjs78fd8i"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.25"; sha256 = "0ikrrasb8r5xv89zda0n9qf0ykdwlmwq254iy4fg310krnv5fqql"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.25"; sha256 = "0nf4zhabwck0gwz5axv5dnxbg05w2726bkkqngrbn1pxjn8x2psf"; })
    ];
  };
}
