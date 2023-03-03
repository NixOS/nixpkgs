{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v6.0 (active)
{
  aspnetcore_6_0 = buildAspNetCore {
    inherit icu;
    version = "6.0.13";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a2234b85-9050-4f90-9fc1-695a428167ee/8d5c3cf8f557e14c7c43965b7cef9c41/aspnetcore-runtime-6.0.13-linux-x64.tar.gz";
        sha512  = "96239951972a04021b1953581c88a3e1e64553d05278fb92729c62827f38eeecd533845d6b0d3e9ba97e9d19701b9ee8e5c02d1ee54b8c14efe54c08c45c15a0";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b675e6e9-652b-42a6-a9eb-2813b90b41e0/88ba0bd190041c1db8a681bef7376ab7/aspnetcore-runtime-6.0.13-linux-arm64.tar.gz";
        sha512  = "72bb5a366fda26eb820c181dc76e43d3fa040feedcc76dadc9064b924c98e2c31c4d4f53e6cac5c325bbd3640b71adde2c605c4cb488435515049ffe9221864c";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6f9bcb00-fa3c-44d8-8f9a-e4a256f20e81/bb989e5cc189e4b51585b4b78024a060/aspnetcore-runtime-6.0.13-osx-x64.tar.gz";
        sha512  = "9e3608fcc6e8d9f6139d3ec186b253f13d9027eac322b9cbf8ad8f9e72439a95abd0bffc4d63f427b76186f4386c8ffe613a9bcc44cb2448e9ec9be31a2fdfaf";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e687d28e-8121-4099-b505-f52cd856f718/1089325f2ab576f007e246ceb174e276/aspnetcore-runtime-6.0.13-osx-arm64.tar.gz";
        sha512  = "869c2cbda288ff97f470e3c79bf63f33fac30c8ae2740f849254c0f14c7e694d4dd0e3cf283965d620fe86ab8742ea00e606da0455d683fee4dddaaa15d658d1";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    inherit icu;
    version = "6.0.13";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/2d8697ac-0b1f-4dc8-8c1a-3748763d5c54/c493efee79b0c36c4bc8d3c5039f27c7/dotnet-runtime-6.0.13-linux-x64.tar.gz";
        sha512  = "af52e1df5e48a1b7465f8137048e9ec292104526c65e415055e5f4630a13f1d4974ae831a143dd4f17e2a813502d90e2c0aef37c6b1eb7a23d01af7ffca5400a";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/79baf344-68fd-4fdf-a279-8b32116514f2/3f91babc487289f63c6f423da0a397ad/dotnet-runtime-6.0.13-linux-arm64.tar.gz";
        sha512  = "f70c8e51c06f9563f33a9a1486fba1487c7ca8f2f77a2de02d382f82bb041b6c432b9cd3a399a4a4e0188b8aa96dc4cc78e9147fa0d0c4fca7fffaec55c38903";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/398dc2ef-017b-4e97-8d05-cde933894da9/bce7bf77230301570a1af839a4ce09e7/dotnet-runtime-6.0.13-osx-x64.tar.gz";
        sha512  = "39ee6b678cd6cba46acba9a616df18814e1cb4bd94f276efc5e6e87644f48ec427b155a8e31e63383b3b9281b2f7f6fa73e3be682df65984b11338c5fb12fbd9";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/98cb1adf-c95b-4ac1-82b7-54c6ffd7c669/617b0dbf1ff662e78a6eb49b5423f304/dotnet-runtime-6.0.13-osx-arm64.tar.gz";
        sha512  = "73df25201ec16156ae57569308e1d620ccc1a28c86c2485c337a3a793e00e2ed2e2eb991ddbabf6e5db310c8e492eca5f0e8297144c4e10afb5b8c323bb75390";
      };
    };
  };

  sdk_6_0 = buildNetSdk {
    inherit icu;
    version = "6.0.405";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c7f21771-9b09-4c81-883b-90dff8760c1e/fe992d38a94cc6f301c0236db3920c0a/dotnet-sdk-6.0.405-linux-x64.tar.gz";
        sha512  = "44e719c67dd06c73a8736ab63423d735850bc607adf4b8a9f4123945b13014f8144b4fb2c4cfe790d323106b7ce604388cc5d617bc153fd7820878b9187a2cd4";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c05dfb39-64d7-42cb-8caa-d669c0509c9b/d498099b33fd336d01e28c38515cb21d/dotnet-sdk-6.0.405-linux-arm64.tar.gz";
        sha512  = "6c31666a95817a7049bd47717c9cf9ab159e94e90987f46883e272dc6dee92fb0d890f4e590faca4458cd2b3943133fb2fa58c2fc175db98d4c6c531f6b2c3c3";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3c785c12-6a6b-493c-929a-9a3f3dc568ad/6290551f01f9cc31039e70771d05aeec/dotnet-sdk-6.0.405-osx-x64.tar.gz";
        sha512  = "2a6050d72b3b453e8f9fbf73e40c1fc10b148c7cf6b5e6c30dbcd322567dec1450813b514361015629ec952718a61a5f3b8d67db9f0e7a32b149fbd874511c22";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9ef6ade4-4d92-4243-9e26-748a7c75c490/ef308e5e0bad95bc604fff5c5defd42a/dotnet-sdk-6.0.405-osx-arm64.tar.gz";
        sha512  = "fb1a66189cf54b14d1176ca9178673bef55aebcf16ce7616ba6b2d988b3152be7ad6d230d8369fd3a503f46d1f22d9074da8a48837118648821f7160f1c5533f";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.13"; sha256 = "0pld39zgx7rwcr0vcfrr6nkhjqjy8nzy74ambxlfavhiz7jjlz0f"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.13"; sha256 = "1a80w34yb700cvjzfcsq3c5sb32bk95ccgjfcvyqxkpzlgcc50xn"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.13"; sha256 = "0sllmnnqzczvqzdwgld8s0jz49k9kzp6qh1a2g98dw8va9kkz8l3"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.13"; sha256 = "1r9v95sjjslhwvgq9jg6szkqv13m5k15yk8d98njwxjz75y8hhq0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.13"; sha256 = "1y2gnkrc788y9k79sygx7dmgkj674qwdajyrxizx0a70rwmjszmw"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.13"; sha256 = "1zkbckl43qv97jrc2lpnab8xgxdw7i27r18l6ai544rfjbf7ympg"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "6.0.13"; sha256 = "0jmhv6nsx5fxg665mjqynk5v3avrlnxmzpf2m17382y0sdg3vhdg"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.13"; sha256 = "11hqmm9hf4h14vcx12iz5zclamlapsjamibdj4fmdgx9gj6lmmzr"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.13"; sha256 = "0rfpd0052a4lkpd3fqpszq6cch13dwkmwgg0ljc4x7y0wq8ddqrf"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.13"; sha256 = "18zm0sb9yipnkm00z1q0v3dfrgidj03jswxx132kvwfryy2dlll3"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.13"; sha256 = "1k49nrz5rw1yglkjypmmnclahib2qiwm838008yahk00ysy039f4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.13"; sha256 = "01zakffrqd75vkj590zmcr0c4bm8gz1d8g3czsw9pm706z2klsv7"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.13"; sha256 = "0sq1np4y9k651cl47sp22nj1vc3qyx329jr89q4z3idvic5ivbcs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.13"; sha256 = "0q2irgcpyw5yh3zrlljv83j96h08ry26wswz5xaavhh16w0g2i1q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.13"; sha256 = "1xy7x37mkdiv907xbxxc0aijjhgi2hli1s79adqn4adw8fbn2aki"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.13"; sha256 = "0cj9bxk9xzcbvy9rk3r6xwh9cywx80ln05px7hpdxs40qhjd1vy4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.13"; sha256 = "1gh7abjpsjq5067msbixgmck1c6hsdc7rzy0kkbg16j7yzs9219s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.13"; sha256 = "0ph1r2vhnqg7agk1zz4873983qy2i5nwa10q40ba3g96rdy2pg1f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.13"; sha256 = "0k035b1cmw1bk4nmdcjkn5rv6s63l6jcsns016i6j8nxsdx5xan7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "6.0.13"; sha256 = "0qdyvzqajs4js03gs9d4r9amqz50lk99r3hz39h053506dzdm126"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.13"; sha256 = "0asqf9j5hdgs2k5yvvx3mla80l7vi68x55jzd8vyw9wcqxh07r5q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.13"; sha256 = "0kg8sxi7nvp1wmgidv2a951pjranc38hdwi51kn96grqwhnxqr79"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.13"; sha256 = "0nfb559qalhr6k2d9bp0s2nj8rn09yvl1sf3lvdiallspawj5rmz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.13"; sha256 = "0rjv4mps6w4mkp4nrrj0jmgy6ykdgwrxrg2cp3zb2mahxz7m8f1z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.13"; sha256 = "0l1bq22d85sm36hrsmyf74hir1fj0msqv0c6d4ba0b64b3rwhvg0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.13"; sha256 = "0n78az6knnvrvbx3myp59vc25nmw34mzkhl9ayqaq25khwxicjl8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.13"; sha256 = "0i36nx014hn1945sn1s7l9kfbqn5qdy16qrhy36ixv8688yydmsm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.13"; sha256 = "0in8sk9bl2r2dgjf3ncvmqzbdnyvy2329bzmykmvsrq511c76gh3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.13"; sha256 = "1sq235gb213sal14g30x83hg4iryf4iid4412pwbmj9q0bygaf1f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "6.0.13"; sha256 = "09ngispg6j04sz5rlbhh28vyk90qyb8ix3zwpvqapn8clgpq29s5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.13"; sha256 = "02hfv113m7ig0iy1354y7h9hs8kqr0addsiplg31ibyifazwr1zg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.13"; sha256 = "1wcb1gik3njsrs77r575f893ik8mlp8q5ljg7bqyay7pi09rbkcb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.13"; sha256 = "0k543qhrf83r9bpanykp49lwkcwkmkz891c177g511vdygid7iyn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.13"; sha256 = "1pv1pqr5rqlzsc73l6gn7wk6gjcrnsig50wx18vxxz9zck9nc6jn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.13"; sha256 = "1r0nfv6f15xqbyjyz5b6j8lhg2645j6718d4q8jxv8f0h5yq0ya2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.13"; sha256 = "0c7s3y86d9h29bmhpb1y89sw3n9bc43vjh65bjn46kfqwrf22xw4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.13"; sha256 = "1rgig3239y7zzn1gjk8ngzwi140d1w7cwahlrn8zqq6dz8df7vad"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.13"; sha256 = "1lvnyhidw4qp0rv1p1l8lwvkjak7pv10agclq7pgybhf7jnsrlk3"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.13"; sha256 = "0rzzpai1d3mvlq1mvpsc3qrwqd5n52jq4dbcmyp422i14q96ghwf"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.13"; sha256 = "1yq9faixq36d2qcnc3x79yvnjnrvdi51f6ah71515rcs83xgv79d"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.13"; sha256 = "1cjxlydhv836gfyh21sb3bn579pf7p4fzcgh3fhanqry0ap7b63r"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.13"; sha256 = "1kdlw21rna5lzvgqh47zcpgzprarjbf20f101inx8j51zxa06xqk"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.13"; sha256 = "1cixlspmka8g94ahmhyqvnms77cmijc6hx71ifrlhki2704cx909"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.13"; sha256 = "1l1rff9hwxv8riz3n1amry5q4szgbkag7wj27l8p97773imy49sz"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.13"; sha256 = "079ayh9kz89sjg691kvbaxq4kyrz2b0g87nw05s4453xi9ng6fb8"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.13"; sha256 = "1xd7cllg3q535fvlihcs3n4rwymg012p645m0fnr5n4ghs31jsab"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.13"; sha256 = "1l7ca5fg6033cikpxhdnmhchnzs94aklqis03403v8jz35llpk8z"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.13"; sha256 = "11rwb65dbn1n0m2m47vhp30fswram419lif2c8s6z3vzpiryvmrs"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.13"; sha256 = "13fyyk2izl15x55dyivl70z80bmhg1nd1nyb99wl5vhws1xjpwvs"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.13"; sha256 = "1lzh157hhiwgikd6ji99by6y3hvmfjpim94xbsp6bk8p2gxkbk04"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.13"; sha256 = "1wgmy41ahxvg2jmvhg8pca77zr3lc814g9kp4d2krm5670r1lq6s"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.13"; sha256 = "170hmj0m09rpklbknafmn52qxjbggk806c50910nhjib5zkmmkk1"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.13"; sha256 = "12dp927q5rwp18n2wpf87mmizfbxmsv3f8yf79qi4713yp3xz8b5"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.13"; sha256 = "0v1x8d238kzz6p1y8gci67i1jykvy5clzpvpzjr8xfyrk2fddm27"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.13"; sha256 = "1pyb2p895kdwjbwqn8krjj311x1sgzh10vr8dkk1yp3m1yndrxcj"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.13"; sha256 = "02pba4c8s4bdd345ay1cdw0hmfy3zpgqm9xsa1a1ky9zbycf0r27"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.13"; sha256 = "0dw6k7ck92zc09kkvx3lp7ncnq9c32hzif56g0x33l6ylfwknnax"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.13"; sha256 = "1157vqmcixmspwfgkyg3xsv3jilv396j7rjg7irwny63h0pwagcz"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.13"; sha256 = "03iciy6fdnx48fff176h12l5zb8i3akhm5aqahr48aqaxw1w4720"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.13"; sha256 = "1s0m2jxk6h9mmisiafjviq3bg029z6px1rrw42r5pmzzxxn3yidv"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.13"; sha256 = "0hd7zycvdqmyi26lnvq01cgyl77r3nsn50xcmi1s5xxi27snzj63"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.13"; sha256 = "1qjkdwiycvf7v254719lrwb98wgbzvv6hf6983ysj4y34mxp66fb"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.13"; sha256 = "1py77bivdbf58csarc5hh2yicpdpvmjl42gpi9hmm1dxfsp2fc5b"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.13"; sha256 = "1gx01w5hcw839m8dwzxag5v0c28zjcr59mg1lkza7qq1cxfg46kq"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.13"; sha256 = "04m52vyh1cwn2vyiymjw8ll04cmbgw4rnwii6qgvym2w7ylzk5qm"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.13"; sha256 = "03xfdv15h21abpnccmqkcah514pi3aywml6pc7yks8ci8y9hsh1p"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.13"; sha256 = "0vf1b3i2rixxvlam47b86j204vnc9dlg046k3i79b2snhx2xcqxg"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.13"; sha256 = "1nzah18j192sbss06rvnsvn5a29s0hwhx1h6d1rnsbdq9rj75lsz"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.13"; sha256 = "0pxflhnq5l4kpwbj5vsljz5sjsch80rrijl18740x3wbzxxpafnf"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.13"; sha256 = "0xsd38czs1nyas79qdssgq5cmd5xiidpqrjx1rijp5c94yq55pxi"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.13"; sha256 = "0sqhxkba7qmyqqprwsa297fn5v012v8d35nvvc5qh5f1l498hi95"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.13"; sha256 = "0cw9yaq2l4nbz6pbnrh8bkpmgrzkrk3h9f4k506znwk54mjjfal2"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.13"; sha256 = "1g35gplkxr1hlbflifc4fj4b3i192cqbfhv8xlwz23qdn67fqyra"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.13"; sha256 = "091ycfgmlawiafaw915h716kmdrrprl12x87rcfvvsnps8r87p0z"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.13"; sha256 = "1nn0igy0a9l0zz1zdjfrqp41i1j43gx60swvycxccn68c0w0rx2h"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.13"; sha256 = "1cqddls75px9fnwjirrzpbpa5hgvsh81z3q6d6lpgm3ascw9v3sq"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.13"; sha256 = "1l9k4ksy19db950875qfwj884z2gqjc7wbq3wld58cyyrbw28g0p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.13"; sha256 = "0gclz5wf4ci3y5qqyibigngikvwwd1v4hmw8r2k8gjq9g0qxmrnp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.13"; sha256 = "09y0ly3akvm5jkkbn597pl958xmhsmx1fs81pmadis504jsny562"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.13"; sha256 = "0a3wnm499iy1jjsyxg51k1sg7b8zb6w7bdaw2j46lk5vcxcz7rlz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.13"; sha256 = "0914qs968m7xqp0wdj1icfqcnwh2zabmkiprw3z22vc7rmjm0v0n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.13"; sha256 = "1d52cacjdlf6dhwalj5bn2vqi8565xd40qpcj6fjxv83a1l80ys4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.13"; sha256 = "0ddygsnms3vfg6s7w2mcm7gqdmb4h7glrdj73hm1l42sndmn9p7v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.13"; sha256 = "1klwr4lykmfcppk2hb2lvx520jxx37aq9xdn9561kaydwis4wj9f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.13"; sha256 = "0zfdj4cgzjadbmm7jxfhfkz8ccf21zg517lxzi13bjmmimz3lap9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.13"; sha256 = "1zpif71jwd2pr2xcwwywyzz3wfkbp3y71rkfjmgk7zhmm0vjk872"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.13"; sha256 = "0bi2xw5v85zbk5nh466af1ppbl3g3pa1z5g3fn25nmcbimk51ki9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.13"; sha256 = "0ipqwxavmpkmg339scydgh212wd0iik0p04zfv2i53qc3j9ap1ws"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.13"; sha256 = "1zchfdhgh13y90yrki5537ik82s7rvcrzyf2y0cfdfw03m7f2yf9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.13"; sha256 = "1ndhp84v7l5ysi66qpqr18qddzvcg119id9d8fdd66fnr2hg207q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.13"; sha256 = "1qx4r2wmryyz7l3r55rhqv4nbjasn74cj0gyh547y9g1fbgh0ib7"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.13"; sha256 = "0jwlkn81larvl41i2hdayy8fx2s1b6zz9ckhqi0y1ixs0xrfh3p4"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.13"; sha256 = "07mdpz2cnyfxcp24adnfx2bzwwxwf9xpx4d87c24lghg1lfbwwca"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.13"; sha256 = "14vaay4mp1rml2jxm9z9qnfmmsiw1673bid7xpmx8xrpxkvbrmpz"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.13"; sha256 = "1cmmzfxnlnz4py738lfz8kdqrcgvyx4cyhbahk60qrynhsfz87yl"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.13"; sha256 = "1p9hnilvkbc7a0mppdmgws00qrhnh76z53j86jps8gsl7d4fm24k"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.13"; sha256 = "1gqsfxbm87qp2dcws8xik18vg66bdjb3s16kp83c3yxa2csnah9w"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.13"; sha256 = "0ibdldj4xzfw845r1bix5nahpck547cp4yb4qazhq6a86944mi53"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.13"; sha256 = "0zzkkwjll40fchaqfg2sy7p40acw7r54539qqanzbl485q61vxiq"; })
    ];
  };
}
