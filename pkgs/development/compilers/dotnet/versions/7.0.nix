{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v7.0 (maintenance)
{
  aspnetcore_7_0 = buildAspNetCore {
    version = "7.0.15";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/30cb8b2d-ee36-421b-90d0-6650bf5180ad/9e2dff64d0134c46b74eafcad1bb658d/aspnetcore-runtime-7.0.15-linux-x64.tar.gz";
        sha512  = "8aae979c0e9c90e781b8747aba5d7e09c9a81845b936c9185dc16d519db3a4ad9e219da4bffe13476baa81c7ff3e1637e8ef031be1f9f305f7d1681568ae3aed";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/fed5ac78-3c8f-4eb9-bc13-2df4e97d01e1/3125fd43ab4eaf0e3304839295bf4bfd/aspnetcore-runtime-7.0.15-linux-arm64.tar.gz";
        sha512  = "4139d28b0c67497854794d34ec3eb3d7f4a49f34be4ed43cb634be88e7315af81090dd851fe2cdd429bf0050345f14000d2f939c020aeb809a1696483afdebe6";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1d44c976-5d7e-441c-aaf2-1b43b95131cc/b9f0c5a91fceb7fd47c76a7097c75c78/aspnetcore-runtime-7.0.15-osx-x64.tar.gz";
        sha512  = "75d01e3e123abbb5851c709a13d186a11db425bf18c82f615b445c2ff6629264a4d41e8011d43a225816ac807c7c8793cb35bbaf506455a3169a741d637230d0";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/478d989b-d381-448d-be80-f81c5ec93014/9a7b49e5a2c0720e290d19a9447984cc/aspnetcore-runtime-7.0.15-osx-arm64.tar.gz";
        sha512  = "7d090dfbc862d6329fefcb93ec74c5b82100fa1949ec92602b69871b48f467654fa6c18ec0553d1edd8908a87cc3682e809270c5fcfb3c93111be8adae86dd6a";
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
    version = "7.0.15";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/921a24a1-0a7c-4100-b72e-f948ff3b4614/1cf0fe858e6d42bf1ef88d775fd8d865/dotnet-runtime-7.0.15-linux-x64.tar.gz";
        sha512  = "3cec6eabe448ccf5105c2203928a6fe00e343f1f0d97c79614d41c198548a20659113b9507da95b63dedbd3caa6a66bf5f3750f4443744186e35e47de5c30555";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/854685e1-521f-4784-8a6a-b49307a3a4a7/6079b3613f0a297df59ab563e31074bc/dotnet-runtime-7.0.15-linux-arm64.tar.gz";
        sha512  = "e5b71578142f81809dd3e2bd5a9d673459c3f311ee095429b8e59929bd3ea17169c880113b7c86b8940c2db4bb1138f4770883456102da6b4b42ab7f0da8f8ed";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f10c8029-961d-4c91-922e-d81eceda9434/004a62489c01ae2a41ac7ec1aba2eec7/dotnet-runtime-7.0.15-osx-x64.tar.gz";
        sha512  = "bab7013467ae933e18f0c963319f19a54816fb3b2bda35316d45affb683c4e74cc1f6f7cd289c3ca475a2a0eebbd2809831f5ef908039c200407341f2bebb5eb";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/44fec9e2-bcd6-460f-b1a9-0e8dfddc98fa/06bcccde9a49279d460d2862f54af404/dotnet-runtime-7.0.15-osx-arm64.tar.gz";
        sha512  = "0910ae01475c5df70b846aa80b30fb85cd91349b43c682e25692d470cadd877d7965b7ecf06ce93a71f92a4a32c534a876e6733dbf45684628476a1c6bb6d112";
      };
    };
  };

  sdk_7_0 = buildNetSdk {
    version = "7.0.405";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5202b091-2406-445c-b40a-68a5b97c882b/b509f2a7a0eb61aea145b990b40b6d5b/dotnet-sdk-7.0.405-linux-x64.tar.gz";
        sha512  = "6cdf82af56f920c87315209f5b5166126e97b13b6d715b6507ddbc9a2eb618f812e43686b79de810ae6a21e0fb5a8e04d68a004f00a07533c8b664f9c889b5b0";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bdfe4e91-3a24-421f-881a-47b6d91404cb/cfe786933a6a7fd358b799af23542827/dotnet-sdk-7.0.405-linux-arm64.tar.gz";
        sha512  = "35c3b0036324f0d5a1711859f318863a2f24dd43d61518b38acffe9e278ee203007bf620d783ac706a615175b9c15d348cb9386c800aac219fb23537c03b919b";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/77e1c2df-aaa1-44aa-abc5-ffca44b1dfc9/1fea5228f09398a885ca956d1b537f02/dotnet-sdk-7.0.405-osx-x64.tar.gz";
        sha512  = "8525c009fad7fd0873ad72654a88f90d86b13ac58b17846fcf3d7cb696bc0d3c2c45bfb8d85e17a99f42421c5d6081aa4973d81211e42265efdc58443d075f5c";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5bb0e0e4-2a8d-4aba-88ad-232e1f65c281/ee6d35f762d81965b4cf336edde1b318/dotnet-sdk-7.0.405-osx-arm64.tar.gz";
        sha512  = "0ad6700475827ffc8f3dd16609f64368b736dc8b6dc07213738480c237a0d8896323959e05acb7f9510d1027746cfecaf4458f620faa757ee4f0779ecca24201";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "7.0.15"; sha256 = "092zx30wi1gsqqxdz9sxw901vzr4vr912qgfy27v2h9c66xwkawc"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "7.0.15"; sha256 = "1mzzijri3ysscnpdpf130i3if4c524hxkqbrgspk2xjnb4qgzgl9"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "7.0.15"; sha256 = "1qjsnv6cj1i55dj67nii4wsnw2yf2vk89r9nrfh385dd5azfr7cn"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "7.0.15"; sha256 = "17jww47v2yzj828wcvwwizbizfn5ygygfab8nzckr6cmfy24wqrh"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "7.0.15"; sha256 = "04qcxbqsabk89q4rk2wcrsry41ykhw0nm27garfhc67j1fy4xz6g"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "7.0.15"; sha256 = "04fa3r282nlxfhfgvkml9f1pmls94kcaxqq1kb7qjp1hliss9ld1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "7.0.15"; sha256 = "10qm75z6ril2rhzyysb24bniw9hzb3m8ipxq7pyw0pw80ppknx17"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "7.0.15"; sha256 = "0j6g9bal618di3arb9sjci2pnx1g33jxv73c3k6pggs6p46kkbfx"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "7.0.15"; sha256 = "19hjclrwwsv7810qhz6p3sac5535qz80y3rknx4r079082zyqmnp"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "7.0.15"; sha256 = "0mfipgk0szhc4p3pysya5gf02vlccz1s2k49swywj4qkarkxc4h3"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "7.0.15"; sha256 = "1wxp1w2wyx81glnngpzyhl6x3px9mg5glljnvxpd0rj7f2a2jv2r"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "7.0.15"; sha256 = "148fxdy6j0iq65g102dhq3wcplpldlflnfzb485qb557pyfs174k"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "7.0.15"; sha256 = "0jklf1dlbvymh18ijq20wnd6v2k3mjafr5k9yya84xl1srad22ww"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "7.0.15"; sha256 = "0mlvc3c0sb0qx33fxamnp1a00y28zz2g519mrhsr9qv6na4hihh7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "7.0.15"; sha256 = "1mys96zqvf2i8nv1j36797p3ha0z2c9xh7zjd5ixd614kgwix0ns"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "7.0.15"; sha256 = "08hvr3dwz0b78v3n7zn7q6qfa1yhy43m6z5rcbs4fd80gzkj45cq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "7.0.15"; sha256 = "0nwl2jivi0dfbkqkmfi5y4zzmvqc2z9sa7bl8mwxx4n3vyyias46"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "7.0.15"; sha256 = "1rrijrvaan4q9qkj0lfd0x9kqana49aiflkn2p2z8w1c0z781g5r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "7.0.15"; sha256 = "1nfah8by8mlzkwpglnf3x9r84gg3dskhhh502z01i60r1khrqli9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "7.0.15"; sha256 = "1gnzl52h65dczh6722w6hkwx8kp32zkqmhnvyd1xksspfi8ldzyh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "7.0.15"; sha256 = "1zn9w3avcl5ssj502dby07f37y0gdcird02v7qqnsxmsd426m8ha"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "7.0.15"; sha256 = "0lxzl2cjcz7kbbcy7m2gwyxisl2v4nw8z84pdlccklx3g7mdjr4n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "7.0.15"; sha256 = "0jf860xprgw4ly4iqs6mf4593h0gjwd7z1cvqgmljdviw1zaxpcy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "7.0.15"; sha256 = "16yak4qmv50yny9amanwsyi29v1c8331w3svz1fhvj02qxh7022z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "7.0.15"; sha256 = "0glwfimi5pzsz9j8ss39xmwwzd42bnagysxdmbwlk6cj8fdxkr46"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "7.0.15"; sha256 = "09c4ax99m8zibpv30id2jd90j6ixi2dam3c527p4047klnwgpjzh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "7.0.15"; sha256 = "0s7idg74b5qbrp6nr1v36s0rfrnz1rbqxikdvbf6whlvfqzjwy8d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "7.0.15"; sha256 = "0r86ab0iihb2qwh6n6ffmmzwsrgva0v2nvvv5gh9vyq00xfjw0wh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "7.0.15"; sha256 = "0vamqkhjamhfgd2a0rlfjjxlj3jfwqxw937599jr4bkx033galn8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "7.0.15"; sha256 = "1vmhysinify9yn3ad8894203y3p279471z2pna52fhdiay89si8r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "7.0.15"; sha256 = "1ir30gp1kv1arhhs435cjkl88yjz1az4wq5ylidrc4r5ny7p91yd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "7.0.15"; sha256 = "12hyxbzpn28a54x2370zvdd7kd14g06dzk6hlj7rwshla35m47a3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "7.0.15"; sha256 = "1hqbnvi10lyr5id92cf7q4k83rvk7qx2hprhanrdf5psvyqjqkk7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.15"; sha256 = "1dy7khybv18q8a7aarlnwps16j32frf0hhvzszx4vx4gpm2y10i0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "7.0.15"; sha256 = "1pd0429sm69jj6kd3a8cs0r6v6n6w849y8y3zlpdf8gzsrkdwbw0"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.15"; sha256 = "1aiizg0za2bahs1myl3fqjy7zpb4knnninylvcdcw71hl4lwnisi"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.15"; sha256 = "0ij656h7nxk2wlr2g05nxiridjncx6mm3limahhjy6pp89v1853v"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.15"; sha256 = "1djd5dj07bwr4rm95vpabaf6piqsdsz30bjimalyz9cams01air4"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.15"; sha256 = "05hqnh1ix7bixldcsp7a5j5fvyc19lfmfqyhvzwz507xl784704i"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.15"; sha256 = "1729n6l2yv6zxp71z8gakxnwcn0p6gfw29djpppkhyby0a5bqnfd"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.15"; sha256 = "027kppzv27ja2fvlxcx22s1vg8kk94rn0lm3b6hji9vhld05170z"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.15"; sha256 = "0dvh2shaw4dkq4ly2xgdw1agjzkzlifnal7s0fbhcsn2da59dqpg"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.15"; sha256 = "1zs1in0v5l0g59rjkhs3iikr9i0zdsnikf7dqr127dy181i558rj"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.15"; sha256 = "0dxh835m4v8hsv3jdw5j7rxk5ap5p8jsqbl86slc72x2jhfm93g9"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.15"; sha256 = "1h15sx8afa17c5jswmdr73kmw0anvvsgi48hzcc20hwn5fyj5cai"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.15"; sha256 = "0b6xrsdfvadnf0a6dgnwy80yggik4a8fvg41ladxfzdl3dzbam1y"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.15"; sha256 = "0xm0yd20p2f9crnj927ikh350n30y3qi0zlwqniv4q53jcs2nlgh"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.15"; sha256 = "12yq0ldk4snn6av6qk19vpsga20r6c71i2k7lhjq2v1cz29q92in"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.15"; sha256 = "0lwi12sy2ygbzj33r50myfjgpz06rccxpzhaa1mdv6qxr7c1izhs"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.15"; sha256 = "1454qcs72846p1hlvmhcvbdgacykr94bgcghimpj97xsgm2h743f"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.15"; sha256 = "0p0a1hgcrbasi58x43zi68q71fd200zvr1g5h4gr1ank0czgqb50"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.15"; sha256 = "03hxh8vc97h5ci8yzapamncgs4pw991w4a58vyd9a657ira8949m"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.15"; sha256 = "07klrbvw87q0fpx965r17d17wa7irw394nnnn8bcypwdibc0ib21"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.15"; sha256 = "1qz2gqjxi9h31lvvx9flzwrc9aikw1mrkd50rrc0i66hl0bv9wrz"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.15"; sha256 = "13bysjg14n6gykcd3a316ik73f7nfb2h0bbxil78dfcsfabzkk9k"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.15"; sha256 = "0icj4qwmhdpp09qypbccpyw64dcjg3ykb76iaz8a1lwys2gqq9cc"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.15"; sha256 = "0xzbl5939ap2s2jzncp8wchvwj5c56fbg67fr6422bbgh0i85fiq"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.15"; sha256 = "07kyjc3957zg8lg73xaxhvx25i1a3mb7zwvvp2icl93fl47pybam"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.15"; sha256 = "1adm4skcxhw3agpxgrg8wldzbzm77kn0nl3n1l1flq0ysf4j7x22"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.15"; sha256 = "03cdg58mhsqvm85jdsks29jv8v5bx8mym9ly9pn6i65v6q211brg"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.15"; sha256 = "1gb0d9dylq250ayydbcraa25fjyzlgx9ich4yh81cf6dw7zxk3cg"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.15"; sha256 = "14vbbqwixyz95skqg5lw9z634d5lw4660zzba036mlg8csq3m9b1"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.15"; sha256 = "16g06phagwnnry3fwh6b3c3iwhxmhw5ppnqynj4gcl2ir7bsdrb8"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.15"; sha256 = "178j0p4c5mxkaza5p2r3fxy613mzhs93a1jvkm8v9rq5qv8pwld3"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.15"; sha256 = "0l37908yz40pmqa2k8ssmj3ypgfa0cqmg9sg6c5b7liczdjnqyyr"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.15"; sha256 = "053ymy8khfq07p0r1kk35z1aykq68inck40j9l2lc4rixk2k9jhg"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.15"; sha256 = "10cnsrxk97f3wxhjax8plbaj2vhcznz9mdybpj2az45rb2abh5vf"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "7.0.15"; sha256 = "1nm7n49jkkvp8j0qfq1dvn48vq9d872chaaly14awql6ypfym5pb"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "7.0.15"; sha256 = "1509qr4cb469hb4dgnmsgm21dyxzwhhyq2iag2z1cxbk44mjz2ma"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.15"; sha256 = "1738bri3bs89hig3149kb9m6ia8dc1vp5ivkiz265qkw6gvhncb9"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.15"; sha256 = "0gq17d6jczj52lgc5c8i5k5gj9g37zp5gcsnvqdc5vaidq1g2ggr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "7.0.15"; sha256 = "099yrwc5f9lx0bczfq8dhq8v0l3hg0pspv3wr6yl2pqz2ziyk9ap"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "7.0.15"; sha256 = "1lljcbkzs1l25ndwzcyhwdh4q4rildwz7vza921r0kcg8zdb7izz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "7.0.15"; sha256 = "0hi97qsr1w0r660rv3h1rqy7cn84pnkgx49l4ckll88klwyvpq9p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "7.0.15"; sha256 = "1wjfm26b0dq2lsa1zrc16xjxnpi1z3n2myd7myjvmlklbzl59x9c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "7.0.15"; sha256 = "0zg8lyik3sdg24vy6w8974iiccy8mzln8gw8rs356wswk7irrpk2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "7.0.15"; sha256 = "03wsv6msyfg6fnbfy2hzkc67sxlhskcr6h3lndl5pyb5fvpqhj4h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "7.0.15"; sha256 = "02w4gk7zvdmpf774d2i2zqkz7nb98gbrp0rkv3klr53dklayqwhn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "7.0.15"; sha256 = "1bwam1av4rkx0pmf9x79lrgsnsimficm33jgm608f3csp8d69a9l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "7.0.15"; sha256 = "08g46m9ksvi1bjbxfjd59npycwmmbdgkdw0162g97wbzz5bi2gdx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "7.0.15"; sha256 = "0dcpi92xgrqqqmg5ka7wjbibzkvfcfgzis5jpkkfxmw6m3srswxp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "7.0.15"; sha256 = "1hw0djf8svihjl6mwwyj3zcx0rczf159v95w660rzh30xn737ykl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "7.0.15"; sha256 = "05pmq79i085r6g7l2gj96vxr0qr2m1775v2381ng6flmylyyjidq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "7.0.15"; sha256 = "1z2hj01n9r5s9x5vrvlhk7gbk8qp6381cmkksj45yqgn9ghkcid7"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.15"; sha256 = "00pbi47dnqns2xbkl72abfidssphi46vqa4qf8rwij7dvz46ddn2"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.15"; sha256 = "0if8hwxz2ibfmdzkpd8n6ga3zkvnrnd10vwxmj1wbld1c7ngfc0a"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.15"; sha256 = "1pka9lqwb9kg9k72i83p53f87md7mgb8qrcwwcjalk8g36dqygwc"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.15"; sha256 = "084pybg40sp61wirjgw7abrnj5xs7519pd9rjmz5y79gnwmspcas"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.15"; sha256 = "1kwsxqcdyc0ijhzsq1j79qqzb8p9irdjdjvrbghmf5mnfnnxhglr"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.15"; sha256 = "0d529y2ih0jjbw89wpyr32ljmdbpvx5v2cwpv8hxqqwwfm133fxx"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.15"; sha256 = "10sxjj9qfr3m0wjdms1h2bx5hxk9dkdy3fgv1fbp5b21gsk9vh2r"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.15"; sha256 = "19l103ajspna7fdkqnwpprm1q3vdgy0j1v2vqz0kxa3sd1vjs5ag"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "7.0.15"; sha256 = "0ndpv3xw74azx9kk9nk0fah97ysn7y006223mczk40cq32vwga3c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "7.0.15"; sha256 = "00ji50aazc4wzwdbvm9yhxw681xpar5nk7f7lbbipxv3mip9lhwc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "7.0.15"; sha256 = "15wgv5x0z2kc1pnkwkflvmj7y6iwds5hb2pjz5gq9z24a5v68310"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "7.0.15"; sha256 = "0g3djzyhlnx2qmwlyjvc2raq5r2ysqim0wlkdsxw87gi7lxy5xdi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "7.0.15"; sha256 = "0acrs1msmxdwq9nrmw22660yj39vi4ywlfjdki8i5s3h2h3ah9dz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "7.0.15"; sha256 = "047ydlw1348y36xz16sxvbvpc8ifypg9vbak43krshdxqkxdkbba"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "7.0.15"; sha256 = "1g5pmhknp9a3xai0p40idb2jds2s1kdpcfimcw0n8rc7w55vanqy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "7.0.15"; sha256 = "0dg2z3qph6ldapz6kz94pv9rrfkiqz0ydyy9rzcj93534iv72i4r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "7.0.15"; sha256 = "1zqqcmhbxyxi683l1qm3caj9d41agz564gsqg5ckb8zkpkwipilb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "7.0.15"; sha256 = "14ibzk7snns5d38ky1g5mwbxmf84x4kapyxfmnrz05y7584qxxai"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.15"; sha256 = "0cyw8m44i1yp85k651hwaqnfsc1hxla9wiin8159kjildzf618rg"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.15"; sha256 = "0xbbwrgzs8az1nkzipv50rr3iffs8pcnjcvxwmlmz1nrk3a3jhxi"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.15"; sha256 = "1r5vwnvkqv0xr2l8ypapps4b9qjgb1cw2fy66wrys62affhm06kg"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.15"; sha256 = "1ayhr32dym33dqxs8lcg2v2vgx2ka8gc3h734wxzj3rrf4ngjswv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "7.0.15"; sha256 = "0jjjnva0qb81x8nldq6v2d1166xm5yhvjs19gbvww36y6zlmm5bc"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.15"; sha256 = "0wjlxvpp0pdmfzpn1c7izadwfjqh60s4cdg4fvbdjq70cgxwf83j"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.15"; sha256 = "0mfwfr6fwp5hg33vmrdy0vk80a7xwg65zsqisgw9b8z07wsyj5k5"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.15"; sha256 = "0a56nn3d0vx4vanw0020sifayqrd3jqiyk7s3qdppkf7gxvd1wnm"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.15"; sha256 = "027hn6c8qzr9jxz3q61fqcnhwj7k2mbcr3s20igmawhmjfrfcxvl"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.15"; sha256 = "1swkh2ra7jqkghx5ka43s1s2nli21saypcnzjk9qfwh71np44ayc"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.15"; sha256 = "12skw2zb5v6wfs9za0s1hhcgdfm490zmm032l9wsrwj3flfx50ak"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.15"; sha256 = "04dq9pljyqnd312y071z0bi3gspzrymyiq9paqvaa3xyprzdyxld"; })
    ];
  };
}
