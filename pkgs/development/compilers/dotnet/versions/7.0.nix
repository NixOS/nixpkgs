{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
}:

# v7.0 (maintenance)

let
  packages =
    { fetchNuGet }:
    [
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "7.0.19";
        sha256 = "0da47yabymn7q9viymv9g3apmmaibfddnlix67qpxwn9cikbq459";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "7.0.19";
        sha256 = "0i8mhcy09lmjqhzqmwvp0n5qkizdqin3vap206b2ad28yl6963wz";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "7.0.19";
        sha256 = "0gqwm6as0lyjawwvq7cgks0ji7cfld495h7hcl553f1vpy3wsn2q";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "7.0.19";
        sha256 = "099yl2cpqmajdlax174z4bxzw2m4ry5abfx8s10q7h6d95fcnmrp";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "7.0.19";
        sha256 = "1zypq8jgk9z3kn3mmkdijvc9h65iyy7gaif9p0vhnylmvvm89jzp";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "7.0.19";
        sha256 = "1jmg7sxjnsmaa7ag6bgyhndlhvibswcmnrw0n6sr6crw2y0in2a3";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "7.0.19";
        sha256 = "0dyk2x5jc3vdpfyl8q6q6wqz8hwzsgvyrjd3956mvs3mrp00brp6";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "7.0.19";
        sha256 = "1g941bzffbdlqlxpgq356mv6n6g72d2yn0rhv0ix53834369367i";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "7.0.19";
        sha256 = "0xz2lacyda09kxs2d7hasvh51dw6pa6xs7k0q809ni247v7bnab0";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm";
        version = "7.0.19";
        sha256 = "1kkkajxxdbcy1kgh80183l8v00fv1l81kx5wmxgypz15lqnpmv2l";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Ref";
        version = "7.0.19";
        sha256 = "19pjhnx49srxp1qwknc390gapc44019wy4adz9caxpryw0ch4l1x";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "7.0.19";
        sha256 = "184fjnln6bzg55xz1xc3bmgaanlrh7jxn48fccks163gnir0frjc";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "7.0.19";
        sha256 = "1dqilsqwwymy7fq2pnvjggn5mfvizqsisla0c36w53mg6xx7vn78";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "7.0.19";
        sha256 = "1pld28mqy2gy5rsy688y0n5lhzrqzhv1pszqq4bx2ki2rcqka4y6";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "7.0.19";
        sha256 = "1dv4vk07a7kj53sk1nf63h51swzk9yl4j7jdvkc5w2v0z5a186hm";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "7.0.19";
        sha256 = "03766ks38fir978qm6s958zzywvqlnfqsj4mq14ifq36dphmkp4a";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "7.0.19";
        sha256 = "034v4p5w946yvfialqszaywjncqixv9bpc3x8v87wyr95pa3b7bv";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "7.0.19";
        sha256 = "0jcfmaq4ckcpywwxm1ack9xa001aic8pn85ggglidxgcfdr6mpzd";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "7.0.19";
        sha256 = "1srx048x6nv88s308bfn2vsg9gyqvzmgn4xlzknm9yr89c5pm96q";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "7.0.19";
        sha256 = "14l69l4fnvykmyq48i60xaipc7n72l5acjwvbvm2hg5sx848mnsv";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "7.0.19";
        sha256 = "0zs1jpj64wrjwkw3yqs3ryl08m9qlk3ksv74cy21g6bgx3xaq05y";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "7.0.19";
        sha256 = "05x34bg48y4aas3yv88ksd84vjz2jj1y7hjkwddmcpd4ni90ixmh";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "7.0.19";
        sha256 = "1d84xdva4av8mv2msbi759fb13sxig0qzdr6a9pmlq8gb8hf7zma";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "7.0.19";
        sha256 = "0m30aykrzl48i8589qn8z89hm9p1yl71cdigv1f09fmwb7c6jfm3";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "7.0.19";
        sha256 = "0akwsg0q1498ribamba3qkabp0rgn941dsrswb29sbpwfyyqmmgg";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "7.0.19";
        sha256 = "06xcc29albls44invg5dfyjf3qzcn991h7sdlbhvc5v0xyk72fhx";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "7.0.19";
        sha256 = "12zgh8pvbdl99zs0rq5ajbl91r976i47hdrrvxl2hbsxl2ws3brs";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "7.0.19";
        sha256 = "1lwnwxscza5m7pk83fwjz5r9kms3ybag2rl07f3gqp3b203iyyxx";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "7.0.19";
        sha256 = "1kgz4594742cd72vh23ra5gr4b9sgxfim2b608z9bmp0slnr08k1";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "7.0.19";
        sha256 = "0njfv091dlc7aff6nj0v7g2b583ns14lkmjf93z184sgav37ynvp";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "7.0.19";
        sha256 = "0hssqp21mjsacxf53g7jjc6ss3689199rxymlzp1sswjhhz8w9ci";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.DotNetAppHost";
        version = "7.0.19";
        sha256 = "1pja0r3p7n41hm0bjcdvmi4ymsd2jr7m2pcky4107dz8lf2l0axb";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.DotNetHost";
        version = "7.0.19";
        sha256 = "1yfy711lpgngy8qmzywjmc7bv0q9j1dz4c6g23vd7q25nw05jrr4";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.19";
        sha256 = "0ab5phjb7vs9rc2cynsn5wgxfdh4lnz97whw9n63dyqmi1zp6y7w";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.19";
        sha256 = "01v9j3j54m2ff7qdfvm5gk77vggjyfy42fjn8lcgz38gi6z57742";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "7.0.19";
        sha256 = "059qxvvyyqihxfmg21c3v6ykb0yf6ay88pc9r1dv27say4glr28q";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "7.0.19";
        sha256 = "09ra2dm7zqjm000rpz2l6jqsf05f97kkkd754djf337h0kskwfkg";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.19";
        sha256 = "1dbzmscgp2drqijl1rl8jkyn1bawfyzq0xlndk1knh7lwq1qhrwz";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.19";
        sha256 = "0w2gvwg8mipvvp9q88asvpaxg96v7k52c535sd70b2lxmwgaf5aw";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "7.0.19";
        sha256 = "10xjjhbivxb37yq7a417r3hmp5vvk75800jwlysfa241yq2x3ysk";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "7.0.19";
        sha256 = "0frf9xf70fh595m6hg9h5wivhvm229dd9w1zij4jwsl532n9s80i";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.19";
        sha256 = "1agbxkypvhcdwf2w3zfnsx7ncfi5nzhnays7b8ciawnjr3jp10gh";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.19";
        sha256 = "056v3fyc0bqad3kixcggzvjrvflxhiiivy90s1rd9gbcm79zyg0x";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "7.0.19";
        sha256 = "1zya7f9gp3rr31kshw3c53wmqz5f8qdr511wf2vyi2854b1gm96v";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "7.0.19";
        sha256 = "156zby9bxx1mcfnxjvgbcmlxx5zi5l3dys8kgb1wfy9ipbhcjh16";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.19";
        sha256 = "03z39bbpq5h9rvs9ixcrhvf18s3hsfap5zsi0j3yrkf8v5zqziil";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.19";
        sha256 = "0agdz3g1v33d8bxm7fk1c0mvlkyh5hvr17f0d5g3yzrzlnrxlc8s";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "7.0.19";
        sha256 = "0nkmj3hl0w5b8ndx0yb86dddq6w5qcknw0xvr40d6rlafsgbfdq2";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "7.0.19";
        sha256 = "0fkkcm9bd7kv87bwfi434ikh0an2n6g340vr3pdz8f292r9kq4d7";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.19";
        sha256 = "11sa38y72qi8v5pncw8j2ql89q3rl27nvmh1bpq4rbvnspl4pvqs";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.19";
        sha256 = "1hrd03lbk63p91fn0rf0fybqwqk2mv57q2g82qns0991cl61fvi8";
      })
      (fetchNuGet {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "7.0.19";
        sha256 = "0b4kq7c2rcngksq0xf12ijhjx9hch90hwrzw5icffqzhqys40v4f";
      })
      (fetchNuGet {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "7.0.19";
        sha256 = "0j1giclx2kn3mjwm8kbw1jsv0vhnd65jk692y1y1xvzz9jbqfs5b";
      })
      (fetchNuGet {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.19";
        sha256 = "143j9g5k661dqx9lwsgia215lr7rqz04xk2rk8g3vxckbnk7rzx5";
      })
      (fetchNuGet {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.19";
        sha256 = "0lf7i88b9mdb72dgzc9zk478gwws4saij721v2n6z5xx9ggn5hyp";
      })
      (fetchNuGet {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "7.0.19";
        sha256 = "012h4pb369y2wrb8rmvvklndsgphh6a6gd1gxqzl6bqfpl716njz";
      })
      (fetchNuGet {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "7.0.19";
        sha256 = "01d9xrh0wczpdyzm6zqym9w73his56lq455hc8nkz9ga5a2s058h";
      })
      (fetchNuGet {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.19";
        sha256 = "02wvkzmmnfj55vzanll95hl2pgg1ihfzarcwkhgnrxyx4j6qrh40";
      })
      (fetchNuGet {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.19";
        sha256 = "0kgd9xl4r39pr4kcpfxgc8s13gpjjzamrkiwhnsj5mqyphslgfp5";
      })
      (fetchNuGet {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "7.0.19";
        sha256 = "066wx7m5vj841xqqbdw4qshsjxzf0g6n7msgxjyqn2aw58w7kk9b";
      })
      (fetchNuGet {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "7.0.19";
        sha256 = "08h5fybyn1dfpsr5gqz7xkafavgaacbf6cijq1hiynvjw89cm7ch";
      })
      (fetchNuGet {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.19";
        sha256 = "1wvp2xlzh4arsnj7fz7p4714af8j19h7b847kzvafg31ns02ws5h";
      })
      (fetchNuGet {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.19";
        sha256 = "17dr9r8j5kqgkbpnj5j4s2hikk0aiv61xvqchr3vp1pjrpzfi231";
      })
      (fetchNuGet {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "7.0.19";
        sha256 = "14q5q312nz1i8q8ffiz4v0rp9fd52n3pv2p4vn71lavcplh3sfq1";
      })
      (fetchNuGet {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "7.0.19";
        sha256 = "1hfb76mkxkqc88km752irifbxjd745lncvy0a0zxxahq0hacj425";
      })
      (fetchNuGet {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.19";
        sha256 = "143abqzcq2s22gz32lj6z363fw6hll6mgm6kh530qr437rb8fvqh";
      })
      (fetchNuGet {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.19";
        sha256 = "01pxl7n3iygdnzj1b08vz87d43ysc5yqzy8yifriy96yf7c9syb2";
      })
      (fetchNuGet {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "7.0.19";
        sha256 = "15gr2dknc4g0dcg6zkml0f87i4hx7hjz7glmknkpy3bsbadlc075";
      })
      (fetchNuGet {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "7.0.19";
        sha256 = "1mfk457maqrmxi0rwj4fhchbj0yj65zsr072374idf61q9fp01wc";
      })
      (fetchNuGet {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.19";
        sha256 = "0qcsddvh4cjn8fkk8d8ndlxhlx7xs1799kqap192m5diip4ik0j0";
      })
      (fetchNuGet {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.19";
        sha256 = "1wkvap3pm7fa02agg9dbnr4xq60rd5hrcjizr4acn8xrljyxbli7";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "7.0.19";
        sha256 = "0afrmsv8qk0p8b5964fz38m07v0h89j16x5mlll3pm0a1ih3cshz";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "7.0.19";
        sha256 = "0xyc0mdd7nnmc9wjzq8nxwrqagmiqxds8qwghr2rgxw55b9slc33";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "7.0.19";
        sha256 = "1ssgnfhgkly0h8dc5h9c8iyb3n75d7dgc4cxgxnslydwv3ygyh32";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "7.0.19";
        sha256 = "08gs703rz3agmisy3vsdnyv5lyc32qb8kvfljzszbyqlaf5cxhd1";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Ref";
        version = "7.0.19";
        sha256 = "1z9zfzccqn6yh9mcqrkiidjagzmnk4blrralzb8q0b7mnf1b1ww9";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "7.0.19";
        sha256 = "10i3rr8hig3cnnd1wf9isxgmbj6hn59ndsywbif5yhyflgw3fvqm";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "7.0.19";
        sha256 = "1rby657hwrw4a26fljbxq7lanl4rhv7sijxcw746lifxx7mzfj6a";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "7.0.19";
        sha256 = "0gg1rj848cfiyx9cvvddangww9h37586dr15d7l1c2zmk9nlisd7";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "7.0.19";
        sha256 = "1gvbnqayjc2nkb42f35d5gxc6ffszwg698z4dy8b75838jjqnwdl";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "7.0.19";
        sha256 = "0xm8l6wbyx55p75wgpckmsn9brrymslgsr7rm2q1a8z003m86kx7";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "7.0.19";
        sha256 = "061lhndg6m4infwhnrb243sz3a8hvwvck6hpl106annxms760mq7";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "7.0.19";
        sha256 = "1cm56g54fa18p9hvbmnkiwn7jf4f6bbcny3zd4vsqm9y348dag1i";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "7.0.19";
        sha256 = "01391xxjmgcfgflc4fvrx74a8nr3y48db5m3r9qnj0m49rh60rxs";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "7.0.19";
        sha256 = "0my6x223z6mpwvw6614xzly6haxamnhn9w4a3q91l3ayq4q9crgg";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "7.0.19";
        sha256 = "1cklsjdk7rvnc2h9pfyq04asjpair2nsnbb002flwyq4nhh35af5";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.19";
        sha256 = "1awcriq95alz79xzd3g669l1wf23bs362z23xkyxmafiyn0h9jvj";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.19";
        sha256 = "1xbwsxaxq55azpj49jal50w8a2awd6aa5q5qbxhwv84rqlv8ixd0";
      })
      (fetchNuGet {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "7.0.19";
        sha256 = "1xb37xfkblby3gi0rg0hhmy66pcvsm9q0x6ypi0z9lbl64h7r919";
      })
      (fetchNuGet {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "7.0.19";
        sha256 = "0270v287dq263a4p34qxk8g09af4nr9sxn8m4jd192zfm9cggvw6";
      })
      (fetchNuGet {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.19";
        sha256 = "12wkp5y27ih8d5k4xrlbi4jd8wg7si9lw03bp2bvmp7grslqdnfp";
      })
      (fetchNuGet {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.19";
        sha256 = "1mz2y7s9gxj0jkrf8xyi9q2h5xaqily3vzd9b5bpmx69nbi1adip";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "7.0.19";
        sha256 = "0anfp4mdsnkkjj398vnqjs5k07z6niriyqz10ccxjzzmkxaq5kb0";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "7.0.19";
        sha256 = "0wj5p8hi9jqr9qn4gl0v367kv43vdh21p1kxsja49vvq98y6c7h9";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "7.0.19";
        sha256 = "0izy5gvkwa5a71aq8q9nsbwmy22sghk9x1b42lw97vn4h5ghwcnr";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "7.0.19";
        sha256 = "1dsj2nhd8wa8m3w69cs4i89kd1b5812qbdjx14nagwgdazvvakbf";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "7.0.19";
        sha256 = "1c9rzh8va957xvfb4w07409ncv8zps8692yp5dl7xh643djsgpwv";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "7.0.19";
        sha256 = "01slq8bk8mk0a59abf6mcs4m39mqzvhb003w4abvqr9vghq8fzbr";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "7.0.19";
        sha256 = "088yv3n9qghnw8fgbrkc90xnb0dlrr13j60wj6qhd8rsk53cvxig";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "7.0.19";
        sha256 = "158pibija2rfnmxsrynypslknlr76h2vgpq4p0n9bfy79pb7krda";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.win-arm";
        version = "7.0.19";
        sha256 = "0qldfcpjid7a05b0sk7zznfz6xvpaz74hkyqs6ybs7ac1mkb5d3m";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.win-arm";
        version = "7.0.19";
        sha256 = "01rbx0phr7apkdkflsmbbzjzfzxl2ls3q6a00bqijabzb9brmfaf";
      })
      (fetchNuGet {
        pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost";
        version = "7.0.19";
        sha256 = "1s1x47nkaxk4mg2k4a81g6c3i2lf6lzzqn5rhs67fsp2p7gam03x";
      })
      (fetchNuGet {
        pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost";
        version = "7.0.19";
        sha256 = "0m9s3fgmlcy1r5knfgm1qm4s9gskjvnpnscsv88hkczw8m4v8if2";
      })
      (fetchNuGet {
        pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "7.0.19";
        sha256 = "02sq95zkgqlksa47n7mgqkrbk44v20fc8k7slsyk3faplg0bzf60";
      })
      (fetchNuGet {
        pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "7.0.19";
        sha256 = "1pk7afp09ilzlinpbqjnbjnww6i7iykrhg822x8ggrmqm0bmxvyn";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Composite";
        version = "7.0.19";
        sha256 = "0mar4ls20prrj2b8vb2yaqgfz46gqsjll5amyacv92vgnyixhv9n";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "7.0.19";
        sha256 = "1934pv8q3jdnsj94lid10wc6xmicmqvg82cv480898hfcvwp25zb";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "7.0.19";
        sha256 = "0w0j7pmdm0x49yv4z96d6phmwqfj2sjm3aaa5k856g08b38kviyi";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "7.0.19";
        sha256 = "116yy1k23jhaibhqr2jjjxd0pbw3n6ps3y8mx6i7s6k2mdglys5y";
      })
      (fetchNuGet {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "7.0.19";
        sha256 = "14p7d7gb4bxi7vdzs0jajcblb3zbp8bg2168yl09jmqwyp3qwrrb";
      })
      (fetchNuGet {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "7.0.19";
        sha256 = "15k2sn69mph4cfrr90rpa803z1jx9bzjccn5z5q5cc7ywnrm8xcr";
      })
      (fetchNuGet {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "7.0.19";
        sha256 = "1gzmw2mp0pb9jj81784xfazxk6i4l9mgffd5k1ljbq4kp8i40wiq";
      })
      (fetchNuGet {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "7.0.19";
        sha256 = "1lx6qydgvip8i7f3v93yn9ibdyl384hblbsk0hc384jai62hs444";
      })
    ];
