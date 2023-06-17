{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v8.0 (preview)
{
  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.0-preview.4.23260.4";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bda9e867-46d3-416b-864f-5fb28658a8fd/c58375f59b0c0a9946a2be04617a7276/aspnetcore-runtime-8.0.0-preview.4.23260.4-linux-x64.tar.gz";
        sha512  = "fa2f95d90dafc11e083904e5795a0f9011ccd135a94e64149795a4404a900f0962d2d8cb187db2e5d32e0d8ca55387626e7201ac0c8127fba0cb499eb5a78c61";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c9d4a334-d522-4439-a98a-0af0e7852621/9c3afe685d3e65a92d5c538afa211de7/aspnetcore-runtime-8.0.0-preview.4.23260.4-linux-arm64.tar.gz";
        sha512  = "1224d2ebe38122380db54b8fbf5ce95a7666b2a2062a1f5da40a769e0ec859640ced391ca6cfabe21f5c0aef4a7b1722b324f361e898c9c8c4207198b0b390b5";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6011ab96-f3be-414f-b13b-792aad1e383c/e78722ebae2ad81640e05286a30eb0c8/aspnetcore-runtime-8.0.0-preview.4.23260.4-osx-x64.tar.gz";
        sha512  = "98cd0208733397e622afc725873983f8f4ee41cd5a7d1987f973e71b640aaa0210d99b4a3d2acffe3e1f016c5816998d06289d3ae509f9280078bb716962851a";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5acf37f1-8232-4421-b4ae-41d635e2c8d1/3de8d329bb5d905e539f61a12d6091c9/aspnetcore-runtime-8.0.0-preview.4.23260.4-osx-arm64.tar.gz";
        sha512  = "c0c248789f312e7430850ce53400e041ed550f3ac6eb30ca16a83c344c6110fdd34e7e92bf3c06ca083a4b5b8f01ba37542ed9136458f0d3e41a6cfab22ea5b7";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.0-preview.4.23259.5";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7267fec0-ae12-4f40-9c3d-56da5fbf83e4/f64c2758980c1f908cbe089a6233bbe7/dotnet-runtime-8.0.0-preview.4.23259.5-linux-x64.tar.gz";
        sha512  = "02544cc1109f3d7e3fc2065b42c7f1ddd4777ffd8765456c8422b6c4b815abf60cac56d69058c2bff7c7c680d47bc6bcd3e00678db818387b6d09ce9b42f64d0";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8fac5d3e-dd32-4b29-a187-1887a912e185/d350aabe412cb33d9c2f2cafbf7c9bed/dotnet-runtime-8.0.0-preview.4.23259.5-linux-arm64.tar.gz";
        sha512  = "56beb8b362028eee4751081811b51a6f5a741736ca2de401a9a9178deaf0b0b8e3790e3175e953fe59140ad0b80700d0b75894d7326b996700d97ed667233394";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/636e676d-136c-4ad3-86c8-d4e86869832e/627c24b6a6753b0dee5af4a322f79155/dotnet-runtime-8.0.0-preview.4.23259.5-osx-x64.tar.gz";
        sha512  = "117af68c68caa2fba04cdb9ef5d4df230d315e30069a7dd378ae413db4dfcb789730f91b2d9898f78e525bdaae6b2b5bf521d5255abda96be35a73ca0cab3ded";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c0d0406b-3995-403d-b25c-6ad764291eaa/7f1d366577de292f32623bdf88a5dacf/dotnet-runtime-8.0.0-preview.4.23259.5-osx-arm64.tar.gz";
        sha512  = "497dc9494c3aab67f60717598e6676650bde300170e1d78a14ffba955d76641b62852c64145b5358eca4a3c0b16dbb1dd8cf662c8b04df3202128d97e05ab8bd";
      };
    };
  };

  sdk_8_0 = buildNetSdk {
    version = "8.0.100-preview.4.23260.5";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ae0534ab-1c49-4055-ba2a-b8159c4f94d2/3a5945c949d2eb141f8ce52096fca13c/dotnet-sdk-8.0.100-preview.4.23260.5-linux-x64.tar.gz";
        sha512  = "1132220710d0e2deb97b58e0f439dfd86e965fc5347a2cc9aa3326ebdd98b21361fd6c019507a884927ee3b0053aa93bc0adfb67554ee5d9526c697ae9771551";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9de5d7d8-6062-4a61-b8bf-b1b61dd4b768/f23a336abc7548309acf01314ddc8904/dotnet-sdk-8.0.100-preview.4.23260.5-linux-arm64.tar.gz";
        sha512  = "47d9d1a67b58223b749fc1ca176c4dbd7049d7437f0717a61a6b22923b9a4c243e4d101c655bc1db817e281e0272ad452f4af6fc60c51d98493d85253e7476db";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/78706993-4be4-46e0-8b14-48f295884a1b/39c2db8388ac84cdfe7e909bdde39384/dotnet-sdk-8.0.100-preview.4.23260.5-osx-x64.tar.gz";
        sha512  = "be1a7cdde31cf018d4d3b1d6c8305330bfc44b5c2e515c3213d162ab227d902edba16a8e422ab1d5441c712b2e50480d1e9240e6a26a51421c794840baafbe23";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/2c6668f9-b531-427a-b3b5-5c9dc456c5b8/ef5ef0a8db2df07d12ef138e05fa2231/dotnet-sdk-8.0.100-preview.4.23260.5-osx-arm64.tar.gz";
        sha512  = "d66f6a9008b707119b37e9d2fa746aaa126f5f87452f25aa4902f3e50d08844218e11a55ecafa731c88eaf9b5aef21d08f828064d722446719ba37e69940a813";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "8.0.0-preview.4.23260.4"; sha256 = "1d3iifh5cqdxf2gk45wna21z8amk7cml505daqkh1jgd50sp12n7"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "8.0.0-preview.4.23260.4"; sha256 = "0ziz2h08d75y4s8ifws6xr4y0jh74j5ccc4hhbzw19b57xdyvlbz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "8.0.0-preview.4.23260.4"; sha256 = "15yvjnij8ij2zbnwcq9cqbxjch1rgzyadi0a295axcjn0jpgg0y9"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "8.0.0-preview.4.23260.4"; sha256 = "02x4k23r6g74fzm9fiiq1cmh1vdjv0i355pfnzfmnwyya1rim3j4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "8.0.0-preview.4.23260.4"; sha256 = "1y88sr0yh8aypi34smxcy94djmvdkww0iq8cmk3sqccjxzyrfc8i"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "8.0.0-preview.4.23260.4"; sha256 = "0armm7x8v8cpa778xcq3iykwfhpnwcz21qhiaqrbc186hjgq1a2l"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "8.0.0-preview.4.23260.4"; sha256 = "1wx5iq5yd8wrcnk8hsy7bknc9vi24fdnmywqj49rkmnr51ya41d0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "8.0.0-preview.4.23260.4"; sha256 = "0z442kryiaiq191knpqgyg73ialnbm1nxi62pdsarfia7wxlgqxz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "8.0.0-preview.4.23260.4"; sha256 = "1sshh549dsv1brv4qwbkp4g8sz4z4gq56y6dk7hysjx4qdlv159q"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "8.0.0-preview.4.23260.4"; sha256 = "0xsg8fjqply0ah5h6rwq871j3yr85ksvakyfm140pjf594cxwgxh"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "8.0.0-preview.4.23260.4"; sha256 = "08x79vw0zw3153dpfrzm3fqfv36l7m55p7xlfqbn4c817fy10y52"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "8.0.0-preview.4.23260.4"; sha256 = "0n9s4q8w7glxp3dwkzf549rk010pjnxj08hqz4m0jhk81vnm7nqf"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "8.0.0-preview.4.23260.4"; sha256 = "07j59nbbakcw1npi6zk06fwbhp3rpd3n73drmyx9sk0j34mqrqs4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "8.0.0-preview.4.23259.5"; sha256 = "1f2xy2zqa8qjfd2dwgx1mcp0gpqvgzypppqk2sg3kbq879fis9ys"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "8.0.0-preview.4.23259.5"; sha256 = "14j6ahm3arfi78m6kjacid7vrw0shjyqh90cdxq3s02s8y6xb4vg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "8.0.0-preview.4.23259.5"; sha256 = "0hncsby0gccfipsimgqp2n5ryzpd5940prds5rwvr8ncm2zzsikf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "8.0.0-preview.4.23259.5"; sha256 = "19pimns32v9gpx27gi53spzkr05r2d3cjg0cr1sydrp5xashvjws"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "8.0.0-preview.4.23259.5"; sha256 = "15wx6bdk38a75llqbc7hw4gizqhlhmyvdr2c0n4jb7vq54b8vh7f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "8.0.0-preview.4.23259.5"; sha256 = "1dg12c904pkd5khm1lqqxzmh1w1hpvi5rb136wm2jh2gri32wmzy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "8.0.0-preview.4.23259.5"; sha256 = "0m08mv9jhpglgalxn37m9acwyrhxjr2kk0cavpjq1nd7imlnhday"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "8.0.0-preview.4.23259.5"; sha256 = "1jchikr4h1snzg3ai4022m5wj9bfallxc2jb9pq0p0zcyr7gy7ig"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "8.0.0-preview.4.23259.5"; sha256 = "1cc8fhh90gh5wra50ys4bqs39qzp6kb477hci8smbflg3dww4l40"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "8.0.0-preview.4.23259.5"; sha256 = "1kv5pzzxhj2cpysxz9jbliz6yz146v9bwr6n9l6vgrayavmg5k5z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "8.0.0-preview.4.23259.5"; sha256 = "196kph47z4k92bdnqfgki2p9l20rcgj7ls5j609ig845wc2z4az5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "8.0.0-preview.4.23259.5"; sha256 = "0m238kwijlpx9y68w86svks7v90kxnr5ssfsaxn58iv2gll4fq2k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "8.0.0-preview.4.23259.5"; sha256 = "170r6xlc3jvvzn4vs1pihkwkw25vqx9940np30padm9r99yyp9bg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "8.0.0-preview.4.23259.5"; sha256 = "1l8qsmi66b1nxdkyz93d9kb4lm3xc55648qdl66ny6sj2h32palj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "8.0.0-preview.4.23259.5"; sha256 = "06hs42ab2k7n7fmasg4nvxknwbv6ffslrd5c188jyfk1m23f12yx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "8.0.0-preview.4.23259.5"; sha256 = "13y8n0hk78l4qkh2h8rwd80knn9jid42q634bsgqalmlg1vplzy0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "8.0.0-preview.4.23259.5"; sha256 = "1ggfqw34pbywpvgjj6qmzv3qbi4i62l4c9xqwi4460z1nv6kxnhi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "8.0.0-preview.4.23259.5"; sha256 = "09jf4zahypzmy95h6asxzkrr7827vwdm83dwasydlzn9cal6xd1i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "8.0.0-preview.4.23259.5"; sha256 = "1xgwxfqhdd0m8qh642bwazgridzrhzs220af6j2qkbyjgsvav4fr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "8.0.0-preview.4.23259.5"; sha256 = "0wvkvaxr661xwr8ch03nlaiyn0ws2ly90yrv0qxvyz60z7b4mi8l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "06wx5kk8zc2dbakwb6gfldxh57v2aiyvqnafr4clq14iw5pki4gc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "13nlrvmjmwzfaf3r37pkdqsgvnby7hp2m7cwcx610vwsjaylyv43"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.4.23259.5"; sha256 = "09nnvqdhgyzp8smaz62a8c9v2awzzc0xxirjs5qiz4f87q76xnc5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.4.23259.5"; sha256 = "0jvm3x2687z85acv6wc9pc2lgzifhz9n3kdsqbwj6djy6vjrhdii"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "03p2khg9x35zf9ws905l61mca4d16i19j8d33bm5igmaizf8hvis"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "04r92k2k7vlds0g6yb6slhmxwricl68gnfzddf7ajrvbz0skvpk8"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.4.23259.5"; sha256 = "1v2dlm8vw9k020lv3lm4g360wkf0nhlxdv8dfix1vl6nd1qr3njw"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.4.23259.5"; sha256 = "0qsrx612kjfpm6xd9a2l7a7qlfw9qmwrn6dnml622zb90nr37iab"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "0rlqs580jflv059w02bq2hmjdawshh376grwxr9vx1v76h38ll2n"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "0dxrv5ypinjx37yazi4zzzp6a712vj4fjlgrzq3h2w6hwz1gf5ay"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.4.23259.5"; sha256 = "0br19vniyn8z8g0b3njga1qzpkmsxk6zwdbafdjhw9pbd4vasx3l"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.4.23259.5"; sha256 = "1vbdnjdab7bxm3w3dabzpga3mgvp6ck6q0iiby789d4nq75zxi8y"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "00pfba98r89ny186rh2yjbx2nx40dx2payi13j8s63js7mim31an"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "1r9finqxwsgqs7f1cvgfjg3ija9lmxnc7p4whaz5sy1lgzyh7wxv"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.4.23259.5"; sha256 = "167m64vvl9649wcp55ggyy1y6q2rhcn2g7pa0zrarl2fg74hda15"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.4.23259.5"; sha256 = "177kwd8qghvibxzhm9n4jmdxs4jdpav04gkc2jvqi4jmk9kfix1z"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "1zgh1fz27bkz9gx813i87xawd9cpwwgch7npfr78csiv3ssqyxf0"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "0ms5r3lih96haz02n5qxv971igah6b00v9wmx6j4m7kk81y8jwsl"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.4.23259.5"; sha256 = "1qmxwx1c57ak6b9lb3rxglxxwm1bnlx2vlldwyq9pl5k5bp4ja77"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.4.23259.5"; sha256 = "0qvl27k2vqsxbpwswpbmx8z8r874nsjprcwkn1imcbrnlgrsw1yd"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "05ycd8gd7lacwh1v85m08zi820x144xzb9w4c5h2d46myhflx238"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "11p76kv9p9ml44y62j4lrqr4y4p75syf86cqjsghsx48b6hqavj4"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.4.23259.5"; sha256 = "08yhc2w6xmbx742f6n8w25iqa14a83khq80krqvr5wh6dfv0j2r3"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.4.23259.5"; sha256 = "1vkczbgajyyys550s62ysqvxgp1w4dl80wyxxa3x57502qrg9dh5"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "1hvdpxjlf9h199xiyzp61ys8m7bnbdmyqqzf59qgidlfk7f4bzn6"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "1xb2d07p00paym06scq8wmg9bvnzfkcgjqjcjqlbbx4d6y2cghpx"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.4.23259.5"; sha256 = "0xfg74za501byqzfsydagd59wbnknfrkj5p9l93f87vz147dpwgq"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.4.23259.5"; sha256 = "0x3hh1k17449rbz010qn8jw9j1r9yl931wr2rk6aci5c9l9c0c89"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "0vrkimk6dl096af256dm9qvhz0cawn37idmqhgyw0w5sq5vp340v"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "1plbjhnh2sa2s9znwn5mkdic20ls755q81hh5zg5ma89q7c94c9n"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.4.23259.5"; sha256 = "1jx6kx7f44zj346q6gvly2slwkw8fplfjzwfr6ryjvzb2llhs4ng"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.4.23259.5"; sha256 = "0cqh3mfmbxnnsrlqaygrvd188nwzf7ik4a77ghv5i1s9jqlb1qyb"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "0gna1y8ygdr7r9j8sknk8gpb5j1fhmwckp1cdj8d9n2g8c8r26fc"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "1d8654bzzbfmi0phgikrifwpdhh8xyymx2jwwxjhfww6nb3n3n2j"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.4.23259.5"; sha256 = "1qg9vzxw0wcn3j2m87rc5cllkfhqi089p8gxw4njic6dm5yxcr4h"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.4.23259.5"; sha256 = "1gz1gk2vjrz5cq65kipkv1k5y0x9q67qg4r26c6fb8s55l4f7wr5"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "1czl0s1sm9wdcgscn0a9r9qb858yr0ak524vnghx81m87s4fl5l6"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "01cwnnwhhr12yqjkjz2fpqhsh9zmdvn95nxrh4x4qzylfs3brw3w"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.4.23259.5"; sha256 = "0n2m6j9izi668s0wa9pgjfafb7lka45sscgzspmzqc80syyr10lj"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.4.23259.5"; sha256 = "1s5fnq3ybvjpw1ddbk3mxx9vzq3s4l0wk9qm6373742c0bnv4k32"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "1s9glkf7zbsdkc0zpvj7r0xkll2g0d6c2v8hw42qmpmb3lby9p0r"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "166jxayw2vx1iysxn8v1ql13x52fw8h4ivrnvziyw43wdk76xjdc"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.4.23259.5"; sha256 = "03x8cv14wsfizzj7fqmyqlbxdn1lkm49xq8jhyhfrrl936f27xd2"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.4.23259.5"; sha256 = "11y01apmjqf18phnzdy5pj62r43m10w1dis8b5sxkz55vsyk1znh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "8.0.0-preview.4.23259.5"; sha256 = "1k221gbx12h9pqqb8zb45zjpy9rfffa7r9q4lx72zg47273rrpkj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "8.0.0-preview.4.23259.5"; sha256 = "0wyyp5f9vnbkqqb0xpxk2n6vcygd271hq6nbll3qrvg5ry9kn51l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "8.0.0-preview.4.23259.5"; sha256 = "1vrcqhpjrmcl4rqpwb3mlgj6gpwwdfz615j4cv5yndwl6pcwi2c7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "8.0.0-preview.4.23259.5"; sha256 = "0rvwvrqiw0b7830i6vn4k6aj0x24bdbvsifg4f4bsd5gd7p8k7m9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "8.0.0-preview.4.23259.5"; sha256 = "12zkl0nar5jw69r8ajliv9nbqng07md168708758g39yzvrs33vb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "8.0.0-preview.4.23259.5"; sha256 = "07p5svdm9i356m9z6qrsbmxjw57jxb5545hmyhipyhcy6yc935sw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "8.0.0-preview.4.23259.5"; sha256 = "1qxxhpccfgvdkkxj5h8mmglh13gpaxis846gq2clx12x5wnhyc8f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "8.0.0-preview.4.23259.5"; sha256 = "017ypd8aa8m9zjv4irbi5p2334q6qfbnzn4wka9kq7m5r7psb3hh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "8.0.0-preview.4.23259.5"; sha256 = "0c1zjb4i0qw7zphhnziawbyflq281jyhs16mmpcx30gi4pmdxm6r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "8.0.0-preview.4.23259.5"; sha256 = "08ax6gyqyj71f20yx54qk8nzwy45k2dnsq3rrnffiyzpwnxsaj0z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "8.0.0-preview.4.23259.5"; sha256 = "14bsjrb344ryhilnkq31pl5jlswpdm1lv8xlpdz1xpdfz1d50qj3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "8.0.0-preview.4.23259.5"; sha256 = "0i1w14i70rmxbg16dvgr6scg7ad4sdq1cch1cxrs32r195k6mx1l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "8.0.0-preview.4.23259.5"; sha256 = "1sga9fgq97zpcws2akpkpm5qsaq0sl9xnqh77jc1fadrlvg7dkin"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "8.0.0-preview.4.23259.5"; sha256 = "1088ss3d0n3afhyi6k89w002wb0h08z3vwxx53fgkdjx1ivqh9hs"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "017nda21914ycdvp6ahzqvdiphaghj3aim8ywnjgrlbzi94x5r03"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "1apdjkjm0f9cg3y9l1xqcmyvnkvqhsf3wdzl31cv7324w4p5wk9r"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.4.23259.5"; sha256 = "1xfh9j892q54n592q9pc5171xxn3p9mqk3c9l0p56wnn50gysvny"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.4.23259.5"; sha256 = "0sz1b0bba36w7nwvbzdfbcpic0pqv5x283gjbdpk7pf1khz39f3v"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "0pspdq0sny7kpfhc8knjsd8711vxnv0ipmg1dy1i2a0ynp5hgn3c"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.4.23259.5"; sha256 = "1bac4a64fn80vdnl28qfpvqdkzd8n0k35hdpviwc076r0zib2idv"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.4.23259.5"; sha256 = "1yv9fwrfykx2n3r2fkplbh344d7ja7d1hbygn2y4mhkkj2xxbpxp"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.4.23259.5"; sha256 = "02wg6cd2vv1ibrlsdl8lkr69nn4h5jvkhdfd429rdkq4pyykm4qb"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.4.23259.5"; sha256 = "1b2h8aqb5sda22cpg1547ayvndlzc84y0b7jg5yy2qd6vv7sx9if"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.4.23259.5"; sha256 = "0m1kyayg1r8i6i1h9n6wran1f62m911vpqgp269gzda4ljb9h2vq"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.4.23259.5"; sha256 = "0f5ml8b84c218fvfwqa1nmr731wvy4sh8minik6kyv0dg0z9kikr"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.4.23259.5"; sha256 = "08lqhmz48szasi8klzwyssbbxvifaq6bgvnnvn5qxhpffl9kxsqj"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.4.23259.5"; sha256 = "057zpvsd67gp8lw826ljc1iyx8gp4i9nxx89n94j5jsvhd33v8ii"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.4.23259.5"; sha256 = "1nlii0clbwqs2gq72lhmf7hf52pia5mn996xvj2n9hsdj7h35ayd"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.4.23259.5"; sha256 = "0rjrjcmns4875rq7qkfgbc4ybs8vcdsfscbkwsz426cgnxpsp8jk"; })
    ];
  };
}
