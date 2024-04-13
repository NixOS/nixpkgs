{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v9.0 (preview)

let
  packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "9.0.0-preview.3.24172.13"; sha256 = "0pai088i88l385bsrdzd6923bq6x56xy3h322592ba9r7rydgms4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "9.0.0-preview.3.24172.13"; sha256 = "0v7n800fkri8mjz5n9781f8461f9ddyyq710nrmmkn24prvzq1yq"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-preview.3.24172.13"; sha256 = "0j5yl5b6fl2kgw5s1gxfmar675igp6ba6pd1sa4rphh6w4a0v3g9"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "9.0.0-preview.3.24172.13"; sha256 = "006mjp2h1wj181zkqrswa0ngnvr1crghd8ykm3wq1np3gn5k46lz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "9.0.0-preview.3.24172.13"; sha256 = "0iz1r7gxa53jh5x1frldcrqnqks9lzaq6ckbwl44bnb3yr99nw5b"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "9.0.0-preview.3.24172.13"; sha256 = "0739nh4j3g2hiqsjisqbzibav6r66z00lw1saiabg3qp70j50dl9"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "9.0.0-preview.3.24172.13"; sha256 = "1mgx83nav4bkjmv7g2gnkij9hys0ly1rmnv5xax2d3nc9hbws3mp"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "9.0.0-preview.3.24172.13"; sha256 = "0xklwl6bysr4innh3jzbl59yvz2n9nrm4sld1w51njw06amm54hm"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "9.0.0-preview.3.24172.13"; sha256 = "18pnmdwkjf5fv8bsxkzhr2s7sk09c9ssqa95pz1dkmfpk3j5q65w"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "9.0.0-preview.3.24172.13"; sha256 = "0vpd8ylh94nvnh6h183m2qbp6p8ildi2y2vkn072xzssa66w756q"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "9.0.0-preview.3.24172.13"; sha256 = "1a2l20k1s9jy1zgx2nd2hfy71vkf2ys9zrgfdypr2sdmrs1wkc14"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "9.0.0-preview.3.24172.13"; sha256 = "1nb4mfzml1s02299x6py648swbdk7db22if0npvh9rxxanwy7hvm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "9.0.0-preview.3.24172.9"; sha256 = "1jwlg9x50x4b92jk089y62ymn7i2nhxw9m9h5igkhhkcwq9bqclr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "9.0.0-preview.3.24172.9"; sha256 = "1gljxawnw72636di27vvqdhjsz1agd9cb8y801wrcq0isxzwmayr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "9.0.0-preview.3.24172.9"; sha256 = "1l8js77x1wfiziw8l3vlsa4c95z3zs8mwjrw09pxqkq0n3wxfifj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "9.0.0-preview.3.24172.9"; sha256 = "1cizxsyv7gp04gr302bhsv99jl4f6cp2w6kjhr23i0iw6c0lzv4h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "9.0.0-preview.3.24172.9"; sha256 = "1wsf8zvn0vasl2jjw27kxc610pm44p6a54i17bmypnxwjs2mmbz9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "9.0.0-preview.3.24172.9"; sha256 = "060xrlmzjimvqnq24rl4nmbq0qlnhc22dmwlk56iqawprnsy2c14"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "9.0.0-preview.3.24172.9"; sha256 = "0q2cd6h55kgh5khsw4rfhxf85473knsxq2mx0zdfz3hdwi59hgbx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "9.0.0-preview.3.24172.9"; sha256 = "1lhvilkvjamv7pqvjn14y394w5i7nlx239869a5nx1zjnsmvvdjj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "9.0.0-preview.3.24172.9"; sha256 = "0pxl0zjsvacrqkcx3bsvkxplxd3wdh0f4871y9kcm4w10hh63fjm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "9.0.0-preview.3.24172.9"; sha256 = "1z648rfs74b6k4qidq1i03hjd3hrf15kcmrkrqpp7dbp5i86vw5l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "9.0.0-preview.3.24172.9"; sha256 = "0hw6y899ngzwgidx005jmzdskgpdd2cz0wia96y9krsccam4nmhm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-preview.3.24172.9"; sha256 = "0b1lywwnhz632v3f6pw9x26ab2ny706lhjr87drc6plxz9k7l9l3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "9.0.0-preview.3.24172.9"; sha256 = "1vng23hpr1csjg28lq0kw366qjy3p6pbnjmyxrbvx8q2cgyq7bhj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "9.0.0-preview.3.24172.9"; sha256 = "0zl2cy4k7c3ncarfl43kpmz2hb6h54psskxcaba9961vdr55ih4q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "9.0.0-preview.3.24172.9"; sha256 = "0nmg8044ahlxblang51id6q2pyxz88fkdvj0cl8q0h5jm0ka75v4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "9.0.0-preview.3.24172.9"; sha256 = "1npm0j01sq5lnx0md9gjdyfh3pmnxc83diadwzab641bcjx8097c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "9.0.0-preview.3.24172.9"; sha256 = "13qb9jx3xqcp63ybqgxr3lml5xanzcbr0nlljb600dx56xkph7qy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "9.0.0-preview.3.24172.9"; sha256 = "17i8zqzqzff9vwfsy3w4163rygknhr0v6gnsl3vr7wxpmw2wwpks"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.3.24172.9"; sha256 = "18j4rns23fv1xajyjc7w1j7hazn3v2a9xhfm7gkkxsdv7s0a2gql"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.3.24172.9"; sha256 = "12bdz1x6pncjm7fhlr8101xp53k5yd4c9lhkjnjvhxsj7qdb83f4"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.3.24172.9"; sha256 = "1p9ahhal1aphf1mvq098wxca6qq89zwjm237df5xcdmiy5dlrjsr"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.3.24172.9"; sha256 = "0sxq3zidqmi9s6qp3sncw8w728hbjsjsfksih3jwiz0lkpa8whrr"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.3.24172.9"; sha256 = "0l5la4w0n78j8824dbsc7ahp4jcakf8m0akb7wm5a3951rq6bh8l"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.3.24172.9"; sha256 = "1i89clhbl21q7q6cwq3fwhgqycy3i9872kl95w4mhgqcld0jn4ba"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.3.24172.9"; sha256 = "17f4ra5l172xb9xbcqcvh7ks3wsqzhx6pzhdkkm96rpwjwyc1yr5"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.3.24172.9"; sha256 = "120yqzrbm2q3n776viw83a24xp3yz8yrv86kg70w1nf2apia8f9d"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.3.24172.9"; sha256 = "1bj6135zkpg6m5q5irshryrr46inmz304d4l4xgwh3czzx9s5116"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.3.24172.9"; sha256 = "0h2an8i9y0m9c26mzsfy3f2dff73m4zfl3ari4n7jnsphagpxkaj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "9.0.0-preview.3.24172.9"; sha256 = "01pd3vdwvwdksmcna7qwi3vam002s6f121gifg3zzhfjx178lk2v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "9.0.0-preview.3.24172.9"; sha256 = "1yapq50dvlfgkhj10wp3xpmvp2qscp5d1jx6lgsy1yh1hidcd9h0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "9.0.0-preview.3.24172.9"; sha256 = "11dwvdqzdcp9xxjb39vrb2z7ysk37nnava62mpdw61zknajwcsgq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "9.0.0-preview.3.24172.9"; sha256 = "1jb0yr0zag4gn4x589kr3hg91x5w1b68a15y3l8znf7x4vx867gg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "9.0.0-preview.3.24172.9"; sha256 = "0vq7w1yncm8mj23sj51rpid5ddf9gilqp7qpa2pkibkikpbr37ps"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "9.0.0-preview.3.24172.9"; sha256 = "1jipca63j5p2npmzdhzyamw2z29qx22q66bhdwh10pny33s7wglz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "9.0.0-preview.3.24172.9"; sha256 = "13i6r7jn75nqxm88cylj8sr2n8xddhbvk4dwlf3nqclhi7dn1ci5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "9.0.0-preview.3.24172.9"; sha256 = "0ksv926c9rbrcsn0a1kgmrppn1v57vg88wmk3pcz8zz112g8na8f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "9.0.0-preview.3.24172.9"; sha256 = "0m9sbl39ana52r6wl50lddmgn14rikvk51rppnh7iyng5a35j1cm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "9.0.0-preview.3.24172.9"; sha256 = "05djlh2w0kaf36mwffrdrdyajvkm5br63638nxsn992qh07q9npw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "9.0.0-preview.3.24172.9"; sha256 = "0201fz1a92hb9f1mgr98r8z5wpf0gqxypblcgxprkg0rnrc2dmfl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "9.0.0-preview.3.24172.9"; sha256 = "18drgl95ibl9ij6d84ms8h79vzsqwzimkkqw31lfxryyk4dqffsg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "9.0.0-preview.3.24172.9"; sha256 = "1dcdqfrizbv6l53irib0ym1v8msfz4ljx008ppcm24jwxav31piy"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.3.24172.9"; sha256 = "1gv21j8v4nvm028w6nxa9s3j9i4xglp74qdrci6q86dra0yh9xpf"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.3.24172.9"; sha256 = "0n1y69d8gfwybs1ylkiqw4ly335i9a287zji5xrlk3g8fpmvr5r3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "9.0.0-preview.3.24172.9"; sha256 = "0b47bqsrxk8lani3njygaip9kqnm9amxr6f4xhjzgikzfn22vcgs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "9.0.0-preview.3.24172.9"; sha256 = "1byqa9dkv6b2i6m9yp2a23lvs8dqf7s5l644kwclhc59l4dz0lwm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "9.0.0-preview.3.24172.9"; sha256 = "1pw07j4sg9kim300dbzayiaw9hxf399dqb6hkqsbyck1d1kcxa6b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "9.0.0-preview.3.24172.9"; sha256 = "06wjbsqz2yi7zgwx9nb620f4bna25xq7jc35l5hbrds18f0id6yn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "9.0.0-preview.3.24172.9"; sha256 = "19pickfd7qbw1nb8vr2xdxpd3980089g542anby9nra43rs8p7rd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "9.0.0-preview.3.24172.9"; sha256 = "0swvmppmy8azxvzr0060k6b99mkrkp09gh6im7q4klvhykfdi7lr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "9.0.0-preview.3.24172.9"; sha256 = "01x8nfdg9ss5k1i5m1k7g3yqwwhv5bphkql0nc3p5xxb4lggwh7m"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "9.0.0-preview.3.24172.9"; sha256 = "1s85zwrr931p6y5c2rmn6gyb1626zsijpvzr3mrfxyiplkjjj0dy"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.3.24172.9"; sha256 = "05dx721hginid24zybda8fw4ygyp979fwvzxlrih54wjmg0dbqjf"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.3.24172.9"; sha256 = "06qgxkyn3dzyjxd29zzdhifrlwjscqjj55b9mhh0k69lrs52h71m"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.3.24172.9"; sha256 = "1jxp08ccvyyrhz20zxi0mf9pnqnjjn35fad27kzhq0hahnl0plp8"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.3.24172.9"; sha256 = "0m3mgcrz0cmqkj75j50r4lmc5a1nivhmd65y4a51pi1w01v59qdl"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.3.24172.9"; sha256 = "1rx9a7kg6ar6qafdw8mr3sqsgcb0pjalfw5h8qwhrawr3k132qwi"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.3.24172.9"; sha256 = "1bc2gx20cmbwyrajcc4k8f5lqkxiynfl4xpgv1253h9g264swfvb"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.3.24172.9"; sha256 = "0y16dkd1px0ghn6rrkz051vihqnk3l0kbsxibl0zzx2ncw91dya1"; })
      (fetchNuGet { pname = "Microsoft.NET.ILLink.Tasks"; version = "9.0.0-preview.3.24172.9"; sha256 = "1420s56kjv4ck7gs78ra1dadrmigdcv4n3nnkap9ajn1ynq7x5q3"; })
  ];
