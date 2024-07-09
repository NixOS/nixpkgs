{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v7.0 (eol)

let
  packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "7.0.20"; sha256 = "0ab1l6r77a11sk450jhhi9flvsn8gp4fz2il2a0vk1lw5rw23047"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "7.0.20"; sha256 = "050wdpwp7hjk5c9xyx0vj1cmslcdl9acldhxs6al3nx83vssa1kv"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "7.0.20"; sha256 = "0wi679cxlfx8s5nl3iqgma9nmxzbi73wamxshgpaaj2dg3z5xrqz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "7.0.20"; sha256 = "0bgi8rx7dam9727v936h5ap81fx4k9n708002raw9v69p8yva5v6"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "7.0.20"; sha256 = "0h6f18k05w66797yyj7yqbf6jv5k3c5r089mkw43y4gbqz27vbmy"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "7.0.20"; sha256 = "1xlqjar4j0g1a7wf8ixjpnn6i19zxr3c7pwr6jdn06yzbi20ri7q"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "7.0.20"; sha256 = "0l2md2g657arlf703vf9y8x1k0zx50zf4wy4f96m6qgs9jx8s6py"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "7.0.20"; sha256 = "1r2nxc0nm2n5dc7laf65yqbjv23g9fzwcvv8vhrnvir6j3lgxfcl"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "7.0.20"; sha256 = "1n0dz6k338wmadkgb7x0jywz2qxf3427wkjw8xn2zdz4m1fcj58c"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "7.0.20"; sha256 = "05srdy7bvgasr0yx1mxkilbkls14k0dmp4mzc7jiqv7xspc4jwwn"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "7.0.20"; sha256 = "00npza90sgnvls4k1k95mhgiw5fpxcrxf60fi17k871m6igdfh1q"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "7.0.20"; sha256 = "1q86xz3v8p24728bl7sw0flhzk042ygxa23k0qyhxdn0qwzzq6bw"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "7.0.20"; sha256 = "1jjb4jsnm0f1q0s8199nympm9vifaa129l0bj4j1z94i1g85nw1w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "7.0.20"; sha256 = "0cn8j76jbbp6vpf00kr1wwr4z1ij0sgdymawff32qvj44wfmhpnl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "7.0.20"; sha256 = "0cbk7shnry75p95zyg14pszf396pgpyjwzhraqbds5mmncqisvgz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "7.0.20"; sha256 = "02fz22di6ax1819spb4v22nb89glp3h08kk88am6rx3vgb440sbm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "7.0.20"; sha256 = "0wvg2rfp4v8cnqkfjv4ifj9q0bd3vljqnbnf719nf1h0ilmcxcjx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "7.0.20"; sha256 = "1mq59gpd6p46zl2nl5ijjncghx6fms9nig9zqhxazjd15bqy0l33"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "7.0.20"; sha256 = "01xpgbphknkjqgsbcngvckg3a8q0y74g409v7hmxsh7rjcradnqd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "7.0.20"; sha256 = "155z494bpri732h1yba6ggmalgwxw68qjpyrbzfj9mi4whwy6p47"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "7.0.20"; sha256 = "021mg80b9x25jpdm2rc6m91wib15bb5arkxjjfa0cp509i5hnshi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "7.0.20"; sha256 = "0jpxs82ndrbs3r28951v0p31ngfkhcs0k7plgywyvd1lpkvdm2nh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "7.0.20"; sha256 = "0bcnw653m7w7if6z84rf4k3mr7hdmvnlv4icflk0kc5jd98bkvhc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "7.0.20"; sha256 = "03107bdy4i9sckpwnk9s497sfq1prl4mccbc3mak43vbnfyqrsad"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "7.0.20"; sha256 = "1lhlaj2ra25jjr6f6rq5rw4wg981h9js7amld10ccyg2vfrswv9d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "7.0.20"; sha256 = "1w5r2nv27h3csd5qd3sx2zmf5drrp3ygb519m4hvn5lazyfah5p6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "7.0.20"; sha256 = "0r002hclq07y275qwj5pq0nxmb6k8h8yglcynpvw8m0pz8d9mr9g"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "7.0.20"; sha256 = "0msncsn0lz0dvc6clvc4blq8a1bv5qap7qx27fdibdx24i5lsjya"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "7.0.20"; sha256 = "13x37m9mdg8pvq1rzcrr4bp5yqaayz7173p39s623n8zjxrh60ww"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "7.0.20"; sha256 = "1cv1zmkiz114vk0b0spnnczagbcks5k1fb198lc88pi3c9dpfm0d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "7.0.20"; sha256 = "0wpf2p1476ns8xd5qvih5llswag133q4s6mj62yzbba890lg5y78"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; sha256 = "02iri99mhfq9awdymsqhg86pg6qfgfig2r2w96jm9lbx4gkg1rgm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "7.0.20"; sha256 = "0g24nr6v86nikikfvg2b3d8im9cp1hib3xiccklbhkpbym3y98dj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; sha256 = "1dldykby8yfvq7r7kmlg5wi6spy1ngsxbs18ng34lcqjfxjjdnpb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; sha256 = "07ip7aflkg89gsbfm1w7sgidn4lvc3csrirzkbdv2jhm876bxz2y"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; sha256 = "13pvjwqlacls6hz719lwc6rz0ghs29gxywisldwnwwbm9i6wdnga"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.20"; sha256 = "15qwwdf3c03gs916r3k49wwg411cmrf5xldydkxjjab8pavdlq0s"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; sha256 = "1mjwlxy5gy7k2iil1jcrssqspn3hrpm2dqwghzx9dr61wvpl6sq6"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; sha256 = "0dwpzaasn5044aqm2xix3czfgrwx0y0jwis6p0x8n8jdqyskpim2"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; sha256 = "0ai75b700v76rmqlblxpkwsd97jidfd5kn3jl0y52yq0ylvc4zyf"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.20"; sha256 = "1jkh7kjhaghslhlx6x7w03kdxi1xbrgxwdj9qav0ci7nvf5j00v6"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; sha256 = "0k5skgnss5hknr4r15gxph54zhk65cnglp117gih8qxyzn0245m7"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; sha256 = "1kllpbyldix05ab1pb775ykxwh9lrcji9vqbyp964b8m68r9yf1h"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; sha256 = "0a5gajmkchf2ad3zwmjaa6mw72snf6hrf3xz581mn8qnjjv68whj"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.20"; sha256 = "0xsyd8jvj39z99ga9x26g1fi4zi39pf3ym87fr9102bg5rllj8m6"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; sha256 = "18jp8cykpj40r61ji5fpvfj7yw6cw041l6r4q30am9sj80sgq73m"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; sha256 = "086cn7jilskr7q2hfy810f4hshzhm9r6kvd2kjzvjwf93s0qfgya"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; sha256 = "11y8c16m63kb1masa0x7ympwjg93ffyp4yfycd0fcf0zhzyw00bx"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.20"; sha256 = "175qh1czpm8vs0ifbg3iwgz2cn3v0rvd51g1k81k6j00z9gmhrsm"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; sha256 = "098177bqda2viwzcabsxrpj1p45jqi5fnyfg9xnnw198gh0iskvj"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; sha256 = "180bkmdr4h14a8l2gs9khm835037pw8aqgjz4snx6wxhq7jbdypr"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; sha256 = "0jdvi1pcb3fxqa01633asixs93rg1lfq98vnba018nbqdifqyvf1"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.20"; sha256 = "09can99m6psr9v93awwkahyxq899sg1l6p8gpp4qscqwpil22r4c"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; sha256 = "0idzsi16ny8bjhii6fwjwqn8wmy8x4q2y0zx4d1vmxfx51ym634f"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; sha256 = "1k5yigh196dn961bbvbyy8jfvw8ghmk4da313a304b4m9rf6q5c6"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; sha256 = "1rnpmqmgdw2y9snjj3kp2irg1aggkq2lccd7v4q53ghnl55jdil8"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.20"; sha256 = "0xibpawi6nahdbrdcb71panhx4w5zlmbfxspwmljn2a77sy9caw7"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; sha256 = "07qrpww6nd67xjj3jin97jwiymyxgpm9mdg4raxs9ss0pc05l5xv"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; sha256 = "0dskgn19yhsq28hvzqs422bq64y5gx5cx33m1m3zq8mfycvscnsv"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; sha256 = "0k70cb1lh6j9qg4pjy6r58z0n5xip3l6i6vkgrdx2rqqvpmq2ky8"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.20"; sha256 = "1qr458jrmsb9nijll88hp56msjmvnk20q73x7qypvqlydsn2ap3y"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; sha256 = "1503pddh5klr3z9kpmbxnr4w472v1w8ggh37iqi79z3b0x72zzi6"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; sha256 = "09ddji35a92iq9f4rm5xmz1vi3bki75xskq3iypjbc52ar7wkfl1"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; sha256 = "03338hfl2sb8ca9v3a42b4fgr7qyv3r2khc0ydhif45r0xjx6zrx"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.20"; sha256 = "0lnm29n2z4r7kjwyfa5gbl8qc5nbbc5qkl9kg8vj2xb9mlk5zsmz"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; sha256 = "15ah793265ikivb5iqblcl4x86g4bqgwmhdlhikgv6a18bq32sjz"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; sha256 = "1jnz72f7m292863wvpmm12gwdnqwbvm45br1958f0gkgp0zmhyjs"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; sha256 = "18k3qs54a4x342ypc0p54ch6xwx9wpfgb5f6iyw0i0f8jjxspbay"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "7.0.20"; sha256 = "0nyk8x3myh6b0jfka8mvxbhlzl38qiljky8acfkyvw4dzw0y63rb"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; sha256 = "0541ykf9hhc56jin59lg5iw96apcg740wg1hrj0m8dagjll2c599"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; sha256 = "09dlmiqcscdrvjrg9w5mjlz59ly0la4as4hkadz6j4mqvv2k7j6y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "7.0.20"; sha256 = "11bcpf986m4wzrln9v4frh63arrg9r3vmv2lq7x338xnrwxadz8q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "7.0.20"; sha256 = "0i07x8kwsifhzkbx1j8argx31g9dxppqwaysn21cd623d16r2g1i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "7.0.20"; sha256 = "0aq01ld9k4064bgki4q4g4fl08i82pnh5xgxaqk3k48nbsbrzvwc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "7.0.20"; sha256 = "18an54s6jldf330ckigig6s1xnadm7zygrlb35qrhawvygbqayal"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "7.0.20"; sha256 = "1fv6p9idx6g58y0khw7jl23lkwj01l8246mv045i9q6sp3fm9m2v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "7.0.20"; sha256 = "0qfv5w1s5pj3c46jx2g75parx12p40rywacvb7v0fbllj2nvm89r"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "7.0.20"; sha256 = "10d13b4vl5nhk3iqcpbhdhqgwmymzx875w4yq3pwjkcc2vyhg3j5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "7.0.20"; sha256 = "1rbl46pfwh1hkbf5djy1khqyiv2fivkgxs0gcnpx0kpx4lncf73a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "7.0.20"; sha256 = "03760jw9bbhcg5gmx5z5xjyccl0sv1lzznk3hx2ynwrwg6dhbkyi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "7.0.20"; sha256 = "1gw4wlraqbr5m5w62wyfx7gsvyj92a8h7i04n9jgc6sfs4yfrsz4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "7.0.20"; sha256 = "0fcph5pd0myyzzl3ihnvp6wii4vl09ayri5ba12xgixb3qidskgp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "7.0.20"; sha256 = "1zxpbwc52xsylc6kwk0sqf24cgyv9b2cz9l3icpl1hnkqims9xy4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "7.0.20"; sha256 = "1jhw9f2mzx8a1bqdiq7ylk8nccwcqa57sd31ykd7lzq1wbhy2r45"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; sha256 = "11l84kx7v6y10kzlsr74kwvvz44wzj476m5mkm2xv2b8pv1z0i7z"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.20"; sha256 = "11xxvyals3q16bzjd7a4gg0nzidsm822aa92yd752jzcxchdn6z0"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; sha256 = "0dg1m80mxvabdkqjgynnws6vlzj9469d5nrjnk5x2zqcsw9kjj08"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; sha256 = "0rdq3z66azlwsak8n8j9jz8pj0lwsvz9f7n6k7x6mlz20wcw4qs6"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; sha256 = "02ymh38rj3pwak3g9qhviv64kqpclcp40paijg7m184y5bli68b3"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.20"; sha256 = "0s9bca6p8j96as25r22vbcmyyhbavkczdk68ypd7qn4g1s44l34w"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; sha256 = "1mi25ilkzw9375lybrmi78g24xzmcz7mnqgjf8y9qvivwsf7ysgn"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; sha256 = "15jfwa5fva8qz6g2gnbxnppd9cfs7r8fspc9xb7n9zgxl7w5n6gd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "7.0.20"; sha256 = "1xvhyafgxaraf97s364a3jk5dad4hsssqqvzx4i8qwg36fdijcq2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "7.0.20"; sha256 = "1r27bm12x9gwzv0cid1fdzx9hv9bdy6p6a65lypjzvgwfdgnyksv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "7.0.20"; sha256 = "039l3qdsz3ima2jgvp8nqby68cr9mvj8q2xd0lmx37drxvck7bx4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "7.0.20"; sha256 = "05zybhb8dc22f934gj3f55xvsfvqizq0nf4d29ns3z9d370jklp3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "7.0.20"; sha256 = "01rrnbwjpy138pra53ypixk3cr528fazjsl3vsrvf6jnymgxlb4y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "7.0.20"; sha256 = "0g09yyi0a00q9xa51p1k9hvdj20jmy1ss2r2l28zk9s7lwyih7kl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "7.0.20"; sha256 = "09kb949p1qc6rz6mf736id8qfsj6dq8azbrpzx19xzpnylqjch47"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "7.0.20"; sha256 = "0l76v2w34igvh6i2hgvhfwmkcch1574ylwl1159649pg7c95kj7c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "7.0.20"; sha256 = "1jj2mzcn1dd66fic37wnyrvd07fplrsdj4azrvi0qz3qyykc8wmj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "7.0.20"; sha256 = "0q8i69qc58kyxzxfz0cqjlbjcz1n3p130nz2q852rvvcxa4644zc"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.20"; sha256 = "09xk16nb9wrsgjr531dhd7mvpqa7b50akmkqrlndyspma7cbvrzn"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.20"; sha256 = "0l82bqvqw5qqhkgrxfscc4dw197b5sh7ic63pymdhixvx0d3fi1h"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.20"; sha256 = "18sarln3kbkqc1ab9jnadcqqxs8iicf7jqldxzbjzhdpmf96vwna"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.20"; sha256 = "1vh3ymhv33qysc4vj4gb3g1rgajy4jr4kxfjcsq2myn96aan84i1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "7.0.20"; sha256 = "12w9hlq70ynkrgqbr555lnqmbf67iz3kaci2vi07zsn3mmak3z6j"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.20"; sha256 = "11c31fzq4qfxcsz3p6vzdfnaqs29saf1dnmzq7l90p6ylwsblc7f"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.20"; sha256 = "087q3p57snmvvzzqpxp3vwvi2q21kzlk8qh1w6axrcjdci31xmji"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.20"; sha256 = "1nc8m38jsqai934nn26f6dkl3c0r4sabssjiizcixdyypzlv3hcf"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.20"; sha256 = "0iyn0rkf9vf7vbd58xs24209557dzq1dppjb5d35g39z2kh06k1c"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.20"; sha256 = "1b0ys3g3bg9kxxvs1h1kj79b9n9nl2g6hjhmb3c2cpp4slzlsd3d"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.20"; sha256 = "14nq8b869k43chsn4ba3b3ww9w25fip39ik8rfxa1z8l5k4k6xb0"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.20"; sha256 = "1gajqvzf18p0jppvcwky0shkmw4nzwz8hzx4kwblrs41d8xmw39a"; })
  ];
