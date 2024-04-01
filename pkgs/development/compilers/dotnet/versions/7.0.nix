{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v7.0 (maintenance)

let
  packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "7.0.17"; sha256 = "08ar7v2x9g0bnfcnn46jj6k61f7n2zf2gk3mw9mmqgzihhi077r5"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "7.0.17"; sha256 = "02x99bzgfcpvfnvspar5qdw0184k5g00v9ibpg7g034iraljknzg"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "7.0.17"; sha256 = "14cbdizjybg6icsyrnhqmbpbszwycgyqblqkhnkm23h5x3pjsl8f"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "7.0.17"; sha256 = "19cigrq2biql6a1hj2gggck8gp0a8qyk22grqfpq301xq9gpd81b"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "7.0.17"; sha256 = "08chy1p9mv3qxl10ml6dpj61x167ipdf61y5xx7hlwc6a4pas3x0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "7.0.17"; sha256 = "0r7jd2p6i3yq1py72glr01j0f99h3idn1px096ql29s1snwzkvpd"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "7.0.17"; sha256 = "09pkr8zq9d3d1gvfwyv5smwl7hccg7dqh44mr7265736b9mrsg96"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "7.0.17"; sha256 = "08vygpnxnmh28nm9lbwm5w4xg4pmkwkdgsvx7w886j7prrkzn7qg"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "7.0.17"; sha256 = "0dgbmcdacma5xz5i0c91dwpl8kk36nzvi8z3n3iz6bnpmfaz0rbj"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "7.0.17"; sha256 = "1vgnd1ghs4barfb6ja0zvzqk612rsbjqmdq5klz0rp9w57pywjbd"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "7.0.17"; sha256 = "1mgbbbp6jr4fb4rl7dpa4qbpfkwhkfnaqnylk0vyw3rr2ryla5j0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "7.0.17"; sha256 = "1qc15ygf2njgnd3i252h5w1bz73qdy59csd23k9ml41r5jn87g68"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "7.0.17"; sha256 = "173a4jzvcxqrf654wg2ravhqdc9yr4yjaw2dg0lcygyygb33gnhg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "7.0.17"; sha256 = "1w8ylvscpr1rjy2axlyxv17sjvk5878v3w29dcdma6p6ia6181is"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "7.0.17"; sha256 = "1fab8pym8mbgw8dw5gzr0bsqmjsalpdj31fwvyyal33bqcynf8d1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "7.0.17"; sha256 = "0i7kcidqp0qcpx8mlgpbrizcmhpa5vwsb25d32jzd1a3jd5car4d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "7.0.17"; sha256 = "1f5syprz551lh51b3b940nb73vh4bqigkyqrgxlfgi6bfvfcxp2g"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "7.0.17"; sha256 = "01bf8spy40sgks6glicsp17wcwah2dvm96n9p892iyyal4dwhsf9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "7.0.17"; sha256 = "12fda37hj555vk1kp0nvrgb0pn2h5vym0wdl4zmplz5plalkrxfp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "7.0.17"; sha256 = "0axpazf00kpysl645i1vmfzhln4bnihld2szfamy2ic5m7db0rwx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "7.0.17"; sha256 = "12bspc5scy6hh6ix8fkiwf2y20ay0sr9i5csqvnv5v19z49ylllg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "7.0.17"; sha256 = "09wak1ja4d1h8gq7yxx82qa1gpa20wbyx2b40a70ii18i9lckgv9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "7.0.17"; sha256 = "1g66bbzsn26i75chncmfc0prwmmgvxp33j3i9q1yryxwmwwbgwbc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "7.0.17"; sha256 = "1blpmgp6a6xsghsgibmdjdm9w2kfjji1x869yxg5i2q0v3dwy4ga"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "7.0.17"; sha256 = "1zbs1w2b6c7h0h65168qwxzh14mdmglckjsfwhf1gdkmlwp17x3p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "7.0.17"; sha256 = "0flx7vd8l93vsr2bc6w5pz2pwnlqyppwrp3ayb01w0xrcpqisrri"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "7.0.17"; sha256 = "0xigswggvnr72czhqscyixch2lhabx7amnk1ay5cjs4syshsczw8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "7.0.17"; sha256 = "0zsbg3023xcgln2x8ijv8r6dcis8vmjjklpcbz8yqkhp20vm77hd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "7.0.17"; sha256 = "0y3scq473wk85lcnsjb6bw6shg4qyshqabfz62df3s8cw3dylkja"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "7.0.17"; sha256 = "1f7n90bqzdii8w1xgk5bvz3hyrljpzcqfz545sxx5fbnh1xm9bw2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "7.0.17"; sha256 = "02jdvys715c1p0vh8601vdrjspg5v332qyl504qm5y8ygikcbvlb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "7.0.17"; sha256 = "1vsql26zppc7s1a0dbrni3rf14iqc1m41jgzzq5w9fnk9mqrd54k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "7.0.17"; sha256 = "0ixn3imwmbzb55prhqwij686c5gmcg5hryr239w29nqdfv4ym0sf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.17"; sha256 = "0yvm9fzbin7j0rz67jqbqmlghmvjrh4m35970kwn8n7jrvyiprk2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "7.0.17"; sha256 = "0182pgnc6l4lmmv9rcrxdmab14gv6aq7qx4yqn25y5q899ksr2wb"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.17"; sha256 = "14gsvg0v345kb7nqkg9bmw12qk1w3s3kipw2w9rf9hc8k46n5gw0"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.17"; sha256 = "058l5jixczxbzirsyh628jddim7j6j3qxby7ac143gyrccgpdc9k"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.17"; sha256 = "1216lf35ynhl7f53by1fgyss5ibb3wdq2wm69sb7vv50yd8668w8"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.17"; sha256 = "19y73178xkkl1m7fcp4n9x7xw7fxmrsmmim3zjs8vll18mzmmmlh"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.17"; sha256 = "1c5f6g8ysqyb5wzp3g01pmkhb6yddm8gyqb434f9m4m3b093r0hc"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.17"; sha256 = "16p5zzmyrmisjpvd2r7rn2bqp0minplyf66fcxijy3b1wy3qrbg4"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.17"; sha256 = "1m1ns40bxskq2pcxy4qzjcqw022gra0bgsv289pb19jvks9vxfbp"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.17"; sha256 = "0lnwrwmsgy39w0s46x6x9i55lwl8bvdimbpfhlv0n5jgmiqnm3nq"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.17"; sha256 = "1wac2sv87dw0i81i6g8v6vdz68n173y9yknj3vic9vj7lab0rnyv"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.17"; sha256 = "083rakqdn1lxsp7jz6hvlzi7d4p6jjjfv2k2jqbx298q4i8l5cqp"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.17"; sha256 = "0pzwksyh1jzi000d8jb23073jdygyh19b3lnai05xz4g7zjbrilz"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.17"; sha256 = "17vgqprd9mh8vrf58lidml0bixqld83sknffs7ahfk8wnvn00gh6"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.17"; sha256 = "1h438hmi68qp7rpxcn19rf036hlyfxch6sw21k4x5r0gvm5vbynx"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.17"; sha256 = "06j1jpdnmr94m8imwqgj09mba73w7kjxkchb32ysy61f6rvbs66l"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.17"; sha256 = "0mg628pr6ih221yqfah2bkv6ca4wvwyjs3kdm7kph286if5ncvgc"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.17"; sha256 = "0z07cka23hj54ljs7cy0q2161zs0365jfp5ajkmcidpqp6gp1drm"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.17"; sha256 = "1fx17zidsx0ifq2mbszyyhl4c416xcqy1ssqgylqnr7a2lj39inh"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.17"; sha256 = "0c9j01gb8bx1ww56g73753px9yy0knsiph5aaainfniqm9sxwrih"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.17"; sha256 = "1s146rl4al0mbmgkh4mkkkp34gjgadggxk99gsgbfqlmbjm0d9m5"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.17"; sha256 = "0smkd3ydd3fyjnkkiwjr82b7cp8vsn4qnfhv94k23ql5w1msx29f"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.17"; sha256 = "1d4py22hj8v992i166imkvav2x5qyja2345cisr1fi2c1sd7zcc5"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.17"; sha256 = "0sxk5pjz8jzmgxd3k2xr6hxdjp777fj0qpblr3h7jskjqh4jsmpw"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.17"; sha256 = "1iacgda97z7dahjl911qkpjqmkfqd0p5b893vi0nk6f4nmc7dr12"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.17"; sha256 = "06nsxsadknqfiqhw7bhngwwzi22jam9lkhgv8pd4s3spfnlmgfr2"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.17"; sha256 = "1ixpfkcj338hxb5vlimvn308gkzgpm53ik4ryq80wg15l3hw1b24"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.17"; sha256 = "14s7nv3l4ff1js9m9c1lzvvh9wp77kxmz5pvbhspkrpxl60qyjxi"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.17"; sha256 = "1310ryri2jlqza9rc8n7bv7l9h7n8lab27ya2chs49iq90f71qmf"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.17"; sha256 = "1blmwpy0wgwjykc538hksvshbij26d5dwp76swfc9m6f7i9fnwbi"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.17"; sha256 = "1q7ib8yplff0h5q5mxiy58fxliaz1c6jswq7gbqnr0fm52vvn9ij"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.17"; sha256 = "1rlm27nrcl4r45k8nmrxx2jz41cd1z9jvxqj7904zvch6vbp1acq"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.17"; sha256 = "18i9m1dik9mwy46594vy8bx41nkr0viwkcykkxljlzqiiahsia17"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.17"; sha256 = "0vh5x7bc2fgvvz05v3jvlp7f017cyi2agi3h5cmh9mhm08ibsmql"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "7.0.17"; sha256 = "01y99n9nnbdzswfsmylkxcn89gy8l659riv2nw8vsg9qi8aab379"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "7.0.17"; sha256 = "1lvnd3kmd061wzsj267pbmghgjrmk4k6cj2z4w50y6yrxwixy5wh"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.17"; sha256 = "0gm37a49vwrzl73d6nyai4hplc55jfylw7g025qx57l3092nk03n"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.17"; sha256 = "0g5vj59fbchbywbb55k66bax78wxz950c1ky1zdscbz44khdajkf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "7.0.17"; sha256 = "0bpf3avhbmlbgwycph5ri6jli6i0sz796dpqf7awqd163xqxpd1f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "7.0.17"; sha256 = "0mrlvqvaxqayp8r91jjgnacm61pqj9xa024kkah4flhsrsq7jzvq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "7.0.17"; sha256 = "0pxw42d8d5bfvgxqdaqapb7w3c48ahdk7a1wwzzmxmfshdqs5h6k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "7.0.17"; sha256 = "0yrjq96igpn5xpiynf376xx1yhygryx8rrg2j5zml953sb9wwnkg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "7.0.17"; sha256 = "1d5fvclmcsq5d8sj5c95dailnalrv9ncmqmxqrxac4qq6r096ihc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "7.0.17"; sha256 = "06h53xbwnfcw8pdpr1749jyi2mx05mi7x6726vasn376w11p02hv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "7.0.17"; sha256 = "06panjabpc48pr12f52v7j590yiw7pr3rgiaamfkspjhjac3cf9w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "7.0.17"; sha256 = "1cl8dyf32qzas8z9yp7q7089xpx38yfcahnhdpalyvkagx2n78by"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "7.0.17"; sha256 = "0753xd5lwxgh2fdzv607fj9gav9pyskzy6kxq80y4f2x02ijcvyq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "7.0.17"; sha256 = "1n846nq2xdpggwqg3gcig1hnw18nim94ycb4vrd2x9qj68rlm39p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "7.0.17"; sha256 = "0p2gx2mhc1xm2xn1g3vkhs72i3vp2qqxjbfblnlhr9bql2mygvva"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "7.0.17"; sha256 = "16704wkgzz6njzcbvrhfw1m8lbrf7lg5bhwnsqc46kmm7s18913l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "7.0.17"; sha256 = "08387qf7jf8wrrkrn9xc3hvl5qmfxv5r0dajn6q5lar852171afz"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.17"; sha256 = "1a327g4dfj0n0pi2sw69mlc0qbnnxpgcfn9d0zam75r6678dhb41"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.17"; sha256 = "0ld9ldb1xv7b5dh9yls8r4pqy4nwg1wlcf24rcbzh77622hljcvp"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.17"; sha256 = "00hk31alqqwdl417v3c98jwy2fjn38df17mrc5jr9c3gfdxa30y8"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.17"; sha256 = "1xwks2qwgqmjl5yj5gpmbvwr9pnbxdlq717iw1075h02avjybywr"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.17"; sha256 = "1gl7sxwb2xwm4pnd1f9hfw3bq8pi0f4zfwr3rcql6a88vrvn1p09"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.17"; sha256 = "1gx4swhsvyh31j852n4m91401vhfllwc75sqgi74ih9l03fywyyw"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.17"; sha256 = "0z2zcmaycjbqhzjp6i55ndz43hggl6s2l0iml7s5rqsn8iw6znxr"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.17"; sha256 = "1739qpgwhdc84jdpnhfki6dysi0gn3q17pbk2kqy1118ik0rsys3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "7.0.17"; sha256 = "0d9kl3hv223sqnfnn5b8q7514wzn6sbkxzm2ypb2bqbr34adk7gs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "7.0.17"; sha256 = "113h87sdgfp9pkk7j5mng7li01nc780fy0nizhva1k4ay7dv91f7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "7.0.17"; sha256 = "18jpmgkialz04q98h6b9kw2xd9h5j6rgssapvzx0sb11jslj53d2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "7.0.17"; sha256 = "1ignp0mfnpi8gy69hhn7as806vjq27j13spgn6f3anda75y5iqv3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "7.0.17"; sha256 = "0pd2wkrfnl2898wqcgj3pd18fbssal5brjnyp743w4w45fj39jj2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "7.0.17"; sha256 = "0fin6di8yz07bh0b8lv2lbjahc513h6h8x4fsfvkan23qkdzh84y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "7.0.17"; sha256 = "002959daj2pj8zr7i3hzmjh249bf36fa1z5zi5g3ydnpscd7y5gw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "7.0.17"; sha256 = "1c1v0h71a9v5f3py105q7cp8r1h0ycvixn94r8vdh1y75yr3wrkv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "7.0.17"; sha256 = "1n1x26hall4p081wvpdgm1jgx85zrmznwsz6sdga7mg87dc9hvci"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "7.0.17"; sha256 = "0dx7s9fmm763fx23gl52jwin2aak2x8fbmq2vsl7vxg5j09y82g5"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.17"; sha256 = "1v5ki2g28sii106mnsnq0smch5fkviibndbnqin5h02n8b26n472"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.17"; sha256 = "03qclsxki7jhhc26fh49vf7ak8mg5a9s219y87mmqxd6wvql8nnd"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.17"; sha256 = "1dbljqp87zg00cgljw2qmni885j6k3r31ah9hjxszaijsw8147lx"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.17"; sha256 = "18lma1vkq839yx8dhg0wasnir508j19q4w1zcqhy7vi8j1z2mff3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "7.0.17"; sha256 = "1gdjp8sn4m80ry4flxmyjzsk71axr282xdlkmkg814idf4qcr4iz"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.17"; sha256 = "1xnnf6fas1im8ccsp95qk9dj822swi66gkprza2q3mxgr7pdq2ig"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.17"; sha256 = "1zy6548yncxwhjn8ydl8p0gkbswqza14qypwkcgc69718l4d2ig3"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.17"; sha256 = "1d8pkl1kw4l0d9g7m0wnrfz4iz9mzpwafzi4hzwra9sjz03mwigc"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.17"; sha256 = "0bbvibqdr11wrlcvajl4k9jl4yjs8c2qjam9dkqrwpscp8jv8l5m"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.17"; sha256 = "00wccrip77zsr41g38h076wz9xzih1ix5m5naw5lqikg5919vmja"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.17"; sha256 = "1d9rb3r41zps3bfvjyay93b1nbk8klbmalypch50hdy640396dzp"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.17"; sha256 = "0565ifq7g1i3166w6vjwkcdspm8n0pq65ww740hzckz7zxbq5yi4"; })
  ];
