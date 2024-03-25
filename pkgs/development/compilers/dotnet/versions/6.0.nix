{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v6.0 (active)

let
  packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.28"; sha256 = "1nijw7h8f0bs5infzpz74f1p96y4da4fdfz21n2yafzr5468v2nz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.28"; sha256 = "0gcqvj6489kdqp6hqs474xy11q9bgvbwvzzgb91cyigdfcgi4l1n"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.28"; sha256 = "087g7pwsn24fmvi89wnb6da6bvrmmml993jlxzv48kzv2cn1h53l"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.28"; sha256 = "0j6x01r1y93dfl9hk2p0cf8ir07rywymbn8y0x2b06dsd7ddbi2v"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.28"; sha256 = "0dvpbyl75jsb47bd1jqipwcf3dbr1n7q52hzx9zmi2k0f6b6qhf9"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.28"; sha256 = "1gckiccj04q4q970q4rk28zy0r6p2jw85pa86v87vaz6h9s65pr2"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.28"; sha256 = "1k0sprpp9vixpjwljzaa846lly73v76jpyjsq2ga1g8zkhbic6cw"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.28"; sha256 = "1f74b9zrilggqjy7f0jskqhx5f79cz4fy2rhd55ygbhp7wcdpiag"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.28"; sha256 = "08xbdwmlxbba3r8hv4zrr03h478y1p7wsjqfn0r6vbrja0gmr4xf"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "6.0.28"; sha256 = "0xglyd327iv817ddb6dlls86r7c07a9bfa1aynn1k8r74cc04nr2"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.28"; sha256 = "0hrvg4jnw5zrrr286savmhivmrak3xdm13nalw2n8nq1y8m60yn8"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.28"; sha256 = "00xwvq42ak7bi75n37a1y1ca10cpgafxg0v0dli6n6lwlgkxl9q4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.28"; sha256 = "1hbsradqn78vy9sbfxlg0my3x8i7ba0ada6zx4k1gfffjah0wrk6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.28"; sha256 = "089kik2zh7brfsw126408qr30v16n9iichr06xw7s370p2f1iza2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.28"; sha256 = "0968c28disqgg5gpiw1fcvr39v5pjayfydka3d94qmp210swpaim"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.28"; sha256 = "0hzcgkhirmxmv4syavxfzhp0cyap7impg4ydzpjiz8mgs29nbj6v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.28"; sha256 = "1sv2mdvjn5cpnjw47x2gjpaa78dmk2pw2hw5253c81l256npq39a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.28"; sha256 = "0flj1r475s8671da32wkwjydv4xclkb6l13nmhzd9rn8gyj94frd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.28"; sha256 = "0wvazn4mhhxfysmylr3vdzcbia3fykjs4v9wvq3v10xjw79hj6si"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.28"; sha256 = "1zz9qm8q7sc1174hpnhywiy4qx90nan32fz6gpj3zahl4lqnbg8x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.28"; sha256 = "1jy8vxry3wpx4wmhffpgq6203rcmcr5c3wnaslpdqkvsmqaf2im8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.28"; sha256 = "1h0fxhr6ix7vf85j2dl66mpvjiq2h3cf1fk29xki3pgq7yvxn625"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.28"; sha256 = "0i19fdh2j23kg3dw03sm29qmm4crkfbaf66d0vdf0jc1nsyd29bl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.28"; sha256 = "0rrdqk06qwv0x719diih2fd4jz8c0g1s4vap471vc6ncciyn1815"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.28"; sha256 = "0ffh1jcrg8s3ccl177vmadmnfgc5i50nhc98psh2rjmaxwpy7c9z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.28"; sha256 = "1cja9vlyyssnc4bicd3d7ihhr75f6zyrnki3gafzpz4vir41zas6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.28"; sha256 = "051gagzxzs13fxiday9q0bcqd1jjqahjhcimgag3y8gq45y85vyv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.28"; sha256 = "11r60bb6sj4378nglkfask2459rnm0znqxdmc72npirqljcrm8m2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.28"; sha256 = "1bil2cv55689q7haxmngzwwlc11cdmqg6wvfp5azxb3ia7j7z7cx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.28"; sha256 = "1f49912758lgwiidq9ys67m3nvx893xy97blqv9qkd7d43q2dvm2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.28"; sha256 = "1bz9sd4vn9crzpq2ir16abvpnm8726q3m7r4i3ibx2255ghma89b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.28"; sha256 = "1znl3zgxky51q8lzcpx4n672j775j26vw76yj9d3b55mydxl14rf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.28"; sha256 = "00zva9hgrh90z6kjjimmvapqidizc570wis2skyqal6py30xrgzq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.28"; sha256 = "1ri7c7cgrg9dsyhdp4dxxb8zv1ynpfi0iv5wnl3jk0l32hrhpvac"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.28"; sha256 = "075zw4402jj7gccvb143xqc8c1dz94xnfhg0vr161hk2yf969mvk"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.28"; sha256 = "15hx223kkabf59abp23nwp87acd6scgvr3bpb2m0gl1spf3yqlxz"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.28"; sha256 = "1as9hkmrp20ajy138nahz0w7cpycb34nglsiazbijiccn4sxl4vm"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.28"; sha256 = "1xwsvi5d08b5hc7mzw3yyay2693vgk6lnj28r37wz9si1qijv0pa"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.28"; sha256 = "08rki5pzmwsrpdala0knjs6q84dq84l6wxdm4mc6lipkr89rk08p"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.28"; sha256 = "17hplsf4v9f17gs5zqmnq2x7vhrgr82013fpyxsgmqc6mr83cwlf"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.28"; sha256 = "0crm28bilgr3gvns5slgc88pibr1yvcn8a4c7kg7arkdx2b3chfx"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.28"; sha256 = "1c3n2q82dmv6c5hma47yp93vda00hfxnjqx2hza55l1vpdq1nfpi"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.28"; sha256 = "0d417w4i9bm2nwff7kxlfa9i68iccl8kdlifz96byjmyab28i2nk"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.28"; sha256 = "16vlxzkpp38f49ba3rc6rxchbqb99p6sw41xgrrmg5b0a300pg3f"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.28"; sha256 = "0pgxv8ilpaknkwlffj1l7zssxf655vbmxf4i12frz7g0r55p1n02"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.28"; sha256 = "1d7alwdwxa6czvafpy2qilw1jjff9zwqm939qzliny9lzdkvwv36"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.28"; sha256 = "0ahinjfs5bdd5g2pd33mn04wxp7whlrbwxgc8ma6z722d1dvra5q"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.28"; sha256 = "1k3zyy9za9y8fi8r48k71bkrk90hnqbriwvfidjp6d7c01fwsdr7"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.28"; sha256 = "1fy60m4pfkp50n095znziwiy6iclhybg16rms2pzg37h24xdwmkc"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.28"; sha256 = "0px9z62mnb1c8cd9d4w1jd3hw0mp5l8c4595m43s3m2dxwkd0ngn"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.28"; sha256 = "1gqzsbfh8ybz96vmr2jldmx56p4mcx54am2q87adxrgz60b2bd20"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.28"; sha256 = "07v5jy2sb4qy8bc7icwy29bw7vrks2bwmwn8vjnzp8530q7hwkxm"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.28"; sha256 = "1mc2fn8s6mddrfrqmm3gq3bz3rvcisjhmfd5cp8n71avjq76g61m"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.28"; sha256 = "1ih8p37hqf3f4n01dcpm2mryx8hm1c1qky64yzhsn60f7dpwj73z"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.28"; sha256 = "1zbzs976qa1bsz7xzssmzkypmf128mvaqs125x6113nzwih9p4ys"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.28"; sha256 = "08s1icklsixk1c6qfxkxcp1rqzsnjk242620qgbvkqpwgchfm74j"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.28"; sha256 = "1h2jnjmkvqf6cqdhrq3a8cd38wp6mvcrscjnl5iqn4kq32cxikjp"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.28"; sha256 = "14kza0n311ijv60l2837glkanj3r102mr9j1jhrmbsqy2zc67aa3"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.28"; sha256 = "0wwfm53hqzhcrsn99b1kzn570fwva95rmnvga1lk3fbhd20ih33l"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.28"; sha256 = "0l1y1392yckws78q3858zgf99c38mzq6kvg0xwwnmx7fj7mcnhzw"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.28"; sha256 = "004qnpb3n7w4cl9cqns82y2ih3lad36kij8c014dxl9zc6mwhx5k"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.28"; sha256 = "18irhjajqr6sdjmpkfxsc21qvli9zx0y4b2jdz21bwwazwfsas5z"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.28"; sha256 = "0f4r6xp6wqy46bfnps22f8p0fc3rvvjj5x6m3qvr3mjalx3vs3nk"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.28"; sha256 = "10xcqzwhlziawf3r3a9lpfd5fxvvp5qrky49f70qrysrlxvvylyr"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.28"; sha256 = "13w01xl8m1v9m2jcv6xv26z4akj2k79875xnfyvsg75xa472px0c"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.28"; sha256 = "0cs3z5cy7xxsfmy8wim7pg7yam2854f3a61vim1dhicvrhbmbwaj"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.28"; sha256 = "00ry2d3f4bb5xmv88kgb0krpr2p5vci115cyp9zv16h0yvmsjql2"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.28"; sha256 = "0790il44qrjs5bl0wmssyi14j7ymdrdx4l76ak31l0mrsha8a9xs"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.28"; sha256 = "06g43041ny30r7q2pl10nnd0aabva3mqyw02w1a881c4aqlvvdx2"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.28"; sha256 = "0qzvg9ng60kacp4h8k51ii63wc3ws8p612d1wa1r9jsxlwxyxjw7"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.28"; sha256 = "176483y8s7m1937hgwrw49l5pkhpi9dnwxlakz2m3060fvpa51p5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.28"; sha256 = "1dcf4xsw85wdr968flk2xz8bmhlkvp152zaxrfq85qvr3zzsj5lk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.28"; sha256 = "1jgapinql35p836vbmia7vg3phh7kzrljmzsf9amn6yvl10lpjnz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.28"; sha256 = "0g0ib4pgfnma1nfbh1xj6nl2mviwnrv1ygid10s63plpcf9h3dgb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.28"; sha256 = "1vh708i00i0504002bm2mkcx2vnj6yd8zy6ay2lix7piqxncb1n7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.28"; sha256 = "0wm4vww7w6darjbd7jxc2vyc91y6n6vqvmi8grd1p5s1h7dib14n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.28"; sha256 = "0v7s8c4h0jwv0381gdsy5vng0ydr93s6z5qi31hdl4f28r95jarg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.28"; sha256 = "0jvgzjnn7jlqlsclhy7zrj9qjvhkb87fj7whrdvdh0iwg6gz5l3a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.28"; sha256 = "0jfh4khdm1630i4rhv9zq6fkgimvkl38lrdpj2jak2xfirb99jpl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.28"; sha256 = "130131fm249wcmb05c40g2a49y6dckxzgjlkkgxzbk66zqa0vr74"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.28"; sha256 = "1ggh925a2b6a98jfv0px6m99gxfs73y1kw747pfcxc8b35mvj49z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.28"; sha256 = "0569s938cg3fz0rrmmm9c2kysh1vjks1sj0z8sx4d8xyrj34m5vn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.28"; sha256 = "1a0i9zic9b6ss7yp5pmm8fs7z3xyydczsf9na0v091w0vzr417j6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.28"; sha256 = "1mn9p861009x87mijanvhgaxakxxvnbqi90k0ghmwili1qzkrdx4"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.28"; sha256 = "0mlnj3xkyjywkairca92065l0ph5gj1by7a5gs9xm9vvn1ycpn7i"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.28"; sha256 = "0dr2gg0dbkjfwmh0zf92nr01s1lphn5canbxrgbdvkgb98vrqh9v"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.28"; sha256 = "0any14pi6lm35g1mihvylnlxxqq2mw2c2sqdb9invprx3aff4s7z"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.28"; sha256 = "0vh6bc5idci2z5x0xx5k05j0h69hx4nidkxbrxyy5j54ldlb9d5s"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.28"; sha256 = "1vsxbrlysnpf8fl0l6xb71wrxpfvj68q63q5qj4n2qs5j2g7dk4g"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.28"; sha256 = "1y045dxwzf4nij3jk6vdmmgz4wbfdshk9vxrsp21hkalvls5fw19"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.28"; sha256 = "0qwiv67cm5zwscr1ixj9y9m48vsyjk8002yzrzck3l6gi46mrz03"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.28"; sha256 = "06z3shb264sn8jkd1858qf01h65br6zbglaryjcl4bpijjv9i3aa"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "6.0.28"; sha256 = "0yjm9hdgcg8c6gx97yxdsrixhdf8a3bi3p7yj8wsw8nrqqhqdsqc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "6.0.28"; sha256 = "02nzwi4kihdbi25mji3qaz6r36fzwi9kjlfvxgcs3mwxbi06h1fb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "6.0.28"; sha256 = "0qspvbdmag4n7rl4dppgkrgkbqmg4lzn4g2sjcw3h6n7lk8m1x6w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "6.0.28"; sha256 = "1pngb7vks1wcyinl3cnvx4n4kaqvajxksqi50lq71amkybxfdl6s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "6.0.28"; sha256 = "0ksakpn1lc8ssl0l3wm5vfzm29lx32qd5kinkk754ax9p66fmf2s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "6.0.28"; sha256 = "0mb73kzvm1l184f4kbbj7f7xzfs59lbf3ra0p0mi62bz663dlm8m"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "6.0.28"; sha256 = "1lsa2sdkbiq2ighk9rb9j8hyfr16pgklkm22fjlrj6gqzpvjwxpg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "6.0.28"; sha256 = "1y7mkbk21j18awmgvijgrphal6gs54lckbnyjm9rn6bjqgdgf4jb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "6.0.28"; sha256 = "12nwr4bb6zbdfbdd6lhs9bmyrxicdzhmcasyn69wmfs2jwa8x1xd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "6.0.28"; sha256 = "0lxvh2yqjrsqgpys32hw6csa36dq3sinz5i6r4wl1d0f0z1mz189"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.28"; sha256 = "195ckzdi2jvisxl3bfxaq5fx5n7blwsgf5h23pr81zal935kcs94"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.28"; sha256 = "1f4d425hnc29hvqy2c0jnafjiz8kv36hdv8vdskj2nqymskhiqky"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.28"; sha256 = "0gm7dgbyfqh2dqmrbisvf4gqhhwp5r02sbp0ls46d2rqv9drwla1"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.28"; sha256 = "1whgwzw4gmwkk3x276fb0zjcjwdgpxvl6lykkwpdr86gi0f1s4ys"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.28"; sha256 = "1ibiypdzaacvjaskmjs74n33gc29d9rqsjmps136329bgxi790c4"; })
  ];
