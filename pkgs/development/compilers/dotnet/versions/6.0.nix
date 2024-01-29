{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v6.0 (active)
{
  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.26";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b63daa46-51f4-480e-ad03-ef2c5a6a2885/ae059763456991305109bf98b3a67640/aspnetcore-runtime-6.0.26-linux-x64.tar.gz";
        sha512  = "51a0091ffa5abb2a6f2f968f76848e475310fbb33126238bc1358ee86e24bfd3f046d32af2f39dc7a30b14becdd637d1314ca4f4b771fe5fa0954474a605e4fd";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/cfc40e77-a6de-481f-812d-6867289e2d8b/eeedeebccc412fd01110d8b59050754d/aspnetcore-runtime-6.0.26-linux-arm64.tar.gz";
        sha512  = "48330ea4d98fc565c9553ea119f56e3e485ca30a0986f43e78335e263d9cc82d17b7ced8115480d1adb33298cbc5cb2b0759bc89d516659c4c59eab9520a2254";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/19e27b0b-cd99-4b84-bc7a-05eda52bd77f/a85cbbb13b629b75b2026bb8c6238e6e/aspnetcore-runtime-6.0.26-osx-x64.tar.gz";
        sha512  = "9ffb209f2f07392935b9627e22b44260803cc5e21ab8d09152d5499ebae51d6f488992664bc44a23334332a1183c444b47cada319cf4d461dd95a6b78f1cd825";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e5181497-c33a-4341-a5a6-57eb21f39d33/85b574ef2b884f084b604d1869d72c02/aspnetcore-runtime-6.0.26-osx-arm64.tar.gz";
        sha512  = "641cb5542c5d4b0103a2ac0154e2a99d755a4987fcdad854cda1fc75bdde08432eab73db69c444628e7d68496ed6e36fa52eda5033e118ed4b5140b8d5c47d96";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.26";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1873e7f3-aa12-4189-8d6d-db0fb859211e/b36e8f8a6ceb63bc3cfac875c7bb63d0/dotnet-runtime-6.0.26-linux-x64.tar.gz";
        sha512  = "7336f71f7f99ffc3a44c7d730c6a1e08c5c0b6e05d2076a1963776f174f8588d31c9b783d1c4f645f7e7cc6a54077b798c6bde35ed4a812ffd9b2427d29b0b34";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/226d8ab0-8daf-47b1-80cb-a9b68badb28b/a4425bebee91775ce41a50aca80e09c1/dotnet-runtime-6.0.26-linux-arm64.tar.gz";
        sha512  = "775d96bb3dfa6f5e7f81829e7eedf0744aeb75d5e1a613622debd1f285f9eda694ae79effe531558dd8367dc4fad5d682039aa24fb2bbb39fb561c67aeeb4a18";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/51703c07-2cf0-415f-abbd-5d4bf2ffd56a/fc952db2ecb119fa2d58828d1046f974/dotnet-runtime-6.0.26-osx-x64.tar.gz";
        sha512  = "e2d51f955c841299fe6dabe1abce15ab2ffb2b9c624f5c2ad12685a14451fa62ed9452ae7d7d579f1beca784e4d4e3b532cf686e58490d44bbd0e022ddabd667";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d76c6416-5a6d-42c0-99b0-a4bb0021426b/84ef0457a893dbf0d565a532fa9dd805/dotnet-runtime-6.0.26-osx-arm64.tar.gz";
        sha512  = "fba964511efd71b87aad92ac8a31d7a86cde605fc0eb9d57ea270067b22cd540a67451d8ff3a079fcec8fffcdcfcbd74cfcc89123c2b11096dca78cbfc891be3";
      };
    };
  };

  sdk_6_0 = buildNetSdk {
    version = "6.0.418";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/01292c7c-a1ec-4957-90fc-3f6a2a1e5edc/025e84c4d9bd4aeb003d4f07b42e9159/dotnet-sdk-6.0.418-linux-x64.tar.gz";
        sha512  = "24d705157ae51ed5ec5ff267c76474d2ff71b0e56693f700de456321f15212a7791291b95770522a976434f5220e5c03b042f41755a0b6e9854abf73cd51e299";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/487a62cc-de86-4648-bcf4-18a02b0f4ccc/669d92e679215646badef80782d32bff/dotnet-sdk-6.0.418-linux-arm64.tar.gz";
        sha512  = "2848db109c65dc284320f680c13b498789f944f3474788548c0bf15d333020cf9b8286348bacda9af56e1dea6b56590ff24669de7ed5eaa31906f4710cabc6e1";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0cce8cdf-fcdf-453e-9346-96abbe76ba6e/79047571e41085ddbef25c25540b40a8/dotnet-sdk-6.0.418-osx-x64.tar.gz";
        sha512  = "62eb6c792e90750510395a4e5796bd72b0b6806633b220ead6f54505edbabcc9216c52a4346247b20fe2c6b5b31de23432afd2687a0a6aa38727c4cad2c96e93";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/20977215-ff63-458a-ba19-43e93456b76e/bd58619144624cc66ac451d9c3bd5f5a/dotnet-sdk-6.0.418-osx-arm64.tar.gz";
        sha512  = "4328aa334e5ddc2dc53c2602e5cd7718e7bc7750a3a44993ee1e6b052251d570882592f24a89821bd261c42d235e3f0213f060d36c7365bd6d2d5eca60231524";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.26"; sha256 = "1dghq8zl0ad9wspixf6pg1ryqx5g5b2d6vavz00arkr29hbb6pr1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.26"; sha256 = "1za8lc52m4z54d68wd64c2nhzy05g3gx171k5cdlx73fbymiys9z"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.26"; sha256 = "0yni79dvg87lx4ysy9l61hz120w43g8g2bl0l5d3l3c835vk4fsk"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.26"; sha256 = "1sb4jy90xwjpysham5a09960zll1p9q696dajcz3hayfd3d72nc6"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.26"; sha256 = "1zpbmz6z8758gwywzg0bac8kx9x39sxxc9j4a4r2jl74l9ssw4vm"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.26"; sha256 = "02src68hd3213sd1a2ms1my7i92knfmdxclvv90il9cky2zsq8kw"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.26"; sha256 = "1b2p4a0vngdq77kqdv3fprqg0r9nzsn1idnxkqclvpbkal8ackhc"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.26"; sha256 = "1gxlmfdkfzmhw9pac5jiv674nn6i1zymcp2hj81irjwhhjk01mf5"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.26"; sha256 = "1kmx5kmsb0xqhjpig9zmwp1zcyxlx7q42npcywfjvj8rhn3k8f6z"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "6.0.26"; sha256 = "0amqvl3jimfr3hpsm43pc30rfijsi5j08q07whyv136s3wj2fp9m"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.26"; sha256 = "1d8nkz24vsm0iy2xm8y5ak2q1w1p99dxyz0y26acs6sfk2na0vm6"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.26"; sha256 = "0gb5b57pq3kfgk5kzwzf6124l0rfa197945ynpr3h8jcamab2bc9"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.26"; sha256 = "1i8ydlwjzk7j0mzvn0rpljxfp1h50zwaqalnyvfxai1fwgigzgw5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.26"; sha256 = "00zknjp1bscjfprzjipjmwvq4i0i95mxvd5r61c077pfwkr2rrap"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.26"; sha256 = "19y6c6v20bgf7x7rrh4rx9y7s5fy8vp5m4j9b6gi1wp4rpb5mza4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.26"; sha256 = "0jlxi1y51rpsppz02gybqcsja746ns7mjfrg7f6y8x5xqvp4p84i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.26"; sha256 = "0sgcg406w9a9s0ipvp1csrb80ddmakifzy8ngsqkxl2phvkxrak3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.26"; sha256 = "0p7hhidaa3mnyiwnsijwy8578v843x8hh99255s69qwwyld6falv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.26"; sha256 = "1chac9b4424ihrrnlzvc7qz6j4ymfjyv4kzyazzzw19yhymdkh2s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.26"; sha256 = "1k78541brbw29n6nblls4msj604jznj4s74973c899svv2qw5ayf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.26"; sha256 = "0i7g9fsqjnbh9rc6807m57r2idg5pkcw6xjfwhnxkcpgqm96258v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.26"; sha256 = "0p7ar2xl9p8qzxvkrx59vry09dyjgy6hky1a8x8alvi5aay725r7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.26"; sha256 = "0w797ab42nncr17f5imgwi47bw8im851v4l52jlkpfcr7sak6f7q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.26"; sha256 = "164hfrwqz5dxcbb441lridk4mzcqmarb0b7ckgvqhsvpawyjw88v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.26"; sha256 = "02nymbmv9wvbx1jsxp1iz3009finzabg9p3ibrsqmrg9cxfs1y5c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.26"; sha256 = "0l30qp4gwcazh8rmw4i4j0k996jnlpkr5nzf0r14zm4j0h1zq6i3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.26"; sha256 = "0islayddpnflviqpbq4djc4f3v9nhsa2y76k5x6il3csq5vdw2hq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.26"; sha256 = "00f9l9dkdz0zv5csaw8fkm6s8ckrj5n9k3ygz12daa22l3bcn6ii"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.26"; sha256 = "0cls6ac8795iwmiqnbwfsg28gw9ac1smdp2fnvqfcjng7fnpq3ny"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.26"; sha256 = "0i2p356phfc5y6qnr3vyrzjfi1mrbwfb6g85k4q37bbyxjfp7zl9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.26"; sha256 = "0qqlnm9p060ff0fs3gl9lkx908zmpbsdnj2inf7h3gxxncf8d7ba"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.26"; sha256 = "19dlfl7z5lxh9kdi6h9a00npmhcbn6j8hpf7lmmx8lqzxx43v92n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.26"; sha256 = "1nzdrswailhr8q2lqcnx5x73fnlacrh91q2zhwsiwkzhnj2g10ad"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.26"; sha256 = "1x9sizw7m2ibff4x0iwwfhwacqmm07h7calp65xyzjbsbd3pvwwl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.26"; sha256 = "1inp20x12nmxydrklcflm2gjq9hhg4w2ak37ssdqs4lp0ljrclyl"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.26"; sha256 = "07w9n5wxj3rb2i50dlq4wx5fpkchlg1zm3mwkq49aw1xspplhmb3"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.26"; sha256 = "0bp1951qsb67a9qkfl144ijbpf7wrayj2zfnsyrlnacyfjr15nh0"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.26"; sha256 = "0pcn8gsw9cyhbry1wlxqh6khmkvji7w01z8mv9m6pxl1f58nnk5g"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.26"; sha256 = "17znyv8ql0iigk3ipnf79jzqfhjb1gr7zmci7plr5gdsm4xwqvhj"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.26"; sha256 = "1mbabip288dypj2vqifs3gc5pxn77m58dsawmhaf1rp046fv66zw"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.26"; sha256 = "1x93q16gfl7j4445vyjp9md4ypfrp1q2562kcxfga7zgfw8jrig2"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.26"; sha256 = "1j2a8svxyphsfry7dj9w2a0dnbpxsm8jp4h0752zs8vwr7566dbd"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.26"; sha256 = "1ia3aysigp73c5iyrk901wygaw5ivlca6pgpq8cv8haf5a0hb8p4"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.26"; sha256 = "0akginmvpjm6pd3854j9p5hcb7iq1qgsmy02w7ih3fsrpc6k1xvj"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.26"; sha256 = "1r7zwd9livxs9gf1a3xnx2rjf0azgp8xxha46axigfip62zqib8z"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.26"; sha256 = "093rjmlk3q74q5bzzxrs5587ymfhikzhfhymii7b86nvnbzm62fp"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.26"; sha256 = "1wjkz1icqlv0f2nkr9mpdiqp8aiqbbgbpb4j1zdms0rqwf3y3ngd"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.26"; sha256 = "0ay8i7vbf0dbfwh3riggm8y0dwn1wxkw98c6isdk2yp30pc6y1gf"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.26"; sha256 = "049gk7f50n1mni8a31dmrih6pxn0dl9iyfb7malhj4x2va54676m"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.26"; sha256 = "0q0xzszp5jxqcdr5n8p0glq79zrlcqkj05zmd31admqxl9hlv4qd"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.26"; sha256 = "0qkivqmgli8id2c6da9nckggs4dl0sg3rafhmgs7g9s1izlwjkgz"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.26"; sha256 = "1ladvxwyh7yp32k27lzw2zyl0wsn74lylpxb0bvcq8fspsq8kqbp"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.26"; sha256 = "0yb06wsqjljnrni0y0dfrfxk8r80w9zzicdj18dx5l85n0apk2zp"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.26"; sha256 = "18l9bpiv03xsawkvy0kzwcmqrfil0m42n5zb2c4na3hdalw6k230"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.26"; sha256 = "17nr1hpb5lkv8f72y0jljn9sb6zgi80z63s0r6pci77dknbqw0m7"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.26"; sha256 = "1vak4v0q9p99yrm24ld3jw3hpy2myk1sr7fm47cb84q4hh6ppdad"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.26"; sha256 = "1693h15h9na4n2bgmrcrcr0rsqfc8dr7s4wwirnn2fki1gk33vxj"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.26"; sha256 = "0s2694rz7ykzg1x1yn8y3vdj6nipmh1h136p8584m4hqyyszg7h5"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.26"; sha256 = "06i6pavanzbl9maclzsvkq482knjsz2s0sk5b36a8wr08lvy83ih"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.26"; sha256 = "0qm079rbljawwj8lm83kd8dfn3rhasn981gyfkrapk92y2ndjjj5"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.26"; sha256 = "1a886rw2xb053cybh9vfjwyg4a0w9d3141dsd08jxqrmbbsirb1d"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.26"; sha256 = "0i9k3fcl54rnqk3gxi6dm17cmxwygclgjhjvqrjc6cshwsxm8g6c"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.26"; sha256 = "06kdqs9x2mwsiv74n5dpilmvy00qzjaxljcsvqdlgmdi2z1jpshl"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.26"; sha256 = "10543k5zyg60icanbn1y7dnxlpf4mcg1nlfx78lf9i9x61q542cw"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.26"; sha256 = "0cfn3r2781rjmmjmk8xxrd8jn88941lkmb8j2g52jp1425w0q0qg"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.26"; sha256 = "0yilpqh378zpy3likp9nkp84jrcnxnhg8gygr8qs3c6xfapy9c65"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.26"; sha256 = "1vxvlf6dwjjfcjahljcv7yfyxlcj1vnf66wbzp7k6bk27lndwc4j"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.26"; sha256 = "1d9q0xcbj50fpbls0hvkk6n7aabg42a3kwszwnknfdabwzgmiyqh"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.26"; sha256 = "077lvw62nbs1xhn4xysml1vyzbqpq3h5x3x28cppjamcnaf00k56"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.26"; sha256 = "1fsz9x2qjavmvl3g7phxqj5cxm0z212dw5cz82f9njyi9m4q5bh9"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.26"; sha256 = "1bxs8cnqny1rdh3q0glr1f2a669697rlr2zmcimhy84y1y46x3s3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.26"; sha256 = "02mdbziad0k3b6za8bp2n7qcqjigyawxkxzphlbqag5gcn7qacsz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.26"; sha256 = "1mq11xsv9g1vsasp6k80y7xlvwi9hrpk5dgm773fvy8538s01gfv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.26"; sha256 = "1731r332y4jxm7f64i1qg4dwb8fbq4q6p85azrrbvbrh08551rgq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.26"; sha256 = "1acn5zw1pxzmcg3c0pbf9hal36fbdh9mvbsiwra7simrk7hzqpdc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.26"; sha256 = "12gb52dhg5h9hgnyqh1zgj2w46paxv2pfh33pphl9ajhrdr7hlsb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.26"; sha256 = "1fj70xx2hp4nly340pcvnxxaari7mixqwmwqrp3fkjnzv0s523f7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.26"; sha256 = "05hzps86qkx0jl8zn89732vw9a2wdxsszhzp6ld665hsjfs7xwr7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.26"; sha256 = "0s9b3ca10wapa0xhqk6yk2hh1rqi38l766fk62yp4d4rvj2sa0qq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.26"; sha256 = "1f8axm5dz0bgm6hsdv2li2iw4y70ki9ac0xvk7q3cqmvrq0100c6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.26"; sha256 = "04iivbqh899d0ddnnicxzckiiv12iy8cfavmkv9w9zh8bw01isy1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.26"; sha256 = "1sxj6sv0p3cbn030j9ivgww5pk4ffrh4wg3n1g50rxd3dvfml87v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.26"; sha256 = "09iynj920zr5c4jlrpim9qajyabxapmkzllvhhx47d88bngqqddx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.26"; sha256 = "1nnbr5v0asl7lrz484572wzhsrzdd0lq31dnxx05c3c1lplxzpgh"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.26"; sha256 = "1vqx13dbw932jx24h7qh49bmh755f28xlwiz6lpzvgz06fr1qb5x"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.26"; sha256 = "0qmbs7509p83l3gfdnckw5hpxkr50awvh3112r469f3zmn2s0wvb"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.26"; sha256 = "0yyxmbdqdzxw3fd36ngpy9j2c7qlmzjxrhqi4lyfz3icnzzb9cpi"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.26"; sha256 = "1p3xq75bhv8nsrym88yij3wlwawvxca4lcfi8hn72qf1gqrsrfby"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.26"; sha256 = "1aznr59g2npja74qa7argkqlyca2sgzn55hy41pd5l5fv275bac3"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.26"; sha256 = "0xbkd0g7qd9jssbnknwqpmvbp4mnkj85bhh0pf489j5nr3cmbhjc"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.26"; sha256 = "1riw5l45wm4f51rfsxhs4r7k06q487zvxssfwc5xg8z0wzhf82gv"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.26"; sha256 = "0207y7jgizr16hq7ml04s2xl8rrp5q87631wcj6sg53bm47nzls3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "6.0.26"; sha256 = "1cs3hij0lidd6wszbwp2kx46mqx5zyvin97sqy8dr1ywl1fb0zw4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "6.0.26"; sha256 = "1brvsvbi55ph9gbx6i4vf2bpvaqk820vjik5x2zvz5kjc5wy9nxj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "6.0.26"; sha256 = "12m6619yqjs81xna3mw7xxwnddxxhffcihxqa5dhz04dca9grmvi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "6.0.26"; sha256 = "0hv0zv2qw78z285bzckcznr2kqmfpl7ghxv1cb1d90lvhfyhhpz0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "6.0.26"; sha256 = "0prdggyp2cqdkxkm4rrk3rgvrj73s89rgkfznqsbd79j9sms5zmr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "6.0.26"; sha256 = "1vwji98xhrmxcqr43f1ijq8bd94dq9cfp3h7g09rc5h327n92i6z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "6.0.26"; sha256 = "0g81sv3jnmwmggsfqniv89fvwk4592bmy09m9fqggv88rfzfcl36"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "6.0.26"; sha256 = "05lhb550f385lprzxdnsama7rac7bfml5p40r7rx3mqg3bs8waxv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "6.0.26"; sha256 = "19s0q3j5w31dnd9j4vnlxyak8cr8bgpwqy0i393ixa9148nfmk23"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "6.0.26"; sha256 = "12whmsh15mb6ny0vazymsxpdp9aa6rjja4nifamm2ss8gzvcbqik"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.26"; sha256 = "0jw2zm5a590mai2wggbhz2h62596076c6p4ndb8z84mkjrm9aal2"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.26"; sha256 = "0wwwp4bsqdkkikwzfchb3d61i9dlpi80y7nlm8l6lyfxpjirszsp"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.26"; sha256 = "1cgmlkg5fnxf5al68m3218zdj5i186ijfly0w2c81fq2yyci6fb7"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.26"; sha256 = "1sqqf6i98y1i7k0dfw51glvin8apf4nknqcjhq3sf1pxsa6c77m5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.26"; sha256 = "0qzca5yxxzjgzkvvp8ysvgbwmda5mw085zrk1ikm2094mswz4mvl"; })
    ];
  };
}
