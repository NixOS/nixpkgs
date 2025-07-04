{
  forwardable = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8X30vWr6b0agAyFwI/5XFu+IziYfXEzw7b3u1kcMr6w=";
      type = "gem";
    };
    version = "1.3.3";
  };
  iostruct = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-d2G1tuFtH/OnCb5MSlq2aBGxXwbafH2rXyC19CX0XF8=";
      type = "gem";
    };
    version = "0.5.0";
  };
  prime = {
    dependencies = [
      "forwardable"
      "singleton"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uvAxxQ1s6SNZSRO+/IrIajJRv/udal6LA2h5YgVOU+M=";
      type = "gem";
    };
    version = "0.1.3";
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
  singleton = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-g+obyl9Ko00AMFq4QqeGLqWooRxz02LLUjedlOlhV3g=";
      type = "gem";
    };
    version = "0.3.0";
  };
  zpng = {
    dependencies = [ "rainbow" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HE+n/+OSsWEcwaDZ+ICmMpnaIiDja/tCZPxo+m482Xc=";
      type = "gem";
    };
    version = "0.4.5";
  };
  zsteg = {
    dependencies = [
      "iostruct"
      "prime"
      "zpng"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-9WpjwYfopD83m2luE8Id7l8ZC2Gb/xNkRUhEvdNeE4k=";
      type = "gem";
    };
    version = "0.2.13";
  };
}
