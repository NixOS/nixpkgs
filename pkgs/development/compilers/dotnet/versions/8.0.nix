{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v8.0 (active)
{
  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.0";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/257bdcc7-cbfd-4680-964a-cbe8e9160bca/ac0cbf19d897ba51ae004b4146940a0a/aspnetcore-runtime-8.0.0-linux-x64.tar.gz";
        sha512  = "c0aa3a926d6c2bc0d4cc14f5d7677a4592111bf3ebefa65c5273c4b979a6e2b5d58305a5aaf4ac78f593b46605ec02f40b610dcbff070b1d8cf8ddc656cac7dc";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/91223e4e-2300-4e8e-9364-09ea1c317294/47fb26a2df5eeee08f77a4d1b720a34a/aspnetcore-runtime-8.0.0-linux-arm64.tar.gz";
        sha512  = "f9e1ae263dd944c70ea1818a3a44bb62aa5bfb65dafa463dc9f9a33bc8ad1c60b4e7a364a7414cc00a01ff707b5e88fc52c520edf0eb357ed1ddf4a8fcd8eae9";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6ef899a5-571a-4fd3-b294-65665d9cc76f/d21cc874f3832a5e0ad583d948d1f228/aspnetcore-runtime-8.0.0-osx-x64.tar.gz";
        sha512  = "1b19d90b631ebd74f6e1f4343ecf54f6f04bc8a2aceebbca66de57d41d440a66c7f56565043c1aaeb77b586dc349914d7d30b8c066197840430d543c24c87539";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0d05d563-f3ce-4d40-8cd8-f28247510533/48ed8322af7e47c2f68fc0afbd65e37b/aspnetcore-runtime-8.0.0-osx-arm64.tar.gz";
        sha512  = "0edb1bd0655d7898d9a02f7127e9a93af7e92e3ea324a7d77e9634b5dfa0851184d784f2573612b18bc37cb0510f93d1b0eaa2ae56b6ca99a16f1edafe6cf8fe";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.0";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/fc4b4447-45f2-4fd2-899a-77eb1aed7792/6fd52c0c61f064ddc7fe7684e841f491/dotnet-runtime-8.0.0-linux-x64.tar.gz";
        sha512  = "16a93af328bcf61775875f4007c23081e2cb7aa8e2fba724aea6a61bc7ecf7466cc368121b08b58ac3b72f68cb67801c68c6505591eb35f18461db856bb08b37";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c879318f-48f3-4cc4-8dcc-a6b77cfdfc38/7890f8a96ea335f5265cd1aa80cac8ce/dotnet-runtime-8.0.0-linux-arm64.tar.gz";
        sha512  = "bb39fed4cff3a1a0a4e5084a517feeacb571700b8114b83b0b040f63f279d32eb9195d9b94cd60f8aa969b84adaad51694a2e26255177a30f40f50f634d29c21";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/65e0ad28-b73d-46ab-b3ae-2d2ae4460b78/50ee103e816a255f9a5331bc2975a6ef/dotnet-runtime-8.0.0-osx-x64.tar.gz";
        sha512  = "a469d4fcbd756861045a2f639f42e7f7296fea3c5cb5bfbe75a9deefae2c5fa1fd658b35fe378e2a4afefcc37d8d874908833728481cc4b18fbd9f6f204d684d";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/65665fae-8f24-4214-89b5-980dbad7be30/1b70f4b76e076b4b656879426e861fbd/dotnet-runtime-8.0.0-osx-arm64.tar.gz";
        sha512  = "5464e6ca9afa89680b71042e200e99c43855a216cfef64ed2cc0b44efe547f7f69e57559ecdc47404e2a8c1c2b0f7d00ebcfc8b949750f0af168eb575e7dc092";
      };
    };
  };

  sdk_8_0 = buildNetSdk {
    version = "8.0.100";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5226a5fa-8c0b-474f-b79a-8984ad7c5beb/3113ccbf789c9fd29972835f0f334b7a/dotnet-sdk-8.0.100-linux-x64.tar.gz";
        sha512  = "13905ea20191e70baeba50b0e9bbe5f752a7c34587878ee104744f9fb453bfe439994d38969722bdae7f60ee047d75dda8636f3ab62659450e9cd4024f38b2a5";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/43e09d57-d0f5-4c92-a75a-b16cfd1983a4/cba02bd4f7c92fb59e22a25573d5a550/dotnet-sdk-8.0.100-linux-arm64.tar.gz";
        sha512  = "3296d2bc15cc433a0ca13c3da83b93a4e1ba00d4f9f626f5addc60e7e398a7acefa7d3df65273f3d0825df9786e029c89457aea1485507b98a4df2a1193cd765";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e59acfc2-5987-43f9-bd03-0cbe446679e1/7db7313c1c99104279a69ccd47d160a1/dotnet-sdk-8.0.100-osx-x64.tar.gz";
        sha512  = "8ab6a1408e630a7f689414ad062191558c363f8fb8a98b6571ed99d386c07951655c6a499f8b8a4b128d4f566b7a67b6e8be26cda751d9286851b603096d0da2";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/2a79b5ad-82a7-4615-a73b-91bf24028471/0e6a5c6d7f8b792a421e3796a93ef0a1/dotnet-sdk-8.0.100-osx-arm64.tar.gz";
        sha512  = "11a307ec17fa11fd8f133d697cd414c12b1d613ef9ec05db813630b10a00cb2ee0f703580688bc59b60c911e97a27eef8ae0d89fc2298c535e0bb15b5b997bc5";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "8.0.0"; sha256 = "0hin09zj8gwvawac0xs7q6pxlki2wk9sf38aklpa7jj2rpiwc54c"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "8.0.0"; sha256 = "05y1xb5fw8lzvb4si77a5qwfwfz1855crqbphrwky6x9llivbhkx"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "8.0.0"; sha256 = "11hrfccb0i7393ddick0rf8p4hwiarby629kvdp24sfcbcwn79g4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "8.0.0"; sha256 = "1aavcj8a90mmpfhnivjaa3khhnyg4zhf7bmga8vrlf41g3f7np5l"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "8.0.0"; sha256 = "18zdbcb2bn7wy1dp14z5jyqiiwr9rkad1lcb158r5ikjfq1rg5iw"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "8.0.0"; sha256 = "1wqkbjd1ywv9w397l7rsb89mijc5n0hv7jq9h09xfz6wn9qsp152"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "8.0.0"; sha256 = "05lk2wdsfj63a61dckzk9p5kfb2a3yilxg2ik9qcnrz8kn6jzr9g"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "8.0.0"; sha256 = "08vlmswmiyp2nxlr9d77716hk7kz7h9x5bl8wh76xzbj5id1xlb2"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "8.0.0"; sha256 = "0bk5dih32knja6j3lw7b7rg1lf0z16lvdj79fcvywrk5di027k1i"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "8.0.0"; sha256 = "0k304yhpm92c46a1fscbzlgvdbhrm9vlbpyfgwp3cafz4f7z7a5y"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "8.0.0"; sha256 = "13w5bn5iz21hf908x35yipkvjp9ni3if7l4ipgyh8nk56rj8q1zf"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "8.0.0"; sha256 = "1nbxzmj6cnccylxis67c54c0ik38ma4rwdvgg6sxd6r04219maqm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "8.0.0"; sha256 = "0l5svjcgkvpj5r4l1xa7jhpqgwr6r8li47yl3j5b8mqqlnisdkjb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "8.0.0"; sha256 = "0bpg3v9dnalz7yh7lsgriw9rnm9jx37mqhhvf7snznb3sfk7rgwb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "8.0.0"; sha256 = "1xsmlbl1k7aj2jcksyz9aaxqwj9cavrikbnpglqw1ghbdwpmyzcj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "8.0.0"; sha256 = "1d7d5k0fwq01fccv0423hfc165v7pm8nskf2fh2zfpfrxf13v7n3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "8.0.0"; sha256 = "1c7l68bm05d94x5wk1y33mnd4v8m196vyprgrzqnh94yrqy6fkf7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "8.0.0"; sha256 = "0jmzf58vv45j0hqlxq8yalpjwi328vp2mjr3h0pdg0qr143iivnr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "8.0.0"; sha256 = "1ys9s7sykhjmgb5a58c2afw6qmhhxybrbinl062hbjcv8xm99362"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "8.0.0"; sha256 = "1n8yr13df2f6jhxpfazs6rxahfqm18fhjvfm16g5d60c3za1hwnk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "8.0.0"; sha256 = "1b899bnr2gvkiqdfygmsxzra1hi5wbbkrwvhlv26jln97i4ybf0r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "8.0.0"; sha256 = "1nsrmh609hk20r950hnyji30incv8jf8sdgdvffgcriawr9b2ax4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "8.0.0"; sha256 = "0gwqmkmr7jy3sjh9gha82amlry41gp8nwswy2iqfw54f28db63n7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "8.0.0"; sha256 = "1d5sd64jaydxxz78k8v3m17dxfqkd0gwzi45isp61504h22haqc1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "8.0.0"; sha256 = "09cv7m2g5sy4zdfycra58qqx6wd1klaknwli6b36v16akkkfadja"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "8.0.0"; sha256 = "042cjvnwrrjs3mw5q8q5kinh0cwkks33i3n1vyifaid2jbr3wlc0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "8.0.0"; sha256 = "1kh5bnaf6h9mr4swcalrp304625frjiw6mlz1052rxwzsdq98a96"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "8.0.0"; sha256 = "00g7pjdnsb7y7a7wh0lszfa6v4lm02l22789cq8q6g9mh79qziii"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "8.0.0"; sha256 = "054icf5jjnwnswrnv1r05x3pfjvacbz6g3dj8caar1zp53k49rkk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "8.0.0"; sha256 = "1gcgnw90g26ihhasqq4dcxbvnh9dmh96jws69dxz5lq7fj1w99q1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "8.0.0"; sha256 = "1fabiw1q86rh6rz040ckmvm7d87dsj135y1kxx1pwksym90vvhx6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "8.0.0"; sha256 = "1f0jkm4dgbvs3kayh580xs34i5fxig6l1sw3hx4ilvh31wmp1wx9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0"; sha256 = "1ikyxx52lq7y9cplqnvcl4a620cgl89h3p85pvfj3hd90990jy05"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0"; sha256 = "1akg7babgmqxjk9gip20ycrlwkclryj9sj9mkm0q66887f1nk3g7"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0"; sha256 = "13p24jmrgh5hv24mxsc9igvmk1rv2g54fn3r39njy0bydwy3fzmz"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0"; sha256 = "0wnh5rmq7ncxabk2hikv57rhn9mg9ri0456dfpap8h46cln8913l"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0"; sha256 = "0cjhznqnvv4dwnn3bnf9jxp2hv1m8szpsmnzgf7ab9c5jw7hjvbb"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0"; sha256 = "1abkipi6c9lz8h3wn588fmnrp4mcwfm3w556jd5x304y159q3vi3"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0"; sha256 = "0zcxjj9p5bzlpbmqavhh1f064bw6nvbjhn4bkzxnkmgqs5p53r95"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0"; sha256 = "16f86g52jzlii95n9a6b7ssz1xnq6pk4rvyhi7c7swz31ddf7km8"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0"; sha256 = "007vg4b0bxl34xg1vm25168lsprn7dvjmz8sjg1w59wacy9cnq68"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0"; sha256 = "1m6hifjaw0r7qwwn5x4gj8swbfgr9zx9apgdr0z6qgs8s4bam7lr"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0"; sha256 = "01rc7adfbjjs09wws1svqrmkmp2knh3dnp3asvav9g978g1f2w95"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0"; sha256 = "0dw47mhqz9x7rwsqarv2nh6g661nkg406r97zy3hbq8s27ygpbn6"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0"; sha256 = "1f7qnfnga1q8rmfrxi53h8w7908jiai4sy8jqx61j87fkzz0ydir"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0"; sha256 = "1c7jas5dw9s40c3i1g6wsnc8nvirshlh483gka0898cr23csdx5a"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0"; sha256 = "1j3dpb8q2cldjsrj5p8nl6nw7jrjdx5iskf7gys9pnfwgrwj8fvm"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0"; sha256 = "0ls3zb7vdshvd9sv9jz343lh509zd88dixpnv7xh2srx1i5f4w3z"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0"; sha256 = "0r708jv7xfzg548n0kn73hxzf256lgw4ifbbjp87yxrh7lmrhsw8"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0"; sha256 = "1c22479vf6yqpkryvqqvr7wbdybfmjpl7fw3jrvyvpfhbwbp0hsr"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0"; sha256 = "1jcvq18zvisbkmrr7pwlr52z9q41sjq6xnkm5iznzmbndr2f2qw3"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0"; sha256 = "1yyp5d7q2c8x48wpq0qbvy6rmy4jkkq5xskfdxrsmsp2ccyjvhfh"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0"; sha256 = "0y7jy6cm8y5fzr61w79rfp4kqpsj9j66ip1i5b39w8gcj1hdnbpi"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0"; sha256 = "1c4hnkn1yjib9n6phsp6kc0vmbsxr4lh8vc2cdcjiz1rf7qk7ps9"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0"; sha256 = "1002nc2hrmjiczcqxbxv18ayaq20680rvcjd4ragl7pdyz68ss4g"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0"; sha256 = "1dj8y4bqks2dzvcly9vqsccgv05lc8zqb8ds30jfniff8ginw63j"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0"; sha256 = "1kvq5ldmz2n3nd9l3wdkdmy34sglx52b94q045z7h8qigkx1p96l"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0"; sha256 = "077903pz31kv8v93930xn7wjsiq3kfddv9slb2qr0gww9cakzzw3"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0"; sha256 = "0xm7jpwbrykrs4ss22ayin7fyb5q8f3wl1ja1cgb4lgvxbhsqmmr"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0"; sha256 = "1wwipsqwk5f7vqr4hrc4jv1hbybmwab5s295n6zwk7kycrmamah7"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0"; sha256 = "0mpbbp4ff5643d1z2m5s0jy7p2gcndls0pdmyn23ind1diacq847"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0"; sha256 = "1a540y4m49bk1733bgflp92413aphzvjy016q3131m6lx5za3xjy"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0"; sha256 = "0v7l2a2qbn1m0lncc8343fpcnkjqgs1zp3sk8yv8dr1izr7wsrz0"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0"; sha256 = "17fz1jnwybsa61p9fq97q09lf3b50lw5lbmjig44b8c0a4jg3s52"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0"; sha256 = "1f5fjsk5a8p9i0hlsy7pnn93k2qlsqhxz0vsm67lg5jd14xj31ab"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0"; sha256 = "0vx4saxa314hiwfgd7i8zwzs4rzq1l4zr0mq1vjqfr44aq9wnly2"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0"; sha256 = "0v37lgyi9piclgm52p66s6vy2jj6vjn4bdv6saqyln0dag09k9ps"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "8.0.0"; sha256 = "0ygbym1pp0mwsd2kdwq5q2klgn18c1dpdi7ia33g8n42c4506ac9"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0"; sha256 = "1zvm2l4nn9xp10xphp546phn5c2dc7fr8lyl54zi5kwym0917wc4"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0"; sha256 = "1mq9f79q6g5f2d52s7c00gf6fsm66rhzrg43j8vq2dhbkariii34"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "8.0.0"; sha256 = "11w0bxmb49flpi4zf33piqvw131ijxly3vc50w1g291bijkp5vbz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "8.0.0"; sha256 = "1hdv825s964vfcgnk94pzhgxnj948f1vdj423jjxpkppcy30fl0m"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "8.0.0"; sha256 = "0hm5si498x513d4ch2dpvb3a8qxwwrqk6s6m9bmzh3ibz3a6myld"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "8.0.0"; sha256 = "06ndp4wh1cap01dql3nixka4g56bf6ipmqys7xaxvg4xisf79x8d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "8.0.0"; sha256 = "0hyvbh86433764qqqhw9i7ga0ax7bbdmzh77jw58pq0ggm41cff9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "8.0.0"; sha256 = "09rqlw40ampi9gyngnf421hq40ib73hsdskqgf4k7dz5slk6mhmr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "8.0.0"; sha256 = "0znkp1zzdahkks6x3bzh63gzgpy59am0h9m70l1ck66sg1mz24jk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "8.0.0"; sha256 = "1qhmj2h05ykmxjs55zv338vq8w6lfqa14qg9qkkfgghk5j4dhq39"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "8.0.0"; sha256 = "1vs9zs72bmqhfjg9hd131i1bg34nb3bpvdkgjlgdk3v35hhnirx6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "8.0.0"; sha256 = "18y043hh5z80jswwiq15mnxbd9p4vck49qgsrbxpym834nzx610b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "8.0.0"; sha256 = "0nzp987irc2vczfdzrzckz8k9rrgbcmz364b9d8g01vy80a95xx6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "8.0.0"; sha256 = "12q0lvpywylxhy03rhs1ala33vy3li4z85jswm8ykaa3xf0jvsmq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "8.0.0"; sha256 = "1cqh2ikcb2897qp452m74dz5jrwmzl0zh9cflmnchjdgd7d6s56z"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0"; sha256 = "1dzc58bbiaq5d45yv6340rbfacy662jnam008w6n50qc659clldj"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0"; sha256 = "02b4hsvifa78zhmwb1pqs4r3p85irx7y6a370fgdsp5dz46isndr"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0"; sha256 = "0r7zvjam59k4y9dgsvxx9nayw71907w91fzcnjgf06m4wal0db5k"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0"; sha256 = "0riynx7ik2fzv00p4j5v2iwd9c9ka5avnk607i852rqq74m2rs99"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0"; sha256 = "1m5fb4iflvmrmbvippf3g8sxrdi4vcx57nqg7yxfilfh85b5l5y0"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0"; sha256 = "1b6s0wmx05a2lv3lzzncgqrgaxmsa14l54q47na4v43v8y7xq6vp"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0"; sha256 = "0vhpabr647gckmys9j4r517qpy4i11bji1ckzig01jkcvafiqsj2"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0"; sha256 = "086228mvlrbb3yl6g3ksv5kwnk9lx17ghiiiw22gp42ik3sk8kz0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "8.0.0"; sha256 = "1jlzrgkvw8qj4crbnr868gl974p46rxgf3285sxzdjki2p7ka3vp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "8.0.0"; sha256 = "0qax7ipklhqr2633xdscsq834g87vcza8h0abkr23zr8v6n2hisc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "8.0.0"; sha256 = "0qr705fs09xilsz4wid0djs5nnv2dwpzvkzm9r2368gwfw5fld4r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "8.0.0"; sha256 = "0d7z88ram53vm1235pmd3srdv602jmvbvkvg22sfj7gl5p4gwys8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "8.0.0"; sha256 = "07r3lk3srs47l0nz0gn4q961scfvg7qkpal5ir51bibrsx586ag5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "8.0.0"; sha256 = "0s2h1bcd81bxpyizym3z4lcy5r6772wl1qrb68b26xdgc40kdb26"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "8.0.0"; sha256 = "11cr30w7xi6wclbaln6w5yvrxxg3pg6m2k0pqgwb1j1ngkwc34gd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "8.0.0"; sha256 = "139ibxcvv0jym0idinq1fi2fjgv73iqpa6ymf9626vip42wwya5f"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0"; sha256 = "0v41gb69hd3sp3rikn5g827623a6n0iqs72y0vab4wbch223418l"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0"; sha256 = "1chz2z24284kg4cxkvvxp2wniamrlil7gcybr5kqnzkx6vx6iy2a"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0"; sha256 = "0qd3ms6x4fq3map00r05z3q7l6y0a8q8ncn0ca72yadcpampcwbr"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0"; sha256 = "0jd728r48bl9kv2w1i13jcm2ff4xzsk1lzk62skb79p80kba1isk"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0"; sha256 = "16jjak8m3r3myxxik1m1fgwxiway15z4prifsnxcs5aq18srdqkr"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0"; sha256 = "1jqdms2c4qxsyqrql7sk46mkrnh4ydqbknxc1d8zklyr39blrss9"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0"; sha256 = "0mphkkdq7nmkb5gjad7z1yfgi84mwkd79wmnzsl9z5xxgn03qhgw"; })
    ];
  };
}
