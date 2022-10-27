{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v7.0 (rc)
{
  aspnetcore_7_0 = buildAspNetCore {
    inherit icu;
    version = "7.0.0-rc.2.22476.2";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/eda5c509-4e42-48b7-95dc-0584b0645d20/2e6219b8fc0873628b9cd8fe9c726b0c/aspnetcore-runtime-7.0.0-rc.2.22476.2-linux-x64.tar.gz";
        sha512  = "1941cd6ea3bea31d970029c34acf0d60b63d1e7fba39086be1a79177a6f87f2b0300bf4008e96a5235d52bc74a41503b21b088143cd306058d42dd3ce8252af0";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6a9cde74-7514-4609-8f87-3d932052bf7a/c8b037945ed4d2b1afc52661bc32a93e/aspnetcore-runtime-7.0.0-rc.2.22476.2-linux-arm64.tar.gz";
        sha512  = "24fb13ed26a44d6fba86a2058839026ec81868143a5b7af7857b75a004b0c64eea9a3e544f9e0774b761f9c911608ac74237b2d63ba6799718d12915d5d32df4";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7b6d123b-4968-49a9-9209-38eb39c893e4/4a870b64b1c32f3c26531532090be743/aspnetcore-runtime-7.0.0-rc.2.22476.2-osx-x64.tar.gz";
        sha512  = "a8799dfa6efb4dcecf023de5d666969906b7b5c512a9eb2e76ef12cef6ff5b63d84e3b9b2ec7573ca3ad1b7dc1f21885974a7bd10d3df807c009c2b02440fd34";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/da2c7570-ae74-42d0-84bf-b059e8635fd5/6db3247d25a867adee6a3d92a437520b/aspnetcore-runtime-7.0.0-rc.2.22476.2-osx-arm64.tar.gz";
        sha512  = "3ebc2f205920b9955ef5d30e02d659468beee68271e54fbc6e4afa5aafb98effea6f642e5086801708b5dd35fc6c25aeeb9a924abf8cb4f6a6c0a44d3c16d025";
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
    inherit icu;
    version = "7.0.0-rc.2.22472.3";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/627fb71b-ed0f-4c99-8566-4157b78042aa/c39f6d133cc76d02bd4a165415c030ee/dotnet-runtime-7.0.0-rc.2.22472.3-linux-x64.tar.gz";
        sha512  = "2294605e371ec575e59baa1eacf973d7dd6761d5d161f4988ed6c51d5db2795a4dc95709d6eaf38ddb2caee6f0551225b49be5cbe42233c2ffae3a0f63d4412c";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/fd677894-fe5d-448b-a1e2-a1abd577a1be/33c3573a28596dfa7cdc73d26a3c7de4/dotnet-runtime-7.0.0-rc.2.22472.3-linux-arm64.tar.gz";
        sha512  = "cc1f37687745a3aed3c161415fa57dd8f151f515fb2a030c6b2e600942d188837398038d81654a1137bfafc5e1733e351e7c8ea04678cd2457d6620a3381826b";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d9a3c643-0572-4571-bf1f-c3f5c6e9f8d6/6144f6fed64492d647741ab3d157a4b7/dotnet-runtime-7.0.0-rc.2.22472.3-osx-x64.tar.gz";
        sha512  = "840835baa12d79404ed1ec59d33cad5d61980dfa2f596f0da56e421ba20f0ec8a91476e4f4b92921cab9c0c95f22f8989dce6394e8f4b3701a54945829ad4a91";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/23235792-7d1e-4b2e-a2f1-3b7069ec6573/eb140f4236a01e8ae3b6d8faf8f542df/dotnet-runtime-7.0.0-rc.2.22472.3-osx-arm64.tar.gz";
        sha512  = "1a4374c3e01a1204822da82be919ce5e3814e54167f78410b23e85e10e8df16f84340588f6b3e3e24eebd762ad4545cb1e5ab8fd01cf8fce6f25fec71701945a";
      };
    };
  };

  sdk_7_0 = buildNetSdk {
    inherit icu;
    version = "7.0.100-rc.2.22477.23";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f5c74056-330b-452b-915e-d98fda75024e/18076ca3b89cd362162bbd0cbf9b2ca5/dotnet-sdk-7.0.100-rc.2.22477.23-linux-x64.tar.gz";
        sha512  = "22db5d1d16f6fcedfc46f87896920425b5d9b61d09c47d254d6ac731c6d853657882b21faf21f313ed20b33e6331d01b9f723b2c586f0e0cf5acc5ed570b0260";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8eb03851-3b65-4116-8d6a-f5665e88b90f/901ff01f63c7dd06c3550e0a0cd15587/dotnet-sdk-7.0.100-rc.2.22477.23-linux-arm64.tar.gz";
        sha512  = "bd5f6fc2bc6783bcf71b4a5c274b2e710336fc031c2577f5ccdb9be2679ce8b15e40fb8e631e2dd18b2359396107fe44d867d341f6fc5daae165f8f238adee17";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0f93024c-7a1a-42c6-a085-50bb1fccea6f/09194b050530239bbc2cdb3b9ec4bdce/dotnet-sdk-7.0.100-rc.2.22477.23-osx-x64.tar.gz";
        sha512  = "a7ef37c576e47b6734b1d58037de8f42e9e20c4e65ce7a213c6e306a68ff426fb2d5e5b805307775e481c35320bb33f6a62b3a2a97ddd35637134f9798ee610b";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e9a9a239-5430-4a88-941e-0c63ffe4ff42/18dc8b8b1cc2010fde2c418a85a96e70/dotnet-sdk-7.0.100-rc.2.22477.23-osx-arm64.tar.gz";
        sha512  = "f7cc6bbe15784f6587c40db2ac043b410fdff764f42fe0cd85a6eba863b201f6bb50b4029a6316c276c0165448c00719768211b67908ee27b7186d18d3431387";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "7.0.0-rc.2.22476.2"; sha256 = "0h2l8yap76j51rlgxq3c0xyan4w6qlmpmd5j61208qkhz09kvcb4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "7.0.0-rc.2.22476.2"; sha256 = "1dpmihfj4rji4j4x454z262dc6mw2wbzq2gkxgkh81gp5b0lv9id"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "7.0.0-rc.2.22476.2"; sha256 = "1c7s3s9i75sxaqdgaz4rxzvyn7bxxrp1vjxarawr6wa9j5k7zvqv"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "7.0.0-rc.2.22476.2"; sha256 = "1km3ys2hwk84sz9ym68l5hcm5dj04incpk0wkj4a80cbqfz58yqy"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "7.0.0-rc.2.22476.2"; sha256 = "196x89hhn1c10rk2xk3jbvnkfiw9qk8b82ms3rbmn660y6cf2z3n"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "7.0.0-rc.2.22476.2"; sha256 = "00hb5pa63fx5qwdb8zlfbgpg346q3m17sw1rvx2bbk3c41lf3mdz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "7.0.0-rc.2.22476.2"; sha256 = "0skd2hy9rhiz0j5zcznvaq2dbyd874c3fy9csmjryxq0r3dlcgz1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "7.0.0-rc.2.22476.2"; sha256 = "0gcmw3vzgbqfg2s935jm8p4bs8xkd9iynwimqpg8lri5scqgckr5"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "7.0.0-rc.2.22476.2"; sha256 = "0snr79gymyk4cmrna2b85kcp9khxkvjmhyn5glhyqj4lz26bbfvg"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "7.0.0-rc.2.22476.2"; sha256 = "02gzw3da5xvlds81ha82mw2aqys9bfafmpbrniz25qyiram49vcp"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "7.0.0-rc.2.22476.2"; sha256 = "0qrznlqilm2yz3akfy0ind65iyl0c4hmxjvlkhh4cm97621p73f9"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "7.0.0-rc.2.22476.2"; sha256 = "01s5wwfma1mzkhlyk31b1mw12k5ilbfq97apkxsxvh85i2vs459h"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "7.0.0-rc.2.22476.2"; sha256 = "02jcl0k71sxvfg573l59a0wypjlhx5bpz9782s2g1q74dnprx0a9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "7.0.0-rc.2.22472.3"; sha256 = "1iysxmdil6pqidyrxgpcvirg0qp0k6b3wpp9fik2lyr3bp8khpks"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "7.0.0-rc.2.22472.3"; sha256 = "1ckzw6p2ih8h9050avq906bchsz19rx1zwnvcvj7a92r2bh92129"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "7.0.0-rc.2.22472.3"; sha256 = "0vk14gymssb6rkcwaagwf3l28j9wv4a86j3gfsj4mqxi89rkwrc1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "7.0.0-rc.2.22472.3"; sha256 = "0v06906mrbj28c202zbydc8zbx2hldcrqx6jbh5wlzhih5mfr149"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "7.0.0-rc.2.22472.3"; sha256 = "150kqnl9v8amydz147h38vagnczn1fpz2gmx70c92l3ypqakrfdr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "7.0.0-rc.2.22472.3"; sha256 = "18ja1aarvq0vs3jp389sskm6mqq7lh0dwahmg17n0c1p8j4zd3wq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "7.0.0-rc.2.22472.3"; sha256 = "1ls11073f3r8yl07fs5y86id38rb726780r5fxcjynkll74m0kwm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "7.0.0-rc.2.22472.3"; sha256 = "00iya8nvkh8r0bfch9r28spgha1rf6xn1756flg0jfpnmnd53xb3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "7.0.0-rc.2.22472.3"; sha256 = "1z3qflwh3m3g0m0lvdzsq3gafc8i8d2010l4g09w2acn200510xg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "7.0.0-rc.2.22472.3"; sha256 = "0p827f73nbcv288wy5vqiq35kxk3y1dhi7f86gzzqarp7cbfzzc4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "7.0.0-rc.2.22472.3"; sha256 = "01z5bcaismz5c06if7vwkd753dh73q92l2bji3pbh6cnsg422nc2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "7.0.0-rc.2.22472.3"; sha256 = "1fgk3yydfw4y4svpdkdil64bxgaddw8brhgcwvak4904l5bx8gkk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "7.0.0-rc.2.22472.3"; sha256 = "1kxnmb8x1df92wd5n7g5ydgb4khcs5xq8kgkwar0067734k8sff7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "7.0.0-rc.2.22472.3"; sha256 = "01myx9n3glmaw366smqjyf4qy3mz6a07iknhgb3abhl309adg46a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "7.0.0-rc.2.22472.3"; sha256 = "121pqvffcib9wdw4q419b1vniyhak8in4iqbkdjdnijips5jbw0n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "7.0.0-rc.2.22472.3"; sha256 = "1z9694xja3qpfh1hqv8b9vwpsljvv4zl7ihnr8r6l1zwzics9gs1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "7.0.0-rc.2.22472.3"; sha256 = "0pymzb6n19cy1ham4glraj5wmnfz4ay1bbk14x2pqg8nmcqs9i0x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "7.0.0-rc.2.22472.3"; sha256 = "1phm6vs0ihs1i5568s3q7nkmjibzgc0vrp8p9nwizg8vn1bzs0aa"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "7.0.0-rc.2.22472.3"; sha256 = "08xpbxb5mrjscvbbkv3cnfxcawl30p3fnxv0wyb1zg6rdd446f4d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "7.0.0-rc.2.22472.3"; sha256 = "04b817bf4fjaip2wjxhbcrl2sbhisw1mz1m2sgqvb8jzbm1bv08z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "0zdgymm1kn2magcs4vsfzd2pbjy61vs4yc654xa8wy68pchc7yj9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "0hhyz0rlw95qjlzp4nbj9hrri82mqahgky5pd3xmiqllmw53y15m"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.2.22472.3"; sha256 = "0x851y3aib319p7fm4cnq99m9l0mrr55nbx9yb1fwxhv4rfn3jmq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.2.22472.3"; sha256 = "0a7lrbwgil8riyp3v306hr97w83b0vqizb3ig0kpdwbj32zxz3q9"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "1mvapavcy2qzkr94mwfsgyygbwlm4s7b63cmhaz9fj3qhydwdzik"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "146ydx54vhgjaxfpggfch96ai3jppbciw5yvn5r9kx34vbxy2m38"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.2.22472.3"; sha256 = "1ixm57p75h285lf2dcc4fk1gnyjbxnadg3war1a7h6v3whjziwmx"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.2.22472.3"; sha256 = "1hgqb8d4nplrlsl0cza57v4h147kighx742ss35rlw40nn7wy40r"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "1pa8zm0j4zwkq13knvadl8fjdz2ayrx5ynxkjwcfk8vkwzrsk21a"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "01igid2msnllk79qfindhz4kr13rgpmkvpp6w7kcyjag37qsp42i"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.2.22472.3"; sha256 = "0mfyxrimmyv2s0r49l43z42qdp5cww4wxcvxv70lrjp6ysizdr11"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.2.22472.3"; sha256 = "05h59an89c6766jy30v91bfys6lb17lzssqn7kzn012zxnsd612w"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "154k3szpgy904qpk3wb45c7c8r7inhxa9jxvcswpdyi8ybbv4vz6"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "10hzyhclv223d9hbgffzpb0nb63ljkxnbilgckhndh0gfn36hcq7"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.2.22472.3"; sha256 = "1hdkxk3w13pvsg8ai3jd4ksw9q1cwixsf5xnz0ci80b1i7pvn039"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.2.22472.3"; sha256 = "1drnja2lwy0v17swaxdgjrc1xk190yffxpf7q7pg0bd5p7kq45f0"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "1lkn3n8a0lm567f6mwkcffkkf4frxkphf51xkgmkab1sqp4b83yk"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "16ig6ly2j0vfm5d915az2kf9b2cai9argn3smfsqchng49zx86rx"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.2.22472.3"; sha256 = "02g0d8ffxbk7h5034sbw4bmq4rh9dr4vmn74c8mn12bq14pi075m"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.2.22472.3"; sha256 = "1xq0by4s3wfz69cajip7spfl94kgg249vll91c4f597cdfqy7kzc"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "06ibkqbrfgngk850vk23mskhyrf5qd1kkck2nw31bhgnh7bp4ddc"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "07m95mpmiblslrdmkpnzn118s6fapds2fxqvm75yasdrd22biy6s"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.2.22472.3"; sha256 = "1bxxczfbjsyr3hlw3ix3gnmila0csyl799c08nh7aycpqpacr51h"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.2.22472.3"; sha256 = "13l2rziiaxvys31mk47wbvg2c05w456s6adicvk3q985lng1alr0"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "0rgakvawamdjgbv414frsh9pl1qk7fa3r82i66bfqz0ld62rgzjs"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "16g06ahnf9wcr0ahm9112l5b8cv6s22gq3v7jljlpz6wxlbby64k"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.2.22472.3"; sha256 = "15yw6sgmjydk5c7przd2n4fip9wqilpqcm46pixpcsdaxd9xn93n"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.2.22472.3"; sha256 = "1ggzm4fcnsjd8shck75hn34g2flwccbx9d75lp0imbgg49rpyp2d"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "0f0cimiwyk9nr69bcmmvv3zna43zhlh09p997ad9225bksgdapr9"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "12wxfs3r94hs2q90fs4jlq7rljdyaza48lx51xz1cjz22m86bnap"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.2.22472.3"; sha256 = "13bb0z7b77s2dgpjabpvm7xr9bvi0w6n88gnaf6csaxnmnqc9jxf"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.2.22472.3"; sha256 = "10hf46mc65wkfcn4wa7lz1addv0h5v8dl96q32n9k7n3344q8f8m"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "0c9ski0p289zchyyy2zy572c5fpp6q8hksnssjw2s6wg5g6sl24g"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "0d4bp0dw4dm8avw14c5y4y8nqhbgvxv821j7davfgah962yf4cq9"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.2.22472.3"; sha256 = "0p8xdq69q4g3w327bpiwnsnz5c8gb20cfyphp2fjb70vg85m6rfq"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.2.22472.3"; sha256 = "1ldxnabxsh9lnlwcb2w911g0xijm8razmxa0hi4w2avgd9khd7yi"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "0rfgkmilnddx24pkkh2mkxxixmrsj5msafl2snv5xg3k9bbrvjcf"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "1y2yc8a3qkqmclycq41jppi4h10kpsrd1c8iyg8nx63kqsgs9nlx"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.2.22472.3"; sha256 = "17bbhvwq27aiwc11wmdj6fqkr011bn2q677jzxmc9c6ia4qclcw4"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.2.22472.3"; sha256 = "0jacafq91y7dkzq5r4d1pblk4yhg3ckl0jv3w8n0mxscpgcg238v"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "1m2wqbr4rs4pm6qb4kmk272iyrdvqjikfg3zzn1c7cwg4ygkyq3l"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "194k56z5sbkphj1kj0w4v26jvls51mn5yb1j079acv7y6jicvqzr"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.2.22472.3"; sha256 = "1mvhrhlh5rm3i6gysd7vhsxxl016y535mvng614hfxf9b8x8fr1s"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.2.22472.3"; sha256 = "109ry8xzjvdl8na9a9sgisxxbfzan15xmbdnxp4f8xcvszbky99s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "7.0.0-rc.2.22472.3"; sha256 = "1pzhw3smwim5ky5721n5gwdp6pwnvpwkmrn7p3k76pvfbprwivfv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "7.0.0-rc.2.22472.3"; sha256 = "1pgfj06fbj1z9hsid8za68fahgsgk0ra148g3hxaw1d1lidyjq9i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "7.0.0-rc.2.22472.3"; sha256 = "0na88422j0clnv979wkzycw8ic0c04zz8yrp39il5z3i7zi1l2qi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "7.0.0-rc.2.22472.3"; sha256 = "1pxmndnjg59z9iwkckzmbgk1q6jkzvpmz0xn13ljwr26bnb5wg0q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "7.0.0-rc.2.22472.3"; sha256 = "0wpgcssqrqphblazjwhi2x7l7sxrv4w86n961d7npnss77w2s1rl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "7.0.0-rc.2.22472.3"; sha256 = "0ng55x7bcyl71hmr4nfk7lkylj39rsmhjpfx65calmpv9jzcw287"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "7.0.0-rc.2.22472.3"; sha256 = "0dpqz7h4wps6wgr6pri2q9zbzx520fpkm55b42lbbcc9hfibpfwc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "7.0.0-rc.2.22472.3"; sha256 = "1can9ygvw84kkjs0bf2ib1rlck10j1cihi68l3dsxx6cfq6j0l6z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "7.0.0-rc.2.22472.3"; sha256 = "099i619jlil2fcznwccsnmix2zmdyfdp3zxda0iiclvpgk0qxyy3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "7.0.0-rc.2.22472.3"; sha256 = "0b2q1ggx19aby50l7fw6xfw209591xqswhkvbpa69r0hccj4b00r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "7.0.0-rc.2.22472.3"; sha256 = "0jpdyn4izznmchc5xzmsbikq2wnzbxy82n3xpymw2ibs4kwv5pva"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "7.0.0-rc.2.22472.3"; sha256 = "0vwf8q4y5fdxzsa1945hcn75n0xwmcb9ksggbc4jy48dy78fmmwi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "7.0.0-rc.2.22472.3"; sha256 = "08lzffzrik1cmgcwj64qnw3klm0srcnvpjx20llsdxh6f1idfzzw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "7.0.0-rc.2.22472.3"; sha256 = "0y3w0vsz8f6w3pb7bc7sh0k3vx4d9j0rvmx7b9r20rnpzv30nbdv"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "1zjvvwi9s1ahl1pfm89nwng9k2bjwby4s8ab1dfgbdj23rfx00p7"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "1816lyga62bf4xdxf8wxga238l8xmvpr556ms5krcy72yd3jzyn6"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.2.22472.3"; sha256 = "1dh3qfmmhj0flp0zs7qcm4shwq6rqrxb3d2q2hbfdkajbx8s2sv8"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.2.22472.3"; sha256 = "02z514s54l9kwr9y8sqciy9rqs6naw0cs5frvik51lsc8sankibq"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "1f5idviqffi44sxjvsd7m70h8z6c0qr739qrp9iqsvrkh3h2x3n0"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.0-rc.2.22472.3"; sha256 = "0f2pdybhsz5n0xswy9hj0fqkmf9wvq8kbsh2748f9v800knn2pmk"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0-rc.2.22472.3"; sha256 = "14lzdp3nw9z4fcc1z50l8sfp9ygwip6g2hfdvby8zhwgj1b43ryr"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0-rc.2.22472.3"; sha256 = "11bb5x0i5ynvsaymlqxml8zf0jjsmn7nfqwgsj0zycpli76qdc5l"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.0-rc.2.22472.3"; sha256 = "11nr2fwv8fmlhj28ny5i8pbj1dvapph494z9sk11z1v1n2pkschl"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.0-rc.2.22472.3"; sha256 = "1jmab7kgm204m5pla82amwhfbs5x62ndxzqvi09sg132s4dc3qcj"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.0-rc.2.22472.3"; sha256 = "0m4qqqlpq6sf1pnzljwqvv78xr2h6ah5m5b2w38f2kzk5h4ngcrm"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.0-rc.2.22472.3"; sha256 = "1nk489n6vcd307cxcv7ljn3b7xabhlnb2c7qpfw5a5yd5bbv7h59"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.0-rc.2.22472.3"; sha256 = "1l89nlxpj2ac3ch8k4draczc5xvdicxyc1n1vff6irhkwfny4y6c"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.0-rc.2.22472.3"; sha256 = "1abq8jzfnwdabivx73f9lcqcamdrp303gjfvii6kgh3abn7lsmki"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.0-rc.2.22472.3"; sha256 = "1clv15r6c38g1gf88r4v6p0y5lb6mykaxry67zh88vzkwvk02lk7"; })
    ];
  };
}
