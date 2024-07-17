{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
}:

# v8.0 (active)

let
  packages =
    { fetchNuGet }:
    [
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.5";
        sha256 = "0zfpmawx2pc1mjdjkadch2ycqfsvjxz6zr4r5lb2s9w8ywafyqcf";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.5";
        sha256 = "0vn6kq3svv9kbgwdfa3lswc4pwsqxplg7kc3srd1a07k4jkz9qn5";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.5";
        sha256 = "0cvzrnqizdccrajfznjgwj6qra8kbqqln5z6x2l9gqklawk4ncdl";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.5";
        sha256 = "0phhkwilyhh764m8pf403d3qv072ld0z7jg6x9sywqlb4q6za443";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.5";
        sha256 = "1m9gp68z0wyv0xxr4aqc1c2v6v8grml3jxkiqabddn46d6gsisqh";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.5";
        sha256 = "0mdcrzpj17g8xkk5j3flk5xkgp2dx44gamyfn9x5lf9siyi4812p";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.5";
        sha256 = "1r2hcmi5l05n1s84gdpiqys0bc4lik1fmp8085dlqz5pc5kg0ibh";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.5";
        sha256 = "1118p6981b74zzm3p1nr2kwd5db35y21z3xif940xahh52zc887n";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.5";
        sha256 = "1bd0spskxlc4kwqd260ycxxvysxq19hrz6z0chlbc8kxfwf3kf9z";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Ref";
        version = "8.0.5";
        sha256 = "0s62x5cv1bw6g4jmmg7vyfpj4nha3bpsanhwpbk1vwgkridwxfgi";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.5";
        sha256 = "0b50abmhp8l8qjiwqxd1i1zw1kfddpr25nxl061kxb319zp5qslb";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.5";
        sha256 = "1m29wm2i6666cl6jlv5r5y75v98qidqjsc74sl2xazxsd105p7iw";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.5";
        sha256 = "1f37i0f227lns4x2zxw670f7lj8lkxhpn805dk07xd2a70w3h54p";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.5";
        sha256 = "1b4js7g35nq5kx50cjbncrpychrhxqysic46x082g50kvkn877zy";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.5";
        sha256 = "18ln96i7md0b3p00gyaka8jr9hly47gkbyqsmyzvvp4b98z5lda9";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.5";
        sha256 = "14mipnqvw6h7pw58sqjjc7013znz9wgcdklfcj6nbpr3cvb297xm";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.5";
        sha256 = "1004mzihgamdrv66nd9bv44kk0qxbmzbqgjlrq54k8fxwy1602ps";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.5";
        sha256 = "1wv6sqhf77x5iac6h64sr1ip8qyz9w79wlvs82h5wxn84hjrb97h";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.5";
        sha256 = "0vz07rfkl7jday1qgjrgvqf47pgzqajx75fz9v3z55n94wdrsrk3";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.5";
        sha256 = "0176paxswr5phr8x29xir3sd4rxygp4w107anpwx14a2fbm01wmc";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.5";
        sha256 = "1rl8f4bgx6hmh4q7lgr4nvx6fb044rg96ja128m22v925wx3wq9q";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.5";
        sha256 = "0j09zajb36z3gyv6f7gw9d80kvcjc8z9qw52x4cs5bynakx97563";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.5";
        sha256 = "00m2f6fi9nagcv9s0f9nd0wkcq9qs6dmwchdp0khfsl3xj1hv99g";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.5";
        sha256 = "0jn3rpk6xcndrlkjvr0s8wlk4vgakvc18js0psmlrswrq9crq4ix";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.5";
        sha256 = "0l1shrv0rshx527dy90wq1w5x3rvx3kzqj1mslx4ysjzf8841q6r";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.5";
        sha256 = "15vadqfi0w7sdq0rh35rb9ph4h4qbal2i5m5ifabbfwjp7348z9c";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.5";
        sha256 = "0f5ya9gb16wi6jff586g67icwshsca22afx4k6vnssr2p38xvh7v";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.5";
        sha256 = "09wjap5ykxsyyxfplhjn7jpxbx8qnks6cbc0200nfx3xqi5hyj6c";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.5";
        sha256 = "03nin18sqjc79b4dwwfzd620vr0ph1jnj462sfaszhyrcxs41vz1";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.5";
        sha256 = "0f9pw81cc2z6jir7nfr0nn211857ac9ix0dq7rpib0ld0bzf9naz";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.DotNetAppHost";
        version = "8.0.5";
        sha256 = "0b8bdyckb4l2z4byxlw84pz4nfahp8kfx5valbll8sj0f9357apn";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.DotNetHost";
        version = "8.0.5";
        sha256 = "0wv2c8cf1fi7pm42by9dhyrld48cl5mssm70aq7fwa2hgnvy5kaz";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.5";
        sha256 = "1yg53pnw2an4vmw9aqmhdnrk54ir16i3q95lv44p3vfdx8az582b";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.5";
        sha256 = "0zjh0ang18sxayr3imidda99bbcna3iwml77f77fyw7cq5xm57xd";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.5";
        sha256 = "0bvnc073s7g9pap6cl0v18xp7shpmck6mfmcwryjzpj98za8fiz3";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.5";
        sha256 = "1lnxgpd66psjciafhgwm37lzd8a5n980m77bbmaclcmx1jf5knv6";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.5";
        sha256 = "1r753a0bhlz9iiw1k47drjmwckwjzzixzgggji8glp3a22p2d8bp";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.5";
        sha256 = "08wcywhnjl2pw5w2ybswnwwzgmyanxm4bma80rbz86xchlqakk5z";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.5";
        sha256 = "12r3is7ddra45yvkwqcrm63lhpya5l9g912xw4rqbnfz4pbmr8dz";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.5";
        sha256 = "1m3vglk8q3bycg6k5x3v29ylrb62kih56hn63dfzb7f20qb8xv8z";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.5";
        sha256 = "1pxw3wxak4x2pm2mqsz9fipzx98d3blma8y0cz03nqqcmxfq2lnr";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.5";
        sha256 = "1m60wsv54czd55qw770mcnv8m7lnn5s99dya38is7szvgjgq0zx1";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.5";
        sha256 = "1xdpipcybj54phsm1xn8ycfrwd6xaa8d67jxdakfiyzdwgbdqnam";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.5";
        sha256 = "17xj4qrmmb6yxd3w0xi5x9la1ywrzczbmyx975p0z97yx5js719d";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.5";
        sha256 = "01wq0zf646c87yz1zgf1vzvwd5kxjv8dfd0vvqq2w6af8670vxwa";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.5";
        sha256 = "1s85bhrhyq7sjks0frj4mkh8g1pd0j0bifd0wj3qnlagrbxmq33b";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.5";
        sha256 = "1qcnnshmqj6i6xf34pfi6ampvgcissclfs547yxjzgjizxgkkhy4";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.5";
        sha256 = "1ar9jssv4njgk6gy3nh81d0p81as8ff5vmgzranshyr6djrmshna";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.5";
        sha256 = "0d0yl060my0f9z3qbkzbks9jhw3zsms5issfa94rnkpgw9is40fh";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.5";
        sha256 = "11v1bk0wsdx87rdk32cx63118bqmrvl054ai6h231yqw75q680sv";
      })
      (fetchNuGet {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.5";
        sha256 = "0j4g9n88vdss1qzslr11pf49jxdv6pkbchdmsnis4nypp4nc4vk9";
      })
      (fetchNuGet {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.5";
        sha256 = "1gmgj6h9nhzdcmn4mq2vfv8a69ncwcaix0vyyk8rrzzcrypvizpy";
      })
      (fetchNuGet {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.5";
        sha256 = "04ihcgls7w20g8v3s47fyxc6cxx554mcmmfynkwp0206l6mfka78";
      })
      (fetchNuGet {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.5";
        sha256 = "1lr79q6bpmggmm1kpgr195662r47mnl4infva84w51daw6hkdkq2";
      })
      (fetchNuGet {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.5";
        sha256 = "0rz6d960kxc4c1nc31w46l76lkpzmrh74qf0l4qy1cmsdylkbsby";
      })
      (fetchNuGet {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.5";
        sha256 = "1cczas7zmdc8wal2n9axgz5kb5ccmh4i94k94jfma3p0c7s69msy";
      })
      (fetchNuGet {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.5";
        sha256 = "1p9hi32ibv12dyiwgysj60as2g53an0dqidgxl93pazmmg1v25fd";
      })
      (fetchNuGet {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.5";
        sha256 = "1l4cbxlw33grx3pyf08079c8f2cmwnvdxkqpnw0072sb50s8yqk3";
      })
      (fetchNuGet {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.5";
        sha256 = "1bzw2w73glg96mnf9cjjdk1bwz4z5rf8pgn1rmnpb3ldlawhz4g1";
      })
      (fetchNuGet {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.5";
        sha256 = "02jz8kvs30d9vnxnv20dc3w8q9vhzff6n6r1qcyym3zfalmc4maz";
      })
      (fetchNuGet {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.5";
        sha256 = "1hwfn3yy9iprikfvc0wz99fvb000w5nya2hmkix2fx3nydxd1gl3";
      })
      (fetchNuGet {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.5";
        sha256 = "18havx9c3m2py0zzccxh1jmj8wb2hq28vqixib0kcicgvdl3rwis";
      })
      (fetchNuGet {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.5";
        sha256 = "1lvp94im006cgi17mj26c9yhhzz6js0lxmdpqas9vh7qxlikj7nx";
      })
      (fetchNuGet {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.5";
        sha256 = "12bc6r867izzb6s092wwj1cfmi09qmyy7q6l1d8r48jq3p14v0np";
      })
      (fetchNuGet {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.5";
        sha256 = "1x6xwq8n9y0n2sj5rfh4pqzhkz62qxaa2g6y4s089f4bcg721l3d";
      })
      (fetchNuGet {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.5";
        sha256 = "06a37cr1pg1nmzw07nbxsvfs3q8wn5p4xiglzg1b4fdpcwr0xpl6";
      })
      (fetchNuGet {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.5";
        sha256 = "1wlrapi8928jd9yfck7kfjdzgrzkylw8d7k4faaxrkbxpzn687br";
      })
      (fetchNuGet {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.5";
        sha256 = "1q4wbircp3dcbhgc7vdxm2m81ywpw3ls44jv6i3j7hkvh83v7kms";
      })
      (fetchNuGet {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.5";
        sha256 = "1rrrfig168zv5hznv19b1pb8k5r6j9smfxg4jn4vcr8qmy0vnfi1";
      })
      (fetchNuGet {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.5";
        sha256 = "118558hm53ix8fr7lib2h4vgp6vmf1gmaxph75220c3v966wbbz6";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.5";
        sha256 = "1sjyap9avwq1p5gk2iw11zmqlh3bh1ch02phvmqp0s9pawwa6mvs";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.5";
        sha256 = "1s2n57qjggyznf23gf9gk7dzsr8nr8ypsv3gyacn8fvy42fvq9v2";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.5";
        sha256 = "04g6vriblgzhaf960pfjbxhql9xdqkwx778pklim0kck4prn39f6";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.5";
        sha256 = "18fxpdzlb9kqq754hs67aabklq7k13b1gxyjmbi7mldcn7yjw0wg";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Ref";
        version = "8.0.5";
        sha256 = "0mjwyl4ywakvzqgiy5gm0rld8fwxw7gp81qa1cn8ns2yn7ll2zhl";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.5";
        sha256 = "0805yfy47fz5348ydi54546g43qr7fp4wpb2xzry5nfh0sn0693s";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.5";
        sha256 = "0rwjw6ahinci3bajky0m421cg7a0h6rjdnx389cd3wan3ij5l8bk";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.5";
        sha256 = "08j0xrfp7b2vj9hxrjf8zdp0agj2jvwyr5xii9wbkhnq4cwikjgn";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.5";
        sha256 = "0vag2bgllay20fmyvvjbckjircry690sr2fykf010kzb4zmywiaz";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.5";
        sha256 = "1pf1m7miy6r430z5fbja0p38ixr4pj9jbh7mzqj6fqm4vqxbfiqg";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.5";
        sha256 = "186q4jy948hy128271rhsjy1z8isc45snvss37pnz5r0wq68vy3b";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.5";
        sha256 = "0njzarmfay3jhqmjr1qmhgsldsff0rhb5lnl6zp0c337i85yd7xh";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.5";
        sha256 = "0fwpmdw5d89mkmzfq16659mlswjp9fnd0cqdyfy5frgb3mi3g10a";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.5";
        sha256 = "0j68y9gp3ci4982imhdri513in9sldicx8xn6kvg3czqanc34n9j";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.5";
        sha256 = "1frixdwdpxjzkzlwrfkxrx6qnf4vpb7flhl7r1z2wi8m2x8xyami";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.5";
        sha256 = "1wmf8b422s3l6rld07zr5qyg43wp6cd3xnz80j45zmny6sl1ksd9";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.5";
        sha256 = "1yp69lwz1yj89258sq0pznr037ihng9444d06893vajyn86x2ys3";
      })
      (fetchNuGet {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.5";
        sha256 = "1r1bzbisjxqkl310yfqjrsivjg55l61rlw60xm77nr4iww4av6l9";
      })
      (fetchNuGet {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.5";
        sha256 = "0gc6kmqvqmgzf22fgsimfybdj7yp889nc50jnlskm20hp6mia4wi";
      })
      (fetchNuGet {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.5";
        sha256 = "0ymnh483ds18699mvcg0k2j1an8xrknsb4zb3nxj97246wgdh9hp";
      })
      (fetchNuGet {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.5";
        sha256 = "1r3cn282p3qv4fzsq5cwd5lkjjrv5dfqp54ffgh6yi9j9s2h0j99";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.5";
        sha256 = "1xkzzn8vg4h4nf63nbzvd5pk19y5cg3k0ljzkblva4knppaxx6k5";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.5";
        sha256 = "00dbmjlcfckpgbl4f44p8vfr5aqabx21jllsqkqcy1qnp8a504h0";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.5";
        sha256 = "1syiaqw9dmqm5n5fvwhaycip1d7mj14dcivjwbhyf5nyd67zy8bp";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.5";
        sha256 = "0jpf2axjfv8nwd4yiib25agfx2y1mmksxz8laf6akac33gf6swgh";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.5";
        sha256 = "02mpnyyklhwyysjz8rhk42cnl5v1gb64la8zm95nldrsgv1viw70";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.5";
        sha256 = "1ky9whq5k3a1x0amailp1kd5926lx3kpir2ji68wj80w7c4kpr72";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.5";
        sha256 = "1jaw4mgzsf7jjkqlzkxjbpj3jszpg86fgjjvkc2vyk91p15dsgll";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.5";
        sha256 = "1jw06my5ds295lap3q35pg4hqcqmrx2bjqjaxgxhm6vyaif756nx";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.5";
        sha256 = "1iq19frhagk99a9wjgb10059mh0k5wp28inwy7diivj4lpi7wr24";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.5";
        sha256 = "1qrmwr0vvl49slnjf5r63lyyl7zlli98lbn0g44n6ra8drbhdyp6";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.5";
        sha256 = "17i0cgs6w8vlr7fnypj4c6188rpc3sgkr80ly453nb2qrmkyhzh4";
      })
      (fetchNuGet {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.5";
        sha256 = "1x80i4rbkdanana8hhbhkw47410bpryinry2axxwaw6yyk5gyr3g";
      })
      (fetchNuGet {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.5";
        sha256 = "1psh3vxfp37xx6bdhgj7l7d9r6p0kkxwfi98i89l1s407nj6cwvc";
      })
      (fetchNuGet {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.5";
        sha256 = "0msnc3iqrlslipar5zbjhz7v4f27lc7rkyy1fv18rqv787a87bbx";
      })
      (fetchNuGet {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.5";
        sha256 = "1q6vx9d2z57idkickjfxf9jf90x9x7jmxz7lrhyxcrprnf7sscgw";
      })
      (fetchNuGet {
        pname = "Microsoft.NET.ILLink.Tasks";
        version = "8.0.5";
        sha256 = "06siqqihzhmxbkryrw3x3xvmv5fr6gw5qdyb6y8z3l9bzd5qdf7r";
      })
    ];
