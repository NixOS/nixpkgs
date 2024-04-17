{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v6.0 (active)

let
  packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.29"; sha256 = "1ww2rsf46bm3mrgq590ky2q2qdxx9q63my661xff24f0s4h2iy7r"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.29"; sha256 = "1kkyqzlmhmms1nl08hlrss75lc8yy8qvb0kx23x0fg1dmyqnnzmw"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.29"; sha256 = "02yxbf6s8ncxl5gp2yq7dl08p2i3iy21bjahy9bpw44cqwcf9crs"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.29"; sha256 = "0wdy09kilnasa64jad3j2piggr7iad9z1jhxc24vchq9nalhdbxk"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.29"; sha256 = "0z359wbz3014rwz7cdcr60qr6mrcwsbwwh36g59a5hncxb1g73rj"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.29"; sha256 = "031kalc7mp8w35rwvnb13jbwwi8cgmny7nywsk3717iy6blxldih"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.29"; sha256 = "04zs1sgfxnlbd9csalxlzciwapz64mn4d284l6qr0yj12v6jjzyz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.29"; sha256 = "0byixcrwj7ixz60lvg7c6r3f132br4pfrjv0w0fh99b3iwzrf114"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.29"; sha256 = "08s37g8x0m6ck862cy44g1khp3ncynk7z9czbknpa4fw8s24g4mz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "6.0.29"; sha256 = "0lbmyxancwikzhiqhyvlv8vd1868fj0yjchm6kby58b6x7h9fawb"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.29"; sha256 = "1ld7aipybxbhwnybimsnhv09ib9ib824zkj11qk3aq7ncz6pfazr"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.29"; sha256 = "0yl3i637jhp2si9dls0yd528q9w0cm59w079wyyxgyffyy2g2553"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.29"; sha256 = "0jhcjy60rjwbv2a8qcrkj2im3qv4mvg1ar9gza5199dciigsh968"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.29"; sha256 = "0wy5hs9h0214i2b2jj0yc3r8lr92ai6iszy3llvyzlb4jb5yzgzq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.29"; sha256 = "1bxmnw7zmjv1wxggzv7qf27jjfb01f2x8440a67lkzxsnrl0cd4r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.29"; sha256 = "0q6fwydh0rhm1p8q11zwi7l4qkvw7fh41s4rhfhwx9jn7vxw9adv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.29"; sha256 = "1whzwlnh0cv184smn0ddhd9ssbrlqlj67a12yw4b0l15xsx51n78"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.29"; sha256 = "1g9qlb4k3i8zq5kn4y8v7lc9mqhy3ikh2bla30nqv86iwaclrwb7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.29"; sha256 = "03rzclkvl2gc7wakh0xqhnj6zl32b91igrnyhd69pzr3mql5kdll"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.29"; sha256 = "18qk2ahkddzd34zwz4q0gg5cgrcdmg00hlkfxp4h18gyq8i5bc0d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.29"; sha256 = "0kh3lrzpz7y42iqa4vdhw4mg51vf4y2x8l4lg767mzbx0sd4xllv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.29"; sha256 = "15sz26wgpnfrp9gqspwdhj64lhlnjv8id8s6bblxxkkwa6040ls6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.29"; sha256 = "0lnq5pqmsgh1fv0q5cxx1bn3lvxmrd4xvx6vsn2mjahzkvpzjgxr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.29"; sha256 = "0jzzkdbqikwq96plmwrmjhpv7v6g0l0bz50swbs27vjf45msbj42"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.29"; sha256 = "0ggicsy3zija6v76mv0rddg0ga6spxn4i9skq9fr7s6a9xccbgqb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.29"; sha256 = "17ma2g0j6klpbnxbv402f8hn1rrvq52f3s9wkz8zllh7zbsqin69"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.29"; sha256 = "0gv5dnd44xj1yidzd70b01s5a19khbq757llkfykgwf7wl4a89cf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.29"; sha256 = "1bk2n7csgnvqma5yv550037xg4ph4j11gp4m5hn7s4sy23cfc5xp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.29"; sha256 = "1k4jkjqrbgsnn8r220vh82s20b38h5hrks579a48bsv1288i0zhn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.29"; sha256 = "0hhypwr4202n8nvpz10ac1q48ryjr7d4xj34r4c79mw49fvh1n61"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.29"; sha256 = "01d27mw1zsfx5wdw7515zg68wvwwl7ia579l7bkkbbzbmbb7n6r4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.29"; sha256 = "16cqxd6kh9dvxrbsjj3ls317ql7cwj036gdqnbg31dpcl9qmib47"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.29"; sha256 = "1alfbxqjq7jyyh62lbw2szjfchmc32ywh10x48hcjkscnqvn32fv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.29"; sha256 = "1q9hbz6qv8gx2v0vpv21i6m0m2rw2jk1956gc0ybj5l5fppqfzqr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.29"; sha256 = "1sf3jvbscph4yrljhpiiyyqgw70qcwcym0jb74ql3aw0cr3gqbh5"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.29"; sha256 = "01dvbid18120g6fgxcb79qfz9628qwm0kr5j88mincvdzklz4k9n"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.29"; sha256 = "15f5mscfmj6cn771wzxqszxfjqx93lvfa2dmdiyg9vx8nyciara5"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.29"; sha256 = "05m50dprl9y1jq40z5wicizwdb669nbp942lmnk282rkvga79wh6"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.29"; sha256 = "11dnr4r4sj9pzmayavs69f274ba4xvynxh4mj46ynkaiwf423imq"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.29"; sha256 = "1f9m1rqfbz6p8h574f9ylw512w6njvdl1a52hcjcjf4y6wjvwm13"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.29"; sha256 = "1sk1fdz3d6gm44qsaqavqc1zdl1kjc1m29sk2rlpw4lml1aa527x"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.29"; sha256 = "1gly6h5vnmp2h3mj2jqym6nwg3swp8ihsq2s56j1b7mdxjnbhilk"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.29"; sha256 = "1hnbr15han7261jjnx6pkyhi3bklyd3sbg24x1yqxac36f7xcvwx"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.29"; sha256 = "06ip2z9j02ak5nqrbm5vzs6lyv8d1g959xmx2h4b24ddj1zrkid0"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.29"; sha256 = "0j089aayx9g653agaqbwk9101nxdiy278j1k4yaj20a78bw6cdsm"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.29"; sha256 = "163b5p3mwy6v0lp00ardag41gn90vv25jfkrawwhqvzjx9i7gm6x"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.29"; sha256 = "0j2dwpr1mzm43nvw1lqyqk23gxf0iwx2j6lpffq43dpx5n3bdi0a"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.29"; sha256 = "1ax7sjajicibkz4zdvdx65vjpc4xdd6q88zgcqfi22hvfpcdgbni"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.29"; sha256 = "1rxcxafv84lcmskdlhxa8pvm32fvcgn1vnmcrsksb3g1ibvh1bhv"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.29"; sha256 = "03qxxkh1wk3rswssglnhrff6k8pajbjalzp95xyg9pyd0xaq5i4k"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.29"; sha256 = "0wq6mjg0apqnvv9axdkvka8c0swap8r4n241kvm7xqrlg88dhlvz"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.29"; sha256 = "0a63sh3i71nwwgw83194k903yc3j9z1wnlnfbcj60w5i3kwifnnp"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.29"; sha256 = "1by4lbzv90lzl1zrgycrpgrq7b3dkc023npixsihx0sw0vc29s1m"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.29"; sha256 = "1pvr7bh9hvg55r4d4yjm5zlqmdnpk5jbi76xjkhw7vdwkp9133rh"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.29"; sha256 = "0k7k4rhq5d9d2rwpqppddhdw633509v1dxs9ii2cvk8pz0vcl2ll"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.29"; sha256 = "0mvyfmmsn40cmn7n8mavspflrz2rahfzmqy4f8vnhdfb2pmirbkb"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.29"; sha256 = "1hyyhbpvzvx56lbbk43vdlajz1x5mb17155j7k0lbnpp29gr2hn9"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.29"; sha256 = "0012c5f6qmgvky5bff9gpcwmc9rydhrs9vd0j2hcqggdixcfv5f0"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.29"; sha256 = "1a1hvalw80kaw2prixzzjr6s4l2q2q73vibqh09cn0hp09zbsr1g"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.29"; sha256 = "0agminm16ksiplxi3lb7csinzbr7r315wl0a32spyy0qbmzpfv4h"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.29"; sha256 = "19x3w376180dh7l9rn82rv4jgcfl7rbrc1ckr9x6nbkmldgq8bxq"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.29"; sha256 = "1jxxx3zh1hzkfxk9m1pawlcg5h5x8bb6jwj0vxb0cflj3yh9scjr"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.29"; sha256 = "03zlldqxlc3ykbapmmvpifik2c3wy3w5k5fnrbjl6ak155iblszj"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.29"; sha256 = "006pk987rmif8kv26l91wchj52r1qad673fdn2vbdmh8qmr4jgp9"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.29"; sha256 = "13z4lgmkkfkw86d5x3pz80rv85h36sbixckbwja7fxc6wzx11a3h"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.29"; sha256 = "0sqcrkdsdih5pjb30r9c4g5bdmvjak4i7s9ji1vx83h2hw71d9x9"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.29"; sha256 = "1mmkp6a8xhyfipnafj9nbwlnc3blpkgpbvcnq12znlbjg6wgxqz0"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.29"; sha256 = "1hj6qqfy1vs88j2lksz2bd69ra1nk5vp1rnc9wbrd95qhzq0bg96"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.29"; sha256 = "0y25zkmm2gwi6kmqyc7ajsjpwyb240x99ipfslxfihan9y8lsjg9"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.29"; sha256 = "02l0adv6iy71pyf3j6r3vag8945avq30srwlpc1k0jdfwb0rp4ia"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.29"; sha256 = "1405a595p5zdsv0czd5fb75f3w6i4w7d4cxns7ar007dc4dnfzhw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.29"; sha256 = "0hp585dlg26zbqgcla0bz8c26bhspnqwccwimyjg3gs0acymm5aa"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.29"; sha256 = "1al87br8qcdplm9j5n57mni5zbvw71jvwax4kjb4yfcq5c9qwdvy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.29"; sha256 = "1n1sj94xzm3f6qx20hmw9zvz188iaxm76pd34zcyzs7izbw1jyq2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.29"; sha256 = "00w4cw7blwkqhcg20q9xybs00mrcymgnmki393smn3bc439b8vpn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.29"; sha256 = "0d0xy3zmrlfzc7zk6hpx69mr5b6p28aj944403c7akhzpg1zz2r1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.29"; sha256 = "0n5zb3hghyqk1yizzznx0azdqg7rc19gvzrw5214rhf731jsm4rw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.29"; sha256 = "110wd98zgddiw0znn6b4hrbsixc8shl9hsjd9gch4vxz1ivbsfm6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.29"; sha256 = "0nrrv68px7xvg7291zsgyw9zzmi3kgcdb24p6cnywmyrrjf1ww0f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.29"; sha256 = "0yviz7fjchd4jg71gbq52c3jpk9jpkcz042hhfpz9rj7wij7m7n6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.29"; sha256 = "0d4sflclyqwx7p9qlb41xfjcpxhjqy0xgah3kr1wb030apr46ina"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.29"; sha256 = "1wl49lg346lhnvn5h2vlb393lasbvbh9hrhvzb1fsi9nnwk6v278"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.29"; sha256 = "192n0rbnwb13m619i70yiym38pdlsfkfh68qcq2pm7r4q1lhw5jm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.29"; sha256 = "0r1sp7jjqz2lh92bfnz6xv2jp3q3m4fabq5m1zbw28q6h945q9mp"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.29"; sha256 = "1lifcf96r5mqh4n8d7gcrnmql7vyj8q42sbd621yrqk68dg2gyz3"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.29"; sha256 = "07hsmqrx6yk8rjr8270v1agqfqhl9lw8mgxfsyf6g7anrjc8skrz"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.29"; sha256 = "0iqvqmhncmwl2df6lwlxs3anzpwwy1xhaci4zzq57f67qkiwfh57"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.29"; sha256 = "1ix3672jd5m5n93y6r9gkpvrkc9hpj1jzf0wlpwji25n75mjg2hg"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.29"; sha256 = "1qxr84lqn6pzi1rh3941rgyaiv1shsjrj7pgdzmmd0r06ng49avd"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.29"; sha256 = "065ih4wls3y3wlcwn61ywjmy08k4abz216kvzg7vhg511qlsi7a5"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.29"; sha256 = "0mm7mybfvqymxcgdr9vwbxfdv83dp613gqhlpm4s8v38jy8ndx52"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.29"; sha256 = "1gr26qlj7v3j3mf5dhizbmdh69y6rs9hnff0yf3pi1p1fc6pljf0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "6.0.29"; sha256 = "0in1hpn7a2dmmrgdzh101idn9nb8x8al1kp2a7s9vx8sk42nvhnw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "6.0.29"; sha256 = "1nzihwz9vyhfhjq2a6ws2kn651mlyq0ki675v9jwkcb0sgabagab"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "6.0.29"; sha256 = "1k7dcy3w7yjpykspcb3n1j8fjba4f7505gv0zs003dzx7379bnis"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "6.0.29"; sha256 = "13s195fgy7yymvc9qw71nr1vlphmvyq4gyr982bv1x0ci2mzybh9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "6.0.29"; sha256 = "0vhd537vh7rakxzbgy6fmfr379k5fj8gq4s005fasripv0a8k98n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "6.0.29"; sha256 = "12l5i81rqm8mvz1hj1hnrdzbdrv9fzxghcdj9mw7xlcynsmazazz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "6.0.29"; sha256 = "1y3mzszv3qa0pqvjpn5y8jykww0pcpj97576gj6m63mw7rlk8vcn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "6.0.29"; sha256 = "0z6lnhq0jmj759z99ph00wxwyvr5dh0mpkqp89mzqi98dpxwlnpb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "6.0.29"; sha256 = "1s1j8zivvkpkg088kmr9lfqqxz6zc4753hqhz3grxp850vhv1hzy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "6.0.29"; sha256 = "0la7fw19zj4aqa8dlp5pg4bvh1m3fsfa1cnzfw3fm1g17bpq210f"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.29"; sha256 = "1p4jxlqnc8kf18q005nhywj2ca1d3j3kk5234xbsfhr8j2wx211g"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.29"; sha256 = "096cldfkih3c3bs8bi7340yiz4ss0dqb3y90n3rshfhln1mik28y"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.29"; sha256 = "1k79s6rbxqhfqsh5yxznnfhhsxvgg1bbfsj5dwrpxwxlhcwg8p9k"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.29"; sha256 = "0inzz41s033hwd5splr0jrf5b4bnsqlyydrbxjcqxhk975fjfgxl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.29"; sha256 = "1k2k68hrxc3181439nipgv6pwci8x3l92lx26n7wzjqr20g7lknv"; })
  ];
