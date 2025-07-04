{
  csv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-b/DBNeZeSF0YZN3mwXA7YNNMyeGb7YRSg0oLKKUZvU4=";
      type = "gem";
    };
    version = "3.3.2";
  };
  enumerable-statistics = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Hg1p/N7B0YjdUp5uWywn6PiAKchi9glGY8k4BvbTE7M=";
      type = "gem";
    };
    version = "2.0.8";
  };
  unicode_plot = {
    dependencies = [ "enumerable-statistics" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kc5iN7ymejuWllWszvkQJMeOxqrUcPzd6ym4H3949zs=";
      type = "gem";
    };
    version = "0.0.5";
  };
  youplot = {
    dependencies = [
      "csv"
      "unicode_plot"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zw8fEIwybyhv/idZmR8ow1VmNn/EUJ5FJqpAcs9aO9w=";
      type = "gem";
    };
    version = "0.4.6";
  };
}
