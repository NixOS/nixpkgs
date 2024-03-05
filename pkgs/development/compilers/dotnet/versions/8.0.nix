{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v8.0 (active)
{
  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.1";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8e19b03a-93be-43ae-8cd6-95b89a849572/facbb896d726a2496dd23bcecb28c9e9/aspnetcore-runtime-8.0.1-linux-x64.tar.gz";
        sha512  = "64eecc0fc50f8c68205123355c43eae5ee29b7f6061a260315818960153fdf25f2bb25a51dd3f051e2362e228c032f2d0b9e7b6b476ac52141c17cfd8de0bfd2";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0688a08e-fdaf-489b-90e4-033cc19cfffc/c9a9c648862b0b18c9aca77d3be0ef9f/aspnetcore-runtime-8.0.1-linux-arm64.tar.gz";
        sha512  = "7d34b6986363e54dca53828ca7a4d658aae1b24f8f33c6a82f811e12ce6d56698462db746d9f19e4ad245cc8d130a19930be28e0a0c2da2c96fd74b1cb2d8192";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6032140f-ed94-431d-94b3-afa360230225/eabd66a040f8a926694f78bf0f4a417e/aspnetcore-runtime-8.0.1-osx-x64.tar.gz";
        sha512  = "1a573a57d7eae9162976f915b065fcba8f4069e42f8aff4bb93b131fff16d9f54ce17d7a9392aeea27fd693c5d5932a94db8a8220ca34f481429824639a4819f";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/73548990-4198-4c80-ac97-29ff5064cb11/da52a05fbc9a0cc6b997c14284753589/aspnetcore-runtime-8.0.1-osx-arm64.tar.gz";
        sha512  = "ac12b846bd8c65035087b9a77cc44edbbbdcc5f8b8b1b9cf47bc282b3505d3f8670188e1dbffebdc26233f7a5c35ae6b2c1dc61b26d7ffc3233117436399e46d";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.1";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4d5166de-c1ac-45c5-bb8a-d47f8ee93ad9/ffab59440a3eb74359dd3009e4da5a81/dotnet-runtime-8.0.1-linux-x64.tar.gz";
        sha512  = "cbd03325280ff93cd0edab71c5564a50bb2423980f63d04602914db917c9c811a0068d848cab07d82e3260bff6684ad7cffacc2f449c06fc0b0aa8f845c399b6";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/39e79317-94d1-4e57-bb90-d5e004f4f3d4/cdcf3c0d8dc2560dcfcb160acb193785/dotnet-runtime-8.0.1-linux-arm64.tar.gz";
        sha512  = "29707882d4fce61eb4b20763473d548570f89f9d028bafb76b646911a5e7bf793dc75e33a6903622d7ba46e9eea0eac000d931cd2f45da118ef05fede6d4079b";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/220d43f7-eb7f-470d-a80b-b30210adbbf2/dbfa691328557ee9888a1f38a29f72bd/dotnet-runtime-8.0.1-osx-x64.tar.gz";
        sha512  = "8c88db692cd889d8f4d6a1f0a82a3eb0b3f49a4771318127c294822f20ee83a87668c6a54012ad87242936d4412b3f8adc0448b8d5ff623f0a6faa3cfc544309";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/43ed6ef8-5265-462e-bbc4-2055a0f473e8/28d78788aeca160f615dcbd63c79b621/dotnet-runtime-8.0.1-osx-arm64.tar.gz";
        sha512  = "9d716e324c041ecd210ae65bcdd9bbf8c884d8fb92cda72d5bd13429581d47d7837d51f63c2994dfe17c5cda77de1c727308b590367d3181c91fa1f173c66b04";
      };
    };
  };

  sdk_8_0 = buildNetSdk {
    version = "8.0.101";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9454f7dc-b98e-4a64-a96d-4eb08c7b6e66/da76f9c6bc4276332b587b771243ae34/dotnet-sdk-8.0.101-linux-x64.tar.gz";
        sha512  = "26df0151a3a59c4403b52ba0f0df61eaa904110d897be604f19dcaa27d50860c82296733329cb4a3cf20a2c2e518e8f5d5f36dfb7931bf714a45e46b11487c9a";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/092bec24-9cad-421d-9b43-458b3a7549aa/84280dbd1eef750f9ed1625339235c22/dotnet-sdk-8.0.101-linux-arm64.tar.gz";
        sha512  = "56beedb8181b63efd319b028190a8a98842efd96da27c5e48e18c4d15ba1a5805610e8838f1904a19263abd51ff68df369973ed59dab879edc52f6e7f93517c6";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c7f806d2-1483-4a52-893a-4de1054b0bff/a6f52ed50876c45f859192b6576a14d5/dotnet-sdk-8.0.101-osx-x64.tar.gz";
        sha512  = "5c18dd1c0bb8199660dea5793eb2a568c63adbde492ca5080a8130e723a6260c6b9c6a055c299a3b8ba2497d6875959f86da8b9c9bf85e093bca2e08724d46a1";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ef083c06-7aee-4a4f-b18b-50c9a8990753/e206864e7910e81bbd9cb7e674ff1b4c/dotnet-sdk-8.0.101-osx-arm64.tar.gz";
        sha512  = "a6048ca248aef3c430c8bdb65b534d5f58463a9d3c314fd70f5c7c4a9ac7eaabfba7786c40c76c73e5abc1a95ba957a682e73fb228e15bc9808adb47b4a1b291";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "8.0.1"; sha256 = "1pqjaj3faxmyhiikrb7gh8zcp9ybqacb91qzz0xxc0snc9k1gc42"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "8.0.1"; sha256 = "0dsdgqg7566qximmjfza4x9if3icy4kskq698ddj5apdia88h2mw"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "8.0.1"; sha256 = "0cx4gz9qjsaxd41aasrk0bq68pwdmy8bjh4wxwgbnlwjr34h29rv"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "8.0.1"; sha256 = "124vppxwj56bs0j7bgl3baj91wi6c8h5cgxz40d1sih9gz5bm9qd"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "8.0.1"; sha256 = "1gjz379y61ag9whi78qxx09bwkwcznkx2mzypgycibxk61g11da1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "8.0.1"; sha256 = "0a9aljr4fy4haq6ndz2y723liv5hbfpss1rn45s88nmgcp27m15m"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "8.0.1"; sha256 = "0xy4pb3imq5ij7k22i3dbbvgchiqbnyblfz988zq6pg140hr84jp"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "8.0.1"; sha256 = "01kzndyqmsvcq49i2jrv7ymfp0l71yxfylv1cy3nhkdbprqz8ipx"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "8.0.1"; sha256 = "1cvf0fdsfv4di3wp83gm5nw1a1qnfn6mdvg49a3afi83lpbjxix4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "8.0.1"; sha256 = "0yaaiqq7mi6sclyrb1v0fyncanbx0ifmnnhv9whynqj8439jsdwh"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "8.0.1"; sha256 = "1j8cdmxv8k1y9vxmdnka0lxk2ykwr1xb2qz8l5s1vca8fns1l7fs"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "8.0.1"; sha256 = "0w3mrs4zdl9mfanl1j81759xwwrzmicsjxn6yfxv5yrxbxzq695n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "8.0.1"; sha256 = "1lai8b9pmvid4sfzgl4br6x426cp9v7m5bhif3ll5ndai46xg8im"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "8.0.1"; sha256 = "0dhpdlcdz7adcfh9w01fc867051m35fqaxnvj3fqvqhgcm2n3143"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "8.0.1"; sha256 = "13psnlgpq89ifn7w56wpvzabxy432wkqqs0g01kpy8y1ni2vb9l8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "8.0.1"; sha256 = "1lhbr8dxwrn4d1ijhdbx1xfhmkjz09phac5130n7cm86ix0vk48w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "8.0.1"; sha256 = "1aw6mc7zcmzs1grxz2wa9cw9kfj8pz7zpj417xnp1a9n4ix1bxgr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "8.0.1"; sha256 = "010f8wn15s2kv7yyzgys3pv9i1mxw20hpv1ig2zhybjxs8lpj8jj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "8.0.1"; sha256 = "1sw3vfg9wc5zwml63h179z385cakj09s217j3nxzf7klhl3fbhm5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "8.0.1"; sha256 = "1ssj1cyam3nfidm8q82kvh4i3fzm2lzb3bxw6ck09hwhvwh909z4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "8.0.1"; sha256 = "0gdv64dzjd656843714kr99rbips9l7q0divc3rfrmdflc7bxji0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "8.0.1"; sha256 = "0krzds3jxxy8kcm0zpi7q9jvm3ryjcl0ldr4pcbi9g4nfr8z6n7f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "8.0.1"; sha256 = "0353whnjgz3sqhzsfrviad3a3db4pk7hl7m4wwppv5mqdg9i9ri5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "8.0.1"; sha256 = "15bix3grr9mjczgc55jk1zb6fpcy3gdp1mafscsdy7zai6yy73lv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "8.0.1"; sha256 = "08qz9ii78rm8plvx3j93v3yckly58hc6s8mjn7sjf7lk0dfvls7j"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "8.0.1"; sha256 = "1g5b30f4l8a1zjjr3b8pk9mcqxkxqwa86362f84646xaj4iw3a4d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "8.0.1"; sha256 = "1fk1flqp6ji0l4c2gvh83ykndpx7a2nkkgrgkgql3c75j1k2v1s9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "8.0.1"; sha256 = "1nv24b7zm1j5kkn02nk308jbkciybvxw8mjj6qsqgmmlg6dyxlv8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "8.0.1"; sha256 = "198576cdkl72xs29zznff9ls763p8pfr0zji7b74dqxd5ga0s3bd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "8.0.1"; sha256 = "1g7l5da8v1s8xhyij2y0mr2q8xkw80cr0bmqzkmkk0425ikbkc8s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "8.0.1"; sha256 = "1rg8b8437sys3pdxzg5m3vi6nn53k5hkg901lwzbp41bch6pjl1b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "8.0.1"; sha256 = "1iagkshd7cy6ni2fb6750a0hvbsqms91lb39jd1dx8mlnspzxyld"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.1"; sha256 = "1n3b044h3c9qbyj41r2rwrld4smfg165fvwqgi56xg16agwz4d2h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "8.0.1"; sha256 = "05jadsr25g30fxqg48sdf1k3fjgs0bipxcwy2rdxf9v5r3g6sqn5"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.1"; sha256 = "085k52x87d2bfw2mwri6s3i6aqn1yfnhb1mp57scck8jb53wnmcm"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.1"; sha256 = "04cdb8ya03419r9v3kbdlawb2bgvxsa284rbfcdbbyhwa49589ja"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.1"; sha256 = "0biyilsm78mlg51f20zkdxcby2qr0vas324jaicpvw9212b99x9j"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.1"; sha256 = "15v9wyj9fagxpr62r3i3wvzmqjb0padrk9249ndrm7xbcghfzkl6"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.1"; sha256 = "1zg5grsl3i368hpqqdhprb46pz5ymfjbyyv07r99jg881i95pp49"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.1"; sha256 = "106gjs082kixijjijs6pmph60zlgmiz26jrzc0c87b22daqc6nc8"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.1"; sha256 = "0s14f344f9xmxhzb8zv0rg6kc361pyrd46bwzd01qxcwa2g1yh95"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.1"; sha256 = "1crszc67z13qwrhin06a6i9m60qlsk730h381jy9s5wbn80cgxgv"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.1"; sha256 = "0girwd7dail3zlvsvj1ypmrw24vbc6jly1fj41j4w87l0v893ccd"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.1"; sha256 = "0mf905knky5k69nyx82jvijsi71fwl1001dj0zsx5rwa6i8g4kpx"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.1"; sha256 = "08z5bxzyhvrx3k7i89n0dpnncjxfyr0ikva7jq25qmqp2xj55wwh"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.1"; sha256 = "0gif52wgg1h7zvd85yl44wfn2gxskwxb679p26xrfdn5npv1vzs7"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.1"; sha256 = "0cmgln0aqrrm57q0zm3sl600j1hjhf46rimc2hvfqk6vv6gmql82"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.1"; sha256 = "1m05vz3y2h028wr785833bfpw18vq1j6b12bpm7fsfib28isgy8a"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.1"; sha256 = "1d7yyc07siamz3h7qilpdkq41j22hm43ds58vrxnpgcn4alr17a4"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.1"; sha256 = "02r7gxrch89viid1zyqa50ag5zbmdjyysx9p54xcxrq2fz874b04"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.1"; sha256 = "1q8z929yf31yhcr0yga2sycgxjkdamddrh0kxfvzpsxa9iq92n41"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.1"; sha256 = "1g7i2mj777avqpnzl8sf4npcwiry712jfarvnk5k39l339xs7qxy"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.1"; sha256 = "0i64v0wf5fcm8fcvj32k0s2h8cmn64zipnm0v54nx010143fsjzm"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.1"; sha256 = "0g7xzzpgcl0zfm4zpyy6r3xh99m5994bkcc7mkhwl2iqyxm121fh"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.1"; sha256 = "0dy2z56ypbkyaif1sqm88np0zd1h7rzsvcwphhw4fghm6z7v31f9"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.1"; sha256 = "06vrwf8n12n8y59x38fdjfm737r9r0ginw3bq1wi8sdsarfxyqpm"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.1"; sha256 = "1fwk41k82q6zbnvd95wn6cibplmmfp281sfj03nmfhcfdqdsfq60"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.1"; sha256 = "1zm5k3xan886sl90ypm90qp02wv9b7wi42am7mk6x016rq4l40cm"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.1"; sha256 = "12ziik1aclv3jyqqpw4bhhvwwzxxllghn5ci9rmfhcanhv2krxbp"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.1"; sha256 = "1isn4n8m9bh0fwd7rqx7z1msrxhn24fwk23kngkwnvl5q17k89if"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.1"; sha256 = "09b2swf93ia4g8yb7j0hzd3jjg41blvx10qz83xsqsvkhci3z1v0"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.1"; sha256 = "07ppksnq35rvqj6zh6b7cr8jda3crlbmy5yq2cz267123x272dm2"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.1"; sha256 = "0fkdc2apgbhhxjnxyplfc3rcvqfmpqx8h7q3lr1bpnhhyvmx5jf1"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.1"; sha256 = "0vq6br7qnwbh62amqfnyc5x9aldgd0sjqwywyh9swfdk30lyp9b3"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.1"; sha256 = "1asyqkk2ilgf7qh4s6cj95hsxsgzqc44wvbsl3z9jm4dh4jrmm7n"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.1"; sha256 = "0lhxhbi9g8dh5si6a63n377p3jwiz1j7khgv15gpqdpz3amsf0r0"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "8.0.1"; sha256 = "06zs2wrgx7sw4rizwphpppgw32i822kjg2qgg7ki7pc0kj7dz6w2"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "8.0.1"; sha256 = "0kwb138r4i3ci7hzkai00wmj3hq7r3838fdsxx8lhavhk3hyzqmk"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.1"; sha256 = "0qg2z4ljj66wg2mfq3pljgzhhs16b42xh51xbhirq3fxrpm0g936"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.1"; sha256 = "0jfqj1cjq05qr04mywy5fz40g8w2ss5f5dzxjy3pk23rg5cg436l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "8.0.1"; sha256 = "02q9kzn4pmsvccm3rl58mx1yaddaca5yks7bsd04z2s7zv70bwz8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "8.0.1"; sha256 = "1dzg3prng9zfdzz7gcgywjdbwzhwm85j89z0jahynxx4q2dra4b9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "8.0.1"; sha256 = "18cj1nganlqfpxq7f3f4mg0pmh76azfgyclny5mcyjyshyznxxnj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "8.0.1"; sha256 = "0cdrpdaq5sl3602anfx1p0z0ncx2sjjvl6mgsd6y38g47n7f95jc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "8.0.1"; sha256 = "02r4jg4ha0qksix9v6s3cpmvavmz54gkawkxy9bvknw5ynxhhl1l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "8.0.1"; sha256 = "139f7rh3lkkwidz8klxrpd47lr5d1bkc7aqsgy5sbsqf6f8nn5qb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "8.0.1"; sha256 = "1h3yxvmaiv2cj5v9a84v1kmp81raas273v8m5wd20s8y51q7fkl3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "8.0.1"; sha256 = "09xavj7hhnw1lmh95v1py9ng3rgp5cksg1lz031qv3vqsxs59lnn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "8.0.1"; sha256 = "02670yxz97b0f2l4jh59xyh4yyg9ijw1c6h5yv78g8zkdd29zdd1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "8.0.1"; sha256 = "1pji3rkhna967ibs58xix0ymgbzpwp7yd8vmjbx6gchxgib5g64q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "8.0.1"; sha256 = "1zvdw094kh02ivzjwzq1izvvhkgkd920y2w2ag73zmfwivaqpya2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "8.0.1"; sha256 = "0g7kv0dy20lcl82yz71w39l9i8j05w57jx8g4smkx3hmk17qxrlz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "8.0.1"; sha256 = "04fjp83zl4fydrp4qmcjapcz8yijag1r3jmb4jn5x9s77w95i6p6"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.1"; sha256 = "1ax8k7zk8p55id1jzsp2xz3cxgyrh0l3za1qpyqgkp9yp8x43qc9"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.1"; sha256 = "0bzrxy28gbl1zmn84b698rf4xic0faywy8dibachh7mh0pxh1bxv"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.1"; sha256 = "01yjcdyj6w9x9f2nvnj46qgcd8z7g3k2n5l0rcvxnwzflyf16c9p"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.1"; sha256 = "058xj78mlq44svhgb4z19npsivw7q9rqjz5x4859gz9fgm4bkajq"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.1"; sha256 = "16x1ivz7ycz04wf4w1a2q9ifqb2knc1ngvpm5m39djh2dwphn4ny"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.1"; sha256 = "0zi02kl8dwc75iwgkpznd6jkd2jmd62m6vix7s55a95jqqgc1lpx"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.1"; sha256 = "0llmj8pj98mgfcazazz1arrq5ccpy35ycp955bl4f1di5422rkyv"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.1"; sha256 = "1xnwgdn8vxxq73krbzd495i2cznyg01jss1495l39z0s79f78ybl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "8.0.1"; sha256 = "1g55w5xa1z8x4cqgn5dvxm3c40lczdsp4xnlwm6czx7iyy7i81mn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "8.0.1"; sha256 = "04rbyl6qxidw2nc3bfmzny7988f2x9ngsxprn7vsi7xlsf8wkqc5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "8.0.1"; sha256 = "1w0w9da4q14icj815c7divmwrslbh7hxmksvyfjck4hyy4q4c6d0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "8.0.1"; sha256 = "0f2zndr6rdb3v443hd5i9dgn0r6668595gvpff6lm1pnyhsv41rg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "8.0.1"; sha256 = "0j4grr62s5gm98rxw77qxkjiy7281sfixw4n8f0r43152ml57qab"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "8.0.1"; sha256 = "0zpsfwygc8azdm1qyh6ry9rfwxlzgd0s2g31zi28xfwzkliwyykv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "8.0.1"; sha256 = "0swxakdpwc4d5fjlxpl0awlkjijldcyvp9hwx0a8kvvjrbydm357"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "8.0.1"; sha256 = "0jd2ndgci5i745n0h70l6kyh5ayd4kvmankmxqxshcfyfqijh8yd"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.1"; sha256 = "05n7p13vc49v4gvrgfkswi7ycnfvcwaww4y28xz9dnd9qj2y2b50"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.1"; sha256 = "1nl4bpr1ba2iqf2y1w3da2cynrwxdb1yghwgm8ix3sd72vmpwfxr"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.1"; sha256 = "08n4pnasxsd2qgq5izib8simzspcwsldcsbjgxjb9291ipzwsd3z"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.1"; sha256 = "0mky32k6kv2iy14c89xbznyrr33ni616s85z40ny43j5w9scxh04"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.1"; sha256 = "08x0vcpnhakaqifhg556dslr3s33mgplnxphhnm90dnfvyb6mqjq"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.1"; sha256 = "1qf7ws0a5ny805pxmpzrp751p5p18h46r6lfi4p7h2rlw9p32ys0"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.1"; sha256 = "01h77hc9b5q8dhr19r3dxs1m76zhk9x4wz0wzkqz4j98p1g5bffa"; })
    ];
  };
}
