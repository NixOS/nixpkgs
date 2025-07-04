{
  base64 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DyXpshoCoMwM6o75KyBBA105NQlG6HicVistGj2gFQc=";
      type = "gem";
    };
    version = "0.2.0";
  };
  bcrypt_pbkdf = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L5B33eg30fDdLrD55TJ8aHHGjryOuoiHD7a3lW4eKxM=";
      type = "gem";
    };
    version = "1.1.1";
  };
  bigdecimal = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qJRn7VpE+K4Bgkr0nLxXWHH6B4My6Pd+pCVyXB/+J74=";
      type = "gem";
    };
    version = "3.1.8";
  };
  builder = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SXkY0vncpSj9ykuI2E5O9DhyVtmEuBVOnV0/5anIg18=";
      type = "gem";
    };
    version = "3.3.0";
  };
  childprocess = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NhbOmcyyQjYc5/Kxm/n/PmvB2YuSfH7cKa+Mphe6bNM=";
      type = "gem";
    };
    version = "4.1.0";
  };
  concurrent-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1KqSYzmwqGtbUFSgqMWAFj5vXcvf0PS7kWsaJXBzHDI=";
      type = "gem";
    };
    version = "1.3.4";
  };
  date = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vyaOFO9xWACb/q7EC1+jxycZBuiLGW2VionUtAir5k8=";
      type = "gem";
    };
    version = "3.4.1";
  };
  diff-lcs = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JzIj37QGhVSENtMrRzOqZzUXacfepiHafZ3UgT5j3f4=";
      type = "gem";
    };
    version = "1.5.1";
  };
  ed25519 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UUpVhPhNOdqsVooX7JOk5yYeFAxSxWLtjDgsGEVuYn0=";
      type = "gem";
    };
    version = "1.3.0";
  };
  erubi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/KYbR9rv2GXQ+1DRaGNPJ61AGBhnRFut9kJ8RZwzzWI=";
      type = "gem";
    };
    version = "1.13.0";
  };
  excon = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YElyZ8mZSFTbrdmGwW1miOGF5fWHTZ0ugXeqBTh35QI=";
      type = "gem";
    };
    version = "1.2.2";
  };
  fake_ftp = {
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BJMCyjr60iWb6stZJ+/ntjN4JMYBggcSSp+eTmrCif4=";
      type = "gem";
    };
    version = "0.3.0";
  };
  faraday = {
    dependencies = [
      "faraday-net_http"
      "json"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-I/ISi/XUBTOAazo/BETMohjXbQryUyDbjngr9Crgqm8=";
      type = "gem";
    };
    version = "2.12.1";
  };
  faraday-net_http = {
    dependencies = [ "net-http" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ofHkzWos8hWZyCIVleJ1gtmTaBmXe71AiaYB8kxk5Uo=";
      type = "gem";
    };
    version = "3.4.0";
  };
  ffi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UWMOQ0JQeDEcBWynX5Ybs72hZBqzbkStTEVeCw5KIxw=";
      type = "gem";
    };
    version = "1.17.0";
  };
  google-protobuf = {
    dependencies = [
      "bigdecimal"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Mjq3tqWX2YBvvAYzBiQyo1vizpMhl9uhse/Kdrau9P8=";
      type = "gem";
    };
    version = "4.29.1";
  };
  googleapis-common-protos-types = {
    dependencies = [ "google-protobuf" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lGVdGuufPLLaa1iv+xMVYoUajYm2knP6yEVw9QWz0fc=";
      type = "gem";
    };
    version = "1.16.0";
  };
  grpc = {
    dependencies = [
      "google-protobuf"
      "googleapis-common-protos-types"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7aoRG4zA0yBlBJ96y+63y0bUEmlZphJrNMVUMZNDvXw=";
      type = "gem";
    };
    version = "1.68.1";
  };
  grpc-tools = {
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+xQQXMmmim/FrrGFmyquhh1hvNqFoVvGbobhoA+Oi4s=";
      type = "gem";
    };
    version = "1.68.1";
  };
  gssapi = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xRzzCELuOb2Tzn/DPiBAX/igTNqd7GCSBxthJYKEruE=";
      type = "gem";
    };
    version = "1.3.1";
  };
  gyoku = {
    dependencies = [
      "builder"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OJ2Ic4THd/Jxy5N3u2QvILvgxjPR71r3hWnU21PBos0=";
      type = "gem";
    };
    version = "1.4.0";
  };
  hashicorp-checkpoint = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ta90r9Y8FwGmyBfYfk/Fj1lQN8y8HTArxFzc0/bn1fw=";
      type = "gem";
    };
    version = "0.1.5";
  };
  hashie = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nWxOUfKjbUYWy8ijItYZoWLY9CgVp5JZYDn8lVlWA9o=";
      type = "gem";
    };
    version = "5.0.0";
  };
  httpclient = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KVHkmRIURkw+khB+RkOFJ9IwSOY0867pHHGeC9+uvaY=";
      type = "gem";
    };
    version = "2.8.3";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3CKadPXRgfCZQt1gq11uZn9zksTugm81CW2zbR/jYUw=";
      type = "gem";
    };
    version = "1.14.6";
  };
  ipaddr = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-y39Ah/2/FLztwjrEcbisUhZIs6W0tb46Q3gGZjbmr3I=";
      type = "gem";
    };
    version = "1.2.7";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fA69rZ0DDm1XLNbxtOk9HYGzLEx9/2EcHveCURD8a88=";
      type = "gem";
    };
    version = "2.9.0";
  };
  jwt = {
    dependencies = [ "base64" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Vf0HzN1kxiLTaFl0jyKQ+5wRnOMLSChnUE6fEmVNamU=";
      type = "gem";
    };
    version = "2.9.3";
  };
  listen = {
    dependencies = [
      "rb-fsevent"
      "rb-inotify"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-255EJODlg0SAOFGXwTnLawrg7yjMEzEM/Ryng3fVnGc=";
      type = "gem";
    };
    version = "3.9.0";
  };
  little-plugger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1fNHwA2dZIBA73wX1usJ09Bxmt8ZyjDRo7b7JtCmMbs=";
      type = "gem";
    };
    version = "1.1.4";
  };
  log4r = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-m0UpKMlkt8VMCa6yX/BFtacis4exbJzjfLG67AAGKWY=";
      type = "gem";
    };
    version = "1.1.10";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nf587W2Bw6JrirBpW0PVrA3OuHzHB5VwE2l2/C+pMmE=";
      type = "gem";
    };
    version = "1.6.2";
  };
  logging = {
    dependencies = [
      "little-plugger"
      "multi_json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uoiTo8IRuDb0Exu5Oz6zE3oMOx/NDsPVcOMk2L3ADMs=";
      type = "gem";
    };
    version = "2.4.0";
  };
  mime-types = {
    dependencies = [
      "logger"
      "mime-types-data"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-b3HblXhAzq5EIRUx7/Pi9+DdRkX++19TXbrrYwerZGQ=";
      type = "gem";
    };
    version = "3.6.0";
  };
  mime-types-data = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L/4K9tCExlQtYeN9ME2B+XYo9feyuq7bKbs5YTnA7ig=";
      type = "gem";
    };
    version = "3.2024.1203";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-H9BBOLbkqQAX6NG4BMA5AxOZhm/z+6u3girqNnx4YV0=";
      type = "gem";
    };
    version = "1.15.0";
  };
  multi_xml = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-T84QDGivWI/5G4upCguz8EZvBskJ8hoy9JYgWRQLphs=";
      type = "gem";
    };
    version = "0.7.1";
  };
  net-ftp = {
    dependencies = [
      "net-protocol"
      "time"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KNY+QHp+25c5wyCk+q7FFeQ+ljgVJI0GQYq6MiR4h08=";
      type = "gem";
    };
    version = "0.3.8";
  };
  net-http = {
    dependencies = [ "uri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-liGyDBN4mK+diQVWhIyTYDcWyrUW3CyJsBo4uJTiWfs=";
      type = "gem";
    };
    version = "0.6.0";
  };
  net-protocol = {
    dependencies = [ "timeout" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qnPgy6ahJTad6YN7jY74KmGEk2DroFIZAOLDcTqhYqg=";
      type = "gem";
    };
    version = "0.2.2";
  };
  net-scp = {
    dependencies = [ "net-ssh" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sy3tDUjIjOcIRKBj5OFO+0SpXlGp4MC/sMVLQxO2Iuo=";
      type = "gem";
    };
    version = "4.0.0";
  };
  net-sftp = {
    dependencies = [ "net-ssh" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZbuRyFnC+TsJgmdXrxG2mvkxo6kVUFD1DRsG04RSY2Q=";
      type = "gem";
    };
    version = "4.0.0";
  };
  net-ssh = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-FyB2xLMM5W+yWgOWGwxNoU4SRkJkAbD4nLoaO1S/PvA=";
      type = "gem";
    };
    version = "7.3.0";
  };
  nori = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YWbNM2lZhUdiBz4vuuiIWTgJysGz6QT0+wCTE9ciaGE=";
      type = "gem";
    };
    version = "2.7.1";
  };
  oauth2 = {
    dependencies = [
      "faraday"
      "jwt"
      "multi_xml"
      "rack"
      "snaky_hash"
      "version_gem"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sh+d789S3BYQ4N+rTIaDQhc9zXB/0Vx3fZ9PBOFT9/s=";
      type = "gem";
    };
    version = "2.0.9";
  };
  ostruct = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CaP7fswfpAOfJUGMwFrpyCvVIEcsXGpvUV8D5JiMuBc=";
      type = "gem";
    };
    version = "0.6.1";
  };
  pairing_heap = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8hfYKllEV7scpoOPwWMuJQVPjg7+3AWuZVaxUfjFMxU=";
      type = "gem";
    };
    version = "3.1.0";
  };
  rack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0/vLykPcK0PJxtffusAWZ65YZDxCzqEAE9DalwIYobE=";
      type = "gem";
    };
    version = "3.1.8";
  };
  rake = {
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Rss42uZdfXS2AgpKydSK/tjrgUnAQOzPBSO+yRkHBZ0=";
      type = "gem";
    };
    version = "13.2.1";
  };
  rake-compiler = {
    dependencies = [ "rake" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8xQQXss9I9QocBTTDBicq52hQVDeAgHki5nCWgR0kXY=";
      type = "gem";
    };
    version = "1.2.8";
  };
  rb-fsevent = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Q5ALly5zAdZXD2S4UKWqZ4M+59h7RY7pKAXVa3MYrv4=";
      type = "gem";
    };
    version = "0.11.2";
  };
  rb-inotify = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oKcARBI5sP8Y62XjhmI2zXhhPWufeP6h+axHqF5Hvm4=";
      type = "gem";
    };
    version = "0.11.1";
  };
  rb-kqueue = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ry8xdbAS4lVOpK4qcg7K5kqbs8Dy6JTGdO8tWmsL+G4=";
      type = "gem";
    };
    version = "0.2.8";
  };
  rexml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1xh1uFKZ80Ht9H1E3wIS52WMvfNa62nO/bY/V68xN8k=";
      type = "gem";
    };
    version = "3.3.9";
  };
  rgl = {
    dependencies = [
      "pairing_heap"
      "rexml"
      "stream"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4/99xnhYuqbK6iM5Z1jFYeSm81fj+cLN+0uQB9MWTEo=";
      type = "gem";
    };
    version = "0.5.10";
  };
  rspec = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1JCRSsHVpaZKDhQAwdVN3SpQEyTXA7jP6D9Fgze6uZM=";
      type = "gem";
    };
    version = "3.13.0";
  };
  rspec-core = {
    dependencies = [ "rspec-support" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lPvabkc45Hjxx1MrfMJBJy/NyLnqwDqXM4sRIuRXMwA=";
      type = "gem";
    };
    version = "3.13.2";
  };
  rspec-expectations = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Dmta9ZuQAUdpjqD/gEVsTy5pysQ5T705L70cpWH2bFg=";
      type = "gem";
    };
    version = "3.13.3";
  };
  rspec-its = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xAQxT5M//V724s+ocWfickd6cAdGfbXsWclq0WecUfY=";
      type = "gem";
    };
    version = "1.3.1";
  };
  rspec-mocks = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IyczXe8OFmUyWpthfjr5riAnJ0HYCsVQM2MJp8Wave8=";
      type = "gem";
    };
    version = "3.13.2";
  };
  rspec-support = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zqOiRj/ZuEudzJaF79gOpwGqj3s97LOzznle1nc32+w=";
      type = "gem";
    };
    version = "3.13.2";
  };
  rubyntlm = {
    dependencies = [ "base64" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RwE0Arma4p7pP5MK9R7a7IxgCFVvS+JXBaQitEMDFPU=";
      type = "gem";
    };
    version = "0.6.5";
  };
  rubyzip = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-P1fjk13CJVxBRIT7+NZztJCdimpXAH7XVN3jk0LSNz8=";
      type = "gem";
    };
    version = "2.3.2";
  };
  snaky_hash = {
    dependencies = [
      "hashie"
      "version_gem"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Gsh+wVf8/npGDoIeDNSK4eb14+CCq1IPA/Maklnb3DE=";
      type = "gem";
    };
    version = "2.0.1";
  };
  stream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YrMzAzDeaQflof0FV9w+9F/CfkjaxvJQI0HeHdBO1QQ=";
      type = "gem";
    };
    version = "0.5.5";
  };
  thor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gyHFfaGxQjJ86AIif954/v0E+agUZ+RanO4wbeQZLzQ=";
      type = "gem";
    };
    version = "0.18.1";
  };
  time = {
    dependencies = [ "date" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-A182BQikpNury7zTiGVmuavUMt6JE2eV0v967FvN6mE=";
      type = "gem";
    };
    version = "0.4.1";
  };
  timeout = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-isotX/mOsvelAcA/jDYiBlkyzFi8WPclzVCgnmO0zBk=";
      type = "gem";
    };
    version = "0.4.2";
  };
  uri = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-swNQTOt+WQV3H6f6FLZJZS+pSd8YtYgNac+xJJR5Hic=";
      type = "gem";
    };
    version = "1.0.2";
  };
  vagrant-spec = {
    dependencies = [
      "childprocess"
      "log4r"
      "rspec"
      "thor"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      fetchSubmodules = false;
      rev = "2a5afa7512753288b4ec1e26ec13bc6479b2fabb";
      hash = "sha256-gDtErRJTO1/ys0xpJCP+oj1eZEiZDcvxNSIYUw7DgCI=";
      type = "git";
      url = "https://github.com/hashicorp/vagrant-spec.git";
    };
    version = "0.0.1";
  };
  vagrant_cloud = {
    dependencies = [
      "excon"
      "log4r"
      "oauth2"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-htGhGigNQ/xAq0ucAkU/IdCZYwlNfBOwlv3+O9L+hx8=";
      type = "gem";
    };
    version = "3.1.2";
  };
  version_gem = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xpdSxtapRGrSGgMGYamIuhC6BcGtJJUyMy7MfvpTRiE=";
      type = "gem";
    };
    version = "1.1.4";
  };
  wdm = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KEBvXyNnlgGb6lsqheN8vNIp7JKMi2gmGUekTuwVtHQ=";
      type = "gem";
    };
    version = "0.1.1";
  };
  webrick = {
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tC08lPFm8/tz2H6bNZ3vm1g2xCb8i+rPOPIYSiGyqYk=";
      type = "gem";
    };
    version = "1.9.1";
  };
  winrm = {
    dependencies = [
      "builder"
      "erubi"
      "gssapi"
      "gyoku"
      "httpclient"
      "logging"
      "nori"
      "rexml"
      "rubyntlm"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-72t2fFdy0G4YYwC1BupeZa+4SZBKVR+EgqXPwqG+XQY=";
      type = "gem";
    };
    version = "2.3.9";
  };
  winrm-elevated = {
    dependencies = [
      "erubi"
      "winrm"
      "winrm-fs"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7XM90WPO2basxqAdMx9TmUa1nkCtvNY5QfYqjGJUtNI=";
      type = "gem";
    };
    version = "1.2.3";
  };
  winrm-fs = {
    dependencies = [
      "erubi"
      "logging"
      "rubyzip"
      "winrm"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DSzdnh+2/I0B9Woy3OQdmK5u77SBk37Q4Fj6oM0MaT0=";
      type = "gem";
    };
    version = "1.3.5";
  };
}