in rec {
  release_7_0 = "7.0.20";

  aspnetcore_7_0 = buildAspNetCore {
    version = "7.0.20";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/09e67261-215a-4003-bcf8-f90d67dcd02b/b32cf12a5c10b1f74e21c8cb03880891/aspnetcore-runtime-7.0.20-linux-x64.tar.gz";
        sha512  = "62ed9743972043a72e48d5aa2f7fdf3483cf684a32b051315004d1c778e9712bf66e5e7a97a5a53993fa8e92daf5bacaf2cdb3eae44bb9a9e25532b9a80f4f70";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ae3027ce-cadf-4510-a1aa-125958cf0432/c3d958ba80ec21e9d75ca5e8f43ec2d3/aspnetcore-runtime-7.0.20-linux-arm64.tar.gz";
        sha512  = "dfb1c1bef4d826defd3d995599a5c03e1bf1a64c65d98b675d6c05dbb7380d98233953e68d53fc5ebec60ad4ef75417073fb1fb3256a0176bb964f0e01161f6c";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/65fff3f3-1b87-42aa-b1f9-04e7e318c1af/4bfbb002455b9a037e75791e99a18c19/aspnetcore-runtime-7.0.20-osx-x64.tar.gz";
        sha512  = "00677819450d14d9adc2b65f25b9a069bc2b43f72e4db651e77fe0e48320be8eb7c555277281de968e75d0fb19bef960d4dcb27161b8c57bce076ee18bb5ca98";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/2833b957-8fb7-45fa-bf85-4960260ae344/fa4678e8c3ceba67771b5195a2343049/aspnetcore-runtime-7.0.20-osx-arm64.tar.gz";
        sha512  = "7de161ea45faef7693d78ca44b585ab73fc183232d3f8d229fde3d05d696818d8d6402ac7ac86ce239a0a6cdae8fc2eafbb445e99443d0c7a4aab3781df35be6";
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
    version = "7.0.20";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/2c5981ff-0f0c-47ab-bff4-0ea4919b395b/cbfdfa7f35d133b0bdef87fa3830bfa0/dotnet-runtime-7.0.20-linux-x64.tar.gz";
        sha512  = "87855297338555a7b577d7e314e5dbf2c2350f8c867a489cd1e535634bad5c123a1871464d37fc9421837ff5d426c2eadecbe0f60bbf3fd32bc2461f47790a40";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/af6e12de-a63c-449f-b35b-b72ec6ee3da5/ae129eca3d734117d14cd5965dca93a3/dotnet-runtime-7.0.20-linux-arm64.tar.gz";
        sha512  = "c245125ee2708252119a1544556e1aa9e00aa18b2303de69877da10c6c17e3f25024b749ca93b53be76ee0e8e4a75d403f7019b8bc2e50ed1278f656cb2f7e06";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/cbade9d9-be1e-46c0-9f90-13ba882965dc/31c86e8f4beaf0e5ad9ad35a408be7de/dotnet-runtime-7.0.20-osx-x64.tar.gz";
        sha512  = "acdcde92f2f2e43584ee59be447f778f4a152c308975c7bdc5c2372b5bbd3092eb9d2233aec3b82756ba1e352a0877ffc17e4c8cfb20a9de91ca6db54d79b591";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/50dbf5c1-942d-4fd8-b646-1f024326ec1c/5fb99e9dae294298a8131757b3ea829e/dotnet-runtime-7.0.20-osx-arm64.tar.gz";
        sha512  = "af1cb62e29c69648ebe334e651c2703cd5e87fa0bb28c670bacb3b3dd1608aeae35ae53402c5eb4ed8bf34abd831a08ccb5ef84e5ec70617d9f8d9969fe7b8fa";
      };
    };
  };

  sdk_7_0_4xx = buildNetSdk {
    version = "7.0.410";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0ddc1522-2361-4394-97e9-52318bf51951/c5aef30601a86810f1f8ea89d42c26a0/dotnet-sdk-7.0.410-linux-x64.tar.gz";
        sha512  = "20b8e02979328e4c4a14493f7791ed419aabd0175233db80cd60e2c004b829b3e8301281ea86b27ba818372473accf5a6d553e5354c54917c8e84d25f5855caa";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3e408891-74af-4ccb-9ce8-895f6806a97d/3a589bbf6e264059544cef47be672540/dotnet-sdk-7.0.410-linux-arm64.tar.gz";
        sha512  = "2db6a3b9a532d2f59a2b459e634206913a9585c821f3f578a421e3bae346a92dd9b85b76ebde343ca3057275f7ec4d0bca71cbb7f2badb6dcdb516244e84da46";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/fc8614cd-f333-4adb-815a-9bbd07e02b16/0ccf5e50cf8fa5c600716395e240aff1/dotnet-sdk-7.0.410-osx-x64.tar.gz";
        sha512  = "782e15c19ce20aa8333566f23c2d3cdb8e89c7626de6330ddf670c4426e30cc854e44ff3341578622aecf210fa66ddcb63a7d2ad629ed92cb5582ab670f953d2";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bfba06ea-d182-4a12-8066-fd78413e6cc3/f7940d1e8d8ae641a3a3d65b6bfa1071/dotnet-sdk-7.0.410-osx-arm64.tar.gz";
        sha512  = "c0ef1914f2b298504433bca9cdab02dcf324421ece39657b66523f13b7a7166e726783673a602fb462f3db5c53f59a89381b918e7658d49a57763b43cf75cedc";
      };
    };
    inherit packages;
  };

  sdk_7_0_3xx = buildNetSdk {
    version = "7.0.317";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3207f51e-26ad-4d43-9249-5e03e93e5895/af409554ce918557a05f8e8102f199ea/dotnet-sdk-7.0.317-linux-x64.tar.gz";
        sha512  = "906ecbfa31b10ae5e2a8ba713d113ccd83e3a9b9e4d3e322482692891542959e76c51db5dd3825fb4a2cf1e951737006a99be7290f309d6822567d3a533a7a9e";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e08e38c2-46b5-45ba-b318-6b0949b3cc2b/1780549adba82e521439b7a0511229ef/dotnet-sdk-7.0.317-linux-arm64.tar.gz";
        sha512  = "22badcdb2cba0f1bedb1fcbdc99269a66a01a232193e00b42823806cee5d46194b8dd008a53e17455072a410f77bd351676f351670be96c13572d8e30cfad180";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c03db249-372d-404f-8767-dc7e4a104ade/49d2336dc14b70dc937d8f91716e4fba/dotnet-sdk-7.0.317-osx-x64.tar.gz";
        sha512  = "d3dbd0fe7cbc62388f150adba5d818abee3986863d757ce63088f4feabf801052c08a608acd5036f97191435fe99224acb12c7365be7f77def28553a231ac3c9";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/697b6485-989f-48d7-86ac-320529a85b35/5b5ed55e7e4e2c0a1ba2c3e0cceefe95/dotnet-sdk-7.0.317-osx-arm64.tar.gz";
        sha512  = "b5f367e1e20d728d7167c81e4146358e760f136b9ee0fc410d813c14366e38b09a069031aa8ca6d8df438435b6ab4e2e989be309e097169459365d4befaf9f5a";
      };
    };
    inherit packages;
  };

  sdk_7_0_1xx = buildNetSdk {
    version = "7.0.120";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8b678e05-b3c7-43ae-a31a-c007a901d939/934ec0853faa6404aa924c99e019f788/dotnet-sdk-7.0.120-linux-x64.tar.gz";
        sha512  = "cb9faba83ab276c935ef35b31f016ca4617f0d967c5b4bf1e993c2159992fb59d1dd25dce09928915b9ff586ead7acf92ec1dd96937c93317a99ca0c92b616c9";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/17a7bef9-4696-4b93-a3cb-f4bb9aaf2985/3e19b62d05b8e85b0a46d5dfd99196a5/dotnet-sdk-7.0.120-linux-arm64.tar.gz";
        sha512  = "f530f794afe3c3b9bd87b8ed509a1a13b1c8fe6f2bc6e6cce3e8cd6b56327c0ff27fc138122c2dad68770cc5015737e007ef5706599c189ef0cc7521cbf0b654";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b1da5ec0-e336-4716-b9ff-77f8160e7878/5c40db0a17dc493eb0be8d047d0c6885/dotnet-sdk-7.0.120-osx-x64.tar.gz";
        sha512  = "94deb9988509fcbfffc357114d0f5645fc6b6f6156664040cd5643a191bef10ae2fba4168aa689ff7da1a1b6fa779eb4e53a77a7847beceb7f0ba451d2c20d57";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3d081107-64cb-46ef-ab37-41560d585efb/5aa6a70b37790bbea98d7b8c380eacaa/dotnet-sdk-7.0.120-osx-arm64.tar.gz";
        sha512  = "dc06801d8de34df698f93e3aa872d57131dd3e33ac4f7cddbc96223911e0ff32fdcea78332da7be0013362c90cd24db2d86c1e275297be6dd162948f2bd38cbc";
      };
    };
    inherit packages;
  };

  sdk_7_0 = sdk_7_0_4xx;
}
