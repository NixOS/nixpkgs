{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v8.0 (active)

let
  packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "8.0.3"; sha256 = "13wg9ygbsziflxyjwn0yrci1h0fbl8zkzgbvknf94qfpfd8vrf34"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "8.0.3"; sha256 = "1s4lq0qiya5v73b5niipzmqkhj2d9wcb3nfaqlkbyjq660ahw98w"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "8.0.3"; sha256 = "1wmkiklh37sfqw5p840a0yad9lgk6x5gigmhkdhw5wrvivbnm4wi"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "8.0.3"; sha256 = "08z7lr4hndf3ach9j8c1snkfighqsk5gsp6q1hzv8z6c1i3s0nnp"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "8.0.3"; sha256 = "0w2az1b4bp5494qi922kjh6hmrnkz4x8nbf9xbrz08wyfkbw8vng"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "8.0.3"; sha256 = "0ri4jdv0v0pdwmvwgdzc46v43bd9d0xbbwscszqp8yd64dffs33v"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "8.0.3"; sha256 = "0isjhgqr3a6ys5rj394dywvpzgcidjvmz7asr6vfn0c6lhqcf10h"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "8.0.3"; sha256 = "0pfwzvnm7js1k1xydr4jll46psdxqb5402ypdzh7gc4ihcbm689q"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "8.0.3"; sha256 = "0lkzrrdgsx26hp07ky6zikdw0kcdbaqxl9d26s1zjvcpdsa9xz2p"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "8.0.3"; sha256 = "156zl00c6zlgvyfkfnfbb85y5g1b8r31v0kzn9ghkv79xy037h5i"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "8.0.3"; sha256 = "0xahpvdqaabkiyafb7x6cbzwf7vdvvgxbk0nhcb9379c87wpcb7s"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "8.0.3"; sha256 = "188bxir2v9rcfg036jmnczw3zlmf0kpy2f28jgbqli8ramlj5jq6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "8.0.3"; sha256 = "1pi1kgqnc2kn9kdvnxzddlx8vfw6qviv7n200c12ld9azgnxad0a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "8.0.3"; sha256 = "1ck7pky6ks5qq294vlqjvxrdpi70xc1g0yhank9kb3vmx9ixm9li"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "8.0.3"; sha256 = "093hyzhyfadj41wdc2ryk1i2yfrsxcqsflvpxaqlaiipmcj89yfr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "8.0.3"; sha256 = "1a4dj7wm42zxpra368p0hv02nfdx7rmrhbq7bid4xxpyqrks0hyl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "8.0.3"; sha256 = "0bw3rq614n7nzs2m7i2wi18rrrxz932lj0nqrpabkiff085fk3vv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "8.0.3"; sha256 = "1bpx1fkyd9dpfjb70l4gh73qvin7rimfrx2hsi1m2amqjmx88s6j"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "8.0.3"; sha256 = "1kbhmn6rdam2cp7pbfd78qfsb19cggi5301g7zglisxpnsds82py"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "8.0.3"; sha256 = "1s5mzb855fbg76pa72cqw2l2nzysb0gfffq62hyv0bwga8xpcqq6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "8.0.3"; sha256 = "1n2g90mg627hdw0w22kglg32zdzdxgkbkhgidsxrhk0lb88gk3k9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "8.0.3"; sha256 = "07gx4dvdq8bvz2w2aynvxjzljwnaxgkbarl433jfwmjkfdw2r2wf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "8.0.3"; sha256 = "19cbqcbsmx2mx88b6xhyh08r16bl0pjq1c5vgj5ai63phs6hlsjp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "8.0.3"; sha256 = "1b2fx07v1hbw67lqk4dpq0z95s4akl5wnx7vw2gvnhx9qcmpqccj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "8.0.3"; sha256 = "05apdnf8m204qlirsysrbhvnpy57lf74dl5iz4z4l9qw0fm7gn81"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "8.0.3"; sha256 = "0ycmbs1dbk98j5q6pw8khhfsf2lrkqah80c2v3jb3bxbf9x0sfg7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "8.0.3"; sha256 = "0gk6082rr0fm3dzspwdqfjzhsbi02iym28r4kcyiy1wcx83z7dfq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "8.0.3"; sha256 = "1mv54c05wzr4mlzsrpwcxpgg8ldq7vd39f023skmfs416ixqp41x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "8.0.3"; sha256 = "1p83bh6nd0m5m5br0grzcc85cflc0xpia25vxxs16i0irzc1fqm2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "8.0.3"; sha256 = "1h8d2nid9p4xm4lgav9b1iiicpg52x9nb60lslgivag7lh7insbb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "8.0.3"; sha256 = "11rrcvxg50qsqzrpg65zpp1cdfcgvxbzd8ff6myiq5fzq8bx72xz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "8.0.3"; sha256 = "14z23ir1snd6mlf2jcivrclrmy8vaa9s6kxqa8al2zs02k590a0d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.3"; sha256 = "0v8g43vwfi4gym3jbkpwqhw6fsv5naa7vm527cdvqa3yq1pgb258"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "8.0.3"; sha256 = "14jxk4r7f08q605dd72vfclis916knpwc0zfhzdgwb55v70a7kii"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.3"; sha256 = "1wiv4idfprsj5x4xxi04nff7qnqniyiscrbpry94nx76vxag0029"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.3"; sha256 = "18hrvqjwlx2c85wlnk8czkvma5kjs85mkqb7f8ry6yqpkjm1zbc9"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.3"; sha256 = "03c747j8sqqwia8ja1ac5h22qrdzz6aj7fmkrsvh1dsds0dkzsdv"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.3"; sha256 = "00iy6g8cr4imzjrcjxf5sl4axgqsr940bbw58xz6g46psc7adzg0"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.3"; sha256 = "1jlg3mclqzs2wd1vv4kxgsbwcdvna7qk97vk6016vl2cynnsyrfp"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.3"; sha256 = "09nhkp9bsvbk6yrfcv05h574gafhc4xfsyxjfrh3wlxb9j93frcm"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.3"; sha256 = "0pqh5qvg711ipv0y006lpr31s5c55rxb334jsgvlf5srk4smvxzx"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.3"; sha256 = "041qkxagvan49jq360xhnh89ibckh3ymjxm72bxv2ccf1klk3126"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.3"; sha256 = "1j46kgss9n3vwnvz3zcix2a9gb709i62l60xcz70nk0p1d3nbg58"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.3"; sha256 = "0510amnrki6rjlxs131rp6ff22p5hlamhsfrhcnwl7f3jb4gby30"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.3"; sha256 = "0zxch9ln8iawzxm4g98yjkyn31f6wn3midq19mzafimzjry1g8sl"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.3"; sha256 = "0lsflbq0l6jbyrwx3k6ff09n7q40sfs53rn9cvc71cjyam61raja"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.3"; sha256 = "1mdghlrcma5k5701xzwhlgwn5mm0zasxy4igrgsfgc3v9s3qjs40"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.3"; sha256 = "11psiydrjxfbc4kl7q4al5jn7n8f8d4wm7nlqwcw7jvrfyrp4l6j"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.3"; sha256 = "0k26pdbd7cjvrbaw0fq95f9v7f0rwnfhgplp0f2rwf5bp64nn4gn"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.3"; sha256 = "0c6mzp5fy9zjad59gc9f14hz92lcxgxagc6dkya9n5fvp9qwjzmv"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.3"; sha256 = "115f9gzja94vnc93x68bwzc3am5q87hkpd07iwxnk3dh67nksbxj"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.3"; sha256 = "0syqscra6z005byz9sbz9yc815q617g21ha0460q4pvzii031yp7"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.3"; sha256 = "19pqql64wa0dhgcpxz5xyb46ryxrwhg62f3y8mhk2gm53aq52v3q"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.3"; sha256 = "0743z371y3xzm3cvm5nzssnv8vyva9rrk3aphz87xss3rb23wn92"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.3"; sha256 = "1202ap5dc92p70w0cda8vb0lrlyigdqbzscm4pr7vvcwl7xwwb0c"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.3"; sha256 = "0ffz835gdr33pzsf3vp38kgh7ivg7wzq15a5im25zlbcd88ach1b"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.3"; sha256 = "0srxz39gwmx11ril5ba4nnavl6rdf56bdy5gslqx89y99jnnz73p"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.3"; sha256 = "1a3pip3b2wzg16pl68yxmpcz51fg25v3lwh66lb0z14cc847p4w0"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.3"; sha256 = "0s3qln7mmniijbqy06pnjj7gsp19z6cnrb612chaj2k8fr9jmvba"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.3"; sha256 = "1x9qar4fk1nl6r06gvhd0v1jgnhdr6wpqkrjvdxa5nkyi6gi03r0"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.3"; sha256 = "0wcvf7f9d187bapjdyfc4c75z02n9h5kjhkazv64rn7bp9pyyl45"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.3"; sha256 = "1yrsg8fd5006n8rimn0hzfgz2mshmvalc0ffg5s30fbvv9w1i423"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.3"; sha256 = "1bdcymyz32af2msd5g0ip0iihla3i98f7wfll6kiwfl3f71czx3f"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.3"; sha256 = "11v3wrfm1y011h4rky3xc9k868yhaizb0rhc4nzrbp0fnijca8ar"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.3"; sha256 = "1yhmvxjw3jc9fjs8a61cyyhn9gwkij40191ip103bwjkayyqb9sm"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.3"; sha256 = "1rvi2xczd7q13piy9sddaim899kv7zbsbw1q4lc1w0pzgms2kzyc"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "8.0.3"; sha256 = "0mxwp1lqv6956qdagx78a5vgqkhdvrapp3y5fvf095qrzszwpk10"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "8.0.3"; sha256 = "0mnd2lrgsln1yhk2kdikgkcx7n6m1imy0cca9jyqnmn0hv2i730w"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.3"; sha256 = "1nywm6b3pjixsn6yzhhcgrn0nrp6mqbmcdl28idizz3j817d0sx6"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.3"; sha256 = "11dv4fp84wr940vwviwxmbx83q97lf94wima3x1r9yqxfz30hisa"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "8.0.3"; sha256 = "1bp62jp52ksrsmyarfdss7913v7xxg3k55mbcyfd8n8h700d098q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "8.0.3"; sha256 = "03qrqwd5v9rvc15i26ik1jxy670xm3gl5qv6mmk0ii1b6qw97ckp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "8.0.3"; sha256 = "1sy01757gmln3f56mi64ax2689fqxkh77rqk91i75kcxl0hr60x1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "8.0.3"; sha256 = "0jnd22x6hi16c8q7l74kh6iqvpl0cbny3fcrrpqky38685n5nzw5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "8.0.3"; sha256 = "00n4qfz9c62xfx8lmfigfyghj59lgkrc1rpv58n0588i6l73njk5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "8.0.3"; sha256 = "1jzqv4ldygjm1hmlslc83wjbh0h1zxrcjl9g564vlp56wql2yy73"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "8.0.3"; sha256 = "1qminm5v4sdzaa7bsya6hq0n9xjibha4sqgxxbkf8firc61rnni7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "8.0.3"; sha256 = "0z8si6qavip6x33m15lznla0iz1h6hcdggqxaacn4syibjs4bf2l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "8.0.3"; sha256 = "11yw9zlqx5hfa90hxz2f79728ivqi7n8w1dkxs95i7k075bbinv4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "8.0.3"; sha256 = "0h3ff5aqp78k2p8xn3rsr7fpcgf2d60xp1pipmp37v5c08mlr4zj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "8.0.3"; sha256 = "07lzl490k58bdq9l1dbwzd4mv5i5jlcxzqac9i6xzbqydk2pfrlh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "8.0.3"; sha256 = "00d271x2058cjyd4cy2l3phfz771qnmvy5p8ackhv1fwjn5zwvgl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "8.0.3"; sha256 = "0zj3ni8ckbzxzwspgb8lwdf154ibdfnipjfghn7940j45cak2n9p"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.3"; sha256 = "1sii9j84x9ipi3hj5dqw9anw76xrwnzyn3pdbwx2hyk2pdcss4iv"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.3"; sha256 = "16nzx2sxplay6iipvrnb93mmvh4ypq27j5c4h2hlcqxi8bzz6dnq"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.3"; sha256 = "10ad9x2piw8ci30pfrin59yc02ylrzal3przmhgk7zd34wvaphq4"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.3"; sha256 = "0263g5k2xg853c4pizyq88g38ykc4a5v7ixr88jq5q9hrs215x2x"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.3"; sha256 = "0kd18616hxcq3hs7275h7sw6fs3br7rvvx8258575740l1wcnqsn"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.3"; sha256 = "06xfiki341ygqq4c6nb3l5dna8z6p695bibrn6q4lxmdhjjkh9kj"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.3"; sha256 = "180wwhib64wvsmycawkrdabxjpk6s2wzd1mw9gd1n4knf1r3sb6x"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.3"; sha256 = "1mqkwsc57vav90ld2k0llgpsmp768r7gr82qd3xwmxmwjk9ch9lc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "8.0.3"; sha256 = "0vb6qv8p0baw0gndd56na5cp8zrp83h14ljqxjary57ni3w37bir"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "8.0.3"; sha256 = "0ddi76rp2kspzghladd14v43ygjri0n4kdha75f16a9zbnlj4p14"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "8.0.3"; sha256 = "07lmljj19hhmq762ls76j8f73vmkcwr4bng7j3v2wnc63lif60bf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "8.0.3"; sha256 = "00kvs8a3nkl11d6zp2f1x4r9dfjs1pix4cvl6l1np00i0vwa9019"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "8.0.3"; sha256 = "1znfsgvwi1p1v21qv6vib9n4kl7g0faylr83b375dh9f6pz6gayz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "8.0.3"; sha256 = "1pl6lg22k3rwrcfx7nb5vv5jmdqx3y3r5n70r7jzhc7f0f4sr8ls"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "8.0.3"; sha256 = "0zw9n8zb4i24ryb0w0v8iwb370r30mh059vaasvfcgs3kf4rhm3v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "8.0.3"; sha256 = "1hl3jc8nkv2qw2jqpzx0brimd3yi8qmywcgvcljiwb4hglfypi7d"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.3"; sha256 = "0wahww6zd2054yfwrgm330i5bs0fnxnimiqam9c2xbi07cjdzs0c"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.3"; sha256 = "1f2h7nqwhr2yc4lsl1v9xy3znf7l9y6mkn7xqbkxncjsa8ily5hq"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.3"; sha256 = "024w9m1hyp6g50kn4lydhknac0bna7sn2q9wljnridlrkibrpfj3"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.3"; sha256 = "0gwjfzmghm4fmspraygdj9z9bsmczqlnkyxp3xk8bdrs5x5z62bm"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.3"; sha256 = "0z0cl2p3ax93zjmzi623mc1l9x9nw6rmhjqmqch5yrvwa4a6h3k1"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.3"; sha256 = "00s4nax6jbdp2ny80sg372xj1xmj76c867ym77d1s63fjkfwxq60"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.3"; sha256 = "1c5f2m12kxd871ydsmz4sjwqk7scga2bh0dldg6pq9rb3lgyfzwq"; })
      (fetchNuGet { pname = "Microsoft.NET.ILLink.Tasks"; version = "8.0.3"; sha256 = "050a64bjws084rsq1xn17mw0v8m4b85y6gwlnhh3rxhp9jygpvwp"; })
  ];
