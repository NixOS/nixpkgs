{ stdenv, lib, fetchFromGitHub, readline, libedit, bc, pkgs }:

let

  buildJAddonGitHub = attrs@{ name, owner, rev, sha256, ... }:
    stdenv.mkDerivation {
      name = name;
      src = fetchFromGitHub {
        owner = owner;
        repo = name;
        rev = rev;
        sha256 = sha256;
      };

      propagatedBuildInputs = if lib.hasAttr "propagatedBuildInputs" attrs then
        attrs.propagatedBuildInputs
      else
        [ ];

      configurePhase = ''
        # set this to nonempty string to disable default cmake configure
      '';

      buildPhase = "";

      installPhase = ''
        name="${name}"
        mkdir -p $out/addons

        #eg: "convert_json" => d1="convert" d2="json"
        d1=$(echo "$name" | cut -d_ -f 1 -)
        d2=$(echo "$name" | cut -d_ -f 2 -)

        mkdir -p "$out/addons/$d1"

        cp -r $(pwd) "$out/addons/$d1/$d2"
      '';
    };

  # TODO: Add propagatedBuildInputs for dependencies.
  # Collect all addons propagatedBuildInputs in to the j package

  #  #github:cdburke/data_sqlite
  # data_sqlite = buildJAddonGitHub {
  #   name = "data_sqlite";
  #   owner = "cdburke";
  #   rev = "331e04b7a357d47284adb71cc38bcbc563572f43";
  #   sha256 = "0kahwwvrd1aksbr5wk7jqq2zsfr20brzflka24iqqmqqf2995p77";
  #   propagatedBuildInputs = with pkgs; [ sqlite ];
  # };

  # List of addons from: https://github.com/jsoftware/addonrepos/blob/master/repos.txt
  # Regenerate it with:
  # nixpkgs$ maintainers/scripts/update-j-addons.sh

  ide_jnet = buildJAddonGitHub {
    name = "ide_jnet";
    owner = "bilam";
    rev = "4f5355308d61bc081ccb1c0f3362fd976d840ec4";
    sha256 = "0hgl3bpnj39z0d06n02qaivawsjparxg42jmgq5m3i5s84gkx8mi";
  };
  media_videolabs = buildJAddonGitHub {
    name = "media_videolabs";
    owner = "bobtherriault";
    rev = "016398899525f5c06d0c6575a9830a8103e1ea0d";
    sha256 = "1wg4nzzd1nis1l7a9y2fy64h9jnwb6iki9j0fh6zna8ca0sprfdy";
  };
  convert_pjson = buildJAddonGitHub {
    name = "convert_pjson";
    owner = "cdburke";
    rev = "a64defe9adb24a0350517ab99121e8c75259983e";
    sha256 = "1km259hnvc1qwxhvb6nz7pk79jz5rn62g43yhn6ma5bvfz5hj35r";
  };
  data_sqlite = buildJAddonGitHub {
    name = "data_sqlite";
    owner = "cdburke";
    rev = "331e04b7a357d47284adb71cc38bcbc563572f43";
    sha256 = "0kahwwvrd1aksbr5wk7jqq2zsfr20brzflka24iqqmqqf2995p77";
  };
  math_cal = buildJAddonGitHub {
    name = "math_cal";
    owner = "earthspot";
    rev = "0a062ac8ba4a95efaec0d5748322e3d8161327fd";
    sha256 = "0bsvhhhx3w8gdn5vblj6s754izrlm15f33s75mn9gnf2h22kl2k5";
  };
  math_tabula = buildJAddonGitHub {
    name = "math_tabula";
    owner = "earthspot";
    rev = "5e1ac362affe3884044b7ee7a9dd612a8ba184c5";
    sha256 = "0gay38i9hb4dknrhpld1v8z4kd5a6sq7a4546hhicja2n1hl76vv";
  };
  math_uu = buildJAddonGitHub {
    name = "math_uu";
    owner = "earthspot";
    rev = "a2f27a49aa8041ead449723749285dca1a2d818f";
    sha256 = "1hk156ncw45j4akxim6kvgmfk19digs0vwb0n9pr5a9yfqvqrf0n";
  };
  mt = buildJAddonGitHub {
    name = "mt";
    owner = "jip";
    rev = "3141a5578957a8bbe07dd63d74c2ac19f72ef4bc";
    sha256 = "1zdala101nmbv4rrcidjc26yb3q3j3gms2kwkkyzv57451sfjmap";
  };
  api_expat = buildJAddonGitHub {
    name = "api_expat";
    owner = "jsoftware";
    rev = "870a37cac689fa85c9483ada685eba34ee1a8588";
    sha256 = "03878qzxm89j317gh282wcf7rr6cmcnv6893im4fjk3y3h48q2y9";
  };
  api_gles = buildJAddonGitHub {
    name = "api_gles";
    owner = "jsoftware";
    rev = "a3709bb1a087c8439cc2afedd2cc749799422327";
    sha256 = "0fwp8kl27vdix4nz5z0i0b80jwgbk58ck4hg93gcvzn6l40sgsir";
  };
  api_java = buildJAddonGitHub {
    name = "api_java";
    owner = "jsoftware";
    rev = "af70fd7accc64c21cf8f24a400a6781e57b5e830";
    sha256 = "12g2b876d84dgmzf4vmgxkksan2gdyr4m00zxfzkhxsbqw1rmiax";
  };
  api_lapacke = buildJAddonGitHub {
    name = "api_lapacke";
    owner = "jsoftware";
    rev = "8e6d7fbc3b8361382cac03896036dfbbc743d332";
    sha256 = "03zpl0lghdsp9zv6jb7gnwqck3m6xfwljbgvq1dz1fgx5lrc0vx4";
  };
  api_jc = buildJAddonGitHub {
    name = "api_jc";
    owner = "jsoftware";
    rev = "7dd91dcdd1f934100ce725e62c40c15f5d4d4166";
    sha256 = "0sj2525lrzn9dq1g39qsk9pv588qrsyfff3ba4z9gy9wbys5ldl7";
  };
  api_jni = buildJAddonGitHub {
    name = "api_jni";
    owner = "jsoftware";
    rev = "dc07d4a17c3a0afe9d6485b8d9421f240ed70068";
    sha256 = "0wj7brdb62hqxc2cl61x2rv491pf1fgm7h26fakffdid7ljs8dik";
  };
  api_ncurses = buildJAddonGitHub {
    name = "api_ncurses";
    owner = "jsoftware";
    rev = "88d3543be292a3cb79d22a02af9fb972bc014636";
    sha256 = "0zcr3knh1hlvr0ydslhmlb5z8jpr91w7rzyaxq4zrbk65ydsbzl2";
  };
  api_python3 = buildJAddonGitHub {
    name = "api_python3";
    owner = "jsoftware";
    rev = "6b36f39967db9513d631b26ecb5bfd971209d05b";
    sha256 = "0zgj63zzx2v4n5gawx45dn5pqm75blrlnlcp4avlawrsshc2p3fn";
  };
  arc_ziptrees = buildJAddonGitHub {
    name = "arc_ziptrees";
    owner = "jsoftware";
    rev = "be0206c115b13073f72f5f551e68ca8842fa8494";
    sha256 = "1n5sr21yf17c0ycf2857qnkl598j77c5c86yx2yqaz9iq4zgrgs2";
  };
  arc_zlib = buildJAddonGitHub {
    name = "arc_zlib";
    owner = "jsoftware";
    rev = "be37111ffaabd9189f295f35714ffcdf7cf34de3";
    sha256 = "1was81f9dwfh63kh18k1gdc9xmj16vh1cgzfcipyjjdrx93jg68x";
  };
  convert_jiconv = buildJAddonGitHub {
    name = "convert_jiconv";
    owner = "jsoftware";
    rev = "a471fc03190b52d60b2b45cdb67fc9f218880755";
    sha256 = "0rkwffqxr0ngngf4ng3s9mx1yv7q21i36drjhpl6q87vkw30mcf1";
  };
  convert_json = buildJAddonGitHub {
    name = "convert_json";
    owner = "jsoftware";
    rev = "7fdff1f8898b958c14c1035f6b42e494bd98fd0d";
    sha256 = "1896hjd43lzmrrags4srgm73r0lf36b89x1z2vdikdwwrksrr9ms";
  };
  convert_misc = buildJAddonGitHub {
    name = "convert_misc";
    owner = "jsoftware";
    rev = "a274e695daf9644a34739e37f4314b5b6df579c3";
    sha256 = "0zwxl9mclw197w61al5zi5snyppsahxwhi8kjzvdz673j4d0dc3v";
  };
  data_ddmysql = buildJAddonGitHub {
    name = "data_ddmysql";
    owner = "jsoftware";
    rev = "94ee53df3d0f3f7df06c4798446a71fb5dd90a39";
    sha256 = "09as7zry3kwlh9n10xgxp5xbqdqbvdgl9fdnjl3icsc6fmkd186a";
  };
  data_ddsqlite = buildJAddonGitHub {
    name = "data_ddsqlite";
    owner = "jsoftware";
    rev = "245e32800356f9d4a365c971d9ece1c534a978ce";
    sha256 = "18gqm8s7fva0l3wv3bqcfl0axmjyap1ixwf1jgwlnd1wppvk8v5w";
  };
  data_jd = buildJAddonGitHub {
    name = "data_jd";
    owner = "jsoftware";
    rev = "b3d8072b084ea15156a0c1649e9838be6927b4a9";
    sha256 = "1kkhplgawjbi28fsa3ifsyf52y8zy9s4fmh9yzdk9q14gf0qgmyz";
  };
  data_jfiles = buildJAddonGitHub {
    name = "data_jfiles";
    owner = "jsoftware";
    rev = "58249adde967f6c23b580625f41be8aca0ce1c40";
    sha256 = "12f1552z1v4f4mvs39qcn0dlxsrp5c3h5wc3b8msyhd4vx9pic7r";
  };
  data_jmf = buildJAddonGitHub {
    name = "data_jmf";
    owner = "jsoftware";
    rev = "25b886d32ca30d2a4b703cc953c167655858308b";
    sha256 = "192071zrng76fjmh0rvs8x069xy72r04jbnrbp6qwpwqfh5yfs0x";
  };
  data_odbc = buildJAddonGitHub {
    name = "data_odbc";
    owner = "jsoftware";
    rev = "1a43648249a94aef250ea4994d4f42d8c0c04723";
    sha256 = "0mjyw234zn799rqldxnhmsk9wgzl4q27wkjp482vfirmz5p7lrxv";
  };
  data_sqltable = buildJAddonGitHub {
    name = "data_sqltable";
    owner = "jsoftware";
    rev = "5c1eda311fb8ba7c8473cf29f782034944921053";
    sha256 = "10whr1lryhc36396yg456m53q33b1z85lhhgkvis2m04cfnd9nhj";
  };
  debug_dissect = buildJAddonGitHub {
    name = "debug_dissect";
    owner = "jsoftware";
    rev = "113260c9e3bbedf8ed3707af38e2343247278b61";
    sha256 = "1w659x1jxwskaikqm082012s2wisn0lzxygazpbjgcsqj35zvslj";
  };
  debug_jig = buildJAddonGitHub {
    name = "debug_jig";
    owner = "jsoftware";
    rev = "c2413bbe58f1746573c37f1799f6fdc756328132";
    sha256 = "1hyamk0m10yn76240fqn9c90z50mbyzl80jlv7ig2d9v2diprq5n";
  };
  debug_lint = buildJAddonGitHub {
    name = "debug_lint";
    owner = "jsoftware";
    rev = "e312d707b31a8c7c92e63c62f9e0b13b553a0d68";
    sha256 = "1askbwxsrq2jv7bvb0087jdlcgc6kss2c7lz38z36gx3kvcz7lc8";
  };
  debug_tte = buildJAddonGitHub {
    name = "debug_tte";
    owner = "jsoftware";
    rev = "29adf19887044080ca630e099cc2c0f8cfabcee4";
    sha256 = "01fi2474y51m0galpdpd3ghn1v3hyxz7n6xd7n07pjcyp9b3wajj";
  };
  demos_coins = buildJAddonGitHub {
    name = "demos_coins";
    owner = "jsoftware";
    rev = "a796c132e5825689a81b95327fb3a852ba8d569c";
    sha256 = "1n401kdf4zw774w0s65cafdlys8izan4qp30ii6aknb7nr1f6smm";
  };
  demos_isigraph = buildJAddonGitHub {
    name = "demos_isigraph";
    owner = "jsoftware";
    rev = "301d390b932f8751613d149333cdc91e409e4461";
    sha256 = "0vhkz89f09fkdrxi5ilb59n3dqvjm2w1xvpjm1fwrfpyilwdgzhi";
  };
  demos_publish = buildJAddonGitHub {
    name = "demos_publish";
    owner = "jsoftware";
    rev = "718e752b7ef93904f46f01f19b6ba099692c481e";
    sha256 = "09xsfxw5ipvahjd6xd146q51f991a4p08bwc14aljsiry3dqiz3z";
  };
  demos_qtdemo = buildJAddonGitHub {
    name = "demos_qtdemo";
    owner = "jsoftware";
    rev = "ae6de5b5623f6c9ade8bb4f35e15534cf14fabd1";
    sha256 = "0jscbj617qc51wggypar22c3aiznx2m6b0bn19rn1y5bdknld0h2";
  };
  demos_wd = buildJAddonGitHub {
    name = "demos_wd";
    owner = "jsoftware";
    rev = "8690bbbd948e4c46952bdcfe5d67069e3e42a96b";
    sha256 = "088sccl7a7sx0q3av3mr8bflg0fwm46ciywzaxfm4kyd635c5rms";
  };
  demos_wdplot = buildJAddonGitHub {
    name = "demos_wdplot";
    owner = "jsoftware";
    rev = "4ae390bb83bb66868929b5bbdaa4e2285ac245ba";
    sha256 = "0s9gk6kpyf7rv9sj1q0hsyh8br8nziif0lva4n36al2cqib751zq";
  };
  dev_fold = buildJAddonGitHub {
    name = "dev_fold";
    owner = "jsoftware";
    rev = "97bda88fbc383e3c097d9928d7e3feea005bdd88";
    sha256 = "01fx8ypals0r29w5xkc31zx20rhm8v3ixmjl9klhm70b1w2bnjjj";
  };
  docs_help = buildJAddonGitHub {
    name = "docs_help";
    owner = "jsoftware";
    rev = "85845390d2ce2bedebb2d408d471740556711032";
    sha256 = "1gq91pzz6cgc2pmdsq9fqv2200j05a2s3x94yilc0mqbjazxssby";
  };
  docs_joxygen = buildJAddonGitHub {
    name = "docs_joxygen";
    owner = "jsoftware";
    rev = "cb51b8c0eb187167605d341981005d06030e5f03";
    sha256 = "1khhp7p78bcrh2n2i2hhp9ljccmzyfzbxx3l8fdac3yqj9v2gq08";
  };
  finance_actuarial = buildJAddonGitHub {
    name = "finance_actuarial";
    owner = "jsoftware";
    rev = "800ced8600516a7b54bc7a87c77ff6cb0bc0aabc";
    sha256 = "03s8fii97xx6b465dvir0rw153hdq58wryx3mnmkjp67ffinqsjj";
  };
  finance_interest = buildJAddonGitHub {
    name = "finance_interest";
    owner = "jsoftware";
    rev = "2e0343ff5026c6d15433c3cb538246a98ab5e849";
    sha256 = "1vvnwcnmj2hh3584swlhdp8m3a5jv9wgd7m014cswpj8zwdjyg09";
  };
  format_datefmt = buildJAddonGitHub {
    name = "format_datefmt";
    owner = "jsoftware";
    rev = "247e9f4d07d09454d51a441d348b34d11a2f41c9";
    sha256 = "1zxccy4m90r7gnnc1l156611wyk5l1lajn25bx6k915qfjmza8zv";
  };
  format_printf = buildJAddonGitHub {
    name = "format_printf";
    owner = "jsoftware";
    rev = "5fca8b8961100f3eecfa3ff1aa7eae43f433fae1";
    sha256 = "07yz6cr6v7lrfpv9gk80phcy6mqdibzghy4bz5scd2167kxqvi13";
  };
  format_publish = buildJAddonGitHub {
    name = "format_publish";
    owner = "jsoftware";
    rev = "e307597fd96420c42e3a5e70dda30e06ce554132";
    sha256 = "1x68x056spckid56rxaj3ivvhvs7fgin8vbdiwanz88dahy9mznb";
  };
  format_sbox = buildJAddonGitHub {
    name = "format_sbox";
    owner = "jsoftware";
    rev = "149623af11d3160fe3d0b32aff03ea1778ee225e";
    sha256 = "0j0wyr9cbq86p8fivhhnfnzw0p46vawdrv7p9v7xp8klndkya1xh";
  };
  format_zulu = buildJAddonGitHub {
    name = "format_zulu";
    owner = "jsoftware";
    rev = "16273e825aae5064ffd72047cc1373c61add6fbe";
    sha256 = "10vf46ynrgn634i494mvyjcirmlvhl6f6f9vjn4fk9m7h24lhk8s";
  };
  format_zulu-bare = buildJAddonGitHub {
    name = "format_zulu-bare";
    owner = "jsoftware";
    rev = "e9602d34e446e3582a4b378668541beccfb0c2aa";
    sha256 = "1xsk88nyn3zm4gdlx6b1wqbcqvkdckpvb19yycw6d1s4rw78d2lg";
  };
  format_zulu-lite = buildJAddonGitHub {
    name = "format_zulu-lite";
    owner = "jsoftware";
    rev = "845df0d1b055232e83fc256701a1897d19ac3e4b";
    sha256 = "1mzlkfvc2n4wbwvj2q3ili568zrbwpkxncfadnn97yq1ak462w9h";
  };
  games_2048 = buildJAddonGitHub {
    name = "games_2048";
    owner = "jsoftware";
    rev = "810f50208fd2f42ba81ca504f458d6cbf2c9c641";
    sha256 = "1hlbwg8ki0wpsajzw9jzd087xv8fbg34szwh9dcv6hlhz8mk2cnh";
  };
  games_minesweeper = buildJAddonGitHub {
    name = "games_minesweeper";
    owner = "jsoftware";
    rev = "6578a63b9ee47d6c00dc5aacb0c61ff22de9c1d3";
    sha256 = "15jbwpsxr1hyqyzj9r8gh2ib14gwawqcahwn40cg68k6avaf0bj9";
  };
  games_nurikabe = buildJAddonGitHub {
    name = "games_nurikabe";
    owner = "jsoftware";
    rev = "914a8508332dad0719f4b4c0b704715db9bc5b35";
    sha256 = "1z0sckyrfvxwaf83c08gzw9k3i7kdxr6786hsaqid27ry6yqwrws";
  };
  games_pousse = buildJAddonGitHub {
    name = "games_pousse";
    owner = "jsoftware";
    rev = "3a8810111a0a029a2401a39b40774b7253abb2bb";
    sha256 = "0g53k8hjmd6rgsdd858kwvqa7i0gmrxkardnn7nw2j73mnyf90kr";
  };
  games_solitaire = buildJAddonGitHub {
    name = "games_solitaire";
    owner = "jsoftware";
    rev = "7ef609f69c891779af8c7ac3ac36d70e3bf033dc";
    sha256 = "1c4xm6325v5ii9hmggh5xx5rj8vr325976crbjx3mannin3i6q3y";
  };
  general_dirtrees = buildJAddonGitHub {
    name = "general_dirtrees";
    owner = "jsoftware";
    rev = "25e439973f0a642d4ea8722ddc70ed13675cc6e6";
    sha256 = "19v5s8i7za1qsr7yc8p9jprsjjr2m5xpzsvwv8h72mxz6kawwc2q";
  };
  general_dirutils = buildJAddonGitHub {
    name = "general_dirutils";
    owner = "jsoftware";
    rev = "8221d58878d2926dde42a7a1330ae5e994410c53";
    sha256 = "12jl7mi6wm5s3116gkv8j1x04dzxfhws7824jhpcdv97siafymdy";
  };
  general_inifiles = buildJAddonGitHub {
    name = "general_inifiles";
    owner = "jsoftware";
    rev = "7e058a2ba1a5d2f1327cf0a52bd2d32d1342d9b3";
    sha256 = "1x61gvarng6swxp6b61vah7g2dzf5yrzr8yfvd267cbrw18ibj74";
  };
  general_jod = buildJAddonGitHub {
    name = "general_jod";
    owner = "jsoftware";
    rev = "28954f977e22acfd0d1470a889f0d0442d198563";
    sha256 = "1zjn757y0p7av6hsxy856q24zpg3nrr04hvm5xjikmz8gybzvzcr";
  };
  general_joddocument = buildJAddonGitHub {
    name = "general_joddocument";
    owner = "jsoftware";
    rev = "49ce6c6adb2e560b63b034ac675af96b0fc5bd75";
    sha256 = "0ck04m508rgv3nxb6czaxa62s3vn5a4skny3mhwlyczmnwgj3gi2";
  };
  general_jodsource = buildJAddonGitHub {
    name = "general_jodsource";
    owner = "jsoftware";
    rev = "921ee10dfb4e681fc759e5040e95d4dbf9921310";
    sha256 = "0sxikk60w4xxih9299wnfqbkdjdn965vk00cld2zpfk9wk5d586c";
  };
  general_misc = buildJAddonGitHub {
    name = "general_misc";
    owner = "jsoftware";
    rev = "bbfc957fc4ddf90231c4a06239cbc85c67cc2769";
    sha256 = "1ky88dq8skdik0lbrr9892bmbdqbj8fn6w83gxg0jc1lkqsmqb6d";
  };
  general_primitives = buildJAddonGitHub {
    name = "general_primitives";
    owner = "jsoftware";
    rev = "13f0c8f156377221e2caee4a1f1deaf94fb52645";
    sha256 = "0lisrgxjclj165glj3233g5wqvxh0z37548jx0ppz7j4r3wq301b";
  };
  general_unittest = buildJAddonGitHub {
    name = "general_unittest";
    owner = "jsoftware";
    rev = "c0916768bba3832fbb9bf2305d34575a5adc0ad0";
    sha256 = "0j78h07jm1b1q79vz091kv54cqx7g1jralj1dy5vyvswj3gkqrwj";
  };
  graphics_afm = buildJAddonGitHub {
    name = "graphics_afm";
    owner = "jsoftware";
    rev = "a5dd48482aa0f37a1e917d3651148203312a8107";
    sha256 = "0kzl810n43cpibygvwvyahk99sywmpcg317wisd841adnyqfbfkx";
  };
  graphics_bmp = buildJAddonGitHub {
    name = "graphics_bmp";
    owner = "jsoftware";
    rev = "edcffe8d7847e9941d14f6838110a068e0a89102";
    sha256 = "00k417ia5fvszmb4pnd4japrn8i15ync8n4fk1l7i7fbafinxrnr";
  };
  graphics_cairo = buildJAddonGitHub {
    name = "graphics_cairo";
    owner = "jsoftware";
    rev = "e23236060339cdf4b4bec1da9dbca911c2230ad8";
    sha256 = "15f22zxyfj96a2ak6pdclg0jzc81a9x96hwcv5b2s7kbgpnj6cw8";
  };
  graphics_color = buildJAddonGitHub {
    name = "graphics_color";
    owner = "jsoftware";
    rev = "2bb8578c370fd2f25b118ae8cba11153c4687eab";
    sha256 = "155m56f0d268jc8g9yc6fw5l8mnx2sm408if865h0a7682mpgqrb";
  };
  graphics_d3 = buildJAddonGitHub {
    name = "graphics_d3";
    owner = "jsoftware";
    rev = "dcf65b3ae75cea5b6a572a58d048971edcd318bf";
    sha256 = "1shvawyknp64n41k8lph58lnhnsinixl5rzbywa46f09csv74ljf";
  };
  graphics_freeglut = buildJAddonGitHub {
    name = "graphics_freeglut";
    owner = "jsoftware";
    rev = "d047eadf0af899301449c04ab38bdaf4ca7d81da";
    sha256 = "0f9fxqxq5fpsz0yj1xi90zf1q4nfn9vv9nr7dqdwmxz6g50r9kz7";
  };
  graphics_fvj4 = buildJAddonGitHub {
    name = "graphics_fvj4";
    owner = "jsoftware";
    rev = "e82b7204014777354c736767e9ebf0fdd0a4b0a2";
    sha256 = "16gzaj0mdnsrgf9ivcciw6bhmmjv721rrg42kn8sb1h54f6xzhh6";
  };
  graphics_gnuplot = buildJAddonGitHub {
    name = "graphics_gnuplot";
    owner = "jsoftware";
    rev = "1b2d3f3e9bc206d13921f16982d5b52bca44c4f7";
    sha256 = "0kz3gjykyrpkvn1agp7hc4rgzyb3kvnrs3k1jwrk20agjn2nzqn0";
  };
  graphics_graph = buildJAddonGitHub {
    name = "graphics_graph";
    owner = "jsoftware";
    rev = "378ec6adf8484cba3c4662ca6f2da0ced905b092";
    sha256 = "0szgv221x5n3fa5cbzzs04mbcrv67jf2p0lw38v5sgnc7v1ydfkl";
  };
  graphics_graphviz = buildJAddonGitHub {
    name = "graphics_graphviz";
    owner = "jsoftware";
    rev = "525db3db46a5ce9b116ac58ed795ec004ea622b0";
    sha256 = "165qspygipqijzpyh2p90xjy31x7yba95kr4xljga5yvr8mxkn1l";
  };
  graphics_jpeg = buildJAddonGitHub {
    name = "graphics_jpeg";
    owner = "jsoftware";
    rev = "1234416aff49164a14a73cc73cf47d4cde634b52";
    sha256 = "0s2xmg6fv1kxhzkkjxvb3w424zk71iij2i9qizr1w81l76nk945j";
  };
  graphics_pdfdraw = buildJAddonGitHub {
    name = "graphics_pdfdraw";
    owner = "jsoftware";
    rev = "c5e6791fabc0a8210b0cca839ed209d4fbf503bf";
    sha256 = "1975ldkgksyqybwdixqg5hapd4rqz929skind4h71gax9hmcy479";
  };
  graphics_plot = buildJAddonGitHub {
    name = "graphics_plot";
    owner = "jsoftware";
    rev = "900efc7c70923f8b2592e6d0ecefa77b00b8ece2";
    sha256 = "04n07988gp5a424sgpasivs2mb3yiqfaxnkp4gw0xf5gqx8v3ams";
  };
  graphics_png = buildJAddonGitHub {
    name = "graphics_png";
    owner = "jsoftware";
    rev = "2767c9b8efea71c38b0d8433bd58aba360ea464a";
    sha256 = "1i5i9x7am36dr58bvlhydyp3bhmhbgg355k9jfddjylbrsnb7rc9";
  };
  graphics_pplatimg = buildJAddonGitHub {
    name = "graphics_pplatimg";
    owner = "jsoftware";
    rev = "a635da57097649ad434680e6006679e65f2711eb";
    sha256 = "034px2d9m1p49jz75469dqx2z1m1zds2jg7rq9c5qjmz7q5kbli3";
  };
  graphics_print = buildJAddonGitHub {
    name = "graphics_print";
    owner = "jsoftware";
    rev = "ef227a8a58217304baebed1aba93853a9e69f7fa";
    sha256 = "16mnikilz3l2v3dvxqkrb333s7kj9bjm27z0km51ibijdxyhb1vl";
  };
  graphics_treemap = buildJAddonGitHub {
    name = "graphics_treemap";
    owner = "jsoftware";
    rev = "ceb71cb6546519291129cc3afdcc0cca706294e9";
    sha256 = "11rpsd08mnfrbxcv46wmyn9896w5g681x1j1xb6iy9h4vs6myg6c";
  };
  graphics_viewmat = buildJAddonGitHub {
    name = "graphics_viewmat";
    owner = "jsoftware";
    rev = "ed86115ed60a43a506f4ec9c827963866b738217";
    sha256 = "1jv52s3fi6wrqjdi2p45v7mjy2jr5zmkq213axjgbgm2f4b3m458";
  };
  gui_cobrowser = buildJAddonGitHub {
    name = "gui_cobrowser";
    owner = "jsoftware";
    rev = "b20f19ad3a63d43e418b12fcec0f6cc65958bcaa";
    sha256 = "17a7kgcahhy0bfscm1bvrvgp2fnslz32fs4z9m56c3kjaqfrpwmw";
  };
  ide_ja = buildJAddonGitHub {
    name = "ide_ja";
    owner = "jsoftware";
    rev = "45a0f1ce50f1f8f33111a142548f22893f81e3f1";
    sha256 = "0rqba6kmiphv0h59cn353izwz1ql69rrr7wdidncl93vjwdzpr6j";
  };
  ide_jhs = buildJAddonGitHub {
    name = "ide_jhs";
    owner = "jsoftware";
    rev = "dbe17d57521660abcfedb19130b902e3835d6fd5";
    sha256 = "17nai7qkpg2df3bmhc2shr6f2zv9fzkl5j1r7b30xq0rr85g7lcc";
  };
  ide_qt = buildJAddonGitHub {
    name = "ide_qt";
    owner = "jsoftware";
    rev = "e306a3898e89a3215c94075d70d360a7deb477d2";
    sha256 = "0vnx2dhi9wjimnk8s3l17fz6ywxx7rkcd905a0swhgbr32w5ajxs";
  };
  labs_labs = buildJAddonGitHub {
    name = "labs_labs";
    owner = "jsoftware";
    rev = "cfa4b1df62ed137df2dc2ab2661f260484880ea3";
    sha256 = "1cgfd5j8j1r1yfy71dcjcldh8yb3l9s120ln5c253liszwii0a6w";
  };
  math_calculus = buildJAddonGitHub {
    name = "math_calculus";
    owner = "jsoftware";
    rev = "9a5cc851423b8c25e09c3be8e3066483d1b895f2";
    sha256 = "0jayryq57cxbmwh9r490q8d2dsk2400fvk8fvymbhbjhk305ryrh";
  };
  math_deoptim = buildJAddonGitHub {
    name = "math_deoptim";
    owner = "jsoftware";
    rev = "12ee2b3b48b7156c9f29538ec11d9533ece2e9ed";
    sha256 = "1simbp0wyklwf730mm7558g2cp6v5pq46gz2p3pgafi1csahwcv3";
  };
  math_eigenpic = buildJAddonGitHub {
    name = "math_eigenpic";
    owner = "jsoftware";
    rev = "797e458957984b564ae9391d1f377bd9447f8935";
    sha256 = "1f1m2m695k9sgr906jbal5nzq4qzb29nwa138mbfgmmbjikxwjxk";
  };
  math_fftw = buildJAddonGitHub {
    name = "math_fftw";
    owner = "jsoftware";
    rev = "7e7e2bbe90cfe479235aebc5335eb0e09a875654";
    sha256 = "0fk43crxrfy2z694lkpw5sgwf7i5ykm3c6x9k52vnljg0kgi5dgp";
  };
  math_flann = buildJAddonGitHub {
    name = "math_flann";
    owner = "jsoftware";
    rev = "99ffb0ade4cccedd7f3263189a50562938e39d7f";
    sha256 = "0wis2jgrp5xzw9abb4k5nikb01ykqgv7k0mcdsk8z6y8dzc2lhir";
  };
  math_lapack = buildJAddonGitHub {
    name = "math_lapack";
    owner = "jsoftware";
    rev = "6b3c0d769e3ca036b9accbde4e3e3d8c8272df66";
    sha256 = "124xb94dp50kzh5v0viynnv1sf4yakp9bk9w4w5x2hhwdpcscdmp";
  };
  math_lapack2 = buildJAddonGitHub {
    name = "math_lapack2";
    owner = "jsoftware";
    rev = "1eaec0d8a39dd687195dcf5b925ccd73ddab1b4c";
    sha256 = "0gjkbk9n9gc5fc063wxqmwdw37fb4m8cdsalqwjbdq8yijsqrv6k";
  };
  math_lbfgs = buildJAddonGitHub {
    name = "math_lbfgs";
    owner = "jsoftware";
    rev = "18c588f0c73380bdfd9ea4d1d87ed3b9305a7dd0";
    sha256 = "0swy48ggkf1pnk8rc302riwcd709yx176hxvb13rdgnwfys9wdl0";
  };
  math_misc = buildJAddonGitHub {
    name = "math_misc";
    owner = "jsoftware";
    rev = "ee67a58fd84d6fe11ad636d703457cb3d7bcd4fc";
    sha256 = "0j2m90nz9r66dccivzzr215fy7k5pk4brkpwl2skqjgkqxd163ln";
  };
  media_imagekit = buildJAddonGitHub {
    name = "media_imagekit";
    owner = "jsoftware";
    rev = "6de6b5eb1305427a99e0eb59285d421959b9c1bb";
    sha256 = "17i2dfdmx6bsa826a1xfw8xg9r855cw8yq8asgfiv3vcvdzqpqa8";
  };
  media_wav = buildJAddonGitHub {
    name = "media_wav";
    owner = "jsoftware";
    rev = "67ccbc720af3f6e35c301c7fb6c2028eb989483d";
    sha256 = "0z104wcd10qi3y3j6gc2qiyig04h72nicxfmsrdfdjla0bhy64z6";
  };
  misc_classroom = buildJAddonGitHub {
    name = "misc_classroom";
    owner = "jsoftware";
    rev = "ba6ba9df647890a6b162b8a22686c8a0afa3edc0";
    sha256 = "0qsyw3vrg2bwmddy9hnv65awvz0zwly63i7h226dwzrw5n1np20f";
  };
  misc_miscutils = buildJAddonGitHub {
    name = "misc_miscutils";
    owner = "jsoftware";
    rev = "3fea111992b16f8e5d476caa5dc4567afe885c48";
    sha256 = "0smd6gq1agmy0pll2vp64vbihilzl3s1g7761mnfq2sipb3ykm22";
  };
  net_clientserver = buildJAddonGitHub {
    name = "net_clientserver";
    owner = "jsoftware";
    rev = "21822d62d75419c73f9e7e871833ac2eaa9e3920";
    sha256 = "0bcr3pynr8s8gppmqf4z86znqs1176ixgxb191pvhn89a2x7f72x";
  };
  net_jcs = buildJAddonGitHub {
    name = "net_jcs";
    owner = "jsoftware";
    rev = "4e7756e0446693f657222e5d128f25046e4358e8";
    sha256 = "17n0cy77cdrdphybxd5zyi00f0ykvw04lb102s82gz6ddlay9qpi";
  };
  net_websocket = buildJAddonGitHub {
    name = "net_websocket";
    owner = "jsoftware";
    rev = "0194fec6908842c0b8c8a4f68d054cbe3d4350c6";
    sha256 = "1wz29574x3xhsvx04cxldaiin96lh0gm80zly3y5fak5b1iipbvq";
  };
  net_zmq = buildJAddonGitHub {
    name = "net_zmq";
    owner = "jsoftware";
    rev = "5e6514c05094e840fd9f1e642c952fb5dfd5c0d4";
    sha256 = "12j1xs6271nxs4345kdcw1jym6zgm8va9xbj8vbpalghrqbdkzga";
  };
  profiles_profiles = buildJAddonGitHub {
    name = "profiles_profiles";
    owner = "jsoftware";
    rev = "6a4d1074e705f61634b18470c1a1356414072aa3";
    sha256 = "1vxycpw7h2ighp89sb5wa6rm02ibwxkbi14nskx1883bhyy378qb";
  };
  sockets_socklib = buildJAddonGitHub {
    name = "sockets_socklib";
    owner = "jsoftware";
    rev = "53dd3d9459ec6d790d33b39da9b24e915e9a837a";
    sha256 = "10ah2wyf42vm2amm4w42i1pzxyvflfrbnmgcgxmhark14kxa19m5";
  };
  sockets_sockutils = buildJAddonGitHub {
    name = "sockets_sockutils";
    owner = "jsoftware";
    rev = "3cd63f5de3124eeafe47de379a12a16cf89631eb";
    sha256 = "1mwrc92dn4zmdqzkb30agd1y1zcam9sdg2bbk44zp9p3g9c88yv8";
  };
  stats_base = buildJAddonGitHub {
    name = "stats_base";
    owner = "jsoftware";
    rev = "559ba502be012e425741879dce642cacdda9a46a";
    sha256 = "0gnsh5r6178g8sa5njfcqbi9aylrfvnhgfyk6szk1nb3s76ibmvl";
  };
  stats_distribs = buildJAddonGitHub {
    name = "stats_distribs";
    owner = "jsoftware";
    rev = "fc3bf537748fa424a580326c5789e1248ea64d58";
    sha256 = "0xjlnj9q0vpigp0zyhvmy9i59k6n4fzb4wwj0yw8shnpbaj9lzwc";
  };
  stats_jserver4r = buildJAddonGitHub {
    name = "stats_jserver4r";
    owner = "jsoftware";
    rev = "4c94fc6df351fab34791aa9d78d158eaefd33b17";
    sha256 = "0k63d81zgdfd3l8zyk4jb8a76pgsh4lgrrvsxsl462hlyh1j663g";
  };
  stats_r = buildJAddonGitHub {
    name = "stats_r";
    owner = "jsoftware";
    rev = "fb37bb7038156850b950d07049a321c53208fd1e";
    sha256 = "1rg2x3axrwqvd6czqgdvf27yh61qrqd94wfdq0f55r8dmapg1331";
  };
  stats_rlibrary = buildJAddonGitHub {
    name = "stats_rlibrary";
    owner = "jsoftware";
    rev = "c7cd717b1087eb930b777ac56c67652091fbc4b9";
    sha256 = "17mpmq3ban0swhd1wsd1yr7fdxnr99k53m6vviypihmm9kazhpvf";
  };
  tables_csv = buildJAddonGitHub {
    name = "tables_csv";
    owner = "jsoftware";
    rev = "3f0d75d1cd4822398d2185c77c0fd1d0ab2af140";
    sha256 = "0qp0d1xivpsmkbrnd0lk7q4dryim48gvwjbrn5r10l07xqqvya8d";
  };
  tables_dsv = buildJAddonGitHub {
    name = "tables_dsv";
    owner = "jsoftware";
    rev = "6c3565993a95f977d93a219c95eff202d0b1845b";
    sha256 = "1znp1qqmb4060qh0xjfxrx6016128w6zkpb51imja2gsqvg0lnnw";
  };
  tables_excel = buildJAddonGitHub {
    name = "tables_excel";
    owner = "jsoftware";
    rev = "7b6ea5ea291d733b453f3639ae5b6b4f7e0a46c6";
    sha256 = "0wmhpm88bhw2b87z9gh6adfiysbhh5n7461yi4mp5kpyd3fax11j";
  };
  tables_tara = buildJAddonGitHub {
    name = "tables_tara";
    owner = "jsoftware";
    rev = "2fd3dc0085dbcbb3f1a963c4b7319ba16adc89c1";
    sha256 = "1pfsal7fnp63l7lx9fzxjwwd1s2hhhzr3scwpnzxalx0nphzz32j";
  };
  tables_taraxml = buildJAddonGitHub {
    name = "tables_taraxml";
    owner = "jsoftware";
    rev = "07ada2ff19add9ee5710e99837016995ced0cfd5";
    sha256 = "11grahr2ki6jjp2mmzn0lbn1smi50i2nfgqg695wid02wnqh3whh";
  };
  tables_wdooo = buildJAddonGitHub {
    name = "tables_wdooo";
    owner = "jsoftware";
    rev = "b4b5423f45cd69b88ca9d3e43c05f31d39d97686";
    sha256 = "0xfdqwdyyz6h5wi21iiyd5awn6r2svwr697sl850m7gv15sy2rhl";
  };
  types_datetime = buildJAddonGitHub {
    name = "types_datetime";
    owner = "jsoftware";
    rev = "45bfa87509e1bd4fa42ffae92bf992764acd2d35";
    sha256 = "0f0f93j55rbs4dq2lznf4ixbb5vmiiyif0ws2mhczl52v3k4wbcq";
  };
  web_gethttp = buildJAddonGitHub {
    name = "web_gethttp";
    owner = "jsoftware";
    rev = "d4881d9f4df9d6f2fda0929cba98fdcdeb228f7a";
    sha256 = "0k5zrydb2hjzygpywdq4z4j8mqfdw4l43b7qmcqxrzk2p8fff947";
  };

