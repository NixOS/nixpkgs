{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v3.1 (maintenance)
{
  aspnetcore_3_1 = buildAspNetCore {
    inherit icu;
    version = "3.1.28";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/effaa5bf-0fa7-4e5a-9ce8-9ac04ee86669/5afb2b1c2ad68550cec914d8fb303d20/aspnetcore-runtime-3.1.28-linux-x64.tar.gz";
        sha512  = "fd66f9c0d0e9ed57abe5f81650c2ff49c694e05927e5280dbbdee1a9eb4299f0710bdc06ae0af0737c0a0584970b24d3eb952434b45ad8984fe3e37ca95cc1b1";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/75b4f8b5-8aeb-4ba1-956d-bfc17ba5d6b3/bb3744801157ebc769808a92eabeee5c/aspnetcore-runtime-3.1.28-linux-arm64.tar.gz";
        sha512  = "28371a6888d41e938f14cceb6c8a4471a1f0d7b585045e65b914f23ffb894f72a66a4a4cdaaf6d21dfd60063bb35d88c36fce8d4411a89c89b52023807639f82";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a9ad2468-f18b-4d35-9b9d-f2bccc681bdc/b3100ca07ee0e8dc4ef958921d4adbfa/aspnetcore-runtime-3.1.28-osx-x64.tar.gz";
        sha512  = "965b23a32a9734c72515430e05d395db506a3a802997a6268ed42e24a700f06e5971cd38102f4ceb9c9d85d8515c1b0d11d4e5fbf8adc00c14060cb503a8faf1";
      };
    };
  };

  runtime_3_1 = buildNetRuntime {
    inherit icu;
    version = "3.1.28";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9a0b8ff8-d3da-4e77-9b5b-2fb3202afbbe/94dbcaacd4ebf59106a141c8e9e84167/dotnet-runtime-3.1.28-linux-x64.tar.gz";
        sha512  = "b0760d463b8935a14bc247899b692038ded7d476a0cf2ed262eaac8ee6840350b29738cd1ab4961ba93b05f1802e7aba6e3c5e27e06ec9cb5e244149c52adea4";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d71449b4-4504-410b-a805-48b3a6af5182/06abb8b35645e76dbe8cc4d17fdcbf89/dotnet-runtime-3.1.28-linux-arm64.tar.gz";
        sha512  = "feb65d2926e21df802c600c8c8c060d15cf44458150b2be8a5d9dc42735cb89d1a5e990121f7ba5813d6f8acf88b6e6bae11d078156c84023e1337b917219b17";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ff22de78-4644-4395-a187-3910c27222d6/95c5a5334aa3c861238518a66696efa2/dotnet-runtime-3.1.28-osx-x64.tar.gz";
        sha512  = "ad6ad23b08460eb09b5019760083906df96d064a5f0a34aa9b31b4e1eb4c8313ee59c1f3717056e3e9f4db8310329f9aed368bea6bba3c0a86c4a4ec7083bbb9";
      };
    };
  };

  sdk_3_1 = buildNetSdk {
    inherit icu;
    version = "3.1.422";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4fd83694-c9ad-487f-bf26-ef80f3cbfd9e/6ca93b498019311e6f7732717c350811/dotnet-sdk-3.1.422-linux-x64.tar.gz";
        sha512  = "690759982b12cce7a06ed22b9311ec3b375b8de8600bd647c0257c866d2f9c99d7c9add4a506f4c6c37ef01db85c0f7862d9ae3de0d11e9bec60958bd1b3b72c";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/fdf76122-e9d5-4f66-b96f-4dd0c64e5bea/d756ca70357442de960db145f9b4234d/dotnet-sdk-3.1.422-linux-arm64.tar.gz";
        sha512  = "3eb7e066568dfc0135f2b3229d0259db90e1920bb413f7e175c9583570146ad593b50ac39c77fb67dd3f460b4621137f277c3b66c44206767b1d28e27bf47deb";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/515fcb39-1e67-4cf5-908e-0e00f3cd76b2/6478e6b98726db240cb6b572f9eab97e/dotnet-sdk-3.1.422-osx-x64.tar.gz";
        sha512  = "9f919e42a692e048405b52cce8938fd4c40e7dcdf9c6c29eaa41940af7846cd2a678b5c43222d1cb988236917e47d85f37212bfe0c2dc6973cd5a8f2799838ff";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "3.1.28"; sha256 = "0ssf6qdsaihg86pb39162xi5sfnv6b2na85brk6h3gcw2ydqfgbc"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "3.1.28"; sha256 = "0gri8zsq5qk5czfg2ik9fc0a3nscz2jn7g1knsp717qxix31ilaf"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "3.1.28"; sha256 = "0wp5nrb63k9p5850bfqjscf0hjyqi5dcw8vsymnfnjdd06zldp6j"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "3.1.28"; sha256 = "16p8z8n47w7m89wy34wh7zyg8a21hbsv8vswrw3b6gh3r861jg24"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "3.1.28"; sha256 = "1cvgplsmg6d9bgxr7lnnnh7lhcmwhn3r08cnw4di9x92xaysgzwg"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "3.1.28"; sha256 = "1zv3vjifjcd56q8xp47998d4016a8ma8x0a2pdlki2kghwjjpmcv"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "3.1.28"; sha256 = "0myfvrwn13z8l6j294jw9qrdzg4ld9dp683jdmy657q30vxqj9ci"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "3.1.28"; sha256 = "1dhg0p820mg2v0gh9yd4snh062cbz0mg106idrii8mhkn09na698"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "3.1.28"; sha256 = "04ss3gd6frf7p9ipry427a0cw9jh4l1xapq3sc0p33hd9g3ggkp3"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "3.1.28"; sha256 = "07r9gd9gc4b0h7fdswk3c4bf617fkcy5jw9y2y8rm97c1gfxph3p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "3.1.28"; sha256 = "186i94wddk4j93pqmwzr6fdrf8vqhlipansjfpp530l8d3zba7zp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "3.1.28"; sha256 = "0asdcnqf2vr9v159brdhg0wmfbvh8gl9n14ynv0h561dkdlps7fr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "3.1.28"; sha256 = "0y5m5azblkr2vi8qba83mnad7irmywn7i1b154yig9r09245plgp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "3.1.28"; sha256 = "0bm99w4v4mw9nj400szvywripgv8vk96vyxmpr0vq96fpzkx66wr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "3.1.28"; sha256 = "09974p9xl37x3dgclpvv280kiclnlvlwg31id8bkrz7ir8iafwbx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "3.1.28"; sha256 = "10rrf9gj81viisb31mc0nq90wr9fbnljzi0vn7bpylj68072sqi2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "3.1.28"; sha256 = "00wcigwd6pphmcb19pj6krj4p8ydzzclgvjxqj45fdj8ja94d0dq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "3.1.28"; sha256 = "1rpj5mscc0b15dr6fphrb6lbkycd58d95n6r4vm40124c17nrp70"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "3.1.28"; sha256 = "15fp5g6334ri43vk4cas50b1fg31y0l7inba1z7fwbcrlf7kj72k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "3.1.28"; sha256 = "1ac9538bx4l4skk295q6d3hm3yfrf3b57zavhlpy8wpclg97wqmc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "3.1.28"; sha256 = "0g2wdkm9dcs3d106r80q84i5plwhgnv34abpda8id993dprjpkg1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "3.1.28"; sha256 = "175195fbgrzxs4zmgnx9xy3mlzdvbd8mrlya2is2s0pa0dz3aw61"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "3.1.28"; sha256 = "03n58cibw0dk782yrxargnbcrhwv43pvyiic71hvf2kh6hi282gp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "3.1.28"; sha256 = "1xs1x03xmmxpy686wydb2v9b3vwb57lhjdxm4spsh74n0iwgbznq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "3.1.28"; sha256 = "0pn000bgrb0lmqy34np3q974n3x4cv6rz1rc0w5n7kfnrlpwl15l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "3.1.28"; sha256 = "0hgj4pib1ckl38hd197g9x22dvb2h0302zny6za6156sblizypr4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "3.1.28"; sha256 = "0irh5riigrpq0wfqsbphf3r1a4w29p547pnml8h5997mmch5ds13"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "3.1.28"; sha256 = "0fayr4rp3ykn0rp3jir81x9ilvg3hfj8s86raxv19k54x15grqw7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "3.1.28"; sha256 = "1j4hf84ycjhna8ng8hxl3bmwwbnzcfbsj751widwhlbnsy7vdiy4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "3.1.28"; sha256 = "0mb5kr8rqgh4m01n20xdw8ji87ixxan9qkbjjr7amiv38x1aimfa"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "3.1.28"; sha256 = "16jm0pcjhmc83f5c5hk2n40xc73jg9358yw1mwm35jp5z15n9nah"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "3.1.28"; sha256 = "184qcjc3h70q1w3mjjbmw7w7fq4j6daw5hk53zgbpicfd928i5fm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.28"; sha256 = "1vx08xz65mapyjs6ixnn31c95i9b35h8fry4djdz167794zj2w0z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "3.1.28"; sha256 = "18jnw2cp3vpm9zkfbjv51gpl5786hsf5fdm6y89c5m25pckilvgi"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.28"; sha256 = "0k4qv1srcsyq9c0d0xik5bjrng6sxsl6c1n9f8q0vyar63d4dm6y"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "3.1.28"; sha256 = "1knlnq8xn3z87h2pwp12rcfiwzv7rf9h9245dhsaq0kv0h2173w5"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.28"; sha256 = "11m6hvf56iq7q736mx21yrk14qnbyz4ahm8517pz9amiilwnwdcg"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.28"; sha256 = "1hp6cysrhm0fn18bmiicy0plvpcplrjbxn792ps6iipn82hfxlfa"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "3.1.28"; sha256 = "1b6rlnazbm9h3rwdz2qglqbn44qxbzny8x0cnj5aqa9wxg0ipkqw"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "3.1.28"; sha256 = "1klfr2a842xflc48mw2zds4cb8s95p1m2yb3w0h58rnpkry4r8cw"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.28"; sha256 = "01v74s41kyysy8v4q20zbl1ba9n6sc55mizybvgjl869h437bikf"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.28"; sha256 = "039an5v5yck70pl4y3h3nphf6jga6vl071iiakv5siccvkpg2zcr"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.28"; sha256 = "03fmzxhhxdvs36zjp38h39g1x4zzabfhfac5k5a80m23kh8zk199"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "3.1.28"; sha256 = "0k7ngxhn39ybx3z64bds7kzwmnpyfzpyx6gyv8l0zw9gzaiakmzx"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.28"; sha256 = "0254fw61xcmvlah2c5fpl4ifslph9vqavba8b7i2b8hjj1ah569x"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.28"; sha256 = "0219z3dqiygl8j8q3khxdvkvpzb4lpk5r76an47lnxpqkw90ip4k"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.28"; sha256 = "0ndcp8b1is2h9rjrkn9hs468n9z619qpbqcnj11algpj0gcs00qn"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "3.1.28"; sha256 = "1fz9r6n018rzqarabfkqdbzm0d6nnprkx1cpyplxl6kmc60gp9f7"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.28"; sha256 = "19lavwarm8svf725vilh1zzwlx27khy27n7nw9d1cvi40r3vpvfp"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.28"; sha256 = "0b6wa3a479d4w1zxgk748q70nkcrzs3c2snlxhhciz4bv09mrbd3"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.28"; sha256 = "1pj7i6kdf8k31d9bczkggn6fdjrjigzsrvmh24zfz2n3q48g0grc"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "3.1.28"; sha256 = "0llnj78c9ds5y2cg2f1q1mz1kbmzm9vs35hq942d4lfv1hpxbd4n"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.28"; sha256 = "1nlxmpzb7qgznx0wmm6zci26y7wvkwndq34d4jm310g8qzrqkxn8"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.28"; sha256 = "0lbsyn96a3nfy94x9n6k9aka5v7q34hbbjdjd0w0is7njrly1xg4"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.28"; sha256 = "0qyf2n35bn0wp4iy4f2whfm1syl44k42g3md2dbivppdc16qs828"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "3.1.28"; sha256 = "091iff9mpp837vakyy5h7mqh1m90gz9x76ch5n49znq7qf819jz4"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.28"; sha256 = "0byn4ng5cs54r1gz84wz9g914n0dby643fs4iyx14v5pg9ns7m7y"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.28"; sha256 = "0jh7kmgxjf4xpsbxyf86yfq4ff0lxrhcykhc9mqizmgsp3kdzg36"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.28"; sha256 = "1x7xkjvx2j7khr6iafl1dvzsfqswr54y79lf17w8m196lbsvn13j"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "3.1.28"; sha256 = "18nqdrm8d2xdf7cq7hcbh5v2fa28kdyx682bb0wb4w06x4gziy55"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.28"; sha256 = "06gfp66ax9m2jhd07alcn0dp8hyxkyi934wy8asl64y1c08rhh09"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.28"; sha256 = "01q1vs13ifnbqywpmdli83w7bdhph88njz15dhmx7kxjadcicclc"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "3.1.28"; sha256 = "1kd6np0i0wfz5kpq2528by8sxmp2q7fdsncks9s7sk9s2am6q6wr"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "3.1.28"; sha256 = "1r9j70gykblfqd2cxnnhb0hpj0pidn9kk7c7v20bmnkv0vn8nb27"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.28"; sha256 = "0aqinv4s9n61i66dd499x1adiw64a83iscddjaxml4qzyffp3v2g"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.28"; sha256 = "13n0lshgwpwizz7zqm6cph621bk2ayhkkimfmp60wz0s9mhx78f3"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "3.1.28"; sha256 = "0ky15gpji8hs8hnibk3ckcqk1fpk20kgsgkvczpvq88qd0nzlp1d"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "3.1.28"; sha256 = "03n3ps5y45hgniirr9bb80cvrwsddb9ixj8xzlxzdg349j3cz5mw"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.28"; sha256 = "0a91gv56gl6j97gn7p0ss0ivpnl7gxhb90sklgbvvwp3601gka6a"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.28"; sha256 = "02i5cphwkqg5z5ariy2lrn8fbx15nbq3pzzw2ncja933zqg145zs"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "3.1.28"; sha256 = "01xcvlrif0wqq02p1x74sqvm95b9aqm5ada1q2l2xr9yglrzh0lq"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "3.1.28"; sha256 = "0j9b8xy9vq7vlgx4fbcrh1g2qypai2q5iar6fwsialrrgp3v599x"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "3.1.28"; sha256 = "1pl66sqxiw103bknbwcazf82sr2q6x1fk21h0d5xl7cgpabx53gs"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "3.1.28"; sha256 = "1jbg3gpmqrbnhy7rf7xjg84riyzfmlmzl8ixpy2ks59q0mm22vkw"; })
    ];
  };
}
