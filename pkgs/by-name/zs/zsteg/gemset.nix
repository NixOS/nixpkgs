{
  forwardable = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b5g1i3xdvmxxpq4qp0z4v78ivqnazz26w110fh4cvzsdayz8zgi";
      type = "gem";
    };
    version = "1.3.3";
  };
  iostruct = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pswyhjz9d90bympsz6s0rgv24b8nrd4lk5y16kz67vdw6vbaqbp";
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
      sha256 = "1qsk9q2n4yb80f5mwslxzfzm2ckar25grghk95cj7sbc1p2k3w5s";
      type = "gem";
    };
    version = "0.1.3";
  };
  rainbow = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0smwg4mii0fm38pyb5fddbmrdpifwv22zv3d3px2xx497am93503";
      type = "gem";
    };
    version = "3.1.1";
  };
  singleton = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0y2pc7lr979pab5n5lvk3jhsi99fhskl5f2s6004v8sabz51psl3";
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
      sha256 = "0xyr7ipgls7wci1gnsz340idm69jls0gind0q4f63ccjwgzsfkqw";
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
      sha256 = "128kbv9vsi288mj17zwvc45ijpzf3p116vk9kcvkz978hz0n6spm";
      type = "gem";
    };
    version = "0.2.13";
  };
}
