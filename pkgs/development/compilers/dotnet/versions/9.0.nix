{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v9.0 (preview)

let
  packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "9.0.0-preview.5.24306.11"; sha256 = "12mq2k54nijycjmgb9c299bcad7iwgc5prff3cv4ilc8zf0db058"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "9.0.0-preview.5.24306.11"; sha256 = "0z0nby81zf1gzvwkm9hk6xxhbxgjxbcqbfw1k6f6dkhq4r52b19m"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-preview.5.24306.11"; sha256 = "0aa2i7kdq2czz8j4r3qf3qkq7kzi07ga19bm5kj35das4v66srn4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "9.0.0-preview.5.24306.11"; sha256 = "1inc6v7kk43yy68gwa0vg04j9jr71rbzdpi486xvv4zf29d3nnyc"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "9.0.0-preview.5.24306.11"; sha256 = "0a4bmfdl3paqb8sh3w5pbahsfifdvdx48m52vsi4qjpbaz37jqqm"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "9.0.0-preview.5.24306.11"; sha256 = "0man1h54lwqid1rpaxr7v811alm1cn6hdyamw5h9sy5k43d6q4jc"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "9.0.0-preview.5.24306.11"; sha256 = "1kn4ghd0rcik6zncqj7a8yx4hldc8ms5dz40zcyz8zpnjr0jalgy"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "9.0.0-preview.5.24306.11"; sha256 = "1vvm6fjnb4b07a6s78qrpc0h2xgzkc5n7xd0n8pl8vf221i36cjz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "9.0.0-preview.5.24306.11"; sha256 = "1ixzkjrrp63dzgx4bpdphcxmwb4bkvpghn2xblsq55lnqgsqrk1c"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "9.0.0-preview.5.24306.11"; sha256 = "12ly0aq7w3ysaz1lgafsj8b3xz60h1sx80112h016cm9x8qaj60s"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "9.0.0-preview.5.24306.11"; sha256 = "1jar76bi0apskqva4xvb21mpkm2spar8zg6dijsb1sfckhvprwg5"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "9.0.0-preview.5.24306.11"; sha256 = "16igqkvzbmiz18y2pxbxjdbn55505i38ci4dlxk2gc90q9ly9hmp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "9.0.0-preview.5.24306.7"; sha256 = "0yjhaflyvwla7bfc5r0f241lpdgs8f07idgw17c27py3jak4z7nc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "9.0.0-preview.5.24306.7"; sha256 = "0xqpixi7klisihnnx0nxadxskryh1fk7p998sib3yvp9r02jnqvn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "9.0.0-preview.5.24306.7"; sha256 = "0wjdwmqkphrz421mvqmv30nkpji6zkyv53n0n58s7cg1xhrysgn5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "9.0.0-preview.5.24306.7"; sha256 = "17xmgdysdsf9x1b5bbyk92fb0m49q2qxqsabdn0dj7apbnappflv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "9.0.0-preview.5.24306.7"; sha256 = "05l7iccmn56hfjfdzw6g2xyhwqn86pmfi0bhxs8zkvfmcxff01km"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "9.0.0-preview.5.24306.7"; sha256 = "0f8ifac136v8lrqg6p49c6v1fbzs7066d2x1gf70wxr5572s53zz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "9.0.0-preview.5.24306.7"; sha256 = "1i02qz80mk278wyj19m6s05xzzyz11q2yrbanark541b5nvp7f74"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "9.0.0-preview.5.24306.7"; sha256 = "02bk2wwlm262v6mz3k2dx1pj02sdmdmmic79bbkjksfpw1pbg4rm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "9.0.0-preview.5.24306.7"; sha256 = "03f18kc1kdm6aglcwc60757prmcb8csw5gvl594kgpgmsh819vdf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "9.0.0-preview.5.24306.7"; sha256 = "04yw10x9lkma4jkhaylwi8scxpifvhyq47mv316m49fas2r7xl96"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "9.0.0-preview.5.24306.7"; sha256 = "01jwa6idxn9jv5vp7am34gzf984jvd72cyns1w367p0v3c6yragl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-preview.5.24306.7"; sha256 = "19bgk42zkrb6q0nss1c4fxs5ii7pwjb85zrzsscgsvy3hjqqwzrk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "9.0.0-preview.5.24306.7"; sha256 = "10xdihmr8nd1jyqwrfsrym8285ngg5z2apbawy92s14bwjy51cj9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "9.0.0-preview.5.24306.7"; sha256 = "10bxll4zphrd2bvyp38z55rcl1fbdd64s53bv7hsjkcfsv26c4wc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "9.0.0-preview.5.24306.7"; sha256 = "0a530mpk29cl8iz1k6rwhgrspa5ssjkqnky5ivbx5hz9iq541bq4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "9.0.0-preview.5.24306.7"; sha256 = "1l2ak1kiq2515x16wdijk2rrjrzxc9jkbwd0ip7j3fqkm0wj62b2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "9.0.0-preview.5.24306.7"; sha256 = "065lhbwjmzf8gcqll5f2lbvgkiiqfjliypvgi4sab0r0m3gjchdb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "9.0.0-preview.5.24306.7"; sha256 = "02yli22m04wyr418na5mjs2ln6zawva8i8ixcij5bynqdfw2rakv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.5.24306.7"; sha256 = "1ix5nw7z8ymnxk1vj101namd4r18bqx6dkzv0zrqj4dx2zpadhd4"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.5.24306.7"; sha256 = "1janx1brnv64cfjvjmdk4zinqbkmmx525l04fmy7pi6c3hq93fr5"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.5.24306.7"; sha256 = "1m8cml0zk772i5a5yy909sb5089h7afphmcn95hm03i6f52kmmf3"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.5.24306.7"; sha256 = "0n04zf1xhdqm0nia3ja3kjz0aq2kasghqw6gamfpd68ln9yimi9q"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.5.24306.7"; sha256 = "0h29s18r4n09l8f2znpd2s9p12f8s2winnqqgn80nynsja5zb34q"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.5.24306.7"; sha256 = "05cf012c37q9vlq7fd2n76gps9dg20lk88dama26jlbpczj7gv81"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.5.24306.7"; sha256 = "0lgfnh0w31afi7ijsbjc305yxp7klxhz61pxcf27pxh7y9vcrvnn"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.5.24306.7"; sha256 = "1h12scdq455rb1ffy339a1fmjkgpp7hp4bjhr2fb7lp8kmsppwxl"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.5.24306.7"; sha256 = "1z1csk8z1yh4w697ghzk73vm4ry2a0d2sy4b5sk34r0bpxw5lbhh"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.5.24306.7"; sha256 = "13p6vi44agpzjq0qghjc4xydy1xy2985v4b0dl5v9j3pgrd1s8qk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "9.0.0-preview.5.24306.7"; sha256 = "0dakyl9dl1609jpwc5h6rkbl5s1s2fcfn3isf69z8m5n36vlz2xl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "9.0.0-preview.5.24306.7"; sha256 = "0nc6xh9xcqg64xf14f95mwxqki4ing5hpwwyd30d1j0ndbdf4xyc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "9.0.0-preview.5.24306.7"; sha256 = "1rjqx0mdf4jd5g613mxmjzjjyzl7gj6wnixhz8x6k21fwmsrn496"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "9.0.0-preview.5.24306.7"; sha256 = "059s063nfxn98cgym7zfn18icd2f7bky1n1b3pbz2d8bc2y6b6qd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "9.0.0-preview.5.24306.7"; sha256 = "1584xdik4q3bdgsnshmwxsy7sx9zjh112m1nvrc8sjm3vy4hpl5c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "9.0.0-preview.5.24306.7"; sha256 = "0l5n8k8zzw3wjgp0mf85jv470cmvp5cs4m7azf4x2x8p4q5j3pzf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "9.0.0-preview.5.24306.7"; sha256 = "0mryfw8svnmzxnvwkd2vs9f1mxdyami5dlcnibvjgylj0ggi8l53"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "9.0.0-preview.5.24306.7"; sha256 = "04zy5396cm98h5gf9rdar7mx6c96fx3lh3k6vm86bcs6y4pvmib8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "9.0.0-preview.5.24306.7"; sha256 = "00np825qdxnqq6vwazs66afdyvz668lyhsyl1hsflwg312h26kfx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "9.0.0-preview.5.24306.7"; sha256 = "1b8m4r2xzlsrja4w12np2wi71bwh38crvjy80md1gc5g67qkh0nc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "9.0.0-preview.5.24306.7"; sha256 = "1j5qpqy7fsg7m637i5p0mfaar6jrfcnwl8kz4virby6an3kgn2fs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "9.0.0-preview.5.24306.7"; sha256 = "1n9m33v04hbbvg7cac5s31sc6733amsafg8kv39b1v5bmfid6m7w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "9.0.0-preview.5.24306.7"; sha256 = "0lz2z4gx54zy8sffwbys1ls1qh03xjgzxzkmsngjdhpzbipyslng"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.5.24306.7"; sha256 = "0faq6h29s4l9lgjkhp82wygxjhjmqpigpc2rzhkw519vkc9a38jp"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.5.24306.7"; sha256 = "19al895aca67a681zm4ppznpdrf4mcs3qqkpwngmcv13jx9mydzf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "9.0.0-preview.5.24306.7"; sha256 = "1ds8w00nxq9i06xklh9klv47q79c0b9blzafkvbay9gclxib310k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "9.0.0-preview.5.24306.7"; sha256 = "19xabxhnb22g6pj8c7bx2zv9ys6qca561fmxq2ac8jl8bdwjzw20"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "9.0.0-preview.5.24306.7"; sha256 = "0g57liiiavqg3s1j4ra0ppd21ldfwihahqd69mai5h37yr7wggn2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "9.0.0-preview.5.24306.7"; sha256 = "15vv4bhdvki49y4zhqpvz1vr8d1iznrbbxk5hypq13k6aypsb3nr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "9.0.0-preview.5.24306.7"; sha256 = "0q5ircv3lrcrjdvkv50gknaix55l9z24rr8x8cb54zcq3fjfn2li"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "9.0.0-preview.5.24306.7"; sha256 = "0hxf3xk6yn8n04fwj9j7c6a70y9apf31aafn2nhd3yykvvf7618d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "9.0.0-preview.5.24306.7"; sha256 = "1pw27c0czrrgp0vqnlcz6zhyrhbjbqh14wbcknrcn1smlm6fl77x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "9.0.0-preview.5.24306.7"; sha256 = "14k0sd0b6rpngw8s1gz833kq89qghnhszgvk9v2rabncb1qlhanv"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.5.24306.7"; sha256 = "0c2spsh6m236cmpf6c2hafcrr4w2ks433g024cmpa93a3s6dfvcp"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.5.24306.7"; sha256 = "0wla1jr95b7hm6wa2yx080wgy8iaqr7r3q83jp3qdnp3k2y0rgpk"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.5.24306.7"; sha256 = "00mkrwlx48dis7fg73gxj1c99zs1na4k6y11q1908a674hni8qlx"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.5.24306.7"; sha256 = "02aqy5fjy8r8n1acvmixmlwif5jg6fhaygnk5ishlmw18yvhzp7m"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.5.24306.7"; sha256 = "1qbjvdmlg3hj1p9v8nzgcpp5cr7nakn14nksighqc8ck4nf9i68g"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.5.24306.7"; sha256 = "1s8m140xbwc2pmyhrrmgfd4r2lppld26m6x3k1kz9gfn7kk4ayjx"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.5.24306.7"; sha256 = "1f9hn43fs25fbzzhrawfjgz56mknsnmhmdgf1f1pqlpfzwb2bvvn"; })
      (fetchNuGet { pname = "Microsoft.NET.ILLink.Tasks"; version = "9.0.0-preview.5.24306.7"; sha256 = "0ck2agia8lmhvwvzh73yh2ydkqfz4g21404cv4qxjj28l618cjl5"; })
  ];
