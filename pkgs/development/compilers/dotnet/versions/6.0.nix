{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v6.0 (active)

let
  packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.32"; sha256 = "16dk5xnrqp04a359m8zhqvxd44ywkc4gg0cd6dmi85qxwfdq06cs"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.32"; sha256 = "0s4k7wmz11rx1257v1mr8n43shmij1dvh58xk890d0zbxqbv91vh"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.32"; sha256 = "00q75d3swd9lq5kqq61vrbhvlax2vicxn84sm0gsyli7092c6nn6"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.32"; sha256 = "09pfzr90cf29jdw5l9wzicmbbfjx37h78qv002q408n09d6wbmv0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.32"; sha256 = "07rb8djc0pkynfhibn8kv0kb1ip0ski5s6jjz34bs1jd3zp2yijf"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.32"; sha256 = "0paraxqg5dn4l3b0w1pn4g08fc7wz7iybjqvdkhpdz2cmkixw7xy"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.32"; sha256 = "0zznf4bsqc6gwh1s7vxs0wmspwb957jrksn4d113f8rvsklhy0il"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.32"; sha256 = "0qbgwdc3lqkiwqmn141pk08z8dnzfazpamqvcdjb2zq58kmqq9aa"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.32"; sha256 = "1mkaw0zpvam58pfb0zslygkrg5h3vcaxav35pcrssyjvmxr507l8"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "6.0.32"; sha256 = "0vcz9c4ffj39a3infwypqxn88mwagifzw2yxwzs2sm2zy8rakc19"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.32"; sha256 = "0mzcwms2nd2sw53vmmvcn33bpv32xgknarc7s6v1kkpf1b3i6r6n"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.32"; sha256 = "19inclzxlyjp3vaxs3ssgcrzld6j35isin8s41ysrnfplvyc1wgx"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.32"; sha256 = "1qmvx3iahrfckp526ix5qqcp863gw9gbasvjj7r7w9hwjknvg825"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.32"; sha256 = "0jv2w71brxynkxjr7076gdvp7jzfpfl1xlb2j2baqy98n9br659i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.32"; sha256 = "0zljqrg741v8mbfvig9hskddqyhbi3pydhgapfx63f06f54a8cy8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.32"; sha256 = "1y3a2s7mciz4hzv1ifmmlhjzl24hrndqncsnm6f33jzaxwwqgk5p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.32"; sha256 = "1as3xy9kyjfas3ahf6gpr5z3pfffgvan5xl0i9ryfzfvqfkaiswb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.32"; sha256 = "1kl8rvwsh8ppb08gglcjivjaackf23ac5024a73pba8hgn9cd86r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.32"; sha256 = "0bv9s4n9iagdd43p6qdahqawjnsci7g6rzz9c20jk0h02vhnl44w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.32"; sha256 = "1v1g6crlpqh18slqxvayay5y8rha46vq11n1yksqlr99vaa3c9ag"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.32"; sha256 = "0w8vcppl28fjc40wpr9lbv30ymj86ndm0jfbza531h3nnrk3ipmd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.32"; sha256 = "1bxqwj57z51hwaiv0xs243fkc6kz46yl1x0zrakmrbhazfa74ns9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.32"; sha256 = "1g88yykizsk3rqvqzgf3wix4wszbm8135mg1594rj78y5vipyy3q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.32"; sha256 = "0pyrjzwcjhkmi07dahz07njssz6r9sbk0f3852lfsxpnmy4zrn4i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.32"; sha256 = "0rfm7qiigb0lf8nkc98qbc703gnahzdcpv9gx24dz7nfcf6svfm9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.32"; sha256 = "03dxavb0rlds4b5dp2mw768a2b06cgilx1zqfgnjg677m30gwiwz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.32"; sha256 = "04c3wp868i0vhmzidby881al9943af8z41h74m1n7mss83gn4yzw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.32"; sha256 = "0hyd2yq5zb3i3dcnzxa335anxj93d5rzlzxls6sv4cm5cpmh35nb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.32"; sha256 = "1v0lwvz9x30n8ynw4h6ywmgb3hf1j9d5c7g7ygr6g5mqpxxmpx9w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.32"; sha256 = "00sb4zf8zdjyrpjv372bq287197k6nm73sa7s4l4hxx9dbnp79yn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.32"; sha256 = "1g5zijlx1wqnga99bqb1jf7fahf2b05m2cpvz6bbfi5viad59g2q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.32"; sha256 = "00fdzf0k0a4z7jdhyl7fskb5z3808cpncgkhqlfckicvd493369r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.32"; sha256 = "03qc1avm835qbccda9gg2m4sdjnl2g69riba62s79ljhq8jfzwj6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.32"; sha256 = "0a6lvdhyx57k7s5aqiffpg4pvbyc1y4alb269z5chs48d3vrd9y1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.32"; sha256 = "015xski1vvhrlhhhd1p4pdc901q7nncylax6lqh4hi8fp4q4bix2"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.32"; sha256 = "0dh68sbhfi7cnx1p0i4aa35h1jc8ya6dgr1v73s9qg1ii6jzd4mj"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.32"; sha256 = "1q44yridrcnv9dvcwszgbvpp7hmcvij2y8b3mk75s94ylvmc14rl"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.32"; sha256 = "1qrvlmjvgqlfpa8cwk6sbkpd44fzh2ixlsxms3nhkd61967azrfp"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.32"; sha256 = "1hk98yqmlqh73qrcw1wa9kanh2srawlrxcwgfxb80f15g77vixj4"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.32"; sha256 = "0g683f7g8mx9id79y11mm9vi477h6x2ybaqz7yzk9q2lx2apsmyx"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.32"; sha256 = "1znjli22nizx2rcyp1wjgv5sdm381079hdb764gvbwn8b5l89k02"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.32"; sha256 = "057r7w6dxjybgdq6r8606rxmmh83qrfyfc2y4fi3a0n2nzf2kkqz"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.32"; sha256 = "0pbhnsyq2rw8l41x500h3q2awrj0rlcr96xkjqvb9nclrnbfdyx6"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.32"; sha256 = "1yvgrsrl86j0f5ndwrg8c1zjkirbny0rfsqnln563rvpi3hd285g"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.32"; sha256 = "0kw8gmrhi59rfg9386ik264yqv2vmwnh9gn9bxd5c78zsjc4lri5"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.32"; sha256 = "0p85xq3l8wk9rid0a0n0viz0fj52cf2822kbym931qgacbw2cgpb"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.32"; sha256 = "0g8xxwfg2nfqqhssqhf2x7364zvigngy4ncrgm9x5mv82f6y2l4b"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.32"; sha256 = "0pdln2pwm171b9qhmagi4pp7b44xzsdsx48bb8mnzkbb9j7l557k"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.32"; sha256 = "13sl3g6dmibadr2znns68cg3n4gwhsqnl9fklch094pwzk36hd66"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.32"; sha256 = "1y0kk6lcx6z44r6483akg3bj98hnaqh869gwcqqv0kf9nj3lbvgw"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.32"; sha256 = "0b4fqvdh04yl1942aq1s4kq7m38hsvpg7kim83xkn17scwzdwjwy"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.32"; sha256 = "05r7rznkpfd7qgd0carb965q8hmnv5i9hs83fa9pmkgmzmykwjn1"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.32"; sha256 = "0ilzphin2fdiaszb09skw9a9nzqkpb2dmphrcqz8jayc7d1lyg6y"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.32"; sha256 = "0z6k4zci6aafrpjv0kk96civz2ymxgxghh2v42idpbksaa5fgh1x"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.32"; sha256 = "0z435p6ym9is98vw00n3x919nb4ssp8h8kvx56phrwb34xp624d0"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.32"; sha256 = "16zq5xhhapbazkgpjsd6fhd2jj0b839ljgcinrj902a6r3qfmsf3"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.32"; sha256 = "0g9dfgw8cdx0kal15i5znfqj0d8h60xczk7isjxs643msair0xj0"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.32"; sha256 = "0b8lfp8kvnfmb673ba77kgrj8sxcycy46308fjhgrjlhp3fhydvs"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.32"; sha256 = "16anbmqrbm5xgdxw1rs090kicjf1d8a6lvd03ygl2kchqs9mabf8"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.32"; sha256 = "09q15492pgylpmzkw1cr2dbf5f3l9ak9a384m0pkidcv25hirm04"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.32"; sha256 = "0swj701rik80sgldqlzirzkx0r53zwnp9lqhqgb68d2sm07y1d7v"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.32"; sha256 = "18akyc7h2jzn2dr1rr5n0a3j6d6bs777rs9zl5awa0igxx6x9azl"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.32"; sha256 = "0mcb19n1gp8zx7wlkg6pmf3dxbd999vjxx5kan933320d5kwx298"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.32"; sha256 = "11l3ass11qjq97xvydmsm2s4ycfbapccmzzi32ai7cywikswgqjj"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.32"; sha256 = "06rc3xx1ka3p73iw41zgp6c2sb0k7rhgj6znklk5cghkmf45z6dp"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.32"; sha256 = "0sfd54gi4fxzlxnigmsvl33s1z8ba2y6gv2daag6q8x2rwkgvvhj"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.32"; sha256 = "0kxy4yslrslg0qql9c00lqwf8rv383yc01v10mmi0sp3rva3sd74"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.32"; sha256 = "00jj4dah0578162y4n6vcjbp9k9cknckkk2kgvd0g9xnnyby57yq"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.32"; sha256 = "0my97vzpc3n2sfgksq97lj8jz40hx91sf2mawjmy3kac3zm0d33k"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.32"; sha256 = "1gm1ccl56dvllpjqklnfs4g283knfw5521db37rg3ihj5c8pfqd7"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.32"; sha256 = "1g0g4dhypkmns4i6a6n615gaq3203szl1gcbhlay25ghr5x3vb8p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.32"; sha256 = "0mn1qvf7ah4acdzq09b0r7hdi3lvdqdvdkb7yk4d8igc8ad33v72"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.32"; sha256 = "1cl915vac9vcbib916qj3adlczjhkqhfjkmdjrg39wgwi2rn9a4z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.32"; sha256 = "0r3qyf5hmzp0srq64ggcy0asb14v1abr68rgraml2mfsl5yf491h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.32"; sha256 = "1da9kpqjvlny88189j03r49gk5mbffy17501sn3i658pwcc0bhq3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.32"; sha256 = "0s1kmdlxmsv9fkv7i3c1w4cy4swwxv7dsbmjw8vqxbjwjd8x2v8n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.32"; sha256 = "12hllbgiha7pksiif73anhfxsq4zi6qm9dwprs6pgw6ifb52fk6d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.32"; sha256 = "1kpy06afqhjhn1zjm48sdlhdwzv8dddiwy6x7i0l9c1zinpz8fx1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.32"; sha256 = "0z4rsxczlh8vn9qr7n3cqkr2nmcxpx2d1x7xbz4mymqwa658azcz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.32"; sha256 = "0a2a848jpnzmcr8l3118a910l2d5bivf9v7cpwqp4d6fpdph5p8f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.32"; sha256 = "1i2x31nbc080inwl8ydd1jf5p9ixdkcz1dz6bgxy0jrfhw10xr03"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.32"; sha256 = "0kk14f26gx90fyacanbjhiv2d28gxap0dbps0zalga07zkaj53qy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.32"; sha256 = "0c81xrn5qzqw4wfi0vrqmj61mzcqiv0qvh51gk858v81j7ixn59y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.32"; sha256 = "0m91kwrqx8j9n442g31ixwww160wxwmd5mbkp6lcpw8p4d7dwjlc"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.32"; sha256 = "1c5yd6waaxhj4klrc095ssj2cf948q1va6nj0jg2vkm38kjlayhm"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.32"; sha256 = "1r3hqswn5nc0l91lwhvjcnqrsr0yjnnlz35s5bpymh4hxd4cvg2w"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.32"; sha256 = "09smvx968m420hrm6hlwaaq13b19xf2pwaghvq8mripxpvzbhrwk"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.32"; sha256 = "07pgqfw4jjq0yjvx7r6k3cny1bdp8kqrs07p81s10q6kxrbdj7j1"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.32"; sha256 = "1hgs8s3dam1hgmxavga3j01556qi3iyww8p4s24fwnmgbp5iqv2f"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.32"; sha256 = "1ydply51jqklzimdfarkbs1xp4nhxn08zxqq2v966cqsms0b6l6j"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.32"; sha256 = "1gfi2rj4fcjcszpl1xhn3h7dy3w99qmpkrlzfrq110ld1fv6kj50"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.32"; sha256 = "0l5zkwwjf05zn16zfh3mai524lb4n42v7v0jd0aphzzy5q90wkzd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "6.0.32"; sha256 = "113sr1iwwf3z88sd4s2qp3n3p33xsjp0cyv45czffqbn081a4s8f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "6.0.32"; sha256 = "1a6ma8q2ckph0azqbv3kbyvnp5zhmkz1ckqc6fwqdmlhb7dmmrhq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "6.0.32"; sha256 = "04yh4fqmpmhcrk0p3rbdj7ywkxxl7l959zw8bcy36dqjixpmjasr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "6.0.32"; sha256 = "15qsjizbjilz6mpxxqcvn8nzlxwviv6ipyzmidd34ssjlzdagglz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "6.0.32"; sha256 = "06ip5fjhwvajz2sq7hgw9d4000mk5nnm6ad4fpn9r56r58phaqf9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "6.0.32"; sha256 = "1d4bnh0bjy1m024ncwvjj8964ia5rv0hi1nwnmr0zvxzd9a4l2cz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "6.0.32"; sha256 = "056b94p57r0y51fbgisryawn43b14p3zj19qs1h3cmm9rksmlf3v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "6.0.32"; sha256 = "1kf2madx3ygg0cczxf0hxxch0qyyr7lp75n6x646bvi28znlk4kc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "6.0.32"; sha256 = "1i2qb8kjmpp7ngabg1rf9w2n6n4gkdydb1zmn8d30wvbak698dwb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "6.0.32"; sha256 = "1s10rpx8d79r88lwl4vykba9gfba3c3nbxc28ilb0p64scl47ba0"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.32"; sha256 = "01s5d3wi5zcgkp5dk0qvjqp8hm0x4r4min5nr0hb20b05ix4fjy7"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.32"; sha256 = "0svywpr1j98igpg3fqmba485q0kn1jyh508yi5q8n6n8ccajl8rk"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.32"; sha256 = "1cpsp0npaz25dh46jdrv5dm2mf73dsp2ancg8v13f0rsxncg2ylb"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.32"; sha256 = "139rkh5fxjnharwp12irl227cydg0c7sv30anv59mni1r1np5gkq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.32"; sha256 = "0zkklh4awc5p2g39mk06sd71xjvjfr8c3qcgwiwfw1yka8hrnka9"; })
  ];
