{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v7.0 (maintenance)

let
  packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "7.0.18"; sha256 = "001f6hj331sy712yq1p1yzdgpxmdz0zk8ikgyb18sxf2xflggrk5"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "7.0.18"; sha256 = "171ygqrbjza8d83awyrqpm1rhrdxmq3x5qdpc2w907nidf3h1nwz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "7.0.18"; sha256 = "1b5zgxzg71jgr2rqgxqgnl9b98zq466g6l15nzkqwa4pj3y2i4s9"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "7.0.18"; sha256 = "0f9dhjgw35i9z96qgq3q7fn0csnd3f17z6db3vw1j126k8zy67yy"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "7.0.18"; sha256 = "0i90lp2pm3x39ypilrvf6v98j3pgj68palw1dimdf04vfi874s7l"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "7.0.18"; sha256 = "1z11qffsbnfdk2a5yk7q8ck12v0vck60nvcd2wrqawv87pxga033"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "7.0.18"; sha256 = "1awf0s6z1grny54s3lbi01978kywx0vdrif0vx6m75n11lps33g1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "7.0.18"; sha256 = "0kq0l498p54314ajsjpsi0rkm17frhsagw60v0ldr7d6y3faw0yf"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "7.0.18"; sha256 = "19g4h724s358an75wksgcg2q2pp6qkll4rrrb36b174cwr265ahv"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "7.0.18"; sha256 = "08d6fhhppdh2arzj9vp7qplsfr513p4fvzl190ybz5zrzxx3nayx"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "7.0.18"; sha256 = "034bccx7g5bn7kjfqsdvr95v7vw2c5cvnifna0v877lb3pbnml6x"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "7.0.18"; sha256 = "1likvj92lgfmbd4ccyff3byv2089wq7xijjcbgq28vp3zha0lr3a"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "7.0.18"; sha256 = "01axi419jqvnv1zpx0fv5ky7d1cdysnn800f6ix8jhrab9h9vlwq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "7.0.18"; sha256 = "1lzmmirxivs9aldpi30j77mhm15fsnr5pi3r4i1nbarqz3jm6kbd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "7.0.18"; sha256 = "0bwcny3bc7swh57isij2v5y4qbd08zvi126nwkvyw43piaqn77yy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "7.0.18"; sha256 = "0php4saswya3ag0zjb95ybb4xj8z8vpbb3bp1gq4xf6kdmkzaz7n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "7.0.18"; sha256 = "0864r2xnczssc4sfrqbvjdqnha0gblrkza4xjk0r0ndiwshyrg3x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "7.0.18"; sha256 = "0a0f8icdzps5cjvgxw0pi26vjilnvii5dqljg1a874y9pazamk4q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "7.0.18"; sha256 = "1h626c86379jsk2fndiqr3zhhrnz46vz7m4s5pp1kz02pss6wjrf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "7.0.18"; sha256 = "1708v99wr4zgflnpjwpsl7dq3jc42mi03z18055p03vmpqrl25f8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "7.0.18"; sha256 = "1xfi9h1gkjkssxnn5gdpa2idhrxcf7yfwgmsy30q227lql7z9hxv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "7.0.18"; sha256 = "18r8vzsgwqnhppx8jw7x8ycamdpsrgfhph9b7s6cj7kzam8vihqn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "7.0.18"; sha256 = "16r1dc61i96df158qk6295lrkpdqd9fy6yqj15027x76xxf234az"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "7.0.18"; sha256 = "098c1iaz3pbwha79vlfbl98cn6zfh3ynnlm2307z5mzb7i4lk7lr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "7.0.18"; sha256 = "16aaf3137rpf93k4k24qdbvy8y0lfj9mqv3zym5ndfd3jw1jh1fh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "7.0.18"; sha256 = "0fvb9s3z71pwmqag8zk2bl97dq8jjnpw45mh0gya49wvw15p1436"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "7.0.18"; sha256 = "1108sk0r71g2rz86yppz7fmlf69ij6gyrazyvyk9hkhl90lrfzyr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "7.0.18"; sha256 = "0b0cl249p51pa36fcwng31g2cp2f8m1360g0cfizq4wb4zfa6a62"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "7.0.18"; sha256 = "1xn4v5avi78sww9a5n2ijf96sv7jixablpqr8fin21fsgg9clqs1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "7.0.18"; sha256 = "03d8zp3f5md61kbawpiac4qrlsn5l4xj2k07kn4s6vkg4r3wz2ia"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "7.0.18"; sha256 = "0hz49hsrk389lmbz8hk057vsqg1m9x8r1p2vh9w1kc3y2ljp9gbn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "7.0.18"; sha256 = "0j5vjd20f492q6sj9i74cflyqzrxr4wbqwdz8yjlaimw00yyg07z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "7.0.18"; sha256 = "1nvlbkhp66zangjpzf5cj0gywkd5kv81hzbfk7igdfbpwmganw7b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.18"; sha256 = "0ng09aacwi2kxws1i695ri8kssn01wb7cd7i3rf3sx4bcyx4ax18"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "7.0.18"; sha256 = "0x77z0kqs56jnr9yma21pdlpw2gjyxccjdk0cgybc7fg36rzpz5w"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.18"; sha256 = "1ijq8jhvfsij3q4irb6a0mnlp57q3yw41qp3bsymi6pbvg9pwm7j"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.18"; sha256 = "12rvs32ggwg4h8j2vgyx0aj8kl1yr17d6d7mw1x26qsaj4y0grzh"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.18"; sha256 = "0mlaifk2xjh2w61zp2hqi4nnqlwzvzl2mn3k8p5q3d4zzjna8apy"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.18"; sha256 = "1ccr55ps2z3vq5bl8mlsfh7ks608fygdrdrw5v7cgf2z7ihihlfh"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.18"; sha256 = "02lj8ch0sq8avqd13p9gk8b7xfwm1rc6qg9q6vpwjdmi80f6zs28"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.18"; sha256 = "14ap1ap85w17h1cq5dlkzp9wnmrr02gxaq8a33ri84gaknsigv41"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.18"; sha256 = "0ipy0s2s54xr9zvy44k13wkk3dd347ks5nz4h27g958ilc9xz3xl"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.18"; sha256 = "0w53iz43wrzyyy4rahvgbpc4xv4yrhxh1bqmcjsycvv5vf0svj2x"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.18"; sha256 = "1x0b90pydgy0i0kbcbfipz4v0pmjd52862rx8d3r68vkfxym7ra1"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.18"; sha256 = "0glgv2dxyf5k6rl7qd9df4s8vrh8wkx2nwv31hcphb3wsg959kax"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.18"; sha256 = "00y32d2c64kkgrri248rp0api9d9xl80ggfhspfc9n08s3bmcknj"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.18"; sha256 = "0s6g0jw99y1mv008q2mckqx0dkhjcpy49kmvm7kpzb20sw4hqqw5"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.18"; sha256 = "190y1n6yv8xqsrmas96ragzvk54kc58mgr7yg0h50i8mq77f96pb"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.18"; sha256 = "1f6dwf0al9ma9m2n63w1b3yrrl5zpqy2knhrcg76njmk2899w1sc"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.18"; sha256 = "0q3qzh2ni435zygimvp35m3c745fafqa87c8gd6ps1fmc5iv9w1p"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.18"; sha256 = "039sh5f8pq1nf1gj5w1ghrpqd3bci2a3ys2sh33r3skhys4k21y8"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.18"; sha256 = "0a2vzgc5pgrv0hn6ijah7s0y2i7aw8nak6mai58mx307kwrawsh7"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.18"; sha256 = "00gq0fgkz198461470gpmixl2b5lgz02yzyz7mz297d2lxixq54y"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.18"; sha256 = "1k1ri4y8d49sqyayi3lg8gzybnb9bmgcqzm8qisi8cf2yrlypc23"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.18"; sha256 = "1q5zg65jlnp0vv4j4ya3kl70843smzm5ljwx21cx3dlnl92d39v4"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.18"; sha256 = "12hvpqgmil06z28ix5x51rbzm99vdxgqr1090c10b9gcy231bbhn"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.18"; sha256 = "0n9hvj7a4f44g38x111ajcjmr3ixq2g2wh3yxr2jjpv45znk0nyz"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.18"; sha256 = "02fd5il9bihnhmvhybw1sqsb31241kg035vwxgghr17bbyb9yx8r"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.18"; sha256 = "1sad1x4sg06rfh2bjrrwy2gk5ik396p7rggcv3p9v9xfl3kbjkwp"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.18"; sha256 = "1mql52lndslpqxb673cv02lif9jxahgm62977r3rdlypljynbymg"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.18"; sha256 = "0gqnw3hvfpvy1lddl98y3jiv69x11ahkcxcnix9sdzlpf4vvshfl"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.18"; sha256 = "1vwjqnyhskvmxnym65a48yh6w9l004a9xk6dfwdqmdxxlv3d14lc"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.18"; sha256 = "006i3qylks25j3cirlafml07wrhlcb3pmpzknbx1vr4a8q29498d"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.18"; sha256 = "05jf0dvxa1wqamdapclwrkfdxvll4cah2i81shaf9crhw3wlpmxq"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.18"; sha256 = "1vyxww3kwz8dw92v0rd3f1phiif01pymbissm3pb9mrf977dkav9"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.18"; sha256 = "1p2dbqwqflh9qnhq70m3jlycs9agyfy7ird9g83icav1v504vm89"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.18"; sha256 = "1y0kka39xahz3a7fjdngd3bcqw6xv7wwypdnq3vq3agcadm1q0rn"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "7.0.18"; sha256 = "1070gji2j2dkb9130c0s3pc5bns4xwkl7y2n4daqz2haqrc1lqr3"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "7.0.18"; sha256 = "1qi51x84nn6b69gpqqxqngc9bp4y6z0r6sqirdgfg370vqly2qhi"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.18"; sha256 = "1q6kxjzi300jkinp9dhnvwf84pj4kh11n3jv0vqkivlycbja92dh"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.18"; sha256 = "0q97bwr9rrq5p6arziz9y31hliplydbkybp8r3ajrl6qh0xlfbd5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "7.0.18"; sha256 = "0hlaxh06z9az86vd8w373hwb40fmz1x43jabl8qdz26cm8hlzngv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "7.0.18"; sha256 = "13pdmcjd64g89wlgj2aiimi22z3nmy6s4wm890h0j3vfgj8q6yhj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "7.0.18"; sha256 = "09zc0k8wv42par873a6gkyknbpgfsam7mmnva3yyxbpm7pxn945y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "7.0.18"; sha256 = "0wj6413ijh62g3pbacirjb26qr38nghps29wcqkp4p56sybx24xf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "7.0.18"; sha256 = "1vj04hfs9xwm2k3r2xgzrwbbr4mxb4n1ri4xsdds0vr0qbfgrb8p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "7.0.18"; sha256 = "1i5an4bhlcwxqbdza35x6l1wmhlsw90nqg9kk9r4qfffyccnsz6y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "7.0.18"; sha256 = "13i6kwkrbifsbjqjx5ik032s1plg1db6wwbvw10qrg82y4x9989g"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "7.0.18"; sha256 = "0328z9jvp0agf7wwwh8hhz5l1r0xpspx6rszdak6mxjqpgs0nlq3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "7.0.18"; sha256 = "0gdvsig08gfcr5jw9a7prqwdm2lk5qz2cq4n0daw1k4572mg4qp2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "7.0.18"; sha256 = "18vy1jkylb3842wc1wjki70rk5wvx3wxfgyvqf15mfgiaw5mp851"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "7.0.18"; sha256 = "1f98jankwxk9d99pmrdnaflydxcj3wc0wkxc13z6plvl63rprphs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "7.0.18"; sha256 = "18sdls7flsdzbdd3jfrmlz0ssvzbfwj8ackx6p40mzr9w4hlnli6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "7.0.18"; sha256 = "0j75anj33h6avdjhvdcqbfbaxj7l07n0850f906ral0mvgfd4ndg"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.18"; sha256 = "0gqn98lic556yf57cgw2gsfrb31v6l5mn3z7kinnp9h25vhbc8wb"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.18"; sha256 = "18gq0h1x6x41qpk754s0vwx6lxf9bhmr61hix3aizh1b3brxhmjw"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.18"; sha256 = "0s0pmas9a344kn7srq0pfc8fgwn6p9qkmnhpcnh1yfkpj4k8nd0q"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.18"; sha256 = "0adz0q7y6xqrg9s71vzwnv6cx871m5ya2kfaiqiff32f7296gcq3"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.18"; sha256 = "1ifibwfypiyc9wl538ivlby5l0csisj5visqnfifwwxg4qhhy2vy"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.18"; sha256 = "0abdf1319zyia7zxqfv32c4fb9rw0qw3qivlbs1ms8qk4c7a5w4j"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.18"; sha256 = "1nf81ngbhr40d81hq6c2d21x0cjs7qh269z1ynwdiv3kslb79sf1"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.18"; sha256 = "1cqv7vvf1v71r5ndwammwy9rvwrbmhmwwpfwpf9635mgnh0707ph"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "7.0.18"; sha256 = "0cdj0g3cyhpfbkpqzbxslhx7pc8a406c1w80y4bxd1dxmwi387p2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "7.0.18"; sha256 = "0mhahzk11a5lziij0w5ahfapcf219zkwfihwqaymwlgyzxdzilq1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "7.0.18"; sha256 = "01dc6m6hwv4zzbpxbib4338j7rhm6kxgz92f84idjnxc9mjrz823"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "7.0.18"; sha256 = "006s6a5xhkvpxm0f25g85xiks7cv5gb6zfqakw4hq4r9sisi5mvd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "7.0.18"; sha256 = "1645i1pqd8a700hf7l0bj2hyflyllsrhvw9nc70fid6sin20nm5y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "7.0.18"; sha256 = "0sabmz4ifqgc22hr1dp5ci7xlhlfxdzl2zvlf53mwkn79818liar"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "7.0.18"; sha256 = "1nda77r6bxa21zph5zymnnk1wym8sla2qrnrqrd0a9sqmq82v3bp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "7.0.18"; sha256 = "1imi3c2g4mpc83ppbl4ipq9v73h2pd3497dcpz8mcv1z82ga0pdy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "7.0.18"; sha256 = "1iws4awg6ph7xblcckza1xd0wzq05s7fkx86j4acsxqmvi696fp7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "7.0.18"; sha256 = "1ix4j79k2azkanpnx63ifjrmfh3qx501rzk3bknf7vh2c0ds2p9d"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.18"; sha256 = "07n3npyw36jddvixnc89yhkj1nj70a1fxh7skq92720z5i76wwbd"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.18"; sha256 = "02girjrnralf4pdz4cv0pvvxvkakriqakgw95ci0ywqn5gv379b0"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.18"; sha256 = "1wbals50h7lnnqpgrinvq5hknl6mvfkgjd83i8c54cpimcy20myl"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.18"; sha256 = "07n6jq7h5750zznv65jjasis010n4b70416mmnc0rn6vdnz3fsbn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "7.0.18"; sha256 = "14h8i3539ghggliix8b7gnzw1wx4cgb6qn7qqx7zaij6b34r9plz"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.18"; sha256 = "1hmnw40zw3m1bwlb0xdnfl1gf66551cyq9vavvj3mnxpximwbc02"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.18"; sha256 = "0a1ln258drgykx1x8hswbfy991mjh017j5f47avgbkq7gxbwvsjx"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.18"; sha256 = "1j37aizp32bfdjs5p1grjdqzyci37gblgj4vxgr585v1whs5bvnx"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.18"; sha256 = "1j7q7nbw887l7np3sy1snxyvwmlfq4kfhbrdx73ng721mv7bvkdd"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.18"; sha256 = "0518w3ifl093jap27p2xhh923if5r01jg70sbkfh3sgc7vwqjsdd"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.18"; sha256 = "1h2fkbva4ddaswkw3zq4bv7gvkxx811svdczxvjx2vhw2fyw3b45"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.18"; sha256 = "07sbkvvx4ixl0yxy91y0avbr7fv2j26p25c9cq42w4jkjzacfjc1"; })
  ];
