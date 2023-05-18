{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v6.0 (active)
{
  aspnetcore_6_0 = buildAspNetCore {
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
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
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
      };
    };
  };

  sdk_6_0 = buildNetSdk {
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
    ];
  };
}
