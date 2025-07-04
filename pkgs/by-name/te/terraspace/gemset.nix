{
  activesupport = {
    dependencies = [
      "base64"
      "benchmark"
      "bigdecimal"
      "concurrent-ruby"
      "connection_pool"
      "drb"
      "i18n"
      "logger"
      "minitest"
      "securerandom"
      "tzinfo"
      "uri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hWXN26MbkAzcF2gv1m7NAgRB4+7zIKmTAoU5TowHpF4=";
      type = "gem";
    };
    version = "8.0.2";
  };
  aws-eventstream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fiw6Vcpw14YdXTyY5H2qRj7VOcNJyroitIMFuJGVctc=";
      type = "gem";
    };
    version = "1.3.2";
  };
  aws-partitions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1mGCoNJdFUeOs6zNMgaYlPmRVKNOV4+IWt4A7xChRUA=";
      type = "gem";
    };
    version = "1.1107.0";
  };
  aws-sdk-core = {
    dependencies = [
      "aws-eventstream"
      "aws-partitions"
      "aws-sigv4"
      "base64"
      "jmespath"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xheq4/Q7or/p+BnBoxx8nb2j4dGjPHRsI8TcFWOIF6w=";
      type = "gem";
    };
    version = "3.224.0";
  };
  aws-sdk-kms = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RNi1tpznOUzALzD5o1vqBOoSyUe1/+FHFTXupRGTaNc=";
      type = "gem";
    };
    version = "1.101.0";
  };
  aws-sdk-s3 = {
    dependencies = [
      "aws-sdk-core"
      "aws-sdk-kms"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-W3A7iq/CbKTz+Sc2hBLaX0uPdJCbsORlHriv6KoQWAM=";
      type = "gem";
    };
    version = "1.186.1";
  };
  aws-sigv4 = {
    dependencies = [ "aws-eventstream" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UKh5aZGoYjJEQgNq16OVkgVyuEu2zSm5ReXhgA6Nods=";
      type = "gem";
    };
    version = "1.11.0";
  };
  base64 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DyXpshoCoMwM6o75KyBBA105NQlG6HicVistGj2gFQc=";
      type = "gem";
    };
    version = "0.2.0";
  };
  benchmark = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DxL4xJVUXjcQw+TwSA9j8GtMhCzJTOx/M6lW9RgOh0o=";
      type = "gem";
    };
    version = "0.4.0";
  };
  bigdecimal = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L/x0IDFSGtacLfyBWpjkJqIwo9Iq6sGZWCanXav62Mw=";
      type = "gem";
    };
    version = "3.1.9";
  };
  cli-format = {
    dependencies = [
      "activesupport"
      "text-table"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-o0JdUnNS0UGLIqEo8+g5ndJMXFnXfP7CY7QVkctkMmc=";
      type = "gem";
    };
    version = "0.6.1";
  };
  concurrent-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gTs+N6ym3yoho7nx1Jf4y6skorlMqzJb/+Ze4PbL68Y=";
      type = "gem";
    };
    version = "1.3.5";
  };
  connection_pool = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-z9dKgrmwlNHOMMTxo0baI+4Z3IoGKhaoX1jqsc7UMFs=";
      type = "gem";
    };
    version = "2.5.3";
  };
  deep_merge = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-g87To9f5X2felY0s5BsYdOg8jZT+Ldv/UMi0uCMjVjo=";
      type = "gem";
    };
    version = "1.2.2";
  };
  diff-lcs = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-muDSy6fU3zB1/ozYYCqGBJk+/A36k0z/Volp77GQmWI=";
      type = "gem";
    };
    version = "1.6.2";
  };
  dotenv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nhF2BgztWB+ObOQ4TpE2GBd2OnbjxiXIvdwYs1vTksM=";
      type = "gem";
    };
    version = "3.1.8";
  };
  drb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CwDW/bUJlf5KRd6hNmNJPIQREuQGhlaFRkb0GP2hM3M=";
      type = "gem";
    };
    version = "2.2.3";
  };
  dsl_evaluator = {
    dependencies = [
      "activesupport"
      "memoist"
      "rainbow"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XcAfmUHhxRSisFADDbp150osECw3MS6Y9+4WpVY6oEE=";
      type = "gem";
    };
    version = "0.3.2";
  };
  eventmachine = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mUAW5CqgQUd7qc/0XL5Q3iBH8l3UGOugA+hPDRZWCXI=";
      type = "gem";
    };
    version = "1.2.7";
  };
  eventmachine-tail = {
    dependencies = [ "eventmachine" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DHDr0+MzIzcfw6cIlMEtwC1JVs/U/O7lis9kZ+vxtHQ=";
      type = "gem";
    };
    version = "0.6.5";
  };
  graph = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZCLc6hygJgGoMc9ey0Hsggnq8D3MrWShTNjZRJ/Umq8=";
      type = "gem";
    };
    version = "2.11.1";
  };
  hcl_parser = {
    dependencies = [ "rhcl" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Up5ahNbvt79bGin6PA5HeH/PEVZlgegAn/2g4FMspSU=";
      type = "gem";
    };
    version = "0.2.2";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zrpXP4E4/ywJFUJ/H8W99Ko6uK6IyM4lXrPs8KEaXQ8=";
      type = "gem";
    };
    version = "1.14.7";
  };
  jmespath = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-I413SlhyPWwJBJTIh5temRjBlIX36EDywcdTLPhOvLE=";
      type = "gem";
    };
    version = "1.6.2";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GW7ex8xEtmz7QPl1XOEbOS8h95Z2lq8V0nTd5+3/AgM=";
      type = "gem";
    };
    version = "1.7.0";
  };
  memoist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pSxTo/JbWHUVFnCy8/1EOIYzSG3A8J+acVDq0eO/PEU=";
      type = "gem";
    };
    version = "0.16.2";
  };
  mini_portile2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DNfH+CTgEMBy4z9ovALYWgCutvzgW7SBnAPf08FAwok=";
      type = "gem";
    };
    version = "2.8.9";
  };
  minitest = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ORtsbLQ6SAK/t8k68evirGaiECk/Sj+32zby/H3Cx1Y=";
      type = "gem";
    };
    version = "5.25.5";
  };
  nokogiri = {
    dependencies = [
      "mini_portile2"
      "racc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jHRkh12cp/cQgMJMDbe8qjlA6L48b8S868z4uaABY2U=";
      type = "gem";
    };
    version = "1.18.8";
  };
  racc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Sn9pKWkdvsi1IJoLNzvCYUiCtV/F0uRHohqqaRMD1i8=";
      type = "gem";
    };
    version = "1.8.1";
  };
  rainbow = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-A5SRqjqJ9C76HW3sL8TmLt6W62rNleUvGtWBGCt5vGo=";
      type = "gem";
    };
    version = "3.1.1";
  };
  render_me_pretty = {
    dependencies = [
      "activesupport"
      "rainbow"
      "tilt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-wpZTWXFhgAtS4HFYpNz4my+4JG5qruixX4LxCZJdUAQ=";
      type = "gem";
    };
    version = "1.0.0";
  };
  rexml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-x0UnqaCgS07DHb4NxO1gBLlgr5Q9jbQuU57d46hxq8o=";
      type = "gem";
    };
    version = "3.4.1";
  };
  rhcl = {
    dependencies = [ "deep_merge" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZCALaQyJrimeiLiQ32NYYFLhuQtX7uwythUNkny6/bA=";
      type = "gem";
    };
    version = "0.1.0";
  };
  rspec = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1JCRSsHVpaZKDhQAwdVN3SpQEyTXA7jP6D9Fgze6uZM=";
      type = "gem";
    };
    version = "3.13.0";
  };
  rspec-core = {
    dependencies = [ "rspec-support" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JRNlB/T5zy6Jd6KFHmTkOLQzFkYFTjRZmHFBCHRc3+Q=";
      type = "gem";
    };
    version = "3.13.3";
  };
  rspec-expectations = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TkNFl2Xf7pALJaoTYeEGqweZiV7eZfxXhyBp/rVZ7Ng=";
      type = "gem";
    };
    version = "3.13.4";
  };
  rspec-mocks = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-a7FYoHGcU9UiEE7TTAd3uISyydx3XOZOqhAgffAquZM=";
      type = "gem";
    };
    version = "3.13.4";
  };
  rspec-support = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KmHjk/bhi3Iocm4MaGnF1aFBnTcgYRbE2RfRRSdrP0M=";
      type = "gem";
    };
    version = "3.13.3";
  };
  rspec-terraspace = {
    dependencies = [
      "activesupport"
      "memoist"
      "rainbow"
      "rspec"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HhW4pBdWnhprxERt/asgv+pR5wN4e3MFLi2EtquiDeE=";
      type = "gem";
    };
    version = "0.3.3";
  };
  rubyzip = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hXfIjtwf3ok165EGTFyxrvmtVJS5QM8Zx3Xugz4HVhU=";
      type = "gem";
    };
    version = "2.4.1";
  };
  securerandom = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zFGT1BSkNBtuIl8MtERqzsqOUNXhiIdD+sFph2OOoLE=";
      type = "gem";
    };
    version = "0.4.1";
  };
  terraspace = {
    dependencies = [
      "activesupport"
      "cli-format"
      "deep_merge"
      "dotenv"
      "dsl_evaluator"
      "eventmachine-tail"
      "graph"
      "hcl_parser"
      "memoist"
      "rainbow"
      "render_me_pretty"
      "rexml"
      "rspec-terraspace"
      "terraspace-bundler"
      "thor"
      "tty-tree"
      "zeitwerk"
      "zip_folder"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3UA86quj9YTBbBxAjtKkbqS5WIxoVafYKEQy7sK5tv4=";
      type = "gem";
    };
    version = "2.2.17";
  };
  terraspace-bundler = {
    dependencies = [
      "activesupport"
      "aws-sdk-s3"
      "dsl_evaluator"
      "memoist"
      "nokogiri"
      "rainbow"
      "rubyzip"
      "thor"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3VoENGT5AL4He3jj8W0ohpcU2+LyEiktoYhT/I+Oxk4=";
      type = "gem";
    };
    version = "0.5.0";
  };
  text-table = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kiTbMSJLYVHf0yN+UdkTpEGxffyZmlgndMC6RJal0Bs=";
      type = "gem";
    };
    version = "1.2.4";
  };
  thor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7vApO54kFYzK16s4Oug1NLetTtmcCflvGmsDZVCrvto=";
      type = "gem";
    };
    version = "1.3.2";
  };
  tilt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Jj10hGbg2D5RCqGi4ige/1R5N/DvBr4z02MnIeJV92s=";
      type = "gem";
    };
    version = "2.6.0";
  };
  tty-tree = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+q2cOPvZySqev7ujJkcrn5hpHLQwtaO4Vv+se32CdnA=";
      type = "gem";
    };
    version = "0.4.0";
  };
  tzinfo = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ja+CjMd7z31jsOO9tsqkfiJy3Pr0+/5G+MOp3wh6gps=";
      type = "gem";
    };
    version = "2.0.6";
  };
  uri = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6fIkRgjuove8NX2VTGXJEM4DmcpeGKeikgesIth2cBE=";
      type = "gem";
    };
    version = "1.0.3";
  };
  zeitwerk = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-suhrSptX0mumihUjDcx/5vBA8GgxzmRBewYhrZa6PoU=";
      type = "gem";
    };
    version = "2.7.3";
  };
  zip_folder = {
    dependencies = [ "rubyzip" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ExUKeYjILxpJQlhqR24BAlnmGpxRMnR9qn8d32NQBKE=";
      type = "gem";
    };
    version = "0.1.0";
  };
}
