{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v8.0 (preview)
{
  aspnetcore_8_0 = buildAspNetCore {
<<<<<<< HEAD
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
=======
    version = "8.0.0-preview.3.23177.8";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e47f5b95-4eb2-451d-8ec5-2e37b928d91f/e386c9fb8185cd35674fe2a44dedb318/aspnetcore-runtime-8.0.0-preview.3.23177.8-linux-x64.tar.gz";
        sha512  = "f990c63e651d71ef615aa494dc555fdcf66411431d07b7ae9bef50f276e863198212471b90bdd86686426d5907d2426924d1a279262035bbf3ce64d8914e590f";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0d98023b-349e-4893-b717-176eab3ca4fe/ab919484bd5a5a981057f60828c8d8d8/aspnetcore-runtime-8.0.0-preview.3.23177.8-linux-arm64.tar.gz";
        sha512  = "c5826d36daa4fab2779bb3b6bb94886bd98ee018109cf82b994a189cd6675b8f14eab9b11fc2a265a7bb3b8dacbe79b75887b1a81ee65c4ca690cef8a27a400c";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/18fcf656-e2e0-4fb0-8141-ffeaf76b2785/cd4ff90bbf9b25d10cdc9fb8aacf94be/aspnetcore-runtime-8.0.0-preview.3.23177.8-osx-x64.tar.gz";
        sha512  = "b8354eccec9c8b77f6afe7b4ff08f300359dbdc6106731b3e5b9966e1060a6def949174de8edfadd4e90a65e3337f2c03dbf55a4a67e2d8dd51446600605a914";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0e9f855d-b7eb-4641-b859-218d7d61e169/c7ecfeb28526a57668f53d7da4fa0c90/aspnetcore-runtime-8.0.0-preview.3.23177.8-osx-arm64.tar.gz";
        sha512  = "9167ae736f29f49522f6263e6b2698b94fb0c4f21653a81a2ee1c8101d3c176a9b69dceed0c832ce04f2b84aa8fe0b14e7dac54dd965026e472429db739ddebe";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
<<<<<<< HEAD
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
=======
    version = "8.0.0-preview.3.23174.8";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6c4d4118-bc92-4601-b42b-2b6e91fc28f6/7b3a642aab860b394982d48bf5681243/dotnet-runtime-8.0.0-preview.3.23174.8-linux-x64.tar.gz";
        sha512  = "d0da20d48448c654ee548668a585b2272c661eb84ec6f845b3a49c0143ba1bfa83865f69da6bb607353a571e8c84b8e63650edf816641b1c5a55fa77a59e09be";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7b272393-da0b-4386-ac78-416ee38195fe/4f0d5a3d43cd7b32ae6051b191edd5e8/dotnet-runtime-8.0.0-preview.3.23174.8-linux-arm64.tar.gz";
        sha512  = "6ec1368fde8d4ffe5eef21e227c93ebe94d44f6bae311c5686d2c710240a025b5bc3716f3ceea18a8b65ef588a811828a0ad8b76db3086512786966fd111c15b";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/962423a9-e286-4a7e-b3a8-4fdcde16d9e2/0b11e7166df8ed292c44d4a7594e482a/dotnet-runtime-8.0.0-preview.3.23174.8-osx-x64.tar.gz";
        sha512  = "53c52fec2fdf5e5cba92f006d2680fa63ae8946ab0a6ec03b4a050e6d52f2e2e94ea01e0b8be63136f0c800907fca6c49dbb180711e8948982205f6c447f9256";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e29d7a01-41b9-4cdb-9c87-640871cd7b31/cfc38e882c713763339265cdfd1e4fac/dotnet-runtime-8.0.0-preview.3.23174.8-osx-arm64.tar.gz";
        sha512  = "73619816e7570bde00105aeba9bd60ddbe868df4d25f4b53679dea01a80d81403215ee7caad7adf7c0128011b687539786e7bb817d652e993064ca5716d1fc1a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    };
  };

  sdk_8_0 = buildNetSdk {
<<<<<<< HEAD
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
=======
    version = "8.0.100-preview.3.23178.7";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/103d5e2c-d5c4-4101-bb6e-b82bc73a7d93/284a5cdccbc995f39806a3ba2dc17b93/dotnet-sdk-8.0.100-preview.3.23178.7-linux-x64.tar.gz";
        sha512  = "3b5d72979831256b9340a01db23d3b2dca801672546eeed04385949ed5f4363d3c731f31477ec82c7200ce88502dc45e03986c8acc8f2fc611b0343af5f1c488";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3b23cbd9-f068-408f-8c3c-551a5432ff08/876e15ab4041bde421e96d21e259b3b9/dotnet-sdk-8.0.100-preview.3.23178.7-linux-arm64.tar.gz";
        sha512  = "c48840b3924196a12cc66b07249af37afb2b0f3b139eb304492a2320e7ae06cfc2391abd1da31e6e58287b8b8e564386f82c55eb9a1b16108f53a4d1d59812f7";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1d4d98db-3a0a-4b77-bd3f-5ead1fc106a9/1a3410ec0ce6b08a02947a5541a3b5a7/dotnet-sdk-8.0.100-preview.3.23178.7-osx-x64.tar.gz";
        sha512  = "53ab3f6449438ab6ee0ecdd0ae3759e5fe873b964d0b4e3ee5c8a48197a7c87ec83b956eb1b10aa90297403762eb2ddab0e99e29442db484b7ed3f9d00c8037d";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7fc953e8-4e3f-422b-ae45-719b38eb798e/6559f9ed96b446bbaf2e2fd2af694dd0/dotnet-sdk-8.0.100-preview.3.23178.7-osx-arm64.tar.gz";
        sha512  = "f67ad34c23dca602e08987c12f07a39b6941682e35eae3f50efb95637b252e1e885a259f4df9be5bc0f5d43a14f16ec206a39c899683e22bf7b6a94fb2db1386";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "8.0.0-preview.3.23177.8"; sha256 = "1nfzm2wl5qmjz5ym7aainpj71gxfl7f8kr1p9c1xl5bkc7437h3s"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "8.0.0-preview.3.23177.8"; sha256 = "0a7zd729dcc7fy72z4416nxd8n9srsjfb9mlzkhr7dm1kxn25smj"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "8.0.0-preview.3.23177.8"; sha256 = "1gvh8c0aylqgw6lys7yl5d6ajywmqaz173ak1icjh9x9073bcnq1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "8.0.0-preview.3.23177.8"; sha256 = "0a28avjcqgkr7wdq0g83wf31dshn8jq05aas5y1rwka8hbplyagq"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "8.0.0-preview.3.23177.8"; sha256 = "0ywsi5qaqhfl9987fgb7kdjmzk8fyvql9ay3c2xqhxw3l0sgk9gr"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "8.0.0-preview.3.23177.8"; sha256 = "1gfms15zadmmpl39m81hmnwr537b4jlhivhp290b4zs00bv7lwq1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "8.0.0-preview.3.23177.8"; sha256 = "1fxzpy9sjjfzkg78c0pzyky0ahm2sy95772acnggy23h554qvfm0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "8.0.0-preview.3.23177.8"; sha256 = "1ali5x4k3yvmi5nwc4yq85xj0ywf0jg1b3fsfkjw18ayh9h61ksp"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "8.0.0-preview.3.23177.8"; sha256 = "0ry5405vj93fm5985z89qk3h38dd6q6iij9ada1063b275gkl36j"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "8.0.0-preview.3.23177.8"; sha256 = "04678w1fg1l6jr65vb4x0y4r76rwjz98qriazv9l6f07iskswbpb"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "8.0.0-preview.3.23177.8"; sha256 = "0awgrd1gm4bisf9qxv122iivzzsvr958lyqghip4cq0v6lrwgp8j"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "8.0.0-preview.3.23177.8"; sha256 = "0xacfmnw3sxnwrfx1vikqc5q6hbd4mn2z5kf2gmc38zg26gnd1dm"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "8.0.0-preview.3.23177.8"; sha256 = "0khvlvily96rm88y14by5svpcy0x8jxbkdnlks965lz6685yz5yf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "8.0.0-preview.3.23174.8"; sha256 = "0w297nsnh4w3pi3w5iwnww8nlk00qys82vwzmrhxbw2mpar5mf06"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "8.0.0-preview.3.23174.8"; sha256 = "0ik3lzj1b41vgs878gci8ck1dz5g1fxkb76d6il7zf95dxkivdiq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "8.0.0-preview.3.23174.8"; sha256 = "062x0vzb75m95knk1wql1bk5vk7s1d3sd13sm0jbh1i4mm7a0amh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "19sb0j0j43xl05wazn24x7hk96nljr9qjwahp4flyfdqrhjan72i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "1zlxqh82wxpb2xq808nmfywgziraa3ndb8v6wmh3315asw0l4j0c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "11wr7i7sz5xd9xc7xsy7gynv1jxzyvja2q7c5pnvp9745w02lizd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "8.0.0-preview.3.23174.8"; sha256 = "04m5y009vj943lc0265frz16q5w8zx45zpj8a4q5bpy63fbzkyfc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "8.0.0-preview.3.23174.8"; sha256 = "13f3smijj3d3ifkwik8vlj01pv2bmcsqmqkzrjw3gj7w5ln3xrf1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "1gy1ri66blly0k5wf8mgnfjkc8wnmrj2qf3bhwzlkfgyab85k1ap"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "8.0.0-preview.3.23174.8"; sha256 = "1p280lr4dqajsqz91rhl0jgpii14wnbwl3878kb6l694q9vh9ly1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "8.0.0-preview.3.23174.8"; sha256 = "1ac0jbv9qc5f2br9bgw198gq7lmpy7rj6xs2n2343v9p9wsff9sm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "8.0.0-preview.3.23174.8"; sha256 = "0l3hb17adqqczv24r6jisk70rqlagmmjbsgqp9ndyz0wgq04sb07"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "8.0.0-preview.3.23174.8"; sha256 = "1iwdap9dldpjzvd1gg1mk84z2p24dq7s96w3i3g31rz41xh0yxdi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "0hxk2p4cavnmc3azfpzjx0pmzapzh3ggfmgsapbpk0wc3zrf0ial"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "1p74gc1h353can3f6104qxwfpzy89cmx43dzjh923pknyp673yhr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "0fv23nd0iq18ggyxpainkrwjnclk9lqvx221j3lhq44pa8fv2xvn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "8.0.0-preview.3.23174.8"; sha256 = "1kj0ss21s7h00mhavm83zgjm3vbx27k8n6567liz3c8zk3xyyxvi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "8.0.0-preview.3.23174.8"; sha256 = "1r3ibli433k48q43nbhd94r3cgr4rdnkqj833n89j0xqvicrbk8p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "1lv5xx2jigpg50ywp105ghq3c3lp6x9q99k609gwhmznq0b2piaf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "8.0.0-preview.3.23174.8"; sha256 = "1q5sbwlkw3hk1gazvzhsjw21c578a4mvvm6xcrjf81zwwqhbqdzx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "14g4qrlvgzjixlbika0qc4zyh7rb4jx3xqm3hgjf5zdccfg3wlr1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "1gsm2clshavsws0zdr1qsay6fylchrgjpxmsxhvs2afgw1p5xb43"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "0x3ipigsad980is2c07f6q792am9lzmkahxkbr3f3k3nf9xxihbk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "135anfn6rz3ysdmrvkig64fb37p9gc154ns97n6snwffc6c7xad4"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "1qlyr3aax6pr21kcrfkfp3a4f5yw55dgam09lr8nzxqzqjc9qry3"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "0sq6i4jpaxp8q98fxxf1y72qmrshigpk6kp19ivzk6vs655yzik0"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "0z8wy3ib6abp129dwbzajrn3yvlm3gsa40n3fg01gbckhkgg1fd8"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "0qzj903aw4lrij85hr18l4cxz0qvvvfgspdzx57g81l1l0dd7qaa"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "1zq0zjnd3yq8a8nbj1dm3bblm1qn5gbfv26wglrb0rzsk8vc4rlh"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "1fhb0s8zgq8basmyzsm7h0rkzlkvz8lajkhqfnzmcwamv6i17m0s"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "05p07vmxjv6s619gcb14h1wfazb8zn47bng5m1nijalysp3sr7vb"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "0kxgkx6p1aacz414j5ia2qffzsk3lkbvssaacna4573ymisxa85c"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "0fpwss7dw6hg4ks5rcbx50rqazankcb8cvsnqrk23361p28myqkl"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "0yl27d46mx7iwg47v6di3r5v8sfagc3yksvxcfy93mvm8gpaii2z"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "1v485fdlrchc7f8lxxsxwapzqv8v9q1q0msm54frxa17iivkgc9k"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "1pq7dx4wnl4wlywf6fhfyvxjajygfhr29hzi2z9bwac8i1nrb54f"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "1y0nx36vms6024r8y5ckzscyqrqpbj0hz5dwzfz6am7iaq90iyjd"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "1hnhxp5wjq9xvm721f5amwk6qyncrvfn3scgmd911zn54ms3z2mq"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "0m64ggyqkdbfzpkyz88xssf1qg62z7i349dij8n0sd0i74fj69fi"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "1pnrq3lrnc5kjhfp17mmjviy4jsrvcizszncfkc28y4hq689q27b"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "19aq4fvyg1hd4bi9l1vnfsrki4ppqkk06wx4m7v8158ss2804a1b"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "0pw78b6agg0smc8k6sfhjj5m4w46dg9nvnzy59lhp1lgz6wfn3vj"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "0ix3arsgyxyffwk9b6vbyx58h3mv2hjwvgsc48b986zh4crjk7fq"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "1k7wp6s8fny06rrif74xzyd2fmflv3ckp5bs6zkcmm2ccmdrrm9z"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "198l3h1y2830g84k7j8p9h20c9j3w9yldn9rrpbfkg462y1l4dqs"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "0jmgijsimrg7lnnsb5ja826h8bj1j8ww1z4zhnsgjddp3shb4v61"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "1wfliwrzq2k8cinv81fn45hq6s6b5977z2h5l0b716qcsk5kkdm8"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "1fqs4kspgvpf564qh5cly2x2l7wqnsrzysdl98j7a1nzsy7z8i9a"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "1wkvqsxf23nmaf4mldlc19pvzpnc7jmbinmdsbh4a12h2m8wr9hq"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "0dmmp83w5hqd9jrwyjnm3n1rwjyhvdjwc07gd3m8i9hpbdglyjgc"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "1fyzrhn46wg99yvmpsp3hq5yjxvgza7y5xkfpxsg1qkwlxxyj39l"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "0s3fvj2bhn5iyzasn0d89lfln2j0ksm4zhkr1jz9jmadk0xdf46q"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "14mdp9hamh85vyd318qnxjj8vrnr79hflh19i02kd1l8d3k4gcwb"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "05mz3qb3833rmhwca6xic6wvzvnq7sz4pi3n4sfyz6jnjg87zp1x"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "039ljiz5lf8kc185nhy2mfz7nl34rczj8dxiq7d4j2q193blk1ws"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "1dddrd8z1lq7v69nsjnpr1vlw14gkwwflcag8mggqxj1wp0jri6g"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "0gv7rnl5qvnzly6fa90i5fsd3mxh2sbay35h0dicplzps8d9c436"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "0x86m6gr1zb0i1wg67snin5zzlvg7xhr5gbc2hklzjgs1b8rq03w"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "1424vq65cpz81fkq717ibjk608v7lac4yi8cnfi5rc9a5bzzwiw5"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "1ghg3pywy83qpgq4wmf28mfsl8njvnm959irv4h2in4dfpvg6d07"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "1jg1l6x0dawx5ysa9m1j11a1iqm5q1wridg4qm1dgg99fchc6mfz"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "1k3nkpj49w5092rjfwvjwgdks3sqdljjzrhgqlfhs99yyfl4vymd"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "0q2j765hr9dwwmamrdq6jq1pngnk82zmwpqsnqw4djf9gbphgb4v"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "0k0bnangipr447dx3gbrd6wska4lkhzywcrs5vnpgnq8n6i7zs9j"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "8.0.0-preview.3.23174.8"; sha256 = "1vhsjwc7y0ax39lwj14hdrmw90bb62p369fnc8lf5pb1k88wr5ja"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "8.0.0-preview.3.23174.8"; sha256 = "1d9qf3h9p5bpik2g3qd2vnh4hcz4vaw262nns8fkphzjvyn1rapj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "8.0.0-preview.3.23174.8"; sha256 = "0h0kfqbr23a625wq2ki363092rl8g0xmchwikh86327sfqm0i1qa"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "8.0.0-preview.3.23174.8"; sha256 = "157z2sdmajf24w6y19k7qacqzdlchwzm97i49vzakpjf4rsrhl7l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "8.0.0-preview.3.23174.8"; sha256 = "00rv31rpfa28lhidzlbkbpvc8ij8akrgj2xc26hh63yqrkxw707n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "8.0.0-preview.3.23174.8"; sha256 = "027s6fbk3qm3r39w545xlan5psp1vp7nyy1id4i94krz3r23jr9b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "8.0.0-preview.3.23174.8"; sha256 = "1hg2ws6jbdjiwlnrqpqqd2crw4qn27whriqchxmzmnxprr857a2k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "8.0.0-preview.3.23174.8"; sha256 = "1gipxwapdl6akscxws63fjr3cx2yz6pbh1pmndkaxgqal364j51a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "1n1x01wwvsdm9vb90kj4qx6wv9jra9jph6dbn8nfdk8ikv8jbyyh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "06bmyjmwfq1xrbz6b4vsw1kxf97ylfgsipavgw8hxkmrn4ic7qw8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "8.0.0-preview.3.23174.8"; sha256 = "1sx1l642yqlfmya6671iv7dbzzg2xsd8kwxzp0ylg294zg8zca33"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "0p307ck43xc50zhk3ygxgaqilvihp0w8xfgb1g08jw7h82k4fnad"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "8.0.0-preview.3.23174.8"; sha256 = "1181xp6vygjvxm3y3ymd0vnq0r67igy77mpby7gfh3yip5ii2j18"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "8.0.0-preview.3.23174.8"; sha256 = "10n3ybn0r0gyndl4yyp60sy6j2s1vc8qpx4ky9d6wv3id80bxfay"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "04xray0vlk2szcms9f8bm66vlaf275lwzxxfdqsr50glhlksn57q"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "1y0b2p4jjdzmicmbzpszs71480sfibmjsmqc52aqclvx5bqzdsvd"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "03i5jf7g8iwp6k5aglbxixkf018ja09jmyjld83f6x8skzc8s6i7"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "0yif5vv4z1z7sy6gh967p9gxiab6srmm94z7y0v69xyzqb9v1ni4"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "0yk0bgs1lrmxdk5fmgdm312kalszvxdv7h3cl4pldqydc7y9pcmk"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.3.23174.8"; sha256 = "0b5qavnw7n3wi9k5qylq1kvby27svdhzd1lz4vja2i76idpsr18b"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.3.23174.8"; sha256 = "1biz7yqd04hx8pk67y2n16lrf3n6wy3pxhh5mx5j1mvp5rd4zd4y"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.3.23174.8"; sha256 = "1k31qi99a26vz4hbpk3qcvgz7wgr492y55sn1lgfl6v29lnicqg1"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.3.23174.8"; sha256 = "0rw21m9yn52iry60aprhy6c3l656kf9q70vxy0qf1xy87vyadaq9"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.3.23174.8"; sha256 = "07dv8xiqkzj21b2r6jav3d4nrb4i8drwa2l0ybramdyynll01687"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.3.23174.8"; sha256 = "0ywg0x5k3826jpajr972b75dzcxvgbl55nwa6v12v8pbi77bnw0m"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.3.23174.8"; sha256 = "1hag4kq25j0mfjc69v4l9vywjcmyp0ya945w34v681ww1akbgm5q"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.3.23174.8"; sha256 = "11swrs1zdvbkvs38xxaqbw928h92qj6hq47i8wmrjx56zcw44iwi"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.3.23174.8"; sha256 = "1wwkhz0y2040bqbgmh8dp6wj48yvq9irmnppfwamznxkqnysc79f"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.3.23174.8"; sha256 = "1pgwp4r2g209lri7fkv94jpgkxddh900pjb39808q7j4s59pn8xk"; })
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ];
  };
}