in rec {
  release_6_0 = "6.0.28";

  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.28";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8e120ccb-35b2-461b-a791-4c439d2371f1/f64e4a1a25fc96ed90c9db839d7044fd/aspnetcore-runtime-6.0.28-linux-x64.tar.gz";
        sha512  = "52675b81e026b4b673aedb2d9ee99a79ccb47eab090a059ef9b95615befc034ef7fbe674b01ae813870f73dcdbcfa32906969860a464aa5d356c004b6bfb201b";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9926d390-141c-449b-b66b-92592af1c4d2/affff3fb06b82ef6388f57f1ee5359a3/aspnetcore-runtime-6.0.28-linux-arm64.tar.gz";
        sha512  = "932773d9aecfe3918c0479f44d5ca7d643cc7bbe632421ea78326605dd374e9df904f49a2c4279cab0af16be55f41c8fb8e04590aef55ce13c728f9a64d3015f";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/82a75674-ecad-46c9-afb7-4cbdd9e5c464/f6fdcb021c3a7c0a7e7bf844eea1bb66/aspnetcore-runtime-6.0.28-osx-x64.tar.gz";
        sha512  = "40f8a76d68a89e62c4300f4f111a9001be0e4664ab6bc07c6718e33a31768e6b8e2bf130ca561628c85e9e1718c26140a8b98465d78fd13471e580148cd1ae39";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/eda70fe7-655e-4753-b185-159a9534f6fc/0cead75a722fddb6341c27da918576d4/aspnetcore-runtime-6.0.28-osx-arm64.tar.gz";
        sha512  = "a713927fffc0335c9b25febbae1f75e8436e9b3d4b36fe4860bc104cac393e72164551260bb4804da282f3658c9c32a88ded87c47d1e2e83d436f932dda6cb84";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.28";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7299a5aa-2992-4ba8-80ba-4aab1d009fc5/4ed058593c95649e1ef63567829d99d6/dotnet-runtime-6.0.28-linux-x64.tar.gz";
        sha512  = "5e9039c6c83bed02280e6455ee9ec59c9509055ed15d20fb628eca1147c6c3b227579fbffe5d890879b8e62312facf25089b81f4c461797a1a701a220b51d698";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/05be959a-e55f-471c-ab03-75be0ac4fff2/65b05e51362a7a73621d17c718b8c5ae/dotnet-runtime-6.0.28-linux-arm64.tar.gz";
        sha512  = "84b9b2d9e2e9c8f1f8a35b184fbe6883c469224e72635efdd1802fd4c24a56b672427ec016d8f57b7c1bed4342cc77b7af1a613b225b1259ccbe634e75799d58";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d04355db-6489-4205-8ad8-f42ca21c1c21/193b2519cd202d9cd8129e62dcf9ec1f/dotnet-runtime-6.0.28-osx-x64.tar.gz";
        sha512  = "29beaa0d6889163cb8629d276961650e230d6393aa735a36865d6746caf8c5bfdb827bc382821418b5ed6b3db5411497ae7b85e99413e189e754719c55ed7bd7";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3093e11f-975b-4c5f-ae9d-197149efb629/ceb685df67884156ea052c95d3b3d466/dotnet-runtime-6.0.28-osx-arm64.tar.gz";
        sha512  = "708a1421995e3e64457f91685463bdddd6df22d21b6fbb430fc2c830f48fb6e785e6a575e923eb5fb21483a0f956b93c2c4905d149fa62c08bd4426b5e2e459c";
      };
    };
  };

  sdk_6_0_4xx = buildNetSdk {
    version = "6.0.420";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b521d7d2-108b-43d9-861a-58b2505a125a/0023553690a68328b33bc30a38f151db/dotnet-sdk-6.0.420-linux-x64.tar.gz";
        sha512  = "53d6e688d0aee8f73edf3ec8e58ed34eca0873a28f0700b71936b9d7cb351864eff8ca593db7fd77659b1710fa421d2f4137da5f98746a85125dc2a49fbffc56";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d4704678-77d5-433e-97d3-a72b5a1f3316/b73d2c0c05f3df0c119b68418404a618/dotnet-sdk-6.0.420-linux-arm64.tar.gz";
        sha512  = "6625ab63705bcdeba990baf21a54c6ddc0fc399ee374e60d307724febd6dd1ca4f64f697041ec4a6f68f3e4c57765cc3da2f1d51591ec5eec6d544c8aee4f9cb";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/fd6f52d7-42fb-47a3-befc-a1458fe3d345/82d7e21a105b02acc768fdbfdcd2cddf/dotnet-sdk-6.0.420-osx-x64.tar.gz";
        sha512  = "611c7a8b89575fa4ee4fbe345d002e953eceb208c7751d72764d9347c67a49b019d4e0150cac84b0b51e181c61efbcdb66a10e836ba4d94b89da875acb99a556";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4a4728b7-96e6-48f1-a072-6906205e6a58/de54331936784caded5ecd5d10b0ee81/dotnet-sdk-6.0.420-osx-arm64.tar.gz";
        sha512  = "b19ef70a71a5bfe78520bd790e1490b541791e02dc5331f9a00ef14abed7f5b0c3bdfa2f4595d0c312256431aa6eef0af63e6dc2b1d140408d3e7285bf452701";
      };
    };
    inherit packages;
  };

  sdk_6_0_1xx = buildNetSdk {
    version = "6.0.128";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/530c0041-ad39-4918-b658-9e8d9b0e3982/41efca744e6ae51fbffd51a8f546bb9c/dotnet-sdk-6.0.128-linux-x64.tar.gz";
        sha512  = "0f282e8b801e37b762a8e0a8d98df8d0a566973f60b8d99d1f08622ebf00655d65d682d971ddeb0d3594ea3276382dc6e2a96de22e6b22e4122b57f0054906ea";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0041b4a7-e890-4fb5-8bf3-8d31cefed5ac/505c3738dbcd0a94edfa0af32afdc95e/dotnet-sdk-6.0.128-linux-arm64.tar.gz";
        sha512  = "3bc341f842346f0fae948c4ff4d52a14c7ebe09aec8e76afd19f8441e52456f66fb32998ea19354053fb4994d38ac7b0572df39708d6e7ba53623a73138cf6eb";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/15f361b9-5a74-4345-b268-0a22ba7e0a97/8113ded4fff1234c307050e7b0f760dd/dotnet-sdk-6.0.128-osx-x64.tar.gz";
        sha512  = "eb696e628a92ca18a841c23958e5efb0e0881299062301340786316db28f9e5b4ac60ea2d135f7b39933fbc88b37be315707c5dedec73792958ece299c5cee39";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d4b2a693-09e5-4f68-b9e6-5f0a0a3d7fdc/e3985f6d25d32394d0da5b259e79a438/dotnet-sdk-6.0.128-osx-arm64.tar.gz";
        sha512  = "7bf615a8ee80839a46c1e6d70b34774ffe049f3a5a5d1a215eaf94c50a451e5c31e4f3bdfa5e42772f2735d541db78a68bed6330a2c68369237876ac31be238d";
      };
    };
    inherit packages;
  };

  sdk_6_0 = sdk_6_0_4xx;
}
