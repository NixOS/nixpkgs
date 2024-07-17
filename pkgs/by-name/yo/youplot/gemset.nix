{
  enumerable-statistics = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dlnfncz0lbyczakgdlys44pksj6h447npj665xk41b36y0lbf7f";
      type = "gem";
    };
    version = "2.0.7";
  };
  unicode_plot = {
    dependencies = [ "enumerable-statistics" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fzpg1zizf19xgfzqw6lmb38xir423wwxb2mjsb3nym6phvn5kli";
      type = "gem";
    };
    version = "0.0.5";
  };
  youplot = {
    dependencies = [ "unicode_plot" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0imy65wjkgdkpqfympbz8lp2ih866538vk55fwz9a909ib9sbdri";
      type = "gem";
    };
    version = "0.4.5";
  };
}
