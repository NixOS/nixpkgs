{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v6.0 (lts)
{
  aspnetcore_6_0 = buildAspNetCore {
    inherit icu;
    version = "6.0.7";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/98271725-1784-407c-841a-64d87c674512/b433af33506c816e3b5838f5c65d990a/aspnetcore-runtime-6.0.7-linux-x64.tar.gz";
        sha512  = "d210e2afd009746d2c4d98c07077b89ce174f462c2bdaae9afea107a5b1c9c4ab63460ae3d9ae38c5388f591c0a95d8712359326013b23325b7be19b51835455";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b79c5fa9-a08d-4534-9424-4bacfc3cdc3d/449179d6fe8cda05f52b7be0f6828eb0/aspnetcore-runtime-6.0.7-linux-arm64.tar.gz";
        sha512  = "0c7317d2170f2632afd7c7c3e5bd84075071802e901de1ed5e54178f8a56266fe0770ebd84502aff9384b06908d4d5bee9d464d215fb20d841de177174f55f93";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5b4d2b0e-607e-4f9a-944f-0acdefd828d9/79a0271038df505617ef800587a92858/aspnetcore-runtime-6.0.7-osx-x64.tar.gz";
        sha512  = "6c05250d2affb61a1f34ba297e3c9bd0ddc42d64b1580f5e8cfa218a079cc455aa183f683869ba52e7b9ce58fb223dff8ef9776d4b2e2421ed7e2058d4af0750";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3d952783-f61f-4399-841a-fa5b5aeffded/15580a465dec6a7c67107e3f96d6da13/aspnetcore-runtime-6.0.7-osx-arm64.tar.gz";
        sha512  = "4d9dccaeabc1490fb9261f0be0702c2f5b4e96b840edee94d50f9a4655aa4d85bcf5a16d21d43b0a543e5a90cc631510aba35000df465a4ffc6cca7de37907fc";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    inherit icu;
    version = "6.0.7";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/bd828687-1706-4041-a804-5e93631fe256/d4ec75936459a7e8c772c929edcbfeda/dotnet-runtime-6.0.7-linux-x64.tar.gz";
        sha512  = "996bdaf33be0a9c0f1e2d309b997e3a84a31e28d2424853d7fb1600212f4ce600ebe1b9615de5e46c17652f08ad0d7ecd4b3619217c9624b875a26a553f370d8";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/f9706e92-c7a1-4dc8-806a-0e95827c5b02/23be52946e4e2425c798208c5f16bb64/dotnet-runtime-6.0.7-linux-arm64.tar.gz";
        sha512  = "a63e100fe80cb64febfd2920e4065b3cc99f759c3de0897928a42cf14fdc963df324bef1354a7734420078d16e52fd8257dd480da465d865c4349c29cab1ef91";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/97def016-12c7-4e24-b924-772485a41faa/e96d9a0502492efa7de3897467f5972c/dotnet-runtime-6.0.7-osx-x64.tar.gz";
        sha512  = "9c53d16971f0366d6d69fbfe37e92eea806faa1c3502cc1050c0e6d2cf394cf886761146e344862a30d0cb131105f387c05d8ea207be8aa87c81cd4c8f962110";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/044c6d0f-0ac2-450f-b621-637ca24ab2fb/5cd0c43804f3fde6d09cacbfd8525868/dotnet-runtime-6.0.7-osx-arm64.tar.gz";
        sha512  = "9f08a535921df7c1ce837ef27478f2381e8132a9ebfec7630465fb3243ef2ec9e982d008faec69e0899675dc3a50b379a96967d1eed3c04dada40cb211489127";
      };
    };
  };

  sdk_6_0 = buildNetSdk {
    inherit icu;
    version = "6.0.302";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/0e83f50a-0619-45e6-8f16-dc4f41d1bb16/e0de908b2f070ef9e7e3b6ddea9d268c/dotnet-sdk-6.0.302-linux-x64.tar.gz";
        sha512  = "ac1d124802ca035aa00806312460b371af8e3a55d85383ddd8bb66f427c4fabae75b8be23c45888344e13b283a4f9c7df228447c06d796a57ffa5bb21992e6a4";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/33389348-a7d7-41ae-850f-ec46d3ca9612/36bad11f948b05a4fa9faac93c35e574/dotnet-sdk-6.0.302-linux-arm64.tar.gz";
        sha512  = "26e98a63665d707b1a7729f1794077316f9927edd88d12d82d0357fe597096b0d89b64a085fcdf0cf49807a443bbfebb48e10ea91cea890846cf4308e67c4ea5";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/60719796-b5c5-46dc-a26a-7e8126a292c8/a7b871d6c46136b61c30403d085ef97c/dotnet-sdk-6.0.302-osx-x64.tar.gz";
        sha512  = "003a06be76bf6228b4c033f34773039d57ebd485cf471a8117f5516f243a47a24d1b485ab9307becc1973107bb1d5b6c3028bbcbb217cbb42f5bee4c6c01c458";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/01a17a2d-6b92-4521-97a2-ad7d845a8064/44aa4e10f71e70a38b5f6f59d211cbab/dotnet-sdk-6.0.302-osx-arm64.tar.gz";
        sha512  = "59caea897a56b785245dcd3a6082247aeb879c39ecfab16db60e9dc3db447ca4e3ebe68e992c0551af886cd81f6f0088cb1433f1be6df865afa357f90f37ccf6";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.7"; sha256 = "028dlrbgs6d9gdvkl48lksm9gagsch5ih974l5wwfpdgx693v4wl"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.7"; sha256 = "1y5l528qp08bghm7qdk223g9ki6mv1hhmixhw5zfdzscp0wf11dh"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.7"; sha256 = "013xk8m2bkh99s0l5wz8k01pw9r7kwlywsngqciwvqk44vr265ga"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.7"; sha256 = "0pl8lr2chnscrbjckqw2ydck15fgxffsmkm7sqbcg9x9pwc0mkap"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.7"; sha256 = "140333iig3wc0iv76gk97cd6bqsjyhmhkf0myd04m9ds5dcwpxks"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.7"; sha256 = "1qfwhpvj9d3xp53y8mhhsamvnihy0czjhj63zxzc3fa21jpiscyy"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.7"; sha256 = "03i5yqhklgm4p536a3vxwgkbyivwschgvn639xwx846g2ghdqnf2"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.7"; sha256 = "01l2wr1lvfa63jn9j3ydgys6j0hcs30w880k0dd50q1jkm24cq4m"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.7"; sha256 = "1kzcw6gxd7ky32zpiwvmzgd5yy6vyjk8p600jwaagz63z36zaa3k"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "6.0.7"; sha256 = "1dkc3px04mpzd8zlkxcld63kqlncd8fs1dm3qdfg83sx7nzzf9xl"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.7"; sha256 = "1hy3wcy7dsw4pl8bcqy84i8hgxk6b1cm30chj2gjahx5yy1gwzr0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.7"; sha256 = "07h9b4fqna61j206hk5jrf9mrffg63ii2icn9h6x19h4pr9bf340"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.7"; sha256 = "1mjjb8a1g1fsw1qbhixc5hjwnkn35551pmfdl9l702zhd9hwf0s9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Composite"; version = "6.0.7"; sha256 = "0l6765cbdmdh71raq5snxd56w71clfbm4iwi93y3n67skpjkn6ml"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.7"; sha256 = "1h8ziaf6qdsm14h1cx7573r0nsr3cwv7sczg9j9lqaizwxmqg8dq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.7"; sha256 = "0354iizqhwhnxcgrn5p8gqv50dnyj5vdyrikwqhv6yd178ardw00"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.7"; sha256 = "17bsbx0hdzkl3axxfd4xav7q455mkw1wvr3j1r0q0z2gic0x3p23"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.7"; sha256 = "0lky1ihhlwjsdb0pb77vx663yji53pnkl9ij3z58pxdknldf0ayb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.7"; sha256 = "1gswphp5w6hbz60bymksf9i6iwlqg5hx8w2l3x83cfpw9q0pw5kd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.7"; sha256 = "1i19iqz89fh54k3126daqrdwn0sxp00ziw0d2hd8z6dkf49vbvmx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.7"; sha256 = "059q3gnvhg7ywbdrvnra8zrcwxa5si50fakh71dg0rnwnivpngj9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.7"; sha256 = "0q61220ii4biz02w37jqi84cnzgspzrrfqpg2g3mkhamb0lgq3c6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "6.0.7"; sha256 = "0aswrsx45f5ql94mbz6qgj4rcd585mvsmg8lbm9yzqavnkxw37q9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.7"; sha256 = "1ax2cyk9zfav69lr6pr223gm4ydqdwjb13pc2mxzb7j9x2z4dj8q"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.7"; sha256 = "0vqng4wqlkl9d3qphh0zzd1k2f53flvwk3k847iaxxdijvlr0b65"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.7"; sha256 = "0xmkfsvzcyk5akaz3k220xx6xli2kimzaqcnfpmyh9l66zkykrym"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.7"; sha256 = "0kgbxc6czq2sz1i7cjlv58jsisvc936m1zzj5f9qfv9c4aka2hig"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.7"; sha256 = "0fm8p7dpq12pv9qar8h7s1rz1dcyki7dh2424xrr49p8d58gmdsf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.7"; sha256 = "1kddakhs8bhrj14qmah78b164ia9277hjdvz8cd61b17f93iz7kd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.7"; sha256 = "0lzp9fc2h4h46ycy1dpbkqdp8qxm7xmfphfc3lgxr6jj9j123qac"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.7"; sha256 = "1hlks5p0i05xixarma211v09rr1n6r5qzmzjy0ca2gvgf9lv5xg1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.7"; sha256 = "04ryakvm54y5a0652hk77f8my3xq7faqn2v50i0w014njq1jyd5a"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.7"; sha256 = "0pci9m6phhdvmk698dm7mzgxlmzf7wbk992s705iqzahdl2ra3sr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.7"; sha256 = "0ij8vixb7ymwxa8yxrhizqjkxbh8hkfg47bk9fmkaw9ab94jhj93"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.7"; sha256 = "0xd2vkrav41fcf86p7ddjqiarjchsl5wy1haxiw7nr0bq3hzmirv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "6.0.7"; sha256 = "0ks2mslr021rwh3k5x7cd28494q16sjr5fw3wx5ba4bagf56wyyr"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.7"; sha256 = "1r1alh763xc40y3iqy2iwb91d273sf1hvgqhvwccyck30m9mqisl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.7"; sha256 = "00ihv8c7h9fkyldwvkqf9wpzi0rr9wrhg7fai374ipmsj9kn6xl0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.7"; sha256 = "1jz71dxps71hb7qay2x93p34bvni7a7dgxk137h162ac4qaa5dn7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.7"; sha256 = "0a2vpn7j4h9phqv7azc9lczrkybln4ddf458j49dkjv3ghrav81z"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.7"; sha256 = "0j1if6nfi3sn1s8jdp08ks8v8526h275as61zh57kwmss5iczl4i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.7"; sha256 = "19cjlpmg0r6f2b2q1jllivlmjkv47bzl32l5xpq3ppn2l6qxs35x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.7"; sha256 = "11nayi9ai5qd9l944rap6fskzaw3nvmv8wmgf564cv4diphy8995"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.7"; sha256 = "1kdv31lz32gywpffa3qiyrmrvqxgxk0zggr0a2235x33zalw9l27"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.7"; sha256 = "0wi08fp0rxif89g0bmyg0ksk5f02xg7hyahignhqh26qpc7d608s"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.7"; sha256 = "0ns8lgqby70cnbij3lprgwzsgqzlv4db98qmcdvlnshv6lqqfd86"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.7"; sha256 = "0x1sjdzvqmvmgg6dsn427r5i3776cphhzpmfjlj4sfilsfpygihp"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.7"; sha256 = "12f24lnzb9m3dl06qklbc08577mf5vc9zibxabdidk83h7k7p0qc"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.7"; sha256 = "0garwnx2j86psq11pcd1z8vvnmhyn3x0fss0c4rza9c3bivh70wz"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.7"; sha256 = "18mgsgmdvm38pxy5jr1wglgz0a1fk5gm8awscmy5y5dcx7qghy3s"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.7"; sha256 = "12ksjis47q9dnnibx6snsnbgz07g1a6fsyrmir39b8m1cq5bbg0r"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.7"; sha256 = "1midq986vs6qwz0b34wmrbv5yk4clqmjhnqgkmfd8bxxflzglg9w"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.7"; sha256 = "0ba37pr3x44n2mhi5kld0cvh2w81fvgwdfl6g1llr1a9ncl8dbq4"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.7"; sha256 = "01pj41baqhkzk1nbqpy6khwakjrq5741wnnb1ny0j0i4mny7aa3i"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.7"; sha256 = "1g0zmc71rf1c2gfwm5zn7qdhisr726rf1fqs9n9nisz7pj0c719k"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.7"; sha256 = "0jr9ig4hga3iyxfwihlswpdfxlln66b16gfmb70qizn3jigwwvkh"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.7"; sha256 = "0wmm9yv20h7wp10xrca6hmv80isjzrw793zkwi591qah99rm7q44"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.7"; sha256 = "0dp94sm7gpzyw882141salqrpk54fp7fgmaqmr5xir2q6r7wxmaf"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.7"; sha256 = "05w0wkin5ydhrgqissdsdzxz39c4fh7msx2h5b50m84ixalqrkgf"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.7"; sha256 = "17anarmiq2n1damyg5yjnm22z4v6fkv30dri6nz1987r0fdn2waf"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.7"; sha256 = "1i9z2xh5r5bfncfd2h469zi46wykkikmbhkf9sys4jpfng78krdn"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.7"; sha256 = "0xm0l5iil6zi6cdnhnnlqzn4bw88gyabajz4wxrklcj7kz8mgm81"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.7"; sha256 = "03bjmb5ad8s7vj5cpbijmpr21z82d565wv0mg0h5iqlk02v5jw9g"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.7"; sha256 = "1wqah3lc8q949w7gi94jmp2hy6ld4s1jxbmm0zj3xjqrq0gmqzqw"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.7"; sha256 = "0vpk34xr3i9bvr7cgl22ss3gj2gmsg6drjv9mj1hksnd7fzb9m9r"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.7"; sha256 = "08swlx9khbyc34lxi59dgkc3fhbap2abm565dnpizmg4jqn7zz7s"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.7"; sha256 = "1lkxnbfpf3f8yj0srq8iavy12i14r0nhcpjxff7ypnk2z7xyc098"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.7"; sha256 = "1is814drvhf81xnq04npr5x56f8mxnr92vmc8bv66d8320yp8z1k"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.7"; sha256 = "0qqzk3r0mlldfpzm40gzrd0q6danfdd4h6l9fmjwwpmadj18dsg3"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.7"; sha256 = "1x7iqnksx4n4sb2ms5ibygkhfcnxbvkvamkx2s0rrbkghy25zndh"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.7"; sha256 = "04m2asmr63vxapgga4gadbrp18349sxzyn7ryn74lg6sqzdpvdr1"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.7"; sha256 = "0ck53135666f917lib6ahb32nxk78r65755v94hhv4g2xdbk813r"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.7"; sha256 = "0mig9c1xn6vdj1xdf20fvy9scw270l52rr2kwfjgppf4px661p77"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.7"; sha256 = "0dwa93brfc4mpjrjrz10jm3ina6kv1v75hdny00m5jfla366k6gj"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.7"; sha256 = "05svx1hz2n9qv6hj4grk0z7rkpw5v3s9059xpkjsb0h0f0y4zx6g"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.7"; sha256 = "0adyh8w348fw9pilj4giiriv4dxxlqgjvrbrcbkc6xdbn9085lav"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.7"; sha256 = "10nq0apr0askhq8z4kmna8gzqiazw4x94nz1c81qm7why0kyv0ws"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.7"; sha256 = "17fxrkxf82jyihp9qkfab6dz8kkz6y437hi123mwyh274qfvcj61"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.7"; sha256 = "0x6h4q5v153z5ym1rjzxgxrm3x87jqpiz52bmsgzv5vb1nkbhcnh"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.7"; sha256 = "09b28pkjxxk1qrij83vjmf16zb8vpipdawzzkk09fw27rspbcckp"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.7"; sha256 = "1r8plgiddlgarij4v60d0dzv5j1jqmnjhwhkaggfkzysgp16yvqi"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.7"; sha256 = "0qzal5v635206c0m4bcm5x29i7ff4y4yg705wv3yqb4b653lxcsy"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.7"; sha256 = "0k9g1n6ansv157jmsfczl2kasnsyvll8ka0yvhzgvwx7rxi7f006"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.7"; sha256 = "0ccahvy9787vb990mn0r2aj3yl8ykzs9wzvh3jk5y7x27zhpsd28"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.7"; sha256 = "0vhisvl2w6dyjmgdrkyhccjhnqlnx24drb1vypwhr6xdmx9r6mv1"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.7"; sha256 = "1zv9r7yhhbqa8vpyiw4an2gdai1icp7dshq228lnadgll3slzaj2"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.7"; sha256 = "02ylic2qyy6ayg1d76axhh61jsr64fi0svsnfj2s34iiifq8faah"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.7"; sha256 = "0gfkrvg1c6zq8dzp8pzjv3cbpy79z0gbym340cq8z235z7a2sijm"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.7"; sha256 = "1f0gbq6j5vhqznjgffaxg4pibl33l9k7zldn43wrzdr8ma5c6ily"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.7"; sha256 = "0a00frccimbza86kjrf1397bbsvsiggry1ihb4c4rk4d8qc2maq9"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.7"; sha256 = "0ppvrdwh32xr7rxlhc59lilj220cayk9f44p0qqygp3z20l1gzkl"; })
    ];
  };
}
