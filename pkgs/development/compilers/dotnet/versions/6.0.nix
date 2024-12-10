{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
}:

# v6.0 (active)

let
  packages =
    { fetchNuGet }:
    [
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "6.0.30";
        sha256 = "00h28rynbg62abjgknxlq79b48qnjjjclib638wpxjaz96wih96n";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "6.0.30";
        sha256 = "1n4v5przbrjhzj01b6qijpdc2jbsxr66ijvd0483qxh4s0b4jppr";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "6.0.30";
        sha256 = "13cyagv2gxzdssy4kch80jalax0d905sqglibnp9ncswv5yv7af5";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "6.0.30";
        sha256 = "01n58418vmvz3bxm3b175irfidp42vg71m5b7v0bf5mhifi40ji8";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "6.0.30";
        sha256 = "18v0l07q74m5xxaf6y6dkmr6and8ivya0nslffnr4djrxcbiygdr";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "6.0.30";
        sha256 = "009srl8vazkjnd93xr6k1m353spbki9gn1yzp4zgazgbrini6rqc";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "6.0.30";
        sha256 = "105zskdc8d7papsi5b8pf76335j4slkm77jd6k5ha0mp6n39a1m2";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "6.0.30";
        sha256 = "1ppl5zc8j6z3yfhq9wkcmjaa0yajjy4d4iiykh8yqsjypxg5pq95";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "6.0.30";
        sha256 = "07yaxq68gjnc512nwvzj3h6xk3w1bj9gl25k0qpljnxfv1nmba8y";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm";
        version = "6.0.30";
        sha256 = "07jhykr9q5akxy2vcsp6w8646j78p636cn13qcbybcxapz7s0iji";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Ref";
        version = "6.0.30";
        sha256 = "17k3l8xd5bsyk69bm5q4nxbpb4i0izw1kzmzi7j3p8pmm9prgrpy";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "6.0.30";
        sha256 = "05ffs63h5f8qhxzrkhq0fwy40q88nf6672xgx5q1zm3pa0a4zpdz";
      })
      (fetchNuGet {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "6.0.30";
        sha256 = "0p53lyqmr5n2ym202pbgmsd9b9aa6jar7ic04dcq86h2g77r5jqk";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "6.0.30";
        sha256 = "0nzgcfvzxkkf9qgy18svjgwsfhhpv9zz44kcyv5qqv3hjnn59n77";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "6.0.30";
        sha256 = "0l3gjhmnjd5n67w83smqyhmfcwzszafjgcbq8kdwxiwwh2m6nh2i";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "6.0.30";
        sha256 = "08xwqfqhazjy1gwj2j060vcn1x429b37db1h20mjcszmr6j55bb8";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "6.0.30";
        sha256 = "0kgpximwlw0ypjnpdvnrvgi3k72r032c44ik1vamka6ilir5gcsj";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "6.0.30";
        sha256 = "0ss3108c2h7afypvliyqixv4dll60sq9iwqy90k1p132znpszrmb";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "6.0.30";
        sha256 = "02x38c68xan8hlr59mindcl4rcx49bbh4bibh6fw1l4rrijb38lw";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "6.0.30";
        sha256 = "0qmma776whn57fnjqkpacj03vx6brcx6j51mh200v9gx8hm9h1gz";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "6.0.30";
        sha256 = "1000y4ap0k0iaidl8bqdais3dpcnccd7f4mp219qfcsbn7ma1g5m";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "6.0.30";
        sha256 = "0dcmanh6bpkiix9nm516ybfd3jijr5f4m4pj2b0f4lzdhgnrg5bj";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "6.0.30";
        sha256 = "1aj6dljgqh7ivbbzzqisycklc3ffy5hav6rr78pi20kqr60hgv2d";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "6.0.30";
        sha256 = "0xfhcig3gj3986rxp3dhnd8hvnj4nvyhz1fz7kpx342d3g53wb37";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "6.0.30";
        sha256 = "11c5cirdzcmv1h88frjpdzknsafmpzxz6k3k5viqs8dj0pkrx9w4";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "6.0.30";
        sha256 = "0yc0kx6nlfq2hj6392m8jq0gkkc8ayp6pndidwpdyrgxr6dcgx5p";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "6.0.30";
        sha256 = "1s81sj8lnb8szqawxh3vc8wi815ln12cyhrl3f7hwcpay57xgswx";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "6.0.30";
        sha256 = "0xybqg2wd240r1nm2vrbn2qbfqfnqsmxn1012zzwjn17wa2si9a1";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "6.0.30";
        sha256 = "1f8jid6hzbgc69i3mrhr75g4yb8mxky1xddzsq6vm5bhzdi9x9dq";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "6.0.30";
        sha256 = "1iv7mxzyma90s2w6pgcr9gb4b0yab0qgd43ljbr776r45jfmhfgy";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "6.0.30";
        sha256 = "0h63xlks92kmgmzi5vcciw46h9i982shqjsy5w64hxb2m28rrali";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.DotNetAppHost";
        version = "6.0.30";
        sha256 = "1nmcfcrhlvyyxgsiaa91ssp691yl3y4p87azsnmvy3p97xppn89w";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.DotNetHost";
        version = "6.0.30";
        sha256 = "1dl58ci5xl0np15mbya16zaipscmvhm3914l2f0pfv1k530c9j7m";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.30";
        sha256 = "1ik2aarvg0r7k5mm47y7z9lq1csx84k5sd55nrkl2bil0x2pwbzq";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.30";
        sha256 = "1n711qbd40468l74fr5yjl92n38fsvcdxcl5i3vrqxxqw24rk2v6";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "6.0.30";
        sha256 = "141ik8krp675ra085b7w4kwslwxdfhpbgkwjwix0l3idkbbqx61x";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "6.0.30";
        sha256 = "1xj1g4j7khd54lk04wdii1mam6iwa61aijr43bwfrl3cwjlyk0s4";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.30";
        sha256 = "0h419n0wzpl7g19g4vwf9s3c3n7vpshyqzfb28w7hy9jk7svvhs1";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.30";
        sha256 = "0d9g5yimjmvqgfm5ndyzb7v5xwi0ix0dq6wxinlfcv9jk933bxis";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "6.0.30";
        sha256 = "0v059yadlahda6ifb84rhpdf5lwd27pkgwfyqdgmqbvc55mvxbpj";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "6.0.30";
        sha256 = "048nxp4xckb367b016r0avzwkfc6acvw1y454466p9ib29kahc9i";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.30";
        sha256 = "0ah5lzn0al0p73mv2ifaqfal38pq7v7cgjsh2byqpylg4fj00lgw";
      })
      (fetchNuGet {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.30";
        sha256 = "1d7vxq3cbqv36mpl1lv9xj6v6gg5x1brr2z0v16zb1sgc20c1py0";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "6.0.30";
        sha256 = "0im0444rnfdjb088mkgj5nwmlh4qqi7cg29dp7c7490h9b4si6sc";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "6.0.30";
        sha256 = "0zl6h8nq6c5jnm2a4sn39wsqy05iv1s8cwwxck1xxhc6xhvm7ssz";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.30";
        sha256 = "1b8h3clg8fhx2lg1znlidawlr6y230rh7fswz459p3y9a5m2g5rv";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.30";
        sha256 = "00zc5ym89ps8f000j3h7d7fqcsk8bs30hx91yd3q8aqcacwp5qwf";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "6.0.30";
        sha256 = "068y16a9966g5r6syznpi445z753h15dngw9dr5z8dr2rpzvjmdm";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "6.0.30";
        sha256 = "04i97cy9x3z0cs738li44s7zf73vspjmqiw70vi7bi6lsnf1n393";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.30";
        sha256 = "0ra00mpz0m4wchxxay0mzk0r4dslkkjbkxfwv3agfldyl20hdh8v";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.30";
        sha256 = "1dmqagg5ygg6w2lmg5rh165chb06q5lalyz0aggd7d10dqyjqdys";
      })
      (fetchNuGet {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "6.0.30";
        sha256 = "01naz5yn790qd96pq00pb17s0cgl82ai9l4p0psgcj9hdazhh5d9";
      })
      (fetchNuGet {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "6.0.30";
        sha256 = "1pfl0sc6z14imjlxdmacs6yb9mfgf2pb0jqxiwsdxrc9yhvkcy4x";
      })
      (fetchNuGet {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.30";
        sha256 = "08vdq131yc70hb72dh9ira28c894b0fwg71ap8bkdwv3nlj92xcp";
      })
      (fetchNuGet {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.30";
        sha256 = "1b2nwjw1q8696j63rfr6b9v3czprj3vnydw5sb1c4dy8rmi037g1";
      })
      (fetchNuGet {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "6.0.30";
        sha256 = "1v4rc0zxiznmg3xzk0f9v780nzrycp7gcj10jpc5f1w7rw9007ch";
      })
      (fetchNuGet {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "6.0.30";
        sha256 = "01r6w4j991lzirvb9nznsjq0825j5pa6mfjvacy6izjqbivwcf53";
      })
      (fetchNuGet {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.30";
        sha256 = "060xdk3fazza196zgg5q3r10p7h9nna90zc0kffdabg6j2msr8rm";
      })
      (fetchNuGet {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.30";
        sha256 = "0z350zy4c4xz42ysac40sacvky7lp0n7lyl1kh393v0bnzqad5zm";
      })
      (fetchNuGet {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "6.0.30";
        sha256 = "0h7c58nx1l77n1s28ysqbsij9408g2vmyacxryp56k1l30aspnri";
      })
      (fetchNuGet {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "6.0.30";
        sha256 = "1nf8p7a8qghpgpyh5hq8f75w78vqy9airb3nkhp600ln0h3rzwsp";
      })
      (fetchNuGet {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.30";
        sha256 = "0579hnk8xiclfzkfdb64628h0r49l8sac3mnv5yrq8sp3kkf8f4d";
      })
      (fetchNuGet {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.30";
        sha256 = "0flcc2vmy9sj40cc6igmb26zflsabp6vx9gzabhyns1lwnkwbljw";
      })
      (fetchNuGet {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "6.0.30";
        sha256 = "0zcsj0zqr2mf5134v74xwvsikxsr4g44qkh16qxkhdai1fi9z78n";
      })
      (fetchNuGet {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "6.0.30";
        sha256 = "0zwqi277hfiqj0yinmvakw6dvb4njj35yi618s96h94c4dz5f64y";
      })
      (fetchNuGet {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.30";
        sha256 = "0bifshrxl0g2q3xby4vy4bfgjbhy28r1jcvfr7y2vl1ci0a7l7q6";
      })
      (fetchNuGet {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.30";
        sha256 = "17nj6zp7z65p1gbd0rpz0fgiwgh3sikd1b0lvj006gz9njldbkki";
      })
      (fetchNuGet {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "6.0.30";
        sha256 = "0yzrn1261ypm7y8l3klpyswkav8qxhnlxsv083nrw1z83sbs6a5f";
      })
      (fetchNuGet {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "6.0.30";
        sha256 = "0q5i9nzwjdl733vqx3rp5k9favjz83yrvpwr953wm0jmcddk8gz4";
      })
      (fetchNuGet {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.30";
        sha256 = "1dhd1zczam6s5r0lwdanm3mvvjrwi6l81izb5v2aq4h28g67ciz6";
      })
      (fetchNuGet {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.30";
        sha256 = "11lqxmcmlhxgj1d4ki1rng3ivs2fx8ny984vwzlmcyhc2y5rz63w";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "6.0.30";
        sha256 = "0ljzirp7nx1xmglz9arfggjaxysg0iaqajck045z31s5dr7p70a5";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "6.0.30";
        sha256 = "08k5v35mvcs712kb0vcfjd1dsas5rgwrmv8rn87mzjb2p6ajl3n3";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "6.0.30";
        sha256 = "0p9qybbi7m797svki92ahsyxchd3ic6xw5dbd6h7j2zacgwwkdr7";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "6.0.30";
        sha256 = "0s71k92daakzwish65gmn4nniy6bf2hv34c0sb6m1hv3criqxmp4";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Ref";
        version = "6.0.30";
        sha256 = "1wqqjhhlqz4dmijcx3kg3hnwq0s0jzqsddaksskzhq8avr4ziy18";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "6.0.30";
        sha256 = "1zgspjf5qsl6nki9flfm5askgs2ryz6n3b5vz0sh0cygjk93mifr";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "6.0.30";
        sha256 = "03gi4ckn2926am1m5i4pimxlwzb47s5bvqcarw8gchiw6ids27a8";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "6.0.30";
        sha256 = "1vp1r5jsphj322dh441fs0723riijdqcai595xf7fgdlhr8kqgqj";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "6.0.30";
        sha256 = "1snjxdqm7bn9p87m8hbv125qbz2sgdy59cz5icld9qgyvx6c65p2";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "6.0.30";
        sha256 = "1pdwyi7p71h8418qcjypl5fzvdj22grxiq9yjpnw1qma7d1251ny";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "6.0.30";
        sha256 = "125qdpv0j0my2m47cdhqacdx3jnpm0f7xgyi60x539iadg9w5n17";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "6.0.30";
        sha256 = "187nbyjgpj64ap3kql0msynrfrjkfxi7flap67nn3ly844l08h1x";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "6.0.30";
        sha256 = "0j8rqm3rfl3x7azpkp3l651v4hdd3rchfm40vd291pcc90qicqd8";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "6.0.30";
        sha256 = "0c3iglyq21mwwlwjd942z2jxaxgh39lxnqkyna0wf4a895g2v4ia";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "6.0.30";
        sha256 = "0frimj5r3c2dzk3a0z8h80jlsyvckw57nzm2rj85x8c3ym7cfp7g";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.30";
        sha256 = "1viylidv5j5h6acikm02v3zrbjbqy78f5a9b5rm5hc74q9hajngw";
      })
      (fetchNuGet {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.30";
        sha256 = "1929s1w81h0y51r2qcywbm4zp700l75yswp5ii68k401861b8pmb";
      })
      (fetchNuGet {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "6.0.30";
        sha256 = "13kgffl4jhbq0dn7lx3hhd36r0vi0s3s8dhjq85lq3hrm8454p8r";
      })
      (fetchNuGet {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "6.0.30";
        sha256 = "10lny4j9yyla16bwpzvnr15gkf5d4n4la5smk4v8ncfxbj7lgbrm";
      })
      (fetchNuGet {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.30";
        sha256 = "0kmxfvb10gfp4870mcrzgvymgzyb3l4yljnj105y8hr80jya2z2l";
      })
      (fetchNuGet {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.30";
        sha256 = "0passlm8ajlarnvvrczgxp0brgnbk4n8fig9xmangzsz43bys5dc";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "6.0.30";
        sha256 = "1cxd3hshcb5m5651324svwqxfsimkz35kr9lx0m9s0h7r7hnrcck";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "6.0.30";
        sha256 = "1adhb5qj1rz68l4dg87d2j1mbl263lvfry200fag6sfydb305kqh";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "6.0.30";
        sha256 = "0f8w8fjaigd2pj0gzc0h5qqm3j24mibprirx0iqaj1l7shgpi40n";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "6.0.30";
        sha256 = "0iirjhd26am5kczss9z1jv0v9qjafassvqdm19jdlwrbfn3nzqvf";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "6.0.30";
        sha256 = "0pvwpdjf5vnyx3kjq9p67hyzqbfq3yri2alxh2i93xjmdc8rmryv";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "6.0.30";
        sha256 = "0bkh3haf5ll5l0iiafv9ihzxqh2jqsqqi5325mkzq192lfkh3nrl";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "6.0.30";
        sha256 = "1dfc7zdjb8m2ziy8rxwismfp6wjs32m4piqxw5w65sc2ryaf2gvq";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "6.0.30";
        sha256 = "0f01cs742z821m1jds7p05jc085aryj7mjpdd04pwv1ql8axmyhw";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Host.win-arm";
        version = "6.0.30";
        sha256 = "0ns1zscka2fs0zdizir5malhxhgqryd5id87gjqa6y9k8vc6d0h3";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Runtime.win-arm";
        version = "6.0.30";
        sha256 = "0pd1bwq2nzd705c65ckwxnayjlj7ahj2n5hwfnglmjvhi8dyzr15";
      })
      (fetchNuGet {
        pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost";
        version = "6.0.30";
        sha256 = "06nrnbbaykg2w35bldyzyp9qxs8y7aa1mp4j3lswdjcly06rgvbm";
      })
      (fetchNuGet {
        pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost";
        version = "6.0.30";
        sha256 = "1h05dhpvycxjs17y3r7y929r07dswv7iq9lmwas1kjxhnzhbs6x2";
      })
      (fetchNuGet {
        pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "6.0.30";
        sha256 = "0jj3nxpbyb3vxh2jsa3qwwy46l6yls1z2n93mq2kyr3yi7lnghmg";
      })
      (fetchNuGet {
        pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "6.0.30";
        sha256 = "0sbi0b0kck61fq99ipw6jrjrj378kzmk30z0czkj5cn3m59v3dgj";
      })
      (fetchNuGet {
        pname = "Microsoft.NETCore.App.Composite";
        version = "6.0.30";
        sha256 = "166xfyap4mgv5y6qa5bzq1r7rd8n2fy1f3gcy16i1fhlf52db5v8";
      })
    ];
