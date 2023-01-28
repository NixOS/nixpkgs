{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v7.0 (active)
{
  aspnetcore_7_0 = buildAspNetCore {
    inherit icu;
    version = "7.0.2";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1d8c4b4c-aec9-451b-9bd3-bf7cdbd28477/def6c1a7a9cfd4590698d4f338da2803/aspnetcore-runtime-7.0.2-linux-x64.tar.gz";
        sha512  = "d3b6c845030069581b3bfd739e3918ce77ae76c8e2e57b8e6c33c9134c46bc8c09fa9b74abdbc917c614c7d09ecbac149b0db1be2e045d26d82c61d976279b49";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f88ac12a-fcc7-4f69-baf9-17cfbd9b316e/8745af53d52c38afc5c9fc171cf3c7b2/aspnetcore-runtime-7.0.2-linux-arm64.tar.gz";
        sha512  = "43ad795456b6d7a1f566113aaca4d7817dc4ff9cc893cab48e01d2d9685a1febdf397dfbc774fa7adc30bac7884dbd60980fe6b95efbc9497cf3228688c123c3";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/035d61f7-0418-4834-8364-eec4d3c3d112/b1fd356e10f14ee2c930e023654186f3/aspnetcore-runtime-7.0.2-osx-x64.tar.gz";
        sha512  = "a6e867fa4a9774231c736dd61e54efd8f62dc29fdcae6be298023ee86fbc8d75867d58d5968ffe566a497dfc1b10ef0104194af495d5cad48871e989b1bc2778";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/42ad7951-d95e-4d52-8427-9ff58cdb0c16/f6256fba5b7484979737f34f7fa1e0ac/aspnetcore-runtime-7.0.2-osx-arm64.tar.gz";
        sha512  = "4538a57c6bea5d3137ec44286b17a4ab0df4b5c946db3e9bb50bd97cc0bff6f7ba6f1eb951d77e9f77d3727af7bf04105076f74f2c8b64005b1175f1c8f5cd94";
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
    inherit icu;
    version = "7.0.2";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/83524cc2-60fb-4e49-8769-e9ecb1af8e46/a28b17808ffe21483b2f719091a0544f/dotnet-runtime-7.0.2-linux-x64.tar.gz";
        sha512  = "56f7f471052b955968b9a4caa27299ac003e0347ae80e8ef23de87d28a2707bdf7ceb70467cc3e9f0c80928a779841dd7e1392ed6b06e66a7a9cda696d5c0a1e";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/38d90a87-4b35-46e8-a4c7-5c4ae15eeb96/77b1c221366f3c748c226edf25a65577/dotnet-runtime-7.0.2-linux-arm64.tar.gz";
        sha512  = "dece1d39074dde28aa61f51f3d932ee5328c9ec2c5e6c9830e304bc768e3253b5fab3eb2e27752d39547d68c29666440fe5c96f0fb0b8e503b93f55429df544f";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4106c55b-9371-47c6-be04-cffe46c334d8/ad559a1e388d9384ae07381ffccdf26c/dotnet-runtime-7.0.2-osx-x64.tar.gz";
        sha512  = "6fde32130590d18d6bfd73fd3c2cd01f3ed6c2b3316285f64fb0bcc8889707e0a6e1415f796f5553486a89ef817628add27c64b69ea41c6cf4cd9fe811caa10f";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/42056f30-aea1-456c-94c0-77eafd2cdbec/ddf45ed3e6c84305aa584a35344f5338/dotnet-runtime-7.0.2-osx-arm64.tar.gz";
        sha512  = "c8ee455a364a53d0945bf76096bcc568a45b843bc5b313392ab9a07f1e25b16110a411a2d4bb3b6632891cd4ea5147597c93065097bdcbd5038107382c84c9bb";
      };
    };
  };

  sdk_7_0 = buildNetSdk {
    inherit icu;
    version = "7.0.102";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c646b288-5d5b-4c9c-a95b-e1fad1c0d95d/e13d71d48b629fe3a85f5676deb09e2d/dotnet-sdk-7.0.102-linux-x64.tar.gz";
        sha512  = "7667aae20a9e50d31d1fc004cdc5cb033d2682d3aa793dde28fa2869de5ac9114e8215a87447eb734e87073cfe9496c1c9b940133567f12b3a7dea31a813967f";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/72ec0dc2-f425-48c3-97f1-dc83740ba400/78e8fa01fa9987834fa01c19a23dd2e7/dotnet-sdk-7.0.102-linux-arm64.tar.gz";
        sha512  = "a98abed737214bd61266d1a5d5096ae34537c6bef04696670d88684e9783bab6f6d45823f775648d723c4e031b1bd341f771baa6b265d2b6e5f5158213721627";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/91c41b31-cf90-4771-934b-6928bbb48aaf/76e95bac2a4cb3fd50c920fd1601527c/dotnet-sdk-7.0.102-osx-x64.tar.gz";
        sha512  = "b7a66a6dc9e6648a97a2697103f2a53f37cab42d7dbd62b1f6ce5b347ca6cc7e45e5474ddb546e10f1e49ac27b20c0f58936093decf779941afd2ff761ecf872";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d0c47b58-a384-46b3-8fce-bd9188541858/dbfe7b537396b747255e65c0fbc9641e/dotnet-sdk-7.0.102-osx-arm64.tar.gz";
        sha512  = "bc95a0215e88540bd52098453f348edb01ffec11ccfc44c7c017bfae5243ce2f0a50f4bb06cc6c3a622c9fc27b89f026be172c2d1bfb8ba62ed007071d5224b5";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "7.0.2"; sha256 = "1yzxfrn3sikcl5xv7l69yly00xs483q5vr5wgp08vrlzgcgyb2rr"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "7.0.2"; sha256 = "07m4dxmgl7fcid7crkb51qsrizw66ax0l1zzq1gan7pbyny9gip7"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "7.0.2"; sha256 = "0vgi12pg0xl0abmzmw0mb29030djg5bk9lqxs1sm6m4sk7137l93"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "7.0.2"; sha256 = "1wapqdaw5k9aqzfdhs4y0avrinfcya2y301qbdr92i3p11i7hccf"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "7.0.2"; sha256 = "1bfs9vgl46zzb59lja3a2phqshspxc9dw4ldc1vqm255isjwyq3c"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "7.0.2"; sha256 = "17bpwdpw6b5v1fqiih1c8jb8cklw7wvlfnsw6zy0ac6z67dylyin"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "7.0.2"; sha256 = "14mmkyg8pi1i7k2i0zqfqvkn5al2k39n6sv2rc6961y7436a7vmd"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "7.0.2"; sha256 = "0j4jzc99az94drwgfzf672hjm8ia1hq7dzhq7i0c8ny4xzdqidwq"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "7.0.2"; sha256 = "1ngxdxn3x54pf97vzrn8f89nr16yrzdbl92mp07jmr1z3k5sdb0k"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "7.0.2"; sha256 = "1lgxj2x6gcyn1c67h8231w1xx4a9alldp0nfkw97298453gnzqg0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "7.0.2"; sha256 = "0162avkqlg4am99jh7a98bv8r4mr3c5r5yrxng8wgyf6n6k7ymy9"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "7.0.2"; sha256 = "0lns56ppla5xgvval5m84j41yaynbzqfvivfqxw88haxay33nlb9"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "7.0.2"; sha256 = "0al7s0nscy1941wpvmc2lnrrknpiai6s4p2w2hy75kay4ipcbg97"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "7.0.2"; sha256 = "1y8wm5jl5ly30ccfff5kjhnmlyacpk0ykipphvgb6whd8fnck8ph"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "7.0.2"; sha256 = "0sjhr5rkk1jv3i9ddgf9k5lk9pclkn0gs961xn2bvjcslm99ns2p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "7.0.2"; sha256 = "0jdh1hrwvdq5llma5p1ammhrwgw8y7iw2qqy5rpkmn4jp08lg2k0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "7.0.2"; sha256 = "1f5qlp1m9mjs6c72a2kdc1f2hq0spwqxhcdyf8wpb6bg4bb80p20"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "7.0.2"; sha256 = "0sfgwgvikpvf1zbzdqmbvi830ri28xgag39x658qk46yp1a13405"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "7.0.2"; sha256 = "17nmc7jymlsxmrdh7jvwmcn9cpfzs04yzcwgigq5bvqiqj809px4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "7.0.2"; sha256 = "1z0g31wr1rwf09v1pyrd2vjdxri0h2f1w9m69pwkx0n255584b4w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "7.0.2"; sha256 = "1b82hk8s3z380vkyzi8w4n3hznjp3x8dh7hrdwyqyb5v7l8lipw5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "7.0.2"; sha256 = "10raq3bpnsy9jsni5bb96zkmx4i1l72h2gzv8jvw9basygqqvk8x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "7.0.2"; sha256 = "0liiy8m17bcn5gydpzbnxl79g2mfpsq2d2c67l0hwqqn5w1zv2a4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "7.0.2"; sha256 = "0lpwyxhxi1ir52lg31kynzldk5pk6qxawy22izdwlw7fhmwkm0sf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "7.0.2"; sha256 = "0cbwhjiwj0lhn6chqz3msymlsqhlpmvdwbhd9r499mfjj0isrpq4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "7.0.2"; sha256 = "1iijrsbib1ipihm01dinpd8kklckravn5i40b8whynbpcqi8avhx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "7.0.2"; sha256 = "0z1lrxnzbjq18fzy1h77rbyfv2amwzwvfzibdaqv0r9xgrzspvdj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "7.0.2"; sha256 = "09agcf1z06z816y40lv0n7mq7njjc48i5dr1xsdiwk587kljp71v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "7.0.2"; sha256 = "0h6sbb8iand170cdrr5y6a4kmlhd7s21h1jz8c1idjp7p3i2i8x1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "7.0.2"; sha256 = "10ddf1b2m8p16hfz16073w1dzlacx9v1mk62vgnbyyv20g4a4gs1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "7.0.2"; sha256 = "0z1yjx7s19m52cliy4f7mwi0y4knba2qadg1qma0d90l7i0wc3v3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "7.0.2"; sha256 = "1lf4vkn635xilfzz183yn9byyjfxhdgvchngm34j6jj4pi70d0k2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "7.0.2"; sha256 = "1j5wmnxanzkngxz9klaf6bd2chc3fk8z6j6sksmrkd46ykrpbxc4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "7.0.2"; sha256 = "0ay93vi625b7f4rmg6ff9qjhjy0zjvv906ygmg9irghn97qqy283"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "7.0.2"; sha256 = "1jnxlw78wqdgcq645aai02vxmgghb0dxhkp33c9qpm5c264vlznl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.2"; sha256 = "07bl45jhg07bfx0f5n755h9wcg3b1igjahy3c45j5d9m5c8avh64"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "7.0.2"; sha256 = "1b40nzkjgv30v15n9dmgph976i883vpi85djmibvrlk7mah66j5k"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.2"; sha256 = "0ig879a4yl5n1xh0i0s7cikf2zkrx1wzb0amqv5ml4pk0ryik4sd"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.2"; sha256 = "04mpy53rw19677ba57l77vk26xmfp5vdgqniqwpqga236sahl3v7"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.2"; sha256 = "081csjhs37m6qspm7mrc3sj7jsn685y1xjkc4wxbypdvqsn43smi"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.2"; sha256 = "139r2lsi1yx5g7d3g62kch1vfyxgfwbyr4gps1q0w4fi0s26qaai"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.2"; sha256 = "0rkpicqfbvd1c6l32kzvimw5i4fff8pachazvfqdqp2w98qik4g2"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.2"; sha256 = "1x73cdb6as4vh4hldql1p5cys94x8lxgmyygb1bj82l1brgqlqzr"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.2"; sha256 = "1cl8ppl19gb442a00g2bf6szbn70wlr465a98q6xg5h5b92a4z1y"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.2"; sha256 = "1lch9mwj3jw8zfaz93pg6j3mviw28bm3ll9z3bdv0spkp1d2gy0p"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.2"; sha256 = "1f3jxldxcy3zjc8ya6lcz68ki8ih5q60vkcv8p9v9qbjbcf3x2qg"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.2"; sha256 = "0kqhpf54jv80in1ypygl3mmdbf1miypn7bdp4d26wrq7anfhr1id"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.2"; sha256 = "1r0hq5w5kn1vr3br7ayg60rf17cxa8jmllmj9cc8rqndpjj04qv1"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.2"; sha256 = "0y5jxxr967xx54wvrrxix9c4i49lx9jlj2dr1y76hywl5rib9xff"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.2"; sha256 = "0xxkdjdssvxwnmfkdrn4qpb1y9yfwdrzzm6xwdhj8gcfjbyxv8l8"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.2"; sha256 = "0cl0xinjkk6qjcff015rjarni4z71q1d56d9y7jnp7z9sxbqcpmx"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.2"; sha256 = "15sr4ispkd1zbbp4xz08vpb24p5pbc2avgn7mk502g9y2a87xszq"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.2"; sha256 = "1iga8qsq38q182p9awjvgf7301f0y0sbzkx2mvgrp3ppy7rz1jvi"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.2"; sha256 = "01kixadmk3zji3cmqimdg9zzaz2jyfkz8dfd5ll78mdl3qcl341z"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.2"; sha256 = "1rvnsiiygy1z01qgl64id93j2nhgi20bc4iwqaaqhzwdgh2600mw"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.2"; sha256 = "0ywkdjisj0dsi9f2wyx8faly6zjwhgnzgxvbblfg01saxkqanfrg"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.2"; sha256 = "0wg2vsp7hs2rqh48q2qkb83a4ga5z6awadyn1zkvmxdzrxyk9kry"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.2"; sha256 = "14vq3sndmmfk3x5pfl3q9pcrv2865xpsbmc5i017qah3x1x74i7l"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.2"; sha256 = "1i3awdr5dp3jcqkhjkipqy13qdbpgi98cncb9m3jfnnsc36mb732"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.2"; sha256 = "160qg0ar7ja7s3vbh5za28an5xabqdgh7gnnv48baswxm4bls8ds"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.2"; sha256 = "1iv0fy0hg62l0r9696f18m9k1fi9qm9pvabq3ahn1nksqmdqjbp8"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.2"; sha256 = "0nrnyb6bpqb48rd2pymm0b20rwxpy2yja8ch0l1gzsw0d28ma5c6"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.2"; sha256 = "1ys6rfj02vf9jspl7kmyif593kn6mmkyhdncvwpp2fbiip8vxgc4"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.2"; sha256 = "0sn7h66y8jxcd17fpfzcysyyic2bgf3jw2ljlgr8v3ags726kn0w"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.2"; sha256 = "1hzfjrrav3pxvx0jryyj6kli7q22w2q5zaix6ij4nml7g3d0ygzr"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.2"; sha256 = "1qwnlz65s9jpl0gr5avfc1krvy9m6d9iprjb4hr8v38gj17q4xxy"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.2"; sha256 = "1n4fjjrb2yc7d11p8l7z9x09xx2421diiv2i78wygmkz0czdlw48"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.2"; sha256 = "0yl9yn4i1lhf76yl92izxzi6x9s6srdbwdh4kcwnwxcszf201gkk"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.2"; sha256 = "09387pgs6qvfs71ll648lyyj7i6wrc98sgh77rr2nhmaw2b3gaq5"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.2"; sha256 = "1jngriv8cfn05njhc97h16048z35686526a3p0iim1xi1zqga5vj"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.2"; sha256 = "1hlqn3qdjcjnfwp40hlnjb747pic0lhwc6xvcnly1a9zgk387sg8"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.2"; sha256 = "1jbaqhrqpm696d40swrjj9l19q47rmixzfzbxwm4xgjf2pnrjarc"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.2"; sha256 = "0ar8bydq0arfa0ky6xwfqnjvdn86rfkw7v7v9ga2x51h3n60i149"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "7.0.2"; sha256 = "0dj6f5fph9m4ym1jcg21v101qj4spzb0qwq0wn79sgd54jia1mfl"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "7.0.2"; sha256 = "0iwdwxqy08j7arbfjjj5bx3x4w0fdwhzmwbzidkhgzvqq634n7d0"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.2"; sha256 = "0j29f9bfa6hxqs32xy58kwbmqqnbz4b29w2l82ip9w9s8yvjvci3"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.2"; sha256 = "1gql9hl2li508sndlvf7hgi0bf74qghbyzyilw6xad88gnvr04vf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "7.0.2"; sha256 = "0j9x85vd9lar3mkdxknas1fsvnbxr2713p88qdf6p5zvv2fc2jlw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "7.0.2"; sha256 = "1bc3kf8yp6hpmp6layigxz2yzfgdclwgjx621lgg4qiq4xs3sddn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "7.0.2"; sha256 = "17kz2565nr7c4737pi3p4kfr1qxrq6gzr3mg3mbm2ky75a2mh016"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "7.0.2"; sha256 = "16pvajh1x6pvqrlq1lbzdhin4r5a4ws77zgvf3bp11a85kv7dj1w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "7.0.2"; sha256 = "0pmzq9z9d0fflk3zjakc1jjxw66n3wnswm224i0hah02vza2xyia"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "7.0.2"; sha256 = "1962bjgwn15p3fh8c1797mhz01bz024mn81dy3dmym755m1mx7c5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "7.0.2"; sha256 = "0lxr8agz52wkdm2jd3lz1fkiwqbfkr8rvaxmp65sfzbzs8zmj3dl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "7.0.2"; sha256 = "0rcq6fxq8z5xc5nmm2l7zal6c9fqj3vva29b0hwnp8ijk6s2srya"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "7.0.2"; sha256 = "1fl418xx0nf5vr6pi3wx257aixiblw70lpsafvjc9f10saihshdj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "7.0.2"; sha256 = "1n2b3lpnzc83wyf9pb5cp54hsk0shhww6kh9jd9gw9g89j8la9x7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "7.0.2"; sha256 = "0raacw2a86d00q0ky8802c4nhgvik4dls7073dd1mjpmkdc9k8ki"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "7.0.2"; sha256 = "14x7cl7dxdy689rkg296rncmzqdv1wsz6axnlf76ywfix5aakh89"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "7.0.2"; sha256 = "106n3vwyr2cbgx5a27xy13zp6j943jmmzb0dyj2w3kjmwzdgbjqd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "7.0.2"; sha256 = "00y48dbl81d08bcgmy0xfnnr9rp9qnq3w6cad3n151nszz7m3i3f"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.2"; sha256 = "1kl99n29m17ab5vg7k14d9ivsaqpwalbqdxchcfsqxnghby84cia"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.2"; sha256 = "02fbrm2d1000s2ql17c0lcdqv0bacnvgx0kq401yqyirlh5ls0n0"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.2"; sha256 = "0bld37hmv1jnxg3w3lkigpk3iy0s1yxryfdd9l4q8my0bpxbdi11"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.2"; sha256 = "055vc0vkbvllqq945py1av0qqcp7a7wvgd6qhazv9d5kyx6hg7dq"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.2"; sha256 = "0wppab4l04l23vizk235wvz5niqhv06v929zdr9gi3zg12ajcw8w"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.2"; sha256 = "0y0rr56sm2ij1mrkq9s5j55w49lh4blxg3s5wwxpb5sxrlwl9ygy"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.2"; sha256 = "0w3hx2bla0pj5g0kjjlhwr65r93fppyb2cl1prr43aq560a766gq"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.2"; sha256 = "1kd4mjd2wygsmlrgy2syvlrf17nd6y5w2bqq42pj4d1xa8i3p7rq"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.2"; sha256 = "1a3hywbyc4hd37pr5cyggxhgr1g69yrphwsyi0h0ylypz7njd721"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.2"; sha256 = "1dalxbgxzc45qj2l7xmhnkzm3jfv4lmbvcd8rvhsm6xh2xq1qhnk"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.2"; sha256 = "019zv2jsw9l440s7c6ybb2jaabkv4l1499vzbks3k55gb7985amz"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.2"; sha256 = "0qmkv3dfrqw8j13cwy3ky3bd5jbs781p4x4m0y2sw6rmfccv7xn0"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.2"; sha256 = "0lmncf55nigri5ivfrlzilx0x6m39pg62nld42zwv3bsncmnfjm3"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.2"; sha256 = "1s14lx6qpfah60rpzxjpinlab98j5kvl8nrmi7g3hjzigf3iflm1"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.2"; sha256 = "1pa8j2n09y062grblkq3ihy22gl71b91pff6ad0d8v7q5821ax2z"; })
    ];
  };
}
