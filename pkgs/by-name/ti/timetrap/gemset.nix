{
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
  chronic = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dm8vzOasPMFSJJ7Q8rgndw0+UX4uh8X7p+109IidLcM=";
      type = "gem";
    };
    version = "0.10.2";
  };
  mini_portile2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jkcTbNrATOgXULtsCXM7N4lb8GliVU5LQFbXgWjXCnU=";
      type = "gem";
    };
    version = "2.8.8";
  };
  sequel = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-v/lMMccNYftR67oI2uOrWFGpZ1TYNdmgXK7mHKmHuOg=";
      type = "gem";
    };
    version = "5.90.0";
  };
  sqlite3 = {
    dependencies = [ "mini_portile2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+nf2PHCVSPRtTptrtFzaUqo4gaoSzIWZETJ1jolocBw=";
      type = "gem";
    };
    version = "1.7.3";
  };
  timetrap = {
    dependencies = [
      "chronic"
      "sequel"
      "sqlite3"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ovE8PtdfvgfcYrFw8yhkAx6JSVAfz8xj1HbE8PxOmj0=";
      type = "gem";
    };
    version = "1.15.5";
  };
}
