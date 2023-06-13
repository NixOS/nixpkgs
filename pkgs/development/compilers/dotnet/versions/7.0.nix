{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v7.0 (active)
{
  aspnetcore_7_0 = buildAspNetCore {
    version = "7.0.7";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c1e2729e-ab96-4929-911d-bf0f24f06f47/1b2f39cbc4eb530e39cfe6f54ce78e45/aspnetcore-runtime-7.0.7-linux-x64.tar.gz";
        sha512  = "e56ee9bc458214bce461e9688e5229ba5b69046ec38a27bfdb2b5413d4b41500cca40152d182793c2768318719d97980b62ae9724de75d6d02874c25e938374d";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/803c679c-de71-466c-8ada-81139a7c55eb/03af937e87cd7220cf22681420ce0595/aspnetcore-runtime-7.0.7-linux-arm64.tar.gz";
        sha512  = "814db12231db89d9935404ec6693b3fb50ad022c0affbc131d657878e194274f1af5e92dd32c2c4f2a78a7e38d0c18a46ba4ecc67630ca3adf5b7550367c2366";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e052c143-c16d-45bd-a9ab-af85c66177c8/d8bde85b6f127ce794274c1bc111034b/aspnetcore-runtime-7.0.7-osx-x64.tar.gz";
        sha512  = "142fc2136112ba4397409a9eda67ba708611d5ac3d019bbb86733c89138d285d8bb2d02fd2bd3b2a027b76b6a7fb8369745ca1ee4740f046a9d0867c40271c38";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/97bb1f46-3b87-4475-bc06-e5cb7f4e6d0a/3e36e0c804c5805d2fe856505d7b1b3c/aspnetcore-runtime-7.0.7-osx-arm64.tar.gz";
        sha512  = "e6979ab34bea777f1f48bf9208a024b33b1685ec236f13c609975ebc7e1f641806b47daefb9ff1f74f675ee6242b628edd615982bc9c014d18e18cd2662171a8";
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
    version = "7.0.7";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/123d8ec6-beb4-4acf-8e9d-b54d2b99bb20/32f203246f4a87d70c339e8e06dc9c36/dotnet-runtime-7.0.7-linux-x64.tar.gz";
        sha512  = "02c4949f2edd4c0e63286443e11f961ee2cbd173eda93b5ba192e7c95dcefe74754222f3986d00f71b213271c184d5c12796a4345d19936a38c45293ac76dd94";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1b3e2977-140b-48c1-9125-5a542db56d1d/3d3e5d2c24689b63486cf1c61a00b50c/dotnet-runtime-7.0.7-linux-arm64.tar.gz";
        sha512  = "95d2b4cceecd1966bf61fa016b4deb3241c4ffd80cbe6ea1a2ab5158401493e87426b8f41e150e595757fa8e8fb06a8e4631ffcf6bb1a04eddf5ebd9b5e0eb2e";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b2d14614-44a5-42f6-92ed-4cb6579c66ee/0472b42d3551d3e673aeb86cba23b95f/dotnet-runtime-7.0.7-osx-x64.tar.gz";
        sha512  = "d1f76a39af4d516bb5670b2e38b0dd4775e7980a5b312c069cfe7016b567521c0a98608d550431337737cf6510f0be1f6ec74f0cdf30c948c0177a7543835d80";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e3e4e56c-8ee6-4aa3-a9a8-6ec7e6b161a3/7a2aa1a2c69ec5f96e7ed5430a1a8933/dotnet-runtime-7.0.7-osx-arm64.tar.gz";
        sha512  = "440338f74bf45f143e160eb2443134d9d8833f9b0a9507443075898f23e8dff94acf17a41c8e2a4c648a977dbf977b4fb568e2d5db8c9999d7d67c7110d7d3d9";
      };
    };
  };

  sdk_7_0 = buildNetSdk {
    version = "7.0.304";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9c86d7b4-acb2-4be4-8a89-d13bc3c3f28f/1d044c7c29df018e8f2837bb343e8a84/dotnet-sdk-7.0.304-linux-x64.tar.gz";
        sha512  = "f4b7d0cde432bd37f445363b3937ad483e5006794886941e43124de051475925b3cd11313b73d2cae481ee9b8f131394df0873451f6088ffdbe73f150b1ed727";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4d36e684-4405-4e54-a6df-7f342ceda377/956ae226bcf74d038845964e88c6904b/dotnet-sdk-7.0.304-linux-arm64.tar.gz";
        sha512  = "eedfa933039e749df49dc80bc5ccb6d46c2799ffff2f634924ccc699cdbb8e08c12507ccd4f5392fbd05838696e5a642843c2da04ee7bae80e4eab5195138f6d";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/18e7fd79-48de-4ad9-a7a5-a659a485e3d7/fc0d190f90917587626fc8086ad6d2f2/dotnet-sdk-7.0.304-osx-x64.tar.gz";
        sha512  = "8ac32c684d9a9691eb2847db50638e7a7179d52882d8a364e8a7b9770fa57a2119141f3871c59556e386709c895ac7b580ae374a3a32fbc652d583d414b3e29f";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c7a10ece-45cd-483f-be8d-15a10b2d0c51/1ded758a3b6140c435e283b0d0ace182/dotnet-sdk-7.0.304-osx-arm64.tar.gz";
        sha512  = "c71bd602e964a9c000c2a7c336039497a41dee8355f37bcb687ab5d27391ce4affe5f1d520ef46f7ac52256d0695c8296f8146686f754af4f198ad54b92031ef";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "7.0.7"; sha256 = "0f4jf9m8mdm93067w04crx80jy7vvsbw3f7j0lz2dg13bpz30smq"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "7.0.7"; sha256 = "0amn01562w51zn7f1jyhwqav43ivzhxqgwpmdyzl5gpq7vg4xaz8"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "7.0.7"; sha256 = "1b2riw4lsg1j7dpnkxlq7djpa1cq72w2s0zf48if0q0g2vk1f981"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "7.0.7"; sha256 = "0w0a9c3zikv13z3yb0v681vb478lgg6dbf83gbawabaxaga5i46z"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "7.0.7"; sha256 = "0y269pjj2lmzg19vlyddqvq7ay0bqbjcq2y3xlk0dskcv289y309"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "7.0.7"; sha256 = "09y6gc20vylz1pk5k62bn8lf3amq7hy5pvk55l12h4f4fkzfjs75"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "7.0.7"; sha256 = "18489ci2gbv9y55cfxkqjb6bn8pf9w3gk3vb5iz3nqayx4jf2mhz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "7.0.7"; sha256 = "15d6lxh1227xw78g55b7rmr6h3qrsb0dxbqfwhq6xi641pnmdzc3"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "7.0.7"; sha256 = "1dbf2p3vykrwbv3492sf9n4j8k1bwdspl7j7alhvl6ab3qcyw5wa"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "7.0.7"; sha256 = "1m16bnbl9c5cr4sfbxin6hqabxf0zm1dhrffhs3mk96nf3bqrm7q"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "7.0.7"; sha256 = "1chk0nhbrxa408wvk8v6r10aax8mwy821a6cmllpaw97p058b1bj"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "7.0.7"; sha256 = "16r61daa566hagxf2bnxwgbh8kb5353g744qhpkwn3b1l1vhp427"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "7.0.7"; sha256 = "04n2055fdv3fhppjfd1zh50fbdcncw1ldcwgj6y0z9zhkbc5c68c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "7.0.7"; sha256 = "1c6wn79hyv3m3fmqj11y61ilqxc39ndd9m1676pi50nydfc301xi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "7.0.7"; sha256 = "0zfq188hmgn6l93b0dshh0yb2cnh6pk366psc1iq9yszhl6p4ril"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "7.0.7"; sha256 = "1l18jm8qd3yrglmwgjphfk4jz5f0rs0sggb8gp2kvd1jz8d4aq4a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "7.0.7"; sha256 = "1g7fbxs7aq68cgd3vhqzxr87wsijvjpcpazf65kskn3vr8gacpiz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "7.0.7"; sha256 = "18w443m7kg7inxgnp6j4ym3zb8cpzi6fgf7pknrsx1zmg4qxhkzi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "7.0.7"; sha256 = "017rampnrspwrmcxc3sr55rvnzldqjygwc3v3ykbkfdr7lksngn2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "7.0.7"; sha256 = "18hxpxsaiw937z9hj0hpvwspqf55gqz2dd1csfc459v65r4fan0x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "7.0.7"; sha256 = "1qlrlpxnska62npd8lksl70ya99qfsljp0vjvla9rhnyhxww67zg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "7.0.7"; sha256 = "0m7zlq6cbi2w7y7ff3kdl2l0dhcagbnbinrik7j6350lcqpx8m48"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "7.0.7"; sha256 = "05hg0ilsh8h2vdknlzkisrb5y5vxaq119p1z2f4smavp3p00fn0c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "7.0.7"; sha256 = "1c97hf8s36n8g55rirgpzq74g62y04hvn4ckqkn00kk8i8h6hcnk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "7.0.7"; sha256 = "1plxf046sr6c0v873wzfxy86zppmy3j0wfh5hjgrddy92dy2l41c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "7.0.7"; sha256 = "056r5q9k9ymdzw8q1dmkljl7sid7wvjyw6lv00bzf0dwfn34889p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "7.0.7"; sha256 = "0a1zzwwgfhg5rs16444cbfig0f0ypqn3wh76h6zaaw3810h6p3wj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "7.0.7"; sha256 = "0v0ja6j6r529jm4bx1781zm3rnkm45b3hi2l00b9y2zbbw49ln35"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "7.0.7"; sha256 = "0c7sg12l9xdv7xq2m9qzgs50yr4gvz10kmmk8h8ndama823s2mlb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "7.0.7"; sha256 = "1w773ahjmiv43xjp56nz1nkaiwbl6bj5zgdybihzah5cwf1r4dwj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "7.0.7"; sha256 = "0sw4awgkw6s46f3ladqs33p73a82zkrlygd7gnqzd6ynzr3czrlj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "7.0.7"; sha256 = "13p19k3k5wds60ci0qbc618k9yw809759diqis7p32adaf64lcs2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "7.0.7"; sha256 = "0w0lpabmyh0c2wam8jfvqhkdl798syznrparr9l7sac0gi57zj9j"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "7.0.7"; sha256 = "057rgppwk92i0pb62myr83h5yrrynjw5q8qqh4pfzhwbwh0szg41"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "7.0.7"; sha256 = "0fck0c1nddr152xqmc73byvi0iqa2aw65kjbv8363ny1b6zgmwrv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.7"; sha256 = "1sr8z77zh0lsb1fksp5gmw3w1wyb7liphh87dwghm3ing8facfng"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "7.0.7"; sha256 = "06fjfvqxy6akk3p1qh2mdww4sg92z1m8y538mpbwr6pfybph4fhi"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.7"; sha256 = "1pv77y2900l4s5krglilfy345k9cqqgk01z0hyazsdsfblw28m8c"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.7"; sha256 = "1ibxnfxssnwn0mbm3qinf62wb4787sbj2qmls1mdi0rg8b8pj0sh"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.7"; sha256 = "1lrzkv7ypb9w3fmvd41l1r07kpwhyx66iysmwg50n499nwmzl20m"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.7"; sha256 = "1a5yxlmps3m9j752c0ynmljk3rr7xshdiyp6m07kgk3k7xlw6d83"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.7"; sha256 = "1lllvwix6ps9vgism7x7nq9i9rvawvyf5x8xsmm765fiac070f5b"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.7"; sha256 = "1k34ap17kl45wzjcvxnab18dmr54fncgw4n8i1zilp6d91j35lj1"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.7"; sha256 = "12x70za09drfxhqa1b8j5bn8kfkv8y69fd30i4vkmk1c0l73a5bl"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.7"; sha256 = "0mnl7b3qa9qppryky635gx3m88h0bcr5fqklpg1dk0l664d7xx0c"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.7"; sha256 = "1h6g1b11kgkgrm5q85pp5hq224d46lkbjfyv9zjbh65mj5ybaj0x"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.7"; sha256 = "0l3hqdxc729f5wpi1jamv7lngk1rp78q1zqm1f7kvln9rfwj6n54"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.7"; sha256 = "11j6603gjhny29i0wmw9d7mmgdjd82ik0xcnm7frp46wi3nx0h3b"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.7"; sha256 = "0mfd9jsw22699avb5zsnyfgxlafh0f2r16rn6wcsjw6yppz2y3qz"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.7"; sha256 = "1fpids1q90xwl1kdnkd1m4xjc082a3hn675djcir9l69iagh5m43"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.7"; sha256 = "17szhhzwpi9dg5i1xn0p0qr39zl2xc5rmk19l43kblvn7qhjdgcb"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.7"; sha256 = "0p2cabk4qqpm6qjsknidm5kgv4q47rxrnxmxrhjr23jrr5ivl2dl"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.7"; sha256 = "1ka7fcby17za9rrllgyapwbdb8vmfh1n7yf04llj9m2jdrb4a68s"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.7"; sha256 = "0afk2bcvg1w9m4mshxw7kibzyn43595hsni8dqlcwnijgk1bhvx2"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.7"; sha256 = "1l9whyz1gcwx05blm53rhaipv0brmf4rpk022fqm9ig1zk0c6j0d"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.7"; sha256 = "0mrz6ysg08dpyxiaxs521fdzyi3biv7sbq3106vgvvhn8a3004a1"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.7"; sha256 = "0s3jdssvcah1755ifivnipb43a5k33dk8zlfgbsb7wpfgpdcnb25"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.7"; sha256 = "14mgqy07i0basdh186dmw1js92xqgx43gmx6vav0d9s0z90js6w0"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.7"; sha256 = "0npvcwq4wb0pxz1m945a6n2q0f3nd91jyd30b49vipmcjchprzp3"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.7"; sha256 = "02pikwzzmmw4b19fdmcx0s3frjrpk5ngcishjw7sfc69nxzwj8di"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.7"; sha256 = "188wkb0alscymwbkwqz13q4n957k35y6s9h9wasy51yw18868693"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.7"; sha256 = "0jnx7mmwy738qgz644msb3kcpnfsgga50da9qypr876fssn6a2dn"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.7"; sha256 = "180vdwwh5wjqx0znm7y5g8npkvmpc20wjq2iir09mz7dcf3i8z2h"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.7"; sha256 = "1j5qg8nwa4ndha5ih7a9izkcx9zq02zmg2cxy5f6hbnas2gq2is1"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.7"; sha256 = "1imgnxg1l4ssa24yjh90as9nsh0fykybraz08hh15dnf74jnvzcn"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.7"; sha256 = "1gd0yrqmfn37fxdsy659bcpisrsa90m41zqjgsbws0r9pacvz6xs"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.7"; sha256 = "0np2a1rbnznpsd4hi18cvfz9zv5kjszp1zmdjkqmz9651k21z3cv"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.7"; sha256 = "13a44dbsiinlyw82sspq6z3wc7c5phn915jc957s2ajngap42gfr"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.7"; sha256 = "0wa70wrvmi2hs1yv4qrkkyxvvia2dy7zjppni8syrb8chqm6zcx0"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.7"; sha256 = "1qyv6phm1pkdzydmmdnlzdi740nkjm4ra7rqd0zpz0ynxi6slxay"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.7"; sha256 = "1l9mcrlfm20hfxv1g4i511xw0laaqmzrkjki0d9nvlrvxhpazjpl"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.7"; sha256 = "0ai4ywzq7fspb11dii90x63cl38fnqjkbdz5llb3wqqfv8i5sdd3"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.7"; sha256 = "03kbgm47xw0np6nnk25ldbqmx5j4qjnagjmmvc32r5j0c589kk4p"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "7.0.7"; sha256 = "1jpxc18mrdnfd4j1d6ixa9v1159akz8pj55gzk3qz6wpbwbwspm0"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "7.0.7"; sha256 = "1v76cp5hs8mpn7lwzq3p201vk240a811zwndf3yg0921yd5dfvyn"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.7"; sha256 = "1r8krg1v2w56xymlf08i6qfk79nij60zzmm56kcqkznjm6cpqbmv"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.7"; sha256 = "1xcl9b9xkwm45cpmsz4ygpwf318jwc3b9bds48cr21mkals56gvs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "7.0.7"; sha256 = "079bk6xbgqz1q483k76jqgaj7fpz3jsnyw0fwg18bgqslm666gl8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "7.0.7"; sha256 = "0xbgqgwryqrs3a6asfxwzgwk8m64rww55xizx5fm4sl6mcqz6xjn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "7.0.7"; sha256 = "16300jwjfj5m9zgyhx049l404b0fw91pip10w7r7brzskq012lzp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "7.0.7"; sha256 = "02mvsjjffwchj7w3bl866phkgs5zkwjfwkxv7rl13jwg461a7d4j"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "7.0.7"; sha256 = "1qa2bs0dss11ib2kxpdgjga2fc13fsn7mbm88grsmlgpn1xq4hmw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "7.0.7"; sha256 = "0b8vz0kaglhp79c2547n8w9lj66f83zybq02vkza2kr0yh5v1qn4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "7.0.7"; sha256 = "1rhxjb0kr4fk8qvbwdzdznkq8ryqk3f5nnni5xzlw3dhn18r8bg8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "7.0.7"; sha256 = "1cn4f5bh7n7wwgj6vkqhnkihh622iq1vbcjxx8d1gimwmwdr2gln"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "7.0.7"; sha256 = "072f0nvh0q2mzz3a8k6kh2w0pq5ppm36b1r8g1lhnpnq0ch42dxi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "7.0.7"; sha256 = "17wsi54lvydsr42fs7vjccfy6alc60qb1gpnpwg2yzxgv7l2kblh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "7.0.7"; sha256 = "02dr4rnrphyzf5alxyiypfhcf24mhy47yn6asnrxfzjxbgzw9vwh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "7.0.7"; sha256 = "1pnvz275ckspanc53k8y4kl7qq0nv478clpcxgjbwgv8ggdzqaf6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "7.0.7"; sha256 = "1wywnzybjjghn1sdp010dm5dxc9pbspc0lk2c5dk3ixkf69qcsdg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "7.0.7"; sha256 = "15q7i73iwnrw3lmfdiabzsargliy7slrijfncy5dv5j0gacwc3z3"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.7"; sha256 = "12qcq3v5cazahm2vy15yvqwmcwa51l2kv70s4zrpk2cifhqpavsk"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.7"; sha256 = "0i7n6d61kc3r4307fxhgyhx2vk2r3yg50j9z1p6krs0nxa7g67f6"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.7"; sha256 = "04w3s9v4wxrysa341n69znmqs7gg7ywzni57ysxkh6i01wi1m83n"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.7"; sha256 = "18qns9568xwpr15864mcz0wvsd2gkfgzys3h47szr15cjnrmd209"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.7"; sha256 = "13zw6kgdni8ixcxd7my91mdgkdci9v743bpl3mhgrf8gs316zwz9"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.7"; sha256 = "1x0bd7b6yjm38k64df1l7jwl6fn1n0wgba8pxrb1dw97ijcq6pds"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.7"; sha256 = "0cri9fbrsdah7xr4x9qy73n3pj0zmrwc8xc8a8zj299xmjx41srp"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.7"; sha256 = "0dp8j9dc46v46zza9i4i7ywn3cz43fxyhzhiwls6nzc9z0y3xnjb"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.7"; sha256 = "12ayxmqacv8n38vvp79g23wd443zs2ws8k64p08pr8aymcpx22k6"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.7"; sha256 = "1bm9rzs5lr6a8qxavy7drjv5z1vwxyh1fcv9cag2d7g91q9ljhxn"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.7"; sha256 = "1hb8dd0hwmng2j6bk1s76lkl9ap1rw687cjccv5g79h30fadcf2s"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.7"; sha256 = "0zl5wlkh432gbd87dbxy7hm2xp7snc9z96n63i8h9vz8nvxfgiw9"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.7"; sha256 = "161x2cc39g07lkv3fy84bn5r2mcf3zajidsv4c3f4g68bp30g48v"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.7"; sha256 = "0fd2f787dg7jnvklxylb1ljpbsln55w01r4r77xralpaxh71aiwk"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.7"; sha256 = "1fl7x5kh3rj11yqbpwwc167ymvw0l2cpswh9wmsg2ivng003wk80"; })
    ];
  };
}
