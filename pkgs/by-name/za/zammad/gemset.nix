{
  aasm = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-46LG5iEwi4E/9Zr8HK/DzM4pU9tXu2f9nMeFEG+70PY=";
      type = "gem";
    };
    version = "5.5.0";
  };
  actioncable = {
    dependencies = [
      "actionpack"
      "activesupport"
      "nio4r"
      "websocket-driver"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WzuIUHWoB2fWPL8rWGy/gkZqJBZ1t5hSM/lXq7Ab/7Q=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  actionmailbox = {
    dependencies = [
      "actionpack"
      "activejob"
      "activerecord"
      "activestorage"
      "activesupport"
      "mail"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iWpHwlIPRQfHXd5nxuofXuw6BB/nv781aMTgFJoIDiU=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  actionmailer = {
    dependencies = [
      "actionpack"
      "actionview"
      "activejob"
      "activesupport"
      "mail"
      "rails-dom-testing"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sCrlI8Msitdi1NuUHnbzwQjBBgMBMiR+56e4yGvHsh8=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  actionpack = {
    dependencies = [
      "actionview"
      "activesupport"
      "nokogiri"
      "racc"
      "rack"
      "rack-session"
      "rack-test"
      "rails-dom-testing"
      "rails-html-sanitizer"
      "useragent"
    ];
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-F7IWCnvL1aVp0Gsa5UpLtczHuggV1z/1doEAp53B9zQ=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  actiontext = {
    dependencies = [
      "actionpack"
      "activerecord"
      "activestorage"
      "activesupport"
      "globalid"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-82nO5BpmdLaXv5JX2Rej3OV1osiZNa9De0MtZzej8NY=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  actionview = {
    dependencies = [
      "activesupport"
      "builder"
      "erubi"
      "rails-dom-testing"
      "rails-html-sanitizer"
    ];
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-afyIDPPYsbryGwSM97to8e7wh2D/gQTX1gpqG+izWaU=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  activejob = {
    dependencies = [
      "activesupport"
      "globalid"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8vlahXOzlKpPfCSEPwxKYGXAc6XGTW8V7NmNmMLCPls=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  activemodel = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-g5iGH57ixGcag1erOemzigRf1lb2aFo91YkMJBnb/a8=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  activerecord = {
    dependencies = [
      "activemodel"
      "activesupport"
      "timeout"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eaMfccMtUThxfCEE4P8QX12CkiJHyFvcoUTycg5n+rk=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  activerecord-import = {
    dependencies = [ "activerecord" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-exvFhsS2NuElwY9TPJrEQh3S26yPSGXb9XY4KjOMLJQ=";
      type = "gem";
    };
    version = "2.1.0";
  };
  activerecord-session_store = {
    dependencies = [
      "actionpack"
      "activerecord"
      "cgi"
      "multi_json"
      "rack"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+EU7HWGNDIdEaD8ICP2kwByak1CDATFimd0bl1ZmI3Q=";
      type = "gem";
    };
    version = "2.1.0";
  };
  activestorage = {
    dependencies = [
      "actionpack"
      "activejob"
      "activerecord"
      "activesupport"
      "marcel"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tOw1/5TU1mVu5pUs5DnD+A4klVLUn9LTmW7lOIDFUl8=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  activesupport = {
    dependencies = [
      "base64"
      "benchmark"
      "bigdecimal"
      "concurrent-ruby"
      "connection_pool"
      "drb"
      "i18n"
      "logger"
      "minitest"
      "securerandom"
      "tzinfo"
    ];
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hCvL+Kkpd/gPtHUGYaI3z13U/dRCBms8NeiK+0iGR/U=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  acts_as_list = {
    dependencies = [
      "activerecord"
      "activesupport"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Xm7WlfGHnWaufY6xYlpy2yFaJqnI7ABHuGaoCIPqVlE=";
      type = "gem";
    };
    version = "1.2.4";
  };
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RimGU3zzc1q188D1V/FBVdd49LQ+pPSFqd65yPfFgjI=";
      type = "gem";
    };
    version = "2.8.7";
  };
  aes_key_wrap = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uTX0dWs3N1iV20VmnnnfzcD3kB4S1OCJdNVUDI4HdqU=";
      type = "gem";
    };
    version = "1.1.0";
  };
  android_key_attestation = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Rn6wGpnSu0jvnPJMwTcSZp1wVsulpS0AlVT/A3VgVws=";
      type = "gem";
    };
    version = "0.3.0";
  };
  argon2 = {
    dependencies = [
      "ffi"
      "ffi-compiler"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YrBBcK83yo2ZdbxuJN07dHlOgqmObYz6muladoBKb4k=";
      type = "gem";
    };
    version = "2.3.2";
  };
  ast = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HigCMuajN1TN5UK8XvhVILdNsqrHPsFKzvRTeERHzBI=";
      type = "gem";
    };
    version = "2.4.2";
  };
  attr_required = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8Ov8VrNeh09NCueZBm28H4Hv7+I2TKOAPcnqak3my5k=";
      type = "gem";
    };
    version = "1.0.2";
  };
  autodiscover = {
    dependencies = [
      "httpclient"
      "logging"
      "nokogiri"
      "nori"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      fetchSubmodules = false;
      rev = "ee9b53dfa797ce6d4f970b82beea7fbdd2df56bb";
      hash = "sha256-JuxOwz3UNyf3hrEN5iZQGluqr0ChcThH2wbEkiP1zuE=";
      type = "git";
      url = "https://github.com/zammad-deps/autodiscover";
    };
    version = "1.0.2";
  };
  autoprefixer-rails = {
    dependencies = [ "execjs" ];
    groups = [ "assets" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zNIfR+WgelgcfSOQJeDY0GoAWCXpbgb3I4LYGP5mX04=";
      type = "gem";
    };
    version = "10.4.19.0";
  };
  aws-eventstream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RGWyrdcdaaNvsSaKc42bPRpZPHieAobyj6044TLUQDs=";
      type = "gem";
    };
    version = "1.3.1";
  };
  aws-partitions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Tf6YdiEcEUM8q3+7Pmk8GDf4qJqvY0Z4+C1UMbLXyCk=";
      type = "gem";
    };
    version = "1.1052.0";
  };
  aws-sdk-core = {
    dependencies = [
      "aws-eventstream"
      "aws-partitions"
      "aws-sigv4"
      "base64"
      "jmespath"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0Qw4Muzh8d6O23y7zXN91JsnifrodEU3lD6G/dgixkk=";
      type = "gem";
    };
    version = "3.219.0";
  };
  aws-sdk-kms = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uikvw//WclMqriYB/lX/Qk7ueNqOI8I7ps5ANxOCdag=";
      type = "gem";
    };
    version = "1.99.0";
  };
  aws-sdk-s3 = {
    dependencies = [
      "aws-sdk-core"
      "aws-sdk-kms"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0Pw1eTlctstpv26XUkDOAx/GcxkOdMjd291sGFcrRQ0=";
      type = "gem";
    };
    version = "1.182.0";
  };
  aws-sigv4 = {
    dependencies = [ "aws-eventstream" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UKh5aZGoYjJEQgNq16OVkgVyuEu2zSm5ReXhgA6Nods=";
      type = "gem";
    };
    version = "1.11.0";
  };
  base64 = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DyXpshoCoMwM6o75KyBBA105NQlG6HicVistGj2gFQc=";
      type = "gem";
    };
    version = "0.2.0";
  };
  benchmark = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DxL4xJVUXjcQw+TwSA9j8GtMhCzJTOx/M6lW9RgOh0o=";
      type = "gem";
    };
    version = "0.4.0";
  };
  bigdecimal = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L/x0IDFSGtacLfyBWpjkJqIwo9Iq6sGZWCanXav62Mw=";
      type = "gem";
    };
    version = "3.1.9";
  };
  bindata = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KdzLi6HMneFI8ku4iTCEDGLbVnFfD4Dsyt1iTZ89JiM=";
      type = "gem";
    };
    version = "2.5.0";
  };
  binding_of_caller = {
    dependencies = [ "debug_inspector" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KykCq/9CRt3PvE2ptpvEoBniKuswDC/2KJoXPUuQspo=";
      type = "gem";
    };
    version = "1.0.1";
  };
  biz = {
    dependencies = [
      "clavius"
      "tzinfo"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jO43CCYl/L6y7ndG1aPFWgJO8Tlb62XLiddSmTQ7Tdg=";
      type = "gem";
    };
    version = "1.8.2";
  };
  bootsnap = {
    dependencies = [ "msgpack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rExCrzl/fuFVIYIBmNrv9UXkw2DSdyxgH73CwH2Sr1U=";
      type = "gem";
    };
    version = "1.18.4";
  };
  brakeman = {
    dependencies = [ "racc" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GgEisMcPF1GaYVSKU6MywKzBnjqhC0ReFeAlpLE7hXc=";
      type = "gem";
    };
    version = "7.0.0";
  };
  browser = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KB1SlXiIJck5ZCfCksLSvgpckYdck8OQ/ebl1hpazi0=";
      type = "gem";
    };
    version = "6.2.0";
  };
  buftok = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-utdgM0Yx4VuO6mCEaHCdMmXgh3A7WvBTL2WD4nfw+uc=";
      type = "gem";
    };
    version = "0.2.0";
  };
  builder = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SXkY0vncpSj9ykuI2E5O9DhyVtmEuBVOnV0/5anIg18=";
      type = "gem";
    };
    version = "3.3.0";
  };
  byebug = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JIWUTSuyEoPFk9Vi+a4QGb+AACFDzDolWq/9Tpz0o1s=";
      type = "gem";
    };
    version = "11.1.3";
  };
  byk = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-9ikpsjL+wblb1kQBfQyRCa/kQGgDIm25MnOek0I1gjM=";
      type = "gem";
    };
    version = "1.1.0";
  };
  camertron-eprun = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mo4zeRZEXmJkj2pPNdIpMC/ETFBUnMiBv/Hilsz5zks=";
      type = "gem";
    };
    version = "1.1.1";
  };
  capybara = {
    dependencies = [
      "addressable"
      "matrix"
      "mini_mime"
      "nokogiri"
      "rack"
      "rack-test"
      "regexp_parser"
      "xpath"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QtunIFeOocpl/XpB0WPdNoUCwZGARVj24PcbORBUru8=";
      type = "gem";
    };
    version = "3.40.0";
  };
  cbor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nuCX/FjZvF5AbREs0tThEsc1TsFvi2/zTkcyweRLTrc=";
      type = "gem";
    };
    version = "0.5.9.8";
  };
  cgi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-o8sZDUaoIMoBo+KL1bZOZwA/+Z14hLcFEkSFZvNTR+Y=";
      type = "gem";
    };
    version = "0.4.2";
  };
  childprocess = {
    dependencies = [ "logger" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mo1IS+L9QJag6QoM0+RJoFvDqjP4rJ5Nbc72rBRVtuw=";
      type = "gem";
    };
    version = "5.1.0";
  };
  chunky_png = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-idWzG1XAz02jz4mitOvDF42Kvoy68Rah26lWaFAv3P4=";
      type = "gem";
    };
    version = "1.4.0";
  };
  clavius = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oamXPxi+r76Qb1Jzvb2LrGLWrHDJVH1DdWoDgybaqHg=";
      type = "gem";
    };
    version = "1.0.4";
  };
  cld = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Qmm1dBdWmJ5+vMX/eMjDDVPO3+QI6wkdYQET2C8+SQw=";
      type = "gem";
    };
    version = "0.13.0";
  };
  cldr-plurals-runtime-rb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-I1OHWvib6frAScYIkelzglskqXnu73J0CTyf9f1W36k=";
      type = "gem";
    };
    version = "1.1.0";
  };
  clearbit = {
    dependencies = [ "nestful" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dNEiFHoQD0E4v8Z5wowEwHxRAQxV8hRL5oHS+37fj7E=";
      type = "gem";
    };
    version = "0.3.3";
  };
  coderay = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3FMAGKRoRRL484FDzSoJbJ8CofwkWe3P5TR4en/HfUs=";
      type = "gem";
    };
    version = "1.1.3";
  };
  coffee-rails = {
    dependencies = [
      "coffee-script"
      "railties"
    ];
    groups = [ "assets" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XaqhulH9SQfJijM7ap58Gpmx//V/zvmZtsYtgTy5Gpw=";
      type = "gem";
    };
    version = "5.0.0";
  };
  coffee-script = {
    dependencies = [
      "coffee-script-source"
      "execjs"
    ];
    groups = [
      "assets"
      "default"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gv4oHhG5PIEXuYxeqAY+cXQYcPHE+7Jxd9fWMz3Th2U=";
      type = "gem";
    };
    version = "2.4.1";
  };
  coffee-script-source = {
    groups = [
      "assets"
      "default"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4SsW/Ykn+7+Lh8sumoWmz0V8aIHMf/ixrxWzH3DaB6Q=";
      type = "gem";
    };
    version = "1.12.2";
  };
  concurrent-ruby = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gTs+N6ym3yoho7nx1Jf4y6skorlMqzJb/+Ze4PbL68Y=";
      type = "gem";
    };
    version = "1.3.5";
  };
  connection_pool = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IzuS+NOOA4wTSczqZd03cnJ9Zp1tLnH5iXyL9c1T6/w=";
      type = "gem";
    };
    version = "2.5.0";
  };
  cose = {
    dependencies = [
      "cbor"
      "openssl-signature_algorithm"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1dTbzWsDXVE+3E4aubwQ6c4TtAEcluPRuP5eZBP9beU=";
      type = "gem";
    };
    version = "1.3.1";
  };
  crack = {
    dependencies = [
      "bigdecimal"
      "rexml"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yDrv20KM3Htmx/KH5IjHlvBVwIOeblRf7CxwR3Q8Skk=";
      type = "gem";
    };
    version = "1.0.0";
  };
  crass = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3FFgIqVuezsVYJmryBttKwjqHtEmdqx6VldhfwEr1F0=";
      type = "gem";
    };
    version = "1.0.6";
  };
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
  daemons = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-j8dtdvrsZp/rXkVdcvNb1MRtxnNeKMQgr7gi+sH6mh0=";
      type = "gem";
    };
    version = "1.4.1";
  };
  dalli = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LmNZUITZH64mVVFKAsXU/A8WwHmYk3lKviO/YovrqqU=";
      type = "gem";
    };
    version = "3.2.8";
  };
  date = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vyaOFO9xWACb/q7EC1+jxycZBuiLGW2VionUtAir5k8=";
      type = "gem";
    };
    version = "3.4.1";
  };
  debug_inspector = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-m9+gLuvD2hY4M+aomxVAhCMvV2YIfllXO3BSHHfqaKI=";
      type = "gem";
    };
    version = "1.2.0";
  };
  delayed_job = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SUHmTGRrg0knn9apj2mf03JcefyNq47feLbaYciFO7s=";
      type = "gem";
    };
    version = "4.1.13";
  };
  delayed_job_active_record = {
    dependencies = [
      "activerecord"
      "delayed_job"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZPNKbVAxbden3x2vfG4ErYiMDoaTh2Ixj29SUit8G6g=";
      type = "gem";
    };
    version = "4.1.11";
  };
  deprecation_toolkit = {
    dependencies = [ "activesupport" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pY/BMb2DVzrS0GfZ0bnnopjfuTWTGtjbL5GXqkub2/0=";
      type = "gem";
    };
    version = "2.2.2";
  };
  diff-lcs = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JzIj37QGhVSENtMrRzOqZzUXacfepiHafZ3UgT5j3f4=";
      type = "gem";
    };
    version = "1.5.1";
  };
  diffy = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QmS559sA0c1Cb80y42Vld5FjztwjQKlbDm8CXnH5qqc=";
      type = "gem";
    };
    version = "3.4.3";
  };
  domain_name = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-X2k7IhVwhHZRdHm/KzgC5JBorYIWe80ihviZU2oX2TM=";
      type = "gem";
    };
    version = "0.6.20240107";
  };
  doorkeeper = {
    dependencies = [ "railties" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bVTzw2dV2M/Lfk8E+88f80ksgWCQrXgSbsinIsKS0mw=";
      type = "gem";
    };
    version = "5.8.1";
  };
  drb = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6dRyv3hfVYuWslNYuuEVZG2g2/1FEHrYWLC8DZNcs0A=";
      type = "gem";
    };
    version = "2.2.1";
  };
  dry-cli = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jJffOykO5jVO4gJaXwpnIms4FifeMnQdBvNeoIh82Vs=";
      type = "gem";
    };
    version = "1.2.0";
  };
  dry-core = {
    dependencies = [
      "concurrent-ruby"
      "logger"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CQOCGpcHZJp9pUWizYjiDzpmOrHFKIq9f5FPp3UasZU=";
      type = "gem";
    };
    version = "1.1.0";
  };
  dry-inflector = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IvXQtQ/VcHSuV+LKF+OzAOV1ZMIYJp3Pgv8+QtPzjy4=";
      type = "gem";
    };
    version = "1.2.0";
  };
  dry-logic = {
    dependencies = [
      "bigdecimal"
      "concurrent-ruby"
      "dry-core"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2m/tvA+Q/EH5sMx+bwX11SnR7672yNzI4HM/aFdFzqI=";
      type = "gem";
    };
    version = "1.6.0";
  };
  dry-struct = {
    dependencies = [
      "dry-core"
      "dry-types"
      "ice_nine"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QgCROiSjaTLVMdcmoABn9ye0vQPVEdJn9YujqGvuU64=";
      type = "gem";
    };
    version = "1.7.1";
  };
  dry-types = {
    dependencies = [
      "bigdecimal"
      "concurrent-ruby"
      "dry-core"
      "dry-inflector"
      "dry-logic"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yE6a2mlBnHJ8OxLhkeDtfSxtWNBA1V556hbg6/iz7A8=";
      type = "gem";
    };
    version = "1.8.2";
  };
  eco = {
    dependencies = [
      "coffee-script"
      "eco-source"
      "execjs"
    ];
    groups = [ "assets" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IDfeZrzhtO3O86f9Q2jhGHKiMlRdVTDO7Bq8ec/iUSY=";
      type = "gem";
    };
    version = "1.0.0";
  };
  eco-source = {
    groups = [
      "assets"
      "default"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QS1PUgnk7YbshpLgooaajYfVywKJxCDbLLwaptTOnbE=";
      type = "gem";
    };
    version = "1.1.0.rc.1";
  };
  em-websocket = {
    dependencies = [
      "eventmachine"
      "http_parser.rb"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-9WqSveTmy4eSVtWO4x8SQYH2j4iHvRTVPV2aKSdYxqg=";
      type = "gem";
    };
    version = "0.5.3";
  };
  email_address = {
    dependencies = [
      "base64"
      "simpleidn"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hzqwF1gG1YB6QKBdN0UrBzcFJeqHUlJzpYfYEQIgKJw=";
      type = "gem";
    };
    version = "0.2.5";
  };
  email_validator = {
    dependencies = [ "activemodel" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WrI4CVvseu+TifIw6eDGTFCBzfkfGdbFzs7gqTryBgQ=";
      type = "gem";
    };
    version = "2.2.4";
  };
  equalizer = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ROW8RvSYg+g9FZ7psfcyC0roKDu2Mp5dlxb1593oVc4=";
      type = "gem";
    };
    version = "0.0.11";
  };
  erubi = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oIIQOwiF28Xs8Rcv7eiX+evbdFpLl6Xo3GOVPbHuStk=";
      type = "gem";
    };
    version = "1.13.1";
  };
  eventmachine = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mUAW5CqgQUd7qc/0XL5Q3iBH8l3UGOugA+hPDRZWCXI=";
      type = "gem";
    };
    version = "1.2.7";
  };
  execjs = {
    groups = [ "assets" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-a8uL6PAFL/nTcLZdHAgPJAZlbhUEUqCr2xhaEzBIRQ0=";
      type = "gem";
    };
    version = "2.10.0";
  };
  factory_bot = {
    dependencies = [ "activesupport" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QFgep77AruBVFLj0+Z7UdydL3xiEwTct5SCeYDItbKk=";
      type = "gem";
    };
    version = "6.5.1";
  };
  factory_bot_rails = {
    dependencies = [
      "factory_bot"
      "railties"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-E54XyqLFDwmP3fXl4fKegGc1ICTpHKEYbQGLNlieXIg=";
      type = "gem";
    };
    version = "6.4.4";
  };
  faker = {
    dependencies = [ "i18n" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GtH76iediC9IYFnCP+PduBbM0dcFLAWkUBS0RQ2Fm/w=";
      type = "gem";
    };
    version = "3.5.1";
  };
  faraday = {
    dependencies = [
      "faraday-net_http"
      "json"
      "logger"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-FXM5wlx7i8tzn1zxIHywzv6PocZQJyZry8NMkMhLmtY=";
      type = "gem";
    };
    version = "2.12.2";
  };
  faraday-follow_redirects = {
    dependencies = [ "faraday" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2S2XVjXix/5SXdSU/NS5u38KSg7A1fTBXHKVMP24B/k=";
      type = "gem";
    };
    version = "0.3.0";
  };
  faraday-mashify = {
    dependencies = [
      "faraday"
      "hashie"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tLK8eJDXgyeiceTWS9AVa15FifzY0+ZrG1KfzvEKPro=";
      type = "gem";
    };
    version = "0.1.1";
  };
  faraday-multipart = {
    dependencies = [ "multipart-post" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hWsPHHMWpNbAUt0u71xC+IfVbZOhcf6IgNoa8GTKB1E=";
      type = "gem";
    };
    version = "1.1.0";
  };
  faraday-net_http = {
    dependencies = [ "net-http" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ofHkzWos8hWZyCIVleJ1gtmTaBmXe71AiaYB8kxk5Uo=";
      type = "gem";
    };
    version = "3.4.0";
  };
  ffi = {
    groups = [
      "assets"
      "default"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Jvaw29EQHm/8CdPKZAsqIYQMxScxrYp97Z+4nl+w/Dk=";
      type = "gem";
    };
    version = "1.17.1";
  };
  ffi-compiler = {
    dependencies = [
      "ffi"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qU89gdEsr1xdTs8TmApw0K6qciaPO5zBM1i8xlCRhKA=";
      type = "gem";
    };
    version = "1.3.2";
  };
  fiber-storage = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uAoyPx4LleebEcHU339lTb5RfBGjRMkPKkPexnulq38=";
      type = "gem";
    };
    version = "1.0.0";
  };
  gli = {
    dependencies = [ "ostruct" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WA6NbIiw8PDLjossoYw0he0PdCzs6FXeRr+ONiAvXbA=";
      type = "gem";
    };
    version = "2.22.2";
  };
  globalid = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cL92cRhx+EPbunK+uGEyKaSUKdGGaChHb5ydbMwyfOk=";
      type = "gem";
    };
    version = "1.2.1";
  };
  graphql = {
    dependencies = [
      "base64"
      "fiber-storage"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+x226eJMk8mV+Ag9Zuxl6nCZGqK2jaGxWjYLQYr1qp0=";
      type = "gem";
    };
    version = "2.4.13";
  };
  graphql-batch = {
    dependencies = [
      "graphql"
      "promise.rb"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-F2kaq6xO5YolzbXeUFdlzh9yvzSGEN7Et00dT0QVvlc=";
      type = "gem";
    };
    version = "0.6.0";
  };
  graphql-fragment_cache = {
    dependencies = [ "graphql" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cU/buECZHbX11//pvDcnvX1iIb+V35jQjUiK/gqXd4Y=";
      type = "gem";
    };
    version = "1.22.0";
  };
  hashdiff = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LDDu3tbtPc6EAdK1uZ5pY/5fFO2F5g3Z4zxUWkS3Gnc=";
      type = "gem";
    };
    version = "1.1.2";
  };
  hashie = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nWxOUfKjbUYWy8ijItYZoWLY9CgVp5JZYDn8lVlWA9o=";
      type = "gem";
    };
    version = "5.0.0";
  };
  hiredis = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fwUuMg99JLXCqf32fG/2+s324lY5SnA1EbzjTs9EUhI=";
      type = "gem";
    };
    version = "0.6.3";
  };
  htmlentities = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Elpzxsny0bYhALfDxAHjYkRBtmN2Kvp/5ChHZDWmc9o=";
      type = "gem";
    };
    version = "4.3.4";
  };
  http = {
    dependencies = [
      "addressable"
      "http-cookie"
      "http-form_data"
      "http-parser"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vhDx0FT8xzKsMkEFU3Z6w+QUG0GCpNj1v5PSPO2uG30=";
      type = "gem";
    };
    version = "4.4.1";
  };
  http-cookie = {
    dependencies = [ "domain_name" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sU/gRFzyS/muCYYz6bjULkwHw8H3AGcrCfv+Mv/UGqY=";
      type = "gem";
    };
    version = "1.0.8";
  };
  http-form_data = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zE7rE2HZh2gh4x17HPC2jxz4dLIB0nkDSAR52GRIpfM=";
      type = "gem";
    };
    version = "2.3.0";
  };
  http-parser = {
    dependencies = [ "ffi-compiler" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QU3sH0Q9aOEGhQnxhO5Lk+NEL2JmRQcRgs5JvCfbGKM=";
      type = "gem";
    };
    version = "1.2.3";
  };
  "http_parser.rb" = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8R0K7FDvJqfR+ZHmJ6yIrNtZeSgq66elw75s4GNu0ZY=";
      type = "gem";
    };
    version = "0.6.0";
  };
  httparty = {
    dependencies = [
      "mini_mime"
      "multi_xml"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AO97+acfMKO/+I7etbFqNL6og6tnwkaz8NstZ5T+EhQ=";
      type = "gem";
    };
    version = "0.21.0";
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
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zrpXP4E4/ywJFUJ/H8W99Ko6uK6IyM4lXrPs8KEaXQ8=";
      type = "gem";
    };
    version = "1.14.7";
  };
  icalendar = {
    dependencies = [
      "ice_cube"
      "ostruct"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Dr/CZy+fp3uGtNjA4l6bIxmq1FozMZ/tBtC+jd0M1IU=";
      type = "gem";
    };
    version = "2.10.3";
  };
  icalendar-recurrence = {
    dependencies = [
      "icalendar"
      "ice_cube"
      "tzinfo"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Xbj6JBYENOeyC2A2Ek26zkkWijKDCkV30Z6nSwI1QgQ=";
      type = "gem";
    };
    version = "1.2.0";
  };
  ice_cube = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Mt60XdpLSsxTUFwvWB9tMrWvwE0puQBHaZRKDfWl/L4=";
      type = "gem";
    };
    version = "0.17.0";
  };
  ice_nine = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XVBqfScj1VktwSG5ko5JMXQnMBMfIqGjdknfHB4uY9s=";
      type = "gem";
    };
    version = "0.11.2";
  };
  inflection = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zrqbJvwoua+C4z6CLSj3ikMSr3Vofv7IHV7xBiSY01U=";
      type = "gem";
    };
    version = "1.0.0";
  };
  iniparse = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NqFl6Y2KJQt2McSn+a+6Mq948ImXDNZEajl3EYnHYfE=";
      type = "gem";
    };
    version = "1.5.0";
  };
  interception = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pTgY1jZ1Ko35DYwbsve24Tp7goVDywK1D73pi4SdeQc=";
      type = "gem";
    };
    version = "0.5";
  };
  io-console = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zWqfrLxphx1pssuLkm/G6n7wbwblBegaZPFKRw/d76I=";
      type = "gem";
    };
    version = "0.8.0";
  };
  irb = {
    dependencies = [
      "pp"
      "rdoc"
      "reline"
    ];
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2bynRaxCB6i3KKUrmLdmypCbhv8aUEvN49b4yE+q6JA=";
      type = "gem";
    };
    version = "1.15.1";
  };
  jmespath = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-I413SlhyPWwJBJTIh5temRjBlIX36EDywcdTLPhOvLE=";
      type = "gem";
    };
    version = "1.6.2";
  };
  json = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NODq2pMCKyoKM0W7C179226f9b58SOQJz7VP+KNqiwY=";
      type = "gem";
    };
    version = "2.10.2";
  };
  json-jwt = {
    dependencies = [
      "activesupport"
      "aes_key_wrap"
      "base64"
      "bindata"
      "faraday"
      "faraday-follow_redirects"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zKv/TG0aFCdrIxeOi+vlE+8jY5m3KguIbX7ZSADRcqU=";
      type = "gem";
    };
    version = "1.16.7";
  };
  jwt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-aCAccxQDTJsjk0syPGX5YtPfEHtGoWYmCHTfCrq86C0=";
      type = "gem";
    };
    version = "2.3.0";
  };
  koala = {
    dependencies = [
      "addressable"
      "base64"
      "faraday"
      "faraday-multipart"
      "json"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gty+WIpcmkrfnh3GA3aECqgKd40vizQnWCXlxfe+gHw=";
      type = "gem";
    };
    version = "3.6.0";
  };
  language_server-protocol = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xIRiZHhmT9E0gtgYCUfFCoWQSEsSWLmbeu2ztp34lmk=";
      type = "gem";
    };
    version = "3.17.0.4";
  };
  lint_roller = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LAyEW2MqfRcsuEnMkMG86TeijFyMzMtQ39RqSFADzIc=";
      type = "gem";
    };
    version = "1.1.0";
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
  localhost = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/NOo2JzYso4E/rTLRREeG0pxOO/IeazfZW9K/9NfQZg=";
      type = "gem";
    };
    version = "1.3.1";
  };
  logger = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3WGNJOY3cVRycy5+7QLjPPvfVt6q0iXt0PH4nTgCQBc=";
      type = "gem";
    };
    version = "1.6.6";
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
  loofah = {
    dependencies = [
      "crass"
      "nokogiri"
    ];
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YeanEIg6u4IQiH89yGjPPtZllMUJ2f9ph2Ie+mZR7h4=";
      type = "gem";
    };
    version = "2.24.0";
  };
  macaddr = {
    dependencies = [ "systemu" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2jd4CZaLvBFgvwKpmekWuzJVAAAHKR2dGkmpPO7a34I=";
      type = "gem";
    };
    version = "1.7.2";
  };
  mail = {
    dependencies = [
      "mini_mime"
      "net-imap"
      "net-pop"
      "net-smtp"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7Dufrc8rN1XHh4XLF7yaDKnumFcQimS29c/JwLW/ya0=";
      type = "gem";
    };
    version = "2.8.1";
  };
  marcel = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DVZJ/rZLjxnz00aLlsaAuul0YzXQIZQnAoeGimYVFqQ=";
      type = "gem";
    };
    version = "1.0.4";
  };
  matrix = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cQg8y9Z6FKQ7+njT5NwPS1A7nMGOW0sdaG3A+e98TMA=";
      type = "gem";
    };
    version = "0.4.2";
  };
  memoizable = {
    dependencies = [ "thread_safe" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rPTSKA/qAZMY5hz8XmkHfcs8ISaBfuWW/9dtDd9egmw=";
      type = "gem";
    };
    version = "0.4.2";
  };
  messagebird-rest = {
    dependencies = [ "jwt" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-U8NjiIQJsdSeeS9Rr62j4FQ8aiSS60dNbUoIKgK18H0=";
      type = "gem";
    };
    version = "4.0.0";
  };
  method_source = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GBMBycRbcxtHabyB6IYOcvkWGtfWbdmRA8mrhPVg9cU=";
      type = "gem";
    };
    version = "1.1.0";
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
      hash = "sha256-IypJfMaM/KWJgmhdR/sm8Q7y6wCcTRxTp+FZ1XJ0Pco=";
      type = "gem";
    };
    version = "3.2025.0107";
  };
  mini_mime = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hoG34uQhXyoVn5QAtYFthenYxsa0kelqEnl+eY+LzO8=";
      type = "gem";
    };
    version = "1.1.5";
  };
  mini_portile2 = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jkcTbNrATOgXULtsCXM7N4lb8GliVU5LQFbXgWjXCnU=";
      type = "gem";
    };
    version = "2.8.8";
  };
  minitest = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nPLK4lrE38kMmI68O5F/U8BUl4tnMnPaG9ILywd4+Uc=";
      type = "gem";
    };
    version = "5.25.4";
  };
  msgpack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/7BJefUeZAaCPAOr5Q4dosglxVo33uE4UYzdCdnTrqg=";
      type = "gem";
    };
    version = "1.7.5";
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
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-T84QDGivWI/5G4upCguz8EZvBskJ8hoy9JYgWRQLphs=";
      type = "gem";
    };
    version = "0.7.1";
  };
  multipart-post = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mHLQOo5VICDKCWra2/XjyxzRzdas08FhE2uKVzfNtKg=";
      type = "gem";
    };
    version = "2.4.1";
  };
  mutex_m = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-z8sErBa2nEgTd3Ai/c7aJOn3mOSAkqK4F+tMCngrB1E=";
      type = "gem";
    };
    version = "0.3.0";
  };
  mysql2 = {
    groups = [ "mysql" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cPRH1F1rPMFrAPfdMDZvcIqBtAk6NdAm/3E113jY2jM=";
      type = "gem";
    };
    version = "0.5.6";
  };
  naught = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-T09rROUiN//KVpd8zuHK+pPpVDQGKXTptYCt98vokvM=";
      type = "gem";
    };
    version = "1.1.0";
  };
  nestful = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fEacF949XN5CdMPv+MB4ofdV/Mpqcjx7sryFC1umx2o=";
      type = "gem";
    };
    version = "1.1.4";
  };
  net-http = {
    dependencies = [ "uri" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-liGyDBN4mK+diQVWhIyTYDcWyrUW3CyJsBo4uJTiWfs=";
      type = "gem";
    };
    version = "0.6.0";
  };
  net-imap = {
    dependencies = [
      "date"
      "net-protocol"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ht6ASO5oihQgYGC/N6cW0Yy26gCFX2ybFdrul+5R++U=";
      type = "gem";
    };
    version = "0.5.6";
  };
  net-ldap = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vio3nMvSj8dftwqUr3TjqaaGa4RXQkf8JD4KvdL4Lz0=";
      type = "gem";
    };
    version = "0.19.0";
  };
  net-pop = {
    dependencies = [ "net-protocol" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hItOmCATwVsvA4J5Imh2O3SMzpHJ6R42sPJ+0mQg3/M=";
      type = "gem";
    };
    version = "0.1.2";
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
  net-smtp = {
    dependencies = [ "net-protocol" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7Zagr2PFJPzrSymw01IZXDDYLdkWpC8Dxio6cOW3BzY=";
      type = "gem";
    };
    version = "0.5.1";
  };
  nio4r = {
    groups = [
      "default"
      "puma"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2V3uaOC7JRuP+QrDQjpRHjt4QSTl23/19IE6IgrnPKk=";
      type = "gem";
    };
    version = "2.7.4";
  };
  nkf = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+8FRvaAlRR9if6/fyz9PE9CyKuEfWMbTopOcdsX18SY=";
      type = "gem";
    };
    version = "0.2.0";
  };
  nokogiri = {
    dependencies = [
      "mini_portile2"
      "racc"
    ];
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yKb42pQYrCE0USS8eblHAfA2+gWyff7EptwUjV+hNtw=";
      type = "gem";
    };
    version = "1.18.5";
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
  oauth = {
    dependencies = [
      "oauth-tty"
      "snaky_hash"
      "version_gem"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OJArfw9e2R6FjWNT9eHgaywWqKoP2RmEZx6rGh0c3es=";
      type = "gem";
    };
    version = "1.1.0";
  };
  oauth-tty = {
    dependencies = [ "version_gem" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NOJcMH2kUJ1N7sJm/zaQu/QuORNV9JYgHAKSaIYtixc=";
      type = "gem";
    };
    version = "1.0.5";
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
  omniauth = {
    dependencies = [
      "hashie"
      "rack"
      "rack-protection"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3vAydymLj4pdP/Fs2y617bm//tYO592iTMDImzrmoM4=";
      type = "gem";
    };
    version = "2.1.2";
  };
  omniauth-facebook = {
    dependencies = [
      "bigdecimal"
      "omniauth-oauth2"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-39xsutpTh1ctVUeEhhVGz2OC+foWxHMcvlgT5XD8ueE=";
      type = "gem";
    };
    version = "10.0.0";
  };
  omniauth-github = {
    dependencies = [
      "omniauth"
      "omniauth-oauth2"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-j/jnCsbW251SSF7vUs+olJOMlBSW5mtSteJ3Ot48ytQ=";
      type = "gem";
    };
    version = "2.0.1";
  };
  omniauth-gitlab = {
    dependencies = [
      "omniauth"
      "omniauth-oauth2"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VD8fpxBIgiCzgr1oOj8xT1spw23oWtdG81bzd5WVlhM=";
      type = "gem";
    };
    version = "4.1.0";
  };
  omniauth-google-oauth2 = {
    dependencies = [
      "jwt"
      "oauth2"
      "omniauth"
      "omniauth-oauth2"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ma1iOzw1yUmIdXSl2NXoRhJR5M5uvCEC64FZ22Fk70A=";
      type = "gem";
    };
    version = "1.1.3";
  };
  omniauth-linkedin-oauth2 = {
    dependencies = [ "omniauth-oauth2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-44mVNkZdmt9GIn9GKGI/F2nnmAqeGHtMI8zG380sUXU=";
      type = "gem";
    };
    version = "1.0.1";
  };
  omniauth-microsoft-office365 = {
    dependencies = [
      "omniauth"
      "omniauth-oauth2"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-O7xMRIxPJ05jWPfyHxQ94yhucgW4NTF+arhP/1Aghu8=";
      type = "gem";
    };
    version = "0.0.8";
  };
  omniauth-oauth = {
    dependencies = [
      "oauth"
      "omniauth"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Jb8iyQI0KA+oJSAEkPA/8c59dvGk+9bIgsbFsWnFjag=";
      type = "gem";
    };
    version = "1.2.1";
  };
  omniauth-oauth2 = {
    dependencies = [
      "oauth2"
      "omniauth"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-svjpVZzH4tTvuldgdpHW0rY0uHn8W1tsz++j2oUInng=";
      type = "gem";
    };
    version = "1.8.0";
  };
  omniauth-rails_csrf_protection = {
    dependencies = [
      "actionpack"
      "omniauth"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EXD9Zyr/CSubfr68FFNVnwc+0AHjzmKh32FuMvjcX+A=";
      type = "gem";
    };
    version = "1.0.2";
  };
  omniauth-saml = {
    dependencies = [
      "omniauth"
      "ruby-saml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-irtr+NOKUPUsfMkF0yh3x7LHnbycIl/MPT5WcjQR1gI=";
      type = "gem";
    };
    version = "2.2.1";
  };
  omniauth-twitter = {
    dependencies = [
      "omniauth-oauth"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xcxsd812d0X/qeu9X71pSj+pnR0tgqTX3vC/O2ExsmQ=";
      type = "gem";
    };
    version = "1.4.0";
  };
  omniauth-weibo-oauth2 = {
    dependencies = [
      "omniauth"
      "omniauth-oauth2"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      fetchSubmodules = false;
      rev = "06803ef97f822ede854322587db8049cc67dcfa6";
      hash = "sha256-4RjjoWhTYn44deLdXUpAVnP+6kAlT9gRatU2dUPoeoE=";
      type = "git";
      url = "https://github.com/zammad-deps/omniauth-weibo-oauth2";
    };
    version = "0.5.2";
  };
  omniauth_openid_connect = {
    dependencies = [
      "omniauth"
      "openid_connect"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Hy84kDhuKnQiIc7g0ukDt42HTm+rnqO/oxwUYvR5PSU=";
      type = "gem";
    };
    version = "0.8.0";
  };
  openid_connect = {
    dependencies = [
      "activemodel"
      "attr_required"
      "email_validator"
      "faraday"
      "faraday-follow_redirects"
      "json-jwt"
      "mail"
      "rack-oauth2"
      "swd"
      "tzinfo"
      "validate_url"
      "webfinger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XYCDgM/4DXjj09VM+uvi1kYdg1xnT6op4jFKQCwbIYI=";
      type = "gem";
    };
    version = "2.3.1";
  };
  openssl = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/zpXP8l6sw9pSD/dyAAp+RZpvzZTKFm9GC0YNvRa7nk=";
      type = "gem";
    };
    version = "3.3.0";
  };
  openssl-signature_algorithm = {
    dependencies = [ "openssl" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-o7QLXoJ2Fi1KblDHyXza8URvmyw5Rqb6LBRijgyVfoA=";
      type = "gem";
    };
    version = "1.3.0";
  };
  ostruct = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CaP7fswfpAOfJUGMwFrpyCvVIEcsXGpvUV8D5JiMuBc=";
      type = "gem";
    };
    version = "0.6.1";
  };
  overcommit = {
    dependencies = [
      "childprocess"
      "iniparse"
      "rexml"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-j5e9bHmawdNk5WmLGfW1Dxp9nrAjmx7wGkLUSCjGQbw=";
      type = "gem";
    };
    version = "0.67.0";
  };
  parallel = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2Gurt6K4FL6fS4FYe/C2zi2n1Flp+rJNiuS/K7TUx+8=";
      type = "gem";
    };
    version = "1.26.3";
  };
  parser = {
    dependencies = [
      "ast"
      "racc"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fb5hYYAlUZAkrHJAKmZ36tAgmVh6VTjoQ3G3ZlnmrKE=";
      type = "gem";
    };
    version = "3.3.7.1";
  };
  pg = {
    groups = [ "postgres" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dh7733O2ZRbwwm/L5lFdx1AMPwqhobhT/q4kVDPGT9w=";
      type = "gem";
    };
    version = "1.5.9";
  };
  PoParser = {
    dependencies = [ "simple_po_parser" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-9c94T9t8/Cn/wqsvK/kIUbpqI84NJYRNIPP3BvHciOY=";
      type = "gem";
    };
    version = "3.2.8";
  };
  power_assert = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Y7URuFu46lczbSUVaGRJhkT1u/AoaZztonlJ4BJbwyM=";
      type = "gem";
    };
    version = "2.0.5";
  };
  pp = {
    dependencies = [ "prettyprint" ];
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lH7DEgxvkhlfjuiqJaeyxSl7sQbYO0G6oCmDaGV3tv8=";
      type = "gem";
    };
    version = "0.6.2";
  };
  prettyprint = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-K8nhVYGpR0IGSjzIsPudRarj0Dobqm74CSJiegdm8ZM=";
      type = "gem";
    };
    version = "0.2.0";
  };
  "promise.rb" = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LSEQBQwF5uqMMKOUWuuWE4ttQwPBh8kginBjNqNOASk=";
      type = "gem";
    };
    version = "0.7.4";
  };
  pry = {
    dependencies = [
      "coderay"
      "method_source"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xP5U7+2sodNRKAtFuISa82MYRpb8rBxy4EFfm9rEM00=";
      type = "gem";
    };
    version = "0.14.2";
  };
  pry-byebug = {
    dependencies = [
      "byebug"
      "pry"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yPl1wyJVv9sp4VH1UyEwvmT/PQBC3IWNCQfoSRJVgfg=";
      type = "gem";
    };
    version = "3.10.1";
  };
  pry-doc = {
    dependencies = [
      "pry"
      "yard"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bVaurwr9tFN0URoh3ShfdeoD7A+hn+USOKSc/VTI+nU=";
      type = "gem";
    };
    version = "1.5.0";
  };
  pry-rails = {
    dependencies = [ "pry" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pp4o4ko0110fYLzyQRkqVCU/j374piy6HnV1CpZTWT0=";
      type = "gem";
    };
    version = "0.3.11";
  };
  pry-remote = {
    dependencies = [
      "pry"
      "slop"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1Z4GW/4T83kyAHYaEwNlNJdnnmKBX5eex2UXz2bm4YE=";
      type = "gem";
    };
    version = "0.1.8";
  };
  pry-rescue = {
    dependencies = [
      "interception"
      "pry"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mFv9UG2YZrWH/YZ5DPhEUmakG3+Sxif8WyHsfZKrpts=";
      type = "gem";
    };
    version = "1.6.0";
  };
  pry-stack_explorer = {
    dependencies = [
      "binding_of_caller"
      "pry"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-otvqm0fErQDPXBziFJn4EouRUInpABX3uvtulFO680A=";
      type = "gem";
    };
    version = "0.6.1";
  };
  pry-theme = {
    dependencies = [ "coderay" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EEGngTPwIspdIg23M1ibFlQ+t5G47At/IRR+sysOGmI=";
      type = "gem";
    };
    version = "1.3.1";
  };
  psych = {
    dependencies = [
      "date"
      "stringio"
    ];
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hKVLuVLRRgT+oi2Zk4NIgUZ4eC9YsSZI/N+k0vzoWe4=";
      type = "gem";
    };
    version = "5.2.3";
  };
  public_suffix = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YdROHKtcu75bMQaEgc8Wl23Q3BtrB72VYX74xePgDG8=";
      type = "gem";
    };
    version = "6.0.1";
  };
  puma = {
    dependencies = [ "nio4r" ];
    groups = [ "puma" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8lwGhz6z1d5fCk68eDrMgaTM/lgMdgz+MjSXeYAYrYc=";
      type = "gem";
    };
    version = "6.6.0";
  };
  pundit = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Q+bSep3wgsBPACCZnOTc9nQuzFd10QLvK/6d8EFBdXI=";
      type = "gem";
    };
    version = "2.4.0";
  };
  pundit-matchers = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
      "rspec-support"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WdYHeh1XXqfM7KPtc99SV0iO4aER7HB7Knl+dpCM/9U=";
      type = "gem";
    };
    version = "4.0.0";
  };
  racc = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Sn9pKWkdvsi1IJoLNzvCYUiCtV/F0uRHohqqaRMD1i8=";
      type = "gem";
    };
    version = "1.8.1";
  };
  rack = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zO4QFxlpal2hLunab7Ox0gyzKZOeCJ4ORYvm6TZn8Ps=";
      type = "gem";
    };
    version = "2.2.13";
  };
  rack-attack = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PKR+j2bNM7LJavU+pHVFJc2SjtP6jaEO5trQJ3eR13w=";
      type = "gem";
    };
    version = "6.7.0";
  };
  rack-oauth2 = {
    dependencies = [
      "activesupport"
      "attr_required"
      "faraday"
      "faraday-follow_redirects"
      "json-jwt"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xzqofFCAQ+IljwK0+xEMrLqbN9LM+ITiJIfQFKEg0aU=";
      type = "gem";
    };
    version = "2.2.1";
  };
  rack-protection = {
    dependencies = [
      "base64"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PHS6f8WQZkU9Ya+by6W2/nqbPatvRFQY07OR1eqO+/8=";
      type = "gem";
    };
    version = "3.2.0";
  };
  rack-proxy = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RGpLVwAQIhRdXDunO3dfZqImDq90IMaQdIMUGQA5XIo=";
      type = "gem";
    };
    version = "0.7.7";
  };
  rack-session = {
    dependencies = [ "rack" ];
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oCEV5UILTeA2g5uYEeP3ln1zRGpVS0KqRRBq8zWFHXY=";
      type = "gem";
    };
    version = "1.0.2";
  };
  rack-test = {
    dependencies = [ "rack" ];
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AFo2aSwwasC0qTUDVe4ID9Cd3vEUil+LKsY2xyD1xGM=";
      type = "gem";
    };
    version = "2.2.0";
  };
  rackup = {
    dependencies = [
      "rack"
      "webrick"
    ];
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uoZgSiiYn+EEO/8g2BmzYJRMoIFWQGgS3KZ0KySzwkk=";
      type = "gem";
    };
    version = "1.0.1";
  };
  rails = {
    dependencies = [
      "actioncable"
      "actionmailbox"
      "actionmailer"
      "actionpack"
      "actiontext"
      "actionview"
      "activejob"
      "activemodel"
      "activerecord"
      "activestorage"
      "activesupport"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rtsWBLQPTkO16AZuWhqjTa4CwzqpZpsh/USX0PjJu0A=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  rails-controller-testing = {
    dependencies = [
      "actionpack"
      "actionview"
      "activesupport"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dBRI21k2YHPob8llukA/iBxja3miw5pI0EhvJgcYLpQ=";
      type = "gem";
    };
    version = "1.0.5";
  };
  rails-dom-testing = {
    dependencies = [
      "activesupport"
      "minitest"
      "nokogiri"
    ];
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5RVxLkjfH2h6HXw4D9ewe4VY+qJkZEdNpkGDp0JvqTs=";
      type = "gem";
    };
    version = "2.2.0";
  };
  rails-html-sanitizer = {
    dependencies = [
      "loofah"
      "nokogiri"
    ];
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NfziyoJC2od1yDtrqcG8qtZ1HZ63PBq6qEA0dauJpWA=";
      type = "gem";
    };
    version = "1.6.2";
  };
  railties = {
    dependencies = [
      "actionpack"
      "activesupport"
      "irb"
      "rackup"
      "rake"
      "thor"
      "zeitwerk"
    ];
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4/Eb8RbdbQ2HRSKEPMxw7A+J+/7T6cLuSKR3jNBC/h8=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  rainbow = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-A5SRqjqJ9C76HW3sL8TmLt6W62rNleUvGtWBGCt5vGo=";
      type = "gem";
    };
    version = "3.1.1";
  };
  rake = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Rss42uZdfXS2AgpKydSK/tjrgUnAQOzPBSO+yRkHBZ0=";
      type = "gem";
    };
    version = "13.2.1";
  };
  rb-fsevent = {
    groups = [
      "assets"
      "default"
    ];
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
    groups = [
      "assets"
      "default"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oKcARBI5sP8Y62XjhmI2zXhhPWufeP6h+axHqF5Hvm4=";
      type = "gem";
    };
    version = "0.11.1";
  };
  rchardet = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JoiUhs3YOzeGUrr3YD9x2T5DG7Ebwje0zYxlFRr0pZA=";
      type = "gem";
    };
    version = "1.9.0";
  };
  rdoc = {
    dependencies = [ "psych" ];
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vsZvubAZvmT3un0s0q7LKDo6Af7yOpWzPiNJxtGqAEA=";
      type = "gem";
    };
    version = "6.11.0";
  };
  redis = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OH7ghmlP/8ljKq6x7+SnsWJ8p4O/NzMgNGqKIM2TMzo=";
      type = "gem";
    };
    version = "4.8.1";
  };
  regexp_parser = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-y28N3eiHcs1kv/Hbv2jfZtN2BD/i5mqe93/LGwxUjGE=";
      type = "gem";
    };
    version = "2.10.0";
  };
  reline = {
    dependencies = [ "io-console" ];
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-V2IDddy+VuwJuscZK/t0YMcWu/AFTclDReyqVDjlOdI=";
      type = "gem";
    };
    version = "0.6.0";
  };
  rexml = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-x0UnqaCgS07DHb4NxO1gBLlgr5Q9jbQuU57d46hxq8o=";
      type = "gem";
    };
    version = "3.4.1";
  };
  rotp = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ddQAh+Ze0NgCLDMFWmMGwcQA0cEiYZMlM7XWy82GiFQ=";
      type = "gem";
    };
    version = "6.3.0";
  };
  rspec-core = {
    dependencies = [ "rspec-support" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JRNlB/T5zy6Jd6KFHmTkOLQzFkYFTjRZmHFBCHRc3+Q=";
      type = "gem";
    };
    version = "3.13.3";
  };
  rspec-expectations = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Dmta9ZuQAUdpjqD/gEVsTy5pysQ5T705L70cpWH2bFg=";
      type = "gem";
    };
    version = "3.13.3";
  };
  rspec-mocks = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IyczXe8OFmUyWpthfjr5riAnJ0HYCsVQM2MJp8Wave8=";
      type = "gem";
    };
    version = "3.13.2";
  };
  rspec-rails = {
    dependencies = [
      "actionpack"
      "activesupport"
      "railties"
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
      "rspec-support"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4V3Mq+0hHi/ZLyEzDIGa3L6xWRwdZsWA2PLYKIVX4zE=";
      type = "gem";
    };
    version = "7.1.1";
  };
  rspec-retry = {
    dependencies = [ "rspec-core" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YQG6I6OICYEa40hKzeSrSBxU2EasZtUDfMtAExpg2Fg=";
      type = "gem";
    };
    version = "0.6.2";
  };
  rspec-support = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zqOiRj/ZuEudzJaF79gOpwGqj3s97LOzznle1nc32+w=";
      type = "gem";
    };
    version = "3.13.2";
  };
  rszr = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UE4vqD/tus3L0Wr4arZF91HfOEkbJojSdOuOEjjRgpg=";
      type = "gem";
    };
    version = "1.5.0";
  };
  rubocop = {
    dependencies = [
      "json"
      "language_server-protocol"
      "lint_roller"
      "parallel"
      "parser"
      "rainbow"
      "regexp_parser"
      "rubocop-ast"
      "ruby-progressbar"
      "unicode-display_width"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AlmjLYn+5giCv0xNiEfmljV3GcnbSXGDnadCvwU66Ws=";
      type = "gem";
    };
    version = "1.72.2";
  };
  rubocop-ast = {
    dependencies = [ "parser" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-T99nkv5EOpoYrLEtvIIl0NZM0WVOQf7bMOecGO27Jq4=";
      type = "gem";
    };
    version = "1.38.0";
  };
  rubocop-capybara = {
    dependencies = [ "rubocop" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XSZO/di2xwgaPUiJ3s8UUaHPquwgTYFTTiNryCWygKs=";
      type = "gem";
    };
    version = "2.21.0";
  };
  rubocop-factory_bot = {
    dependencies = [ "rubocop" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jeE81O3O5cqADyVRiBZ+zvjb/D0frp8Vc06dLnVTkqo=";
      type = "gem";
    };
    version = "2.26.1";
  };
  rubocop-faker = {
    dependencies = [
      "faker"
      "lint_roller"
      "rubocop"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-y5rBMtRPnS221fn49XFHAL9NJyy671vOQFL0Jw/cXJs=";
      type = "gem";
    };
    version = "1.3.0";
  };
  rubocop-graphql = {
    dependencies = [ "rubocop" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LYiNQLCFd9rx50ykYjvh4wWMGpNUPVpyIIGPVholQZI=";
      type = "gem";
    };
    version = "1.5.4";
  };
  rubocop-inflector = {
    dependencies = [
      "activesupport"
      "rubocop"
      "rubocop-rspec"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-c0jIg6Hax1MosFF3GrfRt04DmCkZl9tJexO+DaiutWs=";
      type = "gem";
    };
    version = "1.0.0";
  };
  rubocop-performance = {
    dependencies = [
      "lint_roller"
      "rubocop"
      "rubocop-ast"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5b05/z42g5W5r4hpJ8w39YkvQ9tL1shSZZQ1LVtEQLU=";
      type = "gem";
    };
    version = "1.24.0";
  };
  rubocop-rails = {
    dependencies = [
      "activesupport"
      "lint_roller"
      "rack"
      "rubocop"
      "rubocop-ast"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GUhDXAAePlmB+QzEUbgA5ThqYJuvio67r0yzEOBxAno=";
      type = "gem";
    };
    version = "2.30.2";
  };
  rubocop-rspec = {
    dependencies = [
      "lint_roller"
      "rubocop"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cQyUL+GviEuo7qdcu4vbsFGSmiIIiApvwuLc4e7VMEw=";
      type = "gem";
    };
    version = "3.5.0";
  };
  rubocop-rspec_rails = {
    dependencies = [
      "rubocop"
      "rubocop-rspec"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iIES6D+dfvetI5fp1poLlhSkuuJPByw5mAShgPgMTEY=";
      type = "gem";
    };
    version = "2.30.0";
  };
  ruby-keycloak-admin = {
    dependencies = [
      "hashie"
      "httparty"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OBAgF7YtchI9GvZizXXslBFCXLeNnKXboHjsysWHbmM=";
      type = "gem";
    };
    version = "26.0.8";
  };
  ruby-progressbar = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gPycR6m2QNaDTg3Hs8lMnfN/CMsHK3dh5KceIs/ymzM=";
      type = "gem";
    };
    version = "1.13.0";
  };
  ruby-saml = {
    dependencies = [
      "nokogiri"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3jQqVZJf1c5hFNCAJlHDJEKMD+wm5/5Svzp8+lTb+m0=";
      type = "gem";
    };
    version = "1.18.0";
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
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hXfIjtwf3ok165EGTFyxrvmtVJS5QM8Zx3Xugz4HVhU=";
      type = "gem";
    };
    version = "2.4.1";
  };
  safety_net_attestation = {
    dependencies = [ "jwt" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lr4tdOftJkU6UYlJE0Sb6g4HL0RJACFUWsLRw4sHGM4=";
      type = "gem";
    };
    version = "0.4.0";
  };
  sass = {
    dependencies = [ "sass-listen" ];
    groups = [
      "assets"
      "default"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gIsNOQU6ppBo35OeJGcf6E/VqdMxRIbhoUV9CTSkJV0=";
      type = "gem";
    };
    version = "3.7.4";
  };
  sass-listen = {
    dependencies = [
      "rb-fsevent"
      "rb-inotify"
    ];
    groups = [
      "assets"
      "default"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rp3Ldt0+I0Mp5bpuIT9I5TLFo+ewtNiofxOqygzBg3c=";
      type = "gem";
    };
    version = "4.0.0";
  };
  sass-rails = {
    dependencies = [
      "railties"
      "sass"
      "sprockets"
      "sprockets-rails"
      "tilt"
    ];
    groups = [ "assets" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lyishuyR1dHC4rS7/gbR8UWfIaycxfdhR2DYzxt3dJM=";
      type = "gem";
    };
    version = "5.1.0";
  };
  securerandom = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zFGT1BSkNBtuIl8MtERqzsqOUNXhiIdD+sFph2OOoLE=";
      type = "gem";
    };
    version = "0.4.1";
  };
  selenium-webdriver = {
    dependencies = [
      "base64"
      "logger"
      "rexml"
      "rubyzip"
      "websocket"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Cn/lPMTSxRWtu4nhFcbnhsZOm5j4WTnSEHHG4yiDoUY=";
      type = "gem";
    };
    version = "4.29.1";
  };
  shoulda-matchers = {
    dependencies = [ "activesupport" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kFW7f0uzQhJfuGCAl5iFXGMOBe9edYN7MWi45u4WCLA=";
      type = "gem";
    };
    version = "6.4.0";
  };
  simple_oauth = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-FHmS4shyxbPLlykuSk7wmcnbt2ESdgACrZPxU02MiTc=";
      type = "gem";
    };
    version = "0.3.1";
  };
  simple_po_parser = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EiaH1E095Rag5p4vODpBgPUBXoxe1afyJY8rN29ky/M=";
      type = "gem";
    };
    version = "1.1.6";
  };
  simpleidn = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CM6W8D+hYFKGviJlG6D8nAstYnLJsnomC8iL4FsNLCk=";
      type = "gem";
    };
    version = "0.2.3";
  };
  slack-notifier = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zZq6P18+Yif3PfH2ozrGwSfF+sNbUTuGt7qQDNmNKwA=";
      type = "gem";
    };
    version = "2.4.0";
  };
  slack-ruby-client = {
    dependencies = [
      "faraday"
      "faraday-mashify"
      "faraday-multipart"
      "gli"
      "hashie"
      "logger"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-r+PJ3e4AymvfiHH+ls7/9N10bsxR9w9+KQMDpKOQPJM=";
      type = "gem";
    };
    version = "2.5.2";
  };
  slop = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dsyrA75mv8q0g4zcB8qwGc0+GSo1OCZiRnSeeeR4iAM=";
      type = "gem";
    };
    version = "3.6.0";
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
  sprockets = {
    dependencies = [
      "base64"
      "concurrent-ruby"
      "rack"
    ];
    groups = [ "assets" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-csIPJWVI+KN/59tB2WvobDJi/dr06+nWnsgxc5T+04M=";
      type = "gem";
    };
    version = "3.7.5";
  };
  sprockets-rails = {
    dependencies = [
      "actionpack"
      "activesupport"
      "sprockets"
    ];
    groups = [
      "assets"
      "default"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qeiObOn4yRLTSapUAVCRZexCMmuvnpQqhd5LdtvEEZ4=";
      type = "gem";
    };
    version = "3.5.2";
  };
  stringio = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IE8YKPhc2znVfKxKvG3ESwRQWiI/ExWH8uIK43KboTE=";
      type = "gem";
    };
    version = "3.1.2";
  };
  swd = {
    dependencies = [
      "activesupport"
      "attr_required"
      "faraday"
      "faraday-follow_redirects"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TNvipCRsGfCT/OIuln7D691GV9N2c2cuYhvwx+t3BlU=";
      type = "gem";
    };
    version = "2.0.3";
  };
  systemu = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AffQFLFFOyjleB4VxNfWP8kiHCmxdLeq5SUyB6dasz4=";
      type = "gem";
    };
    version = "2.6.5";
  };
  tcr = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-frQTvYQHTRNa9Qqm9unc9xXgPcyQ74KGjZRyTlT87dQ=";
      type = "gem";
    };
    version = "0.4.1";
  };
  telegram-bot-ruby = {
    dependencies = [
      "dry-struct"
      "faraday"
      "faraday-multipart"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ROTb3C1R7EjaieSpl5Lsmm+UYgAKRTl7F5hQp7HJuQk=";
      type = "gem";
    };
    version = "2.4.0";
  };
  telephone_number = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EJPHxRO2qwS51UkwyroCSM8o6aaEvhyepZnYd9o06gA=";
      type = "gem";
    };
    version = "1.4.22";
  };
  terser = {
    dependencies = [ "execjs" ];
    groups = [ "assets" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8eSXcLYa9ol3cCF/h8ZXTV5vgYgXEvsPxqYJurDMv6c=";
      type = "gem";
    };
    version = "1.2.5";
  };
  test-unit = {
    dependencies = [ "power_assert" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-w0K7n3M06oSjYbQ8ILBj9AXAvzx9vj/zj2GpFmHSkiE=";
      type = "gem";
    };
    version = "3.6.7";
  };
  thor = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7vApO54kFYzK16s4Oug1NLetTtmcCflvGmsDZVCrvto=";
      type = "gem";
    };
    version = "1.3.2";
  };
  thread_safe = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ntcHKCG1HFfo1rcBGo4oLiWu6jpAZeqzJuQ/ZvBjsFo=";
      type = "gem";
    };
    version = "0.3.6";
  };
  tilt = {
    groups = [
      "assets"
      "default"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Jj10hGbg2D5RCqGi4ige/1R5N/DvBr4z02MnIeJV92s=";
      type = "gem";
    };
    version = "2.6.0";
  };
  timeout = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lQnwebK1X+QjbXljO9deNMHB5+P7S1bLX9ph+AoP4w4=";
      type = "gem";
    };
    version = "0.4.3";
  };
  tpm-key_attestation = {
    dependencies = [
      "bindata"
      "openssl"
      "openssl-signature_algorithm"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0FzFKzl/icNqcwdAfg6E0+ocevzlDgpwsUb4qxfSv0s=";
      type = "gem";
    };
    version = "0.14.0";
  };
  twilio-ruby = {
    dependencies = [
      "benchmark"
      "faraday"
      "jwt"
      "nokogiri"
      "ostruct"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0a1OutWczJomjr23SQUl4ONDwbT2Ny7XxMVLj5i7XuE=";
      type = "gem";
    };
    version = "7.4.5";
  };
  twitter = {
    dependencies = [
      "addressable"
      "buftok"
      "equalizer"
      "http"
      "http-form_data"
      "http_parser.rb"
      "memoizable"
      "multipart-post"
      "naught"
      "simple_oauth"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XjxEk9PAkfxzbgexjTNDk9YBRRT+uFT9VqF6q5+ctY0=";
      type = "gem";
    };
    version = "7.0.0";
  };
  twitter_cldr = {
    dependencies = [
      "base64"
      "camertron-eprun"
      "cldr-plurals-runtime-rb"
      "tzinfo"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XRjCMJcAi82lQqJgU1dm/fxJ2YLV7t8khtGfNoqox6Q=";
      type = "gem";
    };
    version = "6.14.0";
  };
  tzinfo = {
    dependencies = [ "concurrent-ruby" ];
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ja+CjMd7z31jsOO9tsqkfiJy3Pr0+/5G+MOp3wh6gps=";
      type = "gem";
    };
    version = "2.0.6";
  };
  tzinfo-data = {
    dependencies = [ "tzinfo" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LYwaUBqT8myy4KUBnAfx3q73bpnMozCPW9zajkEf3ws=";
      type = "gem";
    };
    version = "1.2025.1";
  };
  unicode-display_width = {
    dependencies = [ "unicode-emoji" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jK8q8cDy8H7InvnhjH2IwnkOIXxIK/x4qqZerdVBWsE=";
      type = "gem";
    };
    version = "3.1.4";
  };
  unicode-emoji = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LCxO9/NT5YCUlxJihaULIwVsxuYbZEM3ZKNe/2w2Uyo=";
      type = "gem";
    };
    version = "4.0.4";
  };
  uri = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6fIkRgjuove8NX2VTGXJEM4DmcpeGKeikgesIth2cBE=";
      type = "gem";
    };
    version = "1.0.3";
  };
  useragent = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cA5kE61LuVS7Y1R/oJjd33sOvnW0DMb5O41UJVsXOEQ=";
      type = "gem";
    };
    version = "0.16.11";
  };
  validate_url = {
    dependencies = [
      "activemodel"
      "public_suffix"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cv4WTAcT1jqZcL1nAL6pSLq7+9zsOS8jQrZwQEL1dFE=";
      type = "gem";
    };
    version = "1.0.15";
  };
  vcr = {
    dependencies = [ "base64" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-N7VuFX5yBEaj9NLTmRnKvvjLe2xFk2rP/S74Ip/sA+0=";
      type = "gem";
    };
    version = "6.3.1";
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
  viewpoint = {
    dependencies = [
      "httpclient"
      "logging"
      "nokogiri"
      "rubyntlm"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gALt3ZoQer/bFfCO6M8xU3YdD9AYd4BMVfU/oB2Me5E=";
      type = "gem";
    };
    version = "1.1.1";
  };
  vite_rails = {
    dependencies = [
      "railties"
      "vite_ruby"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GVxEZ3vAXB+U56afEmTknUutJymrBlOO6FjCli9btQA=";
      type = "gem";
    };
    version = "3.0.19";
  };
  vite_ruby = {
    dependencies = [
      "dry-cli"
      "logger"
      "mutex_m"
      "rack-proxy"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5FhKS6FXhgLxOjrHNAIAeu0ES9Zg2qrCIFI6l8SaTMQ=";
      type = "gem";
    };
    version = "3.9.1";
  };
  webauthn = {
    dependencies = [
      "android_key_attestation"
      "bindata"
      "cbor"
      "cose"
      "openssl"
      "safety_net_attestation"
      "tpm-key_attestation"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oQZl9eBesVa6Ahn9F0gMV+CvTar4Pj4zQ5v5WDUK9MU=";
      type = "gem";
    };
    version = "3.4.0";
  };
  webfinger = {
    dependencies = [
      "activesupport"
      "faraday"
      "faraday-follow_redirects"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VnpSved/s4ymtn5V23VfmIdm7EZRwdJJFqZapwVAaVw=";
      type = "gem";
    };
    version = "2.1.3";
  };
  webmock = {
    dependencies = [
      "addressable"
      "crack"
      "hashdiff"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Vzwj/EiHAIyDDyLaWI2zOco4ttWYVv1X9aBolZR0GY4=";
      type = "gem";
    };
    version = "3.25.0";
  };
  webrick = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tC08lPFm8/tz2H6bNZ3vm1g2xCb8i+rPOPIYSiGyqYk=";
      type = "gem";
    };
    version = "1.9.1";
  };
  websocket = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-t+enTiQQtehcJYWLJrMyLykWHjAJNfcKDg08NeBGJzc=";
      type = "gem";
    };
    version = "1.2.11";
  };
  websocket-driver = {
    dependencies = [
      "base64"
      "websocket-extensions"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BW2Z8s1UVxLPsSkWUP3nR45PJmHcHbag+juWYjGhRrQ=";
      type = "gem";
    };
    version = "0.7.7";
  };
  websocket-extensions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HGumMJLNo0PrU/xlcRDHHHVMVkhKrUJXhJUifXF6gkE=";
      type = "gem";
    };
    version = "0.1.5";
  };
  whatsapp_sdk = {
    dependencies = [
      "faraday"
      "faraday-multipart"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NGukbSWMK11f68vjTsgdy+XhymAKMljnlbBhHIJ+vGw=";
      type = "gem";
    };
    version = "0.13.0";
  };
  write_xlsx = {
    dependencies = [
      "nkf"
      "rubyzip"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/UQqEZCzUd0qVMYBpMHKkBYr56hKIQtWLc+J7UEkluI=";
      type = "gem";
    };
    version = "1.12.1";
  };
  xpath = {
    dependencies = [ "nokogiri" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bf2nnZG7O5SblH7MWRnwQu8vOZuQQBPrPvbSDdOkCC4=";
      type = "gem";
    };
    version = "3.2.0";
  };
  yard = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pukQOZ545hP4C6mt2bp8OUsak18IPMy++CkDo9KiaZI=";
      type = "gem";
    };
    version = "0.9.37";
  };
  zeitwerk = {
    groups = [
      "assets"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CUWYYFDkkHFAiVN4503x/ogqInHtCHzGxtawDUFaJ1Y=";
      type = "gem";
    };
    version = "2.7.1";
  };
  zendesk_api = {
    dependencies = [
      "faraday"
      "faraday-multipart"
      "hashie"
      "inflection"
      "mini_mime"
      "multipart-post"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+FtkYmNyn+6Nw8R/Ars8qvJvFlCglCmd7kbAY+JuchY=";
      type = "gem";
    };
    version = "3.1.1";
  };
}
