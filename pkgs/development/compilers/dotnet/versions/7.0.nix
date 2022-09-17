{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v7.0 (preview)
{
  aspnetcore_7_0 = buildAspNetCore {
    inherit icu;
    version = "7.0.0-preview.7.22376.6";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0dcd6772-e520-4827-92e4-ad840230fe1b/fc025ae94601620a7133f8479e8458ec/aspnetcore-runtime-7.0.0-preview.7.22376.6-linux-x64.tar.gz";
        sha512  = "7d4861a28a42df31a7e2c740d17e1b0eb78e860a2ccdb25eec754a2098593a3adac00687294209d847a8fa618019a2d1b1d5fdd3f9aea37ffdc19164c862c558";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d6db9068-b8bf-4148-8c46-b5ee6b5a1a8e/eebc3347e69547e59145094b76efa1f5/aspnetcore-runtime-7.0.0-preview.7.22376.6-linux-arm64.tar.gz";
        sha512  = "af8d65460bded7a6b1591ecb47ed704cf577f73a83b09ceb5880ec1c90677b1d724e799022854623ac132534e0acd656443b32a49090354a9ef872f2bb0eb441";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8a2b2985-e061-44e4-9f9d-915179671a7a/1e4005f1d349063642beb40ee5ac8bf5/aspnetcore-runtime-7.0.0-preview.7.22376.6-osx-x64.tar.gz";
        sha512  = "52782e60b688a595a31b151b094978afb174df0e823f916b8a1e78b14566822ef22726481846c36dc95178ad5f39caa6832c9b8642b87dbc6998f3a20c18fcaa";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8041c215-8bb1-41f1-b550-ca5298ae49c0/4bf353f81b4b4e0d36146794e0121bde/aspnetcore-runtime-7.0.0-preview.7.22376.6-osx-arm64.tar.gz";
        sha512  = "893a55cd551bf3a490cd0069315cfdc9283fcfc851fab4964a3e6560ce2af6d9c08366f7a1d6a87e2199b29d03c81eed5daabe378d136afaaf467ef137f00c78";
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
    inherit icu;
    version = "7.0.0-preview.7.22375.6";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/57191b50-7af9-40d1-86a6-73dac33795fb/51ccaf67389abbd80249ddeebe7bc3cd/dotnet-runtime-7.0.0-preview.7.22375.6-linux-x64.tar.gz";
        sha512  = "9814a4e5a55b7137ec27b423ae4a557792af6cced035ab42876de012cb160adabbe054f043b61ed21a8385deb62075ab0a028f6599954ed3519ffe8cf824d30a";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c09945b9-bc4b-4f81-adf8-01daecbe65fb/7992ad0a8673a56f63261eb6f14e6b1c/dotnet-runtime-7.0.0-preview.7.22375.6-linux-arm64.tar.gz";
        sha512  = "c9277fb51a2624051b57a59c6f401619a6b0db2a8abce66f8a3a051397cc8222931104fdee480a26b5d65fa8150b0ced700c370ee437efb739edf30a2ad6e993";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7bd38473-15b6-4c6e-8bb0-891dbbbd3a45/37442e606ac06e70a2fa477a18995a62/dotnet-runtime-7.0.0-preview.7.22375.6-osx-x64.tar.gz";
        sha512  = "e6b02eaa8c3d578404d0f6c5e94447ab017397d2dfd71d5712c9089833e70da6294505ff3599929caa1a2c3e2c981d35e9f0343faa15a7dae2f330b09c1e3d20";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/be63ba3f-9707-448e-8b41-b2b19c7a61ae/b762ab7c0947ab72ea8438809cd95e6c/dotnet-runtime-7.0.0-preview.7.22375.6-osx-arm64.tar.gz";
        sha512  = "efbbf99de893507e49d5e2e752c1977b5e5bdeba3ddd5184f11e20bfc7ffaf64f0847647974cec78a07daedcba0b5cff78125c647ce133c4183d0821d55a2ade";
      };
    };
  };

  sdk_7_0 = buildNetSdk {
    inherit icu;
    version = "7.0.100-preview.7.22377.5";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/aabf15d3-f201-4a6c-9a7e-def050d054af/0a8eba2d8abcf1c28605744f3a48252f/dotnet-sdk-7.0.100-preview.7.22377.5-linux-x64.tar.gz";
        sha512  = "c16d452dbe4f097b75d304c8bc19892017847768bf2e8a0a72fafd6d6b46c3dd77e0c251b80c245197f47fdeafc2c18db255af8a1a5c30be982de19129874390";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/261a4c75-3058-4319-98b7-050c1c12f8e8/46d3da56919fb74ef4e1eccdfa24e4e8/dotnet-sdk-7.0.100-preview.7.22377.5-linux-arm64.tar.gz";
        sha512  = "de43c471794239a06a6bc70df79491e1ea8f717df84e74b91aa8383bc9edc3efd286216a2495d42c60cb18d47ec0442132d3ec2fbad695f62969e7e3f61e61ee";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7936e760-5156-45ec-aee6-ab8cdd988a32/5b3b9cc8a843a60fec8e3ac54b4f830e/dotnet-sdk-7.0.100-preview.7.22377.5-osx-x64.tar.gz";
        sha512  = "9f6fecb00df04f07a6275e202d2f005ab1b8ee471ee1587c7cb362b945658a2b2dcf572c4957a2ff7e95305558429320feabe3062d1d009e8244442ecb88fae4";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b3b49061-1894-4454-9976-5ee9f310e3e9/36ad0ad134881d00d4e10144ede8cc36/dotnet-sdk-7.0.100-preview.7.22377.5-osx-arm64.tar.gz";
        sha512  = "fd3ed7cf1f31b6090a19465932e39a3bccd952d3ec25756f2d9a4246fe7e93588050433a3711e9bfed1765f015e4fa14bdce9534a68f0a3f121eb4424f486f21";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "7.0.0-preview.7.22376.6"; sha256 = "0ci1cq4pxgz8pv4gcnmb87mgb1c5gq44s6hxalgwi4fsxk34403f"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "7.0.0-preview.7.22376.6"; sha256 = "191gi10dj5lsvnlammh7lya6c51y89sc0njmg2f4cj62vyiij91m"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "7.0.0-preview.7.22376.6"; sha256 = "06p40gdv77n2fz5bgyq69jamlji8b3mr535crf86b3yabgcg54gm"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "7.0.0-preview.7.22376.6"; sha256 = "0ls52qpz17s137iy3y5y46ij2a82ri01w9r19qrv3amacm73vn1z"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "7.0.0-preview.7.22376.6"; sha256 = "1qzrvwn0clk7lil8bkpr840pyfgh4hcvsl8sfhmh0mdn3xrzz7nk"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "7.0.0-preview.7.22376.6"; sha256 = "1f2c07h7bpjkcz47ay6rpybhpxk6icq9k3x7bfr40573hfqr0nja"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "7.0.0-preview.7.22376.6"; sha256 = "1spk1ch75ljbdkjqhad7fp5jp9gzg9iymby7hzzpsbs7zf57abd9"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "7.0.0-preview.7.22376.6"; sha256 = "1fai73xrz03yxpqcl3mqsgrs5hq8nbna9ggn9wc3isgr7i4v3498"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "7.0.0-preview.7.22376.6"; sha256 = "1snjfih9x8ai8h5hm60jf93aci27ymvgvbqdpsci885hgxw59lv4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "7.0.0-preview.7.22376.6"; sha256 = "13wdfb7pp9ji114c8cssgmcy3a8si8kd87nklwli6ml7ywnrh2kw"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "7.0.0-preview.7.22376.6"; sha256 = "1nmgfwpjdy3n7b0bn5z48nbk1xpvvgjphm5h04by1y7ii1ca17fg"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "7.0.0-preview.7.22376.6"; sha256 = "0zyb761an1i03zmk2d8z9ir86z9dqbdhzr7an31pyf2is9c7wczr"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "7.0.0-preview.7.22376.6"; sha256 = "159ipsa7s8wak3y2p40h6f394zg6jyr04p7jwh8vqv6dpn9wbjpi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "7.0.0-preview.7.22375.6"; sha256 = "1d02nv8x8pd4j1qmvy9ldn93yyxdzzl9jmgv6gl2aaqd8jvz9zcj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "7.0.0-preview.7.22375.6"; sha256 = "1z8p4z4ywmhaa5zz2cvpzrxzixpy7pppy08qzh0sjp6vl4sagnz2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "7.0.0-preview.7.22375.6"; sha256 = "0s2v26rknpk51bc36cfpcpnbillaiigka9lrg9p1xqflpkhk847b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "7.0.0-preview.7.22375.6"; sha256 = "0vbhavpp1mljfxl6xgcq4vhl8vyk3r5pdj24zaxqy3a0linxyk0x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "7.0.0-preview.7.22375.6"; sha256 = "1m5fp2qv66zn2rprf9ns8ff6ry81sgmh0rzj572vp5ly2lrxsa09"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "7.0.0-preview.7.22375.6"; sha256 = "0v3pnal3knb5g3ajz8icja84sgrh5rmbyksy9ydara10f43hga74"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "7.0.0-preview.7.22375.6"; sha256 = "0zmd5j5ajpl73rkpdnw7c5avp915imvwyfgazi6cxg4bycydxnis"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "7.0.0-preview.7.22375.6"; sha256 = "1l94sy69xikjmwwql3c2w5m44vylsrp4abhf2r82a4qz2daw4c8p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "7.0.0-preview.7.22375.6"; sha256 = "0qp0l475iwadn0d1mjlrblj4sqgdc2nbr7zf4plyaam1w0yfcafg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "7.0.0-preview.7.22375.6"; sha256 = "0nq91piw11f25zsm5ra8944h88rcvl97qyri5ypd9a2yl4v63c5d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "7.0.0-preview.7.22375.6"; sha256 = "1s0nqr9cydi4z0pafqyi5d5axapawy3l0wrx0xvgrpycsz1nzqfk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "7.0.0-preview.7.22375.6"; sha256 = "1w1pqicldr5hdj6c4xik786xn6nklzrcb9n14kl25bagaqbw30lc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "7.0.0-preview.7.22375.6"; sha256 = "1zl8f784yqfxpyyvlk966vpm3f7b91l6hanwfasg974rk1cs3v59"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "7.0.0-preview.7.22375.6"; sha256 = "0c0xqlzpx07s2kppilfkkw1vg856sabac34n0kynadbna7knb2qf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "7.0.0-preview.7.22375.6"; sha256 = "0c29mpc7rfyr5zjqr33cf1sn436c9hha9lrfcfiwia8jmybg2616"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "7.0.0-preview.7.22375.6"; sha256 = "03ndkii6pslv7h7j074b6da2nk3kz98g2k5kvx4h58px32lx966f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "7.0.0-preview.7.22375.6"; sha256 = "02pbiq38dhgvcn21m299v4hvbfz8vj5ns1qfcnr6hlcxxs1d7sjz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "7.0.0-preview.7.22375.6"; sha256 = "0jk73k9xsrm7wp27spl9xw5wfr3i9sn0xrzsy0a6bsksn0yp8lzh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "7.0.0-preview.7.22375.6"; sha256 = "0cc8yg8yv5r4dm8irlgp8kqp05cadm3hg94la1arka54sfaas51s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "7.0.0-preview.7.22375.6"; sha256 = "16cf9sf99izqdmdx7kii7gwmaiwdz75b4wcwc719v1nk6k4zmdax"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "7.0.0-preview.7.22375.6"; sha256 = "0gjyk0dhg63c9q4k5drarhwcdv8h92hysg5v5w0ib75nvjsyyx59"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "7.0.0-preview.7.22375.6"; sha256 = "1pkwk1yrc2pqjs4lwmzp4mmm46sc6ssbkhfr9z3z1l4w0vdzcxis"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "7.0.0-preview.7.22375.6"; sha256 = "08msq7ymypkki61an5ibiwxsya5cs0wziyl5kdprjzf3qx0lkjsr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "7.0.0-preview.7.22375.6"; sha256 = "197iwkl24d7gmj6l3qvblcbl2rynqdpv5c9ahr0kqd2lm9mkkmqx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "7.0.0-preview.7.22375.6"; sha256 = "0bslphbqnrlq5c56qmm7740qw1zjy90qb15vs1579qjxf09p33jc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "7.0.0-preview.7.22375.6"; sha256 = "0spqf4vmcdi9bnz6swx96mfmndc6qn18bbxwkr8hs6s8gxsvikaf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "7.0.0-preview.7.22375.6"; sha256 = "16n0yl888ip43167cxz3583cvdyzlw4a5c43xds6nakarkcda6wq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "7.0.0-preview.7.22375.6"; sha256 = "05y4js5k8mzkkl2glscl941xynx3h9nl5mkn4p7sj0jn93caxsqh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "7.0.0-preview.7.22375.6"; sha256 = "0prkrs8igc2v7rvn2gmq46np009z2cpvnwjyv023plc4l98ql7id"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "7.0.0-preview.7.22375.6"; sha256 = "10abdfmw8bzm4vz79sabsviwxa0a93payxf6r8jy0c2nv97wq1jy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "7.0.0-preview.7.22375.6"; sha256 = "1rj5bnqmwwigh2bais352kqxxiqx9m6zbcrgcirqpx98nj1z6y2l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "7.0.0-preview.7.22375.6"; sha256 = "03fbkp4a4py4s2bqxrrmvig5dxlc2iz41pwxl6ic1q8pgrfhs216"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "7.0.0-preview.7.22375.6"; sha256 = "00b16rhdwgqxdrs1z9p48wn8yjfnnzjv3kl06nl45z88ry3nfhgn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "7.0.0-preview.7.22375.6"; sha256 = "1kv7rfkjhhkjx575xd5ghjyi1xmmzgxxymih7vjny1s4zhbvrj0v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "08jr5ib1x91hfbwwz9k9885301p7mffw9d3ai7wqm7jgb6zf9zsm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "1knwjdjwvw0y7zdwk10vakbkgxzsmssw46v5lcyw8wwcpc8j7spn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-preview.7.22375.6"; sha256 = "0nw3fij8jmq3slcdj2xcb3dj6vqx85bwzidh6jd3xn5sz9jwsaak"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-preview.7.22375.6"; sha256 = "1wlvf7iqcsga3aqas0a9fscv0nrhjjkw0lwqjzvn1bm9cykyxmfl"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "0ccs9c8j7pr5038ifcppfr59zyfr64pgda937bj33lxh3xjrirbl"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "0s3sgla70q2fqdvnxqj3q11bbvj791jk79yyrsc3lvsvna5qqag4"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-preview.7.22375.6"; sha256 = "0j28x3vdwddb9mw74fawm0kjjmhnsac168ixxdzwkyi140w52dbs"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-preview.7.22375.6"; sha256 = "0yskfi9s2alfackyyz5gji566rlivml1vqipl29wkahavlfzv4g4"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "04as4f8y0d69i8j81s2wxskcidq0b9fmagfs042h8ihaxgrszk85"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "1s3zvyq8pgsyqs07s2i9clgn9ny9akqcwpw2crxjzg8d7dicxph0"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-preview.7.22375.6"; sha256 = "087ikb0q3ibvh6j5l72gvf8qcs5w0m6f0gwlylwshr2a5qxhbjmn"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-preview.7.22375.6"; sha256 = "0y41qxarl2zhr4hji9yz8kydfkzqh46p86yvnmxjqybx26axci3q"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "0anqqlrp3whwv2fka9nv6l24k7933fcanfjriyqhvjsg73vm5k2b"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "0d6larkd121rjd0qfvp3in3hiy4v6x63jarfca780zp6ylh5bxsm"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-preview.7.22375.6"; sha256 = "05k3r9zml71inya44pksp3p0m9aprihvndfx35wa2zidfqi0g0bw"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-preview.7.22375.6"; sha256 = "1khg92hngl98y0lcwqv13c13n5sfrbx5fx1sq7x2f18vxp76hb67"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "0lflk05jmsx0sw8m6sfl1q1dvxyx4xcxn33rq2bdd22zgd0ypqr1"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "0h3v9wn4fbaalrda8d39kjyh9r7glifcnbv0ii9b2philq7h2zib"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-preview.7.22375.6"; sha256 = "1l9z6h76kb6pas743adyw69zrckx5lrh9gqh0cmcrfxlyafqm9l9"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-preview.7.22375.6"; sha256 = "05s171k78f1j5lfd685nqvjazypxxaxawswpiz8f95g01wjga6r2"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "0w756yahm0xw4cpyp1zyqm8awba4b9i5c47bvc1jsjq0kyag5fi5"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "09ip5yiv1dwsmg4agcx89f5s75q3gy6klm0vbninv1qds0addlz0"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-preview.7.22375.6"; sha256 = "09mkr3w2gdyp5lzslhfc3f9nrz5l7hk9zwfc82dr1b8wd5ka4j05"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-preview.7.22375.6"; sha256 = "0pycdqs617nlha22ky27kq7p8b0jcsammqf6pcakgzj0h0lzk85w"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "0yh03hqpmw48nllhkqmva1c0qbhizarh55mh68mw2gx0xj8jwxkc"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "1p5wd5s526fpqc5vc1j7d4fmi58bazqmb21liayxl1rg18gpmrs0"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-preview.7.22375.6"; sha256 = "0rpxvnr9l24s1xm41shiwwpx03137p9isvv77rvfmv32426id8xd"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-preview.7.22375.6"; sha256 = "04h88hqmrkf0ypniam1kp0ci04yc3w35pxgfnyn2d5s5rn9hvvy9"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "14bbp79lbdy67i638aml3wrxp79pa1lywxnsifd0p5fx3spfl872"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "0ib2aq98zn15gr211p4232yhv00bdfnhpzzpy18cyjcdld7kr5rz"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-preview.7.22375.6"; sha256 = "0drm3sc16h08hqpxlj14bcc3y22505jnz85la83ciyzjlgd08iw7"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-preview.7.22375.6"; sha256 = "1gz1mkagz1qkxd5hyx9s32cwkgn80nyk7kvcsplm0w35v5058f93"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "072kfmlfq0miays6mzdpzy5021h54l67704h3mwyr0ik0y8i6v1a"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "19mhhsb89z0m3hai74n6pfkf0jgxnl7jsfc05pb1dsgiw9hh2lg1"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-preview.7.22375.6"; sha256 = "0aia62qm0ka0j15j7ly9jph41yjbyqyw87d825mq6icja5lybvp0"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-preview.7.22375.6"; sha256 = "08d7697p6vnmhaymiz3bm6yb4h1894b2d9xc28ckgra7gpfbx4ax"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "1g2rzj9fxwa5p0ym9sd5p7qrmjrba67fmbv72yc9cnbic6clb3rh"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "0nphm54hm803qs2sy183rp97qk0wxzmzm7lhw4msymnahkn4wm4n"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-preview.7.22375.6"; sha256 = "17x30zj75ijxj7j9zxsk9z4f9jmny3jv7rx6hrc413bgs2s0r4gv"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-preview.7.22375.6"; sha256 = "0fqp4a54czcmlz5rkl3a7431bgccgmqqbvqsryhszrk5z1s5q9jb"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "0l0pka55nvjy6jgby43kakdi1xkhkqcyk3amldwj4pw61vry9s0c"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "11h9769nrs07a4l9lwbic2qbl85121pj4c10cd3rgfr5p58q18hc"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-preview.7.22375.6"; sha256 = "1hgw4dvc5s4axr0c2xvmmj78lwr5ljyhxfcrn59bmcky8alpm774"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-preview.7.22375.6"; sha256 = "015f8k3xhxba9dpflv9985by4r9s5hr9hzmc7nc3yn3b4w4975l8"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "1jd0cmkhv4n48xwn7a3myyraixpmb1mnw2x0mrb438kbf6yrac02"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "0y7q3hzhk39p9r8js9p84y6v83mvnr2dqsbllfkzas912h4lwxh7"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-preview.7.22375.6"; sha256 = "09d1faksns1cv588aqqpc0wnkn0a0yclhh2padww7kcg8aqyx1qk"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-preview.7.22375.6"; sha256 = "1cca36xppd44krfs5wmk9grdk74qy3yrl62dykmxvzbh7qjd3wwq"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "1cmgscq2znig10cqw8zbfxfd3h6274pd45y048bq0zwnav833bk3"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "7.0.0-preview.7.22375.6"; sha256 = "0b4j1w5g1lzmdb08cxq07w3x3srqcx6f3gw1dmqpp7qr65iyay4c"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-preview.7.22375.6"; sha256 = "0pp3w2ix5x5pb8y86k6h6j89svkwbly8f924qbhyjfhb8m2fx21w"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-preview.7.22375.6"; sha256 = "02vr9ylyfcrdhm4ypjf4swg5g0d1b9bs3c37z19bnjrmgwrnsd2x"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.0-preview.7.22375.6"; sha256 = "0qqg76s2kdaj7bbriir4b0b6ham0rg1ws6b49n2v3llrg6mmml8m"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.0-preview.7.22375.6"; sha256 = "00padnxadhsmrrbdasnp1dmywr4xf4n18za7006acq5jn89qqppl"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.0-preview.7.22375.6"; sha256 = "0pb3kpzsixklap4d2dgr3x9m47cfgydxz4sk71j3zy3d6fgqc3l1"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.0-preview.7.22375.6"; sha256 = "1f5lml0bp65f2vpvmzdw714dq0wwbz29kfxcd6d7ypphb0rr1dpr"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.0-preview.7.22375.6"; sha256 = "0k4swyrsn9hjbbxn12hkl5d44wvr2ssvkl8zkigl180j8fjbgjb5"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.0-preview.7.22375.6"; sha256 = "0dd8wy9plw8fh3rgcmgkqgml5zfwrw4c8zda5q6cpswpqwswqm82"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.0-preview.7.22375.6"; sha256 = "18ijc7h5sji53ck3r2hyhn9x54mqbzq69lpnp4vbgn9i2vw98kdr"; })
    ];
  };
}
