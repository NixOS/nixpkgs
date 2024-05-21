{ buildAspNetCore, buildNetRuntime, buildNetSdk }:

# v9.0 (preview)

let
  packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "9.0.0-preview.2.24128.4"; sha256 = "0sxv7581axjyc9d8q2ij0rizbf24d7lrfqphnihxbf2gnphbixqa"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "9.0.0-preview.2.24128.4"; sha256 = "03zyr7dn151hlzgjkks4vixh5air3h4d2ml188521p3sv5kkhr63"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-preview.2.24128.4"; sha256 = "054qw93b9gw6fm9iaiki8msjglpw5nhchh96v42hfpggdk84ki1x"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "9.0.0-preview.2.24128.4"; sha256 = "11f8hmw1rxqcf3qsan6mjd7vrq442hsh90fpmx1gkfflibj8psjz"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "9.0.0-preview.2.24128.4"; sha256 = "1bpa4l0n3ahyk5s62ns35pr13idjnvbmahnpvjg2ay2n8fhr4wrh"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "9.0.0-preview.2.24128.4"; sha256 = "1z6gwynwfndhkv3gkqqaxbahx48ajx5ir2dfm8rfxg7hrc3x8sdx"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "9.0.0-preview.2.24128.4"; sha256 = "0vs4n68qlmqgizbn2i4h1wascx416slw0dmdib3dzxcivzfrv51j"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "9.0.0-preview.2.24128.4"; sha256 = "0cjhbli0p8b0nxvrp75dzk4pm112pwqy9cl1ajgr6ra6g3n9jypf"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "9.0.0-preview.2.24128.4"; sha256 = "0152n8y2gx8jcws6hrqfb91bsd3bfrk89hvls7rw8mazg5hac3yd"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "9.0.0-preview.2.24128.4"; sha256 = "1m7ynhxz62msv3fzaxpnb1lq5369wn8bwfbk70bxr32fz5smnar0"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "9.0.0-preview.2.24128.4"; sha256 = "11dg6qs92lc9n1n3h6jmi8iz62na9l3xhk8h7x0k92pcwax8dcwb"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "9.0.0-preview.2.24128.4"; sha256 = "1rq42nly7hq6bng7x39sh6zgklfsk44mhzxf91nb0nna5rvqy2v5"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "9.0.0-preview.2.24128.5"; sha256 = "0plcb424mj45pwd3lwsshrqqsmfcxfhzv9gwcsx4vmhk4p0lgynd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "9.0.0-preview.2.24128.5"; sha256 = "1h3hq06csy8nn1ms39gi4gpz1vs4rci09w602pal9cdn3qr946yl"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "9.0.0-preview.2.24128.5"; sha256 = "1a1h62xisa7jy0ac0mj5kyqnhs4mrhnr2mnj56i3savyhj0n53gb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "9.0.0-preview.2.24128.5"; sha256 = "0bz3ckck2ixyk8brjl5si6d161ml4kdzm4qk85ghvglc6ac192hx"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "9.0.0-preview.2.24128.5"; sha256 = "06jfjb853z5jxwxw107xbii7xlj9ardhh4k59bnck79vplh7abqd"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "9.0.0-preview.2.24128.5"; sha256 = "0521d38bwh94lzv3fkj6yir8v4zx1riiaiwk860303ljp79iyxdp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "9.0.0-preview.2.24128.5"; sha256 = "1wjybjhalhdbxndyalgy3alkr8ra8yj88g7h7ysjlsfxp4gx3xha"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "9.0.0-preview.2.24128.5"; sha256 = "0xgfbi9r6hnmqh18z2smfp04693fy3l66y30v7337jlvamxmz0hi"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "9.0.0-preview.2.24128.5"; sha256 = "0mjgb3vnkx845lrx7w99q62c5s12n924pi5fh37c52jn1mvaj1za"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "9.0.0-preview.2.24128.5"; sha256 = "1adjb3wp3zxjj3vgyf7xk34sqv3zxavss9v2d1zr4hdvrbwsv2hp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "9.0.0-preview.2.24128.5"; sha256 = "1w00m6hnalndscssc6prsm4dhbn43fclm20h39icll2z4p2jyly2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-preview.2.24128.5"; sha256 = "16087b037vlrra853ls9iardxl1g14zm57q3flrylmd8wdhm7caj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "9.0.0-preview.2.24128.5"; sha256 = "0p5kq3ccrc5v5cfj7fvqliyh9k0vrgxmw11mcmlv0s2m1ziikvgf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "9.0.0-preview.2.24128.5"; sha256 = "0f9g2vj3vb9q3ryqywn76604ah276whpkn93r876sxqkvgsdbnvq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "9.0.0-preview.2.24128.5"; sha256 = "0jdq6s36y9733sqsq9ppr08642sv3dgmjg2c36wf0ag1v3vlz2ab"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "9.0.0-preview.2.24128.5"; sha256 = "0lc5d6jkcz31znv9bi0li4xy1j3kji48xww8v2df3dsjgq62bbjj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "9.0.0-preview.2.24128.5"; sha256 = "11h38px2i2hw0g1y5annpffn0xlq26m29xm5mvnjdjsz05khnwhb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "9.0.0-preview.2.24128.5"; sha256 = "0a7jr03d66jzzzyajs552i1qn0jgzq1rlzpqch30k51ssnrbljpg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.2.24128.5"; sha256 = "1a4han0cbhwj63ja5lnkjbaa012769j69hir21nc4k706hyf09pk"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.2.24128.5"; sha256 = "09s4mdzbgmrm5v3a4d9zdw918cwpsg9r84ywla1na6dh6i0400w5"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.2.24128.5"; sha256 = "0c46wbnn1jh6k05khjysmmn0x69p0nh6b17lszvbr2p6v7nbfa78"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.2.24128.5"; sha256 = "1izlvyk9xl0s888byw2c1n4jpvd6hh1yqx53z5mh0zi9jmc430mi"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.2.24128.5"; sha256 = "1sr07f4zyyllmkzkqs0lqa4b01ig4bcpxghhn37nys7ab2f15619"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.2.24128.5"; sha256 = "1l12jxmlvy116a9dzfqn28ain7c4nwk3fawiw54qiaikc1dbz8zc"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.2.24128.5"; sha256 = "0bcr4zbl1kpnbk34m2i221rb6bl1jiyylak0hvs790bldj47c6lk"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.2.24128.5"; sha256 = "089dll9w3mgf9xx22gk5z2wgw01ydwvw5snn3ij2jwrjakz611hc"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.2.24128.5"; sha256 = "09adk3i17biq3sjzx4amnxjvp6viwch3p6nklb3ybknsncn9ix5v"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.2.24128.5"; sha256 = "1jfi2wzl5lrij3h4v0ix38vs3g57wg2nmv8c7iwmf2k4i8nf523y"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "9.0.0-preview.2.24128.5"; sha256 = "1030gjhrwqwc01sqdi88ynz1phh4ccpjqfnbs0i3kwjb3sg3iy3k"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "9.0.0-preview.2.24128.5"; sha256 = "12136vhid3aj3gn40vfrilcypr9n9izhx110q65c57m0kgg41k13"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "9.0.0-preview.2.24128.5"; sha256 = "0nnsfxbrf8m6zn0s021c6dvq4kif1b2cv2l6rlw4986y92g6147p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "9.0.0-preview.2.24128.5"; sha256 = "1fhfsjp1caxnn73is92zrrmpinyr5hkzd7mcp1dnrsqllx6v1w52"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "9.0.0-preview.2.24128.5"; sha256 = "0syi6dlgmvpnfcgkvnwyf1i7gnn1k71nd6rc6fc9b0jwi4ys5y3n"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "9.0.0-preview.2.24128.5"; sha256 = "08ran7vyfn2f4hhj1hc1hfdw1c2k6whbjyvkj8p78f66zqkh11ic"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "9.0.0-preview.2.24128.5"; sha256 = "02pk28mghl4jqzyv10ab92iidg581lnpsj49pfw818w324dk2hpp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "9.0.0-preview.2.24128.5"; sha256 = "01yagr5c4d3347a3ljbsjz27420igvzf856275nj7yn6psini72p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "9.0.0-preview.2.24128.5"; sha256 = "1wa54f15xp32277h85hxamxdyj62yldi7vpmldsqds3n7r2wg3q2"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "9.0.0-preview.2.24128.5"; sha256 = "1a138w5bh1d5ilq4ynpxcawfj6n1dl1jqa5z1a7p7fgry2362pp7"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "9.0.0-preview.2.24128.5"; sha256 = "0nwkqpn1qsk45nqxc4ih3bi4ik13a0hck0jbkc5jrl9301839l15"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "9.0.0-preview.2.24128.5"; sha256 = "1a1iw32fmhapsr0r7mm6iz69clwvnhqg6q4jqbdlp12id2v9r3l6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "9.0.0-preview.2.24128.5"; sha256 = "06j1scfv8vb3b9n3jpa0nsx6rxk413xsjr7fpxgsiraqfi9cl4ch"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.2.24128.5"; sha256 = "15v4idsw83bfypqv17r8a8vwvpsf3fa30gvja9zzbj4v639s2n28"; })
      (fetchNuGet { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-preview.2.24128.5"; sha256 = "1nqjazr7dwsahy6qix5fa1bby8qhcxqwpvpp7aj3slpgp88ag795"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "9.0.0-preview.2.24128.5"; sha256 = "0i2plc6nr1fsx0wa6ff2fda3xig6aaxcnb7v9l1w1da2qw767f23"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "9.0.0-preview.2.24128.5"; sha256 = "1h2sd4pcsh1p1fim0jydl8i70pj54lxywwqdz31b3x7x7r05hjgw"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "9.0.0-preview.2.24128.5"; sha256 = "1f30y1hwcprm1j549v00kq9w5a3jxls7z6pryyjx379axaspd805"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "9.0.0-preview.2.24128.5"; sha256 = "1b09s5v153wxv0mqr5nvhym5dvavc7jilmflzs6wh7jjn1gq06q8"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "9.0.0-preview.2.24128.5"; sha256 = "1z0s40i0nnxxwhgh85aacfh6qd1sygwz1z94hppnmaamdhqmf6wg"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "9.0.0-preview.2.24128.5"; sha256 = "13w3kpyilk1n2vy6lnm5h44zskblfnrhdnbjx4f13hwzc1127a2b"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "9.0.0-preview.2.24128.5"; sha256 = "0r79zrqxvvkg1f4vb8yqaa22fb7ix93fkkwsmqpj8f43z71aizjh"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "9.0.0-preview.2.24128.5"; sha256 = "1l3k9sgiqjvxaagvbfza9q136p36kixl434xg9qhzr8rl6m2g2ih"; })
      (fetchNuGet { pname = "Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.2.24128.5"; sha256 = "1dq6mir5n319a7pjzgvhxlm90py4wslx6y4n68x1g8ifd97cxnhy"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.2.24128.5"; sha256 = "07y3hhf3h4p59wyv25wmb58wzayhrqp4wawb777k8x6r448c5xaz"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.2.24128.5"; sha256 = "1kyigz0zzlbl22cr31na8lzf7595zvysnck44xlay1if99crkndg"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.2.24128.5"; sha256 = "0rr2ka6ivsx54p9c2k4gp4aligkw605j2z1wkviq0aa7mrn2vjiw"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.2.24128.5"; sha256 = "1cmjncpcyiyn3mpzlhh5iya2b8pjl37mpssr8wbvhlzi86f6sh1n"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.2.24128.5"; sha256 = "11nl8nqkhx012nw1wgjss05sdxkz4j5k5frzbpj19n46pxh3mx9v"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.2.24128.5"; sha256 = "0lcrwv09qp47vli4xa6nsjvgglbz9add3pqa6282pl5b221q83rc"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-preview.2.24128.5"; sha256 = "1i83fpfx50z1yadrfg40m91r2qmji6v1vyipaqp6863646z2fa4z"; })
      (fetchNuGet { pname = "Microsoft.NET.ILLink.Tasks"; version = "9.0.0-preview.2.24128.5"; sha256 = "11n78chcg40lj7cjadsmaynczbviqmw1kp1araixnrkmy2xpdzqd"; })
  ];
in rec {
  release_9_0 = "9.0.0-preview.2";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.0-preview.2.24128.4";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e3e81a61-4493-433a-ac40-ce2bceb3370d/ce1c59a7054d200dd24a7e4987666b8c/aspnetcore-runtime-9.0.0-preview.2.24128.4-linux-x64.tar.gz";
        sha512  = "9d836edc539ace64ef8fa883bdfc881d89f4cf30d048640246dae9d54e46e79f2e82ebcdf366c1b69017d86d1bf1496acef5d56c3133297ea0bddb2df2eb4523";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/cb8d7d43-e403-44b3-9ee8-477a947f3e6b/3e38a543b6b9144e0fed12cf18eae7f9/aspnetcore-runtime-9.0.0-preview.2.24128.4-linux-arm64.tar.gz";
        sha512  = "6f7a5575d02197f1908c56d580f0a9049f393ae68a4ad4b73935e981d9c6766e028463d2828d3ba0aeb4049237516fee2e116196e790948fefd65436ea804f35";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/dbbdbf43-8860-4aae-b1aa-57d44f976cc8/f4f6c6c4a740de95a332ed2c693d1d6f/aspnetcore-runtime-9.0.0-preview.2.24128.4-osx-x64.tar.gz";
        sha512  = "c0c37a504f8c3113c90b8108f1f784fbb61387475e3eab37d303c49f627e06034ef6e917ee9c780e910cbf565c20050173f240f215fdead4fabb1f3795f3ac08";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/9f27cd5d-334b-4dfe-8876-33186210815a/2752edc7662b603b734219e4fee20ba0/aspnetcore-runtime-9.0.0-preview.2.24128.4-osx-arm64.tar.gz";
        sha512  = "81b5860e68e9e660a535568f96d8058ab6f98dd6b0a8305e3e3358ee721da610c08baf0b59a52d7e30184c39784ab18544f9328a55d8490d400d07be734059a4";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.0-preview.2.24128.5";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/3d7900df-fefb-4aba-8dbc-e3d755111a85/c849ddf0290aeae485414ba46ad961c3/dotnet-runtime-9.0.0-preview.2.24128.5-linux-x64.tar.gz";
        sha512  = "6433959a75103f2f1108bbc16cfe348f9ba04fec1c8f9b6895019241bfcb7b21fab675cc13971f2c1a66b46b044a95f91e1e2b46e6e8bdd893d277906f82545a";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/ab7bbaf3-c61e-481d-8dbf-b0dc2bcc80f6/0467f280265fe3b33ddcd345b04cdfa1/dotnet-runtime-9.0.0-preview.2.24128.5-linux-arm64.tar.gz";
        sha512  = "5ae4c5f4acf1465c8aba29a90aa3ee99ab47ffece9f932e9fb4de8937d05feace4c5d3b53d4b8bf226eb99de16a0aad0e71f091827651f0722261513c8a8a2e7";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/8ccc8b00-80b0-48c4-9948-9adfa67f42e3/b93918f628eee154b3400fe05774d1be/dotnet-runtime-9.0.0-preview.2.24128.5-osx-x64.tar.gz";
        sha512  = "9f83d1d7dbfb8c8df1c7530fed3ddbb1571e60100954051bf07b8ee758edc600d1d988819c91711cd8b4baa05dd97f9900d1edf2ae5035ac74930a920951f380";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6401083b-8213-431e-94b3-bb1bba37d792/551aca92ab4da13513ead1e7865d57e2/dotnet-runtime-9.0.0-preview.2.24128.5-osx-arm64.tar.gz";
        sha512  = "cc7b8626cdec48427ef79f14c0919a09a3500bdc1c2933c6b5cf80886cc590ab20ccbd07bdb3a6081e47b80f372db3b4887b5276a12252887b7360a7f23e9901";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.100-preview.2.24157.14";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/911f82cf-0f87-46c2-8d70-44fab9a0f3c9/137ec23686722b8119bd62def8d7b117/dotnet-sdk-9.0.100-preview.2.24157.14-linux-x64.tar.gz";
        sha512  = "c44df5e11791e4b22720834ed7f28102e33ab475670fa8e132d73d5dd03d8f4ed3f4a548deac67a79e06db6f776c9f632eda4503b6fdc9eef7ffb001cc9963c0";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/b64ba1b3-ad10-40a2-b588-73db9ed9d99d/f772743c20f55a5a8aea3da2e1480676/dotnet-sdk-9.0.100-preview.2.24157.14-linux-arm64.tar.gz";
        sha512  = "1d591e504352f765a35092394719451c024a628c69efb6a10d0a5d57947c466a004243e799b46147fdf6316a23b4335b1e8fb1fc5513def1dec9f96c6c845dc7";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/5d2259a0-cb6e-4079-96fa-e0de6f0448c5/9b299e3cc15adf6153c28c24cba35fef/dotnet-sdk-9.0.100-preview.2.24157.14-osx-x64.tar.gz";
        sha512  = "a5a02f596e3976e65650d6a780903a755d4d700491c670b4f3c2f167224da632b98ad03ab7a087dc18561c5cc3ae6a3be78d5c6ca2f7312c7d7c417d909a481a";
      };
      aarch64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/30628efc-01f0-468d-baf1-fc487e55093a/4c2bf86dbebb6c522d4d667516dc5930/dotnet-sdk-9.0.100-preview.2.24157.14-osx-arm64.tar.gz";
        sha512  = "1c7166a594ba6c07d0233aac44428e561e2131f1f1812cdfee75807d19f1fe53f40f9d93e88d4a478c885993424ec2ec7b9aaf8f174332f587e6ff10813680ec";
      };
    };
    inherit packages;
  };

  sdk_9_0 = sdk_9_0_1xx;
}
