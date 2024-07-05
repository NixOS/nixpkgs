{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v6.0 (active)

let
  packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.31"; sha256 = "16xd2i3rzvvkdqswmr4i132s7a71m0i2iml8zbxb81vj0qj99nmi"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.31"; sha256 = "0blf8hl2irl9r9x6f7cih87ps21rcs3b8r09z5wp7jcb5j1cv8fg"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.31"; sha256 = "13765sv4fi9sr0cq4d1lif461xmaxdm4rlnk9gg01g1wgfjaci9v"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.31"; sha256 = "1nyk0bggmwggw06dm5py4qz2f8b4mzc1c0zvqb3zigsrn37mp44s"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.31"; sha256 = "050dzfy49c4jwcm8dfrz2lqbbyhmgnq485zdhpcnc3w08z0ppbs6"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.31"; sha256 = "13kww7x35926wik32z8cnvzhpqp3dwhazkzb569v87x8yww56n3k"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.31"; sha256 = "07hjgb341356qz440i7agz0zmy0267s1ab09n26nmmclmwi33b6c"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.31"; sha256 = "15zi7yfc862ckv67w69linqnnckb57v2c8xfkd8sc583b55wj65c"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.31"; sha256 = "0b7k2rhhffg36bsqwdbz4sqfn5frahclfhl4g67f8kdz3xjqnv6s"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "6.0.31"; sha256 = "1wablrn1g5z4b995zan397iayxilriapcycmd7fd2rlqamay639p"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.31"; sha256 = "0hki4z9x60vzcg53s8cxnig4g1xnpqcj629r2cg5q1xw0sknfp5d"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.31"; sha256 = "1yf6wkmf0dvifphgai72ik09mxvzqdmwg9bgw76d7lwrjq1i0ij8"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.31"; sha256 = "0w4sab66rjjyar9z139ls6rx29gvgj3rp3cbrsc8z00y9mw2sl22"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.31"; sha256 = "0g76dzpmpffgv2a10znz0fcqkbms2l3br49f45fa72l6ap4dsm0i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.31"; sha256 = "05s1c6bd4592xhy0y3w0cjckg11hb4pci729v59k3i3hl0hbad4s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.31"; sha256 = "10cjff8ddjykawlacjv5zqgdax8vc6g8kdqz9xyk557xi1p1bai9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.31"; sha256 = "1cqkvmasyh53nlj9vciyfpvv2mhv9jnvnfh5w5sm98cqc49dkmkm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.31"; sha256 = "10s0p30qzfn9zibp1ldnqar87hqs47ni3rwqpvwx4jn3589cl9sn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.31"; sha256 = "0k16h1fwnvhw1gcx8ib01bidhrls5m56fiy6wldk3ajgs5dif8i6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.31"; sha256 = "1rrgp98ssg6xvq4m12hk4wzdrcrc9ks1pbjdvacv7a68zhq9c2ds"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.31"; sha256 = "0d9lbwlq4xf31lfrkmyv4wsdz39fhha8ink02hkah2yawr4pfbza"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.31"; sha256 = "127jg9md1xriaj00bh0vqx426y0kiq5l2r9vkd78cihzyfv0asd2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.31"; sha256 = "0p9z0mx8fmj908nn4ckj78phdwjlwlkd3fy8g04nsgds54wzznnm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.31"; sha256 = "1wmlwzy9bc1fs38r0vpn3ragp8pkimcq6sicj978yhk7brn52z1p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.31"; sha256 = "0jr9llhmdjzv4z813m8g1carsj7fqbsjc2r2315qkicvisjf82yg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.31"; sha256 = "13wfhnjqvk6h9d6s8jvm81fscsc6am3vixpqags8fc38449852v7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.31"; sha256 = "0pw2n3j6vbmbghda1cvkhi3c39a49xk0a4w059mfya017adl6kac"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.31"; sha256 = "1cl561dgdk4mj48zw5xwg7a0cafkx8j2wjd4nlv0x3di300k75k5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.31"; sha256 = "14pbbp2mmnrx42a3zzwavbfshpp4hp04lmpayw3d2fm9nbrzjzlf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.31"; sha256 = "105f5iq1r1j7fb1nkvls7hdm864pk7l04w0drqj1msml7ja4fdw5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.31"; sha256 = "0ln0hj3xgr4xlghfna43rr68gclhp6dnqnhn4sfwh82z9i2593nr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.31"; sha256 = "0cwzp2ym7d6kyp3sf21v7ixfdjcprpw27qv6x1j7h7bp9jfk8cj2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.31"; sha256 = "1dcj6cclv3j3xmhhvk46kak1afp04mamli0j0n9c4pf3ri4p02h0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.31"; sha256 = "1ld8jxpiapa3zmvikd0r200nx1cwlmm50rl4dyxm3m1xn6hvxkaa"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.31"; sha256 = "0mr4x1x42srl363f7v5zdn1l973rfw247vf20i5wrv5hv0qci2pa"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.31"; sha256 = "0i2q45z8qkp0pz44rcsljzxrk25xq62z7i4rnq16mcpiq4ycacd8"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.31"; sha256 = "16z8z85bn2zd5r4jjbz5f1sjadj8s3fv3l42xfqka9wj3362rrsr"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.31"; sha256 = "0svd4zv4ah95n5cw7z2p8ndfvvvk29qyyd1cpw2qkkghj21lqzk5"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.31"; sha256 = "0sr995kaxlnzzgdlgdfnw0zf6qi06f54xga6a80sr69qxacg1n7f"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.31"; sha256 = "0ds6i8lcswa8fgbljs1hx3fq0x1h8h9ahb190y751kx53gda4q7j"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.31"; sha256 = "0v3wc81wlsp97a0ab3kqbf2la8j5d66sdzhjs5fagcmlzhgjybvb"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.31"; sha256 = "06a8zdvyr004lhs0pdsin3v8ylmlyqapa5wvyh7q0l4ds9f13h9l"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.31"; sha256 = "0k1zsaaj5r91n9iqfdwww0s3kq5ak254brfyhq018jzfgsmwsv1r"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.31"; sha256 = "1smij7fblrcbdn6960snvb5yz0ylk31ixha26bx4pw1qzdq25dda"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.31"; sha256 = "17fb7lnzcna3vjmkkf64l6x67vsc9lkk318bydn0rd8xmsvcarlh"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.31"; sha256 = "0z94wlfc7y356m6xbh4yn4f7349dxv3340mmiz3k9m39mcibvh5c"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.31"; sha256 = "0d7fpy0ycqigdr79p4ii8hd2d0pgc70rmn67h6y3hvcqxn4569x8"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.31"; sha256 = "0vx2caca3rs34hhbci4m8sdrapbph1ry6mj5mjymzqgdvl21zgxl"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.31"; sha256 = "0hhflm634mqdr3q9qjc701yjfammc10hch334zs42758nzbpi4f7"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.31"; sha256 = "0l5861rmfqqsqr53d2jnal7nggc6mlvy7hj9ln4b5nbk8w2qmsfs"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.31"; sha256 = "12dj9crj57k905q2i0r6ragmf6n85q4p1ayf00vfjr5wqylfmm18"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.31"; sha256 = "0aslfapafa9mp3k09yjy6ay4lclb5kmkiic660xqjqw0gk851skb"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.31"; sha256 = "12w425dbggb34knqxqfqrp6hzyi2d427anmrjqmipsi8hnivnrpd"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.31"; sha256 = "0zqfg5g06aqyypk0ka21jzsrb1v38yrgqcsll3ps7xsjd3swx8pp"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.31"; sha256 = "07wpsqknjimf0k9gxz49n69jhybj6h1yap4lsyhaclw4nxmhi2vc"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.31"; sha256 = "0akikavmdma4p2fh96i91xfxk8a3dmcm6j0pc0az321fi22g9k1m"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.31"; sha256 = "11knfd86jpmpnhn2vkqn0rkl7yg8ndfva07j90lm27zznz0fzhbd"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.31"; sha256 = "0qg7qi7x98szsi1n0gmjv5nplpnkwhli3jrf64wc9jpf3mv2wd6n"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.31"; sha256 = "0rv4fwgqr26s1n1qqkzsp1ghn5m5zimllfh5ydn2rd4z9gvg0ivy"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.31"; sha256 = "1w71y8yffaljg96sy7lqfjpxk0mxbh5k1m9mik2nps1cs4f71l5g"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.31"; sha256 = "19xb50y6jcn9yj1yblyd5c7gdcj09xvz0lna329a3gm55144pfgq"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.31"; sha256 = "1qgfxnvlhbr1y9r89srljdmgnyvjqh8knyhcgpakh3g4bi6j61s3"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.31"; sha256 = "1141m8s0q7d73hicr9fgrgc4623rvz6a8mcf70zdq5hrf718nim5"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.31"; sha256 = "1691jld833fyjyy3ahw4hq6k7rlwx6nzz74qf97s5nadbzdqa6b7"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.31"; sha256 = "0b1i3mgnnp3h13p94n14xfvz28lsqmadqiyc5ib44yb28w72zwrm"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.31"; sha256 = "0clgs6fs1gz2rld92hcmf4dksw62xb948l1a8zrsdyir40j0l33s"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.31"; sha256 = "1p0cnnvb9i9x2yivvzj3lawy2fdrx2lw934q309anipfsxdzgx13"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.31"; sha256 = "1qy3bgvr9bqi35ncq6f11ihdrbv63vzhs72pl1s56f7wsqx7wpba"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.31"; sha256 = "06bjzlw0gskrgzrp344nq5qz95rkmqf56zcj1dip1107pzhiz4x7"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.31"; sha256 = "0d6cdb1nsiqidwy5sgwq5iznb75cqkjffvyqlw9r7i9knj24yp30"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.31"; sha256 = "0srvnrvgn48jjwmxrsqqafz9xvvgc3vc24yfibjcj0aa20mr0zjp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.31"; sha256 = "1dmadshsp686r44sm1l72jkjlym0hbvpycv1vvaivrgrkjsy22yv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.31"; sha256 = "0sah1gf2lccc93n3lmkgiahlz4jwr02cw20bvcwqyikpldy2awds"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.31"; sha256 = "1rinf7daaphinmjfcp1v28gm88wcpjvi59a3an76vvjjgpwcms23"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.31"; sha256 = "115c220p0mbk30biaw0sfqprnaghks7lcvvz6n5rsg0kn4fvy7qs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.31"; sha256 = "19a4ainxj8jxij7ckglbmlnvrjxp72xfgx0r6lbglzh9dhsakwm7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.31"; sha256 = "1y1sdabrcxswlwwlh5a493chxfsfpxrhvs2bkhqpw6bm712df6y4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.31"; sha256 = "06hcajknx5f3q4hl4950p3wpqylwkrbkady2qyrjil9d9i2nh7dr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.31"; sha256 = "1ybchvd2n4n57sn0ycd4rw5fhlhyc9w66anffdzmzxk0m2nj1ll4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.31"; sha256 = "1glgiqxkppk99h5q7hii1d0zx160qxmmna3qjfvk0yp62cx51nam"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.31"; sha256 = "07wdnlh41x3mblxi8wr5f6n0p9m7j76a6zda5snq25lfsvv75qr7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.31"; sha256 = "1q56hjpxpda23qn678cm11s0klf7259wbiw4js0yrjhzv0bwy2gf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.31"; sha256 = "17yzgzbadg8cxrfp9y9lil346jj6lk1ba96pmwcglprmqlf2747s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.31"; sha256 = "0j2bachvygz0cnyx1gdj64czsbxypzqhfm3x302jq1lq5mc7g94h"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.31"; sha256 = "0ypldja725nxa9h3ddn352lm2c6f07vs1485mqgh10ymnv6a4m65"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.31"; sha256 = "0my18xrinvnb66vm3ni1l6d18l381fd8rpxbjwmcsdznv8p8brg7"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.31"; sha256 = "1i2dyhifzawlsyygykl1rw9y0ybkn8jagklvnvk94mswh55df8k9"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.31"; sha256 = "0lr7qhhgdn20xap6jrsqm444vycmhyjway0g417wk2bp9v22wgf4"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.31"; sha256 = "0gscb2py8shgnsqk4rm1wr29b0g9bk2sxfwlva2vy82i3msx9zcm"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.31"; sha256 = "0rwg0dbd9bfyhs5n2bwr6pz1ygklhgsx1kfjinyl6prgpz8sghgb"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.31"; sha256 = "0wwkhq5lahhxz24ihh16ybzkajgzbncfl8mykndphlgq2y0qznay"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.31"; sha256 = "1hdz6j2i206gshm01zrijsgflgab937h8b5idxamdk4rnq9jzhg2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "6.0.31"; sha256 = "03q5qamv7yw6gc975i8fccms5d9wlq8zn7kzaimnzykh470adnz7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "6.0.31"; sha256 = "0zp62hsaf6nfg28wc6inraqwihbbcd2mcjjkl5g8dfhfd62wqryq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "6.0.31"; sha256 = "08dydwm0sq3hr6bak3p11c9i66jg1prcb75nvdrrx01jsv9gcmab"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "6.0.31"; sha256 = "16xjxz2y3s6lagfmyhzqwwddbs678nfrwz6ja56sxjkwicisq5qm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "6.0.31"; sha256 = "1kqqij06k5mcjphcnwikyjs02b2z0fdccsmbfa7diw5wmci4hr9n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "6.0.31"; sha256 = "0n7cddp4pq5dr7b38mar64cnb3apf6ib9p9wi506shisy8xh7fni"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "6.0.31"; sha256 = "02x1i47syzjm6j7wi1ldzgh4gpz866qcygr4z0b16qsl36qvzb55"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "6.0.31"; sha256 = "1xab7dmxks7kqqnraivgwg4qyvcp11zz7vj1qbryxj6qv7wkv0bg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "6.0.31"; sha256 = "0z0isj1zsknp81wdf09qf1f1p1vk3v92f9jbkzx9pnqvfdk3s4wb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "6.0.31"; sha256 = "02bi7qlc5d9iz82ld6z6ycczlj3s6c2fy7zi9f917z7v6b278n76"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.31"; sha256 = "1s889d0rri4xjjk1w47f04jnn1awyxgwa9j01dn0n98qhhl8h8jm"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.31"; sha256 = "0c9rx3g3j7jrcbly8482xvjhyf16vns95zs466yj17jm9wnq0gcb"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.31"; sha256 = "0szi3vbsj7gnbf3nq5q0xbf5p4581bglcz3mclwi8z0x2d607c23"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.31"; sha256 = "07nxbwjjdzxviyrr4f13bfrbs33kz3bf53lk470r5jchi7msv8l2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.31"; sha256 = "17zn4r2nqkqb4cl0mn1mkd0v11j1j4gwxzcas38ss0snidqddkqj"; })
  ];
