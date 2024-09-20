{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v6.0 (maintenance)

let
  packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.33"; sha256 = "0xpki5wnl629zcih2d70vr1cgrhwr10mf4r89dyfm4hmwfpjz0pl"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.33"; sha256 = "0d26nch9v7aaxb6m8xjbwbbag88j8r7igbg512p242g7a03xp743"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.33"; sha256 = "06mdbp3z8pvj6q15agzdgxiqdvk057k0ld0q6q2bcy5i39x9744m"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.33"; sha256 = "1gyxvfaigp8i7x7yf24xzk4z5p638zxfa0pmahcyly0afl8s0i2v"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.33"; sha256 = "1q5aigywyx1jcm0ws2gql8y2ns6lrs9q6h85k3l8kamrbjls51jf"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.33"; sha256 = "1m1qac3mpnhdz3xpjn3a659nis10v687aacjrgrlbmjffibh0wz7"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.33"; sha256 = "0rks3lj4vwxlv1w6bk2v0z7lm5i22hzf46qcmc3qxndwmlp1frr3"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.33"; sha256 = "101ibi2xfy9wnll7qbm257ifsmn4plqfa5649i331481m6hjscjj"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.33"; sha256 = "14fgl7m0r9q3j0ab2v2g0jkby28d6c7386n0dx4zd1j516kcrzpg"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "6.0.33"; sha256 = "00ky4jnrpq5zcpmrkjny74j2k466kw7sj4sbh361wql3q0ma9nm2"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.33"; sha256 = "0fx2zh5266inw8c2a353gl6sfcssnc4l952sc83rpl48x0xy5hqr"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.33"; sha256 = "0iwxzkdlmhd4ks6ivrfp5hgwgxmr2cbx8jvz7vzj01v3zbv8m8hd"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.33"; sha256 = "0r1knq9hzvx4qibrlvq8809r6pf3j3inq6aiw94dyrrkl1vfz3rr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.33"; sha256 = "03rxxv7vlaf7pbdcbyv2q93f5d0w7v9mhi2qy2nyiwscx1b1rrj5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.33"; sha256 = "1qazlv2aczbrzv5l4l0p94ix7q321i3j3jn6fcw0yxlgznjqw1dg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.33"; sha256 = "01kqcqjp2f5bx7nwx7ma90r7pjnc9vdb16k3fs1v3lvdb83mlwjn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.33"; sha256 = "04vrmd5blrqv2immaw4xlwcc8krlpnckdlxl5jg9mr7azq657z9d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.33"; sha256 = "15ki8y9607dw4ldixy041v3s6ld36j7r8gdhn31y6ffp0ij0s9p6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.33"; sha256 = "153hdch33nxbs4lwd799rvbac8kvbg1jbkkq440fmmy7001zdvmn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.33"; sha256 = "0v86zfpln81b7r5yxjf676xx372kmwn0fcciwnnx6xks3i9qdzy0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.33"; sha256 = "0rcg68qj84584v6vij6kqk2jrmgci26rc40cmf9ibc2h65cm3hjx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.33"; sha256 = "1605avj9l3f6vxghkwzvqhyx5n2ipyb9y7d0n32777pg0kjc29iv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.33"; sha256 = "0f92sp9120a4bqcws53migvpbv6iixfqb43jp38s3sgdv0dx3i1l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.33"; sha256 = "0xn1ckjg0zha3wib7pin29i0b3390xmanfrivm29x98mj644md51"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.33"; sha256 = "0yn9cczgh2clmxl92jca176dkvqn33jc4jyl25s41z9y58gbc9nz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.33"; sha256 = "18b8pf3dkbgav63yb2szdi96v6s1brn6yhbragzsw9iiwhvqxw8n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.33"; sha256 = "1c4j03a7dcxvb0lajllnkyi7jdjzvvfd739mnhpcy5dcfaz625yv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.33"; sha256 = "09hbn47rn8yn5646p12xzw60ijhshrwav5jsha2hn27d4i57ls5j"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.33"; sha256 = "1x1b6hc4jg3l3fypdll6rqq29021v2p8y5piclyhsqwwhlzjb2cl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.33"; sha256 = "01pvlmwhdhp6ny3h5m0rm5mahkj33xgmrbcldvh1qsilwb4vqvsb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.33"; sha256 = "1yl8gy6abj4c7n2mkzs6v9mjzv2bhwdny7za6pclay4m1a4kijlf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; sha256 = "16ij3bf9kil06kh0ca1csqcg3x5ang46z9pd17y6f08im1l0xfj9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.33"; sha256 = "122aw6hy2xws6wi00g3swcp7ria1qwzrz4ywakwbqjac0winshmn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; sha256 = "186r14nlx93g053yhxcq9lfai2j9w7nrjiff1y2q5bmnkfnbd38j"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; sha256 = "12mxxvzi9rf53lj3vz2q8fpar915ghdhixpkm9q29kz8ly3hbv1c"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; sha256 = "0zjpj744gld18fni5gwr94yp5bmf7hk8k7mcpg5s34pyyzp3zd0q"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.33"; sha256 = "0yzs527173v46x77if2ark872sjx0a1spz08xsm9d3bpkx0ncyd1"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; sha256 = "1hf30pxgpc1kcmfpcnd4v69xrav99npsv7apzj55fy9z83a2djgy"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; sha256 = "13vpx6vayxqk7g975bgvdslcfwaxvs3rj7ikn7ir3k0kivsp7dlq"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; sha256 = "1i60ry18padghnnwlyxcij0hc8361mh4mnsx4wy1y8ys45s5garc"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.33"; sha256 = "0k4h0j73sjd1w1zkcq1qdz2kdmrjnssr5w9g7xx2l1djkvw93lkv"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; sha256 = "09kzlvz9ddzj4x8p9qnjvb2xkzbhwn2phs4sxwa8305janbhypy7"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; sha256 = "12sjcxxg0l2q3ks4s8lac2l5yb7xn691idww895jkxar7d47vjy4"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; sha256 = "119szgcdrbxqqmmz59phw83b7kv0vmfl2pafhnmx63wvyda1717x"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.33"; sha256 = "15fmfgl0ga7fkz4bw74552ljs2l0iw6sm6xk0v90k6qdihy4z9ay"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; sha256 = "1a0dvvsivcsr6r2ln8r0g7d08swh2pa5fnzcabif833x7rxlriqz"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; sha256 = "0kv445lsj1kkp2mgayp211i5q28j808v54z4fxifda3cynjpsyv1"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; sha256 = "090v3q7d7i1h4a8zafhhh4h4qgws7i4vr20px4x3sq2lcigqky28"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.33"; sha256 = "1s9ia1hh82pnzj0w6szjyg56vb9w9h1rlnqj1nb6nk6vj3a6ihiq"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; sha256 = "1n5j69z3pvmas6a6p5c45qn6mzdmb8ns4yl2if1cc69n3fs6axmw"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; sha256 = "1zbdbainvfx8m1228ql3zs2zs2dincl1fwgfivbwg0pb578l70ab"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; sha256 = "08aqnwzvxhvk9dlxra5f022hjgcsqgcs1kpdm09yy6yma3xd8v6y"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.33"; sha256 = "04asl4lwf3wlrghccip463fri9sgarbgijky8052c1caj68bmscv"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; sha256 = "0x38bnmilkkc2c3i62jkn3vj3visjx87drsj3m3k0x6psn6h3qmr"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; sha256 = "1hkfp1p8z6ada8z5ilbn2j1pw6mqxw69r6719rcv8ggngpwwd21y"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; sha256 = "099s3fcqjl2sjp3fsn1xb3yq3qjv5nwsmy40ipr2wrf17lasjz2w"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.33"; sha256 = "1wbzabbc7br7my9f453n8jds29ry2mx3l3b03b4bc3zl1ri6spzn"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; sha256 = "0jwyfcw085svfr1f3y5xbpap3mhszpax95l7rw6g77fp15qfdzf0"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; sha256 = "0yk7j0d8hgkb9dkgkxrp19cjg09sl3vycpz9ff16md8jjakd2ywz"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; sha256 = "06156xl3wia310qcfjahs5ni58j42pg8s0gjy7yzz7m7ixkig1kp"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.33"; sha256 = "1sydbax1kcg8nbcry6h4ik54gk2q5swbw5cay2w5xl985p6dwkjg"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; sha256 = "00pcsz4vd9mscrwbpwlqqnlacw2xihxgvlp6xw0ycjsdrkq4621z"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; sha256 = "0l9j0fqpi22b791xs1vik98gr4zz004gxni85zmss64pqj7zabkb"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; sha256 = "1zpciqzf5g7sygj1iw3r575msfmr8bs56j68rx7jl90hzrdf14mr"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.33"; sha256 = "1qwbplriqj5b720lnl4h9848pixxagqqa7k73fa11x2r8yqn399b"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; sha256 = "1nyffsb8lvj23x2xg38ngcbg8bh3apv9px1n9slf8jf9qlb6hnhc"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; sha256 = "1ynzpwx6mmj3w5x37ivqjjk5is9hmgwwlb8p50rjhidhc99avlwj"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; sha256 = "00if84zqqkrl7gdak1hx8l93ixidj4sgxj5d6wjji93iiph4m9md"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.33"; sha256 = "0vd5xvmxvlqc6k1c86ib0fk582899vvkfnsnnfmw7f6s8271jcs3"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; sha256 = "0lkv19rqhvykdvs3lnbv0lda66s6wz52ad244yirmmr6gx54a7jg"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; sha256 = "0g4aqyz0685mh4b2w3d96q0m7138w3j5w9ds9yli51gdlv0xpy13"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.33"; sha256 = "11qqd4vkjmypah5lg9y37ma374a7kwvrrqi14knc9rzi038xdzc3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.33"; sha256 = "0ghxb55azggk0cs8aasv57w7n1ag7wb981dfrqrag5cfi6gdwwlk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.33"; sha256 = "0vglrj3yx5ykxy6lbpb6frsxcp3109rpl6zl859vy6vdmjskpdn2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.33"; sha256 = "1cnm270drlfq1f839r5frljfg8q4xqn0fqicf97bd2cwd1nyx8gl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.33"; sha256 = "0vrg6xbzhi8mbp6nas6admh6pja3akc9synlcpjh859mg9qr8886"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.33"; sha256 = "0vdabiysl8hjaza06yfmk2x45i2qhr092izx820qv8clfdggmb8k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.33"; sha256 = "0zlsdg3bn5i1s09p9lw7xfdcfrm0ii9a1zbfqhvqgvs4zwcvk17n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.33"; sha256 = "0jgmmy5y2ci29izn0w1dh73xvrmvmypbyxjiq1kxjq1si5j465mv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.33"; sha256 = "0l7bh7mfha16dbpmlvgfpkgblw0p00x52bcki96pkjldgqnf2fwr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.33"; sha256 = "03bk8c7shd8sfvlw8k58aq95yc094247722fs2s2456j1gsirqqj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.33"; sha256 = "0qzdhg82sxa1srjh5lpnjyyz6lww00j1b4sgm0581ya1cjz8b38c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.33"; sha256 = "1sn5q5q0qwnj5majqsfbzgirv0kgxs538ri9cbrp52sdz017c3a1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.33"; sha256 = "1ddmaapazmsvwmry58x117hjl2l3q7r52l8wk45h820q46v8m26v"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; sha256 = "13l2xvm9zlb2b8xmznjj341nrknhaqcz7hlg4ccs9rmw32p0zvdy"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.33"; sha256 = "1fiqsm2nwz45gxrakbkvfcsp3g8l0nl678df0k52ql4inn77f7p3"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; sha256 = "1nrnwgpgqrjr1pipjld74h1nk2m1gfk83f6lid4hvznyvi4181ph"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; sha256 = "0n8hm8dhl1k70iag7n6pkzi9nfc56xkz4y4xsn6hy792nw17haz2"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; sha256 = "02cjzf07kp8k2vb8hmf72rz6fx2y29biqvdhdva2jj2j1768a9gd"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.33"; sha256 = "0k0cc1swhcrf6ydw0qkx52ikc8mnjv9i0v963yp61n6dhsa5cv2z"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; sha256 = "0ascpl1c8a710ggmxvkxw63rgp1gwkjdr03mmvwlwiwgxks5z4d0"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; sha256 = "0ra2v9l3w9sid1hg21ss7lawp8mgdhv1g04napa4nrv84bcz7kkh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "6.0.33"; sha256 = "10hswinnzm4mvhaqj1kr352lx7a7m2c6dc96q7p5dizlsg2rsh54"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "6.0.33"; sha256 = "0h990mf442c2s9k3vfis7r1nhf36bm2xsmz8472vlhdgym3bvr9h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "6.0.33"; sha256 = "15s3ihn50jwh3wdswy2563fl8rjdn5lxwhfcsd8xsjp9j5ixpm27"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "6.0.33"; sha256 = "1vcq2m5bcrkvqdphjcx7lz780rgddi4h2sbwhw5ysxmns5nkpim4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "6.0.33"; sha256 = "1jh4xm42mzrd7xqp96qvvinhz7rs9qfal7243nfiznl4y9az4k85"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "6.0.33"; sha256 = "0zfqp5axbl5066655wsd4435194xfnfbs2k8hb1dp82a74fwz2p1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "6.0.33"; sha256 = "0kkqj31kxdsd8jzna25lh6f1kqlwpx5pfwgdn02qr7dzln8c25vw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "6.0.33"; sha256 = "04gc5p591kmn3divsqqn8s29x1l3klcysj4zskcidp1dkclx1dq2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "6.0.33"; sha256 = "1aik89f8pjg5vrz1lx6g0ccsbkcf38mw0591dbryqjwfdzp08g2f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "6.0.33"; sha256 = "171qj7ajbc3fhld7dbqm04xrqmqmhbfmh9vpsl6sqkgp58b8vg11"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; sha256 = "1pf31zyfxd68cs6pklhg5g8izp8r5jzkcxgq85px62ym6xp83r0w"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.33"; sha256 = "0in7gk5bi69gmm992cs4apj2kaxdjsdmfxcrl291822mi2ai3d2r"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; sha256 = "18m6qi5hjlscd8lkmc8a513zycfhm64mqyd7g032j02vrrz1d20y"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; sha256 = "1jq2mc722g8xc7wggyxayfvhan9dplvk4rbp9pjkpiby25mlhj8g"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.33"; sha256 = "1ighzhn8ngjnv53nn98b8n8krwh6k764r2kkxwfccajwhpn9sb23"; })
  ];
