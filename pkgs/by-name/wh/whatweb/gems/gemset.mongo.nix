{
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cl2qpvwiffym62z991ynks7imsm87qmgxf0yfsmlwzkgi9qcaa6";
      type = "gem";
    };
    version = "2.8.7";
  };
  base64 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yx9yn47a8lkfcjmigk79fykxvr80r4m1i35q82sxzynpbm7lcr7";
      type = "gem";
    };
    version = "0.3.0";
  };
  bson = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02q695963ix1qcdwy205rwd38mv089z54n2i5n3ih1kad864jz55";
      type = "gem";
    };
    version = "5.1.1";
  };
  getoptlong = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "198vy9dxyzibqdbw9jg8p2ljj9iknkyiqlyl229vz55rjxrz08zx";
      type = "gem";
    };
    version = "0.2.1";
  };
  ipaddr = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wmgwqv6c1kq8cxbxddllnrlh5jjmjw73i1sqbnvq55zzn3l0zyb";
      type = "gem";
    };
    version = "1.2.7";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0s5vklcy2fgdxa9c6da34jbfrqq7xs6mryjglqqb5iilshcg3q82";
      type = "gem";
    };
    version = "2.13.2";
  };
  mongo = {
    dependencies = [
      "base64"
      "bson"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15f96bg3gr3vahwh9vslgfxl3khma21gaqgdj98jc1447w73xlf1";
      type = "gem";
    };
    version = "2.21.3";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1543ap9w3ydhx39ljcd675cdz9cr948x9mp00ab8qvq6118wv9xz";
      type = "gem";
    };
    version = "6.0.2";
  };
  rchardet = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1455yhd1arccrns3ghhvn4dl6gnrf4zn1xxsaa33ffyqrn399216";
      type = "gem";
    };
    version = "1.9.0";
  };
  resolv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "057vj12w6cnzz9kzbnwg17snm9jwr22izrbp9yqv3pnxrr2ybvv1";
      type = "gem";
    };
    version = "0.6.2";
  };
  resolv-replace = {
    dependencies = [ "resolv" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13v8xdmsqlr9822xpcvscnr4b9vzmzhg0l7r6hh4b281baq1jda7";
      type = "gem";
    };
    version = "0.1.1";
  };
}
