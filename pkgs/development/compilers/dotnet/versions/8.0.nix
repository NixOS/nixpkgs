{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v8.0 (preview)
{
  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.0-preview.5.23302.2";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b95d1c31-20bb-43ad-a6e3-7d14e955f759/003b3b17dbbc72ac8ee66c54aef85c04/aspnetcore-runtime-8.0.0-preview.5.23302.2-linux-x64.tar.gz";
        sha512  = "e9d570ceb193ab9a3e0b2ec3549bd1b67555ed4a333a6654ca8e4020bc38f42eadf3a690f996669c24af428222a6bf989b17b8cc0f7f276db928b2a40a7bc049";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3a1b9bf4-f6b5-47ed-b325-38e31af9f60d/dfa9cbb848ab710dc162b5cff1f26f2d/aspnetcore-runtime-8.0.0-preview.5.23302.2-linux-arm64.tar.gz";
        sha512  = "b54203fc664d4390441278e1917fec13466df174672622740509ca973811cfa178a851ac930c6d0cb03410bab8f630f4dd21609d2d8706f8b64bc23fb88a1836";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c588c5f1-58e5-4cfe-b1a7-622458123783/42b3f9e884a7e995da49ad847ee8ffe6/aspnetcore-runtime-8.0.0-preview.5.23302.2-osx-x64.tar.gz";
        sha512  = "76da6d5bfaee0779aab41eaf2ca5759e2f0de919f89446883f6d8d46d4e1643fc9aed2b6095e00aa81ad05dc49c76ba2dc3ab09ae4fbccc7596b6977e5765ea2";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e1fe9f3b-448e-4ed8-85f1-9ab58c51438d/823051b4bdaff6e19c7b78bfbaa1101f/aspnetcore-runtime-8.0.0-preview.5.23302.2-osx-arm64.tar.gz";
        sha512  = "ead98dd5d81efaf8b80f2c9223f55557a54c30f32118c778258ece80e6ff3d63cb55af85e4a1e463d88f356f54d790af35148b9025a9b86147bb6c4a3153b950";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.0-preview.5.23280.8";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bbdc7ec0-d87e-4b6b-bb3f-9dbe5db3078e/6cda9733bbedf8f4fb9e18829e301051/dotnet-runtime-8.0.0-preview.5.23280.8-linux-x64.tar.gz";
        sha512  = "0fa3d9bef5300533b4f266fc1983c7bc8eb55c6c9e8ddf86978a3adb911663a2069c9ed9e428f8d2361558a40edef5bfad6ef75ea2a728cf700a23cd38e7bbcc";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c5c38c9e-775f-48e1-93db-bdeaccf15876/be5113d9c28eaa96d6317bc6e38e9528/dotnet-runtime-8.0.0-preview.5.23280.8-linux-arm64.tar.gz";
        sha512  = "e53ea13c70b4d358b3a313b3edb6e160a3453d62eee76b13c9f4bbb01c79eaf5a1aea9afa3b565ae9adb74f3f674fb5db9135dfe6cbc1be03b34a8d6288b3965";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/07613650-5f43-4792-b975-10fb0dd512b6/966e29340d90ab182f7e73925cf46d28/dotnet-runtime-8.0.0-preview.5.23280.8-osx-x64.tar.gz";
        sha512  = "190b316c22a833339d0af75b80699a50049cdb4ba0d3f0b0c5e2eed28900930ad7d6043f884ec01cc4406c620504f30cabaf3e3e30bb266e591eb34f22876ed1";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/620a82a4-38d2-4967-9076-388de70cefaa/9ae3a2b33a9df5b312861995b0bcb08b/dotnet-runtime-8.0.0-preview.5.23280.8-osx-arm64.tar.gz";
        sha512  = "7c9a2086b05a8fa90b6077d3627d1afcddfd0977d3203759a66da3b0784cccdd88f1cc3c559b30f18d4892ee7cf9957cd0ec61eeb30a30532988a78146fa6bd0";
      };
    };
  };

  sdk_8_0 = buildNetSdk {
    version = "8.0.100-preview.5.23303.2";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/07b027f8-4ef8-48cb-becc-132652c625bb/441ef662adfe931013745df24d53b26d/dotnet-sdk-8.0.100-preview.5.23303.2-linux-x64.tar.gz";
        sha512  = "dfe2085a92854a5cee84cb7be9344368f5dcb6333c4ca215375a34b862f3a3ee66c953b9957f7b46f6cd710992ee038f6b4c2bd16464b4a216a1785868e86f7c";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/93db1aea-6913-4cdc-8129-23e3e3de8dd1/4a942a2fbbb6ca6667c01ec414096ee0/dotnet-sdk-8.0.100-preview.5.23303.2-linux-arm64.tar.gz";
        sha512  = "13c6c559646c359ce07584328ef2e5cf5cb70371197deea9d31caee249c45b07ec1b874bcc5e3cb3b601b5ae280883cda555fd4cd2bf4a255d3be431574e46d6";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/47115ea7-dffc-436d-a0ac-e7445a932d12/b59ac26284ffa2162139c21052feaed9/dotnet-sdk-8.0.100-preview.5.23303.2-osx-x64.tar.gz";
        sha512  = "f4f42021b88abe1adae7aed539ad0b31ad524a7f2af79a974030bfc50aa8b2e9424fd5f38cb25f40277eb9b0a76f68255e7a97058bac49c30c20a72ddc59d0bf";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/078ed12c-82d5-486c-85b2-5f4ed34ddf34/a314372565e2e62d8de3497118a41888/dotnet-sdk-8.0.100-preview.5.23303.2-osx-arm64.tar.gz";
        sha512  = "2b3c95d41fca29b6c3812d47561b14d312d270b599e88a8c02918695ec285d171ab69233567c11820bdc16fe03dabd33d23fd6fd8a987ae36f33f87e59b89f27";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "8.0.0-preview.5.23302.2"; sha256 = "1944ynm8cygvnffrrinpdk3xpa7dg4kzknhgjncrmydcz82chv6b"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "8.0.0-preview.5.23302.2"; sha256 = "0i1aifdn4zig99gj7v4113sg7igmd3n44p42nf91m0gpsxb79gmc"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "8.0.0-preview.5.23302.2"; sha256 = "1dqmj5ahlrqn4vymmww6lsca4kpr8a3pihddh78rwxwhgd0dg683"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "8.0.0-preview.5.23302.2"; sha256 = "168zcrhcyxgbmjk64ggg28c3j55fj1hrzdihprq4w5cncmi0qgsx"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "8.0.0-preview.5.23302.2"; sha256 = "061ss2psdhfmn4wh7i5cghk49bawa4qsw9qhlaiqg2815k2l3rr0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "8.0.0-preview.5.23302.2"; sha256 = "1jm2gqmyk86qppbrr5sl9nf7wh7wgw832p3nmsd0l8by3dnz3cwb"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "8.0.0-preview.5.23302.2"; sha256 = ""; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "8.0.0-preview.5.23302.2"; sha256 = "0pwbbjcwvim69maj8981fnf4v6kmd5ql47a3kadj7y7c1whcg41x"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "8.0.0-preview.5.23302.2"; sha256 = "1cnryxcs0dwzgxpfir3ibi762xrpjlzgxjsagzsmda5y766xkx8j"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "8.0.0-preview.5.23302.2"; sha256 = "1g66zixb90y1qnlayw8cjqdlj6n8s6d4b3y97bl7khrdpp0dn99y"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "8.0.0-preview.5.23302.2"; sha256 = "132fc74r5cviz2057bqpwpk56nwjykh6flliavx2lr5dpcclk78j"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "8.0.0-preview.5.23302.2"; sha256 = "0m0b5lppvsy5d76zj5gigmssiv5yl36xb84f7hn0wzn4idg0zc97"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "8.0.0-preview.5.23302.2"; sha256 = "1g92v7axzr9lm2zl29hpcdjas9yvqpwjx8r5zs18w20iykjz7dhy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "8.0.0-preview.5.23280.8"; sha256 = "1p8xk4jsf82fnlfn92fg0mxmrvh6fhnv04vbvwl8p2145sqgzlr4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "8.0.0-preview.5.23280.8"; sha256 = "154njplr7vqh3arfg4ygn05z8cwyl5fdr635n704h7p6585dw7xr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "8.0.0-preview.5.23280.8"; sha256 = "0zika3kzi18xj37sy3vs99ypigqxrsvqykrrk8gjnls1dfrgk1gz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "8.0.0-preview.5.23280.8"; sha256 = "0c34kp92s522f3x2fwyvixrnpmm92wc3giw9da9f0ihga4kxs62q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "8.0.0-preview.5.23280.8"; sha256 = "183lndsg4x0agi0c0jvk88dv122l4hm23fy8wy082iprbdjdfmvw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "8.0.0-preview.5.23280.8"; sha256 = "0i5kl7gkhn7zpx70f3sygcmbz945f71d9ama9ikb0bd8w316657b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "8.0.0-preview.5.23280.8"; sha256 = ""; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "8.0.0-preview.5.23280.8"; sha256 = "0if1jkyj5zzsj3v8xramk18hl1arwv14yz17sylac0zi92fa1hy0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "8.0.0-preview.5.23280.8"; sha256 = "15h588yv53panbc1gbslizqr4144g9a5bfjyqcksi5qdh70q0wcd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "8.0.0-preview.5.23280.8"; sha256 = "16m670bnlql1fd3v9xkd72fh8gjdm5gdxflbg0bka17cdbsl6c3w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "8.0.0-preview.5.23280.8"; sha256 = "1p2cf5cbb6rqnsrb1ncaw2rxydg3f4ldcyv40h0d8lqypymlxkfb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "8.0.0-preview.5.23280.8"; sha256 = "1lvk6ysazcb6jd51mpwqbwqj05w0rknbwr78wdwi1bfsqkj850n3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "8.0.0-preview.5.23280.8"; sha256 = "1101b3hl12v0p4hxciylb4sx817cjhwlkibyrvq0rcc59ph9r3bi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "8.0.0-preview.5.23280.8"; sha256 = "1cyvbp2shb8jcm9vcwn9ipgqsbqvwizny40yq12lqis6l2kjxdlk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "8.0.0-preview.5.23280.8"; sha256 = "0qkmy9p708f31yyqmc4przb6vldraasilivpgp4ci55fgv7gqphm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "8.0.0-preview.5.23280.8"; sha256 = "1ijv96vgfidkxcfx8yi2wyf63srld7gjb7d73h8rhimfa6sg3fa2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "8.0.0-preview.5.23280.8"; sha256 = ""; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "8.0.0-preview.5.23280.8"; sha256 = "0azd1hdhnirgqc3q06qrqjxhidk9zj9jqj8nlqddp06r2ql8jki8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "8.0.0-preview.5.23280.8"; sha256 = "0293dg11f5kbsapp6mq5bkqfv2jpsrv7xw62qvmdn0ky3zfjxls6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "8.0.0-preview.5.23280.8"; sha256 = "1d5z1facifk0q3yk7kx56y91a4gqs94q79myxlrc6zxs204gfywp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "1r754iznmx0mz99qifxzm2asm76j8ykmjxiqxbj1y7i525s838im"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "1zgyav841b3nwdy2shlda26r1zizprzjrjj731c78drr1ihp0iga"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.5.23280.8"; sha256 = "0ri3fqfrgsl95ya08c99in1ig48m60p326i2dj929hfj9yikzwly"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.5.23280.8"; sha256 = "1k8vzl18g8hclpgd7sy2s5n3ixfnv17csp9akf7nis0y493s1gbf"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "0am2i1k527887qqyipwzg0idss5sscah57zr3fvldfb3hxx5xm0m"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "08ghakmfzjjn2s4b3s73zrr6g6akxfib4lx0740481abzq985d8x"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.5.23280.8"; sha256 = "1n8ip4zc6sljknl3pk8gkw4rg8ajmnc3qcrivs0jlz79kr95vxds"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.5.23280.8"; sha256 = "02n6psqh8y70v5hgw4k6w823dx4k8iqfp137i1xgxwjmijm7c0sm"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "02wgvv0gvhgp1z41rmb4g5d4ld0b8anwahz7514c7bqlk3gvmhaq"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "17sm055xml4xfzdbr5cxi546n9gfacz1q5mjznzvng290ds9y34l"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.5.23280.8"; sha256 = "1xr3plgr99423psql74hs038lckf4h32ngphsa2748c6fhck7a43"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.5.23280.8"; sha256 = "08qg0b05wlg6q414fha9qgxsby00mm9qs5r4i2lr250klxih0vbm"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "1562mlps4z2n3vjmvvw9q2chxay8chi45ggsfkj2bdg6fmsns8j1"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "0rd3wxdmlcj9h5n2jlvmbk2y8qf93wy4f85z6amlzsqkk6pgjxqv"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.5.23280.8"; sha256 = "1s02wwn7jc0a3fa73qyx3hxvzy3f93jknsmqs26frg5bwnj7sz79"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.5.23280.8"; sha256 = "0abyyqcx4ix4xw7f67dhhdj2dpiddsfb6qpd4qqicfd481nvp6yd"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "0bfgvcrhgzj78chnnapg5mzkzwyl5m3z5arrk4h31vg041xiamx1"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "01dlxshx6riqj03j8cyy9w5i20dkzq2zbvh7av977d465rnyzvak"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.5.23280.8"; sha256 = "1p1xvc15fvvqmmyc55xz3plmdc8j7zvr2z61ngzr6y82grm782j0"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.5.23280.8"; sha256 = "0rva3jjas2fiz643fgc4nhl82l79gws92jwipp7dxq4p7psn93m2"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "1xl6ydjv0icj6707a074qc8b2rh2gfq1pibplvnpr3j04hvi3wcc"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "1swijczxc4g3rw49ki3ll3b5czm3pahx4x2893sdigrc54xhcyj3"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.5.23280.8"; sha256 = "1gc9rvscpcbv7x2v5j3bvjsikldkzhwhz1d0zszq4ha0wccijqgf"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.5.23280.8"; sha256 = "13g0vkws6acsbg9nq7y7jcmw0p21w8vsj5clw1r0qfwhbypx3gwy"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "1nwg176lj8nahsqzffdn3wjirbzfqkjkh940i2jcv621318x1c5a"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "1kwd8c67wnv2xl62vaa5fd6dpxdcf32f1bhmzqpk2j4xddjp81p6"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.5.23280.8"; sha256 = "015xh2077rd65lmg2a21x8dd67mqbmxna3jn0fvkhjir31sga18y"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.5.23280.8"; sha256 = "19694r5gr0l5ks1wa76ip9jk8kwbmppc4dk9jv5ppm82ya30mjdv"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "0c1yrywmndbb0ckda5nl69xq2mpkmlsz146s55mbd9hil8s4sr9n"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "0sx5kyvhgwm05djwqglccwjqnwjglwn3lbh81q8nhxx0m2l07x7w"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.5.23280.8"; sha256 = "1xffjvnc64p23fm7alxsmgrga13xx20ixmllrgv0gnxqbbd192im"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.5.23280.8"; sha256 = "1lw0dj4gpd668mw2aw880zq76yxnz3d74whx3dlz8r4119r6xp54"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.5.23280.8"; sha256 = ""; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.5.23280.8"; sha256 = ""; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.5.23280.8"; sha256 = ""; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.5.23280.8"; sha256 = ""; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "11f12zcrj9hif65ai1ifmrxy6in49fyjvf30xh42iv8zzp4b2fp5"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "1avarzaaidy2bw44cd3vr9yzjfc6d4i2h8ar8z57bj0y69c7sfbn"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.5.23280.8"; sha256 = "0vblvvs0blsajd01zhzgyxpfdxjz96715r1saz7n66k2v3n22qrf"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.5.23280.8"; sha256 = "054d7gqm4w1svfg6g90gnlzijmj4410q845a095lcs8arg5fdw7i"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "00hk4zp2cccxzw87fw1qn59ikd6276wsi46qagg93lsrvm5i2b7p"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "10g16wjyl7dzx1al0jhxc65fywbqs84b0m2gzbcwp84q7fn2ap3k"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.5.23280.8"; sha256 = "0j4876vm3jws5ndyg5cp3qlrlpwgv31aijaxcw8nymrxhm0afiz9"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.5.23280.8"; sha256 = "1wz5pvisa22wd2gbd5s70mfnyvrj8jcaz7bi7i9lblsbac63vs34"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "8.0.0-preview.5.23280.8"; sha256 = "18mrbqsawj4r2vw2z7w21vl5m27dwx8zbd4qj58yjv9fcw8lnjgz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "8.0.0-preview.5.23280.8"; sha256 = "1a5mil8zzp6jrjpjj15mcz2mahpj6h7mlqbqygzc7ky5gdzfx7kk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "8.0.0-preview.5.23280.8"; sha256 = "0z73n85psbmcm2gd5fxicr0zb3nz8hgbs2g961zn9bf92668bp0s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "8.0.0-preview.5.23280.8"; sha256 = "1qz78a9d5jcfrkcb1ifid65p91h1xxkn32ssbmqprzzx394qnj56"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "8.0.0-preview.5.23280.8"; sha256 = "1d9nzpn3rg8rc3j1hgyafsqjnq5iigwf57waqa4v07vhwv94l2gr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "8.0.0-preview.5.23280.8"; sha256 = "15zwam01k50f2hcy8aj3kj9wvgdvpccvmkin8lq4a5c1hll8867m"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "8.0.0-preview.5.23280.8"; sha256 = "1fswvdzw646lim6z1sj5nf4ccmzv10b6kdywrmxfdbdbc5q31672"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "8.0.0-preview.5.23280.8"; sha256 = "09vd8j32qhflwy2s0xb8mrkidbq1bvkfysb59js7wbjn6fbaqi55"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "8.0.0-preview.5.23280.8"; sha256 = "1sq4rvvwd616vsdw8slpg06lkkdp0cb55g67zz0p8bbiqfzclwc3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "8.0.0-preview.5.23280.8"; sha256 = "0pgsh0qg2hb99hjcxfkvj238g81w16lh3dxl1qvcw9ldi87raskm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "8.0.0-preview.5.23280.8"; sha256 = "1frc2m51qk7ymmygg5dqwp2jfnj0x0qsflmasvwx69w21ncsjp9n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "8.0.0-preview.5.23280.8"; sha256 = "0zps8ackfk4g07395ywybcr2bsfcfz0asc3ps50hwv8mrfxavfcp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "8.0.0-preview.5.23280.8"; sha256 = "16jack7jcy4vg05949l5j2ykc5g12r2nbcgkrkim094a6cdfnnci"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "8.0.0-preview.5.23280.8"; sha256 = "0r9xl99m3h88l8xmsh4lb4wmf5n9kbdhv2q98rl6r6ggdcb1rwz1"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "0v7n2a035ipylqadcm9xnxsnx1lbiwip6m4mwl2gl5b7ibx9n509"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "0h176skavpcqfa68l4vk3yy9axq24sc661azcb7i6cpjb0scdcb6"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.5.23280.8"; sha256 = "06lbqcig7grq3g93a754q3bnlrmg4mqr3wi6xxhm0x7k0sxa71hk"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.5.23280.8"; sha256 = "0b68cjjpja582xfwm3dk722sjj88ri5vyawvgrn8lkdkarpcmjna"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "1l4pmphc50kciz40w9pggmjsmh3bzfbla76fp5p0ppms0xafkr1y"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.5.23280.8"; sha256 = "13iavci8n0ahsl5k1xasribk93gmkxd3s67xgagasc1gzpkxm8q2"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.5.23280.8"; sha256 = "16aa6sgblm4l1fzsgllmxsxn57qnx430z12n6hm3m08qrlmcpyd9"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.5.23280.8"; sha256 = "05k0h0p6yc02np4m7jdhmc8c2105b22wdldbsklx4rl3jqy7m6p3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "8.0.0-preview.5.23280.8"; sha256 = "1yvaiqblqmsrydbf9gr18rp6d9rqqpzahzxhc62hixfh59l55mi7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "8.0.0-preview.5.23280.8"; sha256 = "06i72xhd0ji755wj8bczv8x8mynyf2kxhx7ysn70crrkk0b7921h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "8.0.0-preview.5.23280.8"; sha256 = "02ks9j1mybb3f34mjky09nw22la6nhfmkjj5g5gczspqfcc6a2dw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "8.0.0-preview.5.23280.8"; sha256 = "15plhhljfyaj0cdpsqyq3n0q747p90nvl5kwj6amccadkcy7ahnk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "8.0.0-preview.5.23280.8"; sha256 = "09vvjm9a7nh6bd8ldf1f0vz1iafp4v77q5d78382hfqan8r505id"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "8.0.0-preview.5.23280.8"; sha256 = "1p21siacj11nbba5czcg4ppk7wny2p3rc2wxg30vs1jj45qvf82c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "8.0.0-preview.5.23280.8"; sha256 = "1h6xrjvgn0bl615bwmr5l5gpw4qxhbzsqd7sb57m8597cjqc8m35"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "8.0.0-preview.5.23280.8"; sha256 = "0fymmvixx0wh1qa5hrazfr27n0hr3dj1gppipy3mslm325m1zdf4"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.5.23280.8"; sha256 = "0z6cny0jzbwd7skgc3lji00j1z061j4yacrjbhysnq5z5g563r75"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.5.23280.8"; sha256 = "0f72algnr7kknbvw1b17vlw6wvkghw8v4n9fji7ppwbrd8g8i8b0"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.5.23280.8"; sha256 = "1bcps96s8n5iwshxjqwbdvhhr5nkh1f1hn4k79gw1q8ic1c4giq9"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.5.23280.8"; sha256 = "1zixz057s0c282v404l8v3da2dag1cwk79phfv5ps83n4mypzpfb"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.5.23280.8"; sha256 = "12wia5n3kakcdqgj9r3hb9qxbrlcrpdfvmy0yml23cxhqsy8ny92"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.5.23280.8"; sha256 = "0r95iysm08cplqwxh7mm81ji13414nd0shgi7jskspqd2cjmcknk"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.5.23280.8"; sha256 = "1w1jzv64d4ijr6g3sb9w5im11jxxssyqwzas6hycvzvjyxb8f3q9"; })
    ];
  };
}