in
rec {
  release_7_0 = "7.0.19";

  aspnetcore_7_0 = buildAspNetCore {
    version = "7.0.19";
    srcs = {
      x86_64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d3d6c11a-a7d6-4be4-8b2b-11154b846100/69bd5fbe2621600e84bb191d0b13abdd/aspnetcore-runtime-7.0.19-linux-x64.tar.gz";
        sha512 = "569fcc25f0c32df3b28c4569bbeabb6c20afc8865088f14a405d3847bbfd159cf291d2dc4810140b8f436f06c95ebb09214ac837b5ade6bd8121e9c0204eb217";
      };
      aarch64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/78d9729a-9f05-49a6-81b7-b041452a2828/73214343fb60deddb7faf355ecbbaca3/aspnetcore-runtime-7.0.19-linux-arm64.tar.gz";
        sha512 = "c71e6a756bdac7f68289fb6c67fcb8c347586e421cbf4345fb510686ff5948e25898759dc7ab30904ac07a7d595508e59d66b5b6dc88d30b54c141c82bd590cf";
      };
      x86_64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e2bed645-39cb-4ea7-ba7c-503741d8d9e6/07bc37ec71cfe01a4187d94275580b3c/aspnetcore-runtime-7.0.19-osx-x64.tar.gz";
        sha512 = "5f16d0cea6b637ad9835dabf23b37f47d8fe92fbd4cfb1ac046fb607beb380255759f14f3e80f9a49c3545afc47000c770394d4dacc5b7444ab0b6d87a5336b5";
      };
      aarch64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/879c8cbe-37bd-4fc9-b8db-857a3fe09144/231cf7ae2bca959750144d08ad08d057/aspnetcore-runtime-7.0.19-osx-arm64.tar.gz";
        sha512 = "10fdc9868efdd8cf25dbe10843ea17075747cc1bee52e495af7e1858ff556dac2802bfcc85fd474527f142672b45e7a1c5b63a927529036923671f6cb9092431";
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
    version = "7.0.19";
    srcs = {
      x86_64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/09ab2389-5bab-4d45-9a91-a56ff322e83c/2f8192a98b6887c7f12b0d2dc4a06247/dotnet-runtime-7.0.19-linux-x64.tar.gz";
        sha512 = "4e556c1437a58d2325e3eeb5a5c4b718599dff206af957a80490ef2945b1a2f5114d25b808b4c9ea233cc4eb2e5ce40932bb249e198319e97f3b5cc443612e6f";
      };
      aarch64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/81616b49-6c82-4778-884d-caeca4c195a9/51a0a0bcdd17fdb77be7f1c5db52165e/dotnet-runtime-7.0.19-linux-arm64.tar.gz";
        sha512 = "fde0a0190c77cd361722d2ce449b207b6a26c7f6462dcc9a2debfa1b0e670f7df0b538758ea5eb865f156df17a98722ed7e8f7a2bfceb0a486d1b06a2d436240";
      };
      x86_64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/92c2b6d8-783f-4a48-8575-e001296d4a54/c11d13f994d5016fc13d5c9a81e394f0/dotnet-runtime-7.0.19-osx-x64.tar.gz";
        sha512 = "005828f1138cfce1f04741a478595186a1098185747ed0872099d7541d2bed16416f36d1214f6289f6ed1d3543e119733e4bba6dddf42db43150bc7bf2e980df";
      };
      aarch64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4b8da067-3b82-4636-8e0d-18583857e64b/fba7ceea0e014535a695ceb9259886c6/dotnet-runtime-7.0.19-osx-arm64.tar.gz";
        sha512 = "394f0f068b1dcd8f116c41391baccb46fd1112578281b0d11edd6dc194b767850c8a2bb9e2bc041b1e872872afb130fa10f7c98fbac988dd80c0d788a0f23e7f";
      };
    };
  };

  sdk_7_0_4xx = buildNetSdk {
    version = "7.0.409";
    srcs = {
      x86_64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/03e24745-90c7-4661-8ffe-e5a857b6e6a3/99038e4e48e403a17bcbe509bfe8d6b8/dotnet-sdk-7.0.409-linux-x64.tar.gz";
        sha512 = "0b67d04621d7c2a1856fdb0cf6e081090b4e1df1075d2f881fb33655422f2f59f63f8324559dc207510485f77781cc20c7a407e3c04dc0b53246987164427671";
      };
      aarch64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f065c679-7039-4968-9a2f-dda7cda72f5f/702eb11e596f498a1cb23b636e1d83be/dotnet-sdk-7.0.409-linux-arm64.tar.gz";
        sha512 = "ebf98115e3ef9a5388394443b8cec8aa104c2468fbcb6c964661115665645326abb0bce42786a98eef4ebffe42dedd36de8608e15538d191e934dc83fcd8b2f5";
      };
      x86_64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/feee7b85-ddb2-4ff5-8927-5656ea1e0a6f/ecdfb330298d11e0d49c3b595ddea452/dotnet-sdk-7.0.409-osx-x64.tar.gz";
        sha512 = "70efa550d6d78e17db0368e8500ddfd9a6343707e009247d00062613e8052463d3d83779af619128233e78a29f5b5a5f71f0eaba740c3c3f74be0c76145c892b";
      };
      aarch64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0025e3a3-0221-493e-90cf-a5baaedc3cfa/716e07c6342d6625dd9a04f632ca8d50/dotnet-sdk-7.0.409-osx-arm64.tar.gz";
        sha512 = "bf234cc2c6e90abb891cbefc3eed35e63fae07d312f01193d8890dce03edbaa3fe5a095cc695bb03ef35fcfd1c2e45e7b9d54c3b483761d7b1653a019c55b53f";
      };
    };
    inherit packages;
  };

  sdk_7_0_3xx = buildNetSdk {
    version = "7.0.316";
    srcs = {
      x86_64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/28d800b7-e6c4-42a2-a27b-ff9de8979025/ef5dd5c9329e1789ab1dfd3a82e88677/dotnet-sdk-7.0.316-linux-x64.tar.gz";
        sha512 = "1489f33f3314b93ac7b9411e4c884fb630622336bee6765b7f193aecda8798cfa201ae0b32d82ec401d5839601d79d6a854832502b08f6eea860fc47fc1da6f2";
      };
      aarch64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/09e91afb-d0a7-4468-9aba-70484bd8cfe2/8ef2416d952b14ec9e00380025960b36/dotnet-sdk-7.0.316-linux-arm64.tar.gz";
        sha512 = "c6c7d57f6ddcb26fae6cef846745bb151296d0f359526161a0e700d9b54ccaef6a24acf2485f2abae1b7305608bfe9204ab89842a712f2913caa092efb756833";
      };
      x86_64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/9a092178-2aa4-4c06-b73d-144327a4992d/4709a913d89feda462d9cccd508b4a5f/dotnet-sdk-7.0.316-osx-x64.tar.gz";
        sha512 = "52a96edba93029283d555c13abd1c1b016870bcdbf10db4caaea6f4b18c46aff3b49355f8bf7b8b2548287c1bc31dbe38c6b7a27e40c1129c2eb010c697c002c";
      };
      aarch64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8e2764ac-debb-4e46-a6f2-637f7c7d8e70/d3da856e4a7d4b45581ff405aee923fb/dotnet-sdk-7.0.316-osx-arm64.tar.gz";
        sha512 = "7f59874fb1638f6f09a5538483ed1b39e482a90bc11555b07cac8fc8ea941dbd9419f57fec252810bb324b89d8647b6bf32d1bd4e6b720c568929d82297d260a";
      };
    };
    inherit packages;
  };

  sdk_7_0_1xx = buildNetSdk {
    version = "7.0.119";
    srcs = {
      x86_64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/03102e44-64d0-414c-9cfa-e212d0160ce8/aad0796ede4708933a4cd75bebd878dc/dotnet-sdk-7.0.119-linux-x64.tar.gz";
        sha512 = "6be08bbbb9d961879b63943413b70e0ceff413e68af59c5c5f01120b02c605e83145a5a9f3417563f9b39159cc5ee149219e99e48ebc92ca2b25c2c0554dd5d6";
      };
      aarch64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c0dd267e-4f6a-4a36-9f7d-19813033cb60/69a960be31caa92da70e68c9529ceeab/dotnet-sdk-7.0.119-linux-arm64.tar.gz";
        sha512 = "187b1422f0ce4eb59c3f894cacb074abe285ad0346ce6cd95a240506167932f08c90ef2529492a8fe6a9abf8bd7cf3dd4c7258cc5972ee4fa630d75f03b42ccd";
      };
      x86_64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/aea7635c-c965-4ee1-9f2d-496873e2c308/e9a800bff17679887458ec75e988fe82/dotnet-sdk-7.0.119-osx-x64.tar.gz";
        sha512 = "dd70345a9093abfd0a839394e425c7b9907afc5884828127ee503ead5395338c1f1b013a481eabff6f1ea1e9e57ce76ef0875d5feb1540f3b05539e9afd129ff";
      };
      aarch64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/06970037-ff94-42b5-a640-16cc25e0ca30/628233310199d362e7af0fb25825f8ad/dotnet-sdk-7.0.119-osx-arm64.tar.gz";
        sha512 = "c411bae746be15f270513412a38e8fde5a72795f876f26b7e5452eaecd3b4fb0e979f9391e0f5f652c692a4516741f2165d77afd5ef264bb24b8bda9cc1e4bf4";
      };
    };
    inherit packages;
  };

  sdk_7_0 = sdk_7_0_4xx;
}
