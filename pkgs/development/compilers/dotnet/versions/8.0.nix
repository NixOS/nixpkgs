{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v8.0 (active)

let
  packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "8.0.6"; sha256 = "1wgxqrnwhxrss67qm72zwgvf0wzskfpq6jmsj7qrl5z035v6wqsk"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "8.0.6"; sha256 = "16m3qvial8wm0p56wf1135fl1v71fv4lmxqgfp79nrs0p5hrvyy2"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "8.0.6"; sha256 = "0qaq8wv1xhr3wm03qiagwyrks18xg81m23q3fw2i1wq61pb3r7b5"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "8.0.6"; sha256 = "1834b3cxmjpxw9q9b6i7a3rkjy1rmcxv3kvnwzbyszn9k41bfcd0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "8.0.6"; sha256 = "1cx96knhh3nkjd0qasw8z89c9f9y7agazdf8ba61r8ir3k9nmh9q"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "8.0.6"; sha256 = "1a7l158y6g2dmrviiisf8qzmnmv5zn5r2cdmrdfwmcsqg9n3dcxx"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "8.0.6"; sha256 = "1m71clfwd7gcgpqblp2q8f4m3a72a90jfv6iif7j3v2wjhmg6ckc"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "8.0.6"; sha256 = "16ln87byqnf7bd8jp5p8lr9blzcwpnrxgsznpv3j4kf7a48q3cip"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "8.0.6"; sha256 = "10dk5lwimgbj436asx89wnghlr2x0lm09yc9c642f6dy58g2fgyl"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "8.0.6"; sha256 = "18y39dkflh9xyga94nhm1xvz9jpz06nd1189k92mp410zv940561"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "8.0.6"; sha256 = "10h4v3a847h0chxs6q88133x8kbx3g74s8zvb5p0p0akkmljyx69"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "8.0.6"; sha256 = "11d6by5vd18vri4cfwfx1yv62dh8bh5q8s63ngrmx84f7vdis30n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "8.0.6"; sha256 = "07ghgyk9j3bhjw5ik8dv57r4yvri3652yzshvbvh6rh6l0b10ylv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "8.0.6"; sha256 = "0i13a09hrglpfzh130q7cdys49s27k1kafhqkd7d524irnid6hpf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "8.0.6"; sha256 = "1p3h4mhcx1f6m667771blxm13dprrxq3kgpwmxpmiv2qkgqgy63g"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "8.0.6"; sha256 = "0asaa081vq2m7zcawld8r2zhf1i1ch4sj0qj5c4w2d2wynrc3yl8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "8.0.6"; sha256 = "1npwnm05kz368fyx2fli6k74zxlmbkmnpzs0bavcjdqw91m72rn6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "8.0.6"; sha256 = "1qhn6d2nax5pak9nw0ly09lkjgx26ir06a9kbqsrd5al2if7vxmm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "8.0.6"; sha256 = "1102pac84v6740nwnh7w40lkdjq1qq0v1f1d93zbml52w1k31hcf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "8.0.6"; sha256 = "098x9l0adam6nfqjs8lisdjv3zlmic9jvf0qf7b7j0cazpsck437"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "8.0.6"; sha256 = "169drx723b5hgy4jav2pj25hfxjj3vzs0aj86ck7wwiwkzjnn714"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "8.0.6"; sha256 = "1slpg1gjhmwr1a2yvbxn1qqjpsrzww6552fbqq6gvghdkbjfis0l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "8.0.6"; sha256 = "06d6jn7fn61iynhqbykdpy37mdi0l46cidlz2s2gn6vlwpz0h150"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "8.0.6"; sha256 = "14zjhrb208zxa0xc2k9lm7s9507rvap9fhwsdrdkf6nd3gvdfmyz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "8.0.6"; sha256 = "1dh3nynradl8gnilx02zv4qgqjq81cmszrqx3kamki05dbga4v6q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "8.0.6"; sha256 = "0ngsjx4pxwig87y9n9z538y9kh5kwkff3x7f2kkmi5h19kwdkwk8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "8.0.6"; sha256 = "0qgcmxhyhbxyrs74l7700psxpfyj17q4mbsrvd7112h8yyvxvspn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "8.0.6"; sha256 = "0q3nyjdh4n5kgsxqkq6sj5kngra40lhq4ms3p097m0aj2225zvfh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "8.0.6"; sha256 = "10ihdkap0l8dvixp9qwc54n9397smfnivqhcv56vgzva1ys4fp4z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "8.0.6"; sha256 = "01r85dmhca8k8791l0p8frw94bnaxm5x3imcmpb9nyflw5cqvalc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "8.0.6"; sha256 = "0izgwc1qv5dfimxnl7aq13qbviyf462cw7igbgzzn1jqrc8j77fx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "8.0.6"; sha256 = "1dv5xf8bmh4q14s8vnjpz8xvv76f1hxpl2w485v37a6znd7jcbjn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.6"; sha256 = "0isvgn41x6x9wdnf8phn84b3w5ir9r6drpawrrbbx099gwzzay4a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "8.0.6"; sha256 = "18gi6vrqamlcv6js0bggjj0gf7q9qzj9hfgps480b5qj7a4lsw6z"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.6"; sha256 = "16swhnl9zyf0bijhwy6gixp4brf7nc0avlhh0rh3q3zknfa32mls"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.6"; sha256 = "07p4s12pkyb7w60g2h18155lida80xwycbyp2c98ak8zrk58j9hi"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.6"; sha256 = "09yz8isiaka54h5pgp7d2llzl11262xwmv02q20bla1rmax8d0qj"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.6"; sha256 = "17q5gzg4r9ljflahnp8rip66bm34sbj33hm0a32m3hlkpjjs302h"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.6"; sha256 = "1kynfwp6aqxiazqy970r8dbpwdl88s1acfwinj8wq6dj125brhyc"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.6"; sha256 = "1xhi7nakjskr3cnsdg5cx0b6ijmmzj4kaawcqwbph06gfbf9s07m"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.6"; sha256 = "1sfn8mrfy5w6piirgqrla99v70g6csxc7sibj52r9iyw9x1hwm1z"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.6"; sha256 = "122h4b1ndpphcap2xigv4l28a4wyhpv4kj9q4zjsliz4dc6bfmnx"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.6"; sha256 = "1825wj7ijw7r9552lq1wppcaqhp1ncigaw8wn1yg82invmshflf8"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.6"; sha256 = "1gc39h7lna08dgrp1gxrzh6m4wqlyp12vbsyh7mzlpbiqdi9bbvp"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.6"; sha256 = "02gc74yx87riml3aadsm9yv7y6ylamicc0mpd5wg91b9vzsj236j"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.6"; sha256 = "0vgh3fpgagkbv0ff6r4fczhg2lq44zshf6sja96ja8wafsjby17s"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.6"; sha256 = "012fl9873nb71v2fgfzg7d35zac7hn13qfqm7201sl0fqs42iyn9"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.6"; sha256 = "0ajr9bwa9jlcf2rwpd7h06q457jhfm01hlzsp6yz3ix8ilbghlv5"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.6"; sha256 = "19zqzlq1fbri10xis3q8h2l8fcjmgllsxyp84yz93kwxh82yakl1"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.6"; sha256 = "1yg9zrji6dqhi9nv89bznbqm7rr167axx5s1rnc1p6g8snpy67yz"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.6"; sha256 = "0hn0kyry6hhrilj957qaa7nxb34ix3hsj8293vlnqrsdfcn3r3v2"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.6"; sha256 = "0jlpz6xpidhj42rnirl5mn8agxxy6nlym0a79nqblznc6nfsk3mp"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.6"; sha256 = "1z6n3gfmmpb291r4ns84lz9l7gcjyfbbqwidc7cfidlf0g87j6kn"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.6"; sha256 = "1s4wpsywinfp59nbpc66l8h4f6r3w2abjdfz0pbw4inqqxdf16qr"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.6"; sha256 = "1vd3la5sl9az2kh5g3i4f3sh6gjwqnq9lijj9d2rzq6wlbg0ygi8"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.6"; sha256 = "0hrwgjz94swf1zdsplbdddzj5afnchzsrd8wf5h25x6blq0sk8hj"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.6"; sha256 = "1yh21ypyzjlzz1r9b1f987pqnhsy1hlb1zw1v4q4zf52v7ja03kn"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.6"; sha256 = "0k2g7vi1d2d4wddyccxhzbj1zrj50819227lggmd8hmfz50qdm4h"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.6"; sha256 = "1yk87srq1i7n7wihzadsb6yqgi74aybk4n0n8vbgqfgfk19aipif"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.6"; sha256 = "1j5b7kb0lj0nqp632plpv4hz9blfwvslx82l4nk58lfk9n37dlsk"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.6"; sha256 = "0qlk7cdkplc30isb4ljk26x7pnbiad6lfnjj4h4m9l5lz1pfl1fs"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.6"; sha256 = "072bm84fw6q8q1a2dvwn6m176l4vj8kjkzwjgd78ihg34gdiz125"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.6"; sha256 = "131gcwp0nisfil3cf9is09cc9dbrv6kisk2llzfyq7m1wcy3ixqz"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.6"; sha256 = "0vwfl048xgv2fwhym10b2hg8lmviamaxs7qkf96pn8s67b2h39ks"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.6"; sha256 = "0flfn8zkq1ds72wf66f0sqahm6ab4ajc28dcanrpadyc1vxyqm34"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.6"; sha256 = "02xsrxwag62fnmg490l920c6nnyjvxxashjikf58ysfmvlsxvpbw"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "8.0.6"; sha256 = "0mvgb6fjia8ajds872g5ycwb8885d0fhgx9wjp3r9rcxb1cgkl44"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "8.0.6"; sha256 = "1mwiis128nmljsim4phf1ms9r9ww9wg950fr3k0y89j9abdfbdmd"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.6"; sha256 = "0kmvd79gf3gax266f8gh41px181anh6mpdj6ys2634f55syfyvb4"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.6"; sha256 = "0gg64xa48wg9vz4r896grd0xqdv4l8kcqlv0pccfaslmlja6f9dc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "8.0.6"; sha256 = "009ych2a5swg9cbbzhyy23rjisa5hcm683hwd4f9sjg9j6yxdyzw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "8.0.6"; sha256 = "1gnky9ippjpdbrksbvff13xyjxyzw8k2bapqiw3mnivy4a4h4zcf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "8.0.6"; sha256 = "0miwpwm3y97jz7345c6fknhgrwr8gacrgs5bbb638vfp6vw2jb7h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "8.0.6"; sha256 = "1j9hfqiz5gqsz91q5snywzrql6bvxczj9yk4jmnp47kp9n9fwi2m"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "8.0.6"; sha256 = "11lg910fgdnh79lmpc0v501a3ykvk99c015w3nsf87pb2hsfgmi8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "8.0.6"; sha256 = "0w885xnxlyvrlyvddvlzry3jscy16dg6mxk585fzw046yww60318"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "8.0.6"; sha256 = "0sz8pl62mfjr65jca4j15277a48ly943l0agwpg87l61pybxlqny"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "8.0.6"; sha256 = "0mi44y7nz4n3h70v6v0x4ldfg3ma9wp7yys6l5rm551dbsmfrpbz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "8.0.6"; sha256 = "14hhibn8swy9d0n1jz7sbdc8z0qahn40m10ras18yl2cy717bdvw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "8.0.6"; sha256 = "1gapc36yd1a9q12av0hz9jqjlilmqp07zbwpzjdh7pvsp5vygf0x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "8.0.6"; sha256 = "0vbhpg42sgjppqskz065z5h6bz4rn5xizffg7znw95vbxwclqmn1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "8.0.6"; sha256 = "14h3qfwp27zzi6l1rh98z47yja5l7aa8pvc0cx6fcvqrlrpz5c5g"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "8.0.6"; sha256 = "01ss9lni310cjb5d8ifrq5arq83mhvxa6dnisk7rgh0y3qc635nl"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.6"; sha256 = "0rcvc38vmr58mwyc0fqbdlgh3iaq41y9djlswniplc4m3m0llq4v"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.6"; sha256 = "1lmngy0101diwbb84f80q71qg10whm38mqfaa8n63qa42q7niski"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.6"; sha256 = "0s2ihbzjvq53npkjp40mzknm1q6s5bv4wpznqa8y2s29f1am8p8s"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.6"; sha256 = "0l7ysphsimif6l19z1awvqmpkm6a16d4ymxn08qhqf9yl8ywr341"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.6"; sha256 = "1qir2zm02wf133ak5pw8fs7gzmixz1hh867zczclf6l2swnxhb6q"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.6"; sha256 = "1gci3c46m16yf045w4vsgi8fjvsmqblzkjj2fd4d03h789spqyf6"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.6"; sha256 = "0kjqc9x3vna55prp0gc29ndzysdrvzm8lq7fk907xhs1655xly0d"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.6"; sha256 = "0gqbcgakcimdmdhyif036r00wk1mfbqir5k513nzv4vi2gbxiypj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "8.0.6"; sha256 = "1b5155pcj5j3y7irdjn8ba7rhcfm9vd8cwmybdn470r89frq7qf4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "8.0.6"; sha256 = "1hwrgwil7na9my78wgphx9hjd4qjj5ayr1hx73bglf058mi9kgsb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "8.0.6"; sha256 = "0f9z837gbyi4179xgrrfmvhach8iq4inknihfwpvrz5jlmg48f3k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "8.0.6"; sha256 = "1jzr4zj9wa68rn8zcb6wk4sy8fiih8sibsdvy89029x9f3qgchjr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "8.0.6"; sha256 = "0aigvzg1ppjpr4mgg56hmkfrqg89zn3vyrpwz8cfysjbqz356xx9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "8.0.6"; sha256 = "1628i25saxmny4k8zzhh6nkz0njlvmi05f1m2sx976flqd3kxr78"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "8.0.6"; sha256 = "0fz0a4hm8lf56r5hff4vcz6pfmwfqygddm6cyxj04x63wqd16sl8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "8.0.6"; sha256 = "1bg9d8fcwr7808vbakkgrzry4wf0l7r28xn9hsnh14awsqprngid"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.6"; sha256 = "0l3pibk6q4hhinf2ki42vcc6kvvi5x4icm8bpcnm9iss6kafchry"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.6"; sha256 = "19wwim19f1aqscvya85chbycj30ns5cxr2ga5jfrkxbyni9q557m"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.6"; sha256 = "1bggciasdgh7yr9vjkfq8fjxzg8lbcj4cd16slcr8kkpqy1lj79s"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.6"; sha256 = "1zz8d3dq0n58qnxb4y1njbgls5nfaaqibgxq4k3s5wnclxp8fmys"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.6"; sha256 = "0l6rsnf39m6fp4p8bs0rl98k36bj4yg2q49hgg89yf7q3r5xka91"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.6"; sha256 = "0cqm5183as2m3nsl9as00qm9928bani6gflndg0fv73r799k5raz"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.6"; sha256 = "0yjji845ngsaqxyg2cmngj3vba8v4wyriv0qz4hgn1wbrramml6b"; })
      (fetchNuGet { pname = "Microsoft.NET.ILLink.Tasks"; version = "8.0.6"; sha256 = "0slfrm65izibsxg505vr8m4k6n2a2kl4iqyyr9xkgr8541g7rrs5"; })
  ];