in rec {
  release_6_0 = "6.0.31";

  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.31";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c8c7ccb6-b0f8-4448-a542-ed153838cac3/f104b5cc6c11109c0b48e2bb8f5b6cef/aspnetcore-runtime-6.0.31-linux-x64.tar.gz";
        sha512  = "ebb20a3461bf9d1e3a5c91761452f5ef2e60873826ad3158493768a18d207319bccc40d6c1a64fd61dd8c22bad51c26689394b0e6a40c4bfe4cca00ce4c00db1";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/088b0ba5-2eaa-4815-a5c2-3517b99d059c/f6d18014064903be5fa2f654f51f5ce0/aspnetcore-runtime-6.0.31-linux-arm64.tar.gz";
        sha512  = "5d395554520a62c81e01f045245749d771d728a353631879462ac499e78658377e475bca756668eeafdd65ac55ad55f244f778809c127a553c5c330b76ef9dd8";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9b9addf2-5f49-4d1d-8272-bc348c9d93e4/a4dc2cdc0dcf8215a1c7e436a4c854cc/aspnetcore-runtime-6.0.31-osx-x64.tar.gz";
        sha512  = "79ced204af5aff757fc7680298121269bdc770b62411750f913d3129dad79c8b2eabd54b2986073c219b3aaa4b49f7188ab7694b99361fb725bff8e32db07dc3";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/299cb3a7-badd-474f-9906-33d744bd77e7/cfb103fc34184ce82a012c5a1046292a/aspnetcore-runtime-6.0.31-osx-arm64.tar.gz";
        sha512  = "f19e54b4a4e42db7aae880b86a6dde57dc988aebf852008b70ae56f89ad130e0aba73903357f4e97ead10d013ae3fa7fd28d197ef88f0742391f601ff136951b";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.31";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d67d6174-70c0-4256-b4f3-1f06cb5e8499/4bb51048eee17bda6b0ab7887c227206/dotnet-runtime-6.0.31-linux-x64.tar.gz";
        sha512  = "8df8d8bfe24104f41cc9715bb04fdc1811426c4d16f29336607c68a30d245fb8f36577d639e7da4865204fa85280fb5cdcf47e93183afe6b9e946e0c53df32c8";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/34215580-c4c9-49ee-a9a1-e9cb1a25646b/9ac060d3bd7eaf550d11acd60bd2841a/dotnet-runtime-6.0.31-linux-arm64.tar.gz";
        sha512  = "022c7fc8878544f8abde8cf13ef661327238381c8f4731b4975be294616fda00a4b093036a896baef99eb58b881890d3fa951cc51b0212e766a8a7ce95d2c440";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e06ea94c-e84e-48c3-9bcb-5fc65db7701b/22612902257c79e6483990c0d9bf02b5/dotnet-runtime-6.0.31-osx-x64.tar.gz";
        sha512  = "fb6ae3a5f5f31078cbc98d06101ed53b6a23e9a5582c3d660850e7315fe21d776ad2c3ec716ce27cc0ac87c37d99c6dd9bc864d9410917aa4c73cd885010980a";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d82928b9-3ce6-4060-bdd5-159afb165b37/002421f6104e66b92b7abb31abe7ffed/dotnet-runtime-6.0.31-osx-arm64.tar.gz";
        sha512  = "57d89d189fd7c33ae9627a06dd543d4783c1e04376173e4a2868a342ca864323e41d5a4050dd82fbd9d7947ca1ea12185e80294c70857b97e3d32eace15940cc";
      };
    };
  };

  sdk_6_0_4xx = buildNetSdk {
    version = "6.0.423";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/111a63f5-e1d4-4d07-b8b2-98642b5fcc59/389661b982fa5b83b09a1f50b9da247a/dotnet-sdk-6.0.423-linux-x64.tar.gz";
        sha512  = "4b4a0e66634211ae04fa030e18ae9e22640f5828307ba85c4bae596ab2d31260519197828dae3b2ec73d6772635e0b375536ea6591b03c67c2b7a5566f016952";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f60a9d6c-1df8-4b84-af48-1961ed476a38/32f60a0f291dce64fb33a502e69e78bf/dotnet-sdk-6.0.423-linux-arm64.tar.gz";
        sha512  = "42f5e89d6d9a9923bbc20398a6272290b5f693cc767aa540233630f849779daa8cc7d8ac87655f6b2c8e0250bf5be986a8e8ae502b6f33c0b3e474d041b77625";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8e5dec4f-d683-4ffa-9704-f4af023d5383/483bb54f830379d5eedd21c47ccaf47b/dotnet-sdk-6.0.423-osx-x64.tar.gz";
        sha512  = "31d8f5aa5b0fc5de1c6f809920cc8ffa0415059daa12ed21888795e600b528376d7b14da5b946ae5493af7214543e6494d9afc8ca017d05ee56dbfd10e2fade0";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c53f9a57-8f7c-4d78-a2a5-32ddcf142cbb/312e8c418f6dd2372dd0e9174b10e6dc/dotnet-sdk-6.0.423-osx-arm64.tar.gz";
        sha512  = "fb31894ae43764c518d7909859a2b598134bc03bbb7996ad0badc1088cfcf4d666f25746f77cfef1aa042c2f9fdb348e6975e1c4a98ff93c1b206a4a0429f995";
      };
    };
    inherit packages;
  };

  sdk_6_0_1xx = buildNetSdk {
    version = "6.0.131";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/439c6d52-892d-4aa6-a6c8-e2f9bcda7121/1fab8b4544b64a5c74fd0277d9115292/dotnet-sdk-6.0.131-linux-x64.tar.gz";
        sha512  = "3df39fbce2d549a258163588a7205bed73dd39a69c6ba7fee785bd8a663e679a4194cb7e20a2e0c289539e1e412ab3a7ac019cd92cac13d219dfb50cd25740a4";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9402bde0-16de-4696-973f-2a9667ce34a9/81b5e2ffa23e29e10a473cdff7dc7c7e/dotnet-sdk-6.0.131-linux-arm64.tar.gz";
        sha512  = "5815bc11dbab9c8be4c9b0d20903d3b6df2e825bbb2789f2d90d1b7d7fc3f4de28a450f5906d82675e8f67d34da8b28526bfbd5dfefa109bd895d2ac03f08cd3";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6667b054-8dd2-42bd-b769-521b5e3c95b7/f8a8a2c8c5f57f81e2b3b1581faaf84d/dotnet-sdk-6.0.131-osx-x64.tar.gz";
        sha512  = "eaf8323e2ebadbeb30bf610700b46814bb42efe17cbf7d0ee7322e7cf089a41cbf87e184226536ac580dd60f04009e3dda5878427df788727d065ae3e9f908ff";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/512b8abb-992c-4af5-b308-9733d072c2d1/ce40f01dea24d4fd4849bb952c9fdb32/dotnet-sdk-6.0.131-osx-arm64.tar.gz";
        sha512  = "ad4563ada153b3d9f11bec8514f97999b31772089150856e46278638caebcf84b51f1413e49cce2c1e4aff266b91a72c1685b6df6546b9a8a2a415e78046587c";
      };
    };
    inherit packages;
  };

  sdk_6_0 = sdk_6_0_4xx;
}
