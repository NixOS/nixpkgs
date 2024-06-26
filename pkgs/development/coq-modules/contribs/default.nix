{
  lib,
  mkCoqDerivation,
  coq,
  callPackage,
}:

let
  mkContrib =
    pname: coqs: param:
    let
      contribVersion =
        {
          version ? null,
        }:
        mkCoqDerivation (
          {
            inherit pname version;
            owner = "coq-contribs";
            mlPlugin = true;
          }
          // lib.optionalAttrs (builtins.elem coq.coq-version coqs) (
            {
              defaultVersion = param.version;
              release = {
                "${param.version}" = {
                  inherit (param) rev sha256;
                };
              };
            }
            // (removeAttrs param [
              "version"
              "rev"
              "sha256"
            ])
          )
        );
    in
    lib.makeOverridable contribVersion { };
in
{
  aac-tactics =
    mkContrib "aac-tactics"
      [
        "8.7"
        "8.8"
      ]
      {
        "8.7" = {
          version = "20180530";
          rev = "f01df35e1d796ce1fdc7ba3d670ce5d63c95d544";
          sha256 = "1bwvnbd5ws1plgj147blcrvyycf3gg3fz3rm2mckln8z3sfxyq2k";
        };
        "8.8" = {
          version = "20180530";
          rev = "86ac28259030649ef51460e4de2441c8a1017751";
          sha256 = "09bbk2a7pn0j76mmapl583f8a20zqd3a1m9lkml8rpwml692bzi9";
        };
      }
      .${coq.coq-version};

  abp =
    mkContrib "abp"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "492d919510ededf685e57f3b911b1ac43f2d9333";
        sha256 = "18f5vbq6nx9gz2gcj5p7v2gmjczpspc5dmlj6by4jqv07iirzsz2";
      };

  additions = mkContrib "additions" [ "8.6" ] {
    version = "v8.5.0-9-gbec504e";
    rev = "bec504e7822747376159aaa2156cf7453dbbd2b4";
    sha256 = "1vvkqjnqrf6m726krhlm2viza64ha2081xgc5wb9y5sygd0baaz7";
  };

  ails = mkContrib "ails" [ "8.7" ] {
    version = "v8.6.0-1-g1f7e52c";
    rev = "1f7e52cbfe12584787a91bcc641bcaa823e773e3";
    sha256 = "0j7sjkjqdxsr3mkihh41s6bgdy8gj0hw09gijzw2nrjmj6g3s9nk";
  };

  algebra =
    mkContrib "algebra"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-5-gcd1d291";
        rev = "cd1d29115197c9c51d56e0a2e19fce2d0227c567";
        sha256 = "01i8189n94swvwyfnrizh01ym5ijfyb6vbzl052awvhxv8a54j3q";
      };

  amm11262 =
    mkContrib "amm11262"
      [
        "8.5"
        "8.6"
      ]
      {
        version = "v8.5.0-5-gbfa5cdf";
        rev = "bfa5cdf3bd803c40e918ae3a78aeb9c2929432a0";
        sha256 = "1zkbviarvqm228x9rnviad3b0sabpcgarx4z1cks9mfvg1wwyk8n";
      };

  angles =
    mkContrib "angles"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-5-g78715f8";
        rev = "78715f86971007c9e2803215cccee1c5fc9dee87";
        sha256 = "0bgczag5qvmh92wxll0grzcyj52p80z6arx0plbrn6h7m1gywka5";
      };

  area-method =
    mkContrib "area-method"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0-1-gc599734";
        rev = "c599734c0ca9bfcdae7ca436be4a17fda5d55c18";
        sha256 = "111jgxngmpb8sddpmrgr4cgh3p0w3w9jg6pq0x2qwddsq2x55bbq";
      };

  atbr = mkContrib "atbr" [ ] {
    version = "v8.5.0-16-g71ca792";
    rev = "71ca792293153f66a3734c367c23f9dd9ad4bd0f";
    sha256 = "0r01crlf2hclq9wrsrx1by1c3qbncs6rkyn6v4amirdjwlrla4ba";
  };

  automata =
    mkContrib "automata"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-gc3dffb9";
        rev = "c3dffb957dea45ffde679c0d360e869e40396c6c";
        sha256 = "174psnrmjwb7ywn8fs67bjjggq5jw9zrg3d9bpsx5n82bzr2vsnk";
      };

  axiomatic-abp =
    mkContrib "axiomatic-abp"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-5-ge48eb5e";
        rev = "e48eb5ed467da6aa250b4d567478bc63e675783c";
        sha256 = "0g924s0iiwhck5vvh6zcwj1s16g3p637xms2bld504d0nrjwapkx";
      };

  bdds = mkContrib "bdds" [ ] {
    version = "v8.6.0";
    rev = "f952a2f23d710761cf3d7143d543c7d9ed1331cc";
    sha256 = "0wbbg2yvaks1fd9sdbmkwijh9sz9bkbjl1z49wy68hd1bs4d81j9";
  };

  bertrand = mkContrib "bertrand" [ "8.7" ] {
    version = "v8.5.0-9-g11a85bf";
    rev = "11a85bf3bb43c1c0447c65f320891e69f7ab6c04";
    sha256 = "1bkcglyw3r0g06j695nynfmjl60p9jxm13z8zbzwaghcriw33p12";
  };

  buchberger =
    mkContrib "buchberger"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0-1-g926229f";
        rev = "926229fb43125f1c3977ffcf474a7e9d350c7124";
        sha256 = "0c5bd99sdk31la58fkkf67p00gjj5fwi3rhap5bj9rjadmxgdwqr";
      };

  canon-bdds =
    mkContrib "canon-bdds"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g1420af9";
        rev = "1420af91ba2f898b70404a6600c2b87881338a0e";
        sha256 = "0g73z6biv3kn8fr3xsc1qlnflfaa8ljbcrmglg6mdacamphjji42";
      };

  cantor =
    mkContrib "cantor"
      [
        "8.5"
        "8.6"
      ]
      {
        version = "v8.5.0-5-gdbcaa1d";
        rev = "dbcaa1de1eca2bd636e92cb5f78eedc237bb3f7a";
        sha256 = "1wy75wv9w5ny2m359rdymvqc0v5ygi9kbljmiknjpd2m1rm24mc0";
      };

  cats-in-zfc =
    mkContrib "cats-in-zfc"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-9-g2945072";
        rev = "2945072aa6c9c328a019d3128c0a725dabca434c";
        sha256 = "177n0hv3jndwlzhxpfrpiv6ad7254iy7yscrrjjlya4kkfdlvnhh";
      };

  ccs =
    mkContrib "ccs"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g7ec1e98";
        rev = "7ec1e98797f8644dc93a0492a901bd2e0cf7332b";
        sha256 = "1fs3cmbdnmvbaz0ash585brqsvn7fky9vgc5qpahdbj541vrqzd6";
      };

  cfgv =
    mkContrib "cfgv"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "d9f4d58ddf571639217f0ba1706e1141921a693a";
        sha256 = "0gsr498sx3zvspz731q5c9bgv9b9mw9khz3j9ijkbq34gz08n1cb";
      };

  checker =
    mkContrib "checker"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "f8da516722ccf49bc910089e12072c09b926fe50";
        sha256 = "05gwasqj05hz3d34a68ir1mk0mq5swclzy4ijdwnysrzdp5nlw28";
      };

  chinese =
    mkContrib "chinese"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-8-ga30ad2e";
        rev = "a30ad2eb63d5d93c82e2a76b8dd836713637b869";
        sha256 = "0mccfdcgw72rl5mhk3m6s0i8rjym517gczijj7m0nhrask14zg89";
      };

  circuits =
    mkContrib "circuits"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-gf2cec60";
        rev = "f2cec6067f2c58e280c5b460e113d738b387be15";
        sha256 = "05w6dmm4qch327zs4726jiirfyprs21mgwxdc9nlvwnpakpimfcf";
      };

  classical-realizability = mkContrib "classical-realizability" [ "8.6" ] {
    version = "v8.6.0";
    rev = "b7b915583675b85feadd6fbf52cc453211de8e87";
    sha256 = "099fwqjd1621bwy237wv1nln3kcr4mq09wl25z1620r2b467sglh";
  };

  coalgebras =
    mkContrib "coalgebras"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-9-g6544eae";
        rev = "6544eaee5de06d2f520a958d52afedcb83a53735";
        sha256 = "0b15r2ln57mxsyz4fmpfzh4mzrwi604gqh8f471awm63a4xqj5ng";
      };

  coinductive-examples =
    mkContrib "coinductive-examples"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "28b0e273c38fdecd1966e3ca5717ccd1f5871a15";
        sha256 = "11dazllhl7qwhbnxqxpgwy0pf2a8c2aijrs93fzj5inf8z48vxnp";
      };

  coinductive-reals = mkContrib "coinductive-reals" [ ] {
    version = "v8.6.0-9-gf89f884";
    rev = "f89f8848f74294afaa5c0e0e211f6e8e8d1fb36a";
    sha256 = "0svpxflynara7v6vzrvibhyfk9kb5kzdxfzrsvbqyk192dsfkwf7";
  };

  concat =
    mkContrib "concat"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-gb4a9619";
        rev = "b4a96199f0bc447be8fcaa494bcba8d713fd1801";
        sha256 = "1haw5i5rz420jsr2mw699ny3f0gfmdsy0i6mzi48dhpj12ni8rfq";
      };

  constructive-geometry =
    mkContrib "constructive-geometry"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-7-g470ffa3";
        rev = "470ffa3d38eb7f78974693e52d190535e87004c4";
        sha256 = "1ddwzg12pbzpnz3njin4zhpph92kscrbsn3bzds26yj8fp76zc33";
      };

  containers =
    mkContrib "containers"
      [
        "8.6"
        "8.7"
        "8.8"
        "8.9"
      ]
      {
        "8.6" = {
          version = "8.6.0";
          rev = "fa1fec7";
          sha256 = "1ns0swlr8hzb1zc7fsyd3vws1vbq0vvfxcf0lszqnca9c9hfkfy4";
        };
        "8.7" = {
          version = "20180313";
          rev = "77ac16366529c9e558f70ba86f0168a76ca76b8f";
          sha256 = "01gp8injb0knaxgqsdc4x9h8714k7qxg7j5w7y6i45dnpd81ndr4";
        };
        "8.8" = {
          version = "20180330";
          rev = "52b86bed1671321b25fe4d7495558f9f221b12aa";
          sha256 = "0hbnrwdgryr52170cfrlbiymr88jsyxilnpr343vnprqq3zk1xz0";
        };
        "8.9" = {
          version = "20190222";
          rev = "aa33052c1edfc5a65885942a67c2773b5d96f8cc";
          sha256 = "0mjgfdr9bzsch0dlk4vq1frkaig14dqh46r54cv0l15flxapg0iw";
        };
      }
      .${coq.coq-version};

  continuations = mkContrib "continuations" [ ] {
    version = "v8.5.0-13-g6885310";
    rev = "68853104fd7390ba384cd2c63101b0bc4ec50a22";
    sha256 = "1v2lqcj93xlwn9750xga6knyld4xcxma2brh58zmiggkc7wn1dpl";
  };

  coq-in-coq =
    mkContrib "coq-in-coq"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-9-g8d137fc";
        rev = "8d137fc20460561e6fd324466ebb04fd5a86150a";
        sha256 = "0p9rb963ri5c8y1dlnp9307qnymr285dd6k7hir1qmvghybj1ijm";
      };

  coqoban =
    mkContrib "coqoban"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g89758d9";
        rev = "89758d9bf1222155a37171e39ea1d6eec53aabb8";
        sha256 = "02ixil10iw26wkbis62ydnsp2fn4r9jmyh88k2dj7inn0ln30h3q";
      };

  corn = mkContrib "corn" [ ] {
    version = "master";
    rev = "bb962a00c2a737fceb459fac663eecb266289461";
    sha256 = "0xgkbzzsv3lc31lk71zgjvcryn9j51ffij5karln87j2ln989l3q";
  };

  counting = mkContrib "counting" [ ] {
    version = "v8.6.0-2-g2823e75";
    rev = "2823e75408a80a5a8946a11dd0debeb2409942a2";
    sha256 = "0bn8kxyh4hwdn1cvnrlp7g66jagxp8c302hsslz07pfrxkdk1cwy";
  };

  cours-de-coq =
    mkContrib "cours-de-coq"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g8ecccd4";
        rev = "8ecccd4196e303b9adbbd95d3531f3d6e3d0299d";
        sha256 = "1v6wh1ppzw6fcb78wvzxyg5hygssjvp56s9qd0yfsagy915vqyl6";
      };

  ctltctl =
    mkContrib "ctltctl"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g51b7096";
        rev = "51b7096482ac402d8e0ba2eeb932432a2f2489fc";
        sha256 = "1fmpp69pv8130wqhsknnn37xqpc5alqhr41n2vd4r4kj3dj45bj7";
      };

  dblib =
    mkContrib "dblib"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "df86f014dbfb07ec113e8ec4b401b6cc28eb792b";
        sha256 = "0s9y9apainqc4kcldrrkisnw5hnqbz052q2ilb5967b643rac4bb";
      };

  demos =
    mkContrib "demos"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-7-g399f693";
        rev = "399f6930fa7a9909b840d4a017159d0e06616940";
        sha256 = "08a99cwqz7f6438bkz0gf5dw7p61s48whccrpsd6rvhqrl4bg7b2";
      };

  dep-map =
    mkContrib "dep-map"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0-3-g091bb2d";
        rev = "091bb2d7fc86a816a2dafa249610d3fbc5b546fe";
        sha256 = "1vp1nxxa4m8c8bmvllajrqi0ap13i450c2q5kcxyvac1bfv9hf50";
      };

  descente-infinie = mkContrib "descente-infinie" [ ] {
    version = "v8.5.0-16-g7ad3ff6";
    rev = "7ad3ff63d8772d40b5ef415741cffc93f343856e";
    sha256 = "0gpn6cngjlcfi78qj743w7a33fvq1513avjq9cnzhnsdnqnnwv07";
  };

  dictionaries =
    mkContrib "dictionaries"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g545189e";
        rev = "545189ef2f9281135ff870069134bb04bc2e38e5";
        sha256 = "0b0c4vcf5dl7bcgxj1pvdin4jg6py6nr1wqcy3yw8vbd1apnhgri";
      };

  distributed-reference-counting =
    mkContrib "distributed-reference-counting"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-7-gfae0b8a";
        rev = "fae0b8a8e26c19f853996fae318e4e9f8f166c0e";
        sha256 = "153xqfkw5cb24z6h4pj6xaqhxbi20bx4zr60mf5aly390sjd4m7x";
      };

  domain-theory =
    mkContrib "domain-theory"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g8a121a2";
        rev = "8a121a29ddb80964855ec43abbb21df7fccca37b";
        sha256 = "0jpqjy9wi1kkn90fr1x3bf47m2a3p0byk06wza4psw2f40lz94yb";
      };

  ergo = mkContrib "ergo" [ ] {
    version = "v8.6.0-2-gf82bdee";
    rev = "f82bdee58ee2e0edc7515bfd1792063e9e1aea4c";
    sha256 = "0ngwiwcxbylpjyz19zalbz9h3a447iagz4llq9vqdmbcs6qyml2k";
  };

  euclidean-geometry =
    mkContrib "euclidean-geometry"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g280bb19";
        rev = "280bb19b7192275678838fdf4b2045074ec4b3a6";
        sha256 = "05rnpxaa3jbz82j1y1hb1yi5nm1kz46c95nbn1kd4rdm0zn53r9f";
      };

  euler-formula =
    mkContrib "euler-formula"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g078d161";
        rev = "078d16102fc0a28f6a96525703ddd272df0e3ba9";
        sha256 = "1wd6hay32ri91sk8pra6rr5vkyyrxfl2rxdhhw4gzyzsv72njmfd";
      };

  exact-real-arithmetic =
    mkContrib "exact-real-arithmetic"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0-1-g593028e";
        rev = "593028ec7d094c23ed4dbb3990d6442f7d05950e";
        sha256 = "10x7w57mpiwr4640vfa27pbllkls68nfra9nz7ml0fqhi3s3h6pj";
      };

  exceptions =
    mkContrib "exceptions"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-8-gcfe4f0b";
        rev = "cfe4f0bb4f98660fadb9d5a9c8cede9f0e4896e3";
        sha256 = "149j0npyphy60xlgp4ibcwd6qyqminirjac1rwq00882n5gdprw2";
      };

  fairisle =
    mkContrib "fairisle"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g3e7c9b0";
        rev = "3e7c9b0c48cf91307bf64f4b01f3c93c412e1ab8";
        sha256 = "1g1jp6w9sip30fs5j5122z4vh7w7wqm6fhswlhpwygi4n5w1l8b7";
      };

  fermat4 = mkContrib "fermat4" [ "8.7" ] {
    version = "v8.5.0-8-g07e3021";
    rev = "07e3021aec1d97f5827eb6ea6281f11108150811";
    sha256 = "1r89cqxy3qmzcj2lfd8hir0hfiikn1f290801rqad7nwx10wfiq6";
  };

  finger-tree =
    mkContrib "finger-tree"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g67242c8";
        rev = "67242c896707de73405a596bfd9db2036fba98f3";
        sha256 = "02jcp74i5icv92xkq3mcx91786d56622ghgnjiz3b51wfqs6ldic";
      };

  firing-squad = mkContrib "firing-squad" [ "8.6" ] {
    version = "v8.5.0-9-gbe728cd";
    rev = "be728cddbee58088809b51c25425d2a4bdf9b823";
    sha256 = "0i0v5x6lncjasxk22pras3644ff026q8jai45dbimf2fz73312c9";
  };

  float = mkContrib "float" [ "8.7" ] {
    version = "v8.6.0-14-g7699b1e";
    rev = "7699b1e4f492d58e8cfb197692977e705fa6b42b";
    sha256 = "11v2w65xc3806r0pc84vjisp9rwqgmjaz8284q6ky9xd8567yq2z";
  };

  founify =
    mkContrib "founify"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-9-gb7c81b8";
        rev = "b7c81b828a444f6a5e4d53020cf319288838399b";
        sha256 = "0prh5vqn0gmvnm4dfb5vqd8n66d9knpx56vqzf5wsiphk5c7a43r";
      };

  free-groups =
    mkContrib "free-groups"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "b11ffb1437f1b2793d9d434872e80d5a2d387ade";
        sha256 = "12bkigjv3vkkkc4z6m57aim6g10ifvy53y941i0shfmwnvhlkgpc";
      };

  fsets =
    mkContrib "fsets"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-12-g9b51a09";
        rev = "9b51a09e24f4b8b219952f2c06d06405944cd7a0";
        sha256 = "19d2v85mnl29g6alpsbd2cb62xyp7rafryglp046hq9qz520gjzy";
      };

  fssec-model =
    mkContrib "fssec-model"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g2fec0b6";
        rev = "2fec0b646ae4d9fcb932901ef85cc13919d5faf3";
        sha256 = "1ib9gw2h9dv5d4n9bqgb64mxz66mgrwy3766ymja0qfc8wflm3yn";
      };

  functions-in-zfc =
    mkContrib "functions-in-zfc"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "ff58f7af1b4b79bf164d6f7abec6b467dde44050";
        sha256 = "076kdfc01mrqh1cz4zi4nzl9rk6yblclbd7r34fxqwbiwdavwsrr";
      };

  fundamental-arithmetics =
    mkContrib "fundamental-arithmetics"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g8976d4b";
        rev = "8976d4ba6a5c53b7eb25d08921e592d200189431";
        sha256 = "0pqq1y3hhw8k0qidigg9zkpblhasnb56rxq0n5sh2yfw07gbnfzc";
      };

  gc =
    mkContrib "gc"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-gee41f2f";
        rev = "ee41f2fad9fb3bbc2cbf3f90dc440cc31dbd7376";
        sha256 = "0hwlby4sn1p7cky0xz9fmgw50xai3i061y6kqhqy9fn2l2did2sc";
      };

  generic-environments =
    mkContrib "generic-environments"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "48b81bb3b8c2941c8d7ef15f5513bbb7f1821ff8";
        sha256 = "03576kkhn5ml4hpn8s8g0i1fxfibr0yjndk8820s7fxmp9838bkc";
      };

  goedel = mkContrib "goedel" [ ] {
    version = "v8.6.0-1-gc3f922c";
    rev = "c3f922cd5cf2345e1be55ba2ec976afcdc6f4b13";
    sha256 = "1cahlrjr1q38m3qwwxzkzvgvgvqvy3li6rjz3hn4n02jxi5daw2g";
  };

  graph-basics =
    mkContrib "graph-basics"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "1b86d778016d88084df8a38b2a08e42a778fdf64";
        sha256 = "1rslb8ha1dnygwp2q2lx23d8x5wjlq0c2b6vr1hgy4wzvbas2573";
      };

  graphs = mkContrib "graphs" [ ] {
    version = "v8.6.0-4-gdb25c37";
    rev = "db25c37561bd35e946fc6ad7c0a48121086fc47f";
    sha256 = "10f7yq409i6skgnyv6xv7qklkj2kaddnwxpq752avgm7y8dr96nv";
  };

  group-theory =
    mkContrib "group-theory"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-gab6459f";
        rev = "ab6459ff2571529edb0d5c10c13f30b1d9379d71";
        sha256 = "062qixxly5zi22lb00dmspadr4ddsvbdwm05m96gbnycrl2siq09";
      };

  groups =
    mkContrib "groups"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "d02aab5c8559ea604a615d993df3c8e714a1dd12";
        sha256 = "0fvwgk5nf5q86sn5q24k3bxps6f1fcafdd47v56xc49iczpkfrck";
      };

  hardware =
    mkContrib "hardware"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-8-g2e85f0a";
        rev = "2e85f0ae87ca311e2ffaa8bfd273e505ac03802e";
        sha256 = "0vzn4sgvsbglnwydf0yplpa6laqdmdnayizhrazca3qcckkzxzg4";
      };

  hedges =
    mkContrib "hedges"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g301e7f8";
        rev = "301e7f86e0941fe0fa2b5f01f17276cf52be4b06";
        sha256 = "1p42idmm741jx1g7swbkzm1b6mki40xnxkm3ci66mypw19m28142";
      };

  high-school-geometry = mkContrib "high-school-geometry" [ "8.6" ] {
    version = "v8.5.0-7-g40e3f95";
    rev = "40e3f95cbbc756ff4b510e1a998bcbd7e1ff1377";
    sha256 = "1ws57irja9fy1lw6kp6jp5kkn3cb8ws9gixgqvhjpxcfsvgaik0f";
  };

  higman-cf =
    mkContrib "higman-cf"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0-1-g587cc23";
        rev = "587cc23ad61f43664d5ae5e9ee1949d8380a5209";
        sha256 = "0wjvsmjh5vdmjf8raqlccxzm6ibklkbgznjqhwz3ss3x333lhykb";
      };

  higman-nw =
    mkContrib "higman-nw"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0-1-g1e2693c";
        rev = "1e2693c6eeb11a39dfe7fcb24acab7dc1fb3d7f6";
        sha256 = "14z3prrsz8c8s0n85890b45pvl4f986g2hckmk61ql6ns7qbsz84";
      };

  higman-s =
    mkContrib "higman-s"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-7-g0cae3b4";
        rev = "0cae3b45df7a65f49afdb58f182065b939e5d224";
        sha256 = "0s50v57ancmdcnidrz3jnjgm5rydkfhfn4s74cf4i6qvvscq44nj";
      };

  historical-examples =
    mkContrib "historical-examples"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-gf08d49a";
        rev = "f08d49a166f486527f14ad45052f9dd9e2132c00";
        sha256 = "1hym8si742z9rhkini9mbiwfa7mm43xrybfw2gh287hp4pcqcchz";
      };

  hoare-tut =
    mkContrib "hoare-tut"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "73dee531bf19ba9db997dff2f0447e12dc8d07db";
        sha256 = "0apmn8f32hfqgpb21n68gqnxg90lhzrawh2c6h4hpl46z087j2ci";
      };

  huffman =
    mkContrib "huffman"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-9-gcd44991";
        rev = "cd4499144059e5426a5380b70a110cdaafbcf008";
        sha256 = "0hw152g5cwc3286p44g73lcwd6qdr4n4lqgd0wfdpilpmzh2lm67";
      };

  icharate =
    mkContrib "icharate"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g11eb008";
        rev = "11eb008f347e68a824e091ca2224b2138a342b3f";
        sha256 = "03vjcwd5vwhkg1q0zvpz45ayb232hd4q130gx23i039wawgzj66i";
      };

  idxassoc =
    mkContrib "idxassoc"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "57991d3754c1b51067329d4abc7caf657c4d4552";
        sha256 = "1xmrv2lpn5rsdxr8ryq5hkihd1wrzpc9a7cvg0jjq8xss1a2sxwh";
      };

  ieee754 =
    mkContrib "ieee754"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-8-g9764c31";
        rev = "9764c31bae03182ba9ada4cc877f411c11edc02d";
        sha256 = "032axmvq4vv03cckm72m773v5h76s43awn5bpzd305gs8iag7wgk";
      };

  int-map =
    mkContrib "int-map"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "42342f3b4152419faf17c7ac9afd90e337d68637";
        sha256 = "1zxgvg021kakvi5vjvyr0xjmmzyd3zhd8wwm4q276wvmya1fjznr";
      };

  intuitionistic-nuprl = mkContrib "intuitionistic-nuprl" [ "8.6" ] {
    version = "v8.6.0";
    rev = "6279ed83244dc4aec2e23ffb4c87e3f10a50326d";
    sha256 = "1yvlnqwa7ka4a0yg0j7zrzvayhsm1shvsjjawjv552sxc9519aag";
    installFlags = [ "COQBIN=$(out)/lib/coq/${coq.coq-version}/bin/" ]; # hack
  };

  ipc =
    mkContrib "ipc"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0-1-g433ab4f";
        rev = "433ab4f5962b49d3178120d6cc4419e4e9932d18";
        sha256 = "16nprdk2cqck0s8ilfy1cjvs48n4kc2hilv9wzi382d4p8jagh0r";
      };

  izf =
    mkContrib "izf"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-5-g98ae92b";
        rev = "98ae92bfe0589c781160c967259be7354aaf1663";
        sha256 = "131gpi3p3pxv50dzpr3zfzmfr02ymcwja51cs029j9a33mw9rwx0";
      };

  jordan-curve-theorem =
    mkContrib "jordan-curve-theorem"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "906762607c3e05bedd3f9aab002172e34dd1b595";
        sha256 = "1l4pl6rjfzbxnzg32rdcrjl5g889syl6iydiprm8b34blk15ajka";
      };

  jprover = mkContrib "jprover" [ ] {
    version = "v8.5.0-14-g80a9497";
    rev = "80a94974fa4e43be45583409daf9278768abebe0";
    sha256 = "1c5mxnjhd21gzx3yf8gdvgbpwcvklmfxl6qjdynb6dw04lybp8af";
  };

  karatsuba =
    mkContrib "karatsuba"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "144bdc68571154ca669a276d30c16bb30ac80b2f";
        sha256 = "0rp9ihw4d68dd6b21xq6lnxa4vsq5ckdhr07ylskmas74p66ns4f";
      };

  kildall =
    mkContrib "kildall"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-9-g319577b";
        rev = "319577bdd99aec968fc52f474565dd33b88e6bca";
        sha256 = "1r7hw98xs5w21p50423jqancccn2cwjm90wff08yi7ln0s1rphn1";
      };

  lambda =
    mkContrib "lambda"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "577930fe1ee3923dcd3c53793908550a948bcb8f";
        sha256 = "0kmqf5yp4q40wpqncwpd152ysryq2i18rwni4dx2z4d6dir7jidn";
      };

  lambek =
    mkContrib "lambek"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "23be01c773ff33dbd06627b7245098bdd3c4525a";
        sha256 = "013nj7b8hicxw5ipiw0my0ms8biyqpcybnh17a7r0w4i7icsygj9";
      };

  lazy-pcf =
    mkContrib "lazy-pcf"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "c0b19dff7e1beeccaa2b2d220012bffac6b75f99";
        sha256 = "1qkpszdc3rkm74hkm3z6i080hha4l8904kg5z3xxgpwmhrwb56lq";
      };

  lc =
    mkContrib "lc"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-gae9c9f8";
        rev = "ae9c9f878d12539d7b61b91435745ffe32febfd0";
        sha256 = "18bmck6xsp5yi17czyad6iy90c0k65gxjhp47ca64yzcccnzpqbx";
      };

  legacy-field = mkContrib "legacy-field" [ ] {
    version = "v8.6.0-7-g7f400f7";
    rev = "7f400f787459dc63ff1bb862efe8aea41abe90fe";
    sha256 = "0889z8s2rcccl1xckc49r904xpdsa9sdf5dl2v9a2zqx37qcn6cd";
  };

  legacy-ring = mkContrib "legacy-ring" [ ] {
    version = "v8.6.0-4-g3e6c0cf";
    rev = "3e6c0cfeb69189278699e176e2f19fef5e738857";
    sha256 = "15a8rvhr2zw17j7d6w3hd0fxpr6kqy5flpngdqdjij99srm7xzsq";
  };

  lemma-overloading = mkContrib "lemma-overloading" [ ] {
    version = "v8.6.0";
    rev = "6112c139add4d81b9e4d555268a60865f9323151";
    sha256 = "0m1i5xdmwfz4saacay7p6skqnw42csn473gisl24am9jls301cfh";
  };

  lesniewski-mereology =
    mkContrib "lesniewski-mereology"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "eeaf56daa0b0bb0fe16368a5e79a089b42d3951c";
        sha256 = "0j4r83biz128pl6g9z5c3x2p5h465ch4fz2jszbr2k1yd8b2gkd9";
      };

  lin-alg = mkContrib "lin-alg" [ ] {
    version = "v8.6.0-5-g74833da";
    rev = "74833da8a93b1c4c921d4aaebbc9f7c2a096a5eb";
    sha256 = "08r9zdq9fxf0b2fxfxb36zywgqd04wpb25l408q3djmq22k56azp";
  };

  ltl =
    mkContrib "ltl"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g53e5fc4";
        rev = "53e5fc475fbcce767e2193f92896bd871f7eb1d5";
        sha256 = "0aprimbywsnlg3zzxrg3kp1hw30swz95zcwa2gfidr381isnqciz";
      };

  maple-mode = mkContrib "maple-mode" [ ] {
    version = "v8.5.0-22-gb97a515";
    rev = "b97a5155464360778b215c22668ab80c96a42332";
    sha256 = "15wk6k8m2ff4b5cnqrsccq5vyabam2qaa6q4bvk4cj1nfg0ykg5r";
  };

  markov = mkContrib "markov" [ "8.7" ] {
    version = "v8.5.0-7-ge54c9a8";
    rev = "e54c9a86df5cb90ef6ea04d3753273186bb2d906";
    sha256 = "19csz50846gvfwmhhc37nmlvf70g53cpb1kpmcnjlj82y8r63ajz";
  };

  maths =
    mkContrib "maths"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "75a2f84990c1dc83a18ee7decc1445c122664222";
        sha256 = "0yj26mnsfk8y92pd575d9nv9r6pm23zaws18r690s9rjm4kzmwww";
      };

  matrices =
    mkContrib "matrices"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g5553a1f";
        rev = "5553a1f7838bafd485e9868c6ad3f76be4c7ffb8";
        sha256 = "0ppw2v404sbvc3d36wi701bwxfxha1ziciyddhzbqw62s5xkhzjc";
      };

  micromega =
    mkContrib "micromega"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0-1-ga70bf64";
        rev = "a70bf64b99462a77cd9181e3f2836bc1fed04593";
        sha256 = "0zvqb56il139xgj7n2arvqd305374jb1ahwg63mpf9cqla1m0fxs";
      };

  mini-compiler =
    mkContrib "mini-compiler"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "5c0b9da5aabc590c28b7d5a9f49e5a9483b742e1";
        sha256 = "02jpwvk0lsws886bsgahsjmmra25r7b6bn19qmizjjrc0pj44q58";
      };

  minic =
    mkContrib "minic"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-7-g0b2e050";
        rev = "0b2e05096f83b08dd935f42501d408bebce01170";
        sha256 = "1wyrshkmkdpkpc47iy2cw9wxadpd1hchr4ilpmifs4rny4y6kkhp";
      };

  miniml =
    mkContrib "miniml"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "22a570e57f9e8d1b971d0a7a9e6fdd8d3f053b44";
        sha256 = "17syhr7qyr2naqm7mgarn39d6lrrwah3a6m4mzsvm8d9mwvdqhzs";
      };

  mod-red =
    mkContrib "mod-red"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g963c2c9";
        rev = "963c2c930175c91ebcd0cd39ef841ff752ad0813";
        sha256 = "18nlgiypcykhnn9vbgy1bv0zz4ibvzw3jhigl3k9aa3672qr2bwl";
      };

  multiplier =
    mkContrib "multiplier"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-10-g127feee";
        rev = "127feeebe065d4698e427cbbcd0ddd8c70fc8bb7";
        sha256 = "08lvs0651yccvxn3mw3sf7d1cdbnf4jvwwc3p57124nvjig649a7";
      };

  mutual-exclusion =
    mkContrib "mutual-exclusion"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-9-g6f54d7f";
        rev = "6f54d7f25d9056bf72932c2acd53b832ba015eda";
        sha256 = "066z3ijlni6h39l6g2phs1vqv460x07cri64f847jykchcdjizil";
      };

  nfix = mkContrib "nfix" [ ] {
    version = "v8.6.0-2-gcaeda20";
    rev = "caeda20f3ce3dea0bc647419f3b284e5656cf4ae";
    sha256 = "0s5adpbjm4pxjvnmj24xwxmbg1c356lali0v1v9rcl5lv9fsfi64";
  };

  orb-stab = mkContrib "orb-stab" [ ] {
    version = "v8.6.0-4-ga0a5520";
    rev = "a0a552020eae39e4fd0512c3714ef1b6f8da584c";
    sha256 = "074ygyskvkzwlhqrpyhivxj1axjh3y8wdd57mnjxsf3c103dvajf";
  };

  otway-rees =
    mkContrib "otway-rees"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-gf295926";
        rev = "f29592659199f79aa5d3b2fa61a35abba7db5183";
        sha256 = "1yczckkchz3xlb9jcv3rkj5z831b0xrv9j0yvslkl6kpgi1br8af";
      };

  paco =
    mkContrib "paco"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "abe297080621c05b3f829a82b36b84f2fc7b5340";
        sha256 = "1jpvkhhnkn8ikj3x7knzr0f8qqrw1ipa8h3mw9bd62kjlmg0f8fj";
      };

  paradoxes =
    mkContrib "paradoxes"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-8-g2da6f5f";
        rev = "2da6f5fd4a560f5726dc6083abf2b624391b6d3b";
        sha256 = "1xmhvfbhwn1rfcchb4wq0jlqdrswv1rapxmshjzgkwryq7a7bf64";
      };

  param-pi =
    mkContrib "param-pi"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-gba4d052";
        rev = "ba4d052f64788004cb7d8ee172d8c8f58f3a8429";
        sha256 = "04v2fd56x8vd1fv89c3a4vhbhlflnzfzybr7z2fkraxnz5ic1xa4";
      };

  pautomata =
    mkContrib "pautomata"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0-1-g0cb5e83";
        rev = "0cb5e83f2829d25e99628b1c771efbf0c9dc3d84";
        sha256 = "09r9vdyc87ysciff3rfi4awpd432gblysjcsi42k8n03xhgjm1rv";
      };

  persistent-union-find =
    mkContrib "persistent-union-find"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "62c2fac131b87d273c6278fe5bcba0e68895aa18";
        sha256 = "0p4zd3mn8nljjch7c3mrmc5n2kcab8fh9xw7f933wqyh695n1zl9";
      };

  pi-calc =
    mkContrib "pi-calc"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-gf8cfa30";
        rev = "f8cfa3027c62719bd944f85d25dcc19b785eb8da";
        sha256 = "12i76ky3x0agd2wzxdsnfxpm7ynp3nj0i7s3skpjnf6rblzgnljf";
      };

  pocklington =
    mkContrib "pocklington"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-gc71f839";
        rev = "c71f83920538781a6be99c8ef8a2a306b66e7800";
        sha256 = "0nsavl8v4ndxbrbi160zwpiaw865z22mr638pwgq4pa9qqbbs2p4";
      };

  presburger = mkContrib "presburger" [ ] {
    version = "v8.6.0-2-g6b473eb";
    rev = "6b473ebcab49ac0c0952c27f8a83fb1f7d21cb1a";
    sha256 = "18r76vv7wclv4nzhypncdx4j68dpc0jf0m7p3c8585ca2l72nyfl";
  };

  prfx =
    mkContrib "prfx"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g719a3ec";
        rev = "719a3ec175aabb2e3ad92dc030ce2e0d2131e325";
        sha256 = "15vz731apciybn6nqb0fsxrwlxpyrfcakdva38hwxmjx6qskqkhi";
      };

  projective-geometry =
    mkContrib "projective-geometry"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-9-g118b0cc";
        rev = "118b0cc37aa97b5de97539cb824a8234f88e123a";
        sha256 = "0fahqagh2il96q160mnwyk6xqjn5wbmy5ckmb5b0yhljs8y181zz";
      };

  propcalc =
    mkContrib "propcalc"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "b68586c079a71ebab3235a636e50c083b23d4f25";
        sha256 = "005vqr0c85ld14ff3cz7nnbgy5m5km7ndgblb041f87l8486dbpz";
      };

  pts =
    mkContrib "pts"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-9-g10a0c39";
        rev = "10a0c39b7e62f8a7ec2afbbe516a21289d065be5";
        sha256 = "14nqxjqg7v6f70zwi13a1iz70vxq4gfsz7aviggj7cbbky9s1lw3";
      };

  ptsatr =
    mkContrib "ptsatr"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "e57ad4552055340ea97bc6a2c61b837c56c11a7d";
        sha256 = "1ivqrvk7dhk52llxi6vxby0zyz05kgc82fgvvkv8f9gmy485v3m7";
      };

  ptsf = mkContrib "ptsf" [ ] {
    version = "v8.6.0-1-g2a303f4";
    rev = "2a303f4e83ef54fc6f8fbc374eaebf05e1e9b5e4";
    sha256 = "0p7dwsf2s72ndgkwf8mj4n8sy1b5anfspj0v8rndvyqsmld7if2g";
  };

  qarith =
    mkContrib "qarith"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0-1-g5255d8f";
        rev = "5255d8fbb28b85424d0fe626125a70cc2f5abcde";
        sha256 = "1rx70f3pnkj30ql97wdp4bimbb2pazbm7xgs5q0g5i3xbiyv50lk";
      };

  qarith-stern-brocot = mkContrib "qarith-stern-brocot" [ "8.7" ] {
    version = "v8.6.0-4-gcad3819";
    rev = "cad381906c9c5b17e701005f3c4290765abc9099";
    sha256 = "0bzczqa61cs9443gapm8y8137d9savxnadwwrkcynhmj1ljx26xy";
  };

  quicksort-complexity =
    mkContrib "quicksort-complexity"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-9-gb897466";
        rev = "b8974665b0de3e9b135291a699e98ed52cd335d1";
        sha256 = "038gyjc6afyb31cfi4fiajzl7a8ykh7dmkajn9dm7rh4md1x6jjf";
      };

  railroad-crossing =
    mkContrib "railroad-crossing"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g2ef67f5";
        rev = "2ef67f5c586a58cd79a8ee0eb22590182374135d";
        sha256 = "0cdk5b6br317xh0ivpj3ffqcy19w2g7sfa5rrv4ls0hmsrrzpxkp";
      };

  ramsey =
    mkContrib "ramsey"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g2821213";
        rev = "2821213706faa7f06823001ce9e58ecff0cd3191";
        sha256 = "1pw2yqkllkvllzs4dyzvyv27mh53qi8wpzh1cr53cwyg6573h0dz";
      };

  random =
    mkContrib "random"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0-1-gf87a8a7";
        rev = "f87a8a77f420df4a12c4a7e4f28ff088e62b4175";
        sha256 = "05xc59frgcmfx7g72i02g3x17zhdlgpap7y6q1gd29xnmrhqnhni";
      };

  rational = mkContrib "rational" [ ] {
    version = "v8.6.0-2-ga12ef65";
    rev = "a12ef65ddd267b4d61e234da4fab17bc12202c17";
    sha256 = "06s3bpm1v7bz69qp3m58kjk5qmdr0d4jgmy20q6qp44mi0341gy7";
  };

  recursive-definition = mkContrib "recursive-definition" [ ] {
    version = "v8.6.0-1-g66b8204";
    rev = "66b820494ed872ef16ff228f78310aab2a47d2be";
    sha256 = "0z6sp1n1m2vbxhb220y3hqi1f24lz6g1nkkq84m9xq2wvg7li6hn";
  };

  reflexive-first-order =
    mkContrib "reflexive-first-order"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g307b421";
        rev = "307b421dd4894ef624e67558087d2f0945ef1970";
        sha256 = "0rwr8sy6v7a17x1g0pa9gbbd9kgrq5lxr6cxv8r926883blz891y";
      };

  regexp =
    mkContrib "regexp"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "da6d250506ea667266282cc7280355d13b27c68d";
        sha256 = "1s1rxrz6yq8j0ykd2ra0g9mj8ky2dvgim2ysjdn5yz514b36mc7x";
      };

  relation-algebra = mkContrib "relation-algebra" [ ] {
    version = "v8.6.0-7-g0d3ca3e";
    rev = "0d3ca3eb5490b2f32d5c2763e2343d373e78baea";
    sha256 = "1kjd23qgmi3qnb4hpn7k5h88psq5rs5bba9s494zhrzkf6cgv9d1";
  };

  relation-extraction = mkContrib "relation-extraction" [ ] {
    version = "v8.6.0-4-g1a604fa";
    rev = "1a604fa2c4211c4c36dd600dab6ed076a04c00ce";
    sha256 = "114idr4n19c5nnzn6wdj5jz82wbisxrbw6qvfjnwh02yz2sbpn2d";
  };

  rem =
    mkContrib "rem"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g306938c";
        rev = "306938c460518695393313f57d47ec8c653add11";
        sha256 = "1cccqj08pmgjdlwgi4r1qz0h9sgr1840zrwc36fzfslhdqixgyd9";
      };

  rsa =
    mkContrib "rsa"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "01dddd705621ad9efbaf081bffa76465b3cdc442";
        sha256 = "1426cyzd1493iwhzb4sm7xpvn5vj10ap9607kh1flhhqdxx4fvgz";
      };

  ruler-compass-geometry =
    mkContrib "ruler-compass-geometry"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-7-g69e66a8";
        rev = "69e66a80590e89c3916359beef4109990b8c92f6";
        sha256 = "01qw8vyaj29frm7zzdn18nwrzcqbjaqhpky5qwlsmxlza5h5vz1c";
      };

  schroeder =
    mkContrib "schroeder"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "31df08b6c00fe7d0ac7391f7f939c4869cfe9b8c";
        sha256 = "18gwh3axcbaicmylkjsljiw8q2z02hpcbz6mpvx3zyh1vcgl47qw";
      };

  search-trees =
    mkContrib "search-trees"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-9-g07dee21";
        rev = "07dee215c9453fcd95a0c13d2495f7e260325378";
        sha256 = "19jw1qccn1c7jp78kc6ipr3mpp1fkm3wxb6y7wjgvqqphjy62sfg";
      };

  semantics = mkContrib "semantics" [ ] {
    version = "v8.5.0-8-g8236bf9";
    rev = "8236bf94a7735378b3a49ea376cd220bcadfe831";
    sha256 = "18kmmn7y0nvgszrap2d7dcqkvfrpkk6w6wzf8ji9j8lc8mznyy8h";
  };

  shuffle =
    mkContrib "shuffle"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "681fc1a794cce5d99e748b68586e8c5a11810788";
        sha256 = "121b021b25vkgcw892lbidrhbk7syrz9xxlk3d45gf8pdin8i8zb";
      };

  smc = mkContrib "smc" [ ] {
    version = "v8.6.0-4-g161f8aa";
    rev = "161f8aaaf80f7475f2679c55a8f7ac511215cd4b";
    sha256 = "01375i2n8cw8kdf7zgcz7kmkw6wspmw4ngrzjnq5bxf7ijw7z9qx";
  };

  square-matrices =
    mkContrib "square-matrices"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0-1-g7fe56db";
        rev = "7fe56dbe1a9916236b44cc96d25cee2b90825ae5";
        sha256 = "03lxq8v63gydnm7fcryjpqdywjb3hrfirnxx7sm6zc9yblh2m0il";
      };

  stalmarck = mkContrib "stalmarck" [ ] {
    version = "v8.6.0-3-g083bd20";
    rev = "083bd20af8ce5c646e5cd9845474523027bf7e79";
    sha256 = "0nhbxin98hwam4jb4iadb06b785s88h0mz8i0v6adpprym1my746";
  };

  streams =
    mkContrib "streams"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-7-gd53a1ca";
        rev = "d53a1ca12b2fb5cb9324452aabe36a7e4b3db85c";
        sha256 = "14qk7w675c2flh2qyrzqjywn1f1fcchsqzn59zlh755krssf4y4b";
      };

  string = mkContrib "string" [ ] {
    version = "v8.5.0-9-g861dd5c";
    rev = "861dd5ce2d72a5856a79d1e9e4eb0c4b1070e73c";
    sha256 = "0fq49qdbi2c5i5hkbf6cgx1dyzg02mhr0zd89kgbxa5lpv5sp3y7";
  };

  subst =
    mkContrib "subst"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-5-g9d9fed6";
        rev = "9d9fed67529aa98f5b2d77c695e1370a3c4b7ecf";
        sha256 = "0dqz2wgzsipk9zic6cf3dhqr1a3p5s2d30cjs5312c5pz6gw3fp4";
      };

  sudoku =
    mkContrib "sudoku"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-g4ebe0aa";
        rev = "4ebe0aace3341b14ba6f2177888148345988c43c";
        sha256 = "0srf1477x5q3qb5inlcrc1hr193rdw8sp8c0bw6fw4na0d6bphv3";
      };

  sum-of-two-square =
    mkContrib "sum-of-two-square"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-5-g66c1146";
        rev = "66c11466b499c0f26a9d687933432e16f4aed080";
        sha256 = "0z1h7cq3f15xlm7b0kirf1jv6n43f11in82x6vjiw7arnn1axwh5";
      };

  tait =
    mkContrib "tait"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0-1-g1505eb9";
        rev = "1505eb9e6af0c14892c9fe2bd1021b56dc65c409";
        sha256 = "1662mn9qpym8rq99854ziykk2jrr5s9h5r8j6y4ddgma0ihv1v5w";
      };

  tarski-geometry =
    mkContrib "tarski-geometry"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-gd30cc0e";
        rev = "d30cc0e71e507dc14eb0d5397e8c3a6252fe5d07";
        sha256 = "1hngfix8riqa0kn774602q3kc2m8mfksx1ynb69pq6hy6q3ikn1n";
      };

  three-gap =
    mkContrib "three-gap"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0";
        rev = "b176a7b3165aecd171926271a8d90888f16dc297";
        sha256 = "0mr8s0djs165i64v48k8i7sn832s5ff2hnyqhl9ijsvhcix20ij2";
      };

  topology = mkContrib "topology" [ ] {
    version = "v8.6.0-1-g4e79a75";
    rev = "4e79a755efe0ca509ef589135aa3406449b44dfb";
    sha256 = "00211410zb5z367mv2brqg1d0p50yjy446g7qc69c4kyp6sr80gf";
  };

  tortoise-hare-algorithm =
    mkContrib "tortoise-hare-algorithm"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-6-gb34a87c";
        rev = "b34a87c0b41eb9a72408292a5d714ae8f342a4c5";
        sha256 = "08j6xc65scxzxznhiiapfny2hchl3mcvrsp2mr05snq5hlidlpxv";
      };

  traversable-fincontainer = mkContrib "traversable-fincontainer" [ "8.7" ] {
    version = "v8.6.0-1-g3f1fc68";
    rev = "3f1fc684ea23a69b1e8ab7f1ee139a66278eb2e0";
    sha256 = "0h0vf74lfll7bhb9m1sk3g82y1vaik1fr5r5k69bbjgh0j5bfj50";
  };

  tree-automata = mkContrib "tree-automata" [ ] {
    version = "v8.6.0-1-g34b3eb6";
    rev = "34b3eb6362407040d7a9a3fc0b1c23661e01162a";
    sha256 = "07iwfi6c6a8dq5rdlsppl187qbmbycj7xifm8aa38ygmsh5rcpir";
  };

  tree-diameter =
    mkContrib "tree-diameter"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0-1-g846a232";
        rev = "846a232a07b3cf43d18b694ef4bcbe4b270e9cd4";
        sha256 = "0i238h60jgqmzkb38qbyjj6i1wzv0bm00g0mwh98wbxlj3pn7ma8";
      };

  weak-up-to =
    mkContrib "weak-up-to"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-5-g0893619";
        rev = "0893619b205a30a0f832da8ceef97c2c3f4801f8";
        sha256 = "0mg1628zyb7xyyg4k8zvay2h7wcdlwcx9nyxwpixdp5xhz3s4l9b";
      };

  zchinese =
    mkContrib "zchinese"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.6.0-1-g25d4e21";
        rev = "25d4e21b648f65593f9378cb9f5171dcc4641223";
        sha256 = "06phig9yh4rqqpqjbzk6704n44vz31irnwvprbdvyzgiyi2bkahk";
      };

  zf =
    mkContrib "zf"
      [
        "8.5"
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-4-gcf33d92";
        rev = "cf33d92b69865af97d93946337f291cffc1e8a9e";
        sha256 = "0fp3vdl79c8d759qjhk42rjfpkd0ba4pcw572f5gxn28kfwz3rrj";
      };

  zfc =
    mkContrib "zfc"
      [
        "8.5"
        "8.6"
        "8.7"
        "8.8"
      ]
      {
        version = "v8.5.0-5-gbba3259";
        rev = "bba325933370fea64780b1afa2fad54c1b567819";
        sha256 = "0iwkpmc22nwasrk4g7ki4s5y05zjs7kmqk3j98giwp2wiavhgapn";
      };

  zorns-lemma =
    mkContrib "zorns-lemma"
      [
        "8.10"
        "8.11"
      ]
      {
        version = "v8.11.0";
        rev = "a573b50fff994f996b8e15dec2079490a5233dc6";
        sha256 = "0jbp1ay6abal66glbablbqsh5hzgd5fv81dc1vzn65jw0iiznxyq";
      };

  zsearch-trees =
    mkContrib "zsearch-trees"
      [
        "8.6"
        "8.7"
      ]
      {
        version = "v8.5.0-7-ga9f6d9a";
        rev = "a9f6d9a8b6e567e749b1470c6879df560dab7f43";
        sha256 = "1001bnh5hzx0rnwhlx7qci52rqi49z5ij7p9gcdr4w86i182w6rg";
      };
}
