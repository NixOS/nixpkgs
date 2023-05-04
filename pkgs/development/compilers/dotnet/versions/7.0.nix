{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v7.0 (active)
{
  aspnetcore_7_0 = buildAspNetCore {
    version = "7.0.5";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b936641a-57d6-4069-bd32-280020863326/5793e00ff9e9973a01ca735479ff15b3/aspnetcore-runtime-7.0.5-linux-x64.tar.gz";
        sha512  = "859d48d0f29e014d56e89161d8001f75b3b0b03ee04f86641066570cfbe267b06798232500a86fd7bc31edf022097278dfeb496874778fead4476863aa994928";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/565ed9fc-5ae5-4168-b08c-f4e39acf47ff/f5e3c6cc872681c08ab9aa6deb8a72c2/aspnetcore-runtime-7.0.5-linux-arm64.tar.gz";
        sha512  = "2c35feac6e8a55185767714eca52912bafe5c6255cc0eb0b93aa245255e405ad1076ae018b7a3cd845b159bc2d87d950ebf5305dd52b1215adbb35ea9cfcf551";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b707a1b6-7222-4929-96b6-3525f93cd79e/dfa98874e490e3da4024cd20baca4a22/aspnetcore-runtime-7.0.5-osx-x64.tar.gz";
        sha512  = "69c473ec116de84bd5cfc27972890f545952a83deae1c3d298152a2dac892f1a70b0a3e10269bbd332fa8d95f2616052f07597adf9279a0d2d2ffad7382602b2";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/dfb4f870-e416-459f-bdf5-5362030c6d5f/fb888174a31cea86516a95f60ca8e65c/aspnetcore-runtime-7.0.5-osx-arm64.tar.gz";
        sha512  = "855ae3cad226fe4429073a54825ebadf2c3bff84ef811d602f4d4f259663d6648b7b0d3e1683e50ec5caf82417ffab47599a928cb635f2149661731cf27ff698";
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
    version = "7.0.5";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e577f9c3-cf57-4f3c-aa2f-2c0c9ce7b9c2/16911adb0b0ac64ece205a8cf96a061d/dotnet-runtime-7.0.5-linux-x64.tar.gz";
        sha512  = "68014bdbf55bf455f59549c7d9d61ccc051e09fe74a975ca6b46d3269278d77c9cd167ba05760aef8ab413df4212f4f5cebdd1533779b49caf517eb4ec50cce5";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8fc09c26-b0b1-4f26-921b-c1378547768a/04088af0b59a80a1fe1d613751d0a2c8/dotnet-runtime-7.0.5-linux-arm64.tar.gz";
        sha512  = "983b8123db0ecddee10c00c455c740e24793c3a7d1d400722cbc6183ca9a8916404d81dde07e43b9a6b1ea6ea160055b871845a789117ddc023eb07f3685f4cd";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e4242cbd-90b1-4fc0-a8a2-44cd251450aa/3d811a2e1d73cf59d077a63099cb8189/dotnet-runtime-7.0.5-osx-x64.tar.gz";
        sha512  = "4053c79ef80dae8f8ae1958215def910490b3c754ef088f02c81263c790eb8658f1845de916827755d62af37c6d090d59c9a2219c961a29b469a7bed74ba950a";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5a4664cc-7009-4b8a-9e6f-e3ae0b2218d0/add2992c737ce7bb70298fc030c84ead/dotnet-runtime-7.0.5-osx-arm64.tar.gz";
        sha512  = "2bbf02e8001b700cf6badcabedad148a3b799ad0404b2e1e17bf80eca5eaa7a7939df135898f2aa5ebe7892f09d6fa7840118d3f360c2f4aacceb2cd8067c15d";
      };
    };
  };

  sdk_7_0 = buildNetSdk {
    version = "7.0.203";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ebfd0bf8-79bd-480a-9e81-0b217463738d/9adc6bf0614ce02670101e278a2d8555/dotnet-sdk-7.0.203-linux-x64.tar.gz";
        sha512  = "ed1ae7cd88591ec52e1515c4a25d9a832eca29e8a0889549fea35a320e6e356e3806a17289f71fc0b04c36b006ae74446c53771d976c170fcbe5977ac7db1cb6";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6cd2eaa7-4c06-4168-b90b-ee2d6bb40b10/4a8387eb07e17d262bfb9965f6d34462/dotnet-sdk-7.0.203-linux-arm64.tar.gz";
        sha512  = "f5e1b5a63b51af664b852435fc5631ff3fbeafbfac9f34c025da016218b0e6fb9a24e816035a44f4b4a16f28bc696821b1aa6f181966754318bc45cde7f439bf";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/de3e24bd-f677-4d9e-9717-859ce6659b5d/80c21bb06ca64d9408d11a32f858c7c6/dotnet-sdk-7.0.203-osx-x64.tar.gz";
        sha512  = "a69ec597bc5b0a59ccfc9cc63c4883037eb9293600e98ea420c879242ec6c3fae6a81a3a08bf7d5d2ab93f750debffb224ad5628c9abd53bc44cfcb02ca77136";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ad0ad533-6970-4099-a0c6-ee1d089a381d/2d7ea966c6d032111389b7686ccc0d9a/dotnet-sdk-7.0.203-osx-arm64.tar.gz";
        sha512  = "e41de76f6be00de587cedaed2b0c6e2c2871b2ebf03c89375b4c69cd3fdd14df0dc49b5fe83970868a25d14aa19deafbfe66ee6790383b77f7da3d8dea939664";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "7.0.5"; sha256 = "168bkqk0v02rwxviqzafhkdmzmmbd4z60sibv3s43byn0d8hvfdl"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "7.0.5"; sha256 = "1f7j3fxfdbin5zh39knsr1icpbdf5zkyjdxds9m8brraw9gj5mlw"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "7.0.5"; sha256 = "0fqhjy5q2j1c44ijgzpl1j4yfkhl7vyijga2y5cnsly42md9k5lz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "7.0.5"; sha256 = "07c87frgxvdgh4v0n02wc8z27x12kywcwjdy2bqa6g45qznnangz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "7.0.5"; sha256 = "01irhwqq80ifrqf87897jlh8v0mr5yls000gryv4v8cagsq648s0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "7.0.5"; sha256 = "1nwlyz0sgykx801fg1lj7la2b3vbgyvk51132v0gnz48m8b62n3w"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "7.0.5"; sha256 = "1zkjvfqz89cc0s25i7acbcqvbs52fach0iqf9098h6ak2pq6241h"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "7.0.5"; sha256 = "0jxrlgb601x1na085pmqyb9r1wp2vbnhly7pd2zmrgqihcxcp86w"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "7.0.5"; sha256 = "0nxyv0bz9c46pmwvvbmpb6c7id8l9ka9lpymi0ljwln01xwhi8fx"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "7.0.5"; sha256 = "1631gy294dkd2fvr7010a1sz6hsrdzvvmpykxp1gjxz242wxqaix"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "7.0.5"; sha256 = "09amylhcl0fgrn08zan5xcsa4wjw5prdnlgypbvsz4z930lm4zf4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "7.0.5"; sha256 = "1c62wlq21lck49a7cfwq6b0lb751151dn1sn9qv11fvc841lkzw6"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "7.0.5"; sha256 = "152dlxn5bqvf0nyhmxbcmaqj95bmm4vhvm4y23ajfwwgh373n00a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "7.0.5"; sha256 = "1vigsv0si95cjicbrpgi3jmpf2a1b4rn13yyxqhqagv1chs60jh5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "7.0.5"; sha256 = "1fq6bjpsmqdgv5z4ncxnxrfn10aw90n2zh8sqw0whhv2kjsq7v8l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "7.0.5"; sha256 = "06pbg6cphf7v39f1nsc7d7wzsl8aanb59dckxay3zazljpbyg80d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "7.0.5"; sha256 = "00nvn3qxhv2rqi35wxj21fwq5q8w1zxki70pnaxpv4b6m2s8jmql"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "7.0.5"; sha256 = "12p3zq5n8pmpscrgz944rkrjb12q702if8510xyf2b4na85r85qh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "7.0.5"; sha256 = "1lnv3z082ijmyzwa3in98wz7jchaxld2gbc3dk2k804pavaamr8r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "7.0.5"; sha256 = "0484mij7i3daag1k6nil5p6bxs5w9hsk2f2f13lnjjgdcnl7znf6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "7.0.5"; sha256 = "0wvjzn6xij7kgdpkb3m7y31p1iz1jzn737r464fqvw778dnnir1h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "7.0.5"; sha256 = "08raqcy32yni373c6kdmxvyndxlwrhnxadfjp4fn7rfqyrgqkifn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "7.0.5"; sha256 = "0g88jgsk0vxwaiil9kcp1cfc5chkb6gsr45m8blmj866qinln3vf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "7.0.5"; sha256 = "1nysbj81wpywh6i39l4agv5rjhdn3bd1jqb6iwlkmriyf1xyshdz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "7.0.5"; sha256 = "08ak2khqcn9dqinb59c5nlpa7imdhi5j7l4g9p2xm62jm6816qlp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "7.0.5"; sha256 = "127bpxp4i902l44b28xmknw59f7smlsc8a3w4q5bykjk1hj18hxz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "7.0.5"; sha256 = "0bba6jzd7bl12wwm5wpnk1nwbn5ylc3jfq16wsqzdf2ymcvnx8vm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "7.0.5"; sha256 = "1cl6g85yaigyzixdqnxqpclf46x32f3ndjl08x9lpypwsv62cd9z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "7.0.5"; sha256 = "1rmim6wrkh9vd0klmlwm5yr6xszrhv2qmw4sh12453khxdsi0xpl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "7.0.5"; sha256 = "0c9p34b55zh490ky338npbga3jkssj7r6h4jwyv1bj9skbp3aayn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "7.0.5"; sha256 = "1x0psxmi1waymxndk38f37aq1lnd8airglq6i0hi38f2yfbmby9h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "7.0.5"; sha256 = "1wd6i75alsj2hv8aich5gjc6979s4shmrdmfraqj2qr51k3jdf0r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "7.0.5"; sha256 = "06vl6l0nkd7iikg98ycb5smsrvw8dz9nzmjqyqksia4hxvhrlzc1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "1y8fqpnfcp04bz0qjsms9dc5cpf8zdkk2vnll4x6w6h8mgsippj0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "1v4n3rb4kcy51z9c19mpwqkymsrw11j5x17hsffj1bdq7ad5ammv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "0yci8wcyliv34pl73gid5f9dilf6fb5hrfwbffgpka19x6yxjni5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "1dl8h9j09lwyc6vq550prwxcz15d7v6c6ii8gzli2c77qk71k6hw"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "11r5944ccwgpzvhqiy9f62a7fyqzszaq2yq9szx31l49hhbiy8bx"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "0k4q546554m8hnlak8300mgydjyp9rrxqm0xwc90hmn42k9zzr21"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "0mrgj2xkc6nk0xchpjyfrvfchx721nc25p796c93vgh60zv388dc"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "10jnaybkq0b8n02lcc6ay2n5s7msghbz96kydphj8fq3bicljggn"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "1ssdj1mgmm4vg8ics072vkbn0a0x5dk958hx7wcvf5966fxjh5l9"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "0xygpaccvszvpbpg144ddbdwfcwmbssp1a53l7nfaippr16c7jc8"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "011kc0d2hmdqzy46x20w4ljq10i0hvlhmna84jid21cinfk2zq8k"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "1sigppl8zjxxs2c7y4gsc03913q7bdgw74rvdkh9vh7hq8kgldb6"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "09jnm9pq7m9wacc640g23i171w1fwmvg103amdyc9ayih66gi6nl"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "0p4izlcdhsd7rnm7iv0s9h7qp8vfvd17dyrn35hjj84147x34dyf"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "0c73xl6ypdjqpq6fw115fdq40pfmj4qm3j5v67mrxgyki2r0m6di"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "0cjsw125syx91d8nm996c03kdv77l1aqx7nwv9gis9mqx6mfb9ij"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "18hxhi8675z52nxwii3zixki3g4k66dm89gnnlsa0bw0n445l44a"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "1mlyrddmdmf3xfh4zfxcv9938xfhyar7yxgin6skxg6n0f1n3qjp"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "1aczpv37c6b2gajwd5b1wp0fx60dzgbpb0r24d2cqkj43rpbynvw"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "0g6z2pcqgi63r70shc4bhy652cjg2phlapscj7niia7nigvj32w4"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "0whgwpb1p8ykpk81z54mqgnfm3dysgfdl85d3idkjzy4a4pjqv0q"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "0zgbl854p26wy3vx0arqm8clbclx23z0q0fvk3117k19r0331kz1"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "0q650bmnl1rn4va86dvdw2gdb0vnlfzdm2jgfph6hk34cdxqdrd6"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "1z32pmdfdpw4ng7z7xqq2ahq9ydgii85cywcixl3rdmxk2fsd9pp"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "176rw7iy5k3rpk63cdi6nzcq00qfmskn8y3dfbrds3qxlqlq123i"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "1xwnpmb7qrzwk2c3vmjrpmwwhpizz8rpx5zm601hkdz458pk9xvj"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "043sg5jfkrvfrc7h2mf2qc9g0l1qz9fifn6dlqx8d6bxl46vqk7d"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "1d6i9dyiml00sr92n5jkp818hibbrmaa1d0wwvczcjqq4r6ajpyw"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "0gxc7jcs1mqbmhz5vwi88pk795f0lbkgk0fvvsy93f9zj70gsc2m"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "1zvlbzfa61i119s98mad7af871f1qkhb832rfkvi2awv103pwccp"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "08gwnsaqgrj61rk0zpd9wbmlfy71jip4fqaavsv350cd1kw76qv4"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "1k27y6mnn2q8pz24bp8ff04lws1jvpdwmadi3a7saqdsxwzs4mas"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "1vxzs20ibj16scg50g28ha5p7yw2csjh8xglqnjfylg2xh8j5g5c"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "1acxvh7g13jq411w3msysmc4ygd6ciw24piprj8zb8vknbrg83z4"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "0saimrqmfg613bpbqsy9f40x8s2rjagzx4x180p3gmwf0sl97qrj"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "0vz8jk7idghnljh8sadl260ndjjnqf04misx1bp847ld0nik97a2"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "0kf5s7gra90g21pc8gimc14vqj6wc9rs5lhhmkpb3w6mr8h25cwl"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "0484f09j66f2gmr4fdsn79xw1mxbvi2b566d6z8kf1702jmd0i53"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "1r6m0933cp0j57lywgaz3vwiswfd04lyh24jxsrvhd62ckywsb78"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "0fwmwpjkv7s18xizcj7psyhm79dy628ksq12hd8w3323rb5696rg"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "10y9rh90a0acqalv348fwf0bx3xlnjya0ni559xi80armbi78l3k"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "1az0l19syxx5nfn3ixykhy43r9hkhwimxf3l9ww60nxhbkx6v72q"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "0licp7y73lkfkkk9zyks5rkahrh3xn0ihz0cs3dvvc9vlnndcnmg"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "166sj8yw8cjnxivhgdwrl5z30wc0004v4gx6k8dl7nr89y71rcqv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "7.0.5"; sha256 = "16vvzp7355l4xi87bq83yvv8s358akdncfqfjk7agj03vbx0qay9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "7.0.5"; sha256 = "16vmhn5xpnbajqbsxd79bppwjyywfza20fkzjd93lsgl36dnxbq9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "7.0.5"; sha256 = "0b87x1r9103fwg3bg6y42hgv4dk40kgysnvksv3wssd9m40v3kqf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "7.0.5"; sha256 = "1pjcd3jnsnsfj1bl60nls8mjfpm0p96jj1jia64l3mfv9lsrgd7v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "7.0.5"; sha256 = "1qw07w5qll6y8rdids8bv3717hmhcv69vs7xbgpddh7ag0xxihr7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "7.0.5"; sha256 = "1sam55nhsa0q6npcx2qa2q2rfqss3lk27djyhp4q7yazsnlihq1d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "7.0.5"; sha256 = "1xdgcrvfiid1njq61cjffhifkw2ix016sz2msfmlyplfmcd9lys3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "7.0.5"; sha256 = "0r6h1rnxaxfalp6msk8wvmlhi5k5gv385c66jgw7vvvq05kq6gk9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "7.0.5"; sha256 = "0bl7ck3hxy34dalpahb0d83f5w1lmp36v0jax18x3lxbn3h5npn6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "7.0.5"; sha256 = "11x0s7zjx7m3q2w0l4sp0gpwzbya6f06iagzkj4y0lm95xsx7pik"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "7.0.5"; sha256 = "1k142050w7m7fqk6cnpa2iin8zp53cq3xfcs3rqwh4g4ng9dzgpy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "7.0.5"; sha256 = "1ap7qlpb2wc5igh08q71i5vh8lgd5p13p9pzz4vpk6gwfqlyiwa3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "7.0.5"; sha256 = "1prrsqcc4maihmgzcc8n9z5qv32svfr9ambfaka86svngif61m28"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "7.0.5"; sha256 = "0w5q19af5f47r8vgpsvh3vxci75v1fhh0hkp1gqj2mrbb3qydnd0"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "0hbndgxbg6q1zwanjl98ybn35w24592bjy935pdf5wa1b7sv1h11"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "1jbvknhwyrpvs81kpi1lbjxlj0zh8nmz61jz7b5dn63ilf3mx9x6"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "0jgzf9dh8zar5xi99qw6qi4yx6cgpvd9g9xzj0yis7cc25h5xbpf"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "0n1fajdm3a925bvzy23g1mvxrpch1v28qwin62bbnl21zk41k7f0"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.5"; sha256 = "1nzgry4ckcbsk36kmn2vqfds4ldqk2hqlkyrm1id12mnxblcrih9"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.5"; sha256 = "0467y44yygx4jia9zmiv63lfn64j7dz8hxn0i0arrw0ai59fzdcz"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.5"; sha256 = "1rzyj8bgcg01pqkww3d2sdv4fk5hsq2ir91xm4kbxkx60zijqfkh"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.5"; sha256 = "0rjz1m2vxw977gl59jdgxzq91kap30jcj2wdbn702im5m1262di1"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.5"; sha256 = "1w4aazcr0qc7sf4mxhkpp1d3x1yvgxwq3i9yak9a94a8mxx9b042"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.5"; sha256 = "1i445i4i15gqa5b2gl92rlj6zww3iwzpx7a3wvjdaf7pyjwcxfd4"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.5"; sha256 = "01bri3hdl9xqkjr8c8krvi2g64csp56jv91rxfspsvy8s1j7mbkp"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.5"; sha256 = "0abidvw000x56fw8vk39645ywynip5rlpwg3ahn4bazm6prjhah0"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.5"; sha256 = "0qwnykfvf136fkzn9iipxmzkrik27xd3zr210jw1m4c2wzd3pwls"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.5"; sha256 = "0330966bldi7x0vxxfl6bb8pd5ysyyvcmn5ll58lwz9b8ihwqji9"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.5"; sha256 = "1fyhsrw7zraf8ml0ibqi26i4y76a5i7hm7155hrlf6g2wh9c2wni"; })
    ];
  };
}
