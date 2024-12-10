{
  builder = {
    groups = ["default" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pw3r2lyagsxkm71bf44v5b74f7l9r7di22brbyji9fwz791hya9";
      type = "gem";
    };
    version = "3.3.0";
  };
  diff-lcs = {
    groups = ["default" "development" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1znxccz83m4xgpd239nyqxlifdb7m8rlfayk6s259186nkgj6ci7";
      type = "gem";
    };
    version = "1.5.1";
  };
  diffy = {
    groups = ["default" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19xaz5qmw0kg1rdsjh13vk7674bpcmjy6cnddx1cvl80vgkvjr22";
      type = "gem";
    };
    version = "3.4.3";
  };
  excon = {
    groups = ["default" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00p5fww0bakph4p9skc7ypjqbqc8crnw31nrmpdm8j4rr5kp4jb0";
      type = "gem";
    };
    version = "1.2.2";
  };
  fog-core = {
    dependencies = ["builder" "excon" "formatador" "mime-types"];
    groups = ["default" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rjv4iqr64arxv07bh84zzbr1y081h21592b5zjdrk937al8mq1z";
      type = "gem";
    };
    version = "2.6.0";
  };
  fog-json = {
    dependencies = ["fog-core" "multi_json"];
    groups = ["default" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zj8llzc119zafbmfa4ai3z5s7c4vp9akfs0f9l2piyvcarmlkyx";
      type = "gem";
    };
    version = "1.2.0";
  };
  fog-libvirt = {
    dependencies = ["fog-core" "fog-json" "fog-xml" "json" "ruby-libvirt"];
    groups = ["default" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "036ajdyj4fxnhqf108jgzjkpiknnr6dg7mrapn8jsagqdr2a2k21";
      type = "gem";
    };
    version = "0.13.1";
  };
  fog-xml = {
    dependencies = ["fog-core" "nokogiri"];
    groups = ["default" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vyyb2429xqzys39xyk2r3fal80qqn397aj2kqsjrgg2y6m59i41";
      type = "gem";
    };
    version = "0.1.4";
  };
  formatador = {
    groups = ["default" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l06bv4avphbdmr1y4g0rqlczr38k6r65b3zghrbj2ynyhm3xqjl";
      type = "gem";
    };
    version = "1.1.0";
  };
  json = {
    groups = ["default" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kvbzh8530pp3qf63zvx9hnb708x7plv9wfn5ibns3h3knnvs3kw";
      type = "gem";
    };
    version = "2.9.0";
  };
  logger = {
    groups = ["default" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q9jm4pzqxk92dq9a1y7gjwcw3dcsm1mnsdhi9ms5hw1dpnprzlx";
      type = "gem";
    };
    version = "1.6.2";
  };
  mime-types = {
    dependencies = ["logger" "mime-types-data"];
    groups = ["default" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r34mc3n7sxsbm9mzyzy8m3dvq7pwbryyc8m452axkj0g2axnwbg";
      type = "gem";
    };
    version = "3.6.0";
  };
  mime-types-data = {
    groups = ["default" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a7fq0wn2fdv57dsxfmjyzsjhxprh56k0zg3c4nm9il4s3v0mzig";
      type = "gem";
    };
    version = "3.2024.1203";
  };
  mini_portile2 = {
    groups = ["default" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x8asxl83msn815lwmb2d7q5p29p7drhjv5va0byhk60v9n16iwf";
      type = "gem";
    };
    version = "2.8.8";
  };
  multi_json = {
    groups = ["default" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pb1g1y3dsiahavspyzkdy39j4q377009f6ix0bh1ag4nqw43l0z";
      type = "gem";
    };
    version = "1.15.0";
  };
  nokogiri = {
    dependencies = ["mini_portile2" "racc"];
    groups = ["default" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18ajyy4d16q4ahnrfmj6d6z9ak21mnbn4wblx2vddck3lvwlpkny";
      type = "gem";
    };
    version = "1.16.8";
  };
  parallel = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vy7sjs2pgz4i96v5yk9b7aafbffnvq7nn419fgvw55qlavsnsyq";
      type = "gem";
    };
    version = "1.26.3";
  };
  parallel_tests = {
    dependencies = ["parallel"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04i61bkra454var9dc79ak3yffl13mbqx8xv2rvidx9n7ins9cyn";
      type = "gem";
    };
    version = "4.7.2";
  };
  racc = {
    groups = ["default" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0byn0c9nkahsl93y9ln5bysq4j31q8xkf2ws42swighxd4lnjzsa";
      type = "gem";
    };
    version = "1.8.1";
  };
  rake = {
    groups = ["development" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17850wcwkgi30p7yqh60960ypn7yibacjjha0av78zaxwvd3ijs6";
      type = "gem";
    };
    version = "13.2.1";
  };
  rexml = {
    groups = ["default" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j9p66pmfgxnzp76ksssyfyqqrg7281dyi3xyknl3wwraaw7a66p";
      type = "gem";
    };
    version = "3.3.9";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    groups = ["development" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "001kazj244cb6fbkmh7ap74csbr78717qaskqzqpir1q8xpdmywl";
      type = "gem";
    };
    version = "3.13.2";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["development" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n3cyrhsa75x5wwvskrrqk56jbjgdi2q1zx0irllf0chkgsmlsqf";
      type = "gem";
    };
    version = "3.13.3";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["development" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vxxkb2sf2b36d8ca2nq84kjf85fz4x7wqcvb8r6a5hfxxfk69r3";
      type = "gem";
    };
    version = "3.13.2";
  };
  rspec-support = {
    groups = ["default" "development" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v6v6xvxcpkrrsrv7v1xgf7sl0d71vcfz1cnrjflpf6r7x3a58yf";
      type = "gem";
    };
    version = "3.13.2";
  };
  ruby-libvirt = {
    groups = ["default" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r0igmwr22pi3dkkg1p79hjf8mr178qnz83q8fnaj87x7zk3qfyg";
      type = "gem";
    };
    version = "0.8.4";
  };
  vagrant-libvirt = {
    dependencies = ["diffy" "fog-core" "fog-libvirt" "nokogiri" "rexml" "xml-simple"];
    groups = ["plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "sha256-NMiRjrVQo2Ui9nOJwpDmNJUk+95gsT85pwFMIiw3bwQ=";
      type = "gem";
    };
    version = "0.12.2";
  };
  xml-simple = {
    dependencies = ["rexml"];
    groups = ["default" "plugins"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pb9plyl71mdbjr4kllfy53qx6g68ryxblmnq9dilvy837jk24fj";
      type = "gem";
    };
    version = "1.1.9";
  };
}