in rec {
  release_9_0 = "9.0.0-preview.3";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.0-preview.3.24172.13";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/37747dcd-c967-4c91-8928-959b32b706bc/2cb1cf0735fcea5d7eadda52bd5a6cc2/aspnetcore-runtime-9.0.0-preview.3.24172.13-linux-x64.tar.gz";
        sha512  = "319f2700c3a954a1e6e0dd01b45c18dfe7d3728fe175b82cbdbdd928c2f64c5fc6f53b7c44f753cf59fb7c32649fab95f0245e5077ae3f607b8f59b5e9cd417d";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b7eb8865-5ff1-493d-b2f2-add90226b29d/901cff3eca56382d9bd7ca0f7e0087e7/aspnetcore-runtime-9.0.0-preview.3.24172.13-linux-arm64.tar.gz";
        sha512  = "e484d1530bb8462f5956d50b0055407a5b697f176f43a8e97b26d80c0507f9373b950f962a5144f7876e4c699b2fd29a63eeda71b090fb80c4885750d73cc42a";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0b4dddc0-6afc-47c6-a878-4ef939e4f46e/70f229cbcc2f968e7dd3cf53bc7132be/aspnetcore-runtime-9.0.0-preview.3.24172.13-osx-x64.tar.gz";
        sha512  = "6f2f4b7ad18311259864f1fe2b2ab4b78e60e035213951eed77f9fcd41488bd9f1a6360bad348af130e3984cffb7e7d7b16406c5ae2bdbd4e75a6eb28924cb68";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5b68ce5e-aea0-47de-bdfd-5a0eb0e9b1a8/67b0d4863b14455f45b2ff1a916bcd6c/aspnetcore-runtime-9.0.0-preview.3.24172.13-osx-arm64.tar.gz";
        sha512  = "c216b72b3ed028cc49ac5e6c50612b77eaadb7834e21a4ef89bce346c7eb1e55bcaced48131ba68ed00d381ea0321501e9b9a0cddff088dd6ff96d5b04be6e6c";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.0-preview.3.24172.9";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/28946a74-4cba-4b0d-a080-3c84b4be668e/651cbebe71762ec64bf342805e48e85f/dotnet-runtime-9.0.0-preview.3.24172.9-linux-x64.tar.gz";
        sha512  = "244963004ced27054eb1c5473adfa7a0e249cca4def0305e81136e39d00319e5be2c77f687034df7e1f026bf92321332d8904ce93851e215e9c213da105d37db";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/41f0b5d2-d224-49ef-baba-d4f75e495f17/dbd1b290ff250e51fd5daa4f639c8e8e/dotnet-runtime-9.0.0-preview.3.24172.9-linux-arm64.tar.gz";
        sha512  = "3f8bd80a03a63019d0c2038119a0bccfa5b1b700fc7c22565bff2e0af425fc0ca475c13b03a666aca2f954db9e53d7505db9cf984482d4a6be1d8019986324ab";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3b5e0ed2-6c44-4e1d-a790-0a9b6a9cdc59/af989e13e8da69501c6ae95b9d12a1a1/dotnet-runtime-9.0.0-preview.3.24172.9-osx-x64.tar.gz";
        sha512  = "873078a50675fa576df27867231b37c7a09511893bb2f7c91f4cc1069e88ac4b6fa7c4eb439b6b39ba2522b7a3e2d2cc9fbec4e700e49402672e6358fdeaaf07";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f2a01607-d9fc-45eb-87d9-190f178f1945/2655017d0a043d97dfe292fc4e986ef0/dotnet-runtime-9.0.0-preview.3.24172.9-osx-arm64.tar.gz";
        sha512  = "20ac79faf78b8e95e73778ab8f8c238aa282d2a6ab844406968f68e946a4a8258e8f01458794a4c77ebf7c0a1e9dcc76169ecc84dabcd1fe983209f968367887";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.100-preview.3.24204.13";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/34c1f43d-2d16-4a44-870d-1e333148e4fd/10ee0406a349070f4e120fdef056216f/dotnet-sdk-9.0.100-preview.3.24204.13-linux-x64.tar.gz";
        sha512  = "7f487d92ee3b28061ef28e013295ebdf6703721b5e2e55ae2d7b18f1ff4fa4e3e01b6a8b508723ffb22dbc8437f0693d7c07f4dd8ef113d5da8a51b3645b3422";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/793717c7-d418-4972-b9f1-1df9bc7f9a59/f37654f223b95c31b5baa92599b72118/dotnet-sdk-9.0.100-preview.3.24204.13-linux-arm64.tar.gz";
        sha512  = "83c6fc2cdb8aba6d72661f2fc360147482dda7c22b69b3f0df9912efe7e0499f3c7b1d1a8577b3667ec3faf6cca99bfa887c663904847356c93e6f1e6f9917b9";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f11c0612-bf78-41ae-836b-2b3c8765fdfb/feac36e69a3ca718c3c0d12dec3661b5/dotnet-sdk-9.0.100-preview.3.24204.13-osx-x64.tar.gz";
        sha512  = "1c0d5a8751f36b4e2f0d2971600a6f870155dd12e0a0669951d99b1d50b8021c51a5c9df447ecd8bb53c3ceaa6f4467edc0eb357bcc8d26e272b5ea121f170f7";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0872ec6f-0e73-4caf-8381-c8004cf508a9/009b50364d70ddb4f892392593659d86/dotnet-sdk-9.0.100-preview.3.24204.13-osx-arm64.tar.gz";
        sha512  = "69452e7266bbccebc7acb9cec7b328f8fa1bca4b0720a27450b67c19d41ac9e8b5ca23f3da762c37769dadd0c65fcb1068b32c98b507d19cb9c5619b301f6860";
      };
    };
    inherit packages;
  };

  sdk_9_0 = sdk_9_0_1xx;
}
