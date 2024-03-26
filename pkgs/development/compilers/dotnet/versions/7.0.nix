{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v7.0 (maintenance)
{
  aspnetcore_7_0 = buildAspNetCore {
    version = "7.0.16";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/cd076f88-c72a-411d-8d7c-a5ed352dce9c/fd020c0de8e056bb5c4a7ef6d1d983d4/aspnetcore-runtime-7.0.16-linux-x64.tar.gz";
        sha512  = "1482c7c946c1b1a0a39f2bef4eaceed0a9b9eae44d3e8a103e6574b64391749d163ad4d65198573571885906215078ff41f53ebfc7884aa8a437c527532521f4";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ce5326f4-7aa5-4463-b7aa-5be3a85387a7/940a239d2a0401a1c5745905f22d750b/aspnetcore-runtime-7.0.16-linux-arm64.tar.gz";
        sha512  = "9acc4c8e99d9ff50f3f5e5615e25e30561a8475ca66332bcb93d3305aa68f1bfb142d21c3eb7cd07627c15d2e3abcfd4d504db617e7c662b83e2b76e4019b3d4";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7b668555-cb1a-4ec9-a095-a2f04c20a0c5/477ca3d9b92b53f4a2cf6fe3ad6859fc/aspnetcore-runtime-7.0.16-osx-x64.tar.gz";
        sha512  = "f28ef3bf07682d6a85bf70c69159f66583fdab5de0b8f693de2b7477b55376ebf797e504f9d0026bfb24bf6f884d843363d3f42921c89b164d084c05288ec2df";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d549c9a5-79cc-40fb-a71d-e3a5e80dddf0/9f3abc8afdc5a110776f0b727e13d1cb/aspnetcore-runtime-7.0.16-osx-arm64.tar.gz";
        sha512  = "ae2e61279788227908ca2308cc22db56c3bc9497f8544a009c33c669469d22909882c91758f28ea45ea0670211417300a448b431ea6b6079c55cdf55651af816";
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
    version = "7.0.16";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a1b18f18-1bd5-4c11-a9ed-b38ff8e5276d/c357409f720369b1eb5b6f183521ac95/dotnet-runtime-7.0.16-linux-x64.tar.gz";
        sha512  = "e1eae1aae9088e8131317e217f4cd3059628cce847103775c61c2d641d19486168bede5fe3123668f81f35bdc5a41100cbb49126d55445e7f5c5c617e2ca3b49";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/2d4227ba-2a3c-4313-a22e-216898a2ba28/6de108672de382cacb507d12874abacd/dotnet-runtime-7.0.16-linux-arm64.tar.gz";
        sha512  = "4a38d656e22129605a5f156b61098f6eb598a88e1d6248577d064481e7f4632fecf9bb60580c266347b4ee60133a617a5528aa6fc789faee83e5cca5fba884c2";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1f9ceba6-cf74-43d1-b595-79f77648c9cb/00af259fec984c4a51b2f34bbf86402f/dotnet-runtime-7.0.16-osx-x64.tar.gz";
        sha512  = "0261d0f93dcb56a0dd7e506be16405c533964254924bbc8412465c6d12c45f07ca7cb61b1025f6d222fb881cdd7f19224a58699e19e21ebcd7f6df92e832a829";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ddbf1eea-34b3-4b30-98c4-73ecc0493e43/8d15c0d6dada8fe863549d4ccbf04e82/dotnet-runtime-7.0.16-osx-arm64.tar.gz";
        sha512  = "69e42aca2fcaf4f5f8787aed3e1db00c6c8a3b5ad83ce8425842222db6453d13cc623778d80fd39219ba6e553c8fe0326b3bfa3802de5ef19247cf1f07ee4a56";
      };
    };
  };

  sdk_7_0 = buildNetSdk {
    version = "7.0.406";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/57150757-56af-450b-ba30-8532fac51e0f/507247327723f24970f66f51554c18bc/dotnet-sdk-7.0.406-linux-x64.tar.gz";
        sha512  = "5455ac21b1d8a37da326b99128a7d10983673259f4ccf89b7cdc6f67bb5f6d4f123caadb9532d523b2d9025315e3de684a63a09712e2dc6de1702f5ad1e9c410";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/67aad17a-4584-40ff-8ac3-0093c63105a4/472183e47222f475198a4b4a394036f8/dotnet-sdk-7.0.406-linux-arm64.tar.gz";
        sha512  = "7543ab3197653864aa72c2f711e0661a881d7c74ef861fb1e952b15b7f8efd909866e99ea0e43430768db223b79d4e0285f3114087b6e009b5d382b4adad13fc";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3a380401-9a77-40a2-a5bd-16c537f7e0a8/ad443240d2182d363d3b5ef7e22d2e46/dotnet-sdk-7.0.406-osx-x64.tar.gz";
        sha512  = "c21e57b566364607ed17bd8032a48fd7f6319646a07265333147fd0de0f7cf9c862958537d08c0c5837d22fae144b4295363c689daffb538ee956587d2f65461";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/188a79a4-50f2-4a36-b56b-6a764d5458c4/033b59ec3d8e0ab8d76ca6763be7ae5c/dotnet-sdk-7.0.406-osx-arm64.tar.gz";
        sha512  = "a186477633215784f7dd50f4f82f4a08323ee0929dc5ac99c9c76a23c74b31b4de7ea81eb4f0b6223f02ae40f5a74fe6533c7989a4a0de6669882ae0065c71e7";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "7.0.16"; sha256 = "1jx0lrh2lj8bq9smcz3j04iirpnias10a0i7w8649lcg3xf0s50c"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "7.0.16"; sha256 = "0g4zxka97q3bdc72yql296hx2laim5b4rfb8vxmknzdpzj0ydiks"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "7.0.16"; sha256 = "12dbai7f9rvb3aidyc58sibkyz3wjjgfn94pzia8jrgysx43xnqn"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "7.0.16"; sha256 = "0nlfblnfwm8b9dxk1v6vvhx1bjsbxx0xdr8rv7lwnzzjy1jwiif7"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "7.0.16"; sha256 = "0zy1zarikg4d1g06ax3zdjvfysw2393b9fgg7xnracqi17hr38ah"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "7.0.16"; sha256 = "1ggcy57k31bxqk6k1hsbmzxkyly9bzch7dw7fgl2yx4a439nkh54"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "7.0.16"; sha256 = "0hxy9mc5g5504d0x1wx41dacw3sixifxxqlvz5ifrrxrfxv9aswp"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "7.0.16"; sha256 = "0j2fwc3pbxl1k2biwz76hv0vxkvnziw2hj2hnc7rdmyw219l9ad3"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "7.0.16"; sha256 = "18276lifx22vzz13r9l038cc9s3knqyy45jvmzjl2y6j4a1kb70c"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "7.0.16"; sha256 = "1q3xkgsx57k6q9rq0jz6jrxffyxm62lh61n3ammz6cdpbdwdx2gz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "7.0.16"; sha256 = "1nrk00w3jkb1r3m8zn7c05snan02b6s7n5s93aq2dl9kz0bm530c"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "7.0.16"; sha256 = "02zbv3ilzvv5169v0ihvss6dlls9vl792d7cip9qd2x2b3vv3axp"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "7.0.16"; sha256 = "1wgmbbn81rbqlx44hg9zqrrcmiinss1qhgfsq37vzy2i8ycyn59w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "7.0.16"; sha256 = "1w6r98zlksyls5cxp7dqf0l22lqbypwzhic6zcvynkjrfxv914x4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "7.0.16"; sha256 = "0wxa2mm34l32324rywns3bphxrkxm265wxck93z030klwvxdalri"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "7.0.16"; sha256 = "1vgfzzgn3vxs0lpj46bymix0ynzqxnkxgl56qsrqhr8myp5r09pj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "7.0.16"; sha256 = "07mi30j37418a27ibrq1pk2f8gm9bmbcl94z3hawhp2d4wvm0aya"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "7.0.16"; sha256 = "1xiq43br5lk1xa4d4wzhdpn9lz3mixmyxggzbsf4i4q5692rv35f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "7.0.16"; sha256 = "1b8w278n8hcxysjs56ghx4pdbfall66nnmk1kx5a0my7lp7yp6xf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "7.0.16"; sha256 = "0qqfjjka29fi986yjhins55h5zb4xdgdjbjdlv5dm725kp1fllm4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "7.0.16"; sha256 = "1g7cpyfcmf9q3qnz6isqng3y96b40z4n7gyjbxg557rcjni1776f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "7.0.16"; sha256 = "1wqby5cfkhz55dgksfzydrs4li4s9xpmpan9ckjb5bp9n2gnl4fa"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "7.0.16"; sha256 = "1qs0h8pn0lhwriqrz19mpr17k4wz1baaysydlszqnnbprcx9yilj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "7.0.16"; sha256 = "1qb3pk1kgvwjc2n4kqfx4bqjmaihjf8cd9cfkqkkwmnnw9jd7f83"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "7.0.16"; sha256 = "05jy2w5sdkzlmad919fb8f7pj9jxx5br77jfxfasy407iqsb3hk9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "7.0.16"; sha256 = "1g5cgagfkgwyfd07h4a4c9pgijvnw7w3cx7nlxr3m8zd902s20wy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "7.0.16"; sha256 = "1w41xwdikkyplxr1kqfn1fwjvbglgsaripgdglhdx9qdxgr3nfi3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "7.0.16"; sha256 = "0mghc3ihk2j60yyrb57k200ddmhj5impl81lldpxxx9821pb0qha"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "7.0.16"; sha256 = "0rrlnlv549008akl81wb0x22sbhrr8qrpag3w6pwa92fkyi4f20v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "7.0.16"; sha256 = "0wmx9axb48ackmd51dyi066dxgkjp0zqnx2pa53gl49xdrs0msrd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "7.0.16"; sha256 = "09s99ni88kh4znq2mljvbnrnmg987i66aibgpvsb3xzwnncmb6hq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "7.0.16"; sha256 = "0fsaw2pfzsl3jd8z58s3xs9jrcssnbj0m67fbjcdmircgf8vk8dz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "7.0.16"; sha256 = "0pa22gkjjniw5q4sq7i5jg4p73c2gn439nmac1zncsarbxvjyypr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.16"; sha256 = "0wv11navikqipxnd2dj500n28jai4gqkqzmkmcci0m886k05pkzg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "7.0.16"; sha256 = "1b08nqx5fjlxnsibzqhlah5df03rxq0mwzwplaiq3pga2mj914zi"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.16"; sha256 = "03qdqykh4sx9imimwy8p1g76dyvqp72174mm8498x0707h2g1srz"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.16"; sha256 = "0588ax90h2hsivnx2jpspb8g67n36626rq429scggzcx8xlmsp2p"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.16"; sha256 = "0qdz5nrhvyx7sjnx6mggzm0m72lqy5v33y1l8hgnk2639pcvpr1c"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.16"; sha256 = "1lnw4d54g344aivyz347db01vg7r4cv3cw7nam9jbm8q6pva5wp7"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.16"; sha256 = "19jw2aii4s52qp60ka5p1z7hfwn9qyz53gw1g0bc3cd02q74spg2"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.16"; sha256 = "03nf68xr3cpadvgiyvdwkjmmhfsb527gdccviam4xwizh9ins8i0"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.16"; sha256 = "0ib8hdlz9zfhn0ra2vp3r5kv2n2vrr80krx1qi1wjjd9sn84fnm5"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.16"; sha256 = "06byb9vzpvfb32waspx8b7n4mbz04fsj808y1waxva4wxk31fkcs"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.16"; sha256 = "0yj24v6vp38y74pwzdkyx4j2ib5md7d47h4ic5294sq073c9j8xa"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.16"; sha256 = "1xkgk8yb3zigqgpnr28wwr4pjwxxnfnrf98q6jj7hpxwc8xai8j7"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.16"; sha256 = "1d65bii8g3jd03xjgb5w6dxfxbk8mpqa4gcykpnp3v05sq9g25bn"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.16"; sha256 = "0qxsrcw4781lc4hlqqd09hrnv2f5yhpzv3hg6cym6l1736ka5y7p"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.16"; sha256 = "13aycnw2s32gw3i2nq0a9g1p7gly02516svzz8qmbp6f3cj36x4m"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.16"; sha256 = "021p4xzb6l1b8dsvfwzqpshq82hgmqpccxlpkrs6dkkiwdx977xh"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.16"; sha256 = "1qzkpdq5f206vxh21lm283mbrqr0kkpjz2b0c8hd8f1lvvbwa7qb"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.16"; sha256 = "08djiaa81rakjb4hjl364ia8is76mbhp8lcqw4d4mz7n3d9hh693"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.16"; sha256 = "18nhlvnck66vsn479f36jn1rxhc29r4xxkai6ff0h1advill3a87"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.16"; sha256 = "0d61y424dz9zl2h4irimcvxwv7r2bvdxlnzx6zl44aa18flsi8ci"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.16"; sha256 = "1psm2x071v3i2125dlljh1r3wyznvjlfkwzxv1h3vwl5195fgsr4"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.16"; sha256 = "0bvhikschpxcp9jxiwd7n6shbfadwvp9ndrjd1hxylds5fbar1ca"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.16"; sha256 = "1qpxb4d96j3ch9mwh77d50ifla0j83g2r01g69ad967ghzwyl872"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.16"; sha256 = "07pil5vdaywhxc7qb7dzhmab02bi1ihvzb8dj9qn4a9009skgsgk"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.16"; sha256 = "0jpkh1nssgiq6kwbzcx5mq2wpa146lj3x1fbix5dq9xzq6f8kdyz"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.16"; sha256 = "1cq2qxds3fjcrk5km9zb95362f54cgvmhvnxxx7b5zh0jgi2aqzz"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.16"; sha256 = "1dbqhpgm6137j2i20pmlzyk1ail6r29cfkshnci4hqij0lxcjsf7"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.16"; sha256 = "1gws1vrlr7aj2317sd8vi7867ph9m806cszkxd59qhpvlsa61rk2"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.16"; sha256 = "19gd4x7b21mk8zllr5scrh8d0p6cw1lak2njp7ywskvcafbj1bcw"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.16"; sha256 = "1x82m3ja5jdimldc3nssxb14yz70pkc2sj9zr8vbab51j3lvmfcg"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.16"; sha256 = "091v9nr2mpphnp4cmv1w9mcb86fhz8qg9nki6qh6y6q1rhasz3wl"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.16"; sha256 = "0br0vl3a7fs6fg4897w3w43cw8ck21lch3vxf6jqz7qdjhry5a96"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.16"; sha256 = "0jmzzwyp61s1dkk3apirvg4b7a2dvhfx3vqy1q2azs5hi734q7kr"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.16"; sha256 = "1884ns4iyv7wa0syzxmp0jcmgr7m9x3z2c7bp3pdxxga9hy6gd3a"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "7.0.16"; sha256 = "093znlbha6bqimv1v6wxm4s1nbgkzbw2iwx4av0f7sy4ipbhvg8f"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "7.0.16"; sha256 = "0234x44hfrxlm3w8j4pbfk83jxpz4b02zfxqy2jvwyiq61qd77l9"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.16"; sha256 = "0mn6wp6gdxgd76wxf07hd4j54iwqfl4mzdijw39aia0ihcaivf8k"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.16"; sha256 = "1bd3k9q7zmw90wrwcza4sm14h1xa4lnlwm66myc2bk5a772i74r3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "7.0.16"; sha256 = "02yfpqaznjkjd4xriiav9d8jxa71bw0wnhxik2522mzahfykrpj5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "7.0.16"; sha256 = "0ln013191h2rkhm8xss4aqbb52ywp44rjfnn7pip99wdx66bkazs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "7.0.16"; sha256 = "1xbr1pc937gbvrz92ijwbpxbpjifp3dyf5fq30yrhlw9rqy73b4d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "7.0.16"; sha256 = "0xgd5nj5nx3w3m9cbh3b6r0c2w5svxjkslwqq35w445vjhq435fz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "7.0.16"; sha256 = "19lnkab2p8nkfc4jag0whkv51v3qabwdyzjk6xgj61i6s8lnnz1f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "7.0.16"; sha256 = "1yccrsv4il1rzfnz1chf1irzyjz7mny95j0dp8r5macw6qyvr55r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "7.0.16"; sha256 = "167kcrzmbhg974smd4ph4pcn9plhpgb4n8rc65i01ap2jyzllgz9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "7.0.16"; sha256 = "1hmwj4d0axhs9nn5anvnmgpa9pj03b13mcfcskn3izcwdz8wp1nz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "7.0.16"; sha256 = "1mxag31556vd31wardb7dj28vy5cabblvhlvwq1jhy6ipcvzwkvl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "7.0.16"; sha256 = "0ba54vjlzmvzwmifw150phidz06vijzxnph50jjv5rs2vzjd2vfz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "7.0.16"; sha256 = "1p5kk30w9rdds765ya6fl4b785maf21xks8favjshkaki5n5rwm7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "7.0.16"; sha256 = "0s4bmbb8rpk20x54iyyzc45fzmmi0j0fw5m8s06vrl756lqwn0av"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "7.0.16"; sha256 = "0x7pbzlk2rhnww0ja5x5xz9fqxxx6rdv83cvhnkw5gfvjy3y4gr7"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.16"; sha256 = "0hww2wdvqpjhznl2m8a1hqmhv2gagym63b56ffwkmjqmg6d77n2h"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.16"; sha256 = "1wly691zlazcj5978wv44z6m371fim9ahjgkjkr1ap0bfks5j8py"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.16"; sha256 = "0xdpgibmkcicga80xb7s8msa2l4jhskvg8q7455pj90dlmx7w0k6"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.16"; sha256 = "1n0cp4wykirh9rw66qjdqp06m9qdp76b130ra8rr9ylhiidhwhx6"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.16"; sha256 = "1pjwzk3a7d8i0p1jl190vq7iyyy8wi5zdm76zxxmn032q77ywsgr"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.16"; sha256 = "08h23dfkfmq572lckbqzlxnx1ahy80n8kf0s6s80sm9sv4vcp0ys"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.16"; sha256 = "09snx65nfb865b1nv167lvqjw678zqbhgxgdbfrv78kisg93xn74"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.16"; sha256 = "0qdpmnnpfpnjgfdpbjh4fwzcciqn04d4wbwrz02fh1bcqj4p7q7v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "7.0.16"; sha256 = "0i0cnv001kzx8rw83kaa5lzqv1irm1m41bzkx7i81ng0mkswvh5s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "7.0.16"; sha256 = "1n1mwx3bc0fxb722sc2gkhpcixsgii2c1081vdzcr84vkz048bv5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "7.0.16"; sha256 = "09mkamk7y6nxc7z5pb3c24jyhgnc7mbdbp089hvggr940sgwnwma"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "7.0.16"; sha256 = "0kgccsa34pzxalagkj7lxf1d01ikacpbdjwkj3g4qj3nmcjjcv5s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "7.0.16"; sha256 = "0brd887irlf2f8nnpi3crsbxnh3jy7dpljpakv6sjqsfmh21vzvf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "7.0.16"; sha256 = "08xbf1r3yxi5p26zbqk67ib7x2fiag82rhsd9bw27y28r0yrgjnz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "7.0.16"; sha256 = "0hb8gabxpzggzi9b1yswbcjvd2cp8bln59yrzjb88xv1n7rb7zg8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "7.0.16"; sha256 = "04j5ngl1dy1l70zswl3ph9mwwij5yj99zlbxvnij59pa6vqhnd9w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "7.0.16"; sha256 = "0yc9dfnmvqb5grwv75c5ixz42l4lkqb326pi362k910rhqdg6rgd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "7.0.16"; sha256 = "0zzsfzd5chf6fygsj9mfzaiyxi4ymg6ndr6mgpr5qb1dvkxyzgj9"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.16"; sha256 = "1njsks3g2nc83inpj0jywscy6lv3rbs3zksnrg8pcj3qkx4dydph"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.16"; sha256 = "0kl9wrnf8d8k72wfyk6kg247s41h3ad64a2zw6b3crzyp8g0kyy4"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.16"; sha256 = "1phmdcih3a456v8l03hr8mw58vb8zza7f94i2zwf8833azqp64hl"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.16"; sha256 = "14s0099y3ilr75p80zzvawdcvs2isadavhgi4im88nswnljc40qw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "7.0.16"; sha256 = "16fzqj99z9fj8x3vjmwa1iwx5bvnyk6wkkznyax0222v9cfbcim1"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.16"; sha256 = "1hsx2mxpwxwp6r1akh8dxqnzqqzlr5xc0w4i36m5ngacjficw3a7"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.16"; sha256 = "10gympyxph3dfdjf0aznmjxw8jiyj17ffs0bxrriyyvys6h386aj"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.16"; sha256 = "0311aapybm1qbqxqgdx27a2lmic8ngqp9m2m616jirj2c1qipdq8"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.16"; sha256 = "0r2n2vkxv8cfcczi900k7wdcg0jaxsw789mla192zw1d80xx5k35"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.16"; sha256 = "07ad9kd1p0wwfa2cr7zs0bzqzcbrzspxmrflg06vyzzcagckz3lx"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.16"; sha256 = "1b0canksc2q34kvngshcqjxvb9lm76vg9z8fj3k40vjbchybs297"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.16"; sha256 = "1pj35db9gwg37ip66rhvnv3jvxhq1v3sz3ilrlhfa3s1bmws3awk"; })
    ];
  };
}
