{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v5.0 (eol)
{
  aspnetcore_5_0 = buildAspNetCore {
    inherit icu;
    version = "5.0.17";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/a2b96f83-e22a-4fa6-a10e-709b3effac9a/0d6ade6c0ceebc8ef7dbf2b1a6d86f17/aspnetcore-runtime-5.0.17-linux-x64.tar.gz";
        sha512  = "d8e87804e9e86273c6512785bd5a6f0e834ff3f4bbebc11c4fcdf16ab4fdfabd0d981a756955267c1aa9bbeec596de3728ce9b2e6415d2d80daef0d999a5df6d";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6eb8aee2-cbea-4c4f-9bb9-ea6229ec229b/d6c438e5071c359ad995134f0a33e731/aspnetcore-runtime-5.0.17-linux-arm64.tar.gz";
        sha512  = "ac1a9d89f1b730dfdca9c2e48373ef21f8f9316014eefbe6b11516f8195d3b3efc4e482883774b74ea2ff1cb77174a2cb471bd1157ab5b7d71621e3026c38e9b";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/25e4817f-6fd0-46dc-be0d-d819445bac5c/a8fa228c872df683741c8a79745f8fb3/aspnetcore-runtime-5.0.17-osx-x64.tar.gz";
        sha512  = "bb0c43c723090fa2d8a0255e6fc8c004ebe7baf2d5d56e22ad2e6336a67fe415333d451e459c8857c0ccb5819d998232c9617bf45f222559d4b8891b0af41f20";
      };
    };
  };

  runtime_5_0 = buildNetRuntime {
    inherit icu;
    version = "5.0.17";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/e77438f6-865f-45e0-9a52-3e4b04aa609f/024a880ed4bfbfd3b9f222fec0b6aaff/dotnet-runtime-5.0.17-linux-x64.tar.gz";
        sha512  = "a9c4784930a977abbc42aff1337dda06ec588c1ec4769a59f9fcab4d5df4fc9efe65f8e61e5433db078f67a94ea2dfe870c32c482a50d4c16283ffacacff4261";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/6690730f-cf10-40f1-9d4d-4c0d002f22d0/e117133858f190c169873200b8d7b9d7/dotnet-runtime-5.0.17-linux-arm64.tar.gz";
        sha512  = "99cb11871924d3abedcc9c8079c54bc0c550203c7cbe4e349ed70d4355f40e4620b68d90b797e6461d898c06bed6953580e2cd4ad01483e5de107ca5a3409610";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/39326cf0-dc7f-42a3-9f7a-fe30c75c7a7f/33cbce552148e13d47120fe4502f5b5e/dotnet-runtime-5.0.17-osx-x64.tar.gz";
        sha512  = "31add512418640f98bc9511509db2049a2674c7725169d26be89218a02ac7972e03e5d6be5a3d45a0dfa764e6eade503a8f4957b7b198ec6ad412e423d95f1b9";
      };
    };
  };

  sdk_5_0 = buildNetSdk {
    inherit icu;
    version = "5.0.408";
    srcs = {
      x86_64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/904da7d0-ff02-49db-bd6b-5ea615cbdfc5/966690e36643662dcc65e3ca2423041e/dotnet-sdk-5.0.408-linux-x64.tar.gz";
        sha512  = "abbf22c420df2d8398d1616efa3d31e1b8f96130697746c45ad68668676d12e65ec3b4dd75f28a5dc7607da58b6e369693c0e658def15ce2431303c28e99db55";
      };
      aarch64-linux = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/d4b71fac-a2fd-4516-ac58-100fb09d796a/e79d6c2a8040b59bf49c0d167ae70a7b/dotnet-sdk-5.0.408-linux-arm64.tar.gz";
        sha512  = "50f23d7aca91051d8b7c37f1a76b1eb51e6fe73e017d98558d757a6b9699e4237d401ce81515c1601b8c21eb62fee4e0b4f0bbed8967eefa3ceba75fc242f01b";
      };
      x86_64-darwin = {
        url     = "https://download.visualstudio.microsoft.com/download/pr/4aeecc7c-7ffa-418f-9362-cf5eb3ed0396/055d5e6064a9fdecd7d906f5f262373d/dotnet-sdk-5.0.408-osx-x64.tar.gz";
        sha512  = "3fdd4deac2809b00c0f669d5488000ac1b9a47dee6ab7b31167d7cec4759a10ee347fd4f52090a40684e5ecc1e1f57eb99c558e561edfd1436a2f77fc1c1a0b2";
      };
    };
    packages = { fetchNuGet }: [
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "5.0.17"; sha256 = "0mfawgcc23r44a1r7ynafxwga6jzn0f0z5ys03qssrvlcdsb376x"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "5.0.17"; sha256 = "183xgqzlwd5lhacxdwcjl8vcq7r7xypv0hddps9k32mmmwf83d8h"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "5.0.17"; sha256 = "0i5pp1smjkyhiyhcbkyc3cxz0sx9204bfml8wsdy7bxznbh2gkmw"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "5.0.17"; sha256 = "1fmd9jq2nzy63hjh4sa6zl636wpgwr3r8ahzln5w14m9k87lfdbk"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "5.0.17"; sha256 = "066fwdlssbv556zd9w1x87x1j8j4kafj9rxyy0692bssdb4gcyc8"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "5.0.17"; sha256 = "1qvvqf8mmzzc7a7fhx324dprnbxhknr3qxspb2xhsn3yyg44xn2d"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm"; version = "5.0.17"; sha256 = "1gzf2gv4z9bn1cr1kpqpf1jf7m0p0wd1pxq5ndylq6bw353yglk1"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "5.0.17"; sha256 = "1lml70ln9bfjrfjf3jbxfzd5kgd4cp4h7v052md5ja364g7lalsy"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "5.0.17"; sha256 = "0j90fri15c05lw96xybgvqkysfm7g8grhkrg25g75vhi6ni2ricj"; })
      (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "5.0.17"; sha256 = "1bdb887xvgxsmphys83zp9skn848p1r8viclc8p29w1rby4wi19i"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "5.0.17"; sha256 = "0y90p765sj54clf2bwrka99w73g8b9550b4qvyilqggzydl1c1hk"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "5.0.17"; sha256 = "07v7vyqm556xr1ypkazfp6gh6drgf20zkwbhkpja8bwdcr6lphbb"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "5.0.17"; sha256 = "0sbzlzhazh31s63hw9553hk9j56fxssncmfgidiyh0dg73aacrsp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "5.0.17"; sha256 = "1qxphvlr882rvmj71y2imnf6r3hh4ln2n138qjyv1z129dp2g4y1"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "5.0.17"; sha256 = "1lc2jhr4ikffi5ylyf8f6ya6k0hdj0wp1l0017grrwd4m5ajj4vv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "5.0.17"; sha256 = "02g5w41ivrw3n6cy3l3ixhcl8bw1fsv4bzs2m34k9h5fqmliaf3c"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm"; version = "5.0.17"; sha256 = "07rfkxpf6rp8x0lybl8hx40mk09w5gjrr9djkjcp8lvjgzidnxq9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "5.0.17"; sha256 = "1i7wka56n3akr96jrkj37jx98bwxfzhpx5705930v50izligd08x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "5.0.17"; sha256 = "15f1kqlpp1d05dhg3dfya32vvzbpj6c7gxds947f10jb0hqlnhdj"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "5.0.17"; sha256 = "1j1334zxv815ksdnllnbwwsbwnimjlpknjmqy1riy2zpswxlfkz6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "5.0.17"; sha256 = "0mmgd6nacx4fzf0w02ch0qxa43vrv6wfspykxsy2bkpvrnvr8xr9"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "5.0.17"; sha256 = "16whaq82pj6fqa0vam3a0va9ly843aa1z12hza040vn6252kk9fq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "5.0.17"; sha256 = "1zavnwqvn2f7lhb880wgv02anrvqsh6l34w72knwd31irggph08l"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "5.0.17"; sha256 = "173r2srcbad2prrw3l914scmdks3mghxgszvlwypdjnv0f2szgvv"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "5.0.17"; sha256 = "0jgcfs3jc98jfyaaamssznckbpnaygplk8pjsp6dswpansz5bnnq"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "5.0.17"; sha256 = "1ph5kx18syinp8bpzw80bgq3njl65gwzws727xcmxnysgm7snmjp"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm"; version = "5.0.17"; sha256 = "0m4jhn70parwnl18fql0sk9sf14y8cf08xw6x2cm5bfhnc9jvjny"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "5.0.17"; sha256 = "1af20jkv73767b4fy18s2dvjncaca1ny0csyr7wbhvqfs59y3n1x"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "5.0.17"; sha256 = "0llhsi03wyp2yjqy0snywqgwjgam91i4nsf5lc9kaxkk5h6vj1a0"; })
      (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "5.0.17"; sha256 = "0xvprbjwd3fymddvavsy7wk5q2hp45hdi10qz4rdbmns23vqkzmf"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetAppHost"; version = "5.0.17"; sha256 = "0vhvxpba3i9ffp4gp56l3rnlhq9yg07n3dv5qi89zb90vgyqjh1p"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHost"; version = "5.0.17"; sha256 = "074c9byxwmndfdavxn103220f5gklaaxc9wj7zpb5v3yr3ads30f"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "5.0.17"; sha256 = "03jkkpsy2zjfp722fa2fcnpk2g6jzy0bn9vip5c39k78y5pz29x6"; })
      (fetchNuGet { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "5.0.17"; sha256 = "1ih6c104skp9q17i2dnsma45l6nv5c62vv2i1988dcjw2v0sl98m"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "5.0.17"; sha256 = "0gwsxd1l0n32xnw0lyjixj2634iyygdb8pd7chydsr3qk8njxnpk"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "5.0.17"; sha256 = "0x5dhn1jkwqnd0cki1vi97rhyfac6w79hvh9dxvnkn2k04sbps8q"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "5.0.17"; sha256 = "1ipx3qn78z6gi415c4fa9wgy8k75aifbml6ys1c9ghl6yxbv0fd0"; })
      (fetchNuGet { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "5.0.17"; sha256 = "1wgbx648yndl0hh8vx6sflfwjyr5pfhi7vj7v19l6vxnrr1096w7"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "5.0.17"; sha256 = "17jc8jc2dk1g8996jpq3k0g6c5inijivxkbz0grxrgr5jbyiv19y"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "5.0.17"; sha256 = "0ydn40qn6cs6f20byvmc9j008s6csxjbh6jh5w4q995vipcmcpcj"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "5.0.17"; sha256 = "0bw08wlf96vcyix850y8jips1glrz2cbj647af4d7gggw8p3wwzw"; })
      (fetchNuGet { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "5.0.17"; sha256 = "0xsqyw848scwcz09pgc719776q712xabx4xv47srzij34p2pq7np"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "5.0.17"; sha256 = "00b0vipypjai4l8icr74kjhglxx2xlc3nw3vyiwisg52l9zyby66"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "5.0.17"; sha256 = "1cdgd4p5zr1mzz9hlb5mj946zfa1vn9wya5y2bhqn9y4ak831wzp"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "5.0.17"; sha256 = "17v8m4fxm4q40z49a2h4lw9dawg6pwfv4s2dskzc23ggcjgr6dp1"; })
      (fetchNuGet { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "5.0.17"; sha256 = "1fbqi92prqmvxx0rx7vhl10l665jmmhb2ng5jndimggydb0ckpqh"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "5.0.17"; sha256 = "1rijxkzzk65xs9z2ygs13h0rhw1cli5vwshmvs1gfnwhhn8ic0gx"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "5.0.17"; sha256 = "02mxvpm2zs5jvawigvxlnrw6si4zwj6qlcas99m9xdmm8yqq22cm"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "5.0.17"; sha256 = "0c1lcl3yy88vdfw12c7h0ww596qfjd5f8l2mn7mlqs6i3f864bkg"; })
      (fetchNuGet { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "5.0.17"; sha256 = "0w0wg9ah7vngvpyds67l6qhizpkdf2r6m6cqyyvv3s5dw5l8rxin"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "5.0.17"; sha256 = "17yy7605vkfz0f4h58005gdfg6fnjxlcnq0vg0hrxsgbdqmd7p1i"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "5.0.17"; sha256 = "0av25fgkdl7zvn44wp8gqx2xl2mdlv1f9cgxzp7xk5yq8f7ynxpq"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "5.0.17"; sha256 = "1smhmdfq0jlv1gq18hdaj0y9yzkvqzmki19c0b3j5b76yxxxpbwz"; })
      (fetchNuGet { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "5.0.17"; sha256 = "0n0cdb9zpdb4h4v6r265pqmqg8c94ydywvna6jp1c6qhqlr0qk39"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "5.0.17"; sha256 = "1s2n2sx29c8rx549zizj8yrddjl98a7vwvxw56y0jvvbwphr9gz4"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "5.0.17"; sha256 = "19m66yvv0hnmyrmx2l4drbls0fcib75fxq2csdx6p8gd54bnrsh3"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "5.0.17"; sha256 = "0bcnlsxcrvhybcjbb9879njx0c4z76y7djx4643g1rpjnkcrj9ww"; })
      (fetchNuGet { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "5.0.17"; sha256 = "1bf95h2f0dmpmv7z7961zia5vaqvmjq3wkf6iil9jxv4z674624w"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "5.0.17"; sha256 = "02q593q09mwwh23m86048vc7b7an7pqch5nd86d4hxzkamnpnpsa"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "5.0.17"; sha256 = "16vzxywfj88gjcwfnmcb6b50ld8dp46i4pqiwwcy7yz15xgdhbm2"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "5.0.17"; sha256 = "1ix5lg2j5ihdfp9j3jdxc042g4syjzc4bafid465j52h6znsm6wm"; })
      (fetchNuGet { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "5.0.17"; sha256 = "0w30v8r26cg427n5glm9nz6r10baalkqq5icqqxkq71hmh8fsjqb"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetAppHost"; version = "5.0.17"; sha256 = "168iq4hdp6bhdpgqa1mir1bygmh2ggwkys1r82d6kpl2lzbxjy28"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHost"; version = "5.0.17"; sha256 = "18jpw2wbrb1b941729lb7hiq4yfq2z53pcxwz4mpgawnr58y0562"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "5.0.17"; sha256 = "0ig464fcsj2jr0p02f6slifwf1m0408g95npm0vccf5ww1nbgkpi"; })
      (fetchNuGet { pname = "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver"; version = "5.0.17"; sha256 = "0qj5avmjrvabxzimprg4m54k3p6zkwrhbpv0byc8c9gbi47s323j"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "5.0.17"; sha256 = "05ghz164lpff7n8mrxs7jm2h8n3clsg4w953zrag3k5ry9j36m9c"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "5.0.17"; sha256 = "0azgs542mbg69jlc81529i2z5m728w8sc2i9m5dx15hvxqqqcjiz"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "5.0.17"; sha256 = "12n1kcgcv5z8hkvjqfk0n705kcipbai4sgcwiimi52xpaf34xw8m"; })
      (fetchNuGet { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "5.0.17"; sha256 = "0b1s2m0a7xcdzfz22x6k7v5hkca90azdjk6pw7wwdnvszwq26nxp"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "5.0.17"; sha256 = "1sjpq07swgj0isdgyh6p2yb254qb9781lv44xfhj6nz7mx2yhdh1"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "5.0.17"; sha256 = "1gnzrqdp26d7pwwz29gm4qb09n2zsb767qkhbwkifcsyxlwi6m0f"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "5.0.17"; sha256 = "089jww13gaf7x7yd9d3qkyx9iq8abcp3r147hd9nblh561c9bzbg"; })
      (fetchNuGet { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "5.0.17"; sha256 = "1nycl1rayk0fhaakpj6q9rfp2lv3dpl7pziavmd9kcfryz952ff5"; })
    ];
  };
}
