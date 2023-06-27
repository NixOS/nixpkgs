{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v7.0 (active)
{
  aspnetcore_7_0 = buildAspNetCore {
    version = "7.0.8";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f452e148-b4ef-4ca7-9d97-59b709c55221/852e848f9fbd345445a0de43efa4e7ec/aspnetcore-runtime-7.0.8-linux-x64.tar.gz";
        sha512  = "b75cb42ecd1936b1b2af5ed59d7f3ef3eb0a602b23f5a272e62c42de9c75db1ae54878b2f9f28d72dac15bdbeaece81cc6344d0df5eae845bc130534ef1bfbb0";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/04dc0f8d-880d-4722-bd51-6669e6cd1e72/cd5689508f2da5395bc70473018ff165/aspnetcore-runtime-7.0.8-linux-arm64.tar.gz";
        sha512  = "ce521f56d95c39be6b8428086fb4e0b13ec49b08431bee151a625aeb2366622e6c688abc79b76810bf5c17a8547b894d5ae57539e15ddb3bfbb0e11022c995ea";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/755a7169-d77c-42e1-a1a5-1eea4213675d/1375f947547134e9297aba032c3760b5/aspnetcore-runtime-7.0.8-osx-x64.tar.gz";
        sha512  = "46d4e2f36240efa316c15992646d8b93d6750b987aa6bde88529e50c9cbfa69f250148ed6dfbda93c28664c555bda62fac7182a76e8ddddfa1962716169ac152";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/787adeb9-d6c1-4db3-8c72-63653dd939c4/a7aafd0908cf7866c6908a14a78ac994/aspnetcore-runtime-7.0.8-osx-arm64.tar.gz";
        sha512  = "31b9806f7c3d327008fe505dbd627bcccebcc7db7179b7010ac814844782d054975cb4c1a35f6ae447fbed3227d39def95bc99169032f4fcffd35916896ed4cd";
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
    version = "7.0.8";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c9514df2-f03a-45a3-9a6d-65b2260accd1/0f59516ed5bc603ee95ae91301090ebb/dotnet-runtime-7.0.8-linux-x64.tar.gz";
        sha512  = "50463de25360aba18c29ab8a3d31896793a7bcf899b40249fcac77efab24888e93ac906dac04ea5b72026c89c07dd371247ff89e8613123dead7e889906aa876";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/fc0cbb05-48d1-4f9d-aa78-8f2bf6423f1b/f06a3e717b95abf8ca5f40504cd63dee/dotnet-runtime-7.0.8-linux-arm64.tar.gz";
        sha512  = "92835372558bc9913e81617d0c396a60427fa30eb2dc9249bf73772ee8c221cce7358aaa4cfe5a261849f9b1303225f6052d29187cfbb15cbe3caffbad4fe3dd";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5b7cd80a-49dc-4364-a4e8-a760219548aa/6ba0a83c6da3897dab16ba709acfcc9e/dotnet-runtime-7.0.8-osx-x64.tar.gz";
        sha512  = "e2c01f09a7532d72578dbbc27ea0156b5e0ee0c636eb0503ec34bf4445b0263857063dbd7701a29baa5e74129ec9c7593566f66cb33cccd40ae64ec888d7ba3c";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/11db4f76-fbe9-4692-ba1e-9edd2b5e0eb4/9204a2e30c58c8a01a8a6f7185e6175e/dotnet-runtime-7.0.8-osx-arm64.tar.gz";
        sha512  = "bad440aac7e065c88685de902e5328990d44e60fa8f583d2fcaa38cc9d3cbaf01810cbc40b7cf9275e53f386b59cd88e563f96e907c8b0c0668fa6a905a5eaa4";
      };
    };
  };

  sdk_7_0 = buildNetSdk {
    version = "7.0.305";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/87a55ae3-917d-449e-a4e8-776f82976e91/03380e598c326c2f9465d262c6a88c45/dotnet-sdk-7.0.305-linux-x64.tar.gz";
        sha512  = "c63e6baf3760a9949089d78920531a1140f4f31fffe13069b2011c61c3d583d585f5ec8cca973b414fa35d48ccbfea9c1ec1c88222b53afd2af5974be3b5cb1b";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e2ca71f5-17e9-4dbd-aaf4-1e0fa225a212/61c440dae017c7129de10cfbfe36fd90/dotnet-sdk-7.0.305-linux-arm64.tar.gz";
        sha512  = "451622fe88ed6c6619be6c27f3e9eeee94ae61db3c9a0b8eab7cf1b14a62d41681181748d823a1207ffb6da6e3a098615aa2f59be8e60d403ba4cb98ab267a50";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/42115a70-7082-41db-bffa-b54ba38d3a76/5dc32fb8dbd24f358947e96400792bca/dotnet-sdk-7.0.305-osx-x64.tar.gz";
        sha512  = "27762a9104c5f44c189fad2cf81984369503add9c6cbca604a4e539f9957db81d807981ce23c025a74feac1a978b9d679eda66f4078af2de7e0bad5992177700";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5514f57a-bdd3-4bf8-aeee-9469379dff7b/8b14cea61057408b04bef7cd94123e66/dotnet-sdk-7.0.305-osx-arm64.tar.gz";
        sha512  = "4567aab659a1900d60f2dc07f6c24954b9fc2c49ea54a75c17825d2b9e131860de33bd79195ae529af1df884a25c7e626d7463d13e340ce6e99a74c8ffe60653";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "7.0.8"; sha256 = "0c6m32c18j2xznkszg85kdik3pc5r07yfxiki4l5i0a4y54ypbjp"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "7.0.8"; sha256 = "19r888q35cac4rn6mr4fis0y4k3yvsbm117l7a10qgfdglgirxfq"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "7.0.8"; sha256 = "1nimaxj9f582y0v5ifxcjyhjrv71yl2hqhszpvhgl4js9bj962gk"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "7.0.8"; sha256 = "1val93qfr2hdas1fsz9f2kifyn6g60np0c4k2kw8a5wl8fmw0kfd"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "7.0.8"; sha256 = "1w4x1spgb4x57qn3d1m9a3gyqnwwfk952kaxg8bqrki20a7qkhl4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "7.0.8"; sha256 = "115yh52g223b45mrlfhspm5jlziq4kcaks20dgk596v0k98mzk64"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "7.0.8"; sha256 = "0h4yirhfjsim0qpfh6sh46s6abqilcr2gby4c8aq9zicm8mrilpx"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "7.0.8"; sha256 = "1mgj49vppwmxmsn4pvlfl72y4cljfc6cyl8difbih5ccg6z1a768"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "7.0.8"; sha256 = "1vgl2g9ffppgzac05zacrik9n65y2zr0p09b1ddb31nwkvmw6d9j"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "7.0.8"; sha256 = "07x477l3l96qp8s5l428a9yl709pp2k0j6ims7ih2wlvcv00yrxf"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "7.0.8"; sha256 = "02ha9xmgiqqsa20h349gp1gr0i283mpnw9z5639gmg42f5n9bnjh"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "7.0.8"; sha256 = "0ksdh5vcp7w7cc28cdbw86yxxac2vggl91r84jfc61z0xpry73p7"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "7.0.8"; sha256 = "0wyq9jhqzy5rzczlbi4fr48z5w3s4v63bjzjq2g7m4j04xp4747a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "7.0.8"; sha256 = "1399yd0cjj87i3ihw59dflc3rwlkmlg4562i0fjidj25aidppdm6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "7.0.8"; sha256 = "1a6g0rpc78z0fjs4qmsgk5kjxxik9x0ca6czrl26179y8kxqba3z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "7.0.8"; sha256 = "1i2mw89q809h4swnhmv33p3wh2sskbkgjkilbvrk01ljbrhi0y30"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "7.0.8"; sha256 = "0aw3d5d8hfhk2hsqq776syq6lsqhxcd811zjdyzak7gswbbjgmw5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "7.0.8"; sha256 = "0f7mi7109pjlmwhky3y813zs3c9579s2xgyfc500y7vs9d0780bs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "7.0.8"; sha256 = "1mvh93rq4syp147dz5175dbrbw58lf42hk9mbjinmr6aa1ahxr28"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "7.0.8"; sha256 = "1br7fc155k7blg0xnazgimh9szz49lri4gn8jcwqsjzfclanac6k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "7.0.8"; sha256 = "02qac81akznxacy4v89bmkcxjr9vfa98c40cmagynb6vd60rnzca"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "7.0.8"; sha256 = "1jlprsgya94lv6agy0s4llcffi3cpv59i2m6aha1m2nh6kd1dawh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "7.0.8"; sha256 = "1iygmgc5xrkclkqb0wd7s5ga2as2vy8pnd7j8jdwjnv81m2p778d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "7.0.8"; sha256 = "064n292hxr4w3246vfj45v8k8pxghj4cjh02k7rvpjn6g3nnpwhq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "7.0.8"; sha256 = "0l209jnikhqc1br5gjwv98pzp7h4amsv7341skzixy7lwamay79f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "7.0.8"; sha256 = "1z3n5xw2a8zjvy4w7y6yr1yaig4wdda231yhinkbmhpc80s904sn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "7.0.8"; sha256 = "17rh26xs78pmcf9yc3zi3rxx9k3s5fg35xgqq80fvvp88jg9hr5n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "7.0.8"; sha256 = "0hp2dsjxg2q3wqnrs8mhfna7pyn9yq55n4rqdydyz2v4d6nsp00l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "7.0.8"; sha256 = "0mfgdx7w9l98a1q31mpzcz11p2bxcz5b6ijhrlg3sjkj0wkga7x7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "7.0.8"; sha256 = "02xqwf6dry4hrp7agd9av5jmwb7i66bdkzhdq8ngy73zkk5ap1q1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "7.0.8"; sha256 = "1whmyzs05751yx5708grmgmiv5i6nbfajhfpryx0h5ipb21csp6k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "7.0.8"; sha256 = "1rxy9hah8r2l7bkikj6lp36frfvmvz93v96d12k9s7rgxaqzw3p9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "7.0.8"; sha256 = "0rl96iw2lp62sxzc2f0y58gj57rwwzq4l1sb2pn8wsrxhjmj0w26"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "7.0.8"; sha256 = "0jq12zpbwgnwz9hhr269y74m6c8hli311h9km5jwr75kzwbf9rk8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "7.0.8"; sha256 = "0xplwfghd8mnpmcmvzdrhx78149r3wvsadp3g3k6fvqd2jh6ncky"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.8"; sha256 = "0l5viqkvm2w5p13dcvpnxpb7g5fsn46p8ay59vcpjmr0k9w8bsis"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "7.0.8"; sha256 = "0hgb6c235fbapz8h5w3x0jjqgg9ahj4xd3829bm8ziyrv3kq2nrg"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.8"; sha256 = "07z788q2hn2iwb3x1lxblj243ncwif1955hzv4qga5h5a5j97yfr"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.8"; sha256 = "0g8g5irxlp5wnrrc7gffac33j6azlig8i0fn0088xhm1lliyaj3z"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.8"; sha256 = "1vhgfz5iv0vhn2g970x3zwaa03z7dq63cfv6v6cbrp5l7c640zzd"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.8"; sha256 = "08fs6v4sjws0sq3jpy9p12gxg720fq6lvkggj18b4xqz07fmz055"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.8"; sha256 = "0br6psv8srk3vxy3swj84in7b1qd030j8y6i0lhd0pjvxmjhqk1y"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.8"; sha256 = "11gfspry6l8hnn5mll51p57bdncy72sswcf2544ldig43znawzq4"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.8"; sha256 = "0y25h674gvf07x1yvvh7x381b7qx5nlgk3xxyj4awqn6hr0m6rny"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.8"; sha256 = "01rzsnaq9jd2wajmyp28bbxhx318hrkixd8h3vvy3ymanhd5sp74"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.8"; sha256 = "1lfww3pgg8flfgpqi7vjl736k68b12v5iakc67a9nm4kml4z2gsj"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.8"; sha256 = "02p3nyyz7mm65vmlafyxrpm1pw4wzryj9z5a4zhvzdlwlddncvya"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.8"; sha256 = "099issp7vpm00ild23571g559mszw11d0za6z5g36n7blywhlj2s"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.8"; sha256 = "0zpj8y89qsf2w31api8pj2rjkq5qscvwpr7mwgn2vbh4fl26f63x"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.8"; sha256 = "0rwn6lhx5q7ya451dfnlxla9z83lcz87ccxx509qkkdmz7lx3ia2"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.8"; sha256 = "0n7xwdvacd4dbss1czpwl2z34jyagpkvf1618g59fif0yg29pwv8"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.8"; sha256 = "18a2iycwmailkcq0ygac1cpysx2kvp2pdp5z02r6s9jx3mgjpb37"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.8"; sha256 = "0gky5dr5b8nzh5f60ik3rr6s2wnbwck4rkalyhgbcbyxkkvcffa7"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.8"; sha256 = "0czvd8s0rw7iql4ggwair5wgcvar2sa9rp7m8xcg1bz88dlpswlg"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.8"; sha256 = "16rfmdwqkbmgq286viqmffqd0sm59iw68gf62rw61ab9gdahdfg4"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.8"; sha256 = "1nqvcpl5jrqw6gh32palk8dn02asp2q77ss91v1v14pdxsx6sc1c"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.8"; sha256 = "0bj4wxhdcdlxs5cvdkn6fzqwrry7a9kx3cz7ad744qjhhm01lspl"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.8"; sha256 = "096svf8b1v5ki24072y9bx0mjnr3zmpbivhnpxqbnji571nw0cax"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.8"; sha256 = "1179n7jg0dz7iik5jdpsfrr2jmzpqd95rw19m1vyqb68qbffy54z"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.8"; sha256 = "00wmjvxdasv24jwhzw6dmyv6rdgd0yz6f1h90yz0yfdxrdbzwipi"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.8"; sha256 = "1y8lb60vgiiw7y10qshhm8y7k21q5jz09f8f1sks4p7v987h5l35"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.8"; sha256 = "0nnbvn0rxrcq2lisb0a7mn01lb9xk2ixyj9p1xbfrlzgyarl2xvx"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.8"; sha256 = "1dnn81sa5wrvvdcnnlzg1gf3b5137va8vxfr95lcxd55wh77l71h"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.8"; sha256 = "0lgzbv71lbh8bj0v260nk4qzkiyvn1bm2kz8as0nq6vlnzvvmnxc"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.8"; sha256 = "1yxhvx23mn53s37pyz6q370gp056z2hmqd6n0ns8ayxcrr4yx93r"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.8"; sha256 = "0cf9mx8yk9v2s5hrv1a603sxq0qvd0mxwwi63l9r1g8x7chc432r"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.8"; sha256 = "09ymhv03h8ws8idmdj1yff0j1r3hxzbdz7n0n9gpqqdyfj2zs762"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.8"; sha256 = "00byqz0f7dz1ncywzbjiqw6vsia7ia05927xm5h6ykv2a9l635j5"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.8"; sha256 = "0sy9kn6n7ccx619fyhyafwgh66rmnyv1s2gz5668hywlcwnbbrhx"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.8"; sha256 = "05xim0a1ppzbf7ny6vdfjlrcnh11lqcwydlrdf2l12224kvcmdgm"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.8"; sha256 = "0k46q68yp88hj0gkm6q1m4y08vpl49w2pdis160q5jx11fh2bvwf"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.8"; sha256 = "0jcx69rq6h6jwlz735qr0pynyadz2nshc6s1xpis6hwc7ysgv0ig"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.8"; sha256 = "1prxn6b80nawq8ixqbmdhj6fzsh4mjhhvrkam6r60an38q8pjmqn"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "7.0.8"; sha256 = "1xp91d7pkgcrpwalrfl9z9qa72vxg01kbc1k01d7n88ndpair032"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "7.0.8"; sha256 = "1hl7q1mrp85khz192kqs7lgnhqbl6wv34m2pyj97plm3sqvyfchq"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.8"; sha256 = "1sjrs0sc8f9hdqvg94njn3012bcmz87f90ab5dgalhj8m5in394j"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.8"; sha256 = "1k5xw1imhsrvj0b8s0zbg1gzbr0r3ja0cql81pq73nc2yk4x5559"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "7.0.8"; sha256 = "0sdm16nvckm4xakarnrfb5l075vzbv8vfxz4lk8vy828iqh9sqmd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "7.0.8"; sha256 = "16bs4w9gj09zxjmq94l3526mk277360zj6mwapq5mvpn0q9ll275"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "7.0.8"; sha256 = "1d3idyw795rpmaklhdn181v3pq9b3m1994jakgmvh2b9hpb4s6x6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "7.0.8"; sha256 = "0qx8czk5x0xxx3f6piz4f6nc43j9hkf0i1yidk5pgshk0l5cjgb3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "7.0.8"; sha256 = "0mbj34898p2ci2fcdk90gky9abf1kl8jydqgi6czj87hmk4kfdpf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "7.0.8"; sha256 = "00l3nvqxpjhhnmdp5yzk2mcm83ibbhcm1dlfxfzbc635f4zqmqrs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "7.0.8"; sha256 = "1xcl7sfx3g1zgvj2kwaffh0gqj3cfh641lma25d8mprqw3kms1l0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "7.0.8"; sha256 = "1s9khkkmziz63g48afhqh2dsqx6yvwcca0ai83diz4k8zg0wlwya"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "7.0.8"; sha256 = "0jkxmi3lc5qpgk748mfj9vk5x58j8q60zcrv636xpj06qsm70z6x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "7.0.8"; sha256 = "1dflhc1dfral612bdqxhm8dznyphvnl56ywjjak6s9nsjc4q8h0s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "7.0.8"; sha256 = "1bp114hzsimjhdwyahph8xlp5aji2in6an6da39i6rwg4j52kgbb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "7.0.8"; sha256 = "0sxcmaqrdlvfjwcs7gipyf28r4m93q5059nxjp12pblq4cnsyjpx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "7.0.8"; sha256 = "173ld6nc66l1lc7g2j9xkvp3nf8d2w15g05rx8waiksl4k2q8rai"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "7.0.8"; sha256 = "1rz3m8x5pnn83z503s4smx775bpap1w43c3a7xvqgnhnqi08pqrn"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.8"; sha256 = "0x5rh5y073d2fx3cwbmw1i4rzvyxg8dlgzlny4vy87ycf2qjf2yp"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.8"; sha256 = "0cg54bp7zx4kfiglbdz4kn767vlii55gzgg8dx0m0zpgcbwnnnsb"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.8"; sha256 = "17jrrw8nkvayjfp4yl0ay8sxg7p46vl9hyx8xbn036clbm1g3ykw"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.8"; sha256 = "0fn9jb7kr6y7vhcfzmykgf21kpn6xwfxzc487ynx4rmqvhd24ck1"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.8"; sha256 = "0hb9ia3s9llppjnqbzb8cy1zvdbxx1vxcrrj77bmphhmd7rm0582"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.8"; sha256 = "1zynb95vlr46zra82dshnmizgq46hg2n1gh3rfwdkdfzznqghbpz"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.8"; sha256 = "0s4d61ibgs4hvjipp2kqrqafarh561vr5ynyyfrg3vmq2dxl4dgb"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.8"; sha256 = "183yrnyypy3smrvhl1p7srivirbv82f74qizf3sm3259x6cy7h3p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "7.0.8"; sha256 = "1m028vv06hx4rnjccm0fya0s888dr2n95qy50alajg2yfsjx5z5d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "7.0.8"; sha256 = "0x914n20l9ymszd9zkxfjgkcql8yxpkkywyiqnr47fapnckg9k1s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "7.0.8"; sha256 = "065v85x5n2ml7b0zq5aq0n7w941i226alvywxmlr3npskd4dxf1x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "7.0.8"; sha256 = "04yaar4msmng1kv5irfhk33093x9wy9j886ba6a2b875fv8bccvx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "7.0.8"; sha256 = "1shcpziwrjs8s6w6c8k35ksaynqj50w50mxbaz5x0abx8zm0171w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "7.0.8"; sha256 = "1855g78y2xr55l8wg6g3268bs99v4yky3ablyskbzh9fcd69f12n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "7.0.8"; sha256 = "1z4z1vwfx8lim0k754wn4l6smx2wbfn3izmla32zbp7azf7wz4mf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "7.0.8"; sha256 = "0z636krp140rz3gvd7n2aqvsr9wlg3r05fl1nal81aaplazpjllc"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.8"; sha256 = "108ifhifj7dv0650xciylgnm3y1405mrkfvk21b0bbjva6ng59sx"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.8"; sha256 = "07qljs56khdm4jlh3ack12xx7jp0dxmihdihcnv653bllys1ay9f"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.8"; sha256 = "1lghi90zb4xswp3v03vbb7hbjixr2jq3s1cxhl35qrg5qm1rib5g"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.8"; sha256 = "1yva9fnnrs1cn4n3y0k0ji24nnysg7x0grj54qknf3anv3nsl8z9"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.8"; sha256 = "0ng2ck1na9v25an5b3jwk1ahr5n5habp0sg2fzqdyjms1y1bx7c0"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.8"; sha256 = "03iw2kk1w2bk2jgi76bfw5xq8pjv6fzxac3ll5b3vfxc2b0wn8p6"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.8"; sha256 = "1c9289fprnb4xhf3ayj2rnhmc5z7narrxxfrjfsr8skprkdcidfs"; })
    ];
  };
}