in rec {
  release_7_0 = "7.0.17";

  aspnetcore_7_0 = buildAspNetCore {
    version = "7.0.17";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c97c327d-c699-455e-8c98-f2bee01a9816/ac33d9589182f506d2c498b5e7d52bb2/aspnetcore-runtime-7.0.17-linux-x64.tar.gz";
        sha512  = "a0cc7f76f24d123fbe787ff3b554736000c3f6b4f7b919819fb3039f6df4a15d28713a0a169c9493012e14afc3a0299f3d800d93d6749a70b567833ef3f3aeed";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/aedca120-d2eb-4b54-aef0-45520ebcf2fb/514dac96b582bcafc7eb238499c3fff5/aspnetcore-runtime-7.0.17-linux-arm64.tar.gz";
        sha512  = "a5b6c6a262334506675447d157d7b4e5683c77715b74f97c9b219166bf9226a20d5194ff1c5eb8e17b625a17f8fd114da4b44ad19888760956ff735facd1d41e";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/2b87831a-9970-4bb7-8932-e84444b16429/e7f75f20ba9711a8c8a6b23272ec155d/aspnetcore-runtime-7.0.17-osx-x64.tar.gz";
        sha512  = "040172bdc6a5ad63dee2925261650f0f4d00c7bb0200b64677e18fdd3877b8b3ce52fb68ab42842bcc4de36c5eeb28622ea483d48c245b9407905ef776971a9c";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ed189d17-cd55-4f43-ad0b-5b5cee85090b/835d867a5efb1236e1e17ee76af30e16/aspnetcore-runtime-7.0.17-osx-arm64.tar.gz";
        sha512  = "384f571ed3e8f623760c37eb4d39dfd50e977063683e2c22e9366dabcfbf509af44a12d14da758d119778261c6d95580fa9eb50d3bdc5a216f69ff33364b4f37";
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
    version = "7.0.17";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7329e982-d340-4e00-9a4a-933327710b9e/c578c156a3e2a94cc4e59447dd312c33/dotnet-runtime-7.0.17-linux-x64.tar.gz";
        sha512  = "bf65378d4e9b1f14559dbe4a0bf5fb7e66fdf9a7bef9d109deccb22fae8a5cac9b5af5df4b67321dbd5f34764d911ba580c62b0456da648a57e94f82be7e4abc";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7016bc89-6c69-40da-a8cb-50107f339810/41d1c8560655da79817eb31532570401/dotnet-runtime-7.0.17-linux-arm64.tar.gz";
        sha512  = "f3a23da65f11bc43a4ea8722a872132a16d76982da1445b79fbfc8e5b2b38f904fdd22c986a0598d5565dbbf104b4e852ac2bebb7d79cefd20b9b5a1d40036f0";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7055c472-e60a-41f3-b583-e3d95f2b0730/b099f5fbbedb6c1801465ea9b6f6e55f/dotnet-runtime-7.0.17-osx-x64.tar.gz";
        sha512  = "d9a79b44c9e97e170ca5ff036f36ad64b077abfe3e5913c458f7de0ba55f56e6512ba5ed70bb4d9a056d3674d0efc41ca66507e5f977e1e291f815592f96fd1c";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a5585224-b050-4e21-938e-f9c68e3bce62/7af1c98ed83514644337f17028282ae1/dotnet-runtime-7.0.17-osx-arm64.tar.gz";
        sha512  = "62655e34a84ddb54db19fc0b51955171fc07c987777dbfa8d8abc370957829e4c7baeb64f9596f2a2078c04bb1843b4ca0601e371124f0016084622e68930c47";
      };
    };
  };

  sdk_7_0_4xx = buildNetSdk {
    version = "7.0.407";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bd9f066f-c0cf-495f-95bc-c3b96c9cf06e/ec93222e82bca1aa14590beb8a73625c/dotnet-sdk-7.0.407-linux-x64.tar.gz";
        sha512  = "82e659aee7d3ab6595bfc141f24eda13551f5c5bd9048aad53ebe3963b8e25836ca07eb3d1d39d6adae145db399aab44ed57db27d34119e836202eb3af93c9e3";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/20d6bfe0-2d50-4f21-a074-a0c1462bcbcb/7300ba9d53182edea839535774cf9336/dotnet-sdk-7.0.407-linux-arm64.tar.gz";
        sha512  = "94c5832ee830035a1329f28c5bf12651537c61b013d9f1afae2ef495f62b93f615c0940754a815f03612125683c242e98e8a9d28912b2eff26f44d998ed6e680";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0fb2e12b-4cb7-409c-ba65-91efbc7ed601/8846094f62316e41e44fd751e24264bc/dotnet-sdk-7.0.407-osx-x64.tar.gz";
        sha512  = "6320463f19cd4448a361181b83f41f19f1e01dfce1d426be6f22cb42976ddbf83ba48c8dcf9440187dd4a4acfc65b7741d0757aad42263ca6a2df03d4a0db061";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4d625ad2-9c2e-41cd-a21b-1de0a49128dd/2f46d764be06da15cdfe07414763601f/dotnet-sdk-7.0.407-osx-arm64.tar.gz";
        sha512  = "84edf6d50264efff29f76acf714514140ed23a33a7e93eaf2c3dd7b81c9b6ae6a0c5d511d7d481ef1cf8a58202be68cfff90b7410f2f0d255c9811503370a79f";
      };
    };
    inherit packages;
  };

  sdk_7_0_3xx = buildNetSdk {
    version = "7.0.314";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1516b4b9-d63f-46a7-8ba6-00210f151ae2/b52b022eaaf287b82bf54f86cf3b4864/dotnet-sdk-7.0.314-linux-x64.tar.gz";
        sha512  = "0f5ae49aaa7fbc63bf7a48837af6299120088e88a272c24176aa70a61ae9654ce15db0a9a7bc36219ecf8eef214ee711354e87872134ec71c32b4e2b90d88da5";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/810aa235-29c4-4070-8318-b260245a780e/c85836039cfc38f8de666148d01936cb/dotnet-sdk-7.0.314-linux-arm64.tar.gz";
        sha512  = "497e833385d62b9f835648bf9a9b1fa214274f9c98c306485ae5634622d3908c2990e0bd09d2950b4be491b5984748cc2f8a6e71814a44ec7f9bb608363834e0";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c8f92913-14c4-440a-af7d-61b266718974/a85c1168ab1bfbb7794e333a0171d799/dotnet-sdk-7.0.314-osx-x64.tar.gz";
        sha512  = "8c3ede3c1b0e8aa379ff054a830fb7f5c4364c5639352671aa7c68fe9b486f1f29cef83c3e99d24859a4e4757bddac4a94e4d98507e4f63e3075ebd3683854ff";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d8ca66f1-1be5-4d18-bf6a-ba0cb04235c5/cfa7141a76477bc066605bd808e19cbe/dotnet-sdk-7.0.314-osx-arm64.tar.gz";
        sha512  = "3960968eb545bf8329ff5c0205dfe2a07ddf6985a62bb34916f09faee56a06f60aa3ebbf8bb0edd7309a1bc29ed19ecf92f63cc60dad44dff47abf6a4c678f25";
      };
    };
    inherit packages;
  };

  sdk_7_0_1xx = buildNetSdk {
    version = "7.0.117";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6cd9009e-085f-4378-9e52-bf217b7ae7c8/a241e54bf3bb4c028ff3ec36340a9506/dotnet-sdk-7.0.117-linux-x64.tar.gz";
        sha512  = "9448f187d8912bdf036b996ea8890292697206e14d171c231f4bf3e5b6f1b317eb9468fcf76356fd2d9532693e36c1a3909f91cafbeb9f82911c836131a72e39";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/40cdf4df-bfb7-4b0e-a178-313201bbd11b/52d9f2b6f7bf4c4f9adf738fb46d9458/dotnet-sdk-7.0.117-linux-arm64.tar.gz";
        sha512  = "2d9e071727d0da836cfef4f46bcb546567c68cf37196d58335b6245fa4152bbce835bae60eda3afc87d478becf65f2faeb88afb815e66cf3399b0f654e278bb4";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/674cf162-da19-44fc-a9c1-e0fe33fafa27/e08a19628c1901e66575e7d300aa6b13/dotnet-sdk-7.0.117-osx-x64.tar.gz";
        sha512  = "b394d3cd901db197346bbea28969148e2ae29c1bc506ca2f1b0cb50c30605ec8191261ec02387659d8da8a474736b0afe56e423680f31f14feed8606e4df4d6c";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a669acce-bffd-4591-bb89-270800fec424/38df8b4002a3bb5a8ded21a8f77f4173/dotnet-sdk-7.0.117-osx-arm64.tar.gz";
        sha512  = "fa4ab2acde6973f8b741f56f3706e36556522691cc903877d4519274fdaa3900659afa32c81b0771a755e14ccc4a53004cbeb036af8586a69e0c2690bf258085";
      };
    };
    inherit packages;
  };

  sdk_7_0 = sdk_7_0_4xx;
}
