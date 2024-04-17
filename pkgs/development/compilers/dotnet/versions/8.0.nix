{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v8.0 (active)

let
  packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "8.0.4"; sha256 = "0d0sgy8rczy78l0inaymcldmw1h742407c7q5y37hbnrw7p8ix7c"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "8.0.4"; sha256 = "0acxp6p5ln9sym8w65lz32ywpxvzpm78j09xd6bcjcz8n9224az8"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "8.0.4"; sha256 = "1plwp944v4a6hj12cg2g378bdl0dwr2jwv22hs7bd2gq56226mjs"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "8.0.4"; sha256 = "1mhbxrj2d2xqp7lkl7129alhppjfma1a5z9jdp0pcik2dw6qd4xn"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "8.0.4"; sha256 = "0g2sjwgkgni797p6ay51brvc9snbnrbsmv88002lnvqnz9zgbifr"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "8.0.4"; sha256 = "07iw2h06awcvlicw0cdvvsrllln72jv3wihvpzp89jyfnjibv4xv"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "8.0.4"; sha256 = "108rwwmv331w8maspamfq3hpv1azajnfwxcj9mr4r7xn1137z5y9"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "8.0.4"; sha256 = "0fhiimqaqr9nf1d6snbni1g38472pzzb21pjsjkcvb9l4z51hbbl"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "8.0.4"; sha256 = "13s2ycyph5p2nddz6crny7zvkaz5f1xylcc8qg24nbwwmrl9539m"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "8.0.4"; sha256 = "1s30dsd5ifv4yfdcjb9nm9gsm1wv3jkhy6b7a5xnk9pblpkizv1g"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "8.0.4"; sha256 = "02d9xv1mzr88lvc7vpn7xpnm2jhbb87bl7jkmaj34fr1r52xg045"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "8.0.4"; sha256 = "040pfyazmii6vyp5jp45c9sw1vqxlrlbhaj6in7vscwd0s67cyi3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "8.0.4"; sha256 = "0pd4v31dfk4z5bbdb29477d2k9jxsg0zslba19vzk7azv1p6zcxs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "8.0.4"; sha256 = "0qbm26aqlyj12wiiy7hpinxammv1a9dzryq3wkm3ij65vfx8r62s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "8.0.4"; sha256 = "0gix41xc788xs8mcdssf4xrpp697h0n159a9j9sdg274cxj8vjhx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "8.0.4"; sha256 = "0wf4bmkw90lmwcp9158j4ywsqvik6hryj53zmm1hbaxpfxkjb1bz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "8.0.4"; sha256 = "0dji6ypar30bqzba9hvsbqf4wsk2zmp2blzg3czfnfbs3034wl2a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "8.0.4"; sha256 = "11rd1hbisjzqyrfz4raj0sl9ip4yznbm7in36j6z41awba2gai9q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "8.0.4"; sha256 = "06k1wbyhphmlqrdfzwhg8pr6nd2mbm47jidzy38mqf4n4qqqb64j"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "8.0.4"; sha256 = "1wvyjsr6yd8ajv8726x7h3fp5kdk6cmgfzyrh0h0vpkn9padac5z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "8.0.4"; sha256 = "00hp5n92a383rkn54n041r8092y3r7hs50bn3zazn5ngcfh2a02z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "8.0.4"; sha256 = "0fz5hmnfl21a7izs02p3hm6k15f6icnnxhb06wv8fb7fncv2qnjl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "8.0.4"; sha256 = "00ql8vy9mpf3k3s1j0gd0ykb9zn98qpzibrf1sm4hyg1xmvarj8y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "8.0.4"; sha256 = "00s7an056z82k14aq809264nhxwr3kmj34rwzch8v3kyl4pm955d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "8.0.4"; sha256 = "14y5nljc6fcbxz48f2m01kyfc9vqxpqwflh9927s77zfr9w2lid5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "8.0.4"; sha256 = "0pi459crkny9bwjl2z4znj9kgnkwl00bnc54jq9asi8zvssvcbfm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "8.0.4"; sha256 = "01apjs90laa069qxns2c5mh0fahrhx1771d0iqifbhwbgvcahz9j"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "8.0.4"; sha256 = "0f291zqarfa1c1gn4ih05gspr2mdv55rvzr2kdjql5vjk3qkjmh2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "8.0.4"; sha256 = "128ghs7lkibpiw3i1kszigffcmwwdj3raak1dqli375qmgpafifk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "8.0.4"; sha256 = "1fgm2q8hj43n6573pbcnj565kx5qshkkh9mfji49pswsva6g475v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "8.0.4"; sha256 = "1k9n0yjp1jsskacl14avbkjnp1a42dn30vhmvnmlp7bi0hirm451"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "8.0.4"; sha256 = "1iqrvg36b2as1maik7b7ls1kwszl30njpp4pjkdljhswlh75c9lz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.4"; sha256 = "1is3dr4m30shxbgqd2g916z192cx2gqvx8iijf05b976qyy0hnvd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "8.0.4"; sha256 = "0056k3y221g13l62fb1cdghijhvml8aynn7lax40ark5rxplam3m"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.4"; sha256 = "1qy3zbvfjqa0gw80jxqd9va58zsf1gp5b6phibsi5da3mw6ybc8k"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.4"; sha256 = "0qpva0m8wn8g7l33ws166s4wr84cl8wd6q3zyp78pc7k309bdfjp"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.4"; sha256 = "02fqkrq74c2rra33spcym05vl378xc8iyzamfpm6gjmkq4vfsca6"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.4"; sha256 = "1k7f79x7yd066b0hhnbq1l183c4v5yw7lysbydfwng14z5x6x7h7"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.4"; sha256 = "1sv4yzx5bagrzqjb3wnb9wqw75ihblsdgdvhd3n7dfhckrssxlnx"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.4"; sha256 = "0brwpdv25lrh6vvq466k25vlhrvgiw7mv61jilm4ngdiyx3261br"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.4"; sha256 = "0c9qjlzwr2y3h98xwmf3ql5kh4x8pp4k16brfx82n8ml8js4g5x5"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.4"; sha256 = "1qy2n7n35wvc5nbik1s5pfirhbp332zbgzs1b3xlnhwdk6nmpcnj"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.4"; sha256 = "0lgd5nxlz8na182n90y935hmcpry813nakg93ixk2cm5k3i0hy37"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.4"; sha256 = "1ig0h7b0rasqrg8hv7j7wqh2n6rxs8wzqllbspk88dyjf64mpvif"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.4"; sha256 = "0lm7a3k7ll1m13clkicnw9smnw29m493w6syvwaada67lxndvdqh"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.4"; sha256 = "1v8yf67dk51paqqvjmljf7x2cc127aykl2ylgqimvs7pn6xajrqb"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.4"; sha256 = "1i1xifc3nrfl5y7xv7iahfw3y9k2w8p8d6qd3p4pkv8rm1i1qqdb"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.4"; sha256 = "0irkqhm47wqj1g32m7pbfyi1igs6js8c7m5xkkfm11a8d3ryy87g"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.4"; sha256 = "0zhw9dxss2zql0qrr4jkj0kr9691b02aav01z2cqn0zbfxc5m5ig"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.4"; sha256 = "1h5kzx741pgzl5p0lsfzmqi1qa3c4yad1p11l54k2dxcbg08nzgv"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.4"; sha256 = "06l874c98i3dac7zyv5y416k6lm477733i4pf6205lamw95hgci9"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.4"; sha256 = "1ciiai9i9cac2fppd5x7whxblgg9jj0n7p5ff83dmylnb04gg0vp"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.4"; sha256 = "168nnns2ppjij3bmbfvnfdpwijf689m6ryrhcbbnram1hxzr2ki5"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.4"; sha256 = "1syw6863rb8p2g6a9r54hflz0dj750fkzm9dv18vib064r7x1lgc"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.4"; sha256 = "07y30dx317kwj089z5laxlw9dwllv27rbh8yhym2ljqajjknaxrs"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.4"; sha256 = "060z3c7iqqjy4p9chm7b18z8j6439dwb71cahpwxb1y0xm6y4hmr"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.4"; sha256 = "0pf30jg23iymn5vvg1vsn6aibdqv26i11cl0zypfmq1bgh3cjh3f"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.4"; sha256 = "0kmbglad3xp643b82qy6gsydib77i3rmlq23vvvm8i8pg6whzflc"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.4"; sha256 = "0x7pvxvl0vfc9lk6kb70v9rj0i5mc5xk9w1cp382npr1lc6l51m6"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.4"; sha256 = "0725n81lawhjlhqs7rhj00fx3ymz10xy4bpj5pmvwx78qrfja8bj"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.4"; sha256 = "18kr4l7vbndvbq2k332axywk0jagci8892r0wxdxyqa9n0pa311c"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.4"; sha256 = "03ng08sx2nvpkvk3nfcp5f4zh85h7lpq0d272d75n0axhffqmwd6"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.4"; sha256 = "0riwadg1qhqdr50js8jx6diaq4g302xwz1an9ngxd22p8xyy1dj7"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.4"; sha256 = "08j2dbg06vg09xz6r6jsqm4k6749z4bbpaaligx7zhrqihszvm41"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.4"; sha256 = "02nkdqf0hi3f6720d0mqv27mr98wxycryy74grrbgabjjylawazg"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.4"; sha256 = "08y3vckrv8njar2v02igsqm4lbcf31fk8f2ld8c74s219nmd2c64"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "8.0.4"; sha256 = "12vlqrllhgbg6n43yv8vav0bmj0xy0cvw4p1rg7knc63x83jf2rr"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "8.0.4"; sha256 = "1d1yxlyk2yjh5i4aidzc155j11qyjfly2vyhvsdxkh0arh41n96x"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.4"; sha256 = "0pwq5vzm34wascaj77h2bhc6rrzbygx2vavr8qn2adz6pia1zvf0"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.4"; sha256 = "00qr1ydbyvjxi57k0ig9kv1ngn84n0b48hznvwa8n86iqqk886q7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "8.0.4"; sha256 = "07mn92340nv63ld5r3ch8hc71p8kjk5zb7bh6n3n43qxmakr3ysc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "8.0.4"; sha256 = "1lgvwyypl2l64qz23p1qdxzap73v3118pjkh0wh8g5qw54nfd3ck"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "8.0.4"; sha256 = "1hdyb154xmapm4bw1bxs433k2sigjkb663cnxzhsgxwwxf8jd0z7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "8.0.4"; sha256 = "08z2bhm5zva61ddb3psmlrwpi9snr37s96xyf6iqc4gl8pki65h8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "8.0.4"; sha256 = "0xi99c6gqhwxgz2yivihs9rxjnfl9h1nwgq4w5v15bjln1blmq9x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "8.0.4"; sha256 = "0a02aa93wx92rzy3lmyxpm9qns6g35wfzdf8zks4sm1f7l2jlxhp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "8.0.4"; sha256 = "0m6sqgr37m0228jkkp89dyr6s2iidnrs9xaffhpaq7yhk578y61v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "8.0.4"; sha256 = "1ws5zchg550sn6rfadrjfc9aqs62qz10pyqw7ddrgygffvb1sfji"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "8.0.4"; sha256 = "1xd1zdb5d2cb4ivw3mj9gf3r02i52hmx7jiswbk2dx8q2k79hv6i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "8.0.4"; sha256 = "05gp1385441wwmjf7j08z4gkirzws06rxvwr7k1hj144ix0nyy9l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "8.0.4"; sha256 = "1l9yahli9dan9szins7sckmjpwnpm3w9ic5qvwzdzzljn8pp16kl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "8.0.4"; sha256 = "05j3n1a5r5gh75mvw5pcj8my3l77kh7hdparl2cv030kk7cc401s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "8.0.4"; sha256 = "05rl747ahxqyvkcdmbcnn5rjr6pg6bc65h0vwc56vwrfd9nif6vq"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.4"; sha256 = "1i7q1fjf07hpnd9hi9z0bavp9kqkk3z5ny8id8yfcansgf4j9bj7"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.4"; sha256 = "01vknc74yy1b36yip1gdcjcr7wij0p9kmglj1lidh6mr676mmi87"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.4"; sha256 = "1qms7i24h9rrzljfmw1vrj3ivfagr0lhr3xaack7vcq7n5mqdcf2"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.4"; sha256 = "1qjzkqm0ra6yhazygw8ypzqcaq6ryvcw19b0msfnw3bkaiip0l7k"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.4"; sha256 = "0m37df28wji42cg3696acbrcq6k67y76rsvlr0gfx5qzgy1nfy8s"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.4"; sha256 = "0g7qb58r0jd17xbfvhbpd2pwvnmzmpq8jvd5m08xdq9krrx0cvcc"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.4"; sha256 = "1b4ihr11yj3zjy7s9zhhailryrlkwrlnpa18z603gic157cbzz2j"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.4"; sha256 = "1fr33r7cgiww338xad3n2f5xhjrq31chx4nj5kqwdh6gszx3ifj9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "8.0.4"; sha256 = "16148vl576zmc336q98a975zzqxz0xjwqkwh87ibxrlyz3w78qw2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "8.0.4"; sha256 = "13gwa8ifir2frmsk88swg778lrjf2l0ij0x7pdlihhywy7gly9wi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "8.0.4"; sha256 = "1b1ml4mppgfl85lz8s34dk2b3s5j8vdql8k2233zhbcs26d401na"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "8.0.4"; sha256 = "1d3yfjqnar7g1fzr6005n43q5frkihkgmpwy91m40jjzbivlid6c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "8.0.4"; sha256 = "0qz21s5v01fls5y1n1zjbc0fylk5lynf5yw9fmgabh2s8gi05wxz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "8.0.4"; sha256 = "0bbw2v83aask0w18ir0i6q3xhmhxa5rahbcd5a1c6cy3hmj3mkx9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "8.0.4"; sha256 = "1kb1y62mgzdyh11qcvb8mk7i2lmxbil7nwnyv2nys2fwqqkp0zdm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "8.0.4"; sha256 = "15yhasq3q0dhw1ssldgxwjdnf8q7az55bly4nmg198ngkw6aiikg"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.4"; sha256 = "18z2lz3rbas3p0k9jahmdas72p5klfwzhqpky044wyp4knwh62dl"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.4"; sha256 = "1ia6kl7v2gmrm52417n4b3h61zvnc7pvyfwa0ighyb16p67zw8rm"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.4"; sha256 = "012phpsracmrpgrv74ajyx0sva2rzbklz7a5pmi2m656j2mqnx1n"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.4"; sha256 = "0pkdlqjpv15x0d87z85w7n40n804nzzdzjbjbhr9arijhl8ykd24"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.4"; sha256 = "1bgwban9h8paav98v8m7bpfsqq85k52vhar4w50wv6kag81dradc"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.4"; sha256 = "1anp4wazxx42r9hzqbyqdsg01pg344wgp36ksd03dvhkdn51dnyy"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.4"; sha256 = "1ppa0jcfwl0g7w71i90wjdfg72gm52pjp9izr5qig0sxfg266jsg"; })
      (fetchNuGet { pname = "Microsoft.NET.ILLink.Tasks"; version = "8.0.4"; sha256 = "055jpbwd3309lplrczs14yfvfhznr4k6cc7b50rdnlrhjvxmhgf3"; })
  ];