in
rec {
  release_8_0 = "8.0.5";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.5";
    srcs = {
      x86_64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ccccfeb7-0af4-4713-b4f1-cf49b5c8bd6c/5b04c0188dfcf78b70da78ae3bd7f3ab/aspnetcore-runtime-8.0.5-linux-x64.tar.gz";
        sha512 = "ffe6a534ed7dffe031e7d687b153f09a743792fad6ddcdf70fcbdbe4564462d5db71a8c9eb52036b817192386ef6a8fc574d995e0cdf572226302e797a6581c4";
      };
      aarch64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/208a57a8-fcc0-4801-a337-79095304d2af/d1ffa79af24735af4bd748229778c1a9/aspnetcore-runtime-8.0.5-linux-arm64.tar.gz";
        sha512 = "54ad859a3307a4ccce6aa794df20dab3fc38cb4a8fc9f1c2cb41636d6d19fed1e82f88a0099bdc9f30e08c919ae5653da828ae54b0299291dafcc755575f02db";
      };
      x86_64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/77cd03cb-5575-48c9-8714-6498ee88694b/8bfba2913a4db23e3dffdff779fb7866/aspnetcore-runtime-8.0.5-osx-x64.tar.gz";
        sha512 = "d214a8b6a60547acb1a7f879e7a82348585b699f714b73b168918ebc60ee580ca5ff973f64e7738063f79dd04f0807bef0d73e90ce42c3b4464b87b768ccd789";
      };
      aarch64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c264657c-7a93-4ba5-b6e0-91bf41341e1e/90fb45ed7d2f92c374899b1c7a5254b2/aspnetcore-runtime-8.0.5-osx-arm64.tar.gz";
        sha512 = "b1a47d2ae3b528f5c32b57e3a03b46d12a14126b9768f9dd5dd979d49dc6543c6aafe55684eae3890ffe6b867aa664805b920ae1514f67cc841b882d5da7c091";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.5";
    srcs = {
      x86_64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/baeb5da3-4b77-465b-8816-b29f0bc3e1a9/b04b17a2aae79e5f5635a3ceffbd4645/dotnet-runtime-8.0.5-linux-x64.tar.gz";
        sha512 = "3efff49feb2e11cb5ec08dcee4e1e8ad92a4d2516b721a98b55ef2ada231cad0c91fd20b71ab5e340047fc837bd02d143449dd32f4f95288f6f659fa6c790eaa";
      };
      aarch64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/00ca4d7a-e529-4384-8ad4-acb8237d540f/a7df4c26e3c0e1dcf8e17d2abb79aad5/dotnet-runtime-8.0.5-linux-arm64.tar.gz";
        sha512 = "cd6c0ac051c3a8b6f3452a5a93600e664e30b9ba14c33948fbbfc21482fe55a8b16268035dd0725c85189d18c83860ea7a7bc96c87d6a4ee6a6083130c5586c3";
      };
      x86_64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0dabe69f-fa99-4b53-96d1-9f9791bb0b6b/f72acbfd3b0e60528d9494b43bcf21ca/dotnet-runtime-8.0.5-osx-x64.tar.gz";
        sha512 = "29a8be6dd738d634cc33857dc1f1f6cc2c263177d78eb1c4585c96b5bf568f8f2689f1a30eec728ccb96a2d005049936abbfd44daca1962caf4f6d53325ba42f";
      };
      aarch64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/fac90ccb-5864-4d4a-a116-67387aaee61e/df82eea80efffad3c9ec8b0522847e68/dotnet-runtime-8.0.5-osx-arm64.tar.gz";
        sha512 = "5401135b8871d85ca6f774958e6a644ef2bf85a88d2358f15c3bdc928b21a700be428efede677d83640085461d000e55a28bfbacdc9f01af0334a6e8b257efbd";
      };
    };
  };

  sdk_8_0_3xx = buildNetSdk {
    version = "8.0.300";
    srcs = {
      x86_64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4a252cd9-d7b7-41bf-a7f0-b2b10b45c068/1aff08f401d0e3980ac29ccba44efb29/dotnet-sdk-8.0.300-linux-x64.tar.gz";
        sha512 = "6ba966801ad3869275469b0f7ee7af0b88b659d018a37b241962335bd95ef6e55cb6741ab77d96a93c68174d30d0c270b48b3cda21b493270b0d6038ee3fe79e";
      };
      aarch64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/54e5bb2e-bdd6-496d-8aba-4ed14658ee91/34fd7327eadad7611bded51dcda44c35/dotnet-sdk-8.0.300-linux-arm64.tar.gz";
        sha512 = "b38d34afe6d92f63a0e5b6fc37c88fbb5a1c73fba7d8df41d25432b64b2fbc31017198a02209b3d4343d384bc352834b9ee68306307a3f0fe486591dd2f70efd";
      };
      x86_64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e05a3055-c987-4127-a315-51d6b982fd67/fbda30d8e461b2c5098f3c405378b559/dotnet-sdk-8.0.300-osx-x64.tar.gz";
        sha512 = "12ed6044dad31c65d6894d7e1cf861a6c330c23761fed90ca2fe0c7d2700433fb8b8541c35bb235b044762f5fd33496cd6e92dbd70deeeb7b9e59423d9d49f5e";
      };
      aarch64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4d7af168-9a20-40a3-8744-b2f1c10c0227/3d6d8d16545d6c05125c51ef8142296f/dotnet-sdk-8.0.300-osx-arm64.tar.gz";
        sha512 = "98a9b56b2795bf6faa848062ed34d917b187eda220db50c8e73de1bfa37244dd68d8c3cbc598b5fc5be4620a2b92724f95d7c13299f8b873fdefe880890a1bbb";
      };
    };
    inherit packages;
  };

  sdk_8_0_2xx = buildNetSdk {
    version = "8.0.205";
    srcs = {
      x86_64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/7cdbcd68-c4e8-4212-b4a2-f30ae2ffdb19/48a359550fd7eab1f03ea18eb2689eb3/dotnet-sdk-8.0.205-linux-x64.tar.gz";
        sha512 = "2ec774350ca3192e1c68c9c8ee62d0c089f9bd03fe1aaebb118fbe7625f2e0960f5dbd800ea3f974cc7ac7fba32830f41faec9ee1bae736497ba05d9c7addb59";
      };
      aarch64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/96b5cb76-37e3-4514-a8c5-bb4834e275d3/b541205fa6efc3bd223b3201dcb7735c/dotnet-sdk-8.0.205-linux-arm64.tar.gz";
        sha512 = "092ce55cc45ab5109c9d991382e7ed7f40bc0281e94766738dbf179d618f03dbf8ba38e43c418a3d5cac0377afc5e5b82a969e36832e386b851f3679a2e988e3";
      };
      x86_64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0dcb3b2f-6bbe-4dc0-a42a-283826d8b9ce/16767a67d602bd267122a26f4c4c2935/dotnet-sdk-8.0.205-osx-x64.tar.gz";
        sha512 = "15f410ae81027f4537a03a00114873fe9bacf799d5ddc24663fefc3b1d977d237269fef48c80334bcaf7230495f304bb123f310692f880fea8cb8e0072abb4a3";
      };
      aarch64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c8126855-4f38-4d01-8e22-b7f93452a9d7/725dda9ebd1ae3486febf496217ba0b9/dotnet-sdk-8.0.205-osx-arm64.tar.gz";
        sha512 = "2792e9b0cd4fd69373022c5e4c17bd128dd8e31db773f51b39c8696f37e72af8c4b67d0c017ee068587c0f664efa8bbd9a0bc4472b072a7897d2ff4ef8fafa58";
      };
    };
    inherit packages;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.105";
    srcs = {
      x86_64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e898e5ae-041a-4e64-95c7-751479f40df5/9e36a84d3e1283e1932d7f82f6980cd8/dotnet-sdk-8.0.105-linux-x64.tar.gz";
        sha512 = "60ff271ee7851ff9ab851f9dc3e3d0abc87ac9b982959abfc8f0a3b58301fb6a0ff7b9f07f8df18668e1e8182c688d0d661bb9cb1771a2d40a0015d02009fce8";
      };
      aarch64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ffadc6b9-6f16-4671-866d-4c150f2888d1/256d5909ff60dae42cbd251347cc14df/dotnet-sdk-8.0.105-linux-arm64.tar.gz";
        sha512 = "8f04afa385676d2ec879ad22734a4c869d931ba4bc7507d0aa5889561d0230e382598057bdf75792048b28bd9a1c8eb187e80691f603309a46d6c50d71373381";
      };
      x86_64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/54b48c6e-1a50-4dd5-9592-8ae5dfbe9d2f/913341d866eaf3149a6158cabf9ce2ad/dotnet-sdk-8.0.105-osx-x64.tar.gz";
        sha512 = "052fd0783bd0901876a29b57a0f15e9f9cf859373bf4f3867a8f3e00b4edac5f3814b066be81c76d6bc74a20bd696e4ec65db48dc19703bbb4ee56d60aedd96d";
      };
      aarch64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8d741dd4-ab83-4bd8-8667-998cc1c6d345/c7ac6cf87561262db36b18e505150e89/dotnet-sdk-8.0.105-osx-arm64.tar.gz";
        sha512 = "f910adb274065fef581728e7d043bc3f0c105a939f659865753c11a0dd0b550bdc4c0bc01e2ce6f710efcdebb3966ef138986113f595af4d6a9be8b15008abc6";
      };
    };
    inherit packages;
  };

  sdk_8_0 = sdk_8_0_3xx;
}
