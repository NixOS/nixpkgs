{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v8.0 (active)

let
  packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "8.0.7"; sha256 = "1wp5yrhqm1aqyl0z7xgg19m7yp99m6fc4jc1xm3yr693a954g1zp"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "8.0.7"; sha256 = "07vb5aljh5xzrzdxwnrxx09bzxrd3acvqj3zzynaknn2fdrlf832"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "8.0.7"; sha256 = "0rhzr1ni73g1gabcxiab29y28jl2r3a17a0z8g0nldwpd8xa2g4j"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "8.0.7"; sha256 = "1nhijfs6l9fhq8zakfz06ifd2bnr5975i3zpalgd7qkkyhjjmbcn"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "8.0.7"; sha256 = "0llrps0ikh8z9nkpn1sgx3xad7x0akn439gd0k6b84v3n3gmpamk"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "8.0.7"; sha256 = "09l49k05zy2km18a4zh2y6yxc5hjamm7s0daw6k3g4ampj4f2rad"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "8.0.7"; sha256 = "1fhqm4xl51mk2ig0rxwl7rxv56dqrs0xlz5q444m5ifin3j68240"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "8.0.7"; sha256 = "00b2d5l1s52prmdf4hfxms39qcyz1jg65fgxrhmbvzb1z5zvl321"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "8.0.7"; sha256 = "0wjqwp2ybxqfgz7wni6v31kgv3ann4il1cqmq01sfwfmw5xxvpvg"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "8.0.7"; sha256 = "1aws0azwwicdal4mdnnl0bs68dnfycqhz32j5fsnz2niz4m1nfg2"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "8.0.7"; sha256 = "16gky3jmq218v5mnhdyr0ncc0assy48vhqsh7q30n4ii0c4dn07l"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "8.0.7"; sha256 = "158csq8wz40b23pcihj2acfc02d9g2yg8hbnzy452xkwfm4nkh6c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "8.0.7"; sha256 = "12ym5pykygfmw7nzfa4gm4f7xm3mdp63f914zms0zk6gg7y7jkfm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "8.0.7"; sha256 = "1vwy9mcfpvzy4l4fw2i57mn9fqqdnrqcgvcypwxrkr4kdzcg1x3x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "8.0.7"; sha256 = "0lk77qzgvchdcbqipldqpyba0rzwcc4qyknxn5vkiyia39aikl1k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "8.0.7"; sha256 = "1klvxxpdajnb7x7w9yjiwc6x1s9shkb2acwggs8z276q73hhq0v6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "8.0.7"; sha256 = "0vc5mr9jmbdpg2hkjfb3mzwmfh7pn8lin3mp53j7w3nq3s2wybqy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "8.0.7"; sha256 = "0cimx6xdv31pp0l2gklh2cwvb2ki5rp6l0pc8smg04xfsm14hllf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "8.0.7"; sha256 = "1f1ajjrdznd8m2im9dw816p7yyz8qmkag4bf09g5bjywp6116xl7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "8.0.7"; sha256 = "02jgc289as6d2dc8y8jz6zl2vxjn9w8w9s9rg4kxd72yxryvq0s2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "8.0.7"; sha256 = "1ng78mgh95kjksg65kwgg6ga3346vc3dw6yv3gb5icvq4h058n26"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "8.0.7"; sha256 = "1wpi3hhca8rilgcvwk05hb81mcs0fmrbzimv9wj42km178gwdf6p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "8.0.7"; sha256 = "1hv7gkgr1r1vb1qqm85160rvq73pn5jpbfg1pf0pnzhr58cw21vi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "8.0.7"; sha256 = "01af32zccgiim7dhsg3r7zagn0d5vmr0fxa6i35ir1l9h7hvxmyq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "8.0.7"; sha256 = "1qbd34x0j8h5qp51nq8i3lbxdxang6yv983n7cijhpk50g5qdk9a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "8.0.7"; sha256 = "06lvfia3jlafkglnq9jkzjq5w5a1am5r4jiy4kv2yfarj83a8xvk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "8.0.7"; sha256 = "11j7hppcjf5lvrs25pgn2xvl4gjxaig0gx073np6vpjfdx6izpj8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "8.0.7"; sha256 = "1vcbjk0xvxkcvlqv1d8njr4h3m9vvxz697skxsg4r01gwz0v5jsz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "8.0.7"; sha256 = "0mskkrv05ajzpkkn1qj1378flzp8lvqyvh80hipks2j55pa1jrsg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "8.0.7"; sha256 = "0z32qaz485l2ksxnqxl7jrqlqhrbwz1kfp3f4qzhhfcav68ylkcz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; sha256 = "05ykcrf3y2hh7vykjwk1yrdarzzff8hgg6swa8hja67yzf3sj17s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "8.0.7"; sha256 = "167a5rmxgpqfzvgn8sfsxlyinnrcgjln2hcnq3q77vv2l1zrq6v6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; sha256 = "0m95s6gz51pnf159a1i8arxlkdpaqdcbvj86m7m7340lny0vza38"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; sha256 = "05ypj80bfrq9i6l2y9nkqqrgvs26z9jg7h2lc3gaf7cb02vacv4q"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; sha256 = "18i0sb869apkjlvdk8xd7y0j203rr60wfm8n7y9ifaqj5y4m74qk"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.7"; sha256 = "1zys8l52j0kqgplpya9a630hnp9290pcwgg5ld41dhl2bziyg4z6"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; sha256 = "07vgsv93n420h4c27bqss979vh6pg11cpcsz9lf7z6qnh56r29r5"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; sha256 = "07zwcakh3flhyqfk1akl9qv0h3lsw2nmr1c1vlc025cc7yaa54sq"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; sha256 = "0adjssv5g7lk7i1cf46ma1wk22b3nk20i8aim93i9k0rn6mv21a8"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.7"; sha256 = "0xc6ghfjfgxdnmg94j89rqfnwahnq1vdq835wn7pkss2ifbf1vkr"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; sha256 = "0qmzqxs0ishi7byqdz96mbcprad6ghk4z72vp0sk2z5wpkiykyq0"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; sha256 = "0k1xb2a6f2nhds3fravnkh7kwyqrlgrip68bsh5ziy7c6975nbam"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; sha256 = "09zbg9yfg1pad3cz78sca2n29qdzdfjd7q5mhplcyipcmg43sinv"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.7"; sha256 = "152j6zxz19m0dc09rf4p61aiipdihzwpm66s5fzgjf2a4xzjq6gy"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; sha256 = "0rif771aj7j4mfsgs7h846znzaw9b3gyzxym8d6jnak431cv1hwy"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; sha256 = "09692akh798nrcp9lw8k0i7xmlnbjbwx4p5wmjd8kkhm2wax4k2c"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; sha256 = "14chclwxhvam94211aa3pnpay5sfmddjxnaiqgjcqnmwfgkgm148"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.7"; sha256 = "1wrdx8jigx6jkwgr63v2bwym5pf3lbr108xvsbdqq2fwszdd5f8w"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; sha256 = "14n7xqn9pi96v6p7n8yg1dddhanhzfm8b1n9wmmrmxmxi3s8m202"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; sha256 = "1lxfxi8bjvw5pd8j4xy7g79kv41hbylnj3x8a2kf4zsqsdis0hzx"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; sha256 = "0623bvv10splx5v0jn1i23w6ciyrs2ldp6k2rbsvzgxyyy4skflb"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.7"; sha256 = "1dqrjxz1zwfvczxjqzpgbcsiw9s17d4fhkki7yyw9q9q4g8nkcsy"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; sha256 = "0ryk72g8bym8pcf8w0zcpwckgr1qr0civxbhr0ggvg5b3mkpm339"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; sha256 = "1n1fc515kdlj5ahkl9n32dynjcabz726rbvpjyxaaq7l7yfhvmiw"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; sha256 = "0n0gzha5padp2276sqwy7xm1an46qz1spvs5rss3fs5z1mxmahmh"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.7"; sha256 = "0f43qv3ixmndgwhhinz45hhy7wjbqwwraivxs6xwimf0qdnis755"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; sha256 = "0wqhzd5v3lr6mdqmpf9bv51xi3i7zpdr2c867rlx1v3xnc3kpqrw"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; sha256 = "062nv47s556qlh9q66qaad4azxns9xr0dk38p32w7p2n3529yqij"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; sha256 = "19mj7cp4gfi5dz2hb0jj7hv7csvq2jscvp729b0pfa8gm0pinyf6"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.7"; sha256 = "0i09jm8lwh2ljdb4qvklr7641i4s73fsybff38qiydbjn9gs9fpi"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; sha256 = "0rf93y39mv3b9qjic435llyn7ag8ng0r6cw4j3i6ncj579l3yjh9"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; sha256 = "05njr3l3k8p9ydy16wnhvayp425llbfijm8zjny7irzcmyfh7x91"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; sha256 = "0xcrprczk5ajkm1mhgf0nl5v8hihl34dp8qbfg9bd0mnhqk2cdxl"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.7"; sha256 = "0q41f0zjldfpl7mq5q2wd4bks4k8k2xc5c6rbmfcw3xcr38zqvlc"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; sha256 = "0x90yf8v4qf558ynjxpvz0nf5n37k68nli35r3xxxgf8dc6c5xgj"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; sha256 = "0rfrykqig7h4ihhrdm9qjwz41b26cid6zl1vy920p4as6hd8l0l3"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; sha256 = "0ajf267742id2fxqjnzvb95l745g4q0x1l3cxqrxw35lr0l0hg4m"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "8.0.7"; sha256 = "0m2n1jhg6zf25hwfx55ifw7fm2sp7v253hbqw9pw5q282pqz5r82"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; sha256 = "0chpzvr9ccngnjj7m6iq5w9zza7vl01pm6xs7n6kg8vs7h8pjsfl"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; sha256 = "0ibdwfyz58523823kiwijw6zq0f9nf4jvxjz6i6h33p07yxkdvwz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "8.0.7"; sha256 = "14xzxclfm8qn82fp15kpzbccfjq815n4mm4268jq0p2m7r4x8cs7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "8.0.7"; sha256 = "1fwxwyjn3w45dnc2swlvqqrkiq7alxpqgd3vldx00fk5phdhgm3h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "8.0.7"; sha256 = "0pycd82v8kpbi9dbcc3p358m27xzpf97pkl3mpax8napksciwbqx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "8.0.7"; sha256 = "13s8rvbccnrpxv9il5bxymkm0drca4y9n2hvf4l5p3zrj6wx3p24"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "8.0.7"; sha256 = "166gh8afm3c15gs5nhnrggi1xdx72zh5v34kv3ssaqir9ixmhzmb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "8.0.7"; sha256 = "1x0zfr8hs7m9wxcmyzha9r78zk22adcc3ihklzyidddg0aja74d8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "8.0.7"; sha256 = "0krpmp2c6mnvd54668pm19zsa7rnx8qlwaxpc61h2zrij0ha51pw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "8.0.7"; sha256 = "0jy9k0zwp9pkc416fwrpvhn7v0ykg1fi19y227wjj9spyp4rh2kj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "8.0.7"; sha256 = "0yzjzhavq5nvm2wcnkdlh95bnqd3nx88hl77s4lk34ib76bnsx9w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "8.0.7"; sha256 = "12wn4rpr8mmck1g8dmg2b3jiz7girry7n79syn08s624kz3a3vvr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "8.0.7"; sha256 = "0z3kgbj1v6b972l3i9pgw3xh61nrh7k7lfxhh0hq19f6wk28lpir"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "8.0.7"; sha256 = "1fywnc00hp0lzggwkvqq9y4j5lzc0zskbavnmly6vsa3ygkapsh8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "8.0.7"; sha256 = "15ry3z0x4qcfq6zxm8yg3vpaq21xgmvy4dn7n0d1ljrha5q4zj2q"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; sha256 = "0bqlgkvy3p3rn1qj7wzzc37jfrwgp3vl52dm1rzalid66b67xj0q"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.7"; sha256 = "0573srfwydvnfswvdn0q8ccbz9ibkvdv21hg7r48v06j5020gfpr"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; sha256 = "16s22ngjq338c132yhndldjwqik51y52fafw9zzcd65qcp11s6kv"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; sha256 = "11n9fygm2hwznrimgw96lw43sp16w3qh2hq58sywdprinbii7gfa"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; sha256 = "18h5a00mlpfgbhgjnknhkyxy0pp4q836p7zal5m29h33q5gsi4hn"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.7"; sha256 = "1jzr1zdch2ddkskg1rnmfcqcajqrd41zjs08mp5x3ivmskr2xxwp"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; sha256 = "1azzc725wpw118fxl7k4q8090miaib3y1y1lcs3zsmw36vhdll6h"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; sha256 = "00ppkc0949lq39dhrq24gz4m7imi96f8py59saisqd54rr1cgk3q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "8.0.7"; sha256 = "10r0bvni4jh5a3wwxad5znqvqn2s4b11l8lydf3kqhg1r21s5fp7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "8.0.7"; sha256 = "04qj62yiz5maqq8r0w6nd02vp6a2s9zn9wd5ii964l4gh1gpzvfd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "8.0.7"; sha256 = "0pf0ap28ar30fj3bfznnmsbjfcb27l1jgzsizb3wbwq59gffkpvw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "8.0.7"; sha256 = "1rhs1klbpyzg4pdfgnj4jiqm8979d3qmpcj2gvflziz2va465wli"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "8.0.7"; sha256 = "13kndc5a7zcfsdl8x3mk3fmarrn1rvgzpp1j97y218j6nnrjlgm9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "8.0.7"; sha256 = "1q5v404fjs0zm3r2c6sk0523irl2zkpn4h19jc7b2bn44qfvfqq2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "8.0.7"; sha256 = "12dgkaxcsk7xihgc3jqpa9xaymnsnhbq31gv73apm80x268q4rn6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "8.0.7"; sha256 = "0y06yfr15sir7lra8igmhkdax76sy0hpr56dlg6yas74p0pnz6q2"; })
      (fetchNuGet { pname = "Microsoft.DotNet.ILCompiler"; version = "8.0.7"; sha256 = "14zkh7hgl0idpvfkl916hypspwsjp3gphjzdi38i8cpd83wwbarm"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.7"; sha256 = "1g7j5xx972716122msm0kj466pl3kzfq3h5gij5p4sm9llbijb2b"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.7"; sha256 = "02laryf8xrjklw0lg29bwhyky7q72wlx13ccvmsc93a0l939wvy6"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.7"; sha256 = "1myy71l948wzsiz3w7pfiycvx73y1vh0k48620xfpnrzb8lmfn17"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.7"; sha256 = "00wvs1nkmfk16cm3cam4hx5n8yryb8qm58b4cslg09jq8ikdyw0l"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.7"; sha256 = "08p0zbzxvfijbsv8zd7r44wdpnbh87rs4pk439gxkqlvm2y8y8px"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.7"; sha256 = "1q1cb66j5qh0dgmbx6rfi9prygr86dfms96r7jxipl5cfp0v3mrx"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.7"; sha256 = "1sqm3v60y96sg27gxvj9ihadwxlb4s397cm8a0wif7g6g5c0nacb"; })
      (fetchNuGet { pname = "Microsoft.NET.ILLink.Tasks"; version = "8.0.7"; sha256 = "1f6v9r0xf6aa690wy2ch2h6l5sl9vlcvbi1jkgz863l72kb5b6bz"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.7"; sha256 = "13y90l6kpc4a3x844iivsnprcabxk5adpvpsrrcgxm8kxcq3rwsd"; })
  ];
in rec {
  release_8_0 = "8.0.7";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.7";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/06cbb934-ef54-4627-8848-a24a879f2130/52d4247944cee754ec8f4fd617d502a6/aspnetcore-runtime-8.0.7-linux-x64.tar.gz";
        sha512  = "c7479dc008fce77c2bfcaa1ac1c9fe6f64ef7e59609fff6707da14975aade73e3cb22b97f2b3922a2642fa8d843a3caf714ab3a2b357abeda486b9d0f8bebb18";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/421d499f-85cb-43dd-97b2-8ebfd06dda8a/61b03be4662125e4af044c7881e66f0e/aspnetcore-runtime-8.0.7-linux-arm64.tar.gz";
        sha512  = "5f1d31b0efc793655abf4289f8f1c7e8cd1ffabfd65b385b49e3f5232277c62ccfbbdad2a51731a8a88594a06c2c9774e38865cb3f7e19c9925a12b25b40b485";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e2410d8b-380c-400f-ae85-c0451afc35e1/cf601795432ee94bf55f03f8fef08e6d/aspnetcore-runtime-8.0.7-osx-x64.tar.gz";
        sha512  = "867765250c5ab0431023d59b9fd04ac0ac868797e2ea1b4257e44d93033d653e48d8776bb7e7cbbdec094a5a60002d2833c5a58094fe54c2b6402b1ce2882c49";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f8909467-b187-4651-86ab-6edbbc21f6e8/f07e4a0141b3907f83079c0dd44188ca/aspnetcore-runtime-8.0.7-osx-arm64.tar.gz";
        sha512  = "f02e3b3a4ec366a2be7ef596f728914fb7c3810ed507ebcade27b09ff62e7cb84cd4b24c8438cada72b99e60fc7477d868a6cb57083a39387f7900874faa35f7";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.7";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/cf3418ca-0e14-4b76-b615-ac2f2497f8ec/2583028ea52460cb1534d929dc7970fe/dotnet-runtime-8.0.7-linux-x64.tar.gz";
        sha512  = "88e9ac34ad5ac76eec5499f2eb8d1aa35076518c842854ec1053953d34969c7bf1c5b2dbce245dbace3a18c3b8a4c79d2ef2d2ff105ce9d17cbbdbe813d8b16f";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/710337b9-9cb6-4bc8-8d13-daeab2578a08/b3ec8c17f85e340820a0ab36a3870168/dotnet-runtime-8.0.7-linux-arm64.tar.gz";
        sha512  = "99e6959a1156d5abc8f0c73b3d493fc1e10a42d48a573226ebcfbdf96bb6fb1c8701db5b3582a4303ce26a4f784e74eb402cb6e5e4bcdbb5dfab8fea221cfe02";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c0e3a3f4-d235-4531-a1f2-1ff969cac1ab/837430d708532d74b7296108a681b9bb/dotnet-runtime-8.0.7-osx-x64.tar.gz";
        sha512  = "09107de04c6748fb3d98d72296e3470a6d3551a66bfcc310d2be0f678dd1cb8cb13a886b1b7e1e3856e12c0766cd5007f9922625653a6e284f5ab8fc80ee04ad";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ccacebeb-3dda-4887-9a98-e2dc9a9d9dc2/0ecac27f49c0111f4877cac54ff873a0/dotnet-runtime-8.0.7-osx-arm64.tar.gz";
        sha512  = "8af655573350f6be0b47223ae7272ca8d49fb3c74f6fc167e7249267c1616842eea09709205a07acd3b86a5ac862026ed1269ece5e681c3fd50ada8351c5dfdc";
      };
    };
  };

  sdk_8_0_3xx = buildNetSdk {
    version = "8.0.303";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/60218cc4-13eb-41d5-aa0b-5fd5a3fb03b8/6c42bee7c3651b1317b709a27a741362/dotnet-sdk-8.0.303-linux-x64.tar.gz";
        sha512  = "814ff07ccdfc8160c4a24adfda6c815e7feace88c59722f827a5a27041719067538754911fc15cb46978e16566fe0938695891723d182055190e876131faedda";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4bfdbe1a-e1f9-4535-8da6-6e1e7ea0994c/b110641d008b36dded561ff2bdb0f793/dotnet-sdk-8.0.303-linux-arm64.tar.gz";
        sha512  = "09cb6b12770febe186e36971afdbcea6e8bf5fb34b7701cd8c416f597d3b7e930d05e51ccef1985e5598291540ef2d721187904587469300bb39772317e2be5c";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/295f5e51-4d26-4706-90c1-25b745cd2abf/ef976bfc166782e519036ee7670eac36/dotnet-sdk-8.0.303-osx-x64.tar.gz";
        sha512  = "5676b8c0497adcc9543b5f4dd57c54451ea66e79ce6f656647bff54619785a05f5c52cb22483bf14b1f3eb85cd3fb19c2ce4352e7b8482fbc1998a1e7043c377";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d81d84cf-4bb8-4371-a4d2-88699a38a83b/9bddfe1952bedc37e4130ff12abc698d/dotnet-sdk-8.0.303-osx-arm64.tar.gz";
        sha512  = "c1c2935ac0b6654805e8112ff88d31ca9aae7f345218c9a9d9e512c98d73e2bccdfdb006537832e4f20fd3a9ce4defaad537e5cb98deb538e95b54a2c76a9110";
      };
    };
    inherit packages;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.107";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7280c125-4555-41e5-8060-cd69e4e325a4/34e25b09d2c92b71215f8974a4eeded3/dotnet-sdk-8.0.107-linux-x64.tar.gz";
        sha512  = "10e0fbdc589e5e0de4fb0fe0e9c839bb2257c51948037a224d4358b8328b6791014ab4cb164beb617c83531a6ed774acb37b08e4a1b53f165e3eb853fd41a959";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8d60cad9-ce0f-43de-8dd3-fa3fd39fae11/ce3bd2ec1177f519b45fe30c6e9bb74a/dotnet-sdk-8.0.107-linux-arm64.tar.gz";
        sha512  = "ab487873827677f44efe4372e0c325a48f339008d00307876e1e56795bc006be1770e8b1f9581c7197ea1bf857eae525aca18934591f603363f8fe9e021e7b2a";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c26fc34d-c784-4c4a-a2b1-43bf3599d4e6/c3ebead0223edb028c7e53eecf37048e/dotnet-sdk-8.0.107-osx-x64.tar.gz";
        sha512  = "9bc62515220f924cadf02e5be880fa813b6d0b0cf8c2199a7e930e25e81576ff3e88894e5a0b691d8b0a1e32fe1ab4499ff47d80cd004f07af61d6d362efb654";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/2bb0f88b-19ab-48f3-b0ff-146629c3ead8/8e59918475c54fe4d881ce8f5bbde2bc/dotnet-sdk-8.0.107-osx-arm64.tar.gz";
        sha512  = "b293f8e3cad20278ee85e30b4b1baa615c30b0e7aba557b1d0248d9e5c4557e323b726afdde0386c0227d6cbc6f95c8ef5493e209cb5a42b64e8c7f6e495224e";
      };
    };
    inherit packages;
  };

  sdk_8_0 = sdk_8_0_3xx;
}
