{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v8.0 (preview)
{
  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.0-preview.2.23153.2";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/930d8abc-009c-47c8-97cc-4c61ca7a74ef/7a116b9554c6db0d84f53937f89d5240/aspnetcore-runtime-8.0.0-preview.2.23153.2-linux-x64.tar.gz";
        sha512  = "1752ce53c8dbc59b3a321da7d44862410bdf29153124099106ec7397ab1fc650aa902849e198da38e5360f7ea5cd3e3f12cf78a9ec8121b666bf1db2080fd7fc";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/87c69e56-17b4-4346-995d-14242e2ec5bb/b656ba5e42d9d96ba065a4d0f971590b/aspnetcore-runtime-8.0.0-preview.2.23153.2-linux-arm64.tar.gz";
        sha512  = "4109b7841aa022b777b0f2ec4191ba0773736b5b4411402a1de6d14a63d273a9114e897c7ea38d3ca0bb48de20b165712aba838a6beacf1c31885f1fce0bb2a3";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8bf4989d-9696-45f8-af31-afd2a7fc5ca9/0892caa5dcc0ee2b342d85963610fe15/aspnetcore-runtime-8.0.0-preview.2.23153.2-osx-x64.tar.gz";
        sha512  = "e711051b2fc7593ce099b200cbe92e56a09e795afefc983f4e3acbbf90019e0b209c5c2a44ae3e3d8228a8c7fbdbaa5e3463ae4dfd7017a6d265537ade01d7f4";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/af525c46-4f32-4fb6-9435-522cb5f6b8e5/2323948790b195eebccfa5121d434e74/aspnetcore-runtime-8.0.0-preview.2.23153.2-osx-arm64.tar.gz";
        sha512  = "62358024b8960412f9e457e2dba14f65e03a50557bd6cf23a6bd77de87539d6b93dec55b375375f1ae7ca88de16118d3dca9d72f0a82a31fb3dab0c8e33bbf08";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.0-preview.2.23128.3";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f74940ab-c6c8-4464-8a4d-a1149a9dc965/c774b22355f65c13101937cbd2a79071/dotnet-runtime-8.0.0-preview.2.23128.3-linux-x64.tar.gz";
        sha512  = "b24bbea7fd0f1d5ca57544ccc690c05496667f30b0804b93a8baaea5e0d201bc471357e0ffac8a4fa5c399d3827942c7f6beb0e3a022e8d0d8cc7ba0ae86a379";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/31b60621-dcaf-4b89-83c6-cd9cc5657350/6a5b181b84409a029d80acc94c0387b5/dotnet-runtime-8.0.0-preview.2.23128.3-linux-arm64.tar.gz";
        sha512  = "48a80c18754e46a12fb04e280cb23e8f9238603aeb0a91125a583eac27a7abb1b20d08b3121444085e4d2034380849dcda88ed69ecc5c4af7e8e3c38a3392921";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/79a747b1-a7b8-432f-a641-fdc528f4d885/242cab0619683336965c964038e57ff7/dotnet-runtime-8.0.0-preview.2.23128.3-osx-x64.tar.gz";
        sha512  = "eb5f6eac1211e5c0398882d4f5e1859b5e2439e0564da4fdd4c8b3a4a60d360a4b9b48c06bc048badcc2d6a2b539ee740f85ae6e7ab03bed40ba9574655fe044";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6651d249-9e3a-4726-9733-76307787c213/445ad516907a2939a3da383501e51cfe/dotnet-runtime-8.0.0-preview.2.23128.3-osx-arm64.tar.gz";
        sha512  = "d6dc11b7e5cea5e96e45a401027a2f3e498e41658b3a1862cddec009a96eea83cb929338e402960e150fb3f77da582f1416d0f5231d6beadfd32a443ad68e9da";
      };
    };
  };

  sdk_8_0 = buildNetSdk {
    version = "8.0.100-preview.2.23157.25";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a042ab5b-f160-4621-ac14-77be759167d7/373e6e8ae9381ffc1ba853bb6542d55c/dotnet-sdk-8.0.100-preview.2.23157.25-linux-x64.tar.gz";
        sha512  = "97302c3600af7787fb136b226ca7e2a0a22241aa93dcffc70010b475bf6f8c4ff74a363d94949e1b64a91032b57a58a7065d7c6b2177696d8e78504ef4f1280f";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5ca09c3e-e6c0-4ea2-bc1c-371cc4d0b79a/f05e4e38788662b2e226bf75569e42aa/dotnet-sdk-8.0.100-preview.2.23157.25-linux-arm64.tar.gz";
        sha512  = "440919e2c0d3e0bfb387e2d0539b39045c6581a41f0237c88566d3642ab2c5e4a8e540f3d9d514997bb4a17b19c64a46b80f38af5f66705da1349373f87448ea";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6a390a1a-2d50-4ea3-a5f7-0a945b30a436/1968bbba00d7c4a3d2f0b8d13002d77e/dotnet-sdk-8.0.100-preview.2.23157.25-osx-x64.tar.gz";
        sha512  = "f3c4bd87d15a0593895121993326adef55641b59682ef52f6ff5fd44505468784590cf5fada9ea531377389ee47202db89de0520cdbbd497f85f5717fb74879b";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/62c49e14-4f0a-4698-aa08-8d77d383fa8f/909bb059d035324ddc2e8a8fdb77a01e/dotnet-sdk-8.0.100-preview.2.23157.25-osx-arm64.tar.gz";
        sha512  = "3b5c169180538a13c3199de0df096a2a84f58d2b55bc0dc94be374a015a231c035e57fa62e160e9c5595c6fcf92926ae9c577c6d62cf17803d931e5e90b5e694";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "8.0.0-preview.2.23153.2"; sha256 = "05d2vh8n184j2l2s187licqpmqfls21nvhrd41gqlg3ryzvax5ck"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "8.0.0-preview.2.23153.2"; sha256 = "1096asgigq2i1wki233g13yf79m81v9w5zb8ga6d31b0fcgjcmma"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "8.0.0-preview.2.23153.2"; sha256 = "0l1nwkiz33qk9jfz76w8mx9i97bwbwngml0wp2288g2zbn6pcp46"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "8.0.0-preview.2.23153.2"; sha256 = "0inamjvmvrb5psir94c96491jf1j28pm4i545zclbzgi3xfrhg9p"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "8.0.0-preview.2.23153.2"; sha256 = "0aghdx9psal6lqdyl60a5yg7x85wswdkbnr1fkgdypxpw99ry0ll"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "8.0.0-preview.2.23153.2"; sha256 = "136w94lkjv46hhjabvmbkswghbk3bjfrzf6m30kgawcmkkiisd74"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "8.0.0-preview.2.23153.2"; sha256 = "0svsdlca2ib81s2vqinl2bjxvmmigrvdiz6zs52nbl17smz800p1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "8.0.0-preview.2.23153.2"; sha256 = "1659z9mc0y32bf1s22s212ndp0qz82zjm2ljlgqvyp1c6chnjrg5"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "8.0.0-preview.2.23153.2"; sha256 = "1ycj8saylma1zv734qva0kq14w6rqsay8w8nin17mc3yl4xl0j4z"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "8.0.0-preview.2.23153.2"; sha256 = "0zgvfh6k856x0mipwb7q6siz9cy7jfm05jrkgjw11jg6m5ci1kyv"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "8.0.0-preview.2.23153.2"; sha256 = "0z4w107njs0z8jmr4m7m8jqk8f4q4zc9cfqib2rfs0ph4cjf3jbj"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "8.0.0-preview.2.23153.2"; sha256 = "0yxk7xnv1n9wmj381a17fdkpz00kwp2hwmpbik6r999f34qnd4dq"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "8.0.0-preview.2.23153.2"; sha256 = "0g6ir33dxn8xvfcmr6ghir9zypxgpkhmsdvmp5ddpfv661jxzmc1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "8.0.0-preview.2.23128.3"; sha256 = "1d3r9n8s3hadjkwpb98racv7ddjcwyjgwkfdgk0jqj6j47qm92qm"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "8.0.0-preview.2.23128.3"; sha256 = "1sfn7y6c5ghrr4hqvisaw4y9kzx1lqdbn0kz2d4gg4lpr757wgim"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "8.0.0-preview.2.23128.3"; sha256 = "1xq95d618m0lymn91bxgly0zvgjxl7788zvv1n9h2x7lc46rpl9i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "8.0.0-preview.2.23128.3"; sha256 = "163xklskw2sa8g6hnyyswrvc62bzm8xwdscv8z9b2a6r8hmfrvwg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "8.0.0-preview.2.23128.3"; sha256 = "1mysvd9wy3cgr0xvici3nfk7h8rcwcd9as4y53igivfilcb5fxml"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "8.0.0-preview.2.23128.3"; sha256 = "1wp81n16hzs989p1vlzvv37jq3nmmja0b8ca7lyw0agd1hyswcq4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "8.0.0-preview.2.23128.3"; sha256 = "0ksyx04f4npgs1qg1m63k0ghgkdpqml3ksk5hr2ai4rs7ygxhrgl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "8.0.0-preview.2.23128.3"; sha256 = "1ai5lm1ad9qfyfdbiazdcag4bhl450x3iivpgdshs01nmx2i562i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "8.0.0-preview.2.23128.3"; sha256 = "1bw78ff4r24qi6s7dbm0a2k664fibz4vlmagb6jhnsp8bn2nmv09"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "8.0.0-preview.2.23128.3"; sha256 = "14vg6k2w1cdajciyf9ki6ksarrv2chini495lklnp6kfxxsp2by4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "8.0.0-preview.2.23128.3"; sha256 = "18zb4b10szrc1k908lxi3awygnhnbxsmki5y8zwalwkpnwlr8fln"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "8.0.0-preview.2.23128.3"; sha256 = "04w085lrc24zmva5jy8lljhhwmml8p1aifzbjdg5lfm6grf9ncld"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "8.0.0-preview.2.23128.3"; sha256 = "1wq6g29zs5sb5x2vk7xkl8rvfckk8c52fpr28x0g948w3vrwqxyp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "8.0.0-preview.2.23128.3"; sha256 = "0y8zsvjws5y91ramribfbv7fmc7az27sfwrpj24jssw031ynxc25"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "8.0.0-preview.2.23128.3"; sha256 = "08rf54a16697h8gk02y55dgn6amfx33zd0cbrrhx5ydwz8pa8a0g"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "8.0.0-preview.2.23128.3"; sha256 = "18c92hvhalnvrl1z6ipr5m5wf24fd0plxq5mq7ryr8g2hwjbrawx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "8.0.0-preview.2.23128.3"; sha256 = "0x9lxg1rxj4hyab2a7qnyjczx35spq82hdscw0cvqyvarpnd705b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "8.0.0-preview.2.23128.3"; sha256 = "04fn90ljqbhnnxk4xirixqsk6ihkp3gc0jql8mqhx381yhy768pi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "8.0.0-preview.2.23128.3"; sha256 = "1787gkxs1wpbfwwa5qhbwwvmblskxaxsmgalngrzhsxjaiii4iqi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "8.0.0-preview.2.23128.3"; sha256 = "1c3kvfwbdr18sdjkgkh5wc4b5bwi5r9w7n69wxf35v9m4kgjppfn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "0w52hfw1la5372adc7g9px6xrql9yn2vamdg253vl4by2db1rwh3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "05qa5ym10q67q03yjqwz1anw38v3w2ajhm8rizsw1djcsfan5gri"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.2.23128.3"; sha256 = "0zkz24f4skx5qjx2xb2wqd33bgsm21j088ch2451nwmhrx9j3p0f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.2.23128.3"; sha256 = "0wa753mfcw2wxrvfj6n4n5dmnvf4phybixdizd2akhs6zmv4960g"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "19nfxqych48gwi1d2cfdfzfrr8kpqgp4xgqlrcan9y0s0cz3liv4"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "1ipm9vyhlhass856k7kzx0hnzk7lfsrwnkdgwqxqmkjdbvqvqywq"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.2.23128.3"; sha256 = "106vy0zk544cjmrx42cldji57lj2fiymbql9khmhk6w9xbp9p47h"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.2.23128.3"; sha256 = "0i2gyk8spj1mf8fiki3q2s3k82nxg6p7b0c924iyl2j65l4220xy"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "19lzsgbcd8f00gh4xmm21h2xjhb40hxxp53skjbs6jbklj4ip7vr"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "0hzgh4gy4ny5aa4hwab5y0scd8cazxic4bc8gdh3k1nlc143jfjh"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.2.23128.3"; sha256 = "1fzsxds8cfjq1z64fv8kn578m7hapydhcrdi5a8iir0zb8zr8cim"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.2.23128.3"; sha256 = "1v45affyh8kj22vfxx0f5mzbyf1wwm6l13k60gi9x4w38alz8wpx"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "0b0y6rckabwybgayvnkl8mxyiidc7vrr3rjaz8f590qik7ivmy7b"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "0sp1q5fzhma9v3mffcz34c8snkrvapp2fw2k341pmqqwqpb6xwi6"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.2.23128.3"; sha256 = "1gi1p0q21gd17r6wpwwl8wv20bprmma8hwmwypq0spb9bxhvamd6"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.2.23128.3"; sha256 = "1g5pcvl6kwn0k9815ikp17qn0dzgc9sq906k90vg57hchz3d4ycc"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "0ik1bljjbv41xf852b2c4kn7rdni5mr7yvdf0bqsz58pxdhghp4l"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "0yc2f7xjmk180l0nkj37ibal5lfiq032pq4zn36pjbpxdzz50ncw"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.2.23128.3"; sha256 = "1mpb7y9khhixbcmiqzc96h55d0ybic1cv6qmlsx57rh6kxpr7hwa"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.2.23128.3"; sha256 = "09m4b9wcqgkq21xq7006hhy7g7h477dbgnlydnjm1snlks9z3gmi"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "1yvk4wai07cmla4nvcn0vg60kc5himvwh4b0j3klb9pdjgrmvhlk"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "0zpbymx7ly9kfnslymcnscqq9yzcl0v4isd6j9nqrpbhphw6wi9q"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.2.23128.3"; sha256 = "1crfr78b0sy5xq16mqi6yzcx5srp6znafjh8rzcfj5pwgf4ajq2p"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.2.23128.3"; sha256 = "1mqzaw0gc7cy1v3rpr5mn15dyhlbdq2zrflcg1v10dcszf4yyr7i"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "11bs3lrf1kwz3fgkas3pc9c1qginbv98hfb4fngxam5818sdfy5g"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "0nb18mb8sddb457k236sdwwnms5jcdxkhvpacdp2vjzydsqxlf6s"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.2.23128.3"; sha256 = "191x8nhdc1g0ssil03imhwfv26pmijz3d8wc2wb2isllqhjsfz40"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.2.23128.3"; sha256 = "06bfmjc8fjrs81injfg6slwx9s3ph766l4fb76l63qcwn8sfhl8b"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "1q61wdr1v497aqx8bx0z0vmj03kckrp6cgwg8dzcnl2pgh9r1w96"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "1av1pnd7wqyd5h0rz9c03r5qg9g4br0in3f20lyskxmgfw5a48ri"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.2.23128.3"; sha256 = "1jr7495wc6g82syzlmf0hr9b4zim3yw6qz0yiadv1bh9aaq7c7pa"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.2.23128.3"; sha256 = "0zhappm1z4y8viyq7v9bw6ag4dksn4lshjgy56dlmshynv5hlaij"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "0vgvllxa1qv6yfk6r4xya71dy88dikgv07n4aafa4kaixa4mr67w"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "1z2zy2daxc2gizb3rs0sfqyz8wk6i38z7v35327j1hfgbfjzs956"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.2.23128.3"; sha256 = "047cc093hq9nqybpw8j2ffdjhyb3lr13zbwm1n41i61yknrba6p5"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.2.23128.3"; sha256 = "1chlxl1s5szcq2k3a661z05rvfwxw6nwqsgdx52d6irkkcmbyi6x"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "17ci6prvykrkaak5sfgbhg5x5x80kg0z7v6y56bm5k4hra32kcbn"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "14vgr8sbnsnqi8y9garinmn87qad114rgzhfcdjy558bjjargx3m"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.2.23128.3"; sha256 = "16bg1y9sw3fs5v02b6qqpd2xijhllnn4gqbd3862hz7yvqg1sj0z"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.2.23128.3"; sha256 = "1shhqi6rmsn80jp1275gwk50jai9c44a4lybrxy8hyq764z45rwy"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "0i8nlby3c0d4isj1w1slz7dznggdbjv7qgvssm00k7wv7j0hcanx"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "08yy7kc519h2d13z4b4ivb9w1r88xdwjr26gyqr7hmajql3mnnbn"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.2.23128.3"; sha256 = "1zn2gli8jp9gd0cgxf3k3iwma58sa1rd183phipcm4nb58203494"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.2.23128.3"; sha256 = "1rp9zcb7m6j3y2lmj9khs300r5rp5kwikhncsh2fhkchjwab821g"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "8.0.0-preview.2.23128.3"; sha256 = "03agvx2dcsaxj3aghhzilvgk22hhknhszp8m1sm8543nn867rrp8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "8.0.0-preview.2.23128.3"; sha256 = "00g4ijfqsi85iafcp84abxvf9v48m2fbsqhjqlmsly9j7ad9x0bd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "8.0.0-preview.2.23128.3"; sha256 = "16vv2sps29zfr9jm4cfbdzrz8231z6h060m2nyw6ydhlnrlnkxn0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "8.0.0-preview.2.23128.3"; sha256 = "1188fa6vns9260jcqb0j8xzzrh0m6m5zmxx7371bhkf0044xcvd6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "8.0.0-preview.2.23128.3"; sha256 = "0hqlhir7xyna9fsvb3zsnb1gh11pbkscaz72q02ck0n3dcspygv3"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "8.0.0-preview.2.23128.3"; sha256 = "1rzzb6p36jqgnww0yqgw1ca0vgjw5y85xalaqi2f2gr6m9aqw0n6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "8.0.0-preview.2.23128.3"; sha256 = "0aj8l590dcx6dl3kvcrpzdnvnkrf45f0k9plbz1818fd7irjcx22"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "8.0.0-preview.2.23128.3"; sha256 = "0vjzymlv7mjjpvl48sfr1c6fiz1nhl0ngbqdi7nkckgvl6l3zfkw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "8.0.0-preview.2.23128.3"; sha256 = "0nkvlxvfg2pbcfvv96xznr8zy892zjs5kps9iy17xsdxn5mwxx6n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "8.0.0-preview.2.23128.3"; sha256 = "0b3m0fsrmn0il6r0qj7nkq941s6pgjv6ik6vj3828ysz4ghsfsw2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "8.0.0-preview.2.23128.3"; sha256 = "0i6an1gkyplm2qf6gpp6k5qyrqaqg0jj5saylqgyq036fd4lsiig"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "8.0.0-preview.2.23128.3"; sha256 = "0w7cjcapw2lq36gfa8g831zfxfc0f6lr70nkm685va04k0lrn31k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "8.0.0-preview.2.23128.3"; sha256 = "1gs80bi0j2zzlzqfbghb1jl6xgc7fqlm2hzd14hzqc0h7i0v2vki"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "8.0.0-preview.2.23128.3"; sha256 = "0lqsam08xd91nmjj0z6qfzn790m5zxp4v2i8r8drs69x6qbbfsid"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "0q1qn6r85baj8vs4xfncl9i9bxh2aiyym3a4qxl370ak42grv20p"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "0fld40l781sw2dyg9b9q9qyixj1sd4s50i3gimxp9pl74qmfxnx3"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.2.23128.3"; sha256 = "0wawwm6f1lkvg05gmbv92ghqcyb5aqbzj99k7mw9lr665gkyz5jz"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.2.23128.3"; sha256 = "1za3s3zihjkxgnm3p5l1p3bk0qx2bmryvnzvailpx5657qrlpkn2"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "0xgm3yrxny3zrqjh6qcfbi4zmrqysas1aidx4m5caqrr9xqxrb62"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.0-preview.2.23128.3"; sha256 = "122rgxjp1lyy4rxm54qqksm6071jrqbha881pmgx9v452032s0mz"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.0-preview.2.23128.3"; sha256 = "0i5ivx1gzd2c9qmxp0cdfvvpy83wylrjsssppkv24zxjwjhr059n"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.0-preview.2.23128.3"; sha256 = "0p71n6w5fyicspdliix26y6rs711f17zdrlf6pp0agjgj75bkc24"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.2.23128.3"; sha256 = "096rczjnkc2nqcj0bp0i85n0fzak9m0nw4xvw189cbsv5wh1k2w8"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.2.23128.3"; sha256 = "0dg9ynq5lb7g2jfcwvp4fj7szm9y44hq52s523xmzfqnrnzvmr88"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.2.23128.3"; sha256 = "14lqrq81xn2s46xqg37fbn2vq7ibscrla52vsf03qj0f7869fdwn"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.2.23128.3"; sha256 = "0psiir0shm21asgfrfz2wi5kakwhvjz88ghm6ibl1clwkgx4lpx6"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.2.23128.3"; sha256 = "1y4636bb9y6rcj38v52lmdzps55l9wk0j4w2aywajw2jdmz9scqg"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.2.23128.3"; sha256 = "0fx2sa5yhc6avdhvpnvh3b9261j3msj2ypzqv6a49klk32jh7a2f"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.0-preview.2.23128.3"; sha256 = "1xzgnb7vr5aj8il46qlx8fakkqyi4wbh1p24x2k9zqhrc92hmzlz"; })
    ];
  };
}
