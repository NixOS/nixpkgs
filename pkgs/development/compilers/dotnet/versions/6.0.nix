{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v6.0 (active)
{
  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.22";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a936856b-96f0-4525-8f74-b96b792c3664/2da9be398c92985d3f95c3336361d1ba/aspnetcore-runtime-6.0.22-linux-x64.tar.gz";
        sha512  = "a42f600823e19611ddb202bde1a8da8d0e9dadb22262cb2122f8c85af12bddee8793524d9e2096c188b267bdd852ef90bf93533c2d4f2f3151742cfc20fdc244";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/000ddf12-2c8b-4d97-9b3d-f76c8fef461e/c2dfb5a82b7952cb272c0f5dbeb7fcb1/aspnetcore-runtime-6.0.22-linux-arm64.tar.gz";
        sha512  = "bd3dc49cd2b637edc3797206a0b6b07b40f774a25c3c6932bc86d345cfb90f4af7c0927e1b39cf4fc638ce67a5291b0ab7a5bfb030c629f8e4e0d9ce76715532";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/447de6fd-79ad-4a1d-a7ea-48f57a8e1280/27c1a55772876bf109b7c2caa5038d9d/aspnetcore-runtime-6.0.22-osx-x64.tar.gz";
        sha512  = "c899865b0c3b409273fc9d4eec1e0d37406021acbc40d34aea8566fbd1cdce541bf0f1011a625ec0f61798ae334d244f72874943da790dc3d4b98611b140a954";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4f2055fb-f5f2-4953-8341-4c56ae1f2893/52d66998e9326c7172d77a706e752861/aspnetcore-runtime-6.0.22-osx-arm64.tar.gz";
        sha512  = "c39e137d351125fefc078882311eb7de37ec8188444767a15b56d6f242bf5855e0e79cfb205a45c5083e86f039b5e7202727a1f8eaab92706e5c705ba782aafb";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.22";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f812da49-53de-4f59-93d2-742a61229149/35ff2eb90bf2583d21ad25146c291fe4/dotnet-runtime-6.0.22-linux-x64.tar.gz";
        sha512  = "c24ed83cd8299963203b3c964169666ed55acaa55e547672714e1f67e6459d8d6998802906a194fc59abcfd1504556267a839c116858ad34c56a2a105dc18d3d";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1cd7db66-695f-48d8-9e79-d61df9774345/4c363363f91445c542e8a997e3568ac4/dotnet-runtime-6.0.22-linux-arm64.tar.gz";
        sha512  = "bef57f12a8f9ad3c41767b85158f76c996f38db56bd4b8d800d9ccd107be3e1d47a3d2917a252bdd937e3c30547e431dfbc295c7ffce8eb4ab072ade426c53f4";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b1dc97bc-8a17-4211-831f-8dd2c01399ce/9972b4153b37a16773b13ea0dcd12268/dotnet-runtime-6.0.22-osx-x64.tar.gz";
        sha512  = "cea7d3de081cdc6053861398700211561e2c7990be2e8d982b007f485321c5b6255622069d4c4adf2c0ddaefbd2438625617b10294d7c05dcd36d283bae40567";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/48cddb0a-2a08-4d83-b571-00772a73d05e/5489b285d12781a983a0f17f26973369/dotnet-runtime-6.0.22-osx-arm64.tar.gz";
        sha512  = "5038b29e5794271284d8316cbc454c8b1f1e54c30fd15305051008ff005a79ae22367bb2a50b03ffa4ce00228d1d82a3361d675a1a1a2c8ffaee3dffdd7c4eac";
      };
    };
  };

  sdk_6_0 = buildNetSdk {
    version = "6.0.414";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d97d1625-d7ed-444c-a7e9-e7b469842960/d8b97220d0d79119e3026da2b956854e/dotnet-sdk-6.0.414-linux-x64.tar.gz";
        sha512  = "79bb0576df990bb1bdb2008756587fbf6068562887b67787f639fa51cf1a73d06a7272a244ef34de627dee4bb82377f91f49de9994cbaeb849412df4e711db40";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a2afb4da-478b-4ffa-aeeb-a37a313d6fc8/0897a8456d42f306519de9a15b1e14ef/dotnet-sdk-6.0.414-linux-arm64.tar.gz";
        sha512  = "225367725fa2af00240654863c4dbe2370b95542d8c411a78017e37e13031a67049bcf570b94d9fdc9f61b1d13db7bf7ff9772bceccb70f43dd468302a47016c";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/25ec70da-5c05-4d55-9f1c-fe103417da1d/afcf8ecac02c9e8a927c128c9a72ec1f/dotnet-sdk-6.0.414-osx-x64.tar.gz";
        sha512  = "399c9fcef1ac858685f67d33079a49fd814d90926d47161680eda23820281acbd3b0a98fc7dffedeb9e2072f68880d74de3e4ff4d369046af157817dce61d5a1";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/72bd5609-d0bd-4fb5-a563-6f426038a7d9/01507b650934aab36c340284d0819ba3/dotnet-sdk-6.0.414-osx-arm64.tar.gz";
        sha512  = "02c65256834ed5cb947089ae4f0b2f5ad0bda44fd3abd06d9f5003e2090017a384a569ef08fa7f4abfdb368345c34242569cb81980c0463529469e522e742042";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.22"; sha256 = "0naka2szh9yxbqh99b4hswmxdspknckxm1dc7y56b8685gpwj202"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.22"; sha256 = "1xvqqc7bzj764g3scp0saqxlfiv866crgi8chz57vhjp9sgd61jw"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.22"; sha256 = "0nwnrchpajsllg2gxnxgyxgdbdamsnvpav1yv746bdjh0anb4yr0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.22"; sha256 = "0ss0avj940d47pykh7sqsks6g15ny0qwp67kcbzb9nc5h6gi4p18"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.22"; sha256 = "1gcv99y295fnhy12fyx8wqvbhbj6mz8p5bm66ppwdxb3zykjg2l8"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.22"; sha256 = "026r38a7by7wdfd3virjdaah3y2sjjmnabgf5l25vdnwpwc7c31d"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "6.0.22"; sha256 = "1bfff1342735kp4d9rhmwf8jflj40dvpy1gb3gvd7dri8vqhk3fg"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.22"; sha256 = "1d58anf2ws7gs52fyjj3i0fr62dva9va605vswl95d4w8av5bgnj"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.22"; sha256 = "0ygdqsd312kqpykwb0k2942n45q1w3yn1nia6m1ahf7b74926qb5"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.22"; sha256 = "075z4rn6nx5jqgxksdcr743mrbd6lw8hvsxkbmyg5ikqxfwqa1ny"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.22"; sha256 = "0fqpl1fr213b4fb3c6xw3fy6669yxqcp1bzcnayw80yrskw8lpxs"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.22"; sha256 = "04xvsm3kjh04d0cbw524f021kliylgi2ghcm7w0bm38p29022jh0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.22"; sha256 = "1ib0x1w33wqy7lgzjf14dvgx981xpjffjqd800d7wgxisgmakrmr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.22"; sha256 = "10dah19xqs4qkvirjj921hrkyrkv3a6gis562f4grqggmr6kb9a4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.22"; sha256 = "0gri1gqznm5c8fsb6spqb3j88a3b0br0iy50y66fh4hz9wc4fwzm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.22"; sha256 = "04b1p8whw3jqxdxck1z5m5zpa56jfqrzspa7ahaq9xqqfacsfnzx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.22"; sha256 = "170d8md31m3cfxwbanpv2amr5cmd1kkl9wl2w0jz9ggiwykc81nz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.22"; sha256 = "0k1i74wn6j7nq0bd8m6jrpl65wda6qc9pglppvz4ybk0n2ab1rbi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.22"; sha256 = "038bjwk201p2kzs3jflrkhlnszf7cwalafq0nvs2v8bp7jlnx5ib"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "6.0.22"; sha256 = "0pvab3a6h8cv1qjwkl90n44jh9z3aajgwq5dyq11hckxq5iga09n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.22"; sha256 = "0h1jr5lacsxqw4dx4fclxfbn711vvdkj7j7l2wq2iqhfkdj6r7d7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.22"; sha256 = "1bjy3zmrmaq97xp0f3nzs3ax330ji632avrfpg8xz4vc5p8s1xpc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.22"; sha256 = "1g190wngdz8758knb5ckgzip6hw6a72cjwiqgszmyh6hfisi553r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.22"; sha256 = "0px26kil779qjcram05smv4lq600l35r0klwh4qrwlrjq4pj2250"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.22"; sha256 = "01gbl9dgky4h7ijxryz3527l39v23lkcvk4fs4w91ra4pris2n8p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.22"; sha256 = "0qplswzqx17xa649mpr3cvlap926hlylvk1hh77cpqyrx5wz7855"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.22"; sha256 = "03nbcav8if0yjkxfkkk5sknc0zdl9nk3lhd847qa602dsigabaz9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.22"; sha256 = "09gfqdxbh36bjx20fw9k94b9qa9bwffhrq0ldwn834mx31bgrfs8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.22"; sha256 = "1sq1ygsrpv2sl85wrs8382wgkjic0zylaj1y8kcvhczcmkpk3wr5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "6.0.22"; sha256 = "0svzrwz3zi40xab1v1fd1rk2vcmxj1y6a4q6ap5hx0y7pck3xlcr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.22"; sha256 = "0596z83qqgrjvih2sqzjhm2i6ww8s3c4dhjfjl35d5a676j44n31"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.22"; sha256 = "1nn254xv1hi5c4rg38fbfkln3031vv545lv9f4df31i8c1yfzz24"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.22"; sha256 = "06hswqx0p4gdvb4r1ff77kwcmwsswhc0h79dffnmfdrll0a10yca"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.22"; sha256 = "0rii1mcsrbz6j0mcnbak51rm7afbxhilkvlfgxqvipgdg0xq0nyv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.22"; sha256 = "15k8187hcs54l1wjh5qd3w48sjcpad0z2dn2ng92kmay74jl1yjy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.22"; sha256 = "0nwcbkmxpjqafpbi7i1lrw3k235jn8a3g5aimnvppfi2plpys8f0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.22"; sha256 = "11cgpvhrq80r2fra1fqpcarp02nfn69v27av4svmglkv0gqc0fvw"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.22"; sha256 = "1x37zyxhv830480kdn96k1w6lh2yby31dpdh6w9yj475fh5na3dn"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.22"; sha256 = "0l7whkm7lidyq2qdbrrvwi3qjk19w2712g9ks1mr4zgqcc29cipx"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.22"; sha256 = "1sj3a6g1l7g1w4c7wrxnswqz1n7kk7f0m63zx2jmqhvx5igpnnvw"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.22"; sha256 = "1c25fmcb0x2alhnhlfclh5vk4b2rrd675vm21wh4jyjv56vls6js"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.22"; sha256 = "04k53x0vc7zwlzxc8n5qg12wxg2r7nppp19sp9q4qfampyr92r2z"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.22"; sha256 = "0pgjn0mkgwrwam03zwyi0f9vz7msnnblw2wxg67wwij1azmjnb20"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.22"; sha256 = "0p0xga68ms5m4a0f89jgja8r79ps03d3ka4m9ni9z7yzhq83fq6n"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.22"; sha256 = "17hr4fpl6a8nq3qphhg7m8z5ad0l5az4whh9dk28n0yis76dy5fn"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.22"; sha256 = "0qvqnz9b4cljffmms8yms9rijyfc18igbvg5l0qa4y50416r6i1i"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.22"; sha256 = "1m56r3admq89lwp4cxsinzcrr8hdl6rr87vj439p9xkpc8yw83a2"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.22"; sha256 = "0zwl7c2vjwwifqb9rfl5s3xfffhhlzffh12zjgd0lzhx7y6fn8iw"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.22"; sha256 = "14h04a5skmdlqd2yr00h3ybgw9mnvyv9zlpg7vij7qgdvq4zz8p9"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.22"; sha256 = "1gw9wmg6nqgahgk04g04rfg3v9d8rs4qfhiz6g4n4h6v8lxwirjw"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.22"; sha256 = "12wscn8jkpbgcj1kwwipyin0b61i99r0z6pwg5wrgrirvv0a9jnh"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.22"; sha256 = "1pl1g7s58ay6dryc1mk1haw3g2ywv1iakqv9wazk9cd8d5ls1mpp"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.22"; sha256 = "0inrily1l901723j2ak983i79vl8ppb01khrpwvfnibcycj8l2d5"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.22"; sha256 = "0vawg1744bxbjxcb5jaqkxcz59bgpg5c231qckjiza2ycrw5nfhk"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.22"; sha256 = "1xywy4lipml6ifi7w8aghnrbp8br421iqjfni8pr25d9fri83rk9"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.22"; sha256 = "0smyxwpihifgbyx8kpqbynp9az0m86k1s1ikdbinahglhj9bxca6"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.22"; sha256 = "1ixmmhyq37s8v76fsj35ffpgvab5lzh9wf4z3x0kkp9v561knh05"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.22"; sha256 = "172wq4gdf64ri5qs9s33wyca5rg2mm9vbfzljf6dszy47847n5yd"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.22"; sha256 = "0iginfaq7smfipidp8vr2jjw0i4xq8fq8km1ki3z6gkxp8p2w3i8"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.22"; sha256 = "1mb10yml3spgamwllqsxx0n7gimj8nac0lc7cz5yq56fipp4i14g"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.22"; sha256 = "1bj7rkqiiy1wrfyiq47h671n5igphzd7xrpda7myzh0xcsvqhxab"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.22"; sha256 = "10yxzymgg8cxhymqhrcr9vqg102fyvh5dc2zrdaqxsf64hv469g6"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.22"; sha256 = "0yv8jv3gbsji81pn72jx6is60gy4v4f657kbp4kk7f1q78vx1046"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.22"; sha256 = "1jsnywr0vd4lkwi6gr6s06pv2bl8dsjhj4q6vxk276i6bfxss5jd"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.22"; sha256 = "02g350h6537fnv9zsw6i4anbaq5f4mrfsqlrsindxbfmqapnbm5w"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.22"; sha256 = "0ipl5zjcmlzm0ia00hkqgzc20f6k7bsk68rr1yc3rzzmp6gcjgml"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.22"; sha256 = "19dqa1s2gz2rfbqsqsnzxxybbkd2y412ck19y06vzbjwc3r5v358"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.22"; sha256 = "1mn6zmgc0n7lbc6vxvnyxf5znvdzsqhvkyfhpfga67npj2i8w7fc"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.22"; sha256 = "0razqiq1hhzrf46m71vx8n8gvraavndig5119g8wh7rlxhrrdwk0"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.22"; sha256 = "14v8vrfx3ncclki3nfhg83p01d7abwqsfmgqyjwka2slhjrapgpn"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.22"; sha256 = "1pqdmbcs3scxa1xqw4sa7y9dky9nd5z4vzzx5frjxx3255f8zcm9"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.22"; sha256 = "0yabmsv8lnrvsylxvs96vswwky4slp3h9c0gn7x0agpwh7wzhwg5"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.22"; sha256 = "18zhyrldffv5scvwvc6v9p0dg606d204m1rdijr2sx1g4sg3gplg"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.22"; sha256 = "032zmbhry64pzk9vlmgk8pc1bwz0jcx8dnbz1w34wp8wwx8f0cdz"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.22"; sha256 = "0gcfaki5mf40x3yw97dci8dwlsyhjvjy0ysbid1g80ag9mkjqh4b"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.22"; sha256 = "08057y5d4sjk77f24lnsiv8dbn2axgz8mp5sfzvmaqzzig3w3j3v"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.22"; sha256 = "1zx164azcsrss62m8dk8g8nkl9kq8z7n1mn756jskdrdmdslqxjz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.22"; sha256 = "0i9gw5d7gqjbir7ip9904zj6n3sr81xv8lf290xbr163l2f181iq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.22"; sha256 = "1si0dmcjdwdm4z6x412hvyq35jps0rv1y483s83wkv22b0j7l3in"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.22"; sha256 = "0166gwarhhnary19lf80ff33bkx00mkm24f17bc8j6v7g3a7zvq6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.22"; sha256 = "0g2sc6359k3z3f6h2pqg8np2cbk57gpzbyqyn5ixlv34gv3pfhfc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.22"; sha256 = "1x7wclv93q8wp7rip5nwnsxbqcami92yilvzbp0yn42ddkw177ds"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.22"; sha256 = "0km8184kma8kgz7iyl3j6apj1n7vskzdhzmq3myy3y36ysqrb4wf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.22"; sha256 = "0nhd7q0piy6frfv7fx00lf7hdd0l6mpj3bb5w2c1ijfqlcny88ww"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.22"; sha256 = "0vhpqbywilqkyyvlra6sq94vc5p76da962g550lmw18yfkzk5i1q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.22"; sha256 = "05yyssk0vin5s7r5cs43il19ki424ikpcifw1nrglw5ar700pw50"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.22"; sha256 = "09if60d7175yaraf1ljg47lcxg3wpnm3yd33a68g60zd3qi80har"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.22"; sha256 = "10bq9y4vmw09a5apyzqa8zgn8r1i0wysrqaj0rw7bjjl3iz4vifv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.22"; sha256 = "1l56sx3rjmdq8i5cwdzd90vkbx5nyzbbc7rzckmbw7lbi92ys8lc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.22"; sha256 = "0gqv5n9kb8avfn9hqn50ybm12hxxrz35gvvfrppdwdqain13ypca"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.22"; sha256 = "04kkaxkqxw67cn58h46li5kxv0axkdh9f2mr22n4llysbfamzcd1"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.22"; sha256 = "10rlwyacci7l8j028n486a1icbsx4lvfq92k88a4h75ys5iy9r63"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.22"; sha256 = "1n313j4lrdsr7yw8r0kxcd1137w4kqmsypjjadcdcq3wm1c8207p"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.22"; sha256 = "126sn9p98shb8pbf4wd5vf94fl2jbmvshdkdmq4knyn8n6bg3kvf"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.22"; sha256 = "1wav33bqfz7237cr55x3l27f06ybdrm9zl2dnapjp79ipp73vqj7"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.22"; sha256 = "07p1gccdwhq7rsvlniwvy8ja4dbxisv4822yawffkwwmpnh94byj"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.22"; sha256 = "09q14pyk13ki8wc29wy87adq393g35aanfsp4bdag8gb68qlq847"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.22"; sha256 = "0hvjnnviv8rc3hgw9ypzvx9b19riyb0kyq34g9sg2y3bamhahd86"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.22"; sha256 = "1zjdfjp161n48s8x4jx1f957j49x4g10f61p2b721cc616wfpvik"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "6.0.22"; sha256 = "1qcv9286f4c035naqfjmscqn11hid1ak5qw4lv51i0qijd6bkqad"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "6.0.22"; sha256 = "141zgcsw9v8pyf0cgg6g433ba1xg87343gpcy9mpnj2jpczhh0cr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "6.0.22"; sha256 = "0cm4bv0izfyh6ynr9zdjy2gn6c6vsqfrc9b0pjmadgf07mw9sns8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "6.0.22"; sha256 = "1jci3jmzxjqi0h2fwmxqh8vss3cnfw0nv6bw7s13a4jzx1127cxi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "6.0.22"; sha256 = "1yx5y4s9ihdgk7pmc2il516w790d6rkklsqlxj5w4yy9vmj16mk6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "6.0.22"; sha256 = "19jrak7w0dbyn2jrvxqzjizafglw1w6v84qfqywbbqkhplr6km3a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "6.0.22"; sha256 = "0pdzn9s2qdw8ngk2ygnj6xil544h801xhxi0lz0d80dws2w8440f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "6.0.22"; sha256 = "1savfrhbcalhdfkc3z6008d7rx0hzr4ry3nvcw7kchx6mxf2pkxf"; })
    ];
  };
}
