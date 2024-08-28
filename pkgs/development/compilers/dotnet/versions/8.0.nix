{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v8.0 (active)

let
  packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "8.0.8"; sha256 = "04gvqgl6b46dfxqs2m8miwn7z7j5accidm4vl22ddpj17r8yhx8z"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "8.0.8"; sha256 = "1vi4ccb95bn6zf3pjrgi1nkcmca4s49s4xb5ni12yfbxf5jw5vv2"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "8.0.8"; sha256 = "1nvp2dhznb8h4pcfyllwcx2vzygjpcqrd32blilylk5g5nqd163s"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "8.0.8"; sha256 = "1mhlrvl7bs28bwfqwxydsmcjb4cm83ps2ahp02d86s6z30inlm6v"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "8.0.8"; sha256 = "0dnn3zbzj1ijp5kn7zqws4chnwklmdbiglv2dy664b99xspfrlgz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "8.0.8"; sha256 = "1bclpw8sa5fs8nv33smlkb4zx2ipans7ir67i5cdp2y3qg3afrks"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "8.0.8"; sha256 = "0gnhrkbr0r4l6x0165g68m87mhavcpv8hqkipsjq2ww53bp7csli"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "8.0.8"; sha256 = "1jnr76a8r7sfjvl5p932mm4xn9pqnyv8rkbqddcbr9d396g18srn"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "8.0.8"; sha256 = "0jkjns3rpl2rzs1x3blsirkxgsz64685my1nl1xzh838y1mk16yg"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "8.0.8"; sha256 = "1fb7zhy8p247n8jfr69ca8f46b578ffvv0viqxwsa1ssl24a49g6"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "8.0.8"; sha256 = "0w57jbrf8w2ffs7m78saawniaabasxjkxvmv1lqm6hkb8b3y4rd7"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "8.0.8"; sha256 = "0lppcnba7jhzr034inxb0pqbywapfin7s9n6lncv6sbwmwcdw7b4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "8.0.8"; sha256 = "1l04vb02ddvafbwax79qs5nfg49dg733mnawxjnzfhjszs9872vr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "8.0.8"; sha256 = "1s7yas0561jv3ihka8zmhxqhb2zc55lslj451dl16196i3zgla45"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "8.0.8"; sha256 = "1h5c5riyj465i8cdl6w4q10ymkfwd6f38nnqdbhs4hz9s3yqnw8c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "8.0.8"; sha256 = "025h7ys6n6b4vfp05gsr4vqph9nhi1rg028fpr3g7sxp9s4b694w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "8.0.8"; sha256 = "1avn1pwjan2pkiw1knh0gw5dj61ylyahi9nc8mh69z7q97yrpsid"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "8.0.8"; sha256 = "1yf1zjx64rjqxaqp31iih6vqfhp09r8hck6fr7xdbq24d1jqxdf7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "8.0.8"; sha256 = "1mazrqxr1hfpka0im7h0n8ab73rn2zdf2jbi9fn48panz3ncqgwl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "8.0.8"; sha256 = "06j8vp6w3mjqd2qrf6ndmmfc563qd5gsfqwza99vzvwvsyyclix6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "8.0.8"; sha256 = "1wia1vgf0ywz4mqz8zqiba8m3wzz4fb5zgk4glwyyf4m646s96ky"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "8.0.8"; sha256 = "00rh92hfqmpzb1s3imsc78n24gmbd1hyi8s09ra4z6fzkrz8vi2h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "8.0.8"; sha256 = "0mvr8swzpgmm6fp2gh0lr8kbdp90ng6j2m80gk5im8q46ggjwz2m"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "8.0.8"; sha256 = "0bgsva11n48n9cw2xjfr071x3aq0yqnis191hw8zrgk07gq7q77a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "8.0.8"; sha256 = "1i0g0jv7vnp7rbagjppldypqx1c6bxsk4zx87w5km1n0aclfmyfy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "8.0.8"; sha256 = "01bsp8lj08jvv3bpnb0ngccmgmdfcvqx1038r5ls001ax4l1p4nb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "8.0.8"; sha256 = "1b2zg6gjjri57v43v4sindbikqlxxgrmp4f89gyz7467rd718qa9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "8.0.8"; sha256 = "1g7kwsdj9d9wy67acz3svkcp80aaf3npfsyhgnvslqgwfg53r5y4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "8.0.8"; sha256 = "1qgj8zhsb4r42zcaw8s66wgs294405d0vkvysvfxjhq0qf4d8k0b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "8.0.8"; sha256 = "1ghvz25730jskl3g7mijn80k2pnaddzadlpc5hrbhk1psrziv4cx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; sha256 = "0jv18yz2cfrmky3v0mssddisnfraiynj2gp6djsj79i5an8lm86q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "8.0.8"; sha256 = "0z3aginrqsi7gbcj8rmga35jrw9qabcn6l0sxkysrs4b0qysfsv4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; sha256 = "1fggfcilvg0icc2zym93wiy2ww3jvzyblrymyrvab5q5n49ni3n7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; sha256 = "1vhav8c6fl3kf24i85iq4hvkml1hbl0fn23zcw0il8za0wa96wjh"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; sha256 = "07lmlyd36d4qgjn238hdb0rxki9dc367b05a8xfp4p9nf765s68r"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.8"; sha256 = "19cw3h709whiysagdmrbqbd19pwqc9893dy39dkl353zwhcr802l"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; sha256 = "1my2f45ikw0kay03d1l6yrdcxc9iwyg8w6qyzyhpvbwybva3szqb"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; sha256 = "03zqkvfvgplrk2g0bd95agbly8lilqksp7v9jkfv8xi6fchyz7mk"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; sha256 = "0lvr6w07wxxs68xc4ki83xgvqbzraapnik8f73k0105vg80n684m"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.8"; sha256 = "1pch0b5f4a936ma9l2pf1y8b89swppzc1034yr9c58f92agwm7a5"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; sha256 = "0bj9cgambifzjk68fcidfc2qw1jw6pmy40b6kimid8kig3vi8vc9"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; sha256 = "06ag1kj6d606h3vmqz2aap9pq7ca5c2w7qa0135md98nivl8ra2z"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; sha256 = "10z3lzn58wv0211fx14xy6nckkpvr7jssnq9gd7jisc40wg47m19"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.8"; sha256 = "0cchmg00iabygbqrzrzw4pj461jw15a66bn8niqbv4j2j7fdxc43"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; sha256 = "0f2yal46hqa26s7wrilymhlydj74cj705wivajw204pvx9y29nrx"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; sha256 = "0jzya3wa3v5d27yr7cw3rin61xkgyllx5bmnmb3nlx9m7yv7s9mm"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; sha256 = "1fp73xdqbzbllb4bc942dnrmk00cgrr496svis58w1w1jhas8fg3"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.8"; sha256 = "0mb6zr6ly59hlc8i4jqgwxrhrsvw92690s036d2zjq5yqiiszq15"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; sha256 = "185dfmvph0dp0syrya02yq8pmaqx8rpz6an91n14mvjrmp6g2xqi"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; sha256 = "1nncg3m5www0vhl7xr0d128a4sm6dngwf9y8shrgpi1c533yff50"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; sha256 = "1z5ii7qq6kvhi62dbjg1miwll6z89xi3ndggrjymbq62q26vxk9f"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.8"; sha256 = "0aqm506ls3nqa1qx9vp8zr96mqsbf1q1ni1jcy0ql39khqcf77lc"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; sha256 = "017jfihz6l7pai2lakj5niwnnmn890xd2lgr9vvzn9lf6m1gsa28"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; sha256 = "0g80h08qizf0bmfi19ky90x8sf00x15xbwx6nmm1gmd0wfkcmfrd"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; sha256 = "1w914cpv0lpvmqi0zhrfxchida2adbllhr6617ix3f7w2g2z4vvc"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.8"; sha256 = "1zwhsmjclhjawsjz7fwnsdmv14dgrch31spba32bkyqsn0bmfhnh"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; sha256 = "06x7nldwx6cfx2k8j26nhvg4vlflaz3qk3aqjld08jzjhzh9zl5i"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; sha256 = "0p3ylipzvd41idbb8d11120rakknr8f8ys15kv5fid765wck8xcc"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; sha256 = "1vrqkddhi87hsa4agx1akfhvygxqlj3b1pq6g405k1pdxm7x0ngz"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.8"; sha256 = "1r80l23i677carh93fpkc4qr1wnrkfx8wvdbqj70k29qarjp1zyq"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; sha256 = "0yf7i13rrjdc9ibqff99cspgnz8qgyx85hv4jvgxz2d3jknv8ck5"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; sha256 = "0jkfh00davbf4ix27ph1p3g85amvrqjix2rapw1375pkv6vnhg1g"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; sha256 = "0r9s92nx7lz9alxc2kn67h0x8vl71wh7hv5dqx0fmhafgllw8dd2"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.8"; sha256 = "13klkc3iy2lqxlknygfbqgqrpb6q4i3ihsvi9834aw17fiznrj60"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; sha256 = "1hxxpl4wzn18gq5zpbr0vz87bs4czmvbibhsf1zznwb2yvlr0sh0"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; sha256 = "0wzl1naijk3gm879bd6s2975yhsksnq2gl7jg7j1bnwik27nwpl6"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; sha256 = "1nvzykpd7d51bqh9lkskfffggd0hfm0hrxrnmp075ibd4v98cc9l"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "8.0.8"; sha256 = "1j15hhf2hii4fh2nnmr7wmjxcx3v58ckm8lf5nsnz71fjcy6r2j1"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; sha256 = "1fchcm8hpianyj2n7lq4vajxak8ww9hxdh9bl6xpx2vij8rhhh87"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; sha256 = "0lj58x7l8f5nj9pyy6d7my611rpw0b9m5x4cb8rhqrx6ywzpjmfb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "8.0.8"; sha256 = "1g0kyfs8dj9jirc6qym1y93hxkcff1c1z2cws1qsqsrxbnrrn5dj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "8.0.8"; sha256 = "1p5jgznx61rfanyzvvbkasp13yysjks9driwdm42cc7gw35h2lig"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "8.0.8"; sha256 = "1wsaw71mq2d6a2n3hxrb1mablbr8rz7x35ibh41y11nyhldwvn3i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "8.0.8"; sha256 = "1z8qvz3k1r699gkk96zrdffbqbb2j949gmh89hafcj9phmrbnvz8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "8.0.8"; sha256 = "150rhzlbbg5fr1la67pbyksk6ca8ypqj5j1izc77c9c9xasfa7nz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "8.0.8"; sha256 = "0lxq6m1b91yc58xqwrw84r90vgviwg97nddilbzsp9bml2y4h8y0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "8.0.8"; sha256 = "16n7frb84h0ckkripfm5x698l7b4m9i2brwrsfr7n2ccxkilnfhw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "8.0.8"; sha256 = "1rd3fzdd4dwdiwqcrnaacy4kh01w1j3f37ig4bw1zpv2kyb2c6f7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "8.0.8"; sha256 = "07a0hi147lag3qm9k7757w7p00l870i9ayhx2slw2g3vsr5fy12g"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "8.0.8"; sha256 = "0ysqwf6xbrv1c6q2chkr1hnkw407w1gk4ccpkivn697d1pc832hg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "8.0.8"; sha256 = "1y9w1xj6hjh0bdcq3ywi98v4mkcpk55x48ac2b157qjpqam906c4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "8.0.8"; sha256 = "13s6ymx8vnxiz4ynss7cx1hc5rlwip746y735x4hjqqwqnxlnbc1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "8.0.8"; sha256 = "0sh1r13xmphk3zb625h8814s455kx0x0h0p3liaxd0nfh8dy2gmz"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; sha256 = "1irszs3125nl5d00yyiganqbsdid1sqj289nirvsgzrkmzk0c44k"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.8"; sha256 = "0lh81hxx7ai6hn8mfy579rym8zxydphq4nahwy1db56q3n7kbkrk"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; sha256 = "0a3x5vaqp0a3gm0dkwkai15jyi1qgbqapr7qg2nrv8q2w53vj007"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; sha256 = "0z71d2s8nn8pidzdnsvq8gsnl8kkf2limnm5fxvrfxc6kq22b9qk"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.8"; sha256 = "0xk8va4vidial13wzc2i315k0w6yh6dgnch5bg53wwz2kkm5b7rv"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.8"; sha256 = "1qb75x60bpr9kwp8s938arplym8p1zj7hsxs2mwna9271c254yx3"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.8"; sha256 = "0wjn5krkprgkz87iqzr10ncs3hfzvg2n9zb1xbcm3f0m5af893il"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.8"; sha256 = "015mg8cyqa6c4q2zqrq68rbmzcnjpm2ay5cwrrg99r2q72k85yff"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "8.0.8"; sha256 = "1sh70bdi1fz8zg2lnln2adn2yzjqi3fq8wazjbb8xgz3jbiha8ln"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "8.0.8"; sha256 = "1z0h02av5737mlk3y94lyjqhyjc577kx7yzmacl89m32ky4r2wk3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "8.0.8"; sha256 = "10qq6jvzg75bzlc0wv8z6wi9zv9f53rxf7ya7175lxjszfzjmrkm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "8.0.8"; sha256 = "1kqcb196n8zgcwi4jznlzqx0mv1y2r2gk51wvvv3vhvmfjd6igsl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "8.0.8"; sha256 = "0bcdfhqsls04gg93av3rnxmjz9cynli36nmdc9wxgqnr8vma799i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "8.0.8"; sha256 = "0zzsb5xkifks23vryy4mpm1xyi69mix2xn657cmgp0nn26c9169h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "8.0.8"; sha256 = "0vhx3z0aqnvlmjliqmd3cps5m34w69srwjw1506k2gipd1bhzgcx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "8.0.8"; sha256 = "1jfwbyr43z6id96qpplxv8mvxgdwc6spiy327lbx1gdbpf6yvv1i"; })
      (fetchNuGet { pname = "Microsoft.DotNet.ILCompiler"; version = "8.0.8"; sha256 = "197lnzrfxws1b8pz64kiqjayaidv4rnigdyigpnfjq67w7x80s1a"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.8"; sha256 = "1ax2ygccd1wnlcrad0kzv1lkb3z67vpwbmmqfipzbzsdaj81sgqg"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.8"; sha256 = "04jwnn2ppdl1h11511df5wljmqx6hdzaw01qi44q5j5yab5ss01c"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.8"; sha256 = "18nk4niv4nmpvhd67jflra7qrlq83mh8h3216p14kdiwmwbbzakb"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.8"; sha256 = "1px4k16qxasb4vb7w2jcwjfr39mybhrjb120044km2ianz5mqsvn"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.8"; sha256 = "194y9hvf4rjshnjvxn8j971byxmd837ax3fwp5j2gj8lr5pmh43v"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.8"; sha256 = "0gxprpxvd28ci5xshappd200f16vzgph7r4k921sx98ffpl45sz0"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.8"; sha256 = "1mbd0x4cwzn8284xbk66mr18s7fc37g75yp9r21agfz2vv6yjcn1"; })
      (fetchNuGet { pname = "Microsoft.NET.ILLink.Tasks"; version = "8.0.8"; sha256 = "0kcg2pz794qh3lis9n06c8zmpa2h4q5pp5lfysgm403xzisd9pmj"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.8"; sha256 = "0nzhfz87nfr8619pj75hnnq0kcl8w82kv4xr4528sdwbl5953dj3"; })
  ];
in rec {
  release_8_0 = "8.0.8";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.8";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/648de803-0b0c-46bc-9601-42a94dae0b41/241fd17cee8d473a78675e30681979bb/aspnetcore-runtime-8.0.8-linux-x64.tar.gz";
        sha512  = "d6c0cc2aac79fbacbf81b597f286763599f66278c17ddb448ce0b93d499bad8f88777d425854e68602945ab18af8a61f1ee59d431d5503006137f86113faa8b2";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f6fcf2c9-39ad-49c7-80b5-92306309e796/3cac9217f55528cb60c95702ba92d78b/aspnetcore-runtime-8.0.8-linux-arm64.tar.gz";
        sha512  = "c3dc9d71fca0a48eda96074cbcef4c9a265c1c4e10cbff38614dd74d79443ae9d1ccd10714764cd041291f81d83c0ed1c307abf89249ab4b6f58a5de952fcffd";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/465bdf6e-407d-4512-a222-32dafb225ad8/c22004de330d10a06141dee0f42b5d12/aspnetcore-runtime-8.0.8-osx-x64.tar.gz";
        sha512  = "d3ba8dcfaddcd6d50fd434911fe3eb8309666939a8a1ede800d7da2dd814efbd781d1449a42b71d1c71d9593465e9e97205025eb432808ef9a3ba0dcbdba0e3e";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a7080974-fac8-446c-ba20-313f6f323fbe/f907c126c9bcd394939a7cdf86b85f4b/aspnetcore-runtime-8.0.8-osx-arm64.tar.gz";
        sha512  = "a196c62b14e9136362073826a03e76e0a147027f03655529426e594f7e44eb8dd036daea80997876047171c1793c7edcfa5146bd55a01b591d9405fb1646eb00";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.8";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/68c87f8a-862c-4870-a792-9c89b3c8aa2d/2319ebfb46d3a903341966586e8b0898/dotnet-runtime-8.0.8-linux-x64.tar.gz";
        sha512  = "8f5220098c562fa3490417748eb9f4f9ca1551f7155728b9ebb1924359c63c18dedef643bcd89ec67b59cb5b1b9de7283ee156ef381ffb16801b516dba9b1b0f";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ac04b123-0542-4e80-9216-93f51a6814b3/d110733c152d34ab4eedb435ccfdab4d/dotnet-runtime-8.0.8-linux-arm64.tar.gz";
        sha512  = "246fb7e5edb51db93421c6bb7420f7a358430b98b224a71fb70e71a2bce0bc91f853aa89109f2188b0ab28532a245c3d52baac163463e01a02019dea37fd39f2";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0159972b-a4d6-4683-b32a-9da824d5689e/ffb0784119abf49015be375b5a016413/dotnet-runtime-8.0.8-osx-x64.tar.gz";
        sha512  = "8029986c1f8bbf1b0e8d0929756156fe41d46d2df6ebe1ab1c66fbcea2add47c35b934573c6198797cf60d2b372cd463e70326c0a35b0926dab4d5c157a357f3";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e9ded115-7a30-4952-bb72-ff101583f20b/5a7628261b98d095d2c97ec3fe5267be/dotnet-runtime-8.0.8-osx-arm64.tar.gz";
        sha512  = "88b06dd051819bd9e8ce2c340b2516dc0e4a77d565eff145d8e957b2552a641e235a5ce7e8db3607475887bc766f1530d01d0e7efd80d10cd652a299954398b4";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.401";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/db901b0a-3144-4d07-b8ab-6e7a43e7a791/4d9d1b39b879ad969c6c0ceb6d052381/dotnet-sdk-8.0.401-linux-x64.tar.gz";
        sha512  = "4d2180e82c963318863476cf61c035bd3d82165e7b70751ba231225b5575df24d30c0789d5748c3a379e1e6896b57e59286218cacd440ffb0075c9355094fd8c";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/14742499-fc32-461e-bdb8-67b147763eee/c14113944f734526153f1aaac38ddfca/dotnet-sdk-8.0.401-linux-arm64.tar.gz";
        sha512  = "e8738b21351d030a83be644571f3674c8dda9e6fbd360b221907a7108fab02becd18e1331907535a1294d8c4d0f608519674c27c77dc2c2803cc53cce3e10e0d";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b266f183-c677-4f93-a729-abe0334401ea/ca0ce4f684c4cfea2d372223f9c67cbd/dotnet-sdk-8.0.401-osx-x64.tar.gz";
        sha512  = "063aeaf4e949b96d501b77873279f0286cde46f9212b59181c6db21630401fd6a352e3259848cee8e127e4ceac85a25e0bce36699a2fb6f6e2a91997c6f61eae";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/29ef2c29-154a-4c44-9450-071ae664767a/4ce00627f3eaee13874b54f033a9a27a/dotnet-sdk-8.0.401-osx-arm64.tar.gz";
        sha512  = "a3232c0693b41ee6b18dc3c8b26d82dd9116132bd7871dc9c0a0acc5e7995f352e760869fe91a08828417ea7b91fc27859aeea449b9efabc17c136a57737c93e";
      };
    };
    inherit packages;
  };

  sdk_8_0_3xx = buildNetSdk {
    version = "8.0.304";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/52cedf32-8a92-4966-b184-18404ea1c5a4/cc399fff1b152b822776514ad247df50/dotnet-sdk-8.0.304-linux-x64.tar.gz";
        sha512  = "971c344379240ec4bfaaf1eca69c6667e594cdd0dfdcde6e8962cb7a41d669dff91c644e48eed3573d841b7b3e60ce02e0c27a7ce37b66cdec27bf3457087c4a";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/be9572a5-bcd5-46a0-b10d-0d00229ad57c/b80d3adb25c20fec467bd33f29f9a1be/dotnet-sdk-8.0.304-linux-arm64.tar.gz";
        sha512  = "6ce93ba330848b4045b6c63f96ad0a91c474361cb0a208bd4128d418fd6da04695559add63df9a0acf283a32e6e781328d3979af900e0b2382cf006c9982806d";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8b5c27ce-6c82-4a06-8960-15ebd5434595/508572144872e190e7f00ba6583011d4/dotnet-sdk-8.0.304-osx-x64.tar.gz";
        sha512  = "50f0265436e8c3d756ba00ab7fcd606cb5d452d7bede4daf97e4c02cc97dbbafc00b76f37ec4f07bbed4bee643a433849ddbd363ad2d916aa5965ee74ba317d6";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5ba638c9-0721-42c5-8bf8-9706c0f9c033/f8dbde51758bd9e734a9c932b60e12bc/dotnet-sdk-8.0.304-osx-arm64.tar.gz";
        sha512  = "6993a950bc5bff0efe762ba2562a88761e93c61024d93633209950cbb68aeb5ff189fcbfe9247a1cdebbe37e738136123c7d4eda1050708608bb1ff0408eff4d";
      };
    };
    inherit packages;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.108";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/95a365b4-ac3b-4300-ab6b-54cbc73220f4/4aabad928064af8761315ef34b08c24b/dotnet-sdk-8.0.108-linux-x64.tar.gz";
        sha512  = "5666ddf6fa9b65deaba4d7c5fcc2e2d56f631c4f5f6fb2a9f5919af0616ab2b420b12a828becc2e4b8628a76ac3dae824b55abde5c6d5ac59ee131d7eceae7c2";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/07df5bfc-98ae-4335-91c4-c95ec5f99a58/48a310e5d1bde3e77c53a51c99bdfc08/dotnet-sdk-8.0.108-linux-arm64.tar.gz";
        sha512  = "6cc723f2b139d19b2e17da5936698d388a5b64638b75ef78c40c407ed3cfd3dea745c2916f03efc9e66479fc55d608eb3a89305727ecdb1c999b183b58de258d";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5ea78b09-65a7-4b08-ac65-bfae17afb322/7416ecc76a30ae4c77e71aade36e037f/dotnet-sdk-8.0.108-osx-x64.tar.gz";
        sha512  = "a80fee279abfeb558a5540ca2a969a11bb3dbeade8c39d8c47be8a2d622ef1c2bedb22c874598ad41dbff2b95d5a43197bd9f55fc933ab4ede5edcb6a76cf6cb";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/64a3d858-c2e3-48d1-8236-7c6702efc1f8/191bed6c7f89244eb998b0f186db57d7/dotnet-sdk-8.0.108-osx-arm64.tar.gz";
        sha512  = "83b01276474b4b62bf0a282fbe11d2353a2191d90becd403b373cd6dfc95264442a907117ad8f615765b13969267b887d26a9f24dbd5f88d8b55daa94412d13c";
      };
    };
    inherit packages;
  };

  sdk_8_0 = sdk_8_0_4xx;
}