in rec {
  release_8_0 = "8.0.3";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.3";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c1371dc2-eed2-47be-9af3-ae060dbe3c7d/bd509e0a87629764ed47608466d183e6/aspnetcore-runtime-8.0.3-linux-x64.tar.gz";
        sha512  = "73a16e08402989f25ca780acc981c2ae3a41ef39b4bb6b6b4962053144b6eda7c175fdd5ee3c25bcd0c86a27d1a83d4f8b9b2f69f37d4e3972f5901a9e0600b6";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9feb7c60-3821-433f-994d-c6861b341d3b/5b90405a9978455b10ce6f1fc058fc1a/aspnetcore-runtime-8.0.3-linux-arm64.tar.gz";
        sha512  = "2ddf440be273febae8049df9b2837fe9b9d95d43a31898b915dbf39aedaf15a291ff28711e983fe099ab22a291ad244813256d57ebb6ef1fb94f04d712a96435";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bb76b58a-59e9-4652-b457-ca7ce7f124d4/1afc9b4da60ab79bd103caa9516b8259/aspnetcore-runtime-8.0.3-osx-x64.tar.gz";
        sha512  = "b9c4ecddbaa20aa707e7fd817895823d42211fc34b44146a2a994cbee1837ea0a2d3d5d5a84318039de0a0ed51af3249d11b2b31904e54b86114bceb05b31f0b";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/794f6ac7-83e4-4af7-9150-7722bf51b5ed/fb380221e5933bc50e5266ddae54e083/aspnetcore-runtime-8.0.3-osx-arm64.tar.gz";
        sha512  = "06fddde704006f92eb3be4bfc95efb9971d54c24038dd739a78ebc2af2e71ca97202350211b53f82f23a4e3ca37ae89d23fb56bf64b5d58d404e7a153c17ded1";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.3";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ed0c9129-950a-48db-80be-e770daf2db41/53879e5802bc6e76bac55c1b8154ed06/dotnet-runtime-8.0.3-linux-x64.tar.gz";
        sha512  = "08ad7065abf73d09bd718963bd1277c4736f9d51c7c51849255732db03b59f2321d321235be8be35ca5ef2bbd4f331a0fecaefb48d3e1075659e075bcd1f0169";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/988a1d6e-6bfb-406c-90ba-682f5c11a7fc/28208806b0a6151c4e5d9e1441b01a6f/dotnet-runtime-8.0.3-linux-arm64.tar.gz";
        sha512  = "a78f51500fe180936152f561b3c2385939053aaeb1c2eba5e1353c6427a57fc1c6de8ffcc398afa0d2051ec696813b7c635917f6f0554028b725c58fda981871";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/564a929b-4f15-490b-895e-5260338cbae1/1db7fd97d0907d3911ac3e4dda32fbb2/dotnet-runtime-8.0.3-osx-x64.tar.gz";
        sha512  = "5ea3f5cbbd9855cb0f305b8b3252e10af03bb0e116ce04f8c764cf5512bbcf7803378ed48cd9fc394e5282761f4137d061a1e2447d2d5cfdf3a2226a2e14a9e8";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/08f11d3e-84de-440c-8982-0c8c62273548/d8a497c6cae9b84456d0b90cc7635231/dotnet-runtime-8.0.3-osx-arm64.tar.gz";
        sha512  = "c70ec1c2f258adc07b585896d5cee6246d8ee5a2f7228c9a52c958c0cad2e6bd8dd6803bfb0c5243635e89dc5a5fac6e32274f1b574b79dc4fd31d69e1aba2cd";
      };
    };
  };

  sdk_8_0_2xx = buildNetSdk {
    version = "8.0.203";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/656a3402-6889-400f-927f-7f956856e58b/93750973d6eedd17c6d963658e7ec214/dotnet-sdk-8.0.203-linux-x64.tar.gz";
        sha512  = "78b1913b54a1a4c9f13cc2864a11540b5fd3bdf4ebb49837483e19c0906a1890f2dfcf173635a1c89714bf735cbcaa01db0f7ae90add5295da69a0638ed5e60e";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/aed2eece-af6d-42e6-8683-21e7835b7479/786b4f225591440a741c1702407fb7b3/dotnet-sdk-8.0.203-linux-arm64.tar.gz";
        sha512  = "cda16b2141c1115ec42303d82f2720ddf5368b7242207e21d3fdd81fa89df2676f0d394ca7293c76c35ed2448b289174739771ec447404ad9c84c72459cc0d81";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/87f31249-1415-4edb-87d5-7f16e63414e9/a1ad58c05a131c618ad458a1564784e4/dotnet-sdk-8.0.203-osx-x64.tar.gz";
        sha512  = "28588e173bcd185a2acaf26f029dc63e238e29027cab0659717549de15ea88c6075fd384b276265b39c4a91f0005dc81417fede62b6f2f81c1a9c5a4a9b0153c";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9019f736-bf0c-45c6-8ea1-c2370f7c59f1/e88a79c0abd77fd38de8271b7c06b293/dotnet-sdk-8.0.203-osx-arm64.tar.gz";
        sha512  = "39fdb91136516f070b5f398b46a7503115493f1cc89d9bee7ea7ee4541ec9d69a4d673d87498e578ebb2cc81df8b062d05c4f7c8be80bc2b113cc61df1157c0d";
      };
    };
    inherit packages;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.103";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9e445c62-e14b-4a06-8913-ff19d8e7de50/39a40667f110cd352de02f7e7eeb4c6d/dotnet-sdk-8.0.103-linux-x64.tar.gz";
        sha512  = "5894942d53ff9acaacde589e6a761bd170f06b696cac465b2dc62b741bf9d9a635721ef4e7fe9477c52ff22feabc928bd8cbcd167a9ea92a6bf6a362c8b63daf";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/af9ecab6-0ee9-4256-8470-1dc4530f637e/084a6690b85f806c06764846e3d9fb39/dotnet-sdk-8.0.103-linux-arm64.tar.gz";
        sha512  = "486c6dfd0c37771422fddaec155950663e79bf2afca085ffde68e2af20e42bcac1bcbf0d95dcc0df9469e643a7f81813ab828afa114d5f715057d2a3895e531b";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/89e38f58-5392-442e-b5d8-9c495d6710a6/5368de8a490982fe1cb191f76f6e9f62/dotnet-sdk-8.0.103-osx-x64.tar.gz";
        sha512  = "86174aee177e039751a5dbd019ed95e4cb56389c9725902c513e5f50fbf2d89cdcb113173a8f9de9bab844c70e1986b3bc3acf8f22402e09473af413df657a3c";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5218a7b6-0e8c-419f-9ea3-5115a194b954/02c7cc5c3bc4ff89c14893ecc299f05e/dotnet-sdk-8.0.103-osx-arm64.tar.gz";
        sha512  = "cdfe17109e0b55777e2ed95e9a538bed67ca532edb0e56eb1c52cbb53eec73959141a9f744c1c1a6c5f9e2863d2f845296b65afa94c726c1a7b3274bda869a65";
      };
    };
    inherit packages;
  };

  sdk_8_0 = sdk_8_0_2xx;
}
