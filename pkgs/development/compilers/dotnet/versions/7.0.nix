{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v7.0 (active)
{
  aspnetcore_7_0 = buildAspNetCore {
    version = "7.0.11";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/dc2c0a53-85a8-4fda-a283-fa28adb5fbe2/8ccade5bc400a5bb40cd9240f003b45c/aspnetcore-runtime-7.0.11-linux-x64.tar.gz";
        sha512  = "a5691a53a1be91751bea5c1f6faa2e93d19f5be61dc5a4953a6d6ce33359f78126873022fa1a25e2694dd85ef9671b566bf8b6c5f399f1eb017ae26833867019";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/cd1c8c35-921d-44dd-8296-f76126a73e86/5c7c20fb1df66c7b1853f77ffe858d1c/aspnetcore-runtime-7.0.11-linux-arm64.tar.gz";
        sha512  = "e8864d261487d3077b0637e710d9348209dd7fe19a0cdd60edde2e43d238f1e534b9485282230c8b1cea0faf4bff1887f07dc919dbeb9ea7f97d4b26b9c7aa91";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6df3136e-ba50-43e8-a68f-93e347c63693/e1b7ad4c0009723ab3a83db65969d0b7/aspnetcore-runtime-7.0.11-osx-x64.tar.gz";
        sha512  = "c0925ba2ff686438a40e5b61b660dca48103b37ad42f30828a1bf20ac2f9750a0f2643beb533eef877519f56757f3d4c50ccc5c1c172527883981b0d7974677f";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f7ea90e7-5d92-44d8-9b55-211182814710/af6bbc87d7505be5d4b22f130076a65d/aspnetcore-runtime-7.0.11-osx-arm64.tar.gz";
        sha512  = "799460d18543a4e3fcb0b0ed824bbc248afd9374bf74142d12a65d422aa8eb939914c870f3d575ad121d035c19adcf4423815a34e24969b9eda15a2048de8b68";
      };
    };
  };

  runtime_7_0 = buildNetRuntime {
    version = "7.0.11";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/948e3f45-a2c8-4d34-954e-a360851b7ff2/aad7d4a9b73242625bc33b0e9c124478/dotnet-runtime-7.0.11-linux-x64.tar.gz";
        sha512  = "110db17f1bc9e5577488e7f5425c6c639851af68c8d7dd17b0616469755c27d3c8a78ab01aaab13ed4849c676230bfeef9113f1dc4cda34c5be7aa1d199e7d57";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6079be92-f70b-447f-bdbb-ee85e5b04d14/249738ad78341a40f9765599281579da/dotnet-runtime-7.0.11-linux-arm64.tar.gz";
        sha512  = "567b39c4b8ff278349fa76522351e6f399eadd9a86189150a312fa7a4d365c60ccad8a06564ff4b8acaaeb907222d6b154b711e324989f7f6c234dc5a85ea0da";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ffaab50c-bc8e-4b4a-a1e1-7bd859a3e7dc/5e6a62a33021d44df7807e3fcca4d111/dotnet-runtime-7.0.11-osx-x64.tar.gz";
        sha512  = "5e714641c1693abe2662ee71f6aae7ddb35a8a3869939f024f63666d7e90fdf2e5e25af5d7e53c81fab293706640c391ce6be4f737df3fe2a0d769bdf443178c";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6120c903-2058-4ea6-a62a-6b246750c2c9/28d586c9ecacc7fe95a65f98dc6acd6d/dotnet-runtime-7.0.11-osx-arm64.tar.gz";
        sha512  = "546ec5050ebc70ed17252d401cc43c9bd628fbaa40a6a764a4ca567fb37d0db14a6c0e28a190bdd74254e886aff9fed542830224f0dbaea32792235386648ea8";
      };
    };
  };

  sdk_7_0 = buildNetSdk {
    version = "7.0.401";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/61f29db0-10a5-4816-8fd8-ca2f71beaea3/e15fb7288eb5bc0053b91ea7b0bfd580/dotnet-sdk-7.0.401-linux-x64.tar.gz";
        sha512  = "2544f58c7409b1fd8fe2c7f600f6d2b6a1929318071f16789bd6abf6deea00bd496dd6ba7f2573bbf17c891c4f56a372a073e57712acfd3e80ea3eb1b3f9c3d0";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/799b3459-f1de-4c88-ae38-fd1aa76c2d73/db275a0fe9776b55cf0f81cb0788b6a9/dotnet-sdk-7.0.401-linux-arm64.tar.gz";
        sha512  = "7c6ba2047998c906353f8e8d7fa73589867f46cbc2d4ece6cc7ee4ca3402b6a18717089b98002c7d15e16ca6fd5b11e42037b5fb0e25aff39075d67d8be49e25";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/7190497a-9e02-4369-ba8a-29e7a4acc69e/45af3f104e254cc37cf48227bc8e464c/dotnet-sdk-7.0.401-osx-x64.tar.gz";
        sha512  = "7c0ffdc756e13606982a58f21e8fe6fb4a0cfe0210ffba925e81f70b0266715f17d2dd9efeac72c23d552f099c173b04c1c31d07a050151ffc65578ba2d922aa";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4246aa3e-4c90-4022-b3d2-5bf36547bfa6/8f75268f923723fb2c4a44b271dbc042/dotnet-sdk-7.0.401-osx-arm64.tar.gz";
        sha512  = "64878c33a80a13eeff58304832b8a00bdea7da088d8683903c4adbf9f6aaab4ea9bd55f5148c76518526d483ee43ab8a76f07afd60da5fc8081456f0448ac3ed";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "7.0.11"; sha256 = "1l9vydgqzsl8mcx2b58gwkiqy46v14by5fh6im0ibcpv1l8raijj"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "7.0.11"; sha256 = "0hmsqy4yc3023mcp5rg0h59yv3f8cnjhxw1g4i8md67vm5y04lfv"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "7.0.11"; sha256 = "0dazipajzj78i4x8f7m8c7sa890il4b46pxzfyz2vq21jb2g9lv9"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "7.0.11"; sha256 = "0d6ny4i84fxzadvxamicr5qlmpnb1d6zndw8rkrqsaskpl57l0dm"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "7.0.11"; sha256 = "18sk9wka8z5354ca77q43hi0615yjssdjbyi0hqq92w6zmg43vgc"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "7.0.11"; sha256 = "0wxw7vgygg6hqzq479n0pfjizr69wq7ja03a0qh8bma8b9q2mn6f"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "7.0.11"; sha256 = "1lvjhrv6c4mmqa645ml4rfj29ardpgxq7rw2jsnxr4qyv1d8iba4"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "7.0.11"; sha256 = "0fmnfq59454vc4jsynvqf768m8qzzbnl9gv8w4q15wz1aqy02789"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "7.0.11"; sha256 = "05ywwfn5lzx6y999f7gwmablkxi2zvska4sg20ihmjzp3xakcmk0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "7.0.11"; sha256 = "0b3sqvy48477yxzh1jfwjz69nrpnhpmy063zb5qj69birpcqriyk"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "7.0.11"; sha256 = "07i1axzlpkprd9imiqxvaxwwxzdrmq8s9vd8k22gdv742wysf5pn"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "7.0.11"; sha256 = "1i9z9q6b4zna1vg53cz2zxp4fv09jsr521nab4yvavzn2khsb32l"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "7.0.11"; sha256 = "1j0zbd4rmmd3ylgixsvyj145g2r6px6b9d9k4yxxg6d61x90c165"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "7.0.11"; sha256 = "0jc8gq3p0qhd5ws9cwwrjghvqbxb5p0chp43na9knkw6m0wxdxdz"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "7.0.11"; sha256 = "03nkxjn4wq30rw0163rqi8sngfxmcvwgm0wg7sgyb1cdh0q1ai68"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "7.0.11"; sha256 = "0azkiy2r6zbgbcgv8ymdlhwydmap79fw4ws1svyl2yy6ws3mynfk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "7.0.11"; sha256 = "0wsy6m1i8znx4y2jf04fnzr6kwzrbqyqvzj6inmdpdnk845lfcw5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "7.0.11"; sha256 = "12hh69sr4wf8sjcw3q71vky51sn854ffahbq6rgz3njzvbvc0dbj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "7.0.11"; sha256 = "1j1k735gkwba93n5yck87wppfpsbny979hppcygwrk81myf3fv03"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "7.0.11"; sha256 = "0hj29pn703vmhkr5x5rx1a0g91f0dx4h7synn1zk4fyzdc5bvj02"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "7.0.11"; sha256 = "1wrwzn4zg5fh00pbiv1s4b8fbcz99vv4x2w0m192k1pz84ywgw8w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "7.0.11"; sha256 = "0ifshdx19bgnbgynbk6iy6gybnxmp63nylrn7068x66hvcavh7kh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "7.0.11"; sha256 = "0px0ha4a256rawssqmzsi2grmydxzi31r9xxqdq2sn8dfpvdshzk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "7.0.11"; sha256 = "14159534yavrgrw04r63rcgvdnfv83xcplvb8h2nhrjgsl2kmabk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "7.0.11"; sha256 = "1gzwc96fs222ddia0k1924cn7gxm2a4anqgcxhmavx56x76wsy6f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "7.0.11"; sha256 = "1mfyq49hcjpj93zhxvy48hh3xji8jfj1hc8caf5wap4jna9rn2dx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "7.0.11"; sha256 = "0s3jx6gmjh907kzcqmd26202vl0knbxqbkf55m4wsk7ar3mgc8m8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "7.0.11"; sha256 = "0vxza49wwiia0d3m887yiaprp3xnax2bgzhj5bf080b4ayapzkf9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "7.0.11"; sha256 = "018qf23b0jixfh3fm74zqaakk01qx6yq21gk2mdn68b0xhnvlzma"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "7.0.11"; sha256 = "06x84avjby7q10shqgfzw6z9d2smgwibg51vfw0dzaw648x9mh0a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "7.0.11"; sha256 = "0i7x1da6drv8wl2ml9cpzbdalnmlkz86l50wgkirgnwczh3ia054"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "7.0.11"; sha256 = "12xmw2kcpf5rh8sv4y0mqzp917f7q8g4mfh5navqw4jmnxyb26qq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "7.0.11"; sha256 = "17n1m76ac0i10vkp3y04fd8wyxf2ywjwc6m9a8z1gxgwbmfajs8h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "7.0.11"; sha256 = "08flk8ygkyzys0iwv447gndnmfqf9b02api0dcqnzq7zhbgvhxyr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "7.0.11"; sha256 = "1x9pbqldaz0h2zmw363q68a9zxp5d8xw45s1i40fb2nwl19qqvk8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.11"; sha256 = "1x1n63nav3x1is0v6glzjy8wbk343ns7n34q831hw98l4v4gs8c7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "7.0.11"; sha256 = "1lpyhwb27fk0d07ibq05fyvhx5lis7gzy3fb2wk617vbwa4aj5vn"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.11"; sha256 = "1yzjid5v639xa91l2hk7kxj2a9nszq4qbydxwlw0z1c1vgzx6lzd"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.11"; sha256 = "10k58ncj2q9d2aszwbqldyprficbg0dlv7vy874h8ws1ds43hgpk"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.11"; sha256 = "1cbzcxwm5q51sd3ba3cfnkmwf72blqy01j98j3p94xj0fp44s82q"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.11"; sha256 = "0k7xdk2k7jrrlas8g6yw0jbmm6gch6ay2vgnayb4nay0l82zczrs"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.11"; sha256 = "1nyj6d3ys9c0ffhy2vjgvkbc7z7qa4p7j0z1w76zrawmiikj0j9p"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.11"; sha256 = "02faahlcq4bl2v0rkbpf1gv0a45vk4xcazbcb28iybdnqmz0jb7v"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.11"; sha256 = "1nksv1xyss8nhin1ac179w05dfn1181amkk4mb340r1zc348qm6j"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.11"; sha256 = "031n5cmmz6z01z7gwq249xc1rysgzvvy0s7jznn9mfbyk7b3f3cz"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.11"; sha256 = "1f8s6y4pyxj0w8l3hbvsyph776c4j0w51h7y7bfb6ldpaa4rf7fz"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.11"; sha256 = "1njk2rc9b1vv9i5v098iycgfsc1wq752x0dj0qpiz5ahmknwgjn0"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.11"; sha256 = "0bgdv0j8mhqsvw7zv225n4x4dlbhassl5klga9zhxxh1dnhfhnv0"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.11"; sha256 = "02pkvvpib02rv0i00abygckw0q5rr5ykv2ffn1f15lvfcakssmzf"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.11"; sha256 = "1spyrjrb5nbawj3npa4xjjl3yq5d2fd1z77bqc2kjnsvmspqcwdn"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.11"; sha256 = "16ddj8gdwhnbynwdfrk56pk1nh38zs7amibpw156iqc0plwpilgc"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.11"; sha256 = "04shzps9lbqwm2njzp8p8iay9b4spj62rgnz79qnjk10drbf4f35"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.11"; sha256 = "0szgfr0r9zqkmbbmcvjnylyvkz9ppfbx1k1dnib6wyxfaiapnl69"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.11"; sha256 = "0gpprrzbvv89kxg9k4sa6j7b16i153zy53ailnr3gqaxw3lvp8ra"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.11"; sha256 = "1gz3g8gvj5gyazlr24x9cxg81rq6wlzy42zc77dxsrlivxx2jwpb"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.11"; sha256 = "0m9h8f9vjpwkf7rcfriqfga11gchv28r7g6w22kc3gxdrba87vzz"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.11"; sha256 = "09zmxhxsjbp9qwjhwc6qlckavi62iqqqa0xhd7cd0x834c2v7jag"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.11"; sha256 = "1hb45sddw3fxlh7yajj2z2s5zzw3sz117p2qi5ihqb0p7chpibv1"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.11"; sha256 = "1x7n2pgxaj2iq6piqav7vfb24n49szrdyalxa31ypkwb4b47s3lp"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.11"; sha256 = "1qznwkwrcl098xwzp9hj0qrz0ch69g0mbg332md94pnzw70wjg1g"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.11"; sha256 = "060hg3kiy679h8n71vx7vn6wsrcb10cvnr9yzkr9j060rdiz1jw3"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.11"; sha256 = "0mjqsvqd8basizxfjrwj1a5ibjajpm1n9xg800cnfi8m7i9gm9wn"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.11"; sha256 = "010icnyhwfxz7gv5s28p88zvg20lsm1fxlgwdcwgns7swiv6vj75"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.11"; sha256 = "0ccyrh87fl4bsxr3a6h54cbnxpm7igm32jfh87s6if1ikb9wp09x"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.11"; sha256 = "1mgi1gl3gvd5rirj91rar32s2ww6f3hf82xpbc3w8bjn6dlnd541"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.11"; sha256 = "0sck1d3dgk78rr6dmsdyrqibp8sk4k61286zvc9h2lzl3fdxizj9"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.11"; sha256 = "017x7dyjvizddd1fq87hijjw9n4dq9naqqksj25pc591f7zr181m"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.11"; sha256 = "1ajc5ipw7wjw0c07zpf2bjx3sch3d72njpdwg2j561a6v76cj8vx"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.11"; sha256 = "0mkjr1shvvrh5rx3q76dp2jrk040ivy1k34bkirms4kh8y680jx4"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.11"; sha256 = "1ni1q83679hchrsmbr15ylj1kcbmaw3lsgfp3ml8m2xig1x2hngw"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "7.0.11"; sha256 = "0ivy2mi36wgmpm0m3rwmiirzbvfypdm63sh4nw6cwkhfzcy7ngif"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.11"; sha256 = "0j1ywgpg2m6pcq9c5cnmac0shjwq6y6lr0p05hzrrkl9amsbgl10"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.11"; sha256 = "0bnm6nq7y93z3q33hgsw112ch1kz39bkw46yn6bl3gs2vwl7pjxs"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "7.0.11"; sha256 = "1n31igwjmjsl5rdzyamcr3hr7qgj4950z3ki78adfgcl0z1a98kf"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "7.0.11"; sha256 = "16cvmpkiaah393pxrl955gd31b9pc3z5pm3wd74r6sd687irgi20"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.11"; sha256 = "1had0cfkfr9jpbl4lf53dn43c1yccsns9wh45di87in58sr52k1w"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.11"; sha256 = "0xr7anzg7hazhczm5kh28l2lvagzxk4y56rb2xlmmmdjs6y32rpw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "7.0.11"; sha256 = "0knl5q76l171fnc3q8yl5f81vv5bkg5m67xm6h0c2szal6s2492c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "7.0.11"; sha256 = "0cxw0ck22ngw3l4d7v2yswqiy7rbcrxgbjf2d98s1k73vrpv4czv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "7.0.11"; sha256 = "01km0wqrga2bd2mir9syh2qiglrp5y233ahyf5vhf5crb9m01g2f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "7.0.11"; sha256 = "040zkvkgyx0cdzgr21x6ysm4m1nb3y64yn80ffbkr7rlfqfyd2rn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "7.0.11"; sha256 = "15b62hxrpfy19xvyxlyligixxpa9sysfgi47xi4imx5055fhwphh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "7.0.11"; sha256 = "0i8h7ifrni8hnawg59wkicrnz4xz7ihidnd7s9xz1iwigaq3q65l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "7.0.11"; sha256 = "0a8fa0758i1gqb44n2v7ha5mzqp9n7rnwc0f9vac11glkvjwba0c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "7.0.11"; sha256 = "0g16xzqqdzzrk22dqvn0wf55lh3rk77v8m2kmk7ac9ha77pm5a09"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "7.0.11"; sha256 = "1ddhka5hpwbfqmz7gklg7w8vy6vy8kja1wxbfyvcx806wj4z6zzh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "7.0.11"; sha256 = "0gjmkkgd85vbd6zj69hr81jn2cbj9zlhxkskmhjsm70k6x9iwbxj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "7.0.11"; sha256 = "0avrzj53p512565m904v54x72xmkvznr3jp5r7psjvs4hvbdg26b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "7.0.11"; sha256 = "0f1fimz923ahxw6cgz6fkz2m1b3clzi9k9yb08y8zc6dc5jc9kav"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "7.0.11"; sha256 = "1hsp6kyw0l88f2i2r9xsyri907v7n0m9ncpr8j4kbwr0ibqnnnxv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "7.0.11"; sha256 = "1shdz0sx66vjv26hlyqvyakh8swmq0238w74lwpihpml1bz2bafd"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "7.0.11"; sha256 = "1zd472n2831hmpb14zzcqc5p0rdwkpm1qzw3ciqs3rcapna3bzs1"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "7.0.11"; sha256 = "1ngxsy9fcsx8rjk71skx9ih1lrj3hp809si2i0rykp8sk95gihvi"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.11"; sha256 = "0s5cslrzmv9i2755s251bcf0hpkr8kh5kfad89pympryl0snqc6z"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.11"; sha256 = "151h7vkpd86psgh3ykxfnfj74sccbvzii07mb1p6ia52l9jihx2p"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "7.0.11"; sha256 = "0k0x4v8rhp6hv30r15g2bny46zx2d32dlf4a5xlrz7va7n95ld86"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "7.0.11"; sha256 = "0cdj4sp2z7gh861m5w98hr64inrf1pr302h0dhabipkj8891rp7q"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "7.0.11"; sha256 = "1xbvxv7qhgyxl1a1w9jm46zrkia54r8liw5ssjj4kg9cagdxml4m"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "7.0.11"; sha256 = "1gh9wxaldind6xfq6ychizaq18s2kf5n377h6wbxra8055nr96gs"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "7.0.11"; sha256 = "1iy49hg0drhcrqfn6wrvk9cywdbv9hz061yz3216kih02pfs3hv5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "7.0.11"; sha256 = "0bxcmi9zx1cqwxf1bzk3n9cmigm7flhid4qr7nzkmlpczdbnk2w7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "7.0.11"; sha256 = "0vhqzbispsdcwywqzz7wvbmm9sr66j2d67nhbvcm283s9ms6wcdj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "7.0.11"; sha256 = "08aib3f9rid6h04r7wk8129qmhs9fcz2qav6bmmjd9gjf9i8iz9y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "7.0.11"; sha256 = "18r221rvnx66n56yxqlwh7lddis1zg6z0qajnraf430k8ilbjwj1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "7.0.11"; sha256 = "04wg0nvq7yl7llk0gc7jc29iv7bw8ablaajw3hrzv0yx6kkhbb4z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "7.0.11"; sha256 = "036vlbafkjnlkqml7h04wbf6qkxnhshl6m9a8x4kdf9w19bcs0k9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "7.0.11"; sha256 = "1c336daa0871l42lwwq7jgh7mkbdbc877dw864wwv2i638rdbnp9"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.11"; sha256 = "1mzr6qxz2vnc0zy3gs87ignrq7yiid61b3v22ifv9cpz4x6vdd72"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.11"; sha256 = "1y41fwdkski1hl93x1lgkdg81jnjf2k57n5adnl8faqb0ybdbijc"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.11"; sha256 = "155qq0kls43bigrn7iikpw7zn0am51zaf7nya4gb3ayy9cy6s35n"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.11"; sha256 = "1yzlmivfm66m6axqlxv99yw8iffl6kn4bamxzzy7wwwvh25y8440"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.11"; sha256 = "1qd1rm707kiwdp5kbp8vqnspvgjdd93x3iny6pjhaavjk0mpbrwg"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "7.0.11"; sha256 = "12341d3xya1icjphf8vscnygcnd3ydb5c1b2k5gq7nfpdsdcxym5"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "7.0.11"; sha256 = "1b1qhysd110a0l8p97yvwgl3q837h2bw56xmqxfsrk4qvnp9n4il"; })
    ];
  };
}
