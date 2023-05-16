{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v6.0 (active)
{
  aspnetcore_6_0 = buildAspNetCore {
<<<<<<< HEAD
    version = "6.0.21";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/56d44b17-03c2-4d9e-bdbc-a598ca34fc01/8fcc1e19dfd3c86b09beb68460db6e85/aspnetcore-runtime-6.0.21-linux-x64.tar.gz";
        sha512  = "3a74b52e340653822ad5120ec87e00e4bc0217e8ce71020ad9c4a0903b87d221b538c3841949be2ca129a45f8105def0ea5152e44e7cef8858958ae04fa0dd65";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1f8d7d02-581b-42f8-b74a-bf523099ab5c/29da812824f1a8cdfbe452aa5bc0ebc3/aspnetcore-runtime-6.0.21-linux-arm64.tar.gz";
        sha512  = "3d39f458831c2e2167c06eb85205a764e9aa497ccc26cb19968f03cb3102daaafde391a707f08c3010bff95cfc0e9586ea97c0fe7d8ef885b4aae009748591c8";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4eece21f-af5c-4bdd-8e5b-5e300f0cbc6d/5290c217803341cb2a51628e8ea0dd9e/aspnetcore-runtime-6.0.21-osx-x64.tar.gz";
        sha512  = "b7d604bc11224b32960f11ed2332cfe5cd595655dad5c2cae1fba40e73ec637f9f6e4246659296d90f544d7aa7c5248b0c7999cf82b4a325acef7368416c1dde";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a6bf9946-7321-452d-8dfb-120ea0911a6a/9d77b20bb6802d0e8a4cdeda58fddaee/aspnetcore-runtime-6.0.21-osx-arm64.tar.gz";
        sha512  = "bd1cf2252d61ab88e39d7cf6e7b57168363f599de7e2aafafa9f2373976c97653e83cbfff5d1708276b6503f8a21f60af8c8601835c4d6e0b603b3c4bb90902f";
=======
    version = "6.0.16";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/877a2d48-74ed-484b-85a1-605078f5e718/752ce1e38b76ffb5ebfc2ee1772307bf/aspnetcore-runtime-6.0.16-linux-x64.tar.gz";
        sha512  = "62f25ed054868155b351b98fdd04c27aebd913d92844430a002da1346e77a8e86e61833f7b81bdc3d733ff2ae60a21d66533cdd7003b2fee47b8d0e8746ad504";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5fe35f73-59e4-462e-b7aa-98b5b8782051/74a27e03d896663a9483eb72bc59b275/aspnetcore-runtime-6.0.16-linux-arm64.tar.gz";
        sha512  = "c08159a811d20003bfa32ce4b5657522433fc134f6dd1a391dc82004edb0e92dc2d75880d057e8467171a91ae2c344e90a679e40b5c5fddffe6e9ed0bf26810a";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3e30ee2d-da08-49fc-8877-712fd63b0b84/1390326bfaf1e6fcd922fcbc4efc6293/aspnetcore-runtime-6.0.16-osx-x64.tar.gz";
        sha512  = "eeb99268be3c8dcb0d0c571944e01f22b3dbf0825e28cb1c9bdc0faa8f584fedf6d280f767609c5d91688897c185a21840f59cc91f7e1712c05a24a70fff26bf";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9209cddf-bdad-425a-8b04-682a7ead5e12/93c46a477e0d4ff411d78546638f6a54/aspnetcore-runtime-6.0.16-osx-arm64.tar.gz";
        sha512  = "b5eda3aa1394821b4607453cc639e49f92653fac6a7b381c8f33282185513ae606a06c63a4381153371354b94c9289e72287f9a25bdc8aca45efb5a8654d4af8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
<<<<<<< HEAD
    version = "6.0.21";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/25fc0412-b2ff-4868-9920-c087b8a75c55/a95292a725fc37c909c4432c74ecdb43/dotnet-runtime-6.0.21-linux-x64.tar.gz";
        sha512  = "9b1573f7a42d6c918447b226fda4173b7db891a7290b51ce36cf1c1583f05643a3dda8a13780b5996caa2af36719a910377e71149f538a6fa30c624b8926e0cd";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/934fe9da-efb0-47e4-8db2-4d2153c7fe0c/e382d2a3169ac6a8288f09c9077868c3/dotnet-runtime-6.0.21-linux-arm64.tar.gz";
        sha512  = "f34e1319ded1e1115ceb63eab16a4ac7096e36e3236f8117f61ec9f0e19dd50adb473e1213a1018abfaedc4da57519b85058e7b14187a33e0b91e79af4dabf63";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/af927c74-8c04-4aac-9597-3b56902a812a/47139a25bbc5e58b24fff42f6af0da7c/dotnet-runtime-6.0.21-osx-x64.tar.gz";
        sha512  = "f34a597910eccb84eec683f75f3ea8b6bdfc33a81388face050e33df679863465c905c0c99cdbfc54b3eb2b2a58733f7185a18234e562b1af5c925fa44dcb84c";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4c3bd8fc-abdb-458d-a675-aac97584babb/35b8a258af87daac35bab7db1af0ff9b/dotnet-runtime-6.0.21-osx-arm64.tar.gz";
        sha512  = "e5a853ee04890e0466489fc46e3cfb8c665aeaacda8646b6958337cb16aeb0edbcf6d4131d31510b12852262fdb466f4d9352e0818a7ecb7e00e4e3a5e5755e1";
=======
    version = "6.0.16";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/45395f1b-8928-41c5-9585-f01d949b2afb/0911c4025fffc0f51c3ab535695c6ca6/dotnet-runtime-6.0.16-linux-x64.tar.gz";
        sha512  = "c8891b791a51e7d2c3164470dfd2af2ce59af3c26404e84075277e307df7dcd1e3ccf1a1a3c2655fe2eea8a30f8349b7adbbe5de4cedfee52da06729a505d8f5";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e7866e12-a380-4994-9c56-1bd3a1e0a546/22a5e54cb4e637c5aac7ec6dcab0d739/dotnet-runtime-6.0.16-linux-arm64.tar.gz";
        sha512  = "f670ea542d34e5f63b6b497a23f9d3f8d9e2fa8292ec3234ee08ef0eb706f339c2c11811857ad83624ae4a7827b449d4cabbe41c566b2b51faccf58be44af598";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/24cc772f-0358-40c5-a41a-4c1434a9e9b8/f91c66d80be3a91f632f7eae102fd64f/dotnet-runtime-6.0.16-osx-x64.tar.gz";
        sha512  = "662084f66cf2983dbfb756f319baa2c1221f183b9d10101ca970fa3ccb2cfc49a7513af5926c843d3bd472b49991284bac5275d8f5e8671b9e96995ad2815571";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/757be454-09b0-4991-a2bc-90c06267fbde/2ea450db713598c9cdb46a6d9bd56156/dotnet-runtime-6.0.16-osx-arm64.tar.gz";
        sha512  = "c7389000b353729af7229017cab4b02d9245d39983b00744e3439ac846e6669368648b91574d46eff7807882c6961f76884447411314dfab18e74e8f3824dca7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    };
  };

  sdk_6_0 = buildNetSdk {
<<<<<<< HEAD
    version = "6.0.413";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8eed69b0-0f3a-4d43-a47d-37dd67ece54d/0f2a9e86ff24fbd7bbc129b2c18851fe/dotnet-sdk-6.0.413-linux-x64.tar.gz";
        sha512  = "ee0a77d54e6d4917be7310ff0abb3bad5525bfb4beb1db0c215e65f64eb46511f5f12d6c7ff465a1d4ab38577e6a1950fde479ee94839c50e627020328a702de";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/82132239-803b-4800-971e-ded613cc280a/67d0025a0a54566657c3e6dfeb90253e/dotnet-sdk-6.0.413-linux-arm64.tar.gz";
        sha512  = "7f05a9774d79e694da5a6115d9916abf87a65e40bd6bdaa5dca1f705795436bc8e764242f7045207386a86732ef5519f60bdb516a3860e4860bca7ee91a21759";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/398d17e1-bdee-419a-b50e-e0a1841c8a3c/2e8177e8c2c46af1f34094369f2219be/dotnet-sdk-6.0.413-osx-x64.tar.gz";
        sha512  = "605b28135dbc8c34f257ea1d10d02edb16569957e554ecc49c2a9fbb4200960b2fe21a06f2b770a9907fa915ebef0e6260704cc9e05a81af931f10dce7f46165";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6152c11b-e65d-4b60-8fc0-3c506a6199d2/c9f1ce3f1fc5bc6fa758fac505845232/dotnet-sdk-6.0.413-osx-arm64.tar.gz";
        sha512  = "e3a24cdcb80b2e283cd93ebb0af4ad891ecb5f2002d56b82a379d5d99b934a58f5ae60d07d21052360f525692fcf7bfde0c678c5d7f9908101fdd2096bea4458";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.21"; sha256 = "012bssj7v9g9zg0k3zj29h9221shy579xn2zzjpxniwlgrvjalkn"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.21"; sha256 = "0sq67slr4fqq0g9nv0bqbf8jv0fyjlf29c2xgqids67gq22k7cak"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.21"; sha256 = "01zs924jfnkz77y50r9pwx0mklvf67c6r765vy154d2ffrqj8dws"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.21"; sha256 = "1hcinwd9wz9lm4rg9lacic4810khmq8g53vfhn9fpm0cx7v0scqp"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.21"; sha256 = "109g3x9djfpjb9fkwyjn6rg151n7n01iyh3q8yd0wl178blwzs4b"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.21"; sha256 = "1f3jqi9zd913grq1bk53np7zdirjj0rhq7s4pip9bgdn7yihmc3g"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "6.0.21"; sha256 = "1x5v12gfssja2hlxv1wnv7s2cc28mrm06g4wsc2jgg01fgs58qi5"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.21"; sha256 = "0rafj2750hw54wj2y67cnq1d8ji419x3cc83i9x3py0i2bxfs20d"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.21"; sha256 = "1mrjv4rkgfwk0c30wsqdy259lqyrlzpymrl7i0gzsg89wvz77jid"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.21"; sha256 = "1yqxjnxlipm4camw59k1rizw11hfgz3rvxdi8saqk2vfc2rzh1pl"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.21"; sha256 = "054d7nmajgxq65ksv99k8swhr18yzwvb7gzkryg4n2msp6akgsbk"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.21"; sha256 = "0i6wf3kivl8lqrbq9lwnlwhnng2md415yg4wxnyyqz4a2mrj38qa"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.21"; sha256 = "0bc5zf1zyzi9cdrnpcr9li658pj2lv9b7fbcfavrmp22jlk81z1c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.21"; sha256 = "1p1jgcxs4231fi5vzdibrp2vnxxnzh56f3my9fp8kcn7zp2pzp5n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.21"; sha256 = "0c3xm07zyglb38g3kqfza92zkpjsg7k7mxr3hq3jwxbfzspxxv6f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.21"; sha256 = "09vnwfwwwa0agb2i88ya8bdwlryjz5p4jrpc7qn0dx3dwzbpkxq2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.21"; sha256 = "17rbp1hb1yl3vw27yqa5zbrfmgnxd2p49hg6qswwc4rlb3zfrjkl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.21"; sha256 = "1mqkdv56qycp1l7bza9rvzaghvd8rm3z863s6w73i21f3y0xnixa"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.21"; sha256 = "0grfr8v5j5g77smqpysqxr6glrw3d13gqj241pynzih5j6v0rz51"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "6.0.21"; sha256 = "0ssq95ymx7rg4b85hrxb1vfkdq8c41f464w029f1k9c21dd06ra7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.21"; sha256 = "1f7n63argwj3vw1y36pb8nj93ami8j1ff4ibp7h19555j96dnpwp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.21"; sha256 = "1qr5pkjgy1z4asa2mmkc0fzycmg4a60zy5ib3f3hpdq7416k838q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.21"; sha256 = "18dsq2n8sxwxmg3rblj5wgm6c3cvdmdll31lbwknbwjdp20c543h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.21"; sha256 = "1q7na94z30hd3xam802izb3mi9nl5l6s4akah5a62jqjxrjb76l4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.21"; sha256 = "1widhp61a7qxnjgjqavqi0d7z36drjkvi2g0r39y2sbk0a9hwsml"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.21"; sha256 = "1cwq84i6xd4h2ddl4yjzd6pbf3cm3g2kids0xkgjcafx3qjiqg4b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.21"; sha256 = "0pgc2rzsr1ag8hk1g75w1sm3p0qabr7fddckfsfk4sk54gwdr14k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.21"; sha256 = "13f65051h35hbvrz2g26vsvi9c1fbrc1hkjsxvx2ys7s1qddddqw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.21"; sha256 = "0y9dwb9fpycff0jh3c7gqmz9vrbg52p1bs4d437b73sfl7yj6s0x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "6.0.21"; sha256 = "1hww6k853nk8i620d9gmldbaj9ylawwqhzcjfmzpkmpj1hij80jd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.21"; sha256 = "0ihsszn9s3dsk31rr4qvh3kvlf3dwrzcb0s91dblcgi40gyczqb3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.21"; sha256 = "1vj58wmhy6rib7y87qg44brvaqqmgnhy69w1icjq2dw0xki5gkcr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.21"; sha256 = "1dk61kz88mhss6x83za34xm0q5nrfv4pdp0mvjqsf448g7c3ndiy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.21"; sha256 = "0rfa7lrhkslws7j31h51bii9y0bghiq8ar6drljyi45hzmp046rd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.21"; sha256 = "1pq884vc9hs34giwbj2awzbc3z168hv201871ivbj8scaxnbga5h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.21"; sha256 = "0cm5h80dix7ca16bhxsnm63jvcxi52iy76v0dlzbnpr8f85i4368"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.21"; sha256 = "0i1qgjwk7ghl1ajdyynl334ncv51nr774fk9xdsylz0qid7nk3qq"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.21"; sha256 = "1x75lhjwpcvh1qrfkzv20blr8kvjpjs79zwn7i39m4dns39bfqyh"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.21"; sha256 = "1a6r36g6sgx64faahgysm21za6hjnk62bp445xb8jxd35vbzqk2s"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.21"; sha256 = "160hyyawl7zz5kwlzwhk6lh5hsnjzsx4h1vkiixg201y24dknim0"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.21"; sha256 = "07b1f5iafhbgmvyxbfbax14wwyyrph89wfbq5bigsibg0j2275nk"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.21"; sha256 = "1585phixq77p44w7kiq3ynf8shfimkgh0raq6shpbp3pv6ayw2ji"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.21"; sha256 = "1ql6kbnav8g9gfc6pv347pcxf853n3q70r2w6l889zizidgvhwpn"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.21"; sha256 = "0zai12wv98sxm51axg474c393p8z22dml8pxl9680hf8z0idi1zh"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.21"; sha256 = "1lf3g9m60kzrysrsbbys9nwf5vy089lkdrpaix4wb8v7qz35z7bf"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.21"; sha256 = "0k9xy7hz3rxcgg0n4jzgbsg7gwah2xz48i2zzy8msqffp46d7gja"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.21"; sha256 = "0bci8z2p4akkf74cyd9x7x2kbyjxr3cik3yyajzc6v6p3pda2cmy"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.21"; sha256 = "1s1cpfj86yl7y7009zvpyjxadyji4pvbjvfmzi1abgyqrq570gba"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.21"; sha256 = "113jyq5ag1qsdxxzz2wk8frnzhybycmqzd945i5lz63hpsm64vmr"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.21"; sha256 = "1jrwjddqb0sqz3n1lsv3inx5119dcjkj4hsarbzj32l81zi6id85"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.21"; sha256 = "13df176z04p6byf0msjyfw9rwmvicbnidrznvdg9njvdni3yxrk2"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.21"; sha256 = "0nyxxqzsgfp3p8mcw258big603fmkqn8xxwgngz9ywbcz2vgm57w"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.21"; sha256 = "0nf3wm66hr4f35dbfvg4qy5wbvc15maiw1dicwzwj4p6w2yxl5hx"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.21"; sha256 = "1rqsms2wm64cwcvc644z3vrs0jfb0gf1my781mshp7cp95z466z9"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.21"; sha256 = "1rga4gy7yna1rdkvbc07hm107kvmygkpwrdbrwbqlw1z4rvg8qs5"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.21"; sha256 = "08msw4lbklmz0yy749fljmiwh3na5zkmjgihcyg19wi8b5rcqi4c"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.21"; sha256 = "1vbz73aj4f9a4if9mckj7rjqfqk0bgwnwj77vlx6rshcc8fsngwp"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.21"; sha256 = "0134c4xzbh3g5ags2ahxrjkwmicmybvyjnl18y06f77r4bnh81gp"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.21"; sha256 = "0ck919lw68xh4x6klqzsc8hshn65ykb9nd4jpk17r7crmxj8jk4n"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.21"; sha256 = "0rz5rn84irzf2k03dcp5qghhmgi9sji6a5l9l2hdjjr8j8pq9dw4"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.21"; sha256 = "1vv0paimjpc3bacv5cz39y4gd5cpc9k9863iil8crmm2rkiy611i"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.21"; sha256 = "1x42nrh4bjf7q2m193dziks543g72cyf4gfylhsyd397kp940sh5"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.21"; sha256 = "0sqxzfirdmaj2r6nc1yc83qb1sbgsl1r0qcjidrwi7dlc5zamrvd"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.21"; sha256 = "0jffm6yxn78l14x7j53hl9729s9vyyv604w8zdk9npdf8sgaxiwm"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.21"; sha256 = "14hbzh401vmfsngvnmc4c1g8hv41h0za0kh8g6ya3lsfylmzdr06"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.21"; sha256 = "120qv0z7jhiplabsqal1ldriillqbbyk0qfrc51yrfp5p7ycc8sl"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.21"; sha256 = "066fn8ncybkfpfssrr0pg0adhrskknn5agqf3bd0fdhwg45k3gh7"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.21"; sha256 = "1bsax9akfrxkj7nyx20hnw98028y3fbawq9k728ldpf8znsk3j0a"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.21"; sha256 = "0pl4yskax24y75mfd6rkwa9cahyv0a1h1836yr7nb3dks6a9npf0"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.21"; sha256 = "1dq1dq27fi4jacrq86xdwfwx49y7mgxxaaqz00na3afaaya2c2xv"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.21"; sha256 = "1k5ajk31rr9bgy9rrlj67czlqpbj5n5iycmf1hvg7knczaraihss"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.21"; sha256 = "1qa1hhbmlb4brnbrx0g3ap9b7ss1f9ddmigjsxgh9z20i0y8pybz"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.21"; sha256 = "01cfpcbds831w51k9ajwbbca6nj05f5cgqswjv5h5hiz85w23yc7"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.21"; sha256 = "08yx4m92fd9sxmfx4r2i1qma9m5jf7rvf35kqv1g6r4pplvm3pzz"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.21"; sha256 = "0kgh9wnx4h6vv9jnbpyzfn8ra2vrzcrza6h44vy4qxbcaavfrqgw"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.21"; sha256 = "05cp30bkyfxiqfx6v1nr8rc08jc9br22n0klf1y1xxvnb5xh9c49"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.21"; sha256 = "01gcn5dh86rjybl1g972id3p5zwiisb6ba9w6bmzybh5pbp2a3sm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.21"; sha256 = "0yhx9gdilrlpzzm5s97y248kr3qw26nmc4b9qzqix1diyln52z2i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.21"; sha256 = "1krvn76iq6y89k8vyxvrvb1x098j4bmf12va32hn9iidkyr656zj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.21"; sha256 = "122nl7llv198m8fih940icjkapk8jxd32ih19cck9cb0bkk0zcqc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.21"; sha256 = "0agjdrz2qy3qmc6r23bnqa4k8fj1kffzb7bibw7yhbz3xvvyxd9k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.21"; sha256 = "11x18rqwis4459mqgdqhwzmqjbj0h87dpypn6cnxqp38x683zcwv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.21"; sha256 = "113p8mql4lfz9cdbfhn1ahd53kwc3d240m1l3z9nlmlbajz9y9xa"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.21"; sha256 = "1b52v5rn5i989vlg92r3magxsq6svmvap409g5f9yks3v8cwndp9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.21"; sha256 = "1mhrrdc6vvvv7qq1qlkfx6w34zzlxv77jlyz5qznhpdklfhdh9f8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.21"; sha256 = "0r19id7qy44lm4xlxi5ycn0msxpab5wga94iy5s3sch6vh66r53z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.21"; sha256 = "1hwf4scm9s0ml477r4iilw8z7q69g87d15hq7v75dglpacikm4mp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.21"; sha256 = "1mf7axx2qw0g9sgiqy302287jz6ir9lxw14qd2hafqy83hryzl81"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.21"; sha256 = "11krayn5c82yicw2xkl2y0yhmjvdi5zc6383lsiv6zr1imk0iy6c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.21"; sha256 = "1ljzi3vrx0lbhvp02d1fm3hws06phqgrsav1yg6hwk9abp2q44p6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.21"; sha256 = "11vjprx73v65khddghqh7r5x5zij04w9yjr9njhhi6x3zb42q0cd"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.21"; sha256 = "1rcsk1j7n1r5i57gr8q60wbc9wdkz09y2w1dl02pi7w5pf8a3j1g"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.21"; sha256 = "06fhwpf5hrz8w4fjsb8hqzlpmc24jmggvp7fk10vvp4gy4jqc7ja"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.21"; sha256 = "1xa6c30whip8m40m208y2za9b854fhwgl9jhzigny431f15nsf56"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.21"; sha256 = "19zmawr6zihk6al746gmrw4sgjf5hkl3n5baaj0h3h177vprh7yx"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.21"; sha256 = "1pxycv7ssawlqsh192qsg40z3q3c1a4jqpwillng3kjq54j0kqac"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.21"; sha256 = "1swcj7v4ryk6sk6nil7g4nzd1zfss470ic7cgxkwpzlnb720rbiw"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.21"; sha256 = "12chbi12vnvsfw2yrm4pj8hnba66cq6y83fwzjxpidca4disl34v"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.21"; sha256 = "0q36jbmhwrpvrnbpckq7qaipwg82ic9gb02xgjizh18cpnr9xkgv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "6.0.21"; sha256 = "0j1f59qa7bc5lnrya39qbwsb9q9w6rvbhlzkjyal8k6cjdvlcwhy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "6.0.21"; sha256 = "1aq51kbaa6hz21qy0hxflqrdkp8fdj4x9xwqnrl9vg7zmqzjd9yk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "6.0.21"; sha256 = "0za904fcz2ckhnbqabavd6gm7pifl7ap9jzxakk11f9ym98d8ls1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "6.0.21"; sha256 = "0y25m7mc0nnwik9f30i9iwhw5rdhaacamiy51w15jz6dilm7m4m3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "6.0.21"; sha256 = "0qanqrbrpzjippga0awcp815052z2al1nrgf7sa2f91325b2yjx6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "6.0.21"; sha256 = "1ivymplxwvb78mc2m1v14p4gj2l8lpbrk90j1aq5ipqkikh7r0bc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "6.0.21"; sha256 = "1g4mf424mw3rww3rmybmzap1p9bhi0anmz6khd8ynprigshchccp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "6.0.21"; sha256 = "1nv9ynkblg1d77gplnpvyvbnym2jc9l7rdfgi24hwmw5w9fxdv99"; })
=======
    version = "6.0.408";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/dd7d2255-c9c1-4c6f-b8ad-6e853d6bb574/c8e1b5f47bf17b317a84487491915178/dotnet-sdk-6.0.408-linux-x64.tar.gz";
        sha512  = "d5eed37ce6c07546aa217d6e786f3b67be2b6d97c23d5888d9ee5d5398e8a9bfc06202b14e3529245f7ec78f4036778caf69bdbe099de805fe1f566277e8440e";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9c4bff1b-9f35-44a3-95a3-d17224810b08/0f7426d4ce82cd5b55ed1b6f07877d5e/dotnet-sdk-6.0.408-linux-arm64.tar.gz";
        sha512  = "40ad715ffb059df03eeae4ee4dff9b8998928e90dc0103b38ef671acbcfe4ac40016220e6b1214f0f77757099dccdf0fbaf1690191b350dbbaf773a01be8d25d";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/048c81a0-ee14-4b14-8572-d192651d12d1/060be74876613256c50ea75ed623970a/dotnet-sdk-6.0.408-osx-x64.tar.gz";
        sha512  = "98599e2b6d85267cc414cba0da26258251499f62eadfad341d0df4694b261b28ab5a7a97db0b2b8c0f215d03340dfb8a9f984a1f0eeb110a128c982336c1e110";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/21503502-8d12-4a18-9d93-ec0f7ee7b9cb/3df619d8ac623a16a79755e73fdf4d0d/dotnet-sdk-6.0.408-osx-arm64.tar.gz";
        sha512  = "2dea66a67ca21dca2b3a12593c7249949af6619551fc265ce33c45b5366ce98eb55aa84a6c5cf0fa9bb8ef7f5ada89bc9cf3c96d34ad208cd9bf0178a80fbb97";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.16"; sha256 = "07si0rn45mzkp6xpcnhziwlafrzmg9asa5mb54bmpa7ww0zdwyvz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.16"; sha256 = "0c6ys204024yi6wh6jyyvkv60f877nzlmzl6np30w9a3nxlavnhw"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.16"; sha256 = "022kkabdfvb551fw1zs77kgd51lak72pn02429jbiw5sgrn34fzy"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.16"; sha256 = "0vffxqwqcar0hzm2bi9igjmzqpy4cqsaikn6y25q8msixwbdr151"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.16"; sha256 = "1xdhn8v8y947kw29npck1h9qaw8rj81q7a0qwawpc2200ds96n40"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.16"; sha256 = "1i26fssv17w3kcaqwk5w2aq03jdijhrfl0xp0q5s68j7i4wrlv6l"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "6.0.16"; sha256 = "01r0bzqi67rq0wls14zm7isxw9za4y6dzswkarzjzcpybx9nzfpk"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.16"; sha256 = "0rjg6w707sacdyr8z1y9aiyif2f16823gmpv36imp6vy7pjiq4xa"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.16"; sha256 = "0n3kawk20i72cyz5925svrg33blimsd2018qrczjxr4hg9pz3z73"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.16"; sha256 = "1akpxx2ad3yi2q6ifm6p3nn4qalc7v7cg0vxcavzpq246qarvai3"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.16"; sha256 = "1v02j1i139a8x32hgi1yhcpp754xi0sg5b7iqzmslvinfg3b7dwn"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.16"; sha256 = "1v2wfyxwk239ypnx7rnklw7v818y7dki86pyixq6fhlm5k0v30fl"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.16"; sha256 = "1p84za2cxyxxbkgxhfnmdarkz64dacx9f52jplrfs9rgl19anan4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.16"; sha256 = "0vxsp1brqifh53c0dziz73m1a7zkyf4l5x9f80m15xfhkvnwvbc0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.16"; sha256 = "0iv5186gb778swka9ylzblwvr8pp7cmsvji5iiszrnfvk8c4n3ia"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.16"; sha256 = "1ickazixmjwsybixb71231qldybaazdiinq621vgpzqn5j4rd782"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.16"; sha256 = "0a5p5y85kcg0a6kk9q55203508yr16accnnf44h6rym5mvmr6lds"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.16"; sha256 = "1pv9arqbmxlh86rnx6nss2cl91hi22j83p66m4ahds34caykf32l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.16"; sha256 = "19ffmw131b8kv7l5pmwi4358j5xhla48qdyn6jv9fznffcsxfgzc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "6.0.16"; sha256 = "0h9pq0pxab1hyc7chnqrl3prg44cwfvflrz2afk4dvz84sq4z5vv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.16"; sha256 = "1dc554g11xv20hg5sdlg4nff5ky1hi42771jkfbsar8ggp90g4sr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.16"; sha256 = "0fv6yvn2sqbrwr9x2alm00g4d06qcgskmbn57nmshjlw7pr4n2ik"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.16"; sha256 = "1gglqjhz5llv6cgq532f7mqf21pzvy3xycy2193wwfg0xir1pfif"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.16"; sha256 = "0aynzlxyhxy9cqlgs03ixpax7sbhr98y68qipd2x38dpq90jncg6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.16"; sha256 = "10dlkzk61nnnw6f5rr1lmrws2p4hvbpkswm3209w45z350n9nlpy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.16"; sha256 = "0ljnxjj9nmcpng1v185zns14a0vzkgja59m42b76ny783nvn4hr6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.16"; sha256 = "1rih8q33byfhr33kbz1xzc74drj1ypbxgqd1rjga3zq9065kpkih"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.16"; sha256 = "1fjrc1l7ihal93ybxqzlxrs7vdqb9jhkabh2acwrmlh7q5197vn2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.16"; sha256 = "0gghxcr32mri7235f41w5ngdxrw85q28nd7d57hmzj72cv93yxb3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "6.0.16"; sha256 = "0gncfcx8v63qw56immp26jmmy3gmmqwws9ajqp3v3c0pfl0ai9h3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.16"; sha256 = "1v6xbi6l9xign3vjqnvh7yd51yzzpj80ac0a889cspizjlvm1f83"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.16"; sha256 = "06zmcsnchsw1n5v0dsa55scpmd5j6bylrayds5739dzxv2f2am07"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.16"; sha256 = "119bh835d4nl4328cqwj666q8smy64jl79arkdnpwa0l78nldf5q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.16"; sha256 = "19y5jy00ifyy5y9qjvlysr1xmsgylbh9bc7vksfsxymll6rg51j4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.16"; sha256 = "1abr810nga8pqr4xnrmxlq7bp11cxzjgx7gsz1bvg9xmr0gyp0vf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.16"; sha256 = "0vry28why3jaisqnida8rjhc84ry9acnw3h02v798j6zd0x2gfvh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.16"; sha256 = "10bhgqnlqgzd5j8x8ix03fpglp1z13k8a4wn822n4fv0yk5kiswq"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.16"; sha256 = "1kk5mq2rm6al46nzr95lhfr7g0i97hpp5d18n00mrba3zk601hr9"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.16"; sha256 = "0x7knx2fw7s97jmjbqarflc3bbj8ywdl371i56gs8ipr0zagx06i"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.16"; sha256 = "00ab8jijc3ibdlybikhn708421m4jx375xzvcm1xbl34ljlsm9rj"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.16"; sha256 = "0bgri0wb39dwxzs1x2hc9f49wvhb14a1g50dm4h0grcfaif58j9k"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.16"; sha256 = "1sr6v2q0hcr2q75qjxgwij0735v5c9m2hc41scs87b0gg7m3mdin"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.16"; sha256 = "0a2q0bkrqqc7sghhhq31c11q5dbw58jgrs696y7qmn4hyj42srxh"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.16"; sha256 = "1fparz4pwvfrkw2r36y787i91rm6q8gmf934i2my88w7nlip7vs8"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.16"; sha256 = "1ggcjz4s4rar9x0y5vdq7zpzwxdcivw8jyzfms6mj0gk3ip4lyy6"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.16"; sha256 = "1qrczz74xvdvbrrsgj3ninp7ab9dz56cwlm5a84x77fyfpfdhab6"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.16"; sha256 = "16fk4xdd5dv67scqszyzmbbwm79mfapa0akn82cfq1l7a2bccami"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.16"; sha256 = "1pw6kzgpvy5ccawj9j3mnm1v64p0cbmc6klchwm53cqcych2626n"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.16"; sha256 = "1brvra8yicix4sm0yhmdgk5ikkqaq7b890d1mjqrk50drjznjhzj"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.16"; sha256 = "1kbk1j7abx4hw0anj35nr8j5vwvxapx55vzy7mcgd95j0kf7nzy0"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.16"; sha256 = "122149r0jylqhpi7f2wdna4xiq30bfyscf1wdbwak4v618r05kr5"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.16"; sha256 = "0d1yny2v2qrji3cay77khjqhwrg9kjnmh9k8pxsrzc6kj3lyslhi"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.16"; sha256 = "0xfmfn4xbqaz39fclj47cv8c21mqkbggv719rl9k1cr5lg35nxkk"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.16"; sha256 = "0wvd818hhivf0z8zxpxlxaffqf6w3nfg4b4abhg8lzxa1jvwjy54"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.16"; sha256 = "0zh770jr1249w53n220d952cj0drjb58j1y4dwrw9ndgdws1vp81"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.16"; sha256 = "0f75fjhm5r2mmnlpl87vq06a203cdy918lnzg0qhfyxrndsphb78"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.16"; sha256 = "1pbxd8fviim97nbpkp12x6cchm81m4zqx20i08k7hhhjr07cn742"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.16"; sha256 = "1ig5a86bhc0k33nqdqsfiy58y2y7bz9ql2jbq7xvwqhrvb8iicyn"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.16"; sha256 = "17l2mfxs7mq5b2arv6wb0vy94m889nzdsjykm7kym85azrs5p6al"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.16"; sha256 = "12z96zf95al3wb7b5zk2j38bxh8dnnkbx7s4n1yvz6h6snln1dcz"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.16"; sha256 = "0gncg3xc8wcmz5jb6g3cf8mds4hnxnqi3cym4nxym1v0p2qlivx8"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.16"; sha256 = "0haalqnkbhnzjp22z168v61qy1kbjp9dx2jqzc6k292j146cdhhz"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.16"; sha256 = "1y227dwp3244dd74i2ainh3w4zv6p3qz1vc8bb8wr89z904nkspz"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.16"; sha256 = "1jm8gv73iig0nj699krbz9avq4b5qxz6y5m5dpaik9wfi76fmlbp"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.16"; sha256 = "19hcw59ywxr1l0j4bn45szvqnd623h1faq74mmi8qcb7brxbndjb"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.16"; sha256 = "1wdrfqihjs3ipwy1d2hq642n2d4777zh0mzijjhjxixxjhcd1s09"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.16"; sha256 = "1dlppj0kiybf6wfz0g1g47c8jvdff5zmdpgdz7lh84jx5j8hv9na"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.16"; sha256 = "1fss3n6qprssrz59gdhahsbwdfr68yi046rv7z9gjahp231jxn3y"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.16"; sha256 = "027jnfdy8cmmj5aixyxmqy80q6vbfysy37pfyg64bjxkvr9qjjky"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.16"; sha256 = "0aj0aqwl2y7v0jxjmknkxk17fdbv3qsg8hsa3vnzm1gsyrzx3dw4"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.16"; sha256 = "08r8nw3pv4dvjdmby3s7b520jn2v0r02j36knyxfn0vy951d95d9"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.16"; sha256 = "08mwpdxgd3gjq7f96m64wd5hj16zrp2qbwrzggrpf2991ppsx52p"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.16"; sha256 = "0j207sqhk0ndmvl11ig34vjq6xfwqg0k3p59yp3f34fvv003x8kd"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.16"; sha256 = "0zwq1wp7737lsliazyrq9h0llv26svsb91mbr6px1dzrqjk2j1s9"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.16"; sha256 = "19gxli9z5x18bpn3yzczj8znh4b7ji3qimnk58v0kmc8kchcs5gd"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.16"; sha256 = "0kz4s3bibp8azqb3n644lsf16gwaxb70lijg6n7w2afxicnhxrar"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.16"; sha256 = "02jpzn42i7n7r4k3w2hnf5xpq4lm5k7gx6s8fkml87rs6xjwma8w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.16"; sha256 = "0lr7hhcjcqszgb7477nzh5ahic6mwjp5wybd2ffl63c263z4c1kk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.16"; sha256 = "1p5cc9nvmdfcpysrszhd6mnk500ksh29b3mmi0v5if01jggl3f63"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.16"; sha256 = "01f98kkq8p3xll4mh6ck8ljgs3k5psv5z7mys7kpvk7lvag2svaa"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.16"; sha256 = "02947hs31zvm5h0s927mk8a6zlvssskyh7wy9pnbq4lcyvan2s72"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.16"; sha256 = "0jsfjp32z08pgi82blcrhmf5ipkhlg1kld8jmr7znzgv0kic8xyh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.16"; sha256 = "1w89n5grnxdis0wclfimi9ij8g046yrw76rhmcp8l57xm8nl21yj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.16"; sha256 = "15hvv7vh6zjs8ps7ksqbv8iayd2ld4lai1yrpxmryqm14gjadp7s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.16"; sha256 = "13w8zy5y827hvpdwbdzpc7xf779ynb8nbajz7izprm0bj73m8784"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.16"; sha256 = "0q28ndwnmh52lbgnfdbrx64im8z2chrffx3hg8xpx6zp5ig4fdva"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.16"; sha256 = "1617fdb6bwa43f2c2a2gix70c3k4gn4swd1m9as8fy8pm89nlrx6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.16"; sha256 = "1m8h239jdp1nrh1axyhfbjjj59bhi2cc4cfal818zq47x9zdr6k8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.16"; sha256 = "0mcjkfbm1ajd65ifpz3758b55nv73pi2aima2j1941z7dagzk98i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.16"; sha256 = "1ilayqmqd00sq27q9mzzq2dbbc6q0zbgjd1cgs9xsnwrrwrgzvhy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.16"; sha256 = "076gr147fzrvn9ikk4pp33ywk973gzv4if0k069xr3piwhf80w0y"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.16"; sha256 = "18pb2az9y24j7sdad95yskmsr0wjbaccd27hlanlyi1wijdg6qd6"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.16"; sha256 = "1mlry7w94mmrnhrpl9jcpbyhdz019kk5n5dvm14yaa8g5inc7i1n"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.16"; sha256 = "14c5q15408dr41x6dvi965qrs2hayy5j1cmzmylxs1yi47xmbvqk"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.16"; sha256 = "02157ypj7znfgiz0q4kzq475m225dqp2cn1j5yzbvr83qb3690xa"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.16"; sha256 = "1sf5sjla7s32h7dmcb5vaa2fgc2f4542wr1zn8xp3b29n1w9xr89"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.16"; sha256 = "1yfcdyjvpd6csqqdm9azz7pm5dy3xapfvcynssl0r2nf9wm0mblm"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.16"; sha256 = "0g6wv8y3l4cnq2w96w69zn5wvya4hzv5vx8421wz35y4vghfbgz7"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.16"; sha256 = "0w7cxw23ka2snvv7dlyfq7npky50l2kckqwgqkjkn29rmqllgxih"; })
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ];
  };
}
