{
  abbrev = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rRtOqq7Uy3ItVoTWOUnkveHTTyqV4g25Ouz+fLrHQkI=";
      type = "gem";
    };
    version = "0.1.2";
  };
  highline = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1j1/Ry+P+qFDclFhrm+waJW1y3Un4LTaxa0eSQLIDLk=";
      type = "gem";
    };
    version = "2.1.0";
  };
  json_pure = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-aod5KbqdT6CAjMw4ZW0bFdE4sqoKoyA37gWr6hNCes4=";
      type = "gem";
    };
    version = "2.8.1";
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
  vimgolf = {
    dependencies = [
      "highline"
      "json_pure"
      "thor"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3mog62fgVYsNdJsT2LLhKn+mSb22g+GkiaRBvSf+DaQ=";
      type = "gem";
    };
    version = "0.5.0";
  };
}
