{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v6.0 (active)
{
  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.19";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/fb0913f6-79a8-40b6-b604-bda42b60d0c2/eb98e78d3d75c16326a54cd0277b5406/aspnetcore-runtime-6.0.19-linux-x64.tar.gz";
        sha512  = "537e4b1be4fcaa5e69013b99c86808e0a13994c87d7542367b3eb18196206d1c27e46a865d89784229a04f69dadbe0b283d7adf1e7848c8d3c7998ee80c9e765";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/86b5e7ea-d316-4b44-a543-95cbfeafadd9/7e7b8ed4c007d9290c2099b5bcd144af/aspnetcore-runtime-6.0.19-linux-arm64.tar.gz";
        sha512  = "739acf3966e32092243f9a2ede241a16b2ae7c26bccdbcd53e63149429c4fad7d7166beca8c54ef1e79f18b43d3a5334bab42128a534aae7499cd137b833e888";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ff5fcf0c-64a2-4b7c-a406-06ac6e0369ec/7edc4ca9309235eb554cfd580aa6ca37/aspnetcore-runtime-6.0.19-osx-x64.tar.gz";
        sha512  = "405f3ef158ae0d8bbf755628b6d3131618255170885164422107955d94ee8483adbd6cedf4e5b414413cefcb15945efa2b44675b1f851647ffb4d92eea7505b0";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/af7c7c1e-4bcc-494e-b454-fcca9577426f/53d486a54766bc79208f72bb60beda29/aspnetcore-runtime-6.0.19-osx-arm64.tar.gz";
        sha512  = "6cff56c4da0d55eafb334775792b92ff22d1b3b6aea85375f90e55e4f850330f70eccab3d8bc8755c8a5895df4d7db9c3099f63982a1ec58ada196d2fcb574f5";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.19";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/59b2fb63-9075-4ee8-9120-d6d048226aa0/fe92c70fec406174fa2585c9b668900b/dotnet-runtime-6.0.19-linux-x64.tar.gz";
        sha512  = "6e8e1db8b247c92c8de4b476e06ad464b0bd664919394afd5fb3962db477490e54865abd2510c29457efdef3be23f0ea4683d6caabcc74a6d7abddce4b4a154d";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5428b024-2cca-483c-b103-429b04611e0c/8db2a6abdd0abbb00714d700e8acccd8/dotnet-runtime-6.0.19-linux-arm64.tar.gz";
        sha512  = "7698ae2a9f7bc32f99cb2a945cc58b47e173720412604807c09c682cc03edec8e4a7cf19d73e087733437da77e7f05ecc8618296f7f9165ac8ff5dfe51dda346";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a9559a9f-3e72-4fde-bc55-b5fd2260ad5f/f501dba0830e7cfdbf73c7d9780abaac/dotnet-runtime-6.0.19-osx-x64.tar.gz";
        sha512  = "c0b7738b198789ba0fe4e2b301aed2b129eb8b09e826c35b6e56b9a205d4d7650841cc0870bb3629c3aef58e03b59cbc37da6495bea4ad674b62d81240639b4d";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9e22fdfd-02df-4b83-ae80-933ab45da241/678caea6e30c0c4673f398cd42288f2f/dotnet-runtime-6.0.19-osx-arm64.tar.gz";
        sha512  = "9a7d0d2c493dcb0cccfd2ff9dcb234a6886f7c261a1a403aa896ccb3e6d76be6d7ad865e18e8f040f769833cc41f1caad7cce2909f9c4ded5ba3bba219c76071";
      };
    };
  };

  sdk_6_0 = buildNetSdk {
    version = "6.0.411";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/1f26cd3a-af60-4140-9cab-b661cfe0a1ed/4d533d26ef5d55fa17f23c207f6d3330/dotnet-sdk-6.0.411-linux-x64.tar.gz";
        sha512  = "dc8aa1f84ad97cf25a979bfc243c200b7a8e73b930b68d5eed782743d88aad823c32c267c83d7a19d3c4f910a8fae7f12d07ea5a35a1d3a97e13a8674d29037b";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/43eb599e-df6d-4303-b266-b96a9f77a8ca/a5c595017960d21f6d7b89530bff173f/dotnet-sdk-6.0.411-linux-arm64.tar.gz";
        sha512  = "e10aed4470087f30e48bf2c3d7e98a680cb7b5f5cfaaf2f7e5029c648e4df9ab140bfcef3b84195f6f8984b56b4156b7afde957b3695e68e9ed24934414a62d9";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d53a8cc3-7c70-4374-8072-5ddd6a75ff5b/0b64e3ca7c14755bd4d806ca235a2760/dotnet-sdk-6.0.411-osx-x64.tar.gz";
        sha512  = "11068da9ae996d0f0c2410ab2fc0a6637d5daa25ef9c152cbd509ee9ef51e452134a787b5214e8122a797b3cd00771fa3bd54c2e4aacbb3cf8ef103dc85b0a99";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5288044c-41cd-43f1-af79-9aa29f6e5a10/aaf4fa836481a4ff3a0f9bf79c4ffffc/dotnet-sdk-6.0.411-osx-arm64.tar.gz";
        sha512  = "0095606938cf1b6d5c54516ccc4d9ff276c567e569d2644dfc2f00c8a20c88ca8b09cfa1bb1254c04463887cb9c2bc057e62afde026948ca326998048c4d5d0d";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.19"; sha256 = "00y8riq5mvgyazbp7x9wijn3kxv7r88hwlyfv9f6a7vkp7w1d011"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.19"; sha256 = "0djzym7lil7p0v4h3x077vjbbh7k8dvij6swn7dk83xmyf87bfca"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.19"; sha256 = "0gy5r2p9l0wwc7lz4pn4ja2wcaw1cwy4w1j4qf0iv6057xmqbikq"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.19"; sha256 = "1rmngjkdq9f7zflxy3fgznchjh67g3zd5wv9a7vdl7b6z07psjnk"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.19"; sha256 = "1izm1kx4rwi6cp6r6qzjn9h1lmqdcx87yj4gnf291gnabgwpdg9i"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.19"; sha256 = "0z4f9jwb6g7xix9xiwldadxr00scbl7qcyvs5j7xsidmwk9dcaiv"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "6.0.19"; sha256 = "0av7ia56k22scyy0s45v6sv584n6mcpbyibn76pka2ah6jhq7dnl"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.19"; sha256 = "1lnqljdakd8hrrq2hxay2ycagpbdlpbj3ck2j41vyddlnn53vf6b"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.19"; sha256 = "1c8g5gy0x8bp75ff0nssvcsq2axwvi26jkzxip30y3r12jh6jw52"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.19"; sha256 = "0vm7d5dp8rgy5ic4qdvj59hifyy8g1b45j1w40w0sbrqbmak89na"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.19"; sha256 = "1r41m93kacyyhgjxmhx84n9wv9c2ckwa8295qa4kj8rn73gg4x28"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.19"; sha256 = "12zmayccdmhwci83xgvmylp13xl96ddw85r6cyccqxfk21x1dhd8"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.19"; sha256 = "1wsjgz3kgxifzc8f6jrgyb89rbngffj9skadqacy4bw158aklps9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.19"; sha256 = "0bv39s9854b7kp9w5068qq5dgyzdfbr5hq0i80cbpj6srxndf9im"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.19"; sha256 = "0ixizxdp0hg98frrka85x37ly0ji006ix9a52dxas3463hdmcazb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.19"; sha256 = "0bdprwa1vklf32w2hpnb0h316pqihy9gfx9z1xgiwljfkdjhin6k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.19"; sha256 = "1a062b09klc0xxkgb7qlxxpl52cmh7vmicy1227ch8qdkwf82nia"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.19"; sha256 = "0xf920dcy92gyf1a4ply370m1k82ja9srql5sq7wm2prl1y77wxp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.19"; sha256 = "0ib7fyl91av9vv734k73l9i37b3iph1gidvg37s556f09s61xg4g"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "6.0.19"; sha256 = "0lbnhfh3xh92gzpgpvmbyk1af3rcva7annayd65v4m27pcixdszv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.19"; sha256 = "04vnz3izwk42igr6p569yas08g6j0ims0ryfsi3qbma095117lq6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.19"; sha256 = "1xl4xrijlkia4vxqyg77sf2gb0r5bgwrzc6yidivwxijmaxmvx3z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.19"; sha256 = "1148n1shzmyxyqq1fqr7f55z6r0z55vjzyj4px80vjf46rs97h8h"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.19"; sha256 = "1635s0h8z55blb8bd1y8ppwac6w19f0w6hmx2nqz433968w74fk4"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.19"; sha256 = "0448b8lfv770qijzxxn3mv4xlw7cp00z52i7qqmmzf2b3vgwcr1i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.19"; sha256 = "1cx8vkwdgh9ai85ps46yb43x5mvxzk579mkyblxsn4b0nm5gqmsc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.19"; sha256 = "0xjiny4vmk621f8h35vl6wlikzjq9xrhw0j6sgrs0k0ylphwmp2a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.19"; sha256 = "0slhgkjlwcmz4xjl0x6rwhhcdc6f7hz0vb4lg5ak85inl5m98xa9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.19"; sha256 = "01hhi86mh3wjr6i31p5kbcqn6ks7kyhc06gfg1xaqyjrf0hkiiwc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "6.0.19"; sha256 = "04pjx9r8ahv3c73l6rl5vm9sj7qml1yiav9w5v5kiyvk6sz8agk0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.19"; sha256 = "1rf27fgqz4xyqi8kxn3hcxwzngdpdpcyjhxc512z21f914pvfz4q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.19"; sha256 = "1j9hp3a74spw9srhyxx36lkgvyqvyckmssl7q72vwamwih4jkdbp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.19"; sha256 = "10irl9p2vszfrxn9s0x1kdcgdjzqvk365452632g9adpz0m96wkg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.19"; sha256 = "1bq00ff77dj8a87paxxhg9qg3x44hs93vmddms2z2rbcv49wh2ra"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.19"; sha256 = "1dk2sqd4j2lr4xaidl99q1gygly52dz5hjpfqhvzkwq5rhm1q2sx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.19"; sha256 = "1iarfzmjb6rdwkp4s0j8zqk0jjmllii1hhrfkmgjhrf9j7zz4qli"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.19"; sha256 = "0d3l3bbfzqzxrwgif6z7a4h0788nm68m5viz9r3jk4cpkc1p8l5r"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.19"; sha256 = "1qxcsdixcf66pg8hyjwb5k2yl1srnm4l6ylhs4nbv9s86kfbafp4"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.19"; sha256 = "0s34svz8dm533nl6g8cbpia6ap0rbimifwraswc20lgj1vi0f30p"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.19"; sha256 = "0mxwikpy61b4kqa8a01gfzzy5nymyk9z6r4br51y43dzqrmi461k"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.19"; sha256 = "0k5mv3m91r19gv3f8hgn558694szpag9d2a5w29xvdy8h3mm6vp2"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.19"; sha256 = "0ipq0a9ij6jn469wd37pnc7np38hxip7452lkm07f6nkihvkg0m3"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.19"; sha256 = "1ps5imiyxcy7rf6cgpkn9p6mz74w606nxb2sbs675yrn3c473kls"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.19"; sha256 = "1729vshl38927sy4bcbx48l3037x9hwjnxjnpp22v31fzjj1gr2x"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.19"; sha256 = "1wv9lqa3lgzqlhqkgcbr0w70g7g3la9j5i84wa6rqsc21y276gqq"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.19"; sha256 = "0lknp6kpb09k6flnv887nv4y7q4nhbblk5bdv4wz6gpswd1b8mck"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.19"; sha256 = "0yl201gy9bilz6zn0xa3lybv3lcpnycmrp8r5kjc6yh73qc32p26"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.19"; sha256 = "1fzawxv0nql0i62najx9gsq396w60cnairxysfm9312m4x5bfcxp"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.19"; sha256 = "0jjnzhqxv00lnmjp49w998rrjhjm1ca7vlir0yv7jpbvhpx2c3g0"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.19"; sha256 = "0gvin96ly03zik2wxabi9m1q3xg20myankp18awmwydmvma5my8f"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.19"; sha256 = "1dgd764pic3s6y4kzy2amxi42rb8bgbkknmg7gc5yz4wi8k2rm7g"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.19"; sha256 = "11lbnzqdzalmqmbqkd4xn2nhx5n8kfjpv2akj76476dhanxfb0l8"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.19"; sha256 = "082jyxig3v9ah4f5rz6d4flwqm20dn999zsy6kp8ri6bkvmap2ww"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.19"; sha256 = "0ky58h37lprp3idwayvrcyn613pdzli24fx472iql5qvhgcgxg5y"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.19"; sha256 = "0g2dhi7sh7gbwrwcinlkzpal6mys12rw6114scyh8xghfswggshi"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.19"; sha256 = "1nrijf8czcbjpkd3ay2czwxa26cl07mv7sbbz9q32ywfqdw16xpj"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.19"; sha256 = "0flz92scm9a3m08fgq99axh02qjhy14dzivzzf702xm9ipa37gds"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.19"; sha256 = "0cwqwlhbvc310hkqkfq1kx0vv77lkj1s4mda2ks4w05s3il42k1l"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.19"; sha256 = "1qwzh3rq4xg44kgyhqxnhddr9d1nmcm11nhj73m091xk0mnz26p9"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.19"; sha256 = "0l66w1h3w6vqd9a8jag4dah6x929sc6684h8321mwy9d5wldx03w"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.19"; sha256 = "15483p2z4lyp2wir0lwlsjk5009nvp0j348ffnhqq115xadb1zz9"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.19"; sha256 = "1q08v78m9z02zmrrq19bjpbsfjzw4am82shj6mnkvhqy6r4aafh6"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.19"; sha256 = "1fh221gf6bl7qcmklhhv58i81h6q33ivh6g46hx70hl96gz62dp9"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.19"; sha256 = "0y6pwh3psknbf2wz03fh1kamyc2xjgazncg76z7msj1sbm3898ac"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.19"; sha256 = "117qw21q6xbvnji6nz79yfqi2i1wdk7kln02102vkl5gficz75y4"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.19"; sha256 = "1qypjwc7918v8qgzz3w2ypl6bsr3anqgb92bajbx4ha0cfrjmmfa"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.19"; sha256 = "1ybqpy5p7424allxgiqjccqx2wyidgylxy368d0n70w3jysyyxg7"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.19"; sha256 = "11xmb1gilncaj1d3i5ry7kbsszjyrqjlaws6n7nnr7rgw26jixrk"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.19"; sha256 = "10nphwf6iibkx37z0prwww6bxi0ks22rm48k4sjksif7rp54mzrl"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.19"; sha256 = "16vpwyp3z1k9f58i9w8k6dfgdw9y4vqb9jb1qvgr6fdvaz40vnxa"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.19"; sha256 = "0whr0rkd9izqhm0bggj27xirwsi8sajiz8imvz34s65ka7q3vsz0"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.19"; sha256 = "0a0sx27pjq282f9iky4djvlfhi3isnfy3fa033xv4in4lsml47gr"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.19"; sha256 = "0p0s6i2s5xqdzcpb0xb1xb0lg8jnn2v91yyawgckj5c0bhvxl5jv"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.19"; sha256 = "130r44f2if0mgjjknbrbqs02gjvaqnixc1hgpj52gm1fpwmydh46"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.19"; sha256 = "1m1z7sl9ivz7ks5clsa7mgwx7ak41a3gg1rap4c4q24w5avk08m3"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.19"; sha256 = "10pq2smssbny6nbgrhb97mnhxqz0xh7rhscx18isqcammkpk4hsg"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.19"; sha256 = "17xk04myv6j3ij28frg2vkr3y35s501gx1c8dngzd30k3n029icw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.19"; sha256 = "1mm2czg8mczkdayx0z58qs91xbrqh9frmlmfd64b7424rayayrfd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.19"; sha256 = "03y87q5mx0bz0lc63barh0r4gymfv11190jgfdxph2cvd4ir7bdn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.19"; sha256 = "11wpx1386cjg78c5jqqh2jgwkp597yrnvy92icyh6ibiy0107wfb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.19"; sha256 = "1lpx76v6113jppqn56pwqan9lgkqw7xd0x95fpyilczc52l3s46i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.19"; sha256 = "1ww8w5r3yvps19sc0nj2giqpsn64y807zw0ayshzn9shpba4gbbn"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.19"; sha256 = "0r0q5jd7a0dbc2w767clz460pn6lhvrmimsrn3jqw9irgm7g2xns"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.19"; sha256 = "1k4m171nsb9m407izsnkayzalhdq6g5kwy5s8f7d2hd53azisb0z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.19"; sha256 = "1q977pxaxnm79lm9ma2hbbll7jnrpkp89pbb41jr4aywp34x151b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.19"; sha256 = "0j6h8w3vrgr4fps3bhycqpzlajyqlrm467p0gpq98ali07ckfrb0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.19"; sha256 = "0r3zdg1rapknp94m2hx42mx8wvyarq24cqdcvzd37wf6nmxmaigb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.19"; sha256 = "1adwrmr618bnc72gab4kg1sqnvvyp3zlzlaafh4n38xyi2hjihs7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.19"; sha256 = "0rmn0i1sy0q91dijw5k20gcbvqg840rqiihv89qqvpdw99al3xgh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.19"; sha256 = "1ck1ws817svrpf5xa100fw74s3mpscds67kjslw57ddi4gh0p07w"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.19"; sha256 = "0xvmpr2vg7cknkzb172zqx8sj3a5fy7j0xxdxxc441hc8xyywh5i"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.19"; sha256 = "1l5zs4c975r6s1qp99yjvygil9w2r324r5v7i15x37bzc3xkr61f"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.19"; sha256 = "1zv2vhi7krnibrm0khr0vk99wlxn9dgvhg0lvx9h0didfn94c71v"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.19"; sha256 = "0x2d8hm8lffy3gc0lxd7njcdggclnvd48i1ybwq78ll07930mlky"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.19"; sha256 = "1ra6gvs7xk2iz9in8641ls30pbxlcmk493q3vcbg30acvm335nzh"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.19"; sha256 = "0q8md416zfk3swpv9j4fn00rxpfj6hgkxxsl57qr9pavsximknhp"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.19"; sha256 = "11vyd6rr47dwfyraz86clza3i6nl8kakj6dys1g436d56mc9qxl0"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.19"; sha256 = "1kg0g83sh4kvxda508mav7xkfd56c3nsxj181hsgdz995yrnpmwz"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.19"; sha256 = "1x86splyckv4zxxj39maq7ppjpvfs8zdq98cbrpk0apb2m20clia"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "6.0.19"; sha256 = "0q5dp89vh189wa0yzhn9msgxs0d6ch822kz3dx8wpg523xwcf700"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "6.0.19"; sha256 = "0jy52i7smi8gsddmbd2isc9l1c4vyir6bb6q4pdwk8nrspl9v153"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "6.0.19"; sha256 = "1piir71cvir9xjdmmsais4q00gy64lllbcmzrlmjbip2hvxqbi2b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "6.0.19"; sha256 = "01v4w53jaq8fbrlf1dd08b0xmlf34qgchlavf8l7l4qzfzk1zc1i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "6.0.19"; sha256 = "1apazbfb96gc3lhj9yq4n1yczsbgjnfrc2a36yqkacfkrzcz5sdb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "6.0.19"; sha256 = "03mgjj0sq8h5k7rhi3g4xvc6w129l99fzipqcpri87gq2v2rq9bc"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "6.0.19"; sha256 = "023bmkhi489932srjpjgni96nifvj04556b1cb69ysqcw2blyjlh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "6.0.19"; sha256 = "0gr4y4wmkv8hvrv7j93cdxyaifgm5shslswy237xb3bi2rn91f2j"; })
    ];
  };
}
