{
  activesupport = {
    dependencies = ["i18n" "minitest" "thread_safe" "tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wp36wi3r3dscmcr0q6sbz13hr5h911c24ar7zrmmcy7p32ial2i";
      type = "gem";
    };
    version = "4.2.11.3";
  };
  algoliasearch = {
    dependencies = ["httpclient" "json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b3xk42ry6dlsqn379p884zdi4iyra67xh45rwl6vcrwmrnbq7f0";
      type = "gem";
    };
    version = "1.27.2";
  };
  atomos = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17vq6sjyswr5jfzwdccw748kgph6bdw30bakwnn6p8sl4hpv4hvx";
      type = "gem";
    };
    version = "0.1.3";
  };
  CFPropertyList = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1825ll26p28swjiw8n3x2pnh5ygsmg83spf82fnzcjn2p87vc5lf";
      type = "gem";
    };
    version = "3.0.2";
  };
  claide = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kasxsms24fgcdsq680nz99d5lazl9rmz1qkil2y5gbbssx89g0z";
      type = "gem";
    };
    version = "1.0.3";
  };
  cocoapods = {
    dependencies = ["activesupport" "claide" "cocoapods-core" "cocoapods-deintegrate" "cocoapods-downloader" "cocoapods-plugins" "cocoapods-search" "cocoapods-stats" "cocoapods-trunk" "cocoapods-try" "colored2" "escape" "fourflusher" "gh_inspector" "molinillo" "nap" "ruby-macho" "xcodeproj"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zqj1878izp34cn7552q2djs3zd4a5ylyv0af3yxbz34z0qllk60";
      type = "gem";
    };
    version = "1.9.3";
  };
  cocoapods-core = {
    dependencies = ["activesupport" "algoliasearch" "concurrent-ruby" "fuzzy_match" "nap" "netrc" "typhoeus"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sn1561sdhq2bh35pmi9nhq1adjcgdkhxybd9pxcjs75zmqzpz13";
      type = "gem";
    };
    version = "1.9.3";
  };
  cocoapods-deintegrate = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bf524f1za92i6rlr4cr6jm3c4vfjszsdc9lsr6wk5125c76ipzn";
      type = "gem";
    };
    version = "1.0.4";
  };
  cocoapods-downloader = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08vn0pgcyn6w6fq5xjd7szv2h9s5rzl17kyidnd7fl5qdmzc9c54";
      type = "gem";
    };
    version = "1.3.0";
  };
  cocoapods-plugins = {
    dependencies = ["nap"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16na82sfyc8801qs1n22nwq486s4j7yj6rj7fcp8cbxmj371fpbj";
      type = "gem";
    };
    version = "1.0.0";
  };
  cocoapods-search = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02wmy5rbjk29c65zn62bffxv30qs11slql23qx65snkm0vd93mn6";
      type = "gem";
    };
    version = "1.0.0";
  };
  cocoapods-stats = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xhdh5v94p6l612rwrk290nd2hdfx8lbaqfbkmj34md218kilqww";
      type = "gem";
    };
    version = "1.1.0";
  };
  cocoapods-trunk = {
    dependencies = ["nap" "netrc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12c6028bmdwrbqcb49mr5qj1p3vcijnjqbsbzywfx1isp44j9mv5";
      type = "gem";
    };
    version = "1.5.0";
  };
  cocoapods-try = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1znyp625rql37ivb5rk9fk9564cmax8icxfr041ysivpdrn98nql";
      type = "gem";
    };
    version = "1.2.0";
  };
  colored2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jlbqa9q4mvrm73aw9mxh23ygzbjiqwisl32d8szfb5fxvbjng5i";
      type = "gem";
    };
    version = "3.1.2";
  };
  concurrent-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "094387x4yasb797mv07cs3g6f08y56virc2rjcpb1k79rzaj3nhl";
      type = "gem";
    };
    version = "1.1.6";
  };
  escape = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sa1xkfc9jvkwyw1jbz3jhkq0ms1zrvswi6mmfiwcisg5fp497z4";
      type = "gem";
    };
    version = "0.0.4";
  };
  ethon = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gggrgkcq839mamx7a8jbnp2h7x2ykfn34ixwskwb0lzx2ak17g9";
      type = "gem";
    };
    version = "0.12.0";
  };
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10lfhahnnc91v63xpvk65apn61pib086zha3z5sp1xk9acfx12h4";
      type = "gem";
    };
    version = "1.12.2";
  };
  fourflusher = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1afabh3g3gwj0ad53fs62waks815xcckf7pkci76l6vrghffcg8v";
      type = "gem";
    };
    version = "2.3.1";
  };
  fuzzy_match = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19gw1ifsgfrv7xdi6n61658vffgm1867f4xdqfswb2b5h6alzpmm";
      type = "gem";
    };
    version = "2.0.4";
  };
  gh_inspector = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f8r9byajj3bi2c7c5sqrc7m0zrv3nblfcd4782lw5l73cbsgk04";
      type = "gem";
    };
    version = "1.1.3";
  };
  httpclient = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19mxmvghp7ki3klsxwrlwr431li7hm1lczhhj8z4qihl2acy8l99";
      type = "gem";
    };
    version = "2.8.3";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "038qvz7kd3cfxk8bvagqhakx68pfbnmghpdkx7573wbf0maqp9a3";
      type = "gem";
    };
    version = "0.9.5";
  };
  json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nrmw2r4nfxlfgprfgki3hjifgrcrs3l5zvm3ca3gb4743yr25mn";
      type = "gem";
    };
    version = "2.3.0";
  };
  minitest = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09bz9nsznxgaf06cx3b5z71glgl0hdw469gqx3w7bqijgrb55p5g";
      type = "gem";
    };
    version = "5.14.1";
  };
  molinillo = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hh40z1adl4lw16dj4hxgabx4rr28mgqycih1y1d91bwww0jjdg6";
      type = "gem";
    };
    version = "0.6.6";
  };
  nanaimo = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ajfyaqjw3dzykk612yw8sm21savfqy292hgps8h8l4lvxww1lz6";
      type = "gem";
    };
    version = "0.2.6";
  };
  nap = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xm5xssxk5s03wjarpipfm39qmgxsalb46v1prsis14x1xk935ll";
      type = "gem";
    };
    version = "1.1.0";
  };
  netrc = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gzfmcywp1da8nzfqsql2zqi648mfnx6qwkig3cv36n9m0yy676y";
      type = "gem";
    };
    version = "0.11.0";
  };
  ruby-macho = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lhdjn91jkifsy2hzq2hgcm0pp8pbik87m58zmw1ifh6hkp9adjb";
      type = "gem";
    };
    version = "1.4.0";
  };
  thread_safe = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
  };
  typhoeus = {
    dependencies = ["ethon"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m22yrkmbj81rzhlny81j427qdvz57yk5wbcf3km0nf3bl6qiygz";
      type = "gem";
    };
    version = "1.4.0";
  };
  tzinfo = {
    dependencies = ["thread_safe"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i3jh086w1kbdj3k5l60lc3nwbanmzdf8yjj3mlrx9b2gjjxhi9r";
      type = "gem";
    };
    version = "1.2.7";
  };
  xcodeproj = {
    dependencies = ["CFPropertyList" "atomos" "claide" "colored2" "nanaimo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bkk8y6lzd86w9yx72hd1nil3fkk5f0v3il9vm554gzpl6dhc2bi";
      type = "gem";
    };
    version = "1.16.0";
  };
}