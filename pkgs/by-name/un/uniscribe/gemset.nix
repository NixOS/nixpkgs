{
  characteristics = {
    dependencies = [ "unicode-categories" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1xqqdfpmnsx9q866y4wjf64giz0lr7dm8sqfbdqq3vmjkzlvsgzc";
      type = "gem";
    };
    version = "1.8.0";
  };
  paint = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1r9vx3wcx0x2xqlh6zqc81wcsn9qjw3xprcsv5drsq9q80z64z9j";
      type = "gem";
    };
    version = "2.3.0";
  };
  rationalist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zydr81pc63m7i5f5s51ryksv3g2qya5pd42s09v9ixk3fddpxgi";
      type = "gem";
    };
    version = "2.0.1";
  };
  symbolify = {
    dependencies = [ "characteristics" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0l99q8ahdkzc5z6lfn0gfann7s9gqgc8i1bzh371dmg00hbypbk0";
      type = "gem";
    };
    version = "1.4.1";
  };
  unicode-categories = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "134zc7bzxyy26l4pqsvxrmldcazh11ya1q6fjxnlv4rd2r1v8czz";
      type = "gem";
    };
    version = "1.11.0";
  };
  unicode-display_width = {
    dependencies = [ "unicode-emoji" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hiwhnqpq271xqari6mg996fgjps42sffm9cpk6ljn8sd2srdp8c";
      type = "gem";
    };
    version = "3.2.0";
  };
  unicode-emoji = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03zqn207zypycbz5m9mn7ym763wgpk7hcqbkpx02wrbm1wank7ji";
      type = "gem";
    };
    version = "4.2.0";
  };
  unicode-name = {
    dependencies = [ "unicode-types" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1pfvpq5v2pf164sfafx764rby3spg202wisws258qx03npgdql5k";
      type = "gem";
    };
    version = "1.14.0";
  };
  unicode-sequence_name = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kg1gw4wvp39whkc4p1fbfysljvms4nbyjaspbidyxjcf847x7s1";
      type = "gem";
    };
    version = "1.16.0";
  };
  unicode-types = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ybns4spibnw11am52h7bx7bnl9sp7mpw7j7hndsh3r6fc921lc1";
      type = "gem";
    };
    version = "1.11.0";
  };
  unicode-version = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0q2dy0vq6gd4x3lg9h09qv0fvafh7n227kiqbv9a74qiwcqiaxr7";
      type = "gem";
    };
    version = "1.6.0";
  };
  uniscribe = {
    dependencies = [
      "characteristics"
      "paint"
      "rationalist"
      "symbolify"
      "unicode-display_width"
      "unicode-emoji"
      "unicode-name"
      "unicode-sequence_name"
      "unicode-version"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01w3j7spn5qrwzgfin4vbq6z80zdx78p048z50vhr5zwsgryi18d";
      type = "gem";
    };
    version = "1.12.0";
  };
}
