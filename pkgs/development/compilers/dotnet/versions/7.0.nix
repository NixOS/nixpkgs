{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v7.0 (active)
{
  aspnetcore_7_0 = buildAspNetCore {
    inherit icu;
    version = "7.0.3";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/29b10b5f-6e65-4a08-a348-488c7b2f98c0/ab7b72e8669d7edf3966cbfefcd532ca/aspnetcore-runtime-7.0.3-linux-x64.tar.gz";
        sha512  = "fff857e44179270d937543ab429ca43a4706f9189ee8f60afb67813d3690652d9da08bd3e69c7acbb7c0b2e613b9659c4d1ee7bbe089c841126efd07dc23a758";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b6b539fc-e39d-4fe0-861d-f95b92e9d9fc/0f2f004f2b6bd4409959c821bb61f97c/aspnetcore-runtime-7.0.3-linux-arm64.tar.gz";
        sha512  = "95ead701041655d9a0ab19dc8f53b7780eeca127499fc294124d466aa12daf930d756de59d7e8e8cd563a6a744b74bd5372d82fa95eca0973c94cbb1595451c1";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f836c792-49e6-4a81-b440-b5aeb561425d/c21cad25b413027b8ab2bc6993210675/aspnetcore-runtime-7.0.3-osx-x64.tar.gz";
        sha512  = "784d8655406535cc6844af63066e51377594de17162ff2431acd8444a5ba0c6434271b592c38f3ace2da0cdec693f3bd2e681316b972789a577e05ad1e9c2e9e";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/09261fcb-ce1b-468c-8c5d-54058e75e5be/d96eac7765210eb09f37362b793b0934/aspnetcore-runtime-7.0.3-osx-arm64.tar.gz";
        sha512  = "379dc7aea65cf0c97a919386f0e4e756321f522c6f658de303543763b0820ff9a6efc0e27c908065a5f95ff740d6ba469eaf264b1f36b017f2fd748d76787458";
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
    inherit icu;
    version = "7.0.3";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/2431d5ac-f5db-4bb1-bcf0-4a2d9725d4e4/1b0747add72af919754509f83ad08660/dotnet-runtime-7.0.3-linux-x64.tar.gz";
        sha512  = "d5cea2e674e9430174da793942b4ff5dc1b64d12c731dd3324ef520a2fb11787782f2f8ffa83023c41a0282ecb174e2a49a2c0aae1b327a58fcbd2bb06c4e256";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9a7f3ac4-7692-4474-951e-c86beada28e0/0842fba93ad196897ce6bda3bcfd7edf/dotnet-runtime-7.0.3-linux-arm64.tar.gz";
        sha512  = "605f4d9657396eb2c9825d1576836115492221a7733f36638d9c6f14f1c15481c908b6c8dcc619ead34beb4d4991d810e2a69a8bccd7c49ed0f4d72411d1a5f4";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/c8f49e77-4d55-4a33-aa87-ddc034be61a2/77a50b1726446bee5a3a4dc6573568e2/dotnet-runtime-7.0.3-osx-x64.tar.gz";
        sha512  = "0c3facc23e8db48bca33e3133ca85c2c6893a56d79f83d87179e8520712cb76c699df0040dda5999591c47a128a7a3b365f62b500cf802091989a23b41eefded";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1dd7d303-2c33-4fa9-bb3b-150f768f75a6/2df66ae5492711c468f1e6c582a440b7/dotnet-runtime-7.0.3-osx-arm64.tar.gz";
        sha512  = "2bebf2296eb65916bf4b88c9447df442b328047794fefe4f5117a9ce2053547b6df64afbfa8f36eed9a1650af37824fb2c325568deb3e171d8e5970a4eef6520";
      };
    };
  };

  sdk_7_0 = buildNetSdk {
    inherit icu;
    version = "7.0.201";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ec76d8ee-8776-42ce-b158-f723a221fc56/0baa1089edf0e0674d719f6a5d847b75/dotnet-sdk-7.0.201-linux-x64.tar.gz";
        sha512  = "fc9d224bf1d3600e878991fc1e8d3b1a0f21c7a8aac7b3cae0e4925ad33172cc12f56210eabfd66cfedd5f70f85918b889673401172b3999cecbeb8f2fe58863";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/35901872-1f00-48e4-9f55-e6c79823e7fd/8af43bb5e25d090c0af921974287ac2c/dotnet-sdk-7.0.201-linux-arm64.tar.gz";
        sha512  = "a4c4d0e7d51643d6a7ff3322f795f0cdf174f62689606304e4dbfb6b38717b111d0a21ecfe2efea0234947deb87383b7cdf38e96b7e4b7bc13127b0d70431b9b";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/71de3463-3644-4159-a7cc-e3b613eb7167/785a9b41cc226c368f44b5742bef466b/dotnet-sdk-7.0.201-osx-x64.tar.gz";
        sha512  = "c5f9ac1ec09f78433baebdcdfe47b715ece63df89b37bd4c919afb09cbb3183f2aa85e5fb12b9842582a343ba2524c5f1d764e607d7465ecd781744473c3fce0";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/92a51981-d618-43e3-a93d-d6f0d178ecc3/020dcb1797b5a73e690bd6ad511619e1/dotnet-sdk-7.0.201-osx-arm64.tar.gz";
        sha512  = "33264819fc928e2206127060935cc01f443f564c2e28eb9aecbc83865697347967c639820496f21c0a7039aacd83b548944fc2a3385f32f01079760e9d0cb677";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "7.0.3"; sha256 = "1lswf2zcc29nrdx03gy2s5km8d3zaap5y6zdx3p90a89z767szcg"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "7.0.3"; sha256 = "1gfyqn029r3s9hdm0lqkd781m8p3y11gjsj7pwki7a65bh1ynlaa"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "7.0.3"; sha256 = "03qb7ycpbsbn684n43gcf78d5zrq44vxayfp9160z7lld65lq876"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "7.0.3"; sha256 = "1x439wq5kavzwn4h12g7pw70vg6pkwfq6zvxdmlh2iks6mi43zzk"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "7.0.3"; sha256 = "0lj6a130wqw6vzdik5xfgjb4nids6p500aihwb0hjavzfn172njy"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "7.0.3"; sha256 = "05rxqaqcx82mwjddh32wnchi2zhs8fdqvcgmbgk126s0yswbzwsp"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "7.0.3"; sha256 = "16rhk79fd6v56bww92nv9d57k7gw71sr9y1yypp7zhwagx4b3jfp"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "7.0.3"; sha256 = "1lnw63y4j8v0l3j0c6khr8asb794819n56rfkmcnxgg700s3vsg2"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "7.0.3"; sha256 = "1jmh6dgziin9igjnfdw3mg631akfbz2g2jnpddrgjajj9zs10zlq"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "7.0.3"; sha256 = "1r34n2qyh5q762dj78fd3b4z9z4fi0mgdr3ha7js8dva70cnrywd"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "7.0.3"; sha256 = "03hw0wsbqqz8fm2zvpnxyvr6z93i0pg512snvkc95vk5szcxkx33"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "7.0.3"; sha256 = "1662dh2di0dfr640v1964n0861ysv1h731gdkqsl6sqsr501wdad"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "7.0.3"; sha256 = "1hqmgxj0w7ihrpv9sdqx04iv8pmjz0zsinyymc1gbv82vfg16374"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "7.0.3"; sha256 = "1c1l23k2xxidpcgxgmf1n9zns48lhajxzac24pnzxjf22jq0nsxb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "7.0.3"; sha256 = "1flz3v6yvm2c9sncnlbxp7y374kirham4sb98y5sz4zijbgp03ps"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "7.0.3"; sha256 = "1x5i8v3n88bsv64xh456fgsa61ga589wapc3f3yliip26p1n5jxh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "7.0.3"; sha256 = "06ga185vqg9v3nqjy4ifvj4jx4nc7n0394bd9j0s2s5mhhbca0p2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "7.0.3"; sha256 = "14yqbljchrhbg2zs78lfl6fjy747ms15sqijslsslcim3mhki8bs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "7.0.3"; sha256 = "0dcz8vk84wvdc1xfz095sg3a9szc1wmlcmm0yf3ghiy2ifbsjf4g"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "7.0.3"; sha256 = "1bby14npfw5frb372aw8cijb93slfp3n51563azbkxwzxk05xcpw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "7.0.3"; sha256 = "0l889zs93zr3640lm9r5bymk3mc070v1d35jzix2f7450pqnbgmc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "7.0.3"; sha256 = "0435w7rpqvjc6nnrw748bjl8dbm2dmc4gdyx2i7539cjf9kdvjlm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "7.0.3"; sha256 = "0qdbp2i4v6rslnbxb23hx0gzk2554k2x3ph6z7f0d3hivr1vip4i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "7.0.3"; sha256 = "0hciqnac7dxmsim97bz0bwpw67jf6xbdhbzvgih9lckhdillfa6l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "7.0.3"; sha256 = "111nsld40834z1q1cqgnlqrvxqlj54gnkhrys444ipikgzkp9qr0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "7.0.3"; sha256 = "1b71yipj8lsq3sri78hwbrlwrqc10rbi2zpa96vmn3ksahchdkla"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "7.0.3"; sha256 = "0k34vf3b7r0n2qw863rz2x4cp0zw1grjmp47dcca68dzmpd8ziz6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "7.0.3"; sha256 = "104czw878d5mwfwyxac337a0wbzrk50nchbrclv1jprm2kq6alsw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "7.0.3"; sha256 = "0ma5h44ibira1991czdww1pfj8g5jpgjrlzvgi8y87yl8idfs25d"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "7.0.3"; sha256 = "0l5j5if39zp24i61pggf6b9fi1i4i0ky831yvwpij7f4rgfgv9np"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "7.0.3"; sha256 = "1m8wyr2f5nk784rl0q8x0ffafi0glxy1mp4j2003c4x7lnaa7a5n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "7.0.3"; sha256 = "070gnnk6pdjjwbv8l9njfq1j9pac4m4j01sidwdra2bxq94mq0zz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "7.0.3"; sha256 = "1dpy66haz3myjvycf64r8csmscfy389g6pnc4shpnqfc0fzh78ha"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "7.0.3"; sha256 = "1xbnr4x91m52kjz4n553kpnp0lx9walnw6hjadgh22711nglhxqg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "7.0.3"; sha256 = "0sv95qx5hr9k156m7b30pv9dx96kqrwz9gdcdc8mcwvj52wjazrx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.3"; sha256 = "1p5pa62laj15i4ycd3czkn4zpb3pwk8kdfyvhqi2v037j7i97ch9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "7.0.3"; sha256 = "183c48q29cqcj443hm1ssmxcgr9w28g8ffrd3fvbzxxpw7s09msa"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.3"; sha256 = "0p7c8djwz214asmmmnzlrc71rl3hydw55r788m315vndck17zwsf"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.3"; sha256 = "1mxz8k155pyqwmfj11kwnzjin1c01ggns8c7xwgby92nmkr1psan"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.3"; sha256 = "1znc4khv11f8zfg03v4mpksi667h252hwqn871ahzrq7qin3av1l"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.3"; sha256 = "0smps1sbmiq803mvmg6ix41jys0fqwfhm0ajy5sbfa9bh52lafr2"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.3"; sha256 = "10f043gigv7gwl5ic3rb109vq7cmkmfqcd479d52qscw2znfvf88"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.3"; sha256 = "10rpibw85k1b6008lqkn31w37gnljbqfa0ywc9x6skydmiwzilka"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.3"; sha256 = "1kif2kqka5frcb1ka6n955fw7qlcrsca77a308q2ypga2gwrzk56"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.3"; sha256 = "1350ckgbvszryh7vjhlggcns4p0qm65zrs34z3wn1639vq3brrsv"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.3"; sha256 = "1l3b9ysrd77xsi7r49653m7szhrxaln9dhfx1gdhcy7dl3nj6aij"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.3"; sha256 = "0z388z36ql8ynbxgmwlm0y3hka8w9m3qw1a5p76prl3vb7z27qc0"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.3"; sha256 = "0gi7lx0bwfiv1ibgdfhf0ajs65ns1q5z1201q2mky9ps6jz5ixwi"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.3"; sha256 = "18nd7xgl9ka9nqaj3fqlgc5547b70w9ab265p5avf4mimmyjy9pz"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.3"; sha256 = "0ds7p7gxldkcdnlfxpz7xsjdfj2kksfrgwkx85wdhxhc9qr1kg9f"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.3"; sha256 = "0qlv9vrv11q8v9gf6dva3jssnyaxj7lnrapl82mpl2qncfcrkv1y"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.3"; sha256 = "0gf650jwh432isj3xj0d92s7h6prag2k7psgnlxb92b82vsannaz"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.3"; sha256 = "1q9574y6d4cfn91m4rqm2ylkhr0l9yy66x9yf7nyrq9y09r37s1g"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.3"; sha256 = "0r0vjza5g53k037gnjzm15h2aib2m4flxsjixni8hk1nj6aa9gj0"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.3"; sha256 = "0z55wh5w2fph0xwvy4gs28bv7f6dlw2h0gk1qibka0dxsh331ikd"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.3"; sha256 = "1i3ycqz3dczfxrxqfw1wlly7dwqr6bmbgsihn1q8rg785ahssyjh"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.3"; sha256 = "1884cf4xg7wn8pivd0k5zkdp4m5lgpz3sc6j3qpa6szwcs362g2q"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.3"; sha256 = "02r060dpa0mqrcbzwkc0392xz3q226vmjfa5kfilsr572fsaibc5"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.3"; sha256 = "0n8r2gplffqixibllvxi0sn52yww472d9yvknpp5zy08pngdglpq"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.3"; sha256 = "1hmd53jhd3b4p4lhx1vc4ydixmi7ncpz8s7cr64dfy0ja5if5wlh"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.3"; sha256 = "1kqz6k0dmfa56x64hsa1im35q421n9c5vy8987wr8a6d3f28qg7d"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.3"; sha256 = "0sgsar8azkjifxvzgyd91xb6k52nlzxw7668vpci27f68y1zkgnw"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.3"; sha256 = "008qqamcf7yspzb66z1xp47xzzninf1p28nr2jzpg0acvzx6rwmf"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.3"; sha256 = "1biv9j628ldca94pl3s4s52q9xi6z9afv903cz21rhcj76n2n2a9"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.3"; sha256 = "12dfsrhh01m9v655w76n5yb3nilb668ca353s2q95qfijx1s4bry"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.3"; sha256 = "04bpbjsf7azamh1z7cvq60m1lv68ggw705cvard1x0hxjmk1sndr"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.3"; sha256 = "08g798gz9dfxd5123m92cpgyw00ffsc5am7pz0fgwsv06vkvfqji"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.3"; sha256 = "0qy16596waicfgvhvjbiy98cizr9xa9r0qkr4dax87394qinvg0x"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.3"; sha256 = "17abxsl6wvm5cblibxnxs2yl9cag6p8qkvykpw29hwzl4vb1mlz8"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.3"; sha256 = "0k3x9klqn43f9k23x9x8acyjn90dlacx5lwq5bviy6b4izzsj496"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.3"; sha256 = "1hn2z2vvy8bahkl9i3sjsgg08q6zbvif2a3jynhn6lgdm5maxj77"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.3"; sha256 = "1q7mppvcg9skbqh8v7mihq2q0192z7p1p7c9b5llbdwhl3rb72a7"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.3"; sha256 = "105qjpxy4lr8i62sys7i9rkpdkr32f049fm4nals1sdyl7dwxzzi"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "7.0.3"; sha256 = "1z2pp0879nfp4sb5vpzr7snfgakpl1gs075581rvp0n419gnlvsj"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "7.0.3"; sha256 = "106qg62vcsz57fi8qql5ly1vfl13w34clbj88gg8shqqv87h7v5z"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.3"; sha256 = "0hga95snhadszc41njg0wzrcp0fnb7iqsprp4pvzyzfw4m2x1b9l"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.3"; sha256 = "07crnpbma9mw6mya2fd0qpkkv8zks55p5fcdn8jff2q4p187khf1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "7.0.3"; sha256 = "0qa95ybxyb49dlv9i03klli5wg27bf4cj2km27fyw3vwz4g4dra2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "7.0.3"; sha256 = "00mrwbxy17j71divsnvw73sga7lm5s2a7nnlrc90c41bh6bchw2z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "7.0.3"; sha256 = "1rx8i4fflrjbkd9xgqj6kh4ygcc7pvbvkjsdspjbyviyrvis533l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "7.0.3"; sha256 = "1gk7nnaw6ykqsiq1sqj768q4rg26ggijgarr3ncjnjxybl2q243b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "7.0.3"; sha256 = "1adxcf1wbpk3fn311kr50p1hwvyk52d64jv9hmg68kbv9df9zivs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "7.0.3"; sha256 = "1jxrm0pchlg1pmdy8kp5f3idjvn13g0dcvklzfzpswvwwjk3bfsg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "7.0.3"; sha256 = "0isaks5p31zzq7gmi1z5ma1j0224205iblg0hxlgz1q8aaxhmxsi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "7.0.3"; sha256 = "16x8kxyn07wjsf7mr6apkrcpqsix8icrgp246g177zl0xw9f6xv1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "7.0.3"; sha256 = "00r3r8plrmavkhqbj0zlrmni5yvrwhfvp8sdpm492yy8mpp8983y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "7.0.3"; sha256 = "1hg8kdp6f50r3qdjgg3bjdl1g3ns42qvhf0rk3f7rxxcqqbkqxic"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "7.0.3"; sha256 = "17ccj3r5yd1y06m4qn9z0plllrzqh5r9ljyhi12h0q0f27s1q6fh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "7.0.3"; sha256 = "10dch69yplclksfnckkg5q3mzivkh36nfdfixqak4w0xxs8kpcya"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "7.0.3"; sha256 = "0xrqdvr4gn0j800did7894ygsy07pxxb12n5mn0m576mbg2lqf33"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "7.0.3"; sha256 = "1a7gqklr9bh37aarw905qshdcynk79xnyklsyiblynb8bpcsjy2f"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.3"; sha256 = "0jlgdkkh1g23dl994565qglg68ky6f7fyp9a3swqyvv7pgm864p7"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.3"; sha256 = "0j7iz4ciqzl7f5hvyqy0cark0bhwp6yjk9mvd3l25li0n76fydzf"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.3"; sha256 = "1z86fdwx9clqrza77biia27jh74r3i4f22xrwdqk65f5id7fls7x"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.3"; sha256 = "0h8fs13jkqq78a1jxc0nv8z4pijzhd2yfa7llfmdn35yqz69iq5g"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.3"; sha256 = "1ycb27kcf3gs11rv6ivhx4dwc7b8c7zshmicfslpms471hg318dr"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.3"; sha256 = "1xjwkq843wqbidfd9qdv1cwn1lq552n3yrk80frxz0gm3jz8g84s"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.3"; sha256 = "141nq2nchdwjvpi3s61svk9lk6bq6hvd808fspszacq7v4fd71kg"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.3"; sha256 = "0dyb7hs3g2hzflssd2wxkl1bk8zscskr7d93w5fyvpb5x7pj2qwq"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.3"; sha256 = "18yxk532qjjvpc2pw480k31mikw3kq2g51i3rnaa0jz7h7kv1g2j"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.3"; sha256 = "0xiv8xvak5nsgfqy1171d309d4a8xi9hgar3ns1ndray9m7iv565"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.3"; sha256 = "0j24dvvbqxiskn9xvmw3kdmnxx062l13jsal98bmaxidmhgyvi72"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.3"; sha256 = "1mbp9fkiqfnbr5azl0fpln6w357nj8yfqfqqpg2wnf8lggv7jm8z"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.3"; sha256 = "0a4lyv6sj0h4sj0m04zijd58p4lpz65rj89wqyw5ccihx7fma02w"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.3"; sha256 = "18768p9d0f5cv0x929hbrcwpgbvipngfkac1p81b6r0cnmmfsl45"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.3"; sha256 = "0cj5i6c3dhd84zwspbvihvrfq4irxcq8h1np3xx8zg5xk72hnnsl"; })
    ];
  };
}