in rec {
  release_6_0 = "6.0.33";

  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.33";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/91f66f75-bd3e-48f1-acb9-99c0da753f96/42c47999ee4c4d108774536afe5da160/aspnetcore-runtime-6.0.33-linux-x64.tar.gz";
        sha512  = "12b34fe1d0a679ff63db4bf002a2988194d9e64d0e107d128c247821dd939a86eced0fe453c0638d3742dac3a32e533792c26299400fb4fd5566b75177e66875";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0c5a5f3a-881e-4ceb-a334-c5e3b210eef8/9834ffebacea659cd14d272fb01f81c4/aspnetcore-runtime-6.0.33-linux-arm64.tar.gz";
        sha512  = "7a60a77a306070a3b94db1acfa73938b6880cd079bdac3e5cab174a47af467b9208e9f41d8e12e080831d528151cdaa5b660bea5aa6fe537ec144543c0fffd95";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d4641b35-5b85-4250-9913-0f6a2c276888/bd8483d09a767f6c19f9274da2819624/aspnetcore-runtime-6.0.33-osx-x64.tar.gz";
        sha512  = "f8dcf3d6de7a34d7fb402fd1ddf55bd810cccb95831d12312bc7607c6c7de8a46200c66d7e753250103961ba2e97fa6a85206b49442e1aeab1e290ec69bb55c5";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/74fa4afa-a6d6-4c32-8ef7-fe88148f10cd/c887bff014d198532ba942988cba124b/aspnetcore-runtime-6.0.33-osx-arm64.tar.gz";
        sha512  = "26a2f1d6cb3ef9df5b6abc16e025fc2e9aeda386b5da53428abae67d76ff007bc921aec60cff9675dbb7291db7b75c5a7bcaadb54e8c04de59308b02dde924cc";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.33";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/250c78ac-a53f-4679-ad2a-cc31fa4c4001/204b39eb9634a8dd9f39cbcaf56030f2/dotnet-runtime-6.0.33-linux-x64.tar.gz";
        sha512  = "0892015544d8903999f8e0fadab6b4b91eb180e495fa5e36c1a755b1d42e134858b7bdbfd60d1880650d9c528d07e31b9ccfc73e650e5d890a955902a89139cf";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/694cd8af-7e9f-4161-8c1d-1c9a7b1d074f/d3a8dc90d971ec4f135f6452c176dc93/dotnet-runtime-6.0.33-linux-arm64.tar.gz";
        sha512  = "c700d4ae3e361fa2a390a8fcf294a2277931b0ea60bd4a2f0ec2bb982bb6c618ba002e5955c3ee96807207b256e10289cf1cfa372029b758aefa6bf1268d45fb";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/82217487-71ef-43cb-8678-d293b802b5a6/cfe49dd7b7e0e3040d4fdc9258c61dde/dotnet-runtime-6.0.33-osx-x64.tar.gz";
        sha512  = "a0ad81d4bb361d91edc7b42142828fb5ac5b75376e6ad0137f7f28bba5c0d0b68c67af708bc85c15ebb7aac5f98df20bd83a56144a1bf9ac5aeaf5caf84e4128";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/aad5df88-c193-4579-b847-633186659a2f/1688cb1838ae0f0b67d16f3ed808f566/dotnet-runtime-6.0.33-osx-arm64.tar.gz";
        sha512  = "95d0e646f688e6f46545625dfae46d8325c7aee4661d3f0e59044acced9c6192ff51524355696e8f868ebd112e9a036d01c951f7249d863c300d07c1a0913d1a";
      };
    };
  };

  sdk_6_0_4xx = buildNetSdk {
    version = "6.0.425";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f57cd7db-7781-4ee0-9285-010a6435ef4f/ebc5bb7e43d2a288a8efcc6401ce3f85/dotnet-sdk-6.0.425-linux-x64.tar.gz";
        sha512  = "a04b75af7c5850238a8d99a6f60b37753467db615831bb3833c14aec86faa2d6ee9b8643885798924a01e28acff44ac9ed39c89f7cbe53c5cb8753c802e85039";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ec8e29f5-2fbe-47d8-b0c5-81f11434c00f/ba4bd30be448d649e5ddf1991bf76252/dotnet-sdk-6.0.425-linux-arm64.tar.gz";
        sha512  = "c15f95664fd0570d5b0cb94c7af6bba5fe830470004f0e958e49d53764714cbf8ddd620b38d487b60a27dbfd467a955856aab3df9c958cde17c942079fdaa55a";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ce410b9f-c7f6-4180-a373-bcb6528a0778/448c9df07432b5dc62d08868ccfef62a/dotnet-sdk-6.0.425-osx-x64.tar.gz";
        sha512  = "5757c661d82408680a6e45efbca260bb9da145bd83f8275280e9ba756a2827ce35c7ae77cb248e9ee6c6cf46730c6e50152b98c0a082c0de764f5e522dfb6ca2";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/24192716-57e3-4e69-9950-7840e05053d1/79398f054d34fb3e424c029e6d41a551/dotnet-sdk-6.0.425-osx-arm64.tar.gz";
        sha512  = "7383b188c8500ab8625cd34f69f7ec5a4d9ff4ca715f95ee020f2bd082d5023697b021ca4b3b1e6a0782fae2ff89586e541e454fedacdf1c49b42f6e47d12011";
      };
    };
    inherit packages;
  };

  sdk_6_0_1xx = buildNetSdk {
    version = "6.0.133";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3fd189c1-072f-4193-8f1c-663b68b9b06f/bf63007e0f0ba0b3d07f1af06c1dee6a/dotnet-sdk-6.0.133-linux-x64.tar.gz";
        sha512  = "7b4fe0095bc6d3ea43fc3b32f2fc2ccc8fec83b0c50ff74b9e9a019ed40721f46c60d7b3ac08841a5f89d0802d8c347b14a445032a00f3d9a8661558b9c74794";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/759c84b7-4d67-4eb4-94c6-0214d150db31/aea9ac1878560278c50174ee213d88c6/dotnet-sdk-6.0.133-linux-arm64.tar.gz";
        sha512  = "6820d62ced6d9770ebd3667a64a74e2249471ee5920e4ce4101f21e55950f8d44ebe4ffbf20bc66260fd5d1edc5e534a6f0b70522fc41a5e48e75b0bb00e6ea1";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c8f09b91-04fe-4d0a-8d01-0556c53f2a5d/cbfe49b3182a2c4ebc7aecd22b6ac881/dotnet-sdk-6.0.133-osx-x64.tar.gz";
        sha512  = "e142785256b731abd6f7bda79b1422ba6eb9135f61526d6f687be67146253403cbec85d3ee66f49e577e7f296b32f94fa705ccf048292b1c00f981d2ef4fd52e";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/fee562a1-baa6-4e8f-a3dd-2c49eae8a891/564d31d1daea39179782c413f99c6160/dotnet-sdk-6.0.133-osx-arm64.tar.gz";
        sha512  = "c0193152166cefbe60a7cbdb4af7e2df365c9e67a0ce0ff5cc1aa06a46d4ffd6cccda3bf026a47116f02e4c52875fdd704aa380817dbc3eab653d30f4f5ffe20";
      };
    };
    inherit packages;
  };

  sdk_6_0 = sdk_6_0_4xx;
}