in
rec {
  release_6_0 = "6.0.30";

  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.30";
    srcs = {
      x86_64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/03d1bc71-2ad1-41b4-aa2f-9e4ef6d5c6ed/29b655655d626c590cb216e0c30bccb3/aspnetcore-runtime-6.0.30-linux-x64.tar.gz";
        sha512 = "757d017db28b8e34c4b242c082aa51eb85bce8fca16af37a0beabedb271c9bd13e1631868faa131745d7784db48974567f82275da09041ba434dcb7abe821a2d";
      };
      aarch64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a4c8e994-c595-4698-8cfc-cf3ac166bbbf/9e6b514da011de5191d148d95601a7ec/aspnetcore-runtime-6.0.30-linux-arm64.tar.gz";
        sha512 = "de0921903ba55e21195107b126e271457550543fd6a9698ab3c2b1e2b95f7fe2d6fb2f067e08ed10c9e56940c247733dd9a2f9775e7993e033a945899461e130";
      };
      x86_64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/15ab71c2-9230-4afb-87c5-36328af745ed/b859c077ed4d8c00985a2ee87009b6f1/aspnetcore-runtime-6.0.30-osx-x64.tar.gz";
        sha512 = "0a0c4c9255ed29db1c1911fa0fc6c8a9083f777c04a3939b2087d80bba21fbd864e6c92c62aa566a930a2b30024b1fdbfdcf34d034e2734c0a9b3d45f7c63445";
      };
      aarch64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0a61c065-2196-4a9f-a34a-9517b3ec9336/538e1624926840a66ef6963f57d44aa0/aspnetcore-runtime-6.0.30-osx-arm64.tar.gz";
        sha512 = "a74d44c399e06c9ce19ec10d4be53444bf18d981fe7ede62a69efc24a5af5898d4ee63542ffbedc3b906cf1ac3f7101ecdb69e45dc0fbb1336bf151940fc2204";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.30";
    srcs = {
      x86_64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a80ab89d-9f64-47b9-bba5-907a4cdaf457/c5714a6e605ef86293a5145d8ea72f39/dotnet-runtime-6.0.30-linux-x64.tar.gz";
        sha512 = "b43200ec3a8c74475f396becd21d22c6a78a6713585837707c2a84bbb869c7e551a05c4c1c1cdba8083baebdd09bc356de5d5a833b8bc84b83421d3ecfac71ca";
      };
      aarch64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/27a21bdd-cad5-4f5a-b7a3-86942632a745/3d7aba7c0cfe0c28342a8f83b65e72b9/dotnet-runtime-6.0.30-linux-arm64.tar.gz";
        sha512 = "75fa6de07e5d8e5485af910de522c1d0afed0532008ded1e80ec3f576c9a78c6e5759dd4d1331159263c02121a4d8f1e532f0533c11524c2d782cf861be13c09";
      };
      x86_64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/aee516fe-b6d8-40db-b284-1a287f7cd5ce/c217b7cdbcac883886169b82bcc2b7d8/dotnet-runtime-6.0.30-osx-x64.tar.gz";
        sha512 = "8cffba5feca56bf11b38318564c45ae18a58ec48223963ee46105f71bc07661457e562d51ea0e8b626eb69b7635565244a5cd1575b6fbac52b776145c533e784";
      };
      aarch64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e78e6379-e47a-4e24-ac6b-1c3182f1d664/b8f47b2f04b15c78ac24a8bc88000131/dotnet-runtime-6.0.30-osx-arm64.tar.gz";
        sha512 = "b33a38f4e41455cd88e23f6c0fa76797e05af25bcd94d500557fdd5ce10071ac16789ddef98ec9abef113f2aa487fc7d5c22f329b8a7941a79d7768ca176975d";
      };
    };
  };

  sdk_6_0_4xx = buildNetSdk {
    version = "6.0.422";
    srcs = {
      x86_64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/316ad9ae-22cb-478b-b51e-47667f1e7027/7a13422c0951e9235b7692c610b83442/dotnet-sdk-6.0.422-linux-x64.tar.gz";
        sha512 = "e0e6ea234a5aef29c2571784c22396115db292fae8f859f4642f80f873807140bb7bbc009be568e8e34288b46b2e3e7732115b5f02bbc8ca0aa723e183bc084a";
      };
      aarch64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/9f8f2c2c-e531-4a5d-b7ed-1e7e4b8bbc29/12e87ade15ce29558b40099d6c152b10/dotnet-sdk-6.0.422-linux-arm64.tar.gz";
        sha512 = "c03c3708061f266a3d7fb5bf2240f5bdd00be4d877dc3dc62b95a857f2ad62c80dd4c54f5257737ef7bad3cb458685d7f2bcfe71c3562075ac3aed660df8ae41";
      };
      x86_64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/818b0c97-95cc-4da8-b5af-05f6854c5e89/200ee246643a1d6a0436ad967ae705f1/dotnet-sdk-6.0.422-osx-x64.tar.gz";
        sha512 = "a301982e64a18cf06577463fc3e2e179c06a31597b1b32127b1196dba755bcc3323edb618f6000c9f4f9ed902c671377a459e9ac90da2c761744fc1d57e220cf";
      };
      aarch64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2f0c0bae-a26c-44c1-bd9e-9fcd42548066/c88dc835e8ac824d992696122c10d959/dotnet-sdk-6.0.422-osx-arm64.tar.gz";
        sha512 = "7bb885b605f51cffcb235a6bb6f0eccef7a211e67480fa6243b0cb8899dfd60c4c0501579c0c1dc7fb267aea5db5a6d35cf9e2a35903772797a66360fa171b3b";
      };
    };
    inherit packages;
  };

  sdk_6_0_1xx = buildNetSdk {
    version = "6.0.130";
    srcs = {
      x86_64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3d0d3892-fec9-4764-8638-b579b1b9e222/dd4c14a3c27929671362c89fe3378677/dotnet-sdk-6.0.130-linux-x64.tar.gz";
        sha512 = "dd4e3e5e24c0bc387dc6ed3fa833236d3f444efc0b12a256dcd73f5f4431488b516143d63019c6e9430173adebb07406b52e78a102f9e143a7e3f16361228b32";
      };
      aarch64-linux = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b7e1a062-bd07-4aab-90c8-0d91994ce0c5/1d399c3f9cc73c767e6927ad4f60c5c5/dotnet-sdk-6.0.130-linux-arm64.tar.gz";
        sha512 = "95767eb4da8e3fb50992ec48df178fba9e2a7beaae26c5fdd8ecd4dae605ec048b83180a2bcb72c836468a99607179f9193ce0e1980bc95484865f559cc91789";
      };
      x86_64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/fa013cb2-8b3c-4986-8863-dd526d13503e/ac0c886e8c9837784ff02db082ac4a53/dotnet-sdk-6.0.130-osx-x64.tar.gz";
        sha512 = "8102f1432343538f45d0d49e518edb7ba0000d1ae7f7306611d2e17a205baa4215281250b45cf11900f45db0622fd190bf7d57f2b63cc8b1b4bd106128564522";
      };
      aarch64-darwin = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8c72ae1a-38b3-4a30-81d5-408073f96d64/2e3493ea5498d598193746232d4be684/dotnet-sdk-6.0.130-osx-arm64.tar.gz";
        sha512 = "9d8273f73e842a3a1a71a2ba5c2f0dce74821e1302ef34843817a3f5c49df83d662bf6c7031dba7a8362903a870f759c7976176209781a3c4ade6c66e6824c41";
      };
    };
    inherit packages;
  };

  sdk_6_0 = sdk_6_0_4xx;
}