in rec {
  release_6_0 = "6.0.29";

  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.29";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/70ddd1ed-776d-41d2-b192-f02436ef3ca6/337d6dd35177408acb9889289a7743a7/aspnetcore-runtime-6.0.29-linux-x64.tar.gz";
        sha512  = "6dc21e1a8dd597df9c1135065f7350bbde9cc040c3079ec7850b0e5f254051b883c6c6e0056682d2963ec74dadff8eb32d82c13b35c9088f3d7c055d3d3f0863";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/094fe5d6-0520-4c0a-9edf-b53d269f8b20/8c5e69ed04787815037ae373ffb77466/aspnetcore-runtime-6.0.29-linux-arm64.tar.gz";
        sha512  = "6e4a504f37ba4bf7d0316d2a3077c5088962c8b8445b659fa05844697bd11427afabacb6fee34094aa4313dd6dca70c862c1c68b30731b12b4451bd59067bc8f";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7b93130d-337d-46b8-8d61-cd702c4f2ae7/e198b8e68a06f1f1f5f46116f9976641/aspnetcore-runtime-6.0.29-osx-x64.tar.gz";
        sha512  = "f4405bcf40a075a5acbd8f4ced424efb0b2de49a5f81481c708a1942c1e92e3a69ea8a4d59b55c025092a59e2715d260521fda56618f250d1484fe18dc4cadf4";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/cbaf5637-d4ba-41e8-a16f-a66a063a30e2/205c5fd4005a47753549594370bd385d/aspnetcore-runtime-6.0.29-osx-arm64.tar.gz";
        sha512  = "a9ecc77db6f0fd8e5ff70ac58ae3549b766694d30a93cfd41869ceaa298178fd2c0e86e4e763d8d7a5e2236d42faf2e87d798d2853f8391a73a40f5193f4fa71";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.29";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a066873e-e4f6-4538-a225-4170e2950af2/7e3b369dee3fb19cf193823e158f3b6b/dotnet-runtime-6.0.29-linux-x64.tar.gz";
        sha512  = "c9fc66d47e7c5ed77f13d03bd3a6d09f99560bd432aa308392e0604bdf2a378f66f836184dca4a678052989e6e51a5535225de337c32a4a4e17a67abdc554ffa";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/633cbdd7-57e0-4101-9627-9bda4f29dc9d/93ad01d00720363b0c054f5d88d97a62/dotnet-runtime-6.0.29-linux-arm64.tar.gz";
        sha512  = "27c7121a4953b51bf29a15ffac4155cf86609ded15948f91ecdd19970ff7e19276c528d875f547c2877245767adf1be1ca0eaeb45dc8db460070637bd5ee1ec8";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ed218418-03fc-455b-ba08-6743dd753435/87ce2ccb4bd152e7e9435b891349ec9c/dotnet-runtime-6.0.29-osx-x64.tar.gz";
        sha512  = "e04207993febbd8593eb5474016e90910491f4c5b23cfec39498bc6d5ca2c3ce427da4f5f14ff4160766daab1e35dd2d324d0cfd7ffa83c4741a25f9ac811f00";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ca51758e-d614-4a55-97ce-bf60ec381931/c2e6633c67dcf4359666cdaa88f1eeae/dotnet-runtime-6.0.29-osx-arm64.tar.gz";
        sha512  = "baf9b30ab7fcdb16878a05429a98c20079e8a5e081f910ddabaee70298dd3d976f3c56569af4efa544533534be50920258982cb97d98bc85f31ce44e6ccabf52";
      };
    };
  };

  sdk_6_0_4xx = buildNetSdk {
    version = "6.0.421";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/19144d78-6f95-4810-a9f6-3bf86035a244/23f4654fc5352e049b517937f94be839/dotnet-sdk-6.0.421-linux-x64.tar.gz";
        sha512  = "aa2c1fdc06c477acbb8ca938895f22373a96e96bb75028b496ddf3d433a1e347f3f765b414e8e09fbf1da1cc50f575e28572e701693bad2a33f9b92437a7d3fc";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/30303304-04ea-4569-9f10-3919b4b3105c/5b689d8357866cc2637a021d16096256/dotnet-sdk-6.0.421-linux-arm64.tar.gz";
        sha512  = "2713e16d70d9cb5bd6d3d2da385c75c8cfe6ed3187225efe6715d595b1b1b17d0a48fc7044cb514add8918875c5f281196f09686c11c7524fe9397d8bbe1f8aa";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/270b615f-5281-4c58-980f-d9f7a08db642/3e874492a9cb0d5b87195c596b46d609/dotnet-sdk-6.0.421-osx-x64.tar.gz";
        sha512  = "93570a4efc929050b36ad53adca2be803c4cd8ebd9f2553b0f3e325af0629f9854ed39ec8ed0bde4302985c74143763b3a7bef89b1bcecbcec99e137777181d6";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ed341e9a-7848-4036-bf88-00cffa9fe535/52887ced41272bf177a9ef6ac04563a2/dotnet-sdk-6.0.421-osx-arm64.tar.gz";
        sha512  = "83870fbe802cdea4ca014eb5dc0cd899deed952d8cfeb862f74bf68d80bfa81e814a3d90381615bb6e26dc39bfcbc82f975462665bf65294d25249e2ea365332";
      };
    };
    inherit packages;
  };

  sdk_6_0_1xx = buildNetSdk {
    version = "6.0.129";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7bb40f2e-6ef7-43d6-b0cb-b74d974a5675/cf48bfe3825b1d419da055a8d8f16101/dotnet-sdk-6.0.129-linux-x64.tar.gz";
        sha512  = "fb4991e5b0297ea0c65dd84300f0c11bef4589b19012556f67eb10970bd3ee50a58bad59023e1d266a8d9688a71c23458e0d21b8cd9adb75d21c47b59987aabe";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ceb30bb4-f3b9-4195-b549-76e49ace533b/60fb639b9c621ba00946765d1be575c0/dotnet-sdk-6.0.129-linux-arm64.tar.gz";
        sha512  = "58185fa68b9a7bd373b8c4ad9f2d14d0379e6758007bfbe52a640cb432eec91267ff7df94fc57ec0d0d16b8ab5a0838a623c31d3cf36384b3a77697d3a8cfd86";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/2e1ce563-4b66-4bed-b092-a411755b0101/e6abdcbec6cb93a3f3c74f3b25eb0dac/dotnet-sdk-6.0.129-osx-x64.tar.gz";
        sha512  = "b4b70a211eaabc9b3a34fe197ca4c69e4a167484445fbbc6df326c972047c813a6ef9a89830d0105ffa00bc8754f8b728e102fba35f89fd9caafe139d45b4eef";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bd5e3be9-a283-4cfe-afd8-b217d2429ad2/0339d0cf86b7b8fa5831d0788175c34a/dotnet-sdk-6.0.129-osx-arm64.tar.gz";
        sha512  = "065a6b54fc5044d335371c6244c633d3a64d6813ebcef9db19fe0dce4f15c381109b537efab8ff1a9850d83721b0783b4f5f58c048cd6e8f05a32d12eebd430a";
      };
    };
    inherit packages;
  };

  sdk_6_0 = sdk_6_0_4xx;
}