in rec {
  release_9_0 = "9.0.0-preview.5";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.0-preview.5.24306.11";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f43de71b-3bf6-49ae-99ec-66499bfa6990/438e1533bbb47d3d7e1f58983677a4f6/aspnetcore-runtime-9.0.0-preview.5.24306.11-linux-x64.tar.gz";
        sha512  = "b4358041bfc42bf614644e7f3c38a4fb73185a8d3541065bfd6758622860b0d0addff6a7ab6e7439d029b0b54238864279d19f1b5096b5d7c0fd10c0435e652e";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e8849fb4-309b-4008-b697-4b5af127cc8e/285762b4db9cfb18abad4e005b37f2cb/aspnetcore-runtime-9.0.0-preview.5.24306.11-linux-arm64.tar.gz";
        sha512  = "6e6198d26b16ebae7bf7f7a428b0026d3c7edb20fa0acf844670a98cdb78a8b0d37cad5df22f35dc3379de8069fdc95318f5eeebcd5b03ad99cf595699116abb";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f07ad200-6654-4341-a594-9a1eb1ca66f9/929c2533f6fe9c402fcb5fee99ee1103/aspnetcore-runtime-9.0.0-preview.5.24306.11-osx-x64.tar.gz";
        sha512  = "104b0b8f216bd36710ee912c92c89c4a5be97774eb21cf090c5c12acbe3ff8a8ec22a2b2bca56feda8aa21690c734d5a4b8293569cbf45172ead6b587d3858fd";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b4c5eec1-4026-4e58-adfd-64dbf4426b1e/1f05059da0484ade0ba1ce6a3e8f6bd5/aspnetcore-runtime-9.0.0-preview.5.24306.11-osx-arm64.tar.gz";
        sha512  = "f6ed6cc22e20e986cf54ddd0c8868b524efcf84ccbcd5335bdb4ac44fbb08641850448aed5d85bcfd2d403b3a89a73cb932d73db1b590cfc704a58aa8ec79d5f";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.0-preview.5.24306.7";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/acc83ac1-a75a-453d-beb1-ab0eef7544b6/fc1c9260c812441c5c51370aa57ea1f9/dotnet-runtime-9.0.0-preview.5.24306.7-linux-x64.tar.gz";
        sha512  = "6d5a313eb3213bca2ac209021218d978a7d8291041f4572780dfb48b5ccb7efe9ace509c75dad1db8e6a427c0bd5e4b2596c3e9f66eec5df4e717a66f8c3d7fa";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7ac3c308-bdeb-4fff-98b8-b22ff6c479aa/31e3d32e7732b17506d41cb6cd7a51b2/dotnet-runtime-9.0.0-preview.5.24306.7-linux-arm64.tar.gz";
        sha512  = "8e49eb2e279684c665031e04c915d63c19e617bf44194655374c957bb13d7f22c8c0e233196711c029653958f98788732e1bbf200d22fad27f76523d7506a91e";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4a7db5f1-a6b4-4232-ba81-f848a8f6dde7/20b9502eb9b73e2f7ae047ae53cd1f21/dotnet-runtime-9.0.0-preview.5.24306.7-osx-x64.tar.gz";
        sha512  = "617847ec35016e4c51359fb8585563a432b8a9ff2c6656d6c10f2e3db70c20dada36509a73b31622c91ccfd5246f51c1c0df79852035f65521ac3f78943f37ca";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/42df8bc2-3414-4253-99f0-50d52d4b0c36/a9b0b1664e2dcba0622b9dc6c6a8a8e8/dotnet-runtime-9.0.0-preview.5.24306.7-osx-arm64.tar.gz";
        sha512  = "7c61293b719016dc8212e5564a80a3686a6947d220e2243438616559995c2d415629bf583148513d0691325ebdac91b6a13cbf4d37d7328426b73989edd8ef7c";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.100-preview.5.24307.3";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/96e19e8f-579e-4a1d-a18e-6773a44d7cd1/092cfc588686cc698c449998b7d5ae35/dotnet-sdk-9.0.100-preview.5.24307.3-linux-x64.tar.gz";
        sha512  = "13b9934b3e7b736ab802a8c580aad95ed4dff6b8f31047c71ce9ffcf4d07e55105d4b0170d309551707b9d232d297cb305c67ed5b5f7026f47ec072ee1bbc121";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/25f41d0d-d27c-4dc5-8884-6c49897d89d1/c51387b8bde1d278a0982b03c3e8c1b1/dotnet-sdk-9.0.100-preview.5.24307.3-linux-arm64.tar.gz";
        sha512  = "3c6f7e6f2f56e86bc8a9633f50129cfa992c52c287dc89551b23cd62fa471199e90392eba7414659c8ff8eecf1dad04016615a98cf85f6c2045d61f6f14c9e73";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a6731f1c-ffd0-4cca-a309-89576e55552c/3000f43ca4b3b51bb034bd7daa514841/dotnet-sdk-9.0.100-preview.5.24307.3-osx-x64.tar.gz";
        sha512  = "ebb84f920a7bb663238a10007d784a7c90f66d073089371fc2c9d5556cba945918fd8b193e02eb3d889676952b79616398aa2555d7d46d080088f01f67ede43e";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/090175ff-fe42-4064-98fe-b6d90e08162d/bc72a57ada79f0ee7b71d74f5deb66a0/dotnet-sdk-9.0.100-preview.5.24307.3-osx-arm64.tar.gz";
        sha512  = "8c1a13d14f2502d3897871f82abd2c2df8cb41ff9d754e79693b99d0780deb910dad7486e05ec065c4a38490de00d251c64b0b2a734863e0a452f0ed23b1e1a0";
      };
    };
    inherit packages;
  };

  sdk_9_0 = sdk_9_0_1xx;
}