in rec {
  release_7_0 = "7.0.18";

  aspnetcore_7_0 = buildAspNetCore {
    version = "7.0.18";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/39baab6f-96c6-42bf-b772-29830158176b/cde064792e7f22506d692f54993fe5a5/aspnetcore-runtime-7.0.18-linux-x64.tar.gz";
        sha512  = "d2c3af93b9b8280c4e519f052f443e0504ccf7a04b3eef60500b2e3a8874a60a3a545ca936f8433887bfa6388106c19283c5a6a2c78ffdc19889bde3edbefbda";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/119db743-de75-4bfd-ac51-f2a2bfd1dd1b/4e96dcef933e3787a34691a86f8972cf/aspnetcore-runtime-7.0.18-linux-arm64.tar.gz";
        sha512  = "62bc42a8d094be8253be90acba02253c27afb1eb6b06976c3adea74f967f522bf7938eaed25c824d6e36a9fb71f7248ba315cc67577a3c7fb73b0d3d7a41ecac";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/79433d6a-6ac8-4c1e-851b-a9335319d846/c91648d921bcec7bedebdaf83cfe0487/aspnetcore-runtime-7.0.18-osx-x64.tar.gz";
        sha512  = "50cecd47a75498ffd2862b3a470c0e05848853b163925c0fb27a7912fc39f77aa27b91d4e780d7ef90e6bce22510714132cbdc06cee0db7547c9d79258d29895";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/be772e15-f6f4-46a4-b0de-2365ccafa69d/fac2f4ae76ba20f7d16e07b60c2b8801/aspnetcore-runtime-7.0.18-osx-arm64.tar.gz";
        sha512  = "3c56c17545d530a35cc13bad410da1caea33bbcc7c3a857b4d68f48a64f02cbba516d83cd0a3fea9a8ab463dac8140a6c079fb63887c176bdb2a44552dc71852";
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
    version = "7.0.18";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9f48eeb2-ca25-4828-87d9-1114e751fa6e/df269cfd6b9661bcd776ed979541c0fe/dotnet-runtime-7.0.18-linux-x64.tar.gz";
        sha512  = "9d2aaf11e798d8dbfa74a93cfc53c6bb631cfb041b5dc55c208f980f61808e872dfa9880c7d9d4b42aad934e5350c9e8f327664909054fa0109636158701b4b8";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e7dc89d5-3287-4f82-b1fa-e0a7f12f7736/3206b55ee6d717f4008a46e67048c100/dotnet-runtime-7.0.18-linux-arm64.tar.gz";
        sha512  = "7cf7d3b0b12cec234227529c66f2a2ecab49e63af2c766d7539b6591f709342da4f2b846726630ab6104a19cd94c1eed5ec66e1a773e3477b344941bc1ee5f41";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/2bbb4960-9fb2-4bd9-a525-80e6260b5979/adecde0cf003ce421b06e76197627533/dotnet-runtime-7.0.18-osx-x64.tar.gz";
        sha512  = "ba790572b8b37a33766dcdfae319c5021568e49be3d9a55c688655b1b4174faf6cf20b3077fefaf57fa2b12261b682a685345db77034412dc883cfa05b8e8ca9";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/38526acb-1b20-4fd6-8a4d-09d72a48c9f8/8db4c13c722425ca9b82fed60d539815/dotnet-runtime-7.0.18-osx-arm64.tar.gz";
        sha512  = "f9a5f09afd9c7cead985cda7db03fa6bd6b684aecedb2b8bfe3bb2569704c233501b1f9888e2e26f273d5ab124b0b9fecf3edf8c7d0b0908f5a499323c67515f";
      };
    };
  };

  sdk_7_0_4xx = buildNetSdk {
    version = "7.0.408";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a256265b-0ec6-4b63-b943-bc27bcfc98c0/47c8bbd54d7f6dbfe0ca4985c410282e/dotnet-sdk-7.0.408-linux-x64.tar.gz";
        sha512  = "89d39601a27cbbc74a5dbbfc6dda6661220e76b73f7387fec6558222aa144734b44db5788bcb888c7f49d4659c8b0ea60794f93ad1223c86ceafdddf6e6b70e2";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/460f951f-0944-442b-8474-555e20394ca8/5fcf6b1845d87d772f919737b3dd5f55/dotnet-sdk-7.0.408-linux-arm64.tar.gz";
        sha512  = "7c5e18f165c2d74345102244a617b475b68c208434512211af154b28896ebe5487caeff96b278e877af384e6e0deb476d38be16d275ad88af1ae177afef561ac";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/dff43b03-6ca6-413b-a48e-82f593c12d40/5760ef99163056c6850f0fe140e01958/dotnet-sdk-7.0.408-osx-x64.tar.gz";
        sha512  = "b183b1a84b345f8e41701f0f1cdcc68d0bcf286d3aad53bf04d860bc6260bde87a6797f6c55ef807609680c10b6efea6bcdf6732d3fa097ffaa99b505bbea7a9";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/749ab69c-0726-4503-9e92-035f13753374/68cbf2a5d6c8e1184f5d8d8ca3bc49a6/dotnet-sdk-7.0.408-osx-arm64.tar.gz";
        sha512  = "ce1b9f7bc67c80b8774b7a8071438027f322c35c330be2667bf15a80a8826a32d9f8a7d2762ba7f3c7417b31f3ac288f336956f6e701d282e80f02c68b805177";
      };
    };
    inherit packages;
  };

  sdk_7_0_3xx = buildNetSdk {
    version = "7.0.315";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e4cc9a2f-7fa1-4ac4-b839-3838d8762ee5/caef8745bcdaf1c089ade6cdb89eee5c/dotnet-sdk-7.0.315-linux-x64.tar.gz";
        sha512  = "ffbaca47ee2a3b601abd1e8ccc99981e55d5f904072d5dc76e0c817940bf1ac1b71f5e652f649112bcee7328bcf0408d203b2f7c91d58a6aaa58c8ff553e49f7";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/12286d30-5894-4ad5-8dfe-8bd03e9fa0ee/58973de54201a7f1963cb524ba421613/dotnet-sdk-7.0.315-linux-arm64.tar.gz";
        sha512  = "a480e012760980121af4eda39dbd0640e824de13f10e916a95e77b7fb591a3c516d40da45fe56dc07cfcbdf24074f4579145d00d45c84ef299ca9ee779c43903";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/32b714c0-96fd-4179-b2a5-34cd29061e5b/3db1ea8db28f706a8af10dd57d1cb590/dotnet-sdk-7.0.315-osx-x64.tar.gz";
        sha512  = "7a7d3c32f71a89bf0d9e809b068252c2496109ae226acaef163f7221e4a8231a2faa2e81ba0a95e7aeef7780691cb59b993e999d45076a280da518941b9fd2ed";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1586c0ec-bae9-450c-83fa-987499e2c9c7/8e2855e078b035404b5fea4f658af1d7/dotnet-sdk-7.0.315-osx-arm64.tar.gz";
        sha512  = "f146ca3f530a96fbd14fe550cded99d36b35dfef4536f2a9174985c933db42c9a6d44708cab83c93a701f6482e0cf868e7aee92385cec201b9d0b5d5f348d642";
      };
    };
    inherit packages;
  };

  sdk_7_0_1xx = buildNetSdk {
    version = "7.0.118";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4e25d320-2883-4b20-aee7-035d586e1426/fdbbb8209dd2ba57a87351c55ef80e0c/dotnet-sdk-7.0.118-linux-x64.tar.gz";
        sha512  = "4f34257abcc013683c0747f5510cddf26013f5ea4cd068efd7591b0a6e809038395d57842f163489884046bcc54ac7ffb406fff91701c9e371920efe6396b710";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/eec4a58d-3546-4c40-bd82-b6533115b5ea/face73d99a1f01f655dfc3f9cfee2bf5/dotnet-sdk-7.0.118-linux-arm64.tar.gz";
        sha512  = "8e5358e3824ec141ee8406e0a67b8d1bf6965a4f9e7487bdee4ff02344078e95bffe4c46c0f1ae975b1caf7164387d35763f1b81abd2e66593b77cc0470cc957";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7ba2b1de-4494-4865-bd90-3931dd6ec41e/4897e62ba478d5f3b5c48ab0c98370b7/dotnet-sdk-7.0.118-osx-x64.tar.gz";
        sha512  = "48081b4b53f7dd79aa9e11e362ab53d50b7efdb48f18fa8f0828c5e179c79b36b192b9b514e9effb04688838bf87a4d4b3763539fac34dd2f2570e1b8882d7b9";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b3541939-7484-4cc4-b8c3-abc2bea28799/610db5c984192e3710151de48f918d1c/dotnet-sdk-7.0.118-osx-arm64.tar.gz";
        sha512  = "25b2fd5a26b870f5b0f407acb3b0cdabe9287d2f7b7c3db81f85e34cecb7a3211a72ee54d0e0adafbbee151387e1bfe51e3681b6a0a347509bddd14b589ba117";
      };
    };
    inherit packages;
  };

  sdk_7_0 = sdk_7_0_4xx;
}