in rec {
  release_6_0 = "6.0.32";

  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.32";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/99f90118-96b4-4d06-97ad-d779715319f6/aecf393f9b9d362b66b93a47d90cfa8d/aspnetcore-runtime-6.0.32-linux-x64.tar.gz";
        sha512  = "1849c0073f12477b94357a1afb1cbd4ad67764263528b66037c19d554df41e681e4b41c0804b106319fe661d0bc3bae9e29e4913c0d0df33861cf6f32ebaac96";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7b3ead1a-441d-42b9-ac91-1253ed8aee48/044d517eaff9f65e18e3e27f4d825d34/aspnetcore-runtime-6.0.32-linux-arm64.tar.gz";
        sha512  = "7b420354821f30809a6e8278f6e9c0654599d3e3b578b777da0f8e387612c20f28ddc49d5baac09627857297648a53ca847bc1237bc30275db5b661253f67523";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ff01df65-0536-46ad-bd67-95b72251e2cc/a9efc5c00994076c2635d70cac4f94bc/aspnetcore-runtime-6.0.32-osx-x64.tar.gz";
        sha512  = "7a91b051b6a48fff6838dc7565ccab11bb16ed0cddb1ce8bdb870d7b1a8978e544047541c2ff3b5b08272768e4dc8edd193cfb2acbd3a6e8cfd5b441dee24b47";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/747ff7b4-44cb-4f11-a052-00484643c9ca/60175b793e5b9b472fb53960ee3aabe3/aspnetcore-runtime-6.0.32-osx-arm64.tar.gz";
        sha512  = "63de1906b3217c8e42dc6da3c5d1dd0f02ec7c8c1f988e2b5df1ca4e2e9220d6ff306e5a1d8f2af1bbc7eecd00790799bf847097e9054f96cd460cb22d3e5ce0";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.32";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/37d9269f-d651-4248-beae-ccfbf4dc34fc/17809ba306015df6406cf4338b5cc576/dotnet-runtime-6.0.32-linux-x64.tar.gz";
        sha512  = "9babfe66f4a4261dd454f3220899af0a19532ab93575b581cec838f1c5f130d98b6fb1aaae5ee8e5b2e70deb55b619a0d55347f014ace72cb84b78d61faf0a59";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ae57a4e9-a6d3-4532-9061-72cfcbb90e70/89016f6466f00a8e707cd2f12fafe9e4/dotnet-runtime-6.0.32-linux-arm64.tar.gz";
        sha512  = "dd9807d0e8872956602241bdc06e33cc6d7cb5519bf7d7864e1671c8608adab28b539ab910778a5f2543e8cd06c9db64f8def044180f29167ac82bc36ee258e5";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7ff71c2f-9fc9-402a-b88b-e85510530744/4fe521036c2d271ed8247fd5b761af1d/dotnet-runtime-6.0.32-osx-x64.tar.gz";
        sha512  = "d9e29d9b5fefd1b431135c6cf504dc16400920eaa1d7b67ec5b24d1ab672a9d573a6c55750abb116facd2b228ed07a73951b7feee1982d5b24ba3cd025b4e6d5";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/aea2980c-1104-4e20-b608-ff52a1295165/19c1f907bab296a31a1c084776bad885/dotnet-runtime-6.0.32-osx-arm64.tar.gz";
        sha512  = "cf9ec72bfb89124d12a359725689b5d4539ff6a8235fafada93d71b7e1c9d836592e6edecb2e1242a23298b0489050068322d2b9356b5d2e59f7dc519f2c5cfe";
      };
    };
  };

  sdk_6_0_4xx = buildNetSdk {
    version = "6.0.424";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e94bb674-1fb1-4966-b2f0-bc9055ea33fc/428b37dee8ffb641fd1e45b401b2994c/dotnet-sdk-6.0.424-linux-x64.tar.gz";
        sha512  = "e9823aa2ad261199f8289fde8721931c1e4d47357b4973b8c7d34c12abd440bb932064ac151b0e0d7b3d5b72a5dfe3f20d5dafa19e6f56f1a61ad54b7de5e584";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5f4b8e71-b03a-45cb-9a81-3cfcb51ef346/eb9509f0a061be1106689c1fbf5d5169/dotnet-sdk-6.0.424-linux-arm64.tar.gz";
        sha512  = "6a24dcad251016aa82ea11d3c665b250d5f86e7f8a82a6ec0f01d250e9cd671fd0746812757c023f28d4929248d326b2a5dc13ede8d5b5486671ea1452954aed";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/28142fce-3788-45fb-a84a-1b00493f02b2/bc8df50296819166baa09ad3d372dca2/dotnet-sdk-6.0.424-osx-x64.tar.gz";
        sha512  = "611a226f16d2dc6c5cfdac1911f116d159d65e1e0d4189afd8db8d88faecd92e32244e96c8d3cfa7d094a6d8ba086323b8d1d038bc0efffcd14795d197cf91a1";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9692d45e-74d3-49a6-b076-7f1248e92c92/62628ca1d882a0266afb8413a7fbf3ca/dotnet-sdk-6.0.424-osx-arm64.tar.gz";
        sha512  = "8de0b5aa92445a366807e3ba87d7b9de3b7dc035d96f7070f03197a6e6b78881d1dc279a619914140cd9025aa9084b35526d6db2c2db396cc07ebc398cbc6e71";
      };
    };
    inherit packages;
  };

  sdk_6_0_1xx = buildNetSdk {
    version = "6.0.132";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9f73ff6b-6d2a-4089-bd97-ffac5a817931/2991e59497eb076bed968bb53fc7aa84/dotnet-sdk-6.0.132-linux-x64.tar.gz";
        sha512  = "71e23cb50ee342d23797f0b9d8ad524b42b3be664b20730da7ebb7cb85c0ec5c69efefa3a68907190328a693f6e21bddd7b9e7ca3da2f48434be1a736b3f7ccb";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ab80d02c-8522-44b3-a6d1-7a4717305656/8ca7718b9d10dd08aad2ccb91d885074/dotnet-sdk-6.0.132-linux-arm64.tar.gz";
        sha512  = "574e63f1de4620f7f62421acf6c0f1971089b10b08e81125582d81fb23c0fca5c7703b79c0d7627ab743ed8ceb5d2948fdb606a9e8c6cf7628fa27d510d4719d";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/45415455-e8cf-42a7-a827-96d189fbc330/36452e5dceca0b0bba3b70a024ee9c15/dotnet-sdk-6.0.132-osx-x64.tar.gz";
        sha512  = "479a45792663144f386ac9ce7f387e2c6d04024dd85de07a83956b4aeff7e91e062937e6e5c341fbc447566284145a491a2faaf6af929cf1940c09ef4966f7bf";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6fc7e679-93e6-451d-ad5c-0ff6ebdc92a7/55df25bc67b5032a83256b1d6a276730/dotnet-sdk-6.0.132-osx-arm64.tar.gz";
        sha512  = "076f890802a0446b43a6aecad0efad939f100e70ed7b5f4ceeab87b0781598b23d647bd77773ce8d895a1573fe68e05cffbcc0d5368cdf954b0471abcdd2780e";
      };
    };
    inherit packages;
  };

  sdk_6_0 = sdk_6_0_4xx;
}
