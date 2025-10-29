{
  csv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kmx36jjh2sahd989vcvw74lrlv07dqc3rnxchc5sj2ywqsw3w3g";
      type = "gem";
    };
    version = "3.3.2";
  };
  enumerable-statistics = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cqksgv0cf69cd30kxk2r0lq1y784wn5nvlyabfqilf1vvy6j38y";
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
      sha256 = "0fzpg1zizf19xgfzqw6lmb38xir423wwxb2mjsb3nym6phvn5kli";
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
      sha256 = "1p1vbb7p4h5a4r2rwl64gwv6cmf350grjn97zrpjhvrjih81y3yg";
      type = "gem";
    };
    version = "0.4.6";
  };
}
