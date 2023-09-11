{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v6.0 (active)
{
  aspnetcore_6_0 = buildAspNetCore {
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
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
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
      };
    };
  };

  sdk_6_0 = buildNetSdk {
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
    ];
  };
}