in rec {
  release_8_0 = "8.0.6";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.6";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ce31d92b-b514-4f9c-843b-29c466871369/b332eba5641cbc6eed1e3a98480972d2/aspnetcore-runtime-8.0.6-linux-x64.tar.gz";
        sha512  = "16cd54c431d80710a06037f8ea593e04764a80cbaad75e1db4225fbe3e7fce4c4d279f40757b9811e1c092436d2a1ca3be64c74cb190ebf78418a9865992ad12";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ccdcbb70-a5e9-4753-b6e3-4461ce56a69d/240803fc1ffba38ab3603778c03e9b87/aspnetcore-runtime-8.0.6-linux-arm64.tar.gz";
        sha512  = "9ed12847e404a0a4fdd8fca33a9a787c5ac2e6745d23821c7890f731f2f8f5682e7f9166b2764b13b612b08e091c71e13359b68acc11bcf990afdef1d42f6473";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ccd03400-c514-4956-9e9d-ad1bd67d1338/436b9590788dd3df98e73d4c5379c711/aspnetcore-runtime-8.0.6-osx-x64.tar.gz";
        sha512  = "61786ecd784b83eacfe4dd901bdd55474e52d9da85806b3d52184e8e35a3065b476e574c939f3af491a925bf7f04fdf376c53a25c103a187a7939f4736158297";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b90758d2-834d-4fe7-b97f-e8294b68d07c/71d63df9474999f831811dd6989d9ba7/aspnetcore-runtime-8.0.6-osx-arm64.tar.gz";
        sha512  = "85d82e90182375ca21326e3d57be0dc5a39d7e64f1a4005950fe21c720f1d1e1615f64030c950fa7a49f6a104f029b9845648cebeb98d48d892aad3309c583c8";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.6";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/021c3de8-14d5-493f-92dc-2c8f8be76961/6ee3407acebf74631bfc01f14301afa6/dotnet-runtime-8.0.6-linux-x64.tar.gz";
        sha512  = "c0c5e93d4e68e2075c4c63336dc74246efb704ac9663411351efdefc4cc7da5a7750f44b8a23aebe959bb4308575bead443a41b2524ae03b29ac41929d27e0e0";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0039e2c5-d78d-45fb-94c0-e258ff0335fe/c3bff45767f679bbab149398e9ee2c6b/dotnet-runtime-8.0.6-linux-arm64.tar.gz";
        sha512  = "428c5a81938273c5e63b04858dbf2f4e82c9bcfa3bd33f954081238be2fb52aadce99296698eabac72e4be55c61e6c1ff06d2d8d1fd5d6a2d0c7a2917cd50739";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/20271d05-67e0-4356-87a9-0ce5102b5007/b7c91c6470e1c2ffbb493a35dd6883c0/dotnet-runtime-8.0.6-osx-x64.tar.gz";
        sha512  = "44c0ad9fc613975fa0c12b12b91ff8cd8ba0be5e8ed59510e7a5ab22e55267a468b321ce34515daf070ffc8d557c09d7ea3ed3c3407887f706553b5d378e3232";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6f090da0-5f55-44f1-ac17-9bd001b33d66/eae314b23ab350b375e794e136a2ca9e/dotnet-runtime-8.0.6-osx-arm64.tar.gz";
        sha512  = "21ae6420914e45be9fe17bfb0c89948eead27756dedb13fc2c6b9b08d78aee80daa2b8cda358268c819f00ba7ca33ed75e21bed387045b3a62160fea159eaa3c";
      };
    };
  };

  sdk_8_0_3xx = buildNetSdk {
    version = "8.0.301";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/86497c4f-3dc8-4ee7-9f6a-9e0464059427/293d074c28bbfd9410f4db8e021fa290/dotnet-sdk-8.0.301-linux-x64.tar.gz";
        sha512  = "6e2e1ad5fe3f00e6974ad3eac9c5b74cd09521f19e06eb9aff45a44d6c55e4a2c1cd489364735215d2ea53cec2a7d45892a5ede344a8421be9ad15872c3496a2";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/cd9decc0-f3ef-46d6-b7d1-348b757781ad/9ad92a8f4b805feb3d017731e78eca15/dotnet-sdk-8.0.301-linux-arm64.tar.gz";
        sha512  = "cb904a625d5e4ef4db995225d6705b84201dc7d7d09a0b1669baccc86e05419472719025036dd78983b21850f7663d159ae41926364d1d3ca0eab62862f75d29";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6ef47a54-b1c6-4000-8df4-486f64464c2b/ae87b597b19312fa9f73b9f2f8c687bd/dotnet-sdk-8.0.301-osx-x64.tar.gz";
        sha512  = "5d91fbc584f32f4d48dee303c7eb16b38b2e2fab9549bd54293bac28508a6d53f93782ff102266010f8cd8c15c6436a807a7e6efede2e1051fe206957ba73071";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c503e53c-0567-4604-b7a8-1d6e7a1357f5/53e78f56b01147a092c0cc273b443550/dotnet-sdk-8.0.301-osx-arm64.tar.gz";
        sha512  = "8d56980b6a6ffd78618a6e9833126d7e67052ca6041bd5f167a32e277aac7094a5cd37b9e7e145d5c9b74da95561535189a077d074ddb0fe710a76c2a2c9b1eb";
      };
    };
    inherit packages;
  };

  sdk_8_0_2xx = buildNetSdk {
    version = "8.0.206";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5fd599e9-4bf8-4603-8a14-87777293837d/1d5f0729055901dce471570bb82a441f/dotnet-sdk-8.0.206-linux-x64.tar.gz";
        sha512  = "d03cbb5ea44a6f4957d7c1fa0f7c19e3df2efcbf569b071082e37ac86776af0729540c3bbddc44668ae2eedcfcb4b098883bb560d26418f1583a558d60c99ef5";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f25f9e53-deba-4c1c-b9d2-5e026e5a4d92/c291c78eb71c30b1c66745dec87936ce/dotnet-sdk-8.0.206-linux-arm64.tar.gz";
        sha512  = "eb0489785dc5bf824bc3fc1014815ebd371fbc73eb02b63e5a1650bcadb158cab7e909904889f6e198a180a1742976351208a57796ef38a4205c52fb945b7d09";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ea0371ce-1119-416c-bab1-578cb8c1fa77/71cb9d66778c8e2a65ca40d8456300ef/dotnet-sdk-8.0.206-osx-x64.tar.gz";
        sha512  = "d7742a0b00c4df835639eeb18f2ae4888ac33d7d7c25d097a8868c5172c878d7df8c5bbd54de9b34f877f07a2dc6c748ea510f783e1842058e8cfd0ad2cda83f";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bca24333-c463-4f90-8085-f856962fac39/ef02fb556ff3d92938a2c11e408c7d71/dotnet-sdk-8.0.206-osx-arm64.tar.gz";
        sha512  = "c4a17c17b02d9559e0029328179d22617321e439e9360175f25385d60789f91582a4024ce41690439d85852e4c85f0d0ae20fe818c0f4acf0d7d48ffac2d2b5c";
      };
    };
    inherit packages;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.106";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0fe59d31-bc28-4f57-8d1a-285f47b5a0ec/e4c5def191daf9f999efc5812b085924/dotnet-sdk-8.0.106-linux-x64.tar.gz";
        sha512  = "06eecc146b16eef0654fb4fd17faec06c6dc1b7236acc7e4a33e4b13cbea1d725faeb9eda41a0c12e65ec4c89d6624971429ca223638387c66f1d3e4dcd1407b";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/34676827-2699-4f0d-81e3-347939a91b7e/6f2f3851e005f57f8b6c132ead1952e5/dotnet-sdk-8.0.106-linux-arm64.tar.gz";
        sha512  = "e8f735d20d79b20d24ce5b2f7c25c60604cb6b694b6572488c654cbf14a4d99c269f64f4ca23ab78aefaedf14f35a0ae1f33adf6afac5556e2ebd22ec73e04eb";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8380cce5-930a-43ff-8a27-981e175d9881/4ddeae425c3c344f4afd8adddb03af5b/dotnet-sdk-8.0.106-osx-x64.tar.gz";
        sha512  = "4e6d45b7b1618bdb528a865d1c89e7ec7750f8a73ae7e805675dd9d7d3974f0b19785e743298f0c468144cd7fe9e20e521f65e9fc081b89d8bd9e187b5783c2c";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d595db17-776d-4b09-aefe-44777823a4de/55867e85ac1b03cd5609a936055c8ee1/dotnet-sdk-8.0.106-osx-arm64.tar.gz";
        sha512  = "490c20abc3cf52f76fecf422a6fcc66c98b7500a56986f84e617860a2758f43ddc4b235647837fae69e4c46a9d1ab9177d4bbfe134258797599b69178f6b91f8";
      };
    };
    inherit packages;
  };

  sdk_8_0 = sdk_8_0_3xx;
}
