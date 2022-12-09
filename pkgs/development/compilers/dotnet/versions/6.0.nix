{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v6.0 (lts)
{
  aspnetcore_6_0 = buildAspNetCore {
    inherit icu;
    version = "6.0.11";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0a17a9f6-7705-4b47-aead-c0b582cad317/158b62e5183281e416994d56ce81bc0c/aspnetcore-runtime-6.0.11-linux-x64.tar.gz";
        sha512  = "12a30719aacd5b3dd444d075c13966a4bb1dc149c36bcbc0e685730f08d1c75eb3929749b89a88569ddb48bd8104db84aaee2ee097ac3a5fe6fff60c9f09f741";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e25f7ff2-9932-41dd-b549-5b4409b5a727/d00786aeabad50cd661e959a576f8777/aspnetcore-runtime-6.0.11-linux-arm64.tar.gz";
        sha512  = "cf2a469cc2364358e0cd51640e9a614747e60724a99d5151dbd346eaad3779939f741f0cd0a752774a6df51c3e2af5a49ba8e4c5ba7ac02eda192cb7b73d85f7";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/16a48ca7-a75f-48bf-a513-ce5721debde1/b55c60cfbac77c576fb0161a4d4ad8af/aspnetcore-runtime-6.0.11-osx-x64.tar.gz";
        sha512  = "cc5d76404fd1a352404597cfa36def6c06018aac9f53c938d96264fa057534364057531d91c8b0ecfb2aed6c2816ce32c0a67bcae39da241c3ee36cdd35ebe9c";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4bb8e524-4a1c-403b-adef-362e13b22fcf/6304e6772640e07412ccfb9a0a5ec58a/aspnetcore-runtime-6.0.11-osx-arm64.tar.gz";
        sha512  = "e52add6045fd30482d3ba1703b41d354f38661ac9f88b1b70aa31d4ff5bc685b8767579b172519a4471beaa3cfdb346f46298da369a5714923937f1af03e353c";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    inherit icu;
    version = "6.0.11";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/367108bb-8782-4f0b-839d-c98191b7729a/94185f91ef33890816a5846a374b74b7/dotnet-runtime-6.0.11-linux-x64.tar.gz";
        sha512  = "9462d73fd3f72efaa2fb4aa472055f388da4915e75cfc123298b3494f1dfd8d48c44bfa6cd5c41678ab7353d9085d05dd7f1fee0eef20c11742446e3591e45df";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b02be36b-8470-4b81-8254-1f957ce8f397/fd6aa0da17fc51c1b57b2d96aa792c1a/dotnet-runtime-6.0.11-linux-arm64.tar.gz";
        sha512  = "c889e70ea0b2224eb9163cca6a57cbbbbb8213a551770dc5c9f08d8d49fec1f38ac4802435cc9509baa03970823666fe1dd80621e6ee8592c27b7e639643e5d3";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c9bd7b7d-8dbd-4486-b3a6-d3bd29e9efc1/4b2debd5a8aa0812cbe19cc6cae26066/dotnet-runtime-6.0.11-osx-x64.tar.gz";
        sha512  = "d8df6aee071b9c59672df6c67cb56c87796d9204a5fb044bd9e7a6fc7d5f83c84e0ee5ec871d57f38a226f57c70d18e52cb35a6520d26d94b335c97a860e6c01";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6fde4997-8628-4666-8281-6aef1322cda3/f9ead70f42ef845bbc5c17d53b174931/dotnet-runtime-6.0.11-osx-arm64.tar.gz";
        sha512  = "0fe0a7f88a1c99b682a0f60d60d6d1954b9ce185450fc21e3700f1e0b2b1b58ae7412cd43636bc7e7ef9d1412d38661df772c946524c5659d05b8945fdfb468d";
      };
    };
  };

  sdk_6_0 = buildNetSdk {
    inherit icu;
    version = "6.0.403";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1d2007d3-da35-48ad-80cc-a39cbc726908/1f3555baa8b14c3327bb4eaa570d7d07/dotnet-sdk-6.0.403-linux-x64.tar.gz";
        sha512  = "779b3e24a889dbb517e5ff5359dab45dd3296160e4cb5592e6e41ea15cbf87279f08405febf07517aa02351f953b603e59648550a096eefcb0a20fdaf03fadde";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/67ca3f83-3769-4cd8-882a-27ab0c191784/bf631a0229827de92f5c026055218cc0/dotnet-sdk-6.0.403-linux-arm64.tar.gz";
        sha512  = "fe62f6eca80acb6774f0a80c472dd02851d88f7ec09cc7f1cadd9981ec0ee1ceb87224911fc0c544cb932c7f5a91c66471a0458b50f85c899154bc8c3605a88e";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/fdbd3d94-ea79-44c9-bf84-ca161871ee50/6e4b47c4926e30251a178014fe3da399/dotnet-sdk-6.0.403-osx-x64.tar.gz";
        sha512  = "8a8b6f86f09d0c5a8dbc35f6adbb14cbb2ed10d1bcee0a15e717a416c759f824b2453fab0b76e0826c149612fe2fb8bdfc3f8827383dd3f8f01ef5497b85d589";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e825e710-a4ac-4bf8-9777-36aaed9ba8fc/1dbf807664c030ffe386453ed35030fb/dotnet-sdk-6.0.403-osx-arm64.tar.gz";
        sha512  = "1210ec9341f7ce192b2a006b1e5d98385e1108d016b0db3c6eb5ac5a1ecd6c9384fe26b62363d3a885e5ba26ec50cbe483970563e897bbb274568990aa43810b";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.11"; sha256 = "1z15s89x44yxv80vm3wnnlz09ljalp3aifybs1pd77967ik3xyq0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.11"; sha256 = "1pw25rnw5nm51wjdjbrhzhz9v0c8gjjqn2na2bam3c5xawvnqkqf"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.11"; sha256 = "127hcb0fwqhxwcwkb1dy77xqm3vr29c5710n3y6jhk0p4sydnrf6"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.11"; sha256 = "16f24lrvrzg02p4ynl69vxq2v13a653pl0i6d1pkn0248mc3h7fk"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.11"; sha256 = "0vd5da34frm7avrc9d16d39s2k5sgzd260j5pkjsianhpjby5rbn"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.11"; sha256 = "0gy7whqd7blj6k7zyv3bgfs2hhwxvkjvvdf4axvnq43w1sv8s92d"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "6.0.11"; sha256 = "0b29lnas3affa0xdgbnxgvcqhzs5v7b40y9kz910lf8k674qxmmy"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.11"; sha256 = "0zx6hw2bjhzwlrny8zkd2223bck1cimws3pkwi3gqyajn1ck49im"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.11"; sha256 = "1yaybb1rmwia5n60bahbykn32y7wad9hqp818hkc3ypxzisd2hwp"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.11"; sha256 = "06is4h5s81np7bx31xb8svzpqz7m16gxs0hvqx5ab2qxhwkwa8x0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.11"; sha256 = "15n8x52njzxs2cwzzswi0kawm673jkvf2yga87jaf7hr729bfmcr"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.11"; sha256 = "05n56w958nzivf5ysls3v5ld1r31fcxq4k3228g9mdxinswhch0v"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.11"; sha256 = "066018q4cr20404gi6i4x6xmq2hcvmlszrx5nv1gr6rlhg7xw6vh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.11"; sha256 = "1ypyxz74hfpcipwgiybdw9pwqkbshbrvil0q53ln75p1hkx51yna"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.11"; sha256 = "0k8nl3hnr8h0ljw185dyhavrz2f7x6wavyadyf7f1v289jzasj72"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.11"; sha256 = "0l5yyqqm1mm96kkyr56b8l1cygs8z5jb72qd51gln47kgxxhcxl0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.11"; sha256 = "12qwrvz46ysw0537s6qax6igcj7bgydcyfskf4s1pb6yzpys84cn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.11"; sha256 = "0bnq4dj7s5mspi7f8ihpp2y4bncb229ihrcmxvifsbb15mlhh8g4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.11"; sha256 = "12g1ynar2n1jrrwa98fcp76gidj227c8swc6c3yfq4v3lgsws9mx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "6.0.11"; sha256 = "0k7yylj9jc7rzc8k014pdyrgiqliw6yq5bvqvjx7vm3k26mr5bjj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.11"; sha256 = "0pgdnbklh28hmkaymn3hz3x30754fkms5hhjpvf2f6zwxjznihd0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.11"; sha256 = "19x6xrjika4iz1xsclxcivffnml1byvazly2l16jk2g5yzab52bm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.11"; sha256 = "0rpka8pv6nhzyglyxgmx6a18qq213fsgazi9chh4x7hv0l573dgh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.11"; sha256 = "1dqx8spmn4zk6h0qvy522hf86zl5zf5k3m403rpdvqbwv5d4prsg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.11"; sha256 = "03kvh4l5j8i8263wz7fmznzf5rs1grgazrhi3ayhynvhdal04mdk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.11"; sha256 = "1r604xbnknk6xcsnk4g1g0mw3s99l021f56xf1nbalyhh85q95q5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.11"; sha256 = "1aslp6yidcmwsv9kxykl66sfgwlhi5kq1zw9fzw5mj7zqllgm4l9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.11"; sha256 = "1f60dyl8pnj067i7bvmsbazcvrjkgrz9943vjj0ym49cfyq98cnw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.11"; sha256 = "01bwpalzfw62qc708488aspyy8lpyjppj1ywfhswbqllaf00i5xs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "6.0.11"; sha256 = "1gsl464hw93vhigglhg8b771p7lmhq0h4rykjrn7x6148iswmhkw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.11"; sha256 = "19l1533sh8g7fngfxa538lg6lnga4di4f4icph0wbs9133x797zb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.11"; sha256 = "07ym9n57gr4vwr9x693f73nz979p1x839fk04yq0vav6v29s6fgk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.11"; sha256 = "0i9kmk37jddy7672k393idnzkncznim2w846zl58pmb6jdldxm79"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.11"; sha256 = "1q3h9nyjdvcr3951kbghln03fclii83dis0dknni8ygn5nc19zmq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.11"; sha256 = "0g5bc7mv16a7k02zw40i238r3f8yi6swspjba5iwisv5knp85dzb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.11"; sha256 = "0pavlb0dblfcnhwr0w6yvn169nggsr2sip0a48ywmzchss3jxs8s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.11"; sha256 = "01n24jn0i9j5mkh3nwx4l56aw2hc28gkrnfjk7b76rq2yib8dl1i"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.11"; sha256 = "0gzwa2aq158l724sl1dcdarlr0y09ll33mhihc9jkpw1y63c2y2n"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.11"; sha256 = "0aqbqhdli5daynlvbnlg5izf7fhmx2gvf97c9yj8zmvg9grqn4vy"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.11"; sha256 = "12xm1wb5k62dpzk12kmnxqqc96h5sidkbf9rghp2hab4dil7d540"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.11"; sha256 = "1plbj8s3wm77mfcm9ps03zc6mdhf0adxbjxf5k2gfxny736dpsb3"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.11"; sha256 = "10nb9ppd3ifgjaxp5q2yyc2bzw9j7shpbp4lh8r21hm4kbyly6bi"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.11"; sha256 = "1mvcnvjm97808hlq9kf2s502rf0ab5vk4bqm5x1jgg9913819i7y"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.11"; sha256 = "1pmp95dbilxsw84g4bxvibsbs0wgz5kqs07lds5raykhipvrhybp"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.11"; sha256 = "1gawsvad4kwr5z1ccsngrdkqqy8wlivk69f6c9fxnbc5srw5kcp9"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.11"; sha256 = "0qxk7r0m5mhvnb3li1yznl2dw95xl9mpkd4sk9hb15rpyxlkfqmb"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.11"; sha256 = "0xmm6y21296l40sfhxgqfqfp7fxdjva2vh6qixnjx2ddablni8q5"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.11"; sha256 = "0fxwrw3d5sffsbbwka02vwimfxp7gj1f0jf25hyaqnqbj1gpgs0l"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.11"; sha256 = "0shwxx47l4jkk757cp6z1iiwbdkiw6sb9jbzwjmsjv3m8swrr44k"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.11"; sha256 = "040zx6skb8wkdmybhgagyj9dcpj2ag9izn2ww0ak3zhbyx4n6gp4"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.11"; sha256 = "05a35jblvxmc0xdsl6gmfxjbxx473an4ha49wldcmyg0451pfkwk"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.11"; sha256 = "1s9frv6h18fi0089afs1qpm8q4lxbfphg2vfd8gkzkwj844jbbqv"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.11"; sha256 = "1c3r7v664bj3h3dch0d860ly75xbcnfc1894cj34g7a67fdhr0l3"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.11"; sha256 = "0q726zb93cd08lr8z77srxk8ab13m755817kss325i32l3zsij44"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.11"; sha256 = "0yk0alqhjna2brvkmgxzvbgja6bfq39sjh35sakglljkmxgypxpz"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.11"; sha256 = "08cf22dd75yab2y9k561yy2y14pwqmpfscssz1n46kqzmxk6zbak"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.11"; sha256 = "0rkhdp3zdc8r9k508fr7fad0j31fh7x33m9q0wg6pia4fdwvh87s"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.11"; sha256 = "10sbpgxikvngf7ddfjw0w2lm54ni6a2gh5mdk9wnnv2lyy6bicrv"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.11"; sha256 = "0sz6yxwij25rxizzbpf4ic1fm5fb2n1k63hgnd0yxshhrpp8syjg"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.11"; sha256 = "1bkka2i41x8qmk0i4a5spabv9bb2jbd12qq0ym98anky6dfvs1r0"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.11"; sha256 = "0fkzkbl12jkwgn9qk23hcz0b2ydfhq7li6frr5np0qpdc66624ha"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.11"; sha256 = "0w2y4xhdszipq7ypp8psk9xmk96pyr1227f8psrs5hdrb58ahzfl"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.11"; sha256 = "0s62ggs2534cmwcsh341jnf0d7frx3bz98h5lb6qiyxa1844na9g"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.11"; sha256 = "1h5q0836z5xn9r4byb1l0ahmhzfa7wlcd6jfl71ja2l2h051k4rq"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.11"; sha256 = "1wnk0gq69g534840ljq0drq6g7a937y3q6r17jxvjdsi3x7gi8cp"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.11"; sha256 = "1smmca72ld8cn4cj7g15xhnx9iadam1cqj1p8xxg0dwa794b83sh"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.11"; sha256 = "0rdxa2d816l3zrf8ijkq0blf685hh9nfnqsxkb96md3xkpqwimnh"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.11"; sha256 = "18hd09z977ad3m5mmhvgbwzb95m2nhsj9nad7plbsdykg8wh0ls2"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.11"; sha256 = "0p850ixy3qxmhh5xfw7wwhmdqzwcf7wxzn80fmlq5f3iwvb3y6nb"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.11"; sha256 = "18252p14vvjxm2sqbn4j122zv9f78rarzrsg1314fzz5g7glhvb1"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.11"; sha256 = "1jy8h6w6sd17l1fxh21lvrkqacj8484ymrhahiy2jjmg5axm5raa"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.11"; sha256 = "000398ffbw1am6l2jx717ny4qmf2zfpl1f8rm6mdbgghyb8if6dh"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.11"; sha256 = "08hhz84pmvnglr51vdv51h3cbw2qf6n14kq3bvwhrlhpngqs62ni"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.11"; sha256 = "0gi160mr13nkdmhk3ihn3pm8hhvll2ychrm9jyc6ii249cccn9rm"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.11"; sha256 = "19mbaafawl665xgw8451cpwcwq11jjr4pkxhm40cqvsnzk22zs9s"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.11"; sha256 = "1aiw9q7kqmwar3w4w5w45l0134xxd46hb4k04ggdzsamn1vg29za"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.11"; sha256 = "1qxb9axrywyblah8g9fcs141dclmj35wksk2izv1k030c5d7cd3y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.11"; sha256 = "0bpy6md1lfzgn5622388rb2pg32i4pvlw1cb8qpqafvms4p5mm3a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.11"; sha256 = "0mb04dsm2z954q6552al84p2ikajm6lrpsrh8gxb1iw1qabyvhlw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.11"; sha256 = "09laias011a3v854zc962lcddjkc3bif3jwsi0blyk6v1m2mf4kl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.11"; sha256 = "13g4jr43f6b83a3jwd76pxkaj71b1sqz1zwq72rk1y24likpshc4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.11"; sha256 = "12a0fqnwsnd6q8vdkdxylrzmmdwn4hfh58j1bdsii1kgm50qwmqp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.11"; sha256 = "1j64ppdvh5s3pqr6sm3sq9bmk3fzj7l4j3bx023zn3dyllibpv68"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.11"; sha256 = "03nn5x4nlj46vgbl2wkxyl6hibn0n2ry0zxxmzbkvs37mbjxk86z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.11"; sha256 = "0fhsjlqg01kxqzdippg1gz93rpd60pgcxl8pxwcgikxgbj7cy8s4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.11"; sha256 = "11pn7rikm8462xgvy92a1lkss68j47bwqik36yki15hyaqybv4ka"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.11"; sha256 = "0i2v135k2f0lbh00x1ximf97737dm81adh3z9w5sbzymqiyi8q3f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.11"; sha256 = "1ksjj7jj8wphcqxkpzmwqkj0mnyk7x4sdfhyanv1a2f3ik603q4d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.11"; sha256 = "0pj9l7fs4hpfdvl7j3c0q21f4cpf7ch2miibga01g82s2rq0vhli"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.11"; sha256 = "0imidlvxriy3yxvgn9pml3gryf025cyspq9wzyicqqaf9b69vahq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.11"; sha256 = "110x61wlvy01pln698dbmr8km1h0savpxs2rji827h3c43lgpp5q"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.11"; sha256 = "16g5vd8j9ykdr10fnbp2bw7ri6z54a1jnl6ymi7b9lc5q34yic0f"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.11"; sha256 = "10pi42nsdyr4phkyf9fyqnq2ycwi9jb8mqs5qfa8qygq44rw8ph5"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.11"; sha256 = "0ds0rlzx5xcny65kfbhgiwk1za9c4zb1pqpz5ij44qpyw4kyp262"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.11"; sha256 = "1npi6kfyhwij9qw43z179hcr2k7cayjlbacc5j8ibwxfr2hay9gr"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.11"; sha256 = "1zw93b8vrf2i2lci6137q4v12qrf30rd14a6964hzc5gyqa6d9ab"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.11"; sha256 = "14scil6kil1rv6hvfkyi980mx47xnkf3m3ms2lkgn3lkgblrnsvm"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.11"; sha256 = "1y7c0km6b2lwpxrba6jjc3pmfwhs27wp6kagir0ai4yccgxw9lwz"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.11"; sha256 = "0i9877kzl4rxlya5df7sb1l3vi2mlyrqim1ww6c1dscb7ii2qyfi"; })
    ];
  };
}
