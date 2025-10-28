{
  fluent-logger = {
    dependencies = [ "msgpack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qlc1gw0jnb86mc43cxhh0iflqwj5dds0v3k75g5my2h7wi4vzib";
      type = "gem";
    };
    version = "0.9.1";
  };
  hirb = {
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mzch3c2lvmf8gskgzlx6j53d10j42ir6ik2dkrl27sblhy76cji";
      type = "gem";
    };
    version = "0.7.3";
  };
  httpclient = {
    dependencies = [ "mutex_m" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1j4qwj1nv66v3n9s4xqf64x2galvjm630bwa5xngicllwic5jr2b";
      type = "gem";
    };
    version = "2.9.0";
  };
  msgpack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cnpnbn2yivj9gxkh8mjklbgnpx6nf7b8j2hky01dl0040hy0k76";
      type = "gem";
    };
    version = "1.8.0";
  };
  mutex_m = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0l875dw0lk7b2ywa54l0wjcggs94vb7gs8khfw9li75n2sn09jyg";
      type = "gem";
    };
    version = "0.3.0";
  };
  parallel = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0055br0mibnqz0j8wvy20zry548dhkakws681bhj3ycb972awkzd";
      type = "gem";
    };
    version = "1.20.1";
  };
  rexml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jmbf6lf7pcyacpb939xjjpn1f84c3nw83dy3p1lwjx0l2ljfif7";
      type = "gem";
    };
    version = "3.4.1";
  };
  ruby-progressbar = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cwvyb7j47m7wihpfaq7rc47zwwx9k4v7iqd9s1xch5nm53rrz40";
      type = "gem";
    };
    version = "1.13.0";
  };
  rubyzip = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qxc2zxwwipm6kviiar4gfhcakpx1jdcs89v6lvzivn5hq1xk78l";
      type = "gem";
    };
    version = "1.3.0";
  };
  td = {
    dependencies = [
      "hirb"
      "msgpack"
      "parallel"
      "rexml"
      "ruby-progressbar"
      "rubyzip"
      "td-client"
      "td-logger"
      "yajl-ruby"
      "zip-zip"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lg192z9yn0svqi57wqr5yh73b1my5jq6i1x548qd4mb5adgis72";
      type = "gem";
    };
    version = "0.17.1";
  };
  td-client = {
    dependencies = [
      "httpclient"
      "msgpack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "080dvxd66jaxprdlqcb24c5bk13shvvvk96glxf4ia5jnl5igz07";
      type = "gem";
    };
    version = "1.0.8";
  };
  td-logger = {
    dependencies = [
      "fluent-logger"
      "msgpack"
      "td-client"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12mpw8qcghbvzvhmfwq6l0ny1h9n5w2p450mcimfgk2z32a3g43v";
      type = "gem";
    };
    version = "0.3.28";
  };
  yajl-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lni4jbyrlph7sz8y49q84pb0sbj82lgwvnjnsiv01xf26f4v5wc";
      type = "gem";
    };
    version = "1.4.3";
  };
  zip-zip = {
    dependencies = [ "rubyzip" ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ny3zv1sn9wasamykfkg7b7xgs6w7k5fy8kggiyjj9vrwfzzavqg";
      type = "gem";
    };
    version = "0.3";
  };
}
