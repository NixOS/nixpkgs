{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v8.0 (active)
{
  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.2";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d6d79cc3-df2f-4680-96ff-a7198f461139/df025000eaf5beb85d9137274a8c53ea/aspnetcore-runtime-8.0.2-linux-x64.tar.gz";
        sha512  = "c8d4f9ad45cc97570ac607c0d14064da6c1215ef864afd73688ec7470af774f80504a937cbb5aadbb0083250122aae361770d2bca68f30ac7b62b4717bee6fca";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bdfd0216-539e-4dfd-81ea-1b7a77dda929/59a62884bdb8684ef0e4f434eaea0ca3/aspnetcore-runtime-8.0.2-linux-arm64.tar.gz";
        sha512  = "9e5733a0d40705df17a1c96025783fd2544ad344ac98525f9d11947ea6ef632a23b0d2bf536314e4aeda8ae9c0f65b8f8feee184e1a1aabfda30059f59b1b9a6";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a44da2c3-cb74-4ffe-af5a-34286598a885/263f113228e88df3f654510c9092f68b/aspnetcore-runtime-8.0.2-osx-x64.tar.gz";
        sha512  = "a7edf091509305d27275d5d7911c3c61a2546e0d3b5b0fe9fcb9e704daf3c550ea0a5ae659272a29b5e218d02f28b7d331ab0905e9459711624692f1589d7285";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a5692569-6092-4db1-9d5c-4862265a7b5b/7173de926da466e21ab9c7666a31dee3/aspnetcore-runtime-8.0.2-osx-arm64.tar.gz";
        sha512  = "9e79556cf58f9d0b0f302a50ef9724122a9b18daba70e715b7334f9ed97a4983be0386e4132f5273d120f00d18f8af8a8ad7ea1ef0a82c610e268a33e76a30e4";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.2";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/307e4bf7-53c1-4b03-a2e5-379151ab3a04/140e7502609d45dfd83e4750b4bb5178/dotnet-runtime-8.0.2-linux-x64.tar.gz";
        sha512  = "f30f72f55b9e97e36107f920e932477183867726a963ea0d4d151f291981877ba253a7175614c60b386b6a37f9192d97d7402dafdad2529369f512698cb9d1dd";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9de452db-acbe-48eb-b3f0-305a4e48e32a/515bbe7e3e1deef5ab9a4b8123b901ca/dotnet-runtime-8.0.2-linux-arm64.tar.gz";
        sha512  = "12c5f49b7bd63d73cae57949e1520eaebc47732f559f68199ecd3bcca597f2da702352313a20aa100c667ede1d701dc6822f7a4eee9063d1c73d1f451ed832ac";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/414af43f-fdc6-4e8e-bbff-8b544a6627a8/0719a2eafa1d0d5f73ee0a7aae4ce670/dotnet-runtime-8.0.2-osx-x64.tar.gz";
        sha512  = "e8945057f5fdf55994675caeff07ff53ba96324edbfe148ea60f58c883548be59cd1d891552b55ed5a594c1cfa549bd783ce9e25b5467ae48ab3f97590f36003";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c7b73f69-39ca-4d2a-bd02-a72abb3a4fc5/6d68aa25f4576b70fff4925fb4e69c4b/dotnet-runtime-8.0.2-osx-arm64.tar.gz";
        sha512  = "c410f56283f0d51484d26755349a7b62364e2c54650c87dcee6fea0a370fa84b14b4ebc8c5e121e2b3ea4f0ac2880ebe40a43bcb02aa30ce360fd0dbc12fbfbb";
      };
    };
  };

  sdk_8_0 = buildNetSdk {
    version = "8.0.201";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/85bcc525-4e9c-471e-9c1d-96259aa1a315/930833ef34f66fe9ee2643b0ba21621a/dotnet-sdk-8.0.201-linux-x64.tar.gz";
        sha512  = "310cf54f595698435b533931b12f86d49f89d27243cf7c87a5b926e0c676b80e869aa58aaff17b5095536c432f377c67d92bf0ca8941b9d891d4b3879637d488";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3bebb4ec-8bb7-4854-b0a2-064bf50805eb/38e6972473f83f11963245ffd940b396/dotnet-sdk-8.0.201-linux-arm64.tar.gz";
        sha512  = "37e230970cfeffdc3873e42595b79ecdf6bfe266a01ace6953725e69a2b64313ce144bf4d4f861130f61f680ead9b4d8a819dd5543c5470c37bbc13d88a78c80";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b61aa134-3109-4aea-915b-f4ad9fddac27/63f2187933dbefad3ae2df55f3a032d0/dotnet-sdk-8.0.201-osx-x64.tar.gz";
        sha512  = "254e578bae6150f194ec9e7d5cfe8a8cbaf048dedafd78afdb421cb0cae22364d21742eb2d11619a8330974739256d45a5d477483a1f82129acc3d12c6805767";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d89ef89a-8e7e-4e04-b32a-8eb6d32a4409/ff889260b90ff66ec8818dd5619de64c/dotnet-sdk-8.0.201-osx-arm64.tar.gz";
        sha512  = "7457d5413dfee375d9e418707ebd726ff8ca9dbb7c34476e9fe33fd77962fbed5827bcbcc6d7978e918faf58a4e2470456b7383df6c0e47ed3b49d00b563611e";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "8.0.2"; sha256 = "06s21b9k4niwb2qlrz4faccfmqyxfv08vzd85izla3zjxmqv3jxb"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "8.0.2"; sha256 = "1bxsrlsyvia4v3fswxl9pnf9107zwf1n1hlwffyxs0kd5iq7jabr"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "8.0.2"; sha256 = "14yysn896flzsisnc3bhfc98slj2xg3f5jr39m62w2p54km0jcrj"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "8.0.2"; sha256 = "1486lnpn9al764f4q9p2xry38qrk1127m62j5n8ikcx8iazrbkqm"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "8.0.2"; sha256 = "0fh2lvjrl41r1r4q3v9mylr16arb190x4xs0m5nsg6qak93y6pip"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "8.0.2"; sha256 = "0ihhhsypb0f8lffl5lbm4nw0l9cwcv6dgylxbgvs10yfpvpix8av"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "8.0.2"; sha256 = "1pfwb7j3gg62z10k799w2hr8yqmiv9gjvqzw6g72navzk322901s"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "8.0.2"; sha256 = "0anifybcb7yipazd0qsiz6g1kj7liw6qz3lmqhkw3ipbr0zip0vv"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "8.0.2"; sha256 = "0ag84bb4p9w41njyf7yh5h2wgz49qgx1xzhb6q4ls0m03mknp2g6"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "8.0.2"; sha256 = "1iv12b2pdngn9pzd9cx0n7v3q6dsw8c38vx1ypd6fb27qqwrdrr6"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "8.0.2"; sha256 = "1a0zy0sfd4k7pwwk7fkgyd4vph91nfbxhjzvha96ravdh8isxngx"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "8.0.2"; sha256 = "0xfwnqbbzg1xb6zxlms5v1dj3jh46lh6vzfjbqxj55fj87qr73yi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "8.0.2"; sha256 = "1217mw4mw978f2d84h0vf0bbzl55kp8z1n4620rphqh6l4r1gr52"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "8.0.2"; sha256 = "1pi4s9sn64cyvarba1vgb17k92ank7q95xmn7dz9zb1z9n6v19hm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "8.0.2"; sha256 = "13ckd4w7ysa5ay5wmklsnws7hhzw6nnlblhcda7r11m0fjfly6lr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "8.0.2"; sha256 = "0vy2r79sgr6p665943rb44d1m5xv8m6h96rqlr03g6ipk1gzz6xw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "8.0.2"; sha256 = "1kbdpqfq64h3dy2mj90sfi2pjks77fmp74fqkvps35fh3lacb3dq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "8.0.2"; sha256 = "1xlnlp4ckqn0myl5pzsqhmpall1pnbmqhb62rr7m61dy83xhvm6l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "8.0.2"; sha256 = "131kgy0787a38zmb3y002yr1lrnkfc4mk2xmh8jx5pqkl7bp5p67"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "8.0.2"; sha256 = "1p7152v1wyhrxh1mqq29bm06xcfilzngr89cl8kxv5lcars3yc00"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "8.0.2"; sha256 = "0yyix9cypm53b0q6zfw5bqbm18x2s54ns7a1w7apxfzs8cckjfp7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "8.0.2"; sha256 = "0j31y9qwcm76zsxbid52zn4350sbq489pa7znmkzdrxgbcn19dmq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "8.0.2"; sha256 = "1g2n69s8sa9ik9jhkc6xcdjcvghwr5m9glbxr1f22dbj6nw433c4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "8.0.2"; sha256 = "0h148hmzrplhw2cx9yd2jmrw6ilpc9ys98w6jcaphzb7n184y374"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "8.0.2"; sha256 = "1xcfs5yxsxis9hx1dkp5bkhgl0n95ja2ibwwnxmg2agc8134y935"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "8.0.2"; sha256 = "0zvivfiz8lja1k6vcmwswh4lz6ch8x0nlap3x35psfw3p7j51163"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "8.0.2"; sha256 = "0x3fsfkv2gcilhsj31pjgg2vfibq2xvqhprw3hpm4gig4c2qi4fg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "8.0.2"; sha256 = "1w6bads6vyiikbfds95zpw91qmb87a20my67c5pri3q6qqwcny6d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "8.0.2"; sha256 = "1cfd2bq41y3m86528hxlh3cj975rvhj8gigalfxaw5jsv8hw6cdm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "8.0.2"; sha256 = "0s92zdr0midkjk5xip0l3s8md7gcfh4dz81pqz2p7wwhcm29k1hq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "8.0.2"; sha256 = "0c99m8sh056wkk7h3f9bj8l67dxwzwnmz0ix398ff1w1pdpiabcm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "8.0.2"; sha256 = "13l2xa4fxnm6i6kpjwr173hyd61s2ks7sjzp2ah3l1n71wds3vag"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.2"; sha256 = "16qhn61di7gz5a68sc2rg5y2y4293rsbks4rvplyjr68scnba4hb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "8.0.2"; sha256 = "0mz7h7silzjgf6p4f0qk8izvjf0dlppvxjf44f381kkamm6viiqd"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.2"; sha256 = "0bvivl9ffgpsq4rbv8n8ivw9jr8yykbsp8r77n23xjm5vz8fcaks"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.2"; sha256 = "1k6vv7mpa81pjx1v8wd8d7ns3wr3ydql1ihx59s6cfg8fx18j5w9"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.2"; sha256 = "05480dq2mzzfvk9whlz16lq0rs2kzy55d905cl832df6j36yzy9w"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.2"; sha256 = "1gm5yrbyh6h09lsr7izbg7izqiq3nwf7cx4y12hwk63544hprh2j"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.2"; sha256 = "0wqdx4h3isn1la8wbm8mvip0ai3fspvr8q2g2hx04lylpilcwnfy"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.2"; sha256 = "16l4dzmqsjnppl8ra3dz3062na1324zqpibcb9kk6aliayzkwjmp"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.2"; sha256 = "0qzqbpwa79qizj7yzmmk2kr1ibwdg0m104rp2ava2qp8c9mxx1lq"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.2"; sha256 = "10k85lqnczpdnzw43ylkma0iv1wxzqv9x4pfr31zwfb5z5p3m7ja"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.2"; sha256 = "0yd9vf8z1p264411p4y2aka4dnzhjvi7zhxc9dy6yfjwndlqfz03"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.2"; sha256 = "1vhi86iwln4pv2k0v6xfx5rp2vk5l6l4p399rj63wmm928n3v2la"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.2"; sha256 = "0i7l7zw99nfq1s43d4cyhs9p5bx719x0q1fmlkp8am4mwga554kf"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.2"; sha256 = "1ny0hjyip2n9mv0iiv2rpikb3apk4cjhvcdi17xn6vf3m79xxbwi"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.2"; sha256 = "0cllix46qh7lxihkaaxhb3islwn8vqn5lkr4c8c3bynvyblskjvw"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.2"; sha256 = "1f20gw4sq0s8idysdbpgrdh5l8ik3lry0i3nq60km9z9n183svxd"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.2"; sha256 = "0c31vfab355bi27wlz18azpyir9y89nn8dcg43j074whc469q0vx"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.2"; sha256 = "1xmy68m6vslqbl4njllgqscdslqj7xgkgjzpx4pq344mxh6r9agc"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.2"; sha256 = "0s93dmisai8wgjid697rgdx3lw2a0s0krr1gcnaav8jz9dg9i8lc"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.2"; sha256 = "0ikwfn1q8jkvzyx77b8ycm7k7004j2w8zgjzkf8kgyw55gy8xfjm"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.2"; sha256 = "0gcwjjaw1lajqmwaji0x03w24721dczgnqrzqjw5ayjh8ib3dir2"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.2"; sha256 = "1i6wijgpksz81hg01c2pwi06k413x6vni4x8v3y38jyazg7qkfp0"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.2"; sha256 = "0hsby9ssa974cqkcc29xrjrrqmxyhfkkssmmhrrimh46n7sxzqab"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.2"; sha256 = "0vwlfcpvbjhw0qmqnscnin75a5lb5llhzjizcp3nh5mjnkdghd8q"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.2"; sha256 = "00kv6ijg6yway8km36yj7jq9y1p87iw8b8ysga66qv05y4fvjch1"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.2"; sha256 = "05dz9mxc94y59y6ja05zamdp63qfdss831816y28kjjw4v4crz1q"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.2"; sha256 = "0qbm5zgvcwmmqlcj4jaixbw4a1zzyrf8ap81nlqjfdxp03bv9zqa"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.2"; sha256 = "1jsnxh1hgy7jrjhbz4kf6gq2x3smfx071cb2w1fa3a740h3i0f4m"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.2"; sha256 = "1738mc91wy3yn2bf4srs2wxksd864hm565nmll396q6gw97a4df4"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.2"; sha256 = "152jc4v2zxcax55vmd9xrsxq76q4cqpjlgrd1mfszipnngrlrc71"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.2"; sha256 = "1z9fa5ryi23sn163j7jry45f64rxqkgv7v91r04b9cpb4hc1qgym"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.2"; sha256 = "14qz0ypylcwldyjn1ins8syjzbqpmfsy4nfkzri12mfn0626qmn2"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.2"; sha256 = "136ss58j9wpxp6sj81mijlk32l2f6h81rvaq4l7x0s8wb9fzzbb5"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.2"; sha256 = "02562zc9nrkfwikzff7km6mixxb1qf632r60jpzykizgx6w0nrck"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "8.0.2"; sha256 = "1sylbjvrr1jnlgd1215czr3xql2gdqy5h5sz7rnfq31hb1j5nc20"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "8.0.2"; sha256 = "0ia1igli2r5gnli0r0yzqm012l56zrjf1jk42viahlil2ic3i144"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.2"; sha256 = "0h1kydv3dxnd9s32fd68x44jhc2pm79gv44mb7jf4227lr1dcxss"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.2"; sha256 = "1njywfwlq2785yk4b0114nzdb33zsgsmqj5fhpr6ii1crym649hl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "8.0.2"; sha256 = "16lp15z1msadrhiqlwwp0ni9k0slp3am05gqs5bagzwk35mcn27q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "8.0.2"; sha256 = "1v8nngksh0cp51g221bizz52jjpc4rzm1avcy5psl81ywmkwmj93"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "8.0.2"; sha256 = "142s1ricyk351nqg298w5qlzd4scz8pc66x5mw9qh75vcyxsr83f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "8.0.2"; sha256 = "116rkq5ri5dbhp5g7zyc71ml2v92vb5bw5f3nx96llb1pqk74grh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "8.0.2"; sha256 = "1c2n7cfc7b6sjgk84hxppv57sh1n4dy49cmdd16ki1l6yl2f3j9d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "8.0.2"; sha256 = "0c6v2mdfshy5966fl2pfkfhgfs8y1sd0r47lfx7d4igy933dqfga"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "8.0.2"; sha256 = "1g8asdz9f3i0mjyh1mkxzfc6x8x77z0d88fa6irpyhh0w45qfccw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "8.0.2"; sha256 = "14djb55i8nwsr3170b82lr89dqxjghnkkghxxy2sl4d2bxw0bsfa"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "8.0.2"; sha256 = "0h0cc31c1izakpx554kivjqw3s5030a9zy3q4a2apwyj16znv2cw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "8.0.2"; sha256 = "18599d4y8n4y0w489pg7zm4nd4a23iz4zwx317pr5z57b4wrk61k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "8.0.2"; sha256 = "04wvf035rr5kw6bj46ici8353lx5k95slydpm42kv1fcy3slqb4p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "8.0.2"; sha256 = "1adxkh9y3y9cxisrn52c75dmzgfkbnz9aqs2p97ln9qdxxvhzhc2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "8.0.2"; sha256 = "0721kp5l7k25ivi2sdxx12kjpddas5l6y5qjmfw8pjcyximhqn0b"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.2"; sha256 = "1kkjmyhrnghihhfvm3qjrkrjbml2nqv8vyslj0g79pjanaqv3prs"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.2"; sha256 = "1j5qhbgy9d1d89xcgdyjcnww0ziad846nd6x5l8fa109z8wvsnki"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.2"; sha256 = "12n0m0rbxp05ggrkxa9yr6kn46pnn3pc4c22p6kkv5ijyg8nhd74"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.2"; sha256 = "1mhwggjfpwssyzxl2mj3j9017xc8qwnw4xlm2rn96yfgsd1pxfpv"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.2"; sha256 = "1nvis5p0gvymv6sdrmgpgg94sr2w3maskm0c3d8p861wfiwwh0hv"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.2"; sha256 = "1vjrnga6inham84hggkx1kkpx4yn7v7z1xnwxas9lisxd0ych7k1"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.2"; sha256 = "0rrblgydpz3yf5gj9kpjc8b17x739nzr1956pwwyarhvh9y0vqrd"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.2"; sha256 = "0xpsaxi54g0xac80gy5nv7qk5b513ak1s397b36vwg7mivwc4yhh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "8.0.2"; sha256 = "1nm6ibys303xlawqibqygpg1gqc8wm1nxb6pl6vgwmp5w4q02r5h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "8.0.2"; sha256 = "0h6wwlz3mqb8758laczcaq7a0wmnmjf797dh5xwyiq50j1ss1mhw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "8.0.2"; sha256 = "09id8hnx0s4x5qvmvifb6jhkfaxzj53yvhl84pvrr4wv4p6ns7cm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "8.0.2"; sha256 = "0cg7b57fysgw809m77nb9dqr56g48ya6bjlh7x880ih5b76bnlak"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "8.0.2"; sha256 = "1rqr95ix3khc7mbaji520l2vv8vjbrg8zzpv6h1i3p3rdbzjm3l2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "8.0.2"; sha256 = "0kzvyghyj95p2qxidp1g8nx5d9qd7wlchpg1a5dqbpv9skljdn7m"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "8.0.2"; sha256 = "0hmk25bvlpn3sfx4vlvysj2myx4dd8fc2pv3gmhfgb2y01dnswjh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "8.0.2"; sha256 = "1z76l5mpvik3517lcl3qygsfsws4yp37j37sslb4sq7gls4aa0w2"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.2"; sha256 = "1kjlc67bqz7d04ga42l7jm9d3jm773a9i77zc5w7cd591wa8vbbv"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.2"; sha256 = "0bx7jv4q8dapx6fb6dbk1im057qmk43isvzygp5ci6nd07p419qf"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.2"; sha256 = "1nf6m85f10j5qcyk0w18qxd06n79w0jvnifis08shdsq1isz403z"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.2"; sha256 = "0pl0w114qrlb8bv6d4jw1gv29dz2cs86y3r0nj5z2fxd1r30khym"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.2"; sha256 = "05bs32vhcvpd1dbvmk1rgqm2swp4gn5yv4mwfsisa4q5qi2xlaza"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.2"; sha256 = "12q0adp0hakl9qrf4bqzkvfsy4az55im6sm1nv7g3k5q4vwkqh30"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.2"; sha256 = "1k1iwpsranma2mrljfz9yr63pxbv5l9j4n0zmancbsxlhx31m30s"; })
      (fetchNuGet { pname = "Microsoft.NET.ILLink.Tasks"; version = "8.0.2"; sha256 = "1fd7ws4qf0354np3lvd735p5r1mdj3zy6gbmv5fzz5cx2bdlplwy"; })
    ];
  };
}