in rec {
  release_8_0 = "8.0.4";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.4";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0b0bc7f4-c6e5-4cec-a7ed-45c2fac0da4b/ae2090564274152b5a4be9f1e66c5d30/aspnetcore-runtime-8.0.4-linux-x64.tar.gz";
        sha512  = "8ab281977116bf59a672afe5463bce4433378cc8a67d332c564a012939b7dbdd8756df82a115a5ab93f8186c22700a6dc0272b99a0f484db837da96820c78e79";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/80ec12e5-b26f-466c-a20c-f96772ea709d/606e7203912400b44cb35d6fcecf60bf/aspnetcore-runtime-8.0.4-linux-arm64.tar.gz";
        sha512  = "0b0b3dffe678211afcaeca5d7e381f2218f156421c79dd06e083b1abd92ceb2b5c04c8a159b7d67b866393b8169de826ede70240226e0164451b329b7d46b570";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8edd447c-bd4a-4677-ba33-8bdac6088dc8/a17a23a5d47642eb050288dea0322350/aspnetcore-runtime-8.0.4-osx-x64.tar.gz";
        sha512  = "544257738cd7265a6c3c99e83f331c20c631ee8064e47bd925e37191627223e2f39f19a025360de1f95915bde1a26eede757bea4ffbd115309d186d81d7d6b61";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/172cfd62-a126-4375-9a48-84cfbcf1b718/959ce27a010020f0e5d393578574bca9/aspnetcore-runtime-8.0.4-osx-arm64.tar.gz";
        sha512  = "15e8a7535e0b4d2deeccec32e6373cc2d79fe1156c2490ec263790723c5f660c03a61978826d825a427ebbad02cd0eef12a14e11cb8fcd9744c5ce2ef7176011";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.4";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a3ca3d31-f45b-4e53-ab4d-0f2f221cbc5b/47382078b4b72a66387d0fd6ed9ff963/dotnet-runtime-8.0.4-linux-x64.tar.gz";
        sha512  = "5c23889d3e6effa85d46c0e1969ce876c686723ae47bddf2cf9c0b1d99affde3f60c04063c2467027aa4163e9a981ef601250a7e8d14ddc6b365c89b24029c80";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/761b252b-a0d9-41cd-b1ec-2dc33159c11c/b8285cf82db4ef340a191bfba9a9a73e/dotnet-runtime-8.0.4-linux-arm64.tar.gz";
        sha512  = "d11ce8867dc91d9e9b333753cc7b9677204898485d044dfbbfabe5c5eee43091580a11c3029fca4138cfa9576f84e23fc11bcffa44fcaf5c3d8e617a3cd18802";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c999e42b-38c9-4d9a-9816-9a0ebece8afe/8e4471db5aa0756d812af23817b14259/dotnet-runtime-8.0.4-osx-x64.tar.gz";
        sha512  = "bb303991154582e1aee0b4850bec2ed92b5c4253bed08d76da0c9687c90c46c9ddddd7ffb9050fb7a4d8db6be6e8cd552156589679a3a169341a167952d76407";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d2cd56cc-5a78-460d-a45d-3893b020949d/8cf9653a23c91ac2b10c70f58edae60e/dotnet-runtime-8.0.4-osx-arm64.tar.gz";
        sha512  = "7aa4ea587348984ca959945a9e52bade7cb9cbcb8c5a32dbcdf0836d2da4148ca68fcf9815b0b274964b5164c9266b1891afc9406c1c7337642f09300efd7649";
      };
    };
  };

  sdk_8_0_2xx = buildNetSdk {
    version = "8.0.204";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0a1b3cbd-b4af-4d0d-9ed7-0054f0e200b4/4bcc533c66379caaa91770236667aacb/dotnet-sdk-8.0.204-linux-x64.tar.gz";
        sha512  = "b45d3e3bc039d50764bfbe393b26cc929d93b22d69da74af6d35d4038ebcbc2f8410b047cdd0425c954d245e2594755c9f293c09f1ded3c97d33aebfaf878b5f";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1e449990-2934-47ee-97fb-b78f0e587c98/1c92c33593932f7a86efa5aff18960ed/dotnet-sdk-8.0.204-linux-arm64.tar.gz";
        sha512  = "7000b559efe502e9a799e9fccb6bccc2e39eb21331d6cb2be54f389e357436b84f5ccbcc73245df647749ee32d27f7fb8b7737d449312f0db7dd3409f8e12443";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9548c95b-8495-4b69-b6f0-1fdebdbbf9ff/30827786409718c5a9604711661da3b5/dotnet-sdk-8.0.204-osx-x64.tar.gz";
        sha512  = "a49c3dc8f364dcf2f88353b80267062b557ef4afff333fa4494e84d01234d38c57619aaf7a3e2cacfb16d066ab1523b6e5953cf864e5e8f411dd38855408bb5d";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8746698c-596d-406e-b672-49a53d77eea7/74c28673e54213d058eec2c9151714cc/dotnet-sdk-8.0.204-osx-arm64.tar.gz";
        sha512  = "db06baa1d076549e393a9a402c03e81834e15641d2b5fdbd5beb7c4a55b5ed979f5e58ac6baa2048bc55a3a7b3aabe0e3c518310c66a17ecd107b7bf0aaaf2b0";
      };
    };
    inherit packages;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.104";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/fd4a16ac-5322-4308-b6b0-afa1821e63f6/0abd2e63358335f2235d22fd84b32a60/dotnet-sdk-8.0.104-linux-x64.tar.gz";
        sha512  = "cb7b5e509c16a7e27ccfc03b3a217460b9eac151ca973f262f82d4b4a494f7bdff3229e9aee91df1c110582ee8dd3d310dad39528c3bd292c5d9b7746ba3b6fd";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/92652bc8-b312-4f77-ad95-cbbcbc9330ed/549869e13f1bf66b0b089b4e976e96ea/dotnet-sdk-8.0.104-linux-arm64.tar.gz";
        sha512  = "71f5fb65c88bfd14ebc13c5eec04d08b4f7461d1b9f3f5f08c31351a377e08cd002072a4487bfc2496ac7b4d5ba83c97eb979a5732de394c1a02a4528877002f";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5f790cbf-88b3-4619-b083-178e1eb6c16f/ab21721125a05ec751b22d689e19a353/dotnet-sdk-8.0.104-osx-x64.tar.gz";
        sha512  = "b451731c7fe151316df57d1e6a23129732ebc0dc3dd53479421b881652bd042d5fb9890c2c8e229fc578b3b05542a8e08986955154e590d8c1e274c5821a5666";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/73d8ccae-9bcf-42e4-9a57-b6a4480eea2b/52e136f08e967c6ea9617be542921286/dotnet-sdk-8.0.104-osx-arm64.tar.gz";
        sha512  = "376fda994997e3ebbf15cafbc910ff25a71debd2d31d088cf7947f813ff013568f3f47514ec53d2c02a3e3f8432a5ca9344dab3ee07cc0df650761a3dbc6be68";
      };
    };
    inherit packages;
  };

  sdk_8_0 = sdk_8_0_2xx;
}
