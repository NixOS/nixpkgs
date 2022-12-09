{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v7.0 (active)
{
  aspnetcore_7_0 = buildAspNetCore {
    inherit icu;
    version = "7.0.0";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4bbb4d31-70ba-4def-b747-4358be873982/3dbca5b64c2ffb88641c0e42bdeb297a/aspnetcore-runtime-7.0.0-linux-x64.tar.gz";
        sha512  = "02ce2e0b3c4b1d0eb0d9bdb9517a3293404b2a1aaf23311e305b856bb15723414f6328887788b875f0f80361f3e195c872ea3984971e5f0ab1ad5de43950d707";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/2d6d851a-4eea-4a7a-9d5e-f1d6cdccda29/366a3dd90251ce11d8c5191ae9633efc/aspnetcore-runtime-7.0.0-linux-arm64.tar.gz";
        sha512  = "ffee38cb0c8fd3ba20f3d814b7e141f94be18620eb91a229b80d7c609f6cad77efb7f8f276e9fbee4f3ed8cce33cc0659f0dc77faeb8f5427c95deead97275d7";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5ea36935-090e-4ca4-841f-49371b408d9d/6e0c2c4721dabbb9a237d6b6ed17df75/aspnetcore-runtime-7.0.0-osx-x64.tar.gz";
        sha512  = "a1ab796c04d17ade8d93bc53b58ebeccd541d30aa0438bd81ff66c728dc13f934043f98528417eb976ea426e58107bef371b26d5877a550f2397005c5362a1da";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e8576603-3b51-43ac-8ec1-fa96517e9149/7de992056c89e164f60908d9912f3a81/aspnetcore-runtime-7.0.0-osx-arm64.tar.gz";
        sha512  = "437f4fe11c95330eb56dc9e4a0c5836546d9e5b28f6cd0236ef563a82b0103e3526c0e6d50d44c90f4eb19bd6a1f409178d0f7b7620a2fff185aee6ae7cbe337";
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
    inherit icu;
    version = "7.0.0";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d4b0a69b-29cd-40ef-9e95-a8d16f0ff346/5844add76ae3917af9efd59d95e3cbd4/dotnet-runtime-7.0.0-linux-x64.tar.gz";
        sha512  = "f4a6e9d5fec7d390c791f5ddaa0fcda386a7ec36fe2dbaa6acb3bdad38393ca1f9d984dd577a081920c3cae3d511090a2f2723cc5a79815309f344b8ccce6488";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/edc62d2f-5c2e-4085-a6d8-11ba9abb18f4/6ca82f155ed65e4c1335214d2d948c78/dotnet-runtime-7.0.0-linux-arm64.tar.gz";
        sha512  = "a359402471c0c4f11f9e472ee6f8d7d165b57a29f132e01a95d3ee4020fa27f9c6ed5ede4b41786fd9bbad1491a4726c6f45d105c19695c0a1cc9a9d414ee614";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/93aca2a1-570c-4db7-90a1-de89a3a53f27/2d443a62676d498918def9188859f900/dotnet-runtime-7.0.0-osx-x64.tar.gz";
        sha512  = "b9b906561a443b0fc2064d7dfb9c497bcc157421c0fa7967547673e098c091a29012e36af3282d7bae9d51c216a31578b086d82c6e10ef6244e773b40ab57081";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/fa0f8c59-92d6-46eb-a35b-2063a888f26e/0dcd341b1bde64bd1a8ae91097dfca7f/dotnet-runtime-7.0.0-osx-arm64.tar.gz";
        sha512  = "4a0dabfc8008dc39c3e7da6315475d5a20d30715cf1f4139e45ad1579486ba005a876918cf69369281b47d6932c070e735a4d7d84dbef8b0ef79f52e12b21d02";
      };
    };
  };

  sdk_7_0 = buildNetSdk {
    inherit icu;
    version = "7.0.100";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/253e5af8-41aa-48c6-86f1-39a51b44afdc/5bb2cb9380c5b1a7f0153e0a2775727b/dotnet-sdk-7.0.100-linux-x64.tar.gz";
        sha512  = "0a2e74486357a3ee16abb551ecd828836f90d8744d6e2b6b83556395c872090d9e5166f92a8d050331333d07d112c4b27e87100ba1af86cac8a37f1aee953078";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/47337472-c910-4815-9d9b-80e1a30fcf16/14847f6a51a6a7e53a859d4a17edc311/dotnet-sdk-7.0.100-linux-arm64.tar.gz";
        sha512  = "0a332df58891e808c9adc2b785e9b0e658b29b494963c8d501b0f8806ff5d3daad4614886349cbba86af638ed7ac76e78a2d05aeca13bac25d5f45fbe62b8251";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/09e4b839-c809-49b5-b424-86d8ca67b42e/54be2d3868ae49fa00b1cc59065d5e2e/dotnet-sdk-7.0.100-osx-x64.tar.gz";
        sha512  = "86165993dcf768b3ce793e94739ae681f30b63b3f7fdc82c6da7692f3867f93c19ac5b9152bc8f45708f4194187d60b706e0ee61a37f6e1470536c95a5e53e1c";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1a0e0146-3401-4c2b-9369-4cb5e72785b7/8548e8f2c619330ea7282e15d1116155/dotnet-sdk-7.0.100-osx-arm64.tar.gz";
        sha512  = "d1af8592bc8aec43069f689449c159a4b13da419a924dab495b66bbf8c99b526c75c609171205b6d1b30bb0ff6f57797135245048e3629fbb33f462171107581";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "7.0.0"; sha256 = "1xzybxsi87vw5fdc0m32l2pdcjbgrj4a9m7766vv3qlm3pnw2gi0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "7.0.0"; sha256 = "07b7pv06nvzv6cgn68x64925bi9v120dczqa1s63z1wqih7ijk9b"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "7.0.0"; sha256 = "1sflim5k94kdrcb88jm8jqxi354r2bnycgsx1l19mraacpsxw2sd"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "7.0.0"; sha256 = "1iiv6vnb7dw00m9m6q3347in8z27pq8h1d759mx8wk4r35wzwijl"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "7.0.0"; sha256 = "1lnyb2v5ahk730fb7nz0z9vrpiyhn4plgvfl130x9zw6as9rkqf5"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "7.0.0"; sha256 = "1aq3lkp6ggsw5iqqyv4ain20c47r3yzwn21i5wbzdfivci0k5pl1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "7.0.0"; sha256 = "1izaa212j4363yajcifym1xxhja7qs8pnbin3rsjdkhm7fgffbw1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "7.0.0"; sha256 = "0h1nnw0h1p04y8n3p2gj0bgin4bm6byr4mklz15diqwy45c6whp6"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "7.0.0"; sha256 = "17lvrw4fp44kf68hx619kdxvmwzd27r2h57qi69dnby7v1givcci"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "7.0.0"; sha256 = "0vc2w7jrvh2hfxxs4if1k95wprzrvbp9dv9lcw84j1vyzhhanngc"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "7.0.0"; sha256 = "0xv3sr2a202xzi09m5m9q0034724mzfldjsw1j3jkn8csv7821gi"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "7.0.0"; sha256 = "0bcbb1znpdr4r83y0qjx7y61mzn43chyv7dhwsra4wrfmw8zk6r1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "7.0.0"; sha256 = "04lbvxk4vywaw5pgwl2ag1nr09a1kx7ji75yfw8igzsp8s3vlqcl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "7.0.0"; sha256 = "1hqrljfjzdsl356fnk3s60fmiwh07hzzff5lj6aywbpbb91sr9fk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "7.0.0"; sha256 = "155ra9i7k63ii10fcnq3q0kbbrbffzwsdrxddvwg891fr23jkz8j"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "7.0.0"; sha256 = "016y3d1337ddjg2lsy0bnls9pflljnzvwnx31caxzaigcbabqqkg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "7.0.0"; sha256 = "101773hcmk7w4cqlw9vlla2vw827lsqaasaalir06gpmrlr3lbwp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "7.0.0"; sha256 = "0vamf4d0cwxa4r9rvx2h05rr8dnqy365qls10s1ifl14bqpsjjlb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "7.0.0"; sha256 = "06rg0czvg9dw8xr95bvgmpdnmlrjxrqihmlg0hs84gdi3c748xgj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "7.0.0"; sha256 = "1gjia7vx6s5vlsniycmkiysygyq6iq8chfd660g7g5j5x4n0bijy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "7.0.0"; sha256 = "1gqs62v531l5wpn4l08dnygxawjdmdq7cs1ykqyic407mpyq35pf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "7.0.0"; sha256 = "0kpahfm1bmwcl551hq5bxd1i39qx2sigkdv39yxps72g8sh89igf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "7.0.0"; sha256 = "0pcz74jxwywm6228zih366qks718wrppb2sv7i3qm1afmqnfkxv3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "7.0.0"; sha256 = "19nax9xgm2pv6163l0dicy9ln3snz3rag5bcxn2vgvmsi6by4aa6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "7.0.0"; sha256 = "0k06bwbf1v03h4j4crp4x1iby1rvx3b277041glh8fywgpv55h08"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "7.0.0"; sha256 = "0nx8ds2f15bxxmhrq1yfvvhniqly1bnknzn1fvg9wxhphlbdync4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "7.0.0"; sha256 = "15czc22gw8z6lb31vwac4xgifmmhr1q62cgydj44ksgiq9x6g87w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "7.0.0"; sha256 = "1y5ci26p30bjhsmax624x5kw421k2ilf8jl6252cjclq8ghxn3i9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "7.0.0"; sha256 = "04s945gayk4r54rfyr3v35b49d26f35pvcng9m9wzzpg2wkyg4ml"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "7.0.0"; sha256 = "0zd84ic9zad1qjydicmbp6dgd342yx4vm382aqx9kfvvdz11kds3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "7.0.0"; sha256 = "1vqw38b7y59203j8z4af1p491941ixrdsnwl8yqc8akg0q74xhx0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "7.0.0"; sha256 = "026r4p2cxpyy0mh0a6fb9cnk2yd5rym8nl9pzzxql664n4fayw6d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "7.0.0"; sha256 = "1fkn84yv26r28blq3mjhxdzscci5q92mwwkbs97ldrqxfb4yi3p4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "7.0.0"; sha256 = "1dq50frd65gr6m297sgihsqwmczazr6yk8ssky2c1d2y0h8q6b64"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "7.0.0"; sha256 = "1arxdwsxq31a9p867sdfl6dxd2wqma1qpjpwxidaab76jgai0awz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0"; sha256 = "16mnrs799i2z367pa7qvr5hysf3wknbjr8mz6l69c979xfckkzyb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0"; sha256 = "0fwkyc22bicsqphmlaf26xmv0smnrdls9mknlzmwysxfnzqpg38z"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0"; sha256 = "056340npn4n4p19fda4jsd0za06q915sn7d12h4c8lqdm51nvrlw"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.0"; sha256 = "12fyxv55lgzf7l6wda6fhlj290r10hy2kqlvswj49106y00qcjfj"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0"; sha256 = "0rjvqr4v93cy2smcxidxplbfrdc211scpx0mnzrrhygha0jchs89"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0"; sha256 = "0rsyhklq5njaszf9q9csa1sl27ym0812q0gba2k205ngxgh082rl"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0"; sha256 = "0ixjyzv6dh5x9dwiiagiabmzhbq2qyk8gwss5viqhgdmd0r30isi"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.0"; sha256 = "0fw209iqv3xvz9fnhrrj1rrjfzpjgig8fr8iim0gl6qixw3a0q8w"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0"; sha256 = "1jr843dpcvrk363wb7zb674zchnvhwn8yw9jgbz9c5b2ql4swgkd"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0"; sha256 = "17xv2wl5cim11sg4zp9xc1jpz3wk3rld0xapzwz0h9af2v89yrm8"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0"; sha256 = "0y3k174hmask6ykhjs4p1sq6jf7zqivlcdy6nw64a5xvqdwfk43g"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.0"; sha256 = "0y81yay24b7idzv836znxryscvns6vy96y0mfdigb2rimv0h4wlj"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0"; sha256 = "0a7gy6pfaknrq692lls6rg6qxxq81db60qidhvxhrdp8y1m52d4d"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0"; sha256 = "0x8ib8ffx6sr4pdw9hxdxkpnbvsl76gqv7wldbv8q7fdzg53a1z2"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0"; sha256 = "12qx9k2a8v0vhc56k459fjykvqq46gygi88n03jfmvapnkvfmdbh"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.0"; sha256 = "0kq19a6wkc0d4qw46jmxdmsf8sg4l6lj3mcdvvxnz03n5lk4c6mv"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0"; sha256 = "0190xml4crgl27hiby096d4hg1wdy2pkdwcyq525qx5dvqvzpvfs"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0"; sha256 = "1pmirxjf49dh66in169rn56cvhyla8hjvnv1njpd2a8bjcl9sdp7"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0"; sha256 = "0wnh0csgdg6cxm82ylhg3bgq3lciha0g0463j36y8vpd9n891axi"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.0"; sha256 = "1xi7n1gx0a26i2c8jwfnmxlv58wbc3bhd7zjmg7m1cy3assqkil9"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0"; sha256 = "1qr7q4gxgk2fm2hqpkg5w144haica0aayz5jgm1zr5dmc5giw8mh"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0"; sha256 = "09yk8ay0ng7rgh0rw99igvm1cjyr5yxwfs7m5zsarwbq01hwp36l"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0"; sha256 = "080k801gqib24x230b7s64cra26vb3jgkhzg5f89897xz4zp7hy3"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.0"; sha256 = "0zkv1zdwfwwlpg0q49733mr8h2d5063gwp1v1rbcw8ka86srdb8k"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0"; sha256 = "19mc3hyxbqy5hpfi888sclv3mylvhc8pbpvnrjdv2ky82j3czn6z"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0"; sha256 = "0r4jvv7v9a0yq5p40p5idyr19kfgxck81yyljp9j79za8lbc7wh6"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0"; sha256 = "07s1vdl5smy94x0f9bd5036bczqhg210kzld4rrins1b6bmv4xl3"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.0"; sha256 = "0kr25wqfcpyjlrb78r0frl2181zkk3qlv9rli3vfb83f35hhdx9s"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0"; sha256 = "0jhidazb3x4mfc4l4zc6vblcdj3270a6r82pysdqrnhvmznlzic9"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0"; sha256 = "13vm2drh1fzqi92qrwbh9dzprsn56ivsdr87i1728ivmmka7iqdp"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0"; sha256 = "1glv394f70q3qjibzjig0czfpbk52k5p6kvv9rim9i5kqkqp4cvy"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.0"; sha256 = "04jm9hkvc57dk2z1parllrsg2zd4hgh9sizjlm2j44s3vm2djy0k"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0"; sha256 = "16r6b5pcziwlihc05li27ihxr9mjxd58clcnslywvyzmv7gz1dj4"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0"; sha256 = "0rw5r6lwdc759pys1cws09izij6vm8ikqwgbxnkhn2ll41qkwfaz"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0"; sha256 = "0a94ic4fd4nxdgiwmk09fg615ib62pfi2mqpypvwfb4kv804hvsl"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.0"; sha256 = "1j5yj4m9d3wmhv5zjwy07wz6gfdhqxh8vylwgv2651zyrlv7kxia"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0"; sha256 = "0w2a95yw49mr7k51b9cigjb0yryflfxjs2rq8p0r82y0njcxw6b0"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0"; sha256 = "0j7mxxgi6167a7l43db1my2qj9n8q6ww6qmfnndk6jrpxywajh3v"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0"; sha256 = "1gb27669992lxzlrdj3ah4k68hxr98rk4k2f83miqd2h4zbhp6kd"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "7.0.0"; sha256 = "04r7nikvzbcg55hx6xbcss9gwnad8cpy3fy2f0jh0ry8jh990h2g"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0"; sha256 = "1rb7myjhyan570242b2vhrk3cpdkaga6qvla54czlqgb20c56qja"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0"; sha256 = "0ssx929yz95b3vvnlb0qwb6sinqqiwlw0ykygaad7l2bxm4bqmvp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "7.0.0"; sha256 = "18z37bdi5x5ggmzxwh8kxd77wd75sqmdp3ynlzb2nfp7mvk10s2l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "7.0.0"; sha256 = "1qfbznic7wk6gy4c77ff3nrwvgx5pvjg26k05rv1dr8w6h58b7r7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "7.0.0"; sha256 = "0fx5zlf9spb2241f1apcyj0zq9kd2crm4mx3b1ccwirnfh20qy9x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "7.0.0"; sha256 = "1gjfp5f76g8bwbpmb9qfq116224zwa9vb4310kxaybdx5yb72iky"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "7.0.0"; sha256 = "1db2jawfmal5qxmswix8kwf3x68sh52r0r9ihdphivbi4nj8nsg2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "7.0.0"; sha256 = "18sf7x6kiigjxjvysbnk1sy0shs50lx6pxslfdcpzr349b7drgap"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "7.0.0"; sha256 = "1xwf795qwyajqk81sipr96pzla4gxyvx88cwpfaq7zclihd03p58"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "7.0.0"; sha256 = "1v3zcyqrrax5nh447bv2b6c2252l4mbi6xcacw4zjicm2v7kadba"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "7.0.0"; sha256 = "1v3j8ffghzd1wjl64r9wl3593xh7adycand78jd9sndiak27qgiv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "7.0.0"; sha256 = "1m62g19w1253dy289k4k490pxiavdalql87dimx9syqk81agknr0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "7.0.0"; sha256 = "1k3nihw931vvr8vj05x0f9gmx7fqqvnhlby297jdxpj9gsvssr2a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "7.0.0"; sha256 = "0wvf8clmyl6xpyi2casa2zxjl5x0f14cj5infkwrm7bkb0hwwj0c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "7.0.0"; sha256 = "0zjlamc8bgvb8lrfwmyimqbxi6b4gfn1w7fhfqf20050vyzivqdb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "7.0.0"; sha256 = "1zcn8hrmbvqx9w4d5pm69v1znwbpdl4573jwybj8w5myl5ni3jly"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0"; sha256 = "01blflyln8rgig20cim8kpjc2kj97vhw6ajxf3029b3692lkm693"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.0"; sha256 = "1f7jfxnw0vkmmwm5rkycqf8f5mj3815hqdbwxbg9cxskd46a6rrg"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0"; sha256 = "0fqbgywnhlb39xhxff0h68pvrx8m17w40z5b5p65jh597l56pgpi"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0"; sha256 = "0dm9pdm5d5nckfhid846kcpm0lb01g7rmpqmimj0qjwy83jdk88f"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.0"; sha256 = "0ccsg4z8fsyqlflgcd8dhz3kq0xc860nyd9q8amw76ig2l7cj2sw"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.0"; sha256 = "02r5nhn51wpn6nnms1kd8znq3zg0vs624wkh6qwc1raq1b2njlyb"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.0"; sha256 = "0451wbsgkf9gybkdijmljc7rsr527gbyy11nimwc8gn266cgnl9l"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.0"; sha256 = "1vz3wd1dgjwgs91r0qdah9nbs5lgf31rmrkyyr830cc9dj7h18hv"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.0"; sha256 = "1clj5f6ywj5agqdpzjy7slj4vx2y80djq54s5v6hdpcppvw7zykf"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.0"; sha256 = "0mqr862bdgcs08941ljmfxgj7srjx1gi3w4356lrvhr9qn754sgk"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.0"; sha256 = "079va9yfpjmiig3ig9zia831hby7i6dx4bg9axc3aikhclcr15sv"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.0"; sha256 = "15dwcikc033wakvgrqavyyxhqi9mc5cq2g54m8mxvdvslx91g2qp"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.0"; sha256 = "1szhmj9c0s2v3fvsawqk8rj19fb1w7hprvgfygaicqsfvqwlw7x5"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.0"; sha256 = "1ia3pvmyy9dlgpcn7lhvl3hlnbj3bjjlfd1gdg3bpwl1l23pbc81"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.0"; sha256 = "1y946qx7ya3kws9g005bqbr0k8hi4v7na3pfw90hvmr23g47fs5r"; })
    ];
  };
}
