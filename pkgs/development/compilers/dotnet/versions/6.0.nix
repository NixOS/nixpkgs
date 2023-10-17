{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v6.0 (active)
{
  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.24";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8f5a65c0-9bc8-497d-9ce2-4658c461dc55/b6c01c3cd060552d987501ba6bbde09f/aspnetcore-runtime-6.0.24-linux-x64.tar.gz";
        sha512  = "b14ed20bb6c2897fb05cf11154aa22df3c68b6f90d2e9bc6ccc623897a565f51c3007c9a6edcdbab2090c710047a3d8eed0bcc6df19f3993d1be4c6387238da5";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d562ba2b-8e2c-48e5-9853-f8616a9cb4e4/f4e251ba67b718083c28017e3b0c6349/aspnetcore-runtime-6.0.24-linux-arm64.tar.gz";
        sha512  = "db5de0888441e93466f84aac459d5ea0c9079c9b8e00308abb0ccc687922bbe48ace22b5cbdeb0f38d89cd115440deab5d0b4f1499611822dfb8a0e9f13c4309";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/cf267621-f2f5-47d8-90b4-e8a4555de21b/aa82da20c081e6359b1ffbc8261b5c73/aspnetcore-runtime-6.0.24-osx-x64.tar.gz";
        sha512  = "8cfab4466ab5a82c7e0110541708b08f894427036f54e2e8add649b9777c86b856f7d5fbd4c2709bc74343b5b1de937b13bff2f0b7e68726072f93b417632603";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/516e1a2a-0256-48d9-8212-c95a6c9d93de/6abbcc369ef1d3e03e6e28f0438ee295/aspnetcore-runtime-6.0.24-osx-arm64.tar.gz";
        sha512  = "1590236034ca91d347b045843d790288024b19939d34f356c6914bdc7ce000af9ceea63a9ce69fa599d126fbc6dae405a3a42cd4a02edf5ffa067388da8b4da4";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.24";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/872b4f32-dd0d-49e5-bca3-2b27314286a7/e72d2be582895b7053912deb45a4677d/dotnet-runtime-6.0.24-linux-x64.tar.gz";
        sha512  = "3a72ddae17ecc9e5354131f03078f3fbfa1c21d26ada9f254b01cddcb73869cb33bac5fc0aed2200fbb57be939d65829d8f1514cd0889a2f5858d1f1eec136eb";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8292f37d-c0b7-4371-b307-990c488ffce0/95142913864b1f8cf45d3bc432a8c193/dotnet-runtime-6.0.24-linux-arm64.tar.gz";
        sha512  = "43ec6b177d18ad5dbdd83392f861668ea71160b01f7540c18eee425d24ad0b5eee88dfc0f4ad9ec1cca2d8cf09bca4ac806d8e0f315b52c7b4a7a969532feacc";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3adf2172-7ded-4053-bc86-b5236b1a3830/80038eb1ea0019995c76660f18e9a290/dotnet-runtime-6.0.24-osx-x64.tar.gz";
        sha512  = "25afb6eb9d9404332efe32407e1dcef080a79372b8631b7720daf62bdea42c4fd36c1fdc12c6333c9c1754a1cb29f5ce64a1436e6392db396a9dce647a8f2c16";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/87743def-9e7c-4157-8ca5-d818496e41ff/97ab6a39043f45d7701f91c422a663f4/dotnet-runtime-6.0.24-osx-arm64.tar.gz";
        sha512  = "fbbf6b385172700e4864db9db6f85bcec6fe447d504d181878ae7a3d7b4e06f19920c7aecbdb4c4700bc65f51abb7409cb68e99dda4af14319909bb2816c22ff";
      };
    };
  };

  sdk_6_0 = buildNetSdk {
    version = "6.0.416";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/675f1077-ab10-40cf-ac18-d146a14ea18a/522055f875b0a2474dacfa25729d3231/dotnet-sdk-6.0.416-linux-x64.tar.gz";
        sha512  = "5a3c60c73b68e9527406a93c9cc18941d082ac988d0b4bfea277da3465c71777dded1b3389f0dde807eda6a8186fcf68d617d2473a52203cb75127ab3dafc64d";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a56a7895-ec29-44fe-9fbf-3ea6a1bedd3d/47393de218098a0d63e9629b008abf07/dotnet-sdk-6.0.416-linux-arm64.tar.gz";
        sha512  = "b121ba30bd8bab2f8744f32442d93807b60dac90f8b6caa395d87151b2ffc335f93a95843f08a412d0b90c82d587301b73ea96f5a520658be729c65a061a8a80";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/fd03f404-c806-4eae-9bda-0d002437c227/314b39bd905ad559bf38421d8184f0b1/dotnet-sdk-6.0.416-osx-x64.tar.gz";
        sha512  = "cccd47ac03198f7c2335abbf9ebaf11d76e229cd2690f334bafd70363de7045e600c33057d16689fba6ed95bb2f80ee8cd8258152c07c1972323471dcc6f2df1";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ac99e470-ab07-4f1f-901a-3d14c9dd909d/a2a51c3f12ba268e22166cdeca54cc65/dotnet-sdk-6.0.416-osx-arm64.tar.gz";
        sha512  = "7099b3dba1137e1f429adebc3ebb4cd002d6528dd74426a687c2919b7d01acea49cb65c2cff1f1f2e283d96159440c60d909258d2350b8e76df3e513152b23f6";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.24"; sha256 = "1xiw3kdc76b9hqf0pyg9vapdxwv637ma1b63am9dpvm8qprn01nh"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.24"; sha256 = "08670zhn2ywkwy0d7sj89rikxccy5qg0vsjwpbypvzndawng0bb9"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.24"; sha256 = "1iwnzs8pfrkvqyp0idxc7bx4k8970zfbsdrk1xc3v4jw99hj0q2i"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.24"; sha256 = "1d7j7b8vvbrdf4hiji5snmn8yi39scd2kvnbs5f9sy26424fz22y"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.24"; sha256 = "0knx6lhlqxn3lkgakpab0663788q0si00m9ga7wdn2mzqq0s9yx0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.24"; sha256 = "0qci0ghi0cnm26pym6qlp8cricnbgzdxzwzc8ay1sdhha8dbh375"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.24"; sha256 = "1qr67bb1wqjs43xwypnqlrx3fzhhm9gyjwdniqr01c48yg8d33yw"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.24"; sha256 = "07sr9hqzbm1p5cmvzwia30yv5cjf5b1bm0l4bx45sg53g8niramp"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.24"; sha256 = "0cvvmh90vil156qqgy2kbv1j6sgrp4z977f3zrwbsw4pj9azdalx"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "6.0.24"; sha256 = "1czq36l5l01f6r1mahzg8fim1qjxgs345mcyx1f4gq024dw1fmfb"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.24"; sha256 = "0lriw4f48f0q2vyagbngnffshdismn3msn7d6dj0lb2xdkzsz1f1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.24"; sha256 = "034p01vm5jfz94qzqcvpph5fjk6rnkjwqlsm39ipc38f4r4a9iif"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.24"; sha256 = "1671gfqabmbqnjq1djx17j5q3zbaf6ivapixyhsla1bz1gadm3g4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.24"; sha256 = "0l2d49an5bmdfd7hgykkd82n7i1l9kpj5k3vfwdkv5274iaiqagz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.24"; sha256 = "1vyy01i4w2wcx82mrjjsbp98v9sjn1cwhdvkhrw8yrrb04lcxbir"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.24"; sha256 = "1ij8xlr044laq4lhl833994hpr636hyisx072c6wmmm21vr9i312"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.24"; sha256 = "1mdhpqdwcly31x08n6wk39n970h98kqgr6hrh8grqln2fqz2xgw8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.24"; sha256 = "02l6javfqwsaialkimmpsq3v4dhb1j4sxy19yvr5w5sdjmq1jh5y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.24"; sha256 = "0g99fqr27h1ya2why3inhcqhyrxrg3g0hvcnqvqp153njcbdl9qg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.24"; sha256 = "0i6gfdlb815322n4rj7mgagrdhpj8kha73r8h0w9y0bkwgjlqw6v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.24"; sha256 = "11nfqmjk11446nl4n35w2l94dsjbbm03lwz47vffibcqmymd57xh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.24"; sha256 = "1n0s52gzfc0i4wwbcfpqh02z3kdjxjpgpvslia1cf8v5wqn690pm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.24"; sha256 = "0j30fyz0cavqd059iviglpx1c3q7mlplvzhnwl2m46hdj18ln8pa"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.24"; sha256 = "1zcn4px94z67j60cidynm5ab8cln1rrxabv7c24mlajqnkfw14sb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.24"; sha256 = "1hw8rxghsagw8vd6f5sgl16s7x5d5ix0pf9zqs9zis1wfm41lgv9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.24"; sha256 = "0w2aq1bmbpbb2b79frr2j7xnf2h5mszip2wgaxzbl1vfsnq4zs3z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.24"; sha256 = "0rylvdvdc5rdmw2vcqi0fdzmiwwa1pwlqiavqnb2pslhhq8qg4mh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.24"; sha256 = "1wb4w0izm4njhgh4dji4zv072cw5h2jkw7qdaa98130ai5czg5x2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.24"; sha256 = "1crdfd8p83syn7m4n7vm82lr9lcrz5vq7k4jrk6g3xfgl4jkym2n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.24"; sha256 = "1pc0f31pvfzgdgwlnvpjysvjmzakskllccrsh5qp28ccrr67ck0m"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.24"; sha256 = "1lpb81zpfdiz4c1jyfq7y7m4v6icq8b8dg5ainrxjzjz8qjmn7qc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.24"; sha256 = "1x3h6w52ab7cwxvshnjbhb9vdfifbnjmwn2kgw2ngl6qxvygikv3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.24"; sha256 = "0ncqxzbpgfgdhrvl3j3csmr749nlzxp7gqf467wsgxd9kri848rv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.24"; sha256 = "1a5935lb2rb9hj6m08fh6r0br8y3i7vq5xzy48hanjdb6cair3k1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.24"; sha256 = "0l5n8pl4i8khrz3nv045saihvndbgwqqip44yc5r5abjbpljp5zq"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.24"; sha256 = "0yv1bmgg85g2abph7wmkv9y7p4s5l51wa3j18rcd7wx63cjik1sa"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.24"; sha256 = "1m17lihc3fya44y4vpnacbia773gpg4bqd0gy3lw86gx7rs4n343"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.24"; sha256 = "04q13b76icmbp7cpjwfbw5hlqxnqlrgs0d0xsp7hxlqvnpg1ba9a"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.24"; sha256 = "14p0wpb8w26zagjnp9jvbdqzvgg04s3b9midhz47zr78qjqa0k41"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.24"; sha256 = "1n66dxxkh5ax83wp640znw80s1j03sq6zbpi1wsvmm9xbasskjw6"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.24"; sha256 = "0yg3fc5x7frqmvnca244rhwbqwmrcyrqwp0kv2102fs08fjcyk5v"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.24"; sha256 = "0fdnvq997sq16fkc9sjaghzmbahvp5k6zk24s8s51ypbniynwpq7"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.24"; sha256 = "1n9bjddbmi6w9bsz4vpc9fx3wyn6ygvh05wcd98d3rf0p3ynghcx"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.24"; sha256 = "14h9xxha2qb2smnk2iy6inhwmsjmkpv4kd92l42i0is19k1sq852"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.24"; sha256 = "18mmlg42j8hs9qlq74pxhpj1sm53gqclsrpdjq3d4gpfg6zz7h02"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.24"; sha256 = "05s0qdlyasjrr8vf6kfx18vixn05iwsk23hpsp7qdjvx560kdza5"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.24"; sha256 = "1x7nqpb0psqk7q9ifhw149b6awcpm8lgpy2pxz03frdnbpjms7x5"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.24"; sha256 = "1jigailv8p3nmmy8qpscxyq8zrdlwkfrls3qicn9arp9ni8phmgs"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.24"; sha256 = "1pycy8jspvdga940frd06smsipq10bip9ipd466pnqicaa8nawjn"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.24"; sha256 = "1gm99469wb35v169dpprrnkwkvbzh6v2lapkw4v8mx4nylfc84dx"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.24"; sha256 = "1sgjiaync06gy6a1zmpyvikbk3l868k2qg3jag1dyyyl2s1hp02c"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.24"; sha256 = "14nh4hlk9znngl1kl2bhi0ybpsn1kmxb0hq122zqjwvjbfqahlzd"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.24"; sha256 = "0y6a53kfhwaddm7yw263yyn6c5fghihlh76mmfi1hba9bf9615qs"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.24"; sha256 = "0ya7bx3lg92bil8mswp9awhlr2gg2z77kmw90l3ax7srymbimzfn"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.24"; sha256 = "1x1hlgn4j9vql8p7szrjrli46lyjn4a4km9v3hj5rg3ppm1wd7wl"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.24"; sha256 = "12b1l6fc9dajvb877kffidyqiicfkk1cxpr5w6cgcvfif3cxak87"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.24"; sha256 = "1dpkwqwj4ldasixv2lkg1smql3cgxavswyk53pflr604v1519f9g"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.24"; sha256 = "1ma16r7q1y8000wcwa3rxk5p4j6pw4gdfhbf64cymcahn49azh63"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.24"; sha256 = "1kf26qd6ajcafssk674c44nmqr68bp9fibgrglqz67hz9r8w84bb"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.24"; sha256 = "0sm8r6zdwxnwv947yszq8p5dl05j846lk2l0dxbd78r83iskmpkm"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.24"; sha256 = "0059gcn5qkbkqcrrcn75nvw54jcc3q06jyq87l4hbvm9l1w6igrg"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.24"; sha256 = "137nq1bv3q48cn14annxsf2zqg19ppg81fkan6vjbb9vwvcvkx25"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.24"; sha256 = "0gz9ipmh5sn4fds2baqfzc8gzalwmifxs2h3qril1rawxkz29s0z"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.24"; sha256 = "1h2pp8p38ilp1hlrjzh70vq2s7k9n4jmcsjpcmzghdaahdg2m8kf"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.24"; sha256 = "1npxp73s5pj6cmy9j2cxnfr3cvbm86g6jmq6194qpax9b3xh3a8r"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.24"; sha256 = "06v40vi7ckrn1rl8ynygxaxr0dj0ll5qqsx8k11qk8dpc6849zrd"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.24"; sha256 = "17lk8414hnpn1lpxnqqlkk612l5dyp9yr8kk3hqz7ygi5i7m0igh"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.24"; sha256 = "1qlxjg6ynf5fkswb65bk0sg20yklq207x1frq2hrccm5s2f53v8w"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.24"; sha256 = "1a5wq6y4qixjd8xadw4wfwx7qrbz9rvhfq5f61sfgsc14lkqjs0r"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.24"; sha256 = "1biz5x9pznlnik0k9jz462z5f3x87frmxayikcb655ydbaiwibkl"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.24"; sha256 = "1qvqfkpr8vrfn3p3ws1k4b7mv4n4swc31grvs7bvx6ah8qfacjgs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.24"; sha256 = "0l1j6ybwawk6w01ffaj2rs6wac6p0lps2wsq21pc5imjcbm2mgyg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.24"; sha256 = "18cysr0gbw18hkvc03r6gmllp2s63a0s5xvp02iryrdhaa0vr0qz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.24"; sha256 = "08kjhz9cw50vw3rd904r873fvdm7z4w8lf9k77ws834k92hr2yrp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.24"; sha256 = "0ygdkff2qln45nc9yb2pcrpx3p01bf2bk5ygm34p5mcfqys9yhpa"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.24"; sha256 = "1fy1hr14igy4lix4vmwkjj13cbyjjfhx8izch9cd9hc4f1y25767"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.24"; sha256 = "09h7bvwsi2bpd8c9p11amqj2mw0hl4rzla333xmz28p3jf2l06yh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.24"; sha256 = "15sqxccpc9s8djhk1cb1rqlgw20qd2bx8iij0i11riblqg8n37in"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.24"; sha256 = "0vxb0a7zvhhljv8w5bz7ryn8hl28r9j0s20xm1rj4ifggpfkgzgm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.24"; sha256 = "0is94agm1v7q3qhxx8qkfxip92zikd65xq70mg7nl0qms8p4cc41"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.24"; sha256 = "10yk9qlw0v0dkwmzhx58spbpab7xlkxnlzji9dcknmb2yxh4g870"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.24"; sha256 = "0bln3fn5pyc9s03yyfln517682jcnmfnw7v207swdn2qrdcfgdk2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.24"; sha256 = "1yxr2n4p6ijc5hi5ym7hbafqgc6b0ckl7wzh2w829mmg16ww4nsc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.24"; sha256 = "1bryp4rpa21q7fmlr71j6p9r9p30f09mzddkg3d85ll7faap7iqx"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.24"; sha256 = "0v2bc1is8786h50nhzf74sm90l1knn85a3f7phxpp8mdsn13ff9z"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.24"; sha256 = "1wmgjg4fl9c321yklb0nl0rzj83646xzcf9akj6nzz9ihmq5jp5v"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.24"; sha256 = "0ikg13k88chg6wv8d9bpivnn1ldpnx2yqs348sk6l4i2m1wyz5dz"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.24"; sha256 = "1d3qs0cm2nmf99rv0milmh3g6y5riz66xlkppc6dhn8p1lqrgaf5"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.24"; sha256 = "1w5gjdv7dpig78m334bavlhl6938g5h7bsx26wlzb3rzc9vbyv5f"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.24"; sha256 = "06fhdy6hm78hsscdlc8i22wm439z3fw4003i5r03vvwlpgwm7y3c"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.24"; sha256 = "157gd8fi7vx2cbak8k1vxri8fy54f4q02n6xi0jip8al4l018kn5"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.24"; sha256 = "0sps772kj4sa7cb6rcwlssizbxj7w7zvqfaflalm9zq2m23v7q3s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "6.0.24"; sha256 = "0wsmpychdx33pcn6ag6wk0z728jfzi3gds0azh7mv8qizg5b7ak1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "6.0.24"; sha256 = "0lc7ckk83bc301kqascqgh2cw0f20rmi1j9144yikpr38x4irg78"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "6.0.24"; sha256 = "0k0vyq8dixgp87mskkhdn8bbhdpza1imjfx1jqycms6l4m3aiffh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "6.0.24"; sha256 = "1g9dl6n77b9bfraz83hsb3qc74g3wjciwr1r5q3m8w44iaqx6vf0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "6.0.24"; sha256 = "1iabbhilq865ccrdq6z765ay6xgqlpcb1abzkaw1kr4lcdp5qh4q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "6.0.24"; sha256 = "1hvz3zfgmk6pc7q4f400fnd578yfrah69fm5ybk4lxywkydazjn7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "6.0.24"; sha256 = "12d30k8ia8sl4n4q4dzqx2daj7zs20h439x2lgj9bn9gxbrc9kw6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "6.0.24"; sha256 = "1ibh79yqbbxxvk8h1nr30kmcj7lz7y733sxdbvj5a28nbvka6axs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "6.0.24"; sha256 = "1xdnk0my2j1smvm1lyb9xxda78nx9pnl7pnjyaxbyli918qayyjg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "6.0.24"; sha256 = "1wxdh02z70dx4x3vx6bq1krc69irrdiar7662wqkcic3lkgqhdpm"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.24"; sha256 = "18h52kg8brvdm2kagjm4lfkmy42sqmxc3avv7wgn1nxrlfdl221l"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.24"; sha256 = "1xbvhii2p53l6xklg2m54pyk6ja4480hkyykas5m7gvzwglnlh2n"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.24"; sha256 = "0c8gpc4qpr2v6hwn7qswdwyv689gczksvfw9wmqij0nmy2fyrdyz"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.24"; sha256 = "0x94xqff4s0nnwslpmyw1g50k4vsrb6g2xvqmiis2lg8422xi7jg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.24"; sha256 = "1s9vsk81c8bkbviig3x0i45skhsifxwn7sgcg417pvzj27l495a8"; })
    ];
  };
}