in stdenv.mkDerivation rec {
  pname = "j";
  version = "901";
  jtype = "release-e";
  src = fetchFromGitHub {
    owner = "jsoftware";
    repo = "jsource";
    rev = "j${version}-${jtype}";
    sha256 = "13ky37rrl6mc66fckrdnrw64gmvq1qlv6skzd513lab4d0wigshw";
    name = "jsource";
  };

  buildInputs = [ readline libedit bc ];
  bits = if stdenv.is64bit then "64" else "32";
  platform = if (stdenv.isAarch32 || stdenv.isAarch64) then
    "raspberry"
  else if stdenv.isLinux then
    "linux"
  else if stdenv.isDarwin then
    "darwin"
  else
    "unknown";

  doCheck = true;

  buildPhase = ''
    export SOURCE_DIR=$(pwd)
    export HOME=$TMPDIR
    export JLIB=$SOURCE_DIR/jlibrary

    echo $OUT_DIR

    cd make2

    patchShebangs .
    sed -i $JLIB/bin/profile.ijs -e "s@'/usr/share/j/.*'@'$out/share/j'@;"

    ./build_all.sh

    cp $SOURCE_DIR/bin/${platform}/j${bits}*/* "$JLIB/bin"
  '';

  checkPhase = ''

    echo 'i. 5' | $JLIB/bin/jconsole | fgrep "0 1 2 3 4"

    # Now run the real tests
    cd $SOURCE_DIR/test
    for f in *.ijs
    do
      echo $f
      $JLIB/bin/jconsole < $f > /dev/null || echo FAIL && echo PASS
    done
  '';

  installPhase = ''
    mkdir -p "$out"

    mkdir -p "$out/share/j"
    cp -r $JLIB/{addons,system} "$out/share/j"
    cp -r $JLIB/bin "$out"


    # install addons

    #TODO: find a nicer way to do this.  (from `tree -L 1 addons` in a git clone https://github.com/jsoftware/addonrepos)
    mkdir -p "$out/share/j/addons/api"
    mkdir -p "$out/share/j/addons/arc"
    mkdir -p "$out/share/j/addons/convert"
    mkdir -p "$out/share/j/addons/data"
    mkdir -p "$out/share/j/addons/debug"
    mkdir -p "$out/share/j/addons/demos"
    mkdir -p "$out/share/j/addons/dev"
    mkdir -p "$out/share/j/addons/docs"
    mkdir -p "$out/share/j/addons/finance"
    mkdir -p "$out/share/j/addons/format"
    mkdir -p "$out/share/j/addons/games"
    mkdir -p "$out/share/j/addons/general"
    mkdir -p "$out/share/j/addons/graphics"
    mkdir -p "$out/share/j/addons/gui"
    mkdir -p "$out/share/j/addons/ide"
    mkdir -p "$out/share/j/addons/labs"
    mkdir -p "$out/share/j/addons/math"
    mkdir -p "$out/share/j/addons/media"
    mkdir -p "$out/share/j/addons/misc"
    mkdir -p "$out/share/j/addons/mt"
    mkdir -p "$out/share/j/addons/net"
    mkdir -p "$out/share/j/addons/profiles"
    mkdir -p "$out/share/j/addons/sockets"
    mkdir -p "$out/share/j/addons/stats"
    mkdir -p "$out/share/j/addons/tables"
    mkdir -p "$out/share/j/addons/types"
    mkdir -p "$out/share/j/addons/web"

    cp -r ${ide_jnet}/addons/ide/jnet "$out/share/j/addons/ide/jnet"
    cp -r ${media_videolabs}/addons/media/videolabs "$out/share/j/addons/media/videolabs"
    cp -r ${convert_pjson}/addons/convert/pjson "$out/share/j/addons/convert/pjson"
    cp -r ${data_sqlite}/addons/data/sqlite "$out/share/j/addons/data/sqlite"
    cp -r ${math_cal}/addons/math/cal "$out/share/j/addons/math/cal"
    cp -r ${math_tabula}/addons/math/tabula "$out/share/j/addons/math/tabula"
    cp -r ${math_uu}/addons/math/uu "$out/share/j/addons/math/uu"
    cp -r ${mt}/addons/mt "$out/share/j/addons/mt"
    cp -r ${api_expat}/addons/api/expat "$out/share/j/addons/api/expat"
    cp -r ${api_gles}/addons/api/gles "$out/share/j/addons/api/gles"
    cp -r ${api_java}/addons/api/java "$out/share/j/addons/api/java"
    cp -r ${api_lapacke}/addons/api/lapacke "$out/share/j/addons/api/lapacke"
    cp -r ${api_jc}/addons/api/jc "$out/share/j/addons/api/jc"
    cp -r ${api_jni}/addons/api/jni "$out/share/j/addons/api/jni"
    cp -r ${api_ncurses}/addons/api/ncurses "$out/share/j/addons/api/ncurses"
    cp -r ${api_python3}/addons/api/python3 "$out/share/j/addons/api/python3"
    cp -r ${arc_ziptrees}/addons/arc/ziptrees "$out/share/j/addons/arc/ziptrees"
    cp -r ${arc_zlib}/addons/arc/zlib "$out/share/j/addons/arc/zlib"
    cp -r ${convert_jiconv}/addons/convert/jiconv "$out/share/j/addons/convert/jiconv"
    cp -r ${convert_json}/addons/convert/json "$out/share/j/addons/convert/json"
    cp -r ${convert_misc}/addons/convert/misc "$out/share/j/addons/convert/misc"
    cp -r ${data_ddmysql}/addons/data/ddmysql "$out/share/j/addons/data/ddmysql"
    cp -r ${data_ddsqlite}/addons/data/ddsqlite "$out/share/j/addons/data/ddsqlite"
    cp -r ${data_jd}/addons/data/jd "$out/share/j/addons/data/jd"
    cp -r ${data_jfiles}/addons/data/jfiles "$out/share/j/addons/data/jfiles"
    cp -r ${data_jmf}/addons/data/jmf "$out/share/j/addons/data/jmf"
    cp -r ${data_odbc}/addons/data/odbc "$out/share/j/addons/data/odbc"
    cp -r ${data_sqltable}/addons/data/sqltable "$out/share/j/addons/data/sqltable"
    cp -r ${debug_dissect}/addons/debug/dissect "$out/share/j/addons/debug/dissect"
    cp -r ${debug_jig}/addons/debug/jig "$out/share/j/addons/debug/jig"
    cp -r ${debug_lint}/addons/debug/lint "$out/share/j/addons/debug/lint"
    cp -r ${debug_tte}/addons/debug/tte "$out/share/j/addons/debug/tte"
    cp -r ${demos_coins}/addons/demos/coins "$out/share/j/addons/demos/coins"
    cp -r ${demos_isigraph}/addons/demos/isigraph "$out/share/j/addons/demos/isigraph"
    cp -r ${demos_publish}/addons/demos/publish "$out/share/j/addons/demos/publish"
    cp -r ${demos_qtdemo}/addons/demos/qtdemo "$out/share/j/addons/demos/qtdemo"
    cp -r ${demos_wd}/addons/demos/wd "$out/share/j/addons/demos/wd"
    cp -r ${demos_wdplot}/addons/demos/wdplot "$out/share/j/addons/demos/wdplot"
    cp -r ${dev_fold}/addons/dev/fold "$out/share/j/addons/dev/fold"
    cp -r ${docs_help}/addons/docs/help "$out/share/j/addons/docs/help"
    cp -r ${docs_joxygen}/addons/docs/joxygen "$out/share/j/addons/docs/joxygen"
    cp -r ${finance_actuarial}/addons/finance/actuarial "$out/share/j/addons/finance/actuarial"
    cp -r ${finance_interest}/addons/finance/interest "$out/share/j/addons/finance/interest"
    cp -r ${format_datefmt}/addons/format/datefmt "$out/share/j/addons/format/datefmt"
    cp -r ${format_printf}/addons/format/printf "$out/share/j/addons/format/printf"
    cp -r ${format_publish}/addons/format/publish "$out/share/j/addons/format/publish"
    cp -r ${format_sbox}/addons/format/sbox "$out/share/j/addons/format/sbox"
    cp -r ${format_zulu}/addons/format/zulu "$out/share/j/addons/format/zulu"
    cp -r ${format_zulu-bare}/addons/format/zulu-bare "$out/share/j/addons/format/zulu-bare"
    cp -r ${format_zulu-lite}/addons/format/zulu-lite "$out/share/j/addons/format/zulu-lite"
    cp -r ${games_2048}/addons/games/2048 "$out/share/j/addons/games/2048"
    cp -r ${games_minesweeper}/addons/games/minesweeper "$out/share/j/addons/games/minesweeper"
    cp -r ${games_nurikabe}/addons/games/nurikabe "$out/share/j/addons/games/nurikabe"
    cp -r ${games_pousse}/addons/games/pousse "$out/share/j/addons/games/pousse"
    cp -r ${games_solitaire}/addons/games/solitaire "$out/share/j/addons/games/solitaire"
    cp -r ${general_dirtrees}/addons/general/dirtrees "$out/share/j/addons/general/dirtrees"
    cp -r ${general_dirutils}/addons/general/dirutils "$out/share/j/addons/general/dirutils"
    cp -r ${general_inifiles}/addons/general/inifiles "$out/share/j/addons/general/inifiles"
    cp -r ${general_jod}/addons/general/jod "$out/share/j/addons/general/jod"
    cp -r ${general_joddocument}/addons/general/joddocument "$out/share/j/addons/general/joddocument"
    cp -r ${general_jodsource}/addons/general/jodsource "$out/share/j/addons/general/jodsource"
    cp -r ${general_misc}/addons/general/misc "$out/share/j/addons/general/misc"
    cp -r ${general_primitives}/addons/general/primitives "$out/share/j/addons/general/primitives"
    cp -r ${general_unittest}/addons/general/unittest "$out/share/j/addons/general/unittest"
    cp -r ${graphics_afm}/addons/graphics/afm "$out/share/j/addons/graphics/afm"
    cp -r ${graphics_bmp}/addons/graphics/bmp "$out/share/j/addons/graphics/bmp"
    cp -r ${graphics_cairo}/addons/graphics/cairo "$out/share/j/addons/graphics/cairo"
    cp -r ${graphics_color}/addons/graphics/color "$out/share/j/addons/graphics/color"
    cp -r ${graphics_d3}/addons/graphics/d3 "$out/share/j/addons/graphics/d3"
    cp -r ${graphics_freeglut}/addons/graphics/freeglut "$out/share/j/addons/graphics/freeglut"
    cp -r ${graphics_fvj4}/addons/graphics/fvj4 "$out/share/j/addons/graphics/fvj4"
    cp -r ${graphics_gnuplot}/addons/graphics/gnuplot "$out/share/j/addons/graphics/gnuplot"
    cp -r ${graphics_graph}/addons/graphics/graph "$out/share/j/addons/graphics/graph"
    cp -r ${graphics_graphviz}/addons/graphics/graphviz "$out/share/j/addons/graphics/graphviz"
    cp -r ${graphics_jpeg}/addons/graphics/jpeg "$out/share/j/addons/graphics/jpeg"
    cp -r ${graphics_pdfdraw}/addons/graphics/pdfdraw "$out/share/j/addons/graphics/pdfdraw"
    cp -r ${graphics_plot}/addons/graphics/plot "$out/share/j/addons/graphics/plot"
    cp -r ${graphics_png}/addons/graphics/png "$out/share/j/addons/graphics/png"
    cp -r ${graphics_pplatimg}/addons/graphics/pplatimg "$out/share/j/addons/graphics/pplatimg"
    cp -r ${graphics_print}/addons/graphics/print "$out/share/j/addons/graphics/print"
    cp -r ${graphics_treemap}/addons/graphics/treemap "$out/share/j/addons/graphics/treemap"
    cp -r ${graphics_viewmat}/addons/graphics/viewmat "$out/share/j/addons/graphics/viewmat"
    cp -r ${gui_cobrowser}/addons/gui/cobrowser "$out/share/j/addons/gui/cobrowser"
    cp -r ${ide_ja}/addons/ide/ja "$out/share/j/addons/ide/ja"
    cp -r ${ide_jhs}/addons/ide/jhs "$out/share/j/addons/ide/jhs"
    cp -r ${ide_qt}/addons/ide/qt "$out/share/j/addons/ide/qt"
    cp -r ${labs_labs}/addons/labs/labs "$out/share/j/addons/labs/labs"
    cp -r ${math_calculus}/addons/math/calculus "$out/share/j/addons/math/calculus"
    cp -r ${math_deoptim}/addons/math/deoptim "$out/share/j/addons/math/deoptim"
    cp -r ${math_eigenpic}/addons/math/eigenpic "$out/share/j/addons/math/eigenpic"
    cp -r ${math_fftw}/addons/math/fftw "$out/share/j/addons/math/fftw"
    cp -r ${math_flann}/addons/math/flann "$out/share/j/addons/math/flann"
    cp -r ${math_lapack}/addons/math/lapack "$out/share/j/addons/math/lapack"
    cp -r ${math_lapack2}/addons/math/lapack2 "$out/share/j/addons/math/lapack2"
    cp -r ${math_lbfgs}/addons/math/lbfgs "$out/share/j/addons/math/lbfgs"
    cp -r ${math_misc}/addons/math/misc "$out/share/j/addons/math/misc"
    cp -r ${media_imagekit}/addons/media/imagekit "$out/share/j/addons/media/imagekit"
    cp -r ${media_wav}/addons/media/wav "$out/share/j/addons/media/wav"
    cp -r ${misc_classroom}/addons/misc/classroom "$out/share/j/addons/misc/classroom"
    cp -r ${misc_miscutils}/addons/misc/miscutils "$out/share/j/addons/misc/miscutils"
    cp -r ${net_clientserver}/addons/net/clientserver "$out/share/j/addons/net/clientserver"
    cp -r ${net_jcs}/addons/net/jcs "$out/share/j/addons/net/jcs"
    cp -r ${net_websocket}/addons/net/websocket "$out/share/j/addons/net/websocket"
    cp -r ${net_zmq}/addons/net/zmq "$out/share/j/addons/net/zmq"
    cp -r ${profiles_profiles}/addons/profiles/profiles "$out/share/j/addons/profiles/profiles"
    cp -r ${sockets_socklib}/addons/sockets/socklib "$out/share/j/addons/sockets/socklib"
    cp -r ${sockets_sockutils}/addons/sockets/sockutils "$out/share/j/addons/sockets/sockutils"
    cp -r ${stats_base}/addons/stats/base "$out/share/j/addons/stats/base"
    cp -r ${stats_distribs}/addons/stats/distribs "$out/share/j/addons/stats/distribs"
    cp -r ${stats_jserver4r}/addons/stats/jserver4r "$out/share/j/addons/stats/jserver4r"
    cp -r ${stats_r}/addons/stats/r "$out/share/j/addons/stats/r"
    cp -r ${stats_rlibrary}/addons/stats/rlibrary "$out/share/j/addons/stats/rlibrary"
    cp -r ${tables_csv}/addons/tables/csv "$out/share/j/addons/tables/csv"
    cp -r ${tables_dsv}/addons/tables/dsv "$out/share/j/addons/tables/dsv"
    cp -r ${tables_excel}/addons/tables/excel "$out/share/j/addons/tables/excel"
    cp -r ${tables_tara}/addons/tables/tara "$out/share/j/addons/tables/tara"
    cp -r ${tables_taraxml}/addons/tables/taraxml "$out/share/j/addons/tables/taraxml"
    cp -r ${tables_wdooo}/addons/tables/wdooo "$out/share/j/addons/tables/wdooo"
    cp -r ${types_datetime}/addons/types/datetime "$out/share/j/addons/types/datetime"
    cp -r ${web_gethttp}/addons/web/gethttp "$out/share/j/addons/web/gethttp"

  '';

  meta = with stdenv.lib; {
    description = "J programming language, an ASCII-based APL successor";
    maintainers = with maintainers; [ raskin synthetica ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.gpl3Plus;
    homepage = "http://jsoftware.com/";
  };
}
