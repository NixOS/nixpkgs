{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v3.1 (maintenance)
{
  aspnetcore_3_1 = buildAspNetCore {
    inherit icu;
    version = "3.1.29";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d35c543b-44be-46ab-abf0-de8af9c5b3cb/4a17a6aaabe3f2f0e49de31f2f809713/aspnetcore-runtime-3.1.29-linux-x64.tar.gz";
        sha512  = "991918a89c1372d8d1eef967777cc9dd55d0cef827d940f068e701ca877dd6e14045c3a309e6e9c4a7f843eef6d1b192b9ae1257141947f999f4e8dd6b0d43e3";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/35d465aa-769b-4b28-aded-0043dae97ef6/685bea2c3c4c7e0071e93c6263299fb3/aspnetcore-runtime-3.1.29-linux-arm64.tar.gz";
        sha512  = "7cf6bccb85b39990d19ed5f42c8907e9fc615358330a060e9f93455c277143ec261f5255b6b05b081ade155f7965db5b092c956b0c77b2ebc9e2dae065f8e977";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/09fc8ad1-3cbe-495c-b34e-0db458c81668/271a1c1b56be2c36057fabf005d15f4e/aspnetcore-runtime-3.1.29-osx-x64.tar.gz";
        sha512  = "03978e8c131274d0bddb78ea6c4f590f015c0ce94527ff7b21cdcad4bd4a731dedb962cd773861f53b2e0178524f6fe5235f00f755b315ce4be47ae1573b382e";
      };
    };
  };

  runtime_3_1 = buildNetRuntime {
    inherit icu;
    version = "3.1.29";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8a8cff44-0a23-413a-8643-2a0fa3b4da3c/c937fe6ed4d60efb1ef2929d983398cd/dotnet-runtime-3.1.29-linux-x64.tar.gz";
        sha512  = "5c5ef6022abb5437e148c1cb22944eca7471a20a6a61300c6737c5f6e3ab0d95ba22d1ce55857e033c826a06359b601478228e3ef62cd321707911ad9d96bf67";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d859c2b0-4af9-441f-8c13-35e119224624/357a1322f8612211c336c63f25553f46/dotnet-runtime-3.1.29-linux-arm64.tar.gz";
        sha512  = "aa3444a91d37a10e892338ff3df0e601cb47f469268f58acdece939e5455c774f7ee9d7600736f72195c312e03cd6ce3fa47b175bcfc62b9155d122f002d7e5d";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/aaea7c1a-5c9d-44b3-8c9f-1968962010dc/0fc4b5693c319c46bf8911ec5c6e7a6a/dotnet-runtime-3.1.29-osx-x64.tar.gz";
        sha512  = "c4e87afb80d6374a4ec66b1e043156b685b80778033565f55bff521cde82c6eb69f75d8edd54db65cb992cba2b24b0e0cb0f44b97a87d2baf4761eb7e966edb3";
      };
    };
  };

  sdk_3_1 = buildNetSdk {
    inherit icu;
    version = "3.1.423";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e137cdac-0e15-46ec-bd60-14fe6ad50c41/30c102677cc4bd0f117cc026781ec5e8/dotnet-sdk-3.1.423-linux-x64.tar.gz";
        sha512  = "bcb0efcc066a668eb390b57fd2c944abe73234fdbed57a4b1d21af5b880d102b765f2a790bb137d4b9f3d0d4e24fc53d39dc7666e665624c12e07d503c54ceae";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/11abab07-d7a2-46b0-9ab5-19d5db67212f/783196073ecbd9fd64378fec412affbe/dotnet-sdk-3.1.423-linux-arm64.tar.gz";
        sha512  = "ba4f82e939be43ed863f059f69cdfb80b6dfe7cf99638bd6e787b060c2c1c4934440b599c133f61e3a0995f73675ae5d927bb047597cdd6a15b9074891dfd62e";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/68bf0fe2-c2e9-4a57-b6fc-fcee862d6a92/6d13392c3596710426f91c6b46c6ff40/dotnet-sdk-3.1.423-osx-x64.tar.gz";
        sha512  = "89c23bd2a4b9d10af443d609194db33de4a5b7ed5f1328b705a87d68bd4a413a7e2a3e18a8a047aa7ce757224f4e81f3582bc91c1f4ffe074847656f56b26098";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "3.1.29"; sha256 = "044b2yaf9y3nczlibgrrb7sajhddrfy0vyz426r1zsrab0zwmaza"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "3.1.29"; sha256 = "0s3xfrvjh0wvkn82qsh2w9nnnmg444mfqb5x769zlwdaynbcilk9"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "3.1.29"; sha256 = "13rjpmm4kzq4rvra5aa8bxsb4nxnlw1gfpldb542arab3pm8zlk7"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "3.1.29"; sha256 = "0gd7yq0d29rj4fs975lx60hsd2m3mxslz25hr0xy5snd8a87kjbl"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "3.1.29"; sha256 = "1bc8cg76m1iazd6c125mdsm0vx3ln5v9wr61baixip6sda4g2llb"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "3.1.29"; sha256 = "19w3x6pz37bi894adl184pb1k0iz58kwkgr3awvxh4sc8r4xbw1y"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "3.1.29"; sha256 = "1526b9smbv0n26bpsh7sl49wxd43g6pkasz387nkagh5xn4jfabl"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "3.1.29"; sha256 = "121x2vcn9ppyr12s2513ga4bchc2bw7y634fi3d1h2s6nkixcpyy"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "3.1.29"; sha256 = "1583dcz8j8l853ba72x6h4ajw3b0zsyp63fg3b10wlb321d6wnf1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "3.1.29"; sha256 = "1xj92ra27k6yf8fmdb7bclr3nqmqwg42b94v5p410cwvss57c1pz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "3.1.29"; sha256 = "0kma4dqkpjvdld3q4vzd14kbb2jmqjy0aqqjw4p2f30ibv337jvn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "3.1.29"; sha256 = "11ras34acbhi7rwcpn5j4lfkx50jvp2iz1mbm45aqzj6m2k27dxj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "3.1.29"; sha256 = "0r46zjrgg8zaskp83wp3q3k7sr1vvizc4xjvf6v34yhxi08aq43g"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "3.1.29"; sha256 = "12771skpb42mz9m932b2rhh51wc8jrbsmbjmjmdi0vl740dk07nq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "3.1.29"; sha256 = "04pjfa6blvyv4axvgbl3nlng92knc6a8i06xf23144m83crfkcm9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "3.1.29"; sha256 = "0il74z0m7pk7w92jjavxlln6lfbkn5jpbwpynnrvbrzwjbqzpvdf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "3.1.29"; sha256 = "1i7wdxjpm5xczsh3jfqlv2ph98dzpa7nw95am5v1nxhddf1ry8pa"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "3.1.29"; sha256 = "10bqdwxmm7v73mwyzs5jgf9fahjdzzyxwyrqvbl7fjrm5c9f601a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "3.1.29"; sha256 = "0wz2w821hwii61vmxf5plfp188p42i4s4zhrqjjkxaz8bxqmp049"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "3.1.29"; sha256 = "0yrqm145vkhpl4jprlzj6r9x0dd2kdlnqd4bmf1zr6lax4sxlakg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "3.1.29"; sha256 = "19qbbbib65bygqk80gkjsj416wjqi4mfjngginfsarq0shbl89ls"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "3.1.29"; sha256 = "04fvpjwldx0l9p3wb6r3lgha8bzv1vbgr0vhksdbwz49nnrx7bvb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "3.1.29"; sha256 = "0qx0lhd8kmxpsya942irsfknxk6l8wqfbgyb56gafg29j5w7fna1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "3.1.29"; sha256 = "1scc0r3mrmd73lck285d6bg4arwf685q5z7pbawxdajrfk1xlqq9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "3.1.29"; sha256 = "1jn4fmjz3nb6y0cajrw93nr4qid3319yjpqsyfqrr6zas1gyk2v7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "3.1.29"; sha256 = "02qgp4x0i5gzxqk1z9zwsd9pa94816yhvr70ig5y1faq343j1qcf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "3.1.29"; sha256 = "0za0ym9s7zjchfl561xp7jd1im1mpsvm2ibdhb6754v4qzr93vws"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "3.1.29"; sha256 = "1fhw97x4bbmpa1afzhmalnqi4fa1aw8qcqy4bnnwl18z00l269fw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "3.1.29"; sha256 = "0jgh3c3d29dqrjb9f41fxfawn5kd3bq1zcbvklpn1wiflqz9m7jg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "3.1.29"; sha256 = "19hprmp89jhf5q3yi2aryam6limmxppkqmr65w33gnzfx7iny3vz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "3.1.29"; sha256 = "1d3h117354dgp0j2395r9ic69dj5j1nfndxaly7vfn4ajl5g8jv3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "3.1.29"; sha256 = "0w1xirsyxr26jiadj6mdgxvhmn48nlpcg1pwv8ann1ln1kp8ascw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.29"; sha256 = "032ahrcjb93hn6s4j16r1nanigmn8jfgjvqhmy2mgpmcxrkj4ikr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "3.1.29"; sha256 = "0q2c7hkxrqkh1chwzp2ysq17z9npsflgq1nym66073rcvhhqxpgz"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.29"; sha256 = "17lf1jl1d2i8w56i4gazglahv2wvijx0xxs81gxn9ipb76hgr0fb"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "3.1.29"; sha256 = "0akljipsfv8vy0gwzj9kv6gi8iwfpiasx9zijp107iplmps3mpbr"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.29"; sha256 = "0jgb0v2jl8bw75j84mj7ykxgw6dspz26jsg941wyirh5namdd7d7"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.29"; sha256 = "1i8sjzbr93696gcx3a194zvqp9wadw9p7880la9s349xan30c37b"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "3.1.29"; sha256 = "1m1klh13bsvkgz145ibz07lzycqi0sxnl360d0l3wjs8qzfn09f6"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "3.1.29"; sha256 = "1qfrzw54gfq2583n4n992v828hzi11y30ylbwp9shb87jvqwcbcb"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.29"; sha256 = "0p5lq2hx315bc3dhh59liqzlx5gh4q9v862lc0d02yznxnfkmhfm"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.29"; sha256 = "1pviax5b66nw4420kz5cp2g2hxyjzfrk1bcgv3my28ravh0fyrjr"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.29"; sha256 = "1p25ni981b0gwqfn67viyayfha47rpqr7m2l0vdbysq4b8nbc7dm"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "3.1.29"; sha256 = "0jsjmy07qmqp6fh7wnddz69q56c5kyx7vfpns5ba0k65ch1s3gn6"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.29"; sha256 = "0msdl6wf9v286pdski0hmszh6g73365k3fygyf7fb78qp262aj95"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.29"; sha256 = "07mgal05cqr05lwxrcdqjhnkmbf3hqjs7xx54pf55knxj3wwglhr"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.29"; sha256 = "06rjafh7hx3pc0m4a24r1a8rapiz2d4ayvnvlw6dr01ajz8241q6"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "3.1.29"; sha256 = "1j4mxr8xnm47bi81cszzd9kfhnggwdff865imib39h36m0sn5r5f"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.29"; sha256 = "1c4m9qi1glarvbrsxrddjfbva1pk0k8blam9mpi6k0rkg8s3w187"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.29"; sha256 = "1wnz47s15lhhxy49fraiyf70k3xqcad6bm6rq66n6kcy9b0miym4"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.29"; sha256 = "0vxpakngckjx3n7bq2ykjf0dfdjk79cpxj0mq7dgwvkvq350s96n"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "3.1.29"; sha256 = "0z1bn3afrp05rypq9wn74a5p7sn5l5pi2qhl9hfdf3ds01bsw20z"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.29"; sha256 = "0yl3wajrflysp7g0bhqig2a99pxghxmfzsys0s86pz01w2fnmp9b"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.29"; sha256 = "198xck9pxx5yc9w6i6mi2wlbg67jchfl8v685s6sdvs0yjy8yyfd"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.29"; sha256 = "1fgl4z7ghrq7g35as2i8qpywq2g6nbh9fag9655np4973p68v4fv"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "3.1.29"; sha256 = "09w175d7zvfkp08c4sgpbsp1fccblrf480hfv2hcsaakz2g2zai9"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.29"; sha256 = "1phdxavas361204sm46la826392wxgyzx46viw7jbbnj6ywrkn6p"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.29"; sha256 = "06xzc7w773dv73x2r1zx8sad7ryzjz4wwpmjx45z0a74vn6l00r7"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.29"; sha256 = "1imng24m75iaxf4hgjwq16m38lsadcsghwp85s983hr09w89z0sy"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "3.1.29"; sha256 = "1snjl0wkyzibm70k3diyz7sdqclgxj3py4xxkp66d64abqr0245s"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.29"; sha256 = "0g8w0m6ajym0hdbhf4gdjv6j863nsl6qbnh7avr6zx211f2jxln8"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.29"; sha256 = "0wr0myb0mkqihp8da5q6vg7nlaz1w0a2wdzhk66aqsfvg0qnj3xh"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "3.1.29"; sha256 = "17n11bqlj0wpb1ixiag511m08ilhvhdmvlgb98rsbcms8jzynf62"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "3.1.29"; sha256 = "089jd0l2j06fbh27qphhsf26lrxd614qg5ymn3y945qsvxf4662k"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.29"; sha256 = "0zqmy7x1wr9shyzgq51l2a96v5kydap71lwcjbwgbc9vkxrpy0zx"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.29"; sha256 = "1dnsgp2bkimp2pawfr79nrqixhyrl6bxshksgx4sgiw5ihh3i11j"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.29"; sha256 = "1xjlxskm9i0f1chijbis883jrjfdlfhsy3blyjq1dg5wa3lyhb4s"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "3.1.29"; sha256 = "0vrahr6gr043c6q7frrjllapifxc6zz55331g5xzsxdfygnk4mb3"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.29"; sha256 = "0kzqygz1jbi7xk36bq76sy9yg4dbdnmcc42agx86igi8qlw0b1ar"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.29"; sha256 = "1mzvnj1wqqv8gnmkq95yxhwqgkldfpr1a0xisp76if0235l14iq3"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "3.1.29"; sha256 = "1zrmwm1shhvxn6c07f9mmjcxbgp18y9nshai8w02lwsw2lp7pan1"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "3.1.29"; sha256 = "0ijn3n7b9h3a2hqxdfgndk8k7chzyb4gry2ymmvgfadhxy4b1vxz"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.29"; sha256 = "0wlxy7pipblk6pyi8yxch181vvxxf1a203bk8rksgpikwswpci7s"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.29"; sha256 = "11qnmn4cy54wgml04bb2xr3m9jmgss8v5c5215zmfzlsywr9gcfg"; })
    ];
  };
}
