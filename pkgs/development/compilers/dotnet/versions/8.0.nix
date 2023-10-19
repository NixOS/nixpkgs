{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v8.0 (go-live)
{
  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.0-rc.1.23421.29";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/02f4c6c2-c137-448d-a189-9ee3a3f6f99f/192f2c750089fa0194f04f5a805bd21e/aspnetcore-runtime-8.0.0-rc.1.23421.29-linux-x64.tar.gz";
        sha512  = "d5f9e7bffbf2b48b26a317dd1d78bc866973b4a2cda448cd7a7ee64c0ffaf98fa3c4b8584d32528026674bdfd99f602f0fdac8242176815705e080df83825efa";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/de4037e0-6e5e-4a40-9c83-555d30d9c21f/f607c58db3f81aea2c7e56b0ddbf9ac6/aspnetcore-runtime-8.0.0-rc.1.23421.29-linux-arm64.tar.gz";
        sha512  = "ba8035da535cb3bffa720e962e6f9e0f88b36e1221b588f2a126ee4b43c02e4d8c27958017d29e5ab68121fab6a564fe0a27099c4103ee3d527f8554b4ab495e";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c3612fc1-f335-4b1c-a08a-08267100ff43/dd06c8e7021c27becdfed27838be253f/aspnetcore-runtime-8.0.0-rc.1.23421.29-osx-x64.tar.gz";
        sha512  = "28c2cc2b1b32a3d4b287f2ceec42ac7fce59870bd6a72f6767d347fa0a9c53210c5328e4d747ce010512dad149109ff072840c9da9301c8bd66a178169458518";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6dbd02b7-f3e8-46b5-a3e9-ea482762a02d/430b0d87ec687b4a9968ca143ea95789/aspnetcore-runtime-8.0.0-rc.1.23421.29-osx-arm64.tar.gz";
        sha512  = "dadb90494fb36a1d38b12d2903a385b76ee7325eba59d44acf4e10c3019bcfd636cf0b9a7c3070516325c6be4f5421c11fad7a2293ccc2b1c7a5d3c62bbf07e1";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.0-rc.1.23419.4";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8cac1522-acbe-4052-9f6a-19341a8f9dae/1cf1396b382e22cb1ba21a27f3b79725/dotnet-runtime-8.0.0-rc.1.23419.4-linux-x64.tar.gz";
        sha512  = "53938ec3aa4353cfb760d22faa850821b54a53fdd864c4969f48caa6b718ba207162b04a196e85543947acb7d3e719982edad1420b76198562051846f51b1b5c";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/78e40734-8864-48f7-8c03-971ee500d93a/4b2fd807bb790d9ac3cd8585ff8cb6ad/dotnet-runtime-8.0.0-rc.1.23419.4-linux-arm64.tar.gz";
        sha512  = "6f5ca722ec2c4a400b9c19b17a3d9a10cf92b265c90c1e1b4822c12117580c286e99134f7c223f3dcd71171d5799e1498d38129dbd1bdff606fd64fe451458ba";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/29e68c3a-f37a-4dea-b7dc-bb1890b28d48/3ee60668c4ccd17ea565d6c204ef1f64/dotnet-runtime-8.0.0-rc.1.23419.4-osx-x64.tar.gz";
        sha512  = "ffb0a22c0e4b9cbefc99a1e016683987dc4046abd9f49f5e48bbb93d0434e818c66274422728b328c97ca1dcd6419c7fbb88ba747edff6a8e92213141ce42bc6";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/59ecb50d-0abc-4bd1-ae81-8a252027d3e0/43ed857eea3316732b1a5cb0c68eaa50/dotnet-runtime-8.0.0-rc.1.23419.4-osx-arm64.tar.gz";
        sha512  = "f5810ed4c8ce565f1eb3505b7994e54ddf6d87f8903f739016daafc01ba532caa1b84e39e4e42b73f392703af973dfcaa2165b4630301a859fb49ba411d6ecdb";
      };
    };
  };

  sdk_8_0 = buildNetSdk {
    version = "8.0.100-rc.1.23455.8";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8cccb582-1956-422a-8655-fad2fa12c247/4e86a676860c2ced06228a5c8d21718d/dotnet-sdk-8.0.100-rc.1.23455.8-linux-x64.tar.gz";
        sha512  = "b182c4d496f1e3d6ff109c304972f5011a343750ed11ed8ab273ad0bd2d1441b7393fbc20968b54f61acacd8c372528f9a91a7a956362787a362b4821a434d81";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7f0829c2-839e-4882-9e21-fa4fc6bac32d/5ade892179b687046b1252638b8cde01/dotnet-sdk-8.0.100-rc.1.23455.8-linux-arm64.tar.gz";
        sha512  = "686a10b89217fd5d28e4b587dc231d0bb2630fe7dfc7423611406fae8812ce1b53aae3e079b924280fe589686153919272f4b5ba0c0292d68ae50a75530d015a";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/17670d0d-05c3-4e4b-8d72-5e31bb7f7000/44395256cb038899393d7958db2bf2e8/dotnet-sdk-8.0.100-rc.1.23455.8-osx-x64.tar.gz";
        sha512  = "184a845b4b395f4c00b3c9e846977a2af446686ac0e4c916f2736f3e891d3045341a8f391517a19f50900ed262ca4999d28e872bd6d0faa0729f6a5c4ad183bd";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/91a1c0c5-ab26-4dfc-8aee-6c0cb2354774/7e12ab1e86fbabc3417eb4036d955f67/dotnet-sdk-8.0.100-rc.1.23455.8-osx-arm64.tar.gz";
        sha512  = "a658e0dd633175ac5c7d7c1481cdc44f431e85094e29d0f21f5632f447469a452f5fcf5cf6e42cd4d0053fabca6bb4a7e5cc0f859f09cecbd062301c24cfaf79";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "8.0.0-rc.1.23421.29"; sha256 = "0ws54phj14833xz9w53frr3pnq6ps0pfrbz173i9gj5xkhjf3mpb"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "8.0.0-rc.1.23421.29"; sha256 = "1sz6skh1ddvdcib8ydi6km593ah3cchgz2fs61kj03z6jg2vz9la"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "8.0.0-rc.1.23421.29"; sha256 = "1r8681ixjxyixznhwakwb19cs8hnwq7pq87n4dpzqpm531jmjkcm"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "8.0.0-rc.1.23421.29"; sha256 = "1hmza9icxnxj6dcdivxmngpvrg2ncri1gh849rbfzk04swylp6f5"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "8.0.0-rc.1.23421.29"; sha256 = "1m6a47bnrl8n9ahnh01mg2fkc20lmfjjg3f7xzbdngnikm6vzcxv"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "8.0.0-rc.1.23421.29"; sha256 = "0ygb60mpk1rkz67v1d9vf3f7zfvdzg5a4ckc1yqcfb2n4a64rdbv"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "8.0.0-rc.1.23421.29"; sha256 = "027xhd1r4my8952fajl0smpdikj4ndn1j5gkyhwrg4z45xx35q18"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "8.0.0-rc.1.23421.29"; sha256 = "0cir3vy94ki9v0zzkm49f33mxmp25i2v0c3gp4fhmnhpsfn0x7rb"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "8.0.0-rc.1.23421.29"; sha256 = "1ydhf3l9c7grakdr1qsqdgbdvp0zqrc4b66xj7imgpx1k92i2m2c"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "8.0.0-rc.1.23421.29"; sha256 = "1mpha730nn451zp3j7h72a4jiwmgq4sqx4r9943v60yzn93j9nhm"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "8.0.0-rc.1.23421.29"; sha256 = "1r8y9ra1qc0jx04jdkqcqnwaqlkr9ah081c68qslj7a2izhz1sbp"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "8.0.0-rc.1.23421.29"; sha256 = "16vy79c7byrqwd9f7vm0xbah3k4y6yis0flm9jkfk0hp4bb0y0js"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "8.0.0-rc.1.23419.4"; sha256 = "1q8dsj0l622jxwxxmasmwcp1mdxi6fxyr5swhw9pd0vq3i8y13m5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "8.0.0-rc.1.23419.4"; sha256 = "1254rvx06wjblf0y2msh1zdg0fky861l8x5f5w7hm5l14ys1firb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "8.0.0-rc.1.23419.4"; sha256 = "1q258zk3kkc3qk39yyfvqw3vlcmz4nf4wxdwg79dfp7i6wcny72v"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "8.0.0-rc.1.23419.4"; sha256 = "0r5f54vyj38b7simbk0481zfawxr3z5q7sivfm23nmfwxpir80ma"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "8.0.0-rc.1.23419.4"; sha256 = "10kjms0wx5iialcvd0fp64vriv4cyk7k22wqh3km9mh43i620px7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "8.0.0-rc.1.23419.4"; sha256 = "03sgkb2ar63wllisx8rmpc3yrngl61yhlmqinwbc5bhyaxpmqnk5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "8.0.0-rc.1.23419.4"; sha256 = "0b747vkvsapy5p4sgv0nw1hs1hak04pbnsqysj4r7ypf4f9bnrhs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "8.0.0-rc.1.23419.4"; sha256 = "0lnxq6risl59ig9svhra6papn0i9rs2pr4zgnysnbfg7gvd3fiwh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "8.0.0-rc.1.23419.4"; sha256 = "1h8xa2kvg6pl8fc1js9lgbvcckh12c496j5hqjiclj6cbsfr3i2g"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "8.0.0-rc.1.23419.4"; sha256 = "0hrxbkqp97mqp6rjpm3azcpvmkkaxz37jl7ybv1bh2m3f0zk66jy"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "8.0.0-rc.1.23419.4"; sha256 = "1x5pq1y4gn1gwnqmq9mj02wki5yncidlnmaf2przz8yingfw0hq6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "8.0.0-rc.1.23419.4"; sha256 = "1855npscp1ziab6a50fh0vzv8j4z0sarp94cl3c1myk9ndnkzksn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "8.0.0-rc.1.23419.4"; sha256 = "03ib84r9xjfzifr5g0b7hifyb5nc6ynk5s3pjifcsplhfhr7hhvq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "8.0.0-rc.1.23419.4"; sha256 = "1arzm0mqdj0hnlsfcki8z3zbbp5mpv73133wc8yxpymh6f000bv2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "8.0.0-rc.1.23419.4"; sha256 = "0f403j2sis8p7y1w2nkbp03xq8qq06f7q94d8clm9c98vppw75sj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "8.0.0-rc.1.23419.4"; sha256 = "1ngwm0hpg00z8hi9kfrc4p8ii51piymn1kkgkbh5wcdz2rmfayc4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "8.0.0-rc.1.23419.4"; sha256 = "00whfl9s9qd43jv68rff5g6da0k6y11yc2pg6v681967fnq31jqp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "8.0.0-rc.1.23419.4"; sha256 = "0rbyh9a41wvygzfja0wm305bqisnsqxhlfhynvb8p5yv1dsg7w4w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "1s8f5mrwnb66azhbrxpy3ab1b7crr3zj1q8fvsym80kl6xapzwva"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "13a7z8m4izwjd0qh3p01kxadxagq59klw173dqn5l57wzzj8vsxs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.1.23419.4"; sha256 = "059c21fq6kql04kn56yq5ahm5wc3321b12q50hsg5lk6w3w7xgj7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.1.23419.4"; sha256 = "110aymhj4rj39vpvbkyph9mdx347xydkdcfsdvw1ablfya1p933f"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "0kynd77v947b6lxhjwynm9yvz5mp6wb4d4jbl8ccqzw0f4g57qxq"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "1ix7jjpqzxjyjqfac2csv2j8zr0xai601m14r5swqs3fy1cpm8zg"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.1.23419.4"; sha256 = "19g1awn1ywnmwm6z547011d3q1k2wn58sbg4dm5y4pinmcfm37wm"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.1.23419.4"; sha256 = "0wyafqqjxksrp052rqvwxaqc3m6yzhj095w8myqbjnxwyfzsikcr"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "183lwi2xm45699zhynw7zgd4sa3zpap6p8h2036i94kfr24ir61n"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "041n6jrvwlchdvy7xnmwk0khvf4ybmyq5lvwaiav1xxw0a1dyn3h"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.1.23419.4"; sha256 = "1k6011bq71b3whz9lg7kc8lgf19jn221qzj694m6qqlzrbb3g2s2"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.1.23419.4"; sha256 = "0qkdinyq87rfgiasjgwaggid86xw6kcbjx97w183z4fb65l561mh"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "08h2djggfpjh0q38bq2hjqk5xf48iz343352n6yvsa40rmn7p0fv"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "1j4gw5c2p0fvjdhnyg2fcwlfvdgh4sk0v1w3w004xkf9j5jv1sf1"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.1.23419.4"; sha256 = "0hh73hk9iq15i46k0h2c1y6ixpi5w0i38f8sk5cijbvkpb1cahwc"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.1.23419.4"; sha256 = "0n3qcyyd0qdnv63ym0rlrw5gvq4g4s65qq6qr5nxpn46iwgz9p07"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "1grdchbc8cw94ly9ihnz675c6kg0rnwzdkciwsspnkixfmr8n4wb"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "0ndrih51r1ggdbgbjn2gyvwarl0i6qkzp9ravvx92jn02k4bb5yg"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.1.23419.4"; sha256 = "13x9gnxzk6k6ipijgmi9bivkj4ibqlsb04fs1c0ag0vsdacpwm4d"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.1.23419.4"; sha256 = "0rfkyclsv8451xm8hh8hd55sw9vbr8i60wi67dnjbip61ydl0sfz"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "1bp2aixzvmvmzkaqq4diqw78azg82751s64s2wn2zkjb9big5d2g"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "1mycvp040slw87cl1cnzcfaxmrdjj728sw6dnhyc9z6x75prn7sv"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.1.23419.4"; sha256 = "0a0c3adk3v7qcrxw5wizqxmbkj3fs57r3a0179c8s92vhh4y31l8"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.1.23419.4"; sha256 = "1dgy2n8acl6kcjpaa6s869v52rvvpkra9wrh6af0zy3z7lrjw3za"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "18rzizk0db8ivbl6hm80r5lzyz2i1gjj1k32nsbhh6x6x57b9a05"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "0a8cnaalpb7v09ijm38anh9wyvkd2sza5q87ggmhc0ji10gdlsrr"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.1.23419.4"; sha256 = "1qfyiwpvh1lw48h3jhry2vkk3qq42avgzfq58xspc87g4km7nq45"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.1.23419.4"; sha256 = "0mnpsvlnw2h4ggw6h3y7cb58a0255p4501m7d2k9jyx2fvkrbiqc"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "15h0vxsg91v0yprbg8yf7ny9h0xdy93s4xp7i1x8vqfxizh89l4x"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "0wiqmcib5cwxfsyvhf7gq6r76caycmyns08q8hifqksj6lfbi64d"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.1.23419.4"; sha256 = "0qcnaz0slz50lzpdhghr6gxck5x8ljyhc4p8apsk52ir66cb9sfw"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.1.23419.4"; sha256 = "0x1bgi69ylpr280ayzj60dxbirqab4ysxjwzqfwglbjdvqkkwn38"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "0fdng2vpzljjpdqjnz2pr8naznlx0vgkbypigjfdkpcrmmdhq004"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "0bwbyzcqcbqnaybkb106sq68035vh7kl8i1zlfq6hgd7rsbc5xnx"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.1.23419.4"; sha256 = "060bkh4viwpc1fkhxkpisbxwvfcld1lbm7wjlyl69p84nikyllnf"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.1.23419.4"; sha256 = "0ma4h0bbham9z57i9fdgf3arz6x5cvc5mmcwr0zm7bzyrc049mdd"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "0m95wrq9q8d965yxjkx1mxjnhq35kqhlc868nfkw7i0bgshizaqf"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "0bk9wb7vmb5d8pr2lh1zg0gqkx013b760b6mdhpfc0qp3jfqza5j"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.1.23419.4"; sha256 = "0s5yrj4hgamn6r69z5a8phm8v2wcq4f725jzlpfa90wnys09qn64"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.1.23419.4"; sha256 = "17mla05aq6ab4amw6arq068i3vf3f56gdzhm1s9k2298gfjk71c3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "8.0.0-rc.1.23419.4"; sha256 = "059v72l55w71i4410jifilgzv9f08mkal7yq87smm5pfmqnl2v35"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "8.0.0-rc.1.23419.4"; sha256 = "0qxnryxvmn6rd8aa1v8knsh974v99n7pqz7lzhyln5f5dr0rpr1s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "8.0.0-rc.1.23419.4"; sha256 = "024blpk2224i4mvkkdmjrk2zlb7kh1shahkbbk71l7rniagyd2aa"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "8.0.0-rc.1.23419.4"; sha256 = "04k93say7b842bvh2x853skj5ymxsq3b11vf6rkfcqz6b7hvn7pj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "8.0.0-rc.1.23419.4"; sha256 = "139j4mdjhqnysgal1zifnhwpmnhd8i6a0x46bjxcwskqm3n85c2y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "8.0.0-rc.1.23419.4"; sha256 = "08mfzspgv3sjcvc2smcsab4q35mbj7cn6ky08nr5clvmf32ddkbd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "8.0.0-rc.1.23419.4"; sha256 = "1wq65zww0ng7w8078bi10km23s7wf1fr2srmzzsk2ailhwhp0ky2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "8.0.0-rc.1.23419.4"; sha256 = "1285632nhb4gqnxqy1rknfzsqn6cg2xaz1p0chdiqdjlw6n8456x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "8.0.0-rc.1.23419.4"; sha256 = "0q5pkl6bji11bskxhgnimbbl9zzv3ly335h169qdi98xig7npv2s"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "8.0.0-rc.1.23419.4"; sha256 = "0998hg6n48j7zrhkx7kyn5hk0axf7h9g61qh4gbfpn353zf6ajbx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "8.0.0-rc.1.23419.4"; sha256 = "1s1i1xlszd7rfrg76m616rlwg96zsap81wcjvj68nijfmv563snz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "8.0.0-rc.1.23419.4"; sha256 = "0aif2k51bxc59rskjivcp7lwdnmdw7dnh5gw5aj0hgd1shljms9y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "8.0.0-rc.1.23419.4"; sha256 = "1j5l7zqr8jkj4bgrnmf9ay0zfc43m47q78f8xkiv96pa2bxp9b29"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "0aklq0jrjcqgihc6l7cn1j5swz3kxsq02zrvl745a197k2jr10hm"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "17ffbsy4cfplaw8cdly3gqfgkzqxmbgrbwnqca6b7lak1ab53mr3"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.1.23419.4"; sha256 = "0kk6w9sid9hkqggxxnmzmz3ng14qq049qhz06zq40lhcgbyik96h"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.1.23419.4"; sha256 = "14s7gxqid5yrlja1aimaq3r40bj2p5karn8ma80368m3zlslm1dw"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "0k24km7x79kxy4blmgzclvqw4m8smlprb0hyi279s1ddg0vpplc4"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-rc.1.23419.4"; sha256 = "1davz97niy36wpsim42yrjm77k6sflcsc0sy5nb6lq9kxj02hypy"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-rc.1.23419.4"; sha256 = "00xw4yjkvdl0x1c60cbbh5gf51cmax2laplhlgilkyazjzrbf3xr"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-rc.1.23419.4"; sha256 = "08yqn96i057lfdrs7xjbambw7sr2aalhskkblvyhqykf8sw24ckb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "8.0.0-rc.1.23419.4"; sha256 = "1w5p3lngqmp5yqwh96kjdhdlzszik5vw9nx7snsfysjwyhgbr8b0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "8.0.0-rc.1.23419.4"; sha256 = "0zwvkqg0nf981gr6wff2ci2dhb6rc9girg3s0gqz7ysldbxnznsd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "8.0.0-rc.1.23419.4"; sha256 = "0kc57i32xqmrjif82czr7ivsrzf41wmdc0zjkk3qak3j8s0j629f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "8.0.0-rc.1.23419.4"; sha256 = "1l8mz0l6g4zv2qnrfsj85miknhq230942l8xvw62bzw4rv89lcp1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "8.0.0-rc.1.23419.4"; sha256 = "1d7m6zgiakdqi6ga0xdaamqjk6y8bxd2fxirmrgzpr0l57zqwhc3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "8.0.0-rc.1.23419.4"; sha256 = "084pm2qnh8mn5cpf4zs7drqs5zifbph0s6m9h62xgrixw3jv4i6x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "8.0.0-rc.1.23419.4"; sha256 = "0szyl8qyc5yc2ah9if4xk20wgny5cbr7hmdl2mzqpbpn5fcm36b6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "8.0.0-rc.1.23419.4"; sha256 = "1mavnwcgnzx1dn7h0cg172p0yv00xdaspi6vk34df1s6d4cc35vh"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-rc.1.23419.4"; sha256 = "0xqxz80rr7h1qlgw6ax2pqj33ngv31xbzljhpd60iv229lfzdvia"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-rc.1.23419.4"; sha256 = "1k6ivz7pcwk7w7fq283q2n88bm0rw7acfl8w9nj8iyag8gi7rpyp"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-rc.1.23419.4"; sha256 = "0al490xcj68xp13q2xl15wd03zld1l3qf88sd651q6jixgwrzbm6"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-rc.1.23419.4"; sha256 = "0wan79hagmkh2in263lbpsydr96l4s6i48qylpgn3fzwdv24idb3"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-rc.1.23419.4"; sha256 = "0jb3gx2ydf4jq0szk071g4l4286alffa6hc4xhy3zqax4vggyakz"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-rc.1.23419.4"; sha256 = "0v4g1bva86vxvkhfcimmr30i5d7xm0r9sknf84az2b450b5vfgpm"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-rc.1.23419.4"; sha256 = "0944c1j5gd3hvw7aij5y8wydbv70zb7dw8gs4qpavwjg8vcbs9cx"; })
    ];
  };
}
