{
  aws-eventstream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fqqdqg15rgwgz3mn4pj91agd20csk9gbrhi103d20328dfghsqi";
      type = "gem";
    };
    version = "1.4.0";
  };
  aws-partitions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wy2b87ry659mifl7xbhabaxjy2svqyyxxbicisad7gw6xdhic7m";
      type = "gem";
    };
    version = "1.1125.0";
  };
  aws-sdk-autoscaling = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03c3q5mnb22s4j9cxb67775nigsi5b40x2z6fs3sp7z6af5di592";
      type = "gem";
    };
    version = "1.138.0";
  };
  aws-sdk-cloudwatch = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1w3skqiih37xnckjn8h4ygyrd437914h0q0x836dy85awgqa7jhl";
      type = "gem";
    };
    version = "1.116.0";
  };
  aws-sdk-core = {
    dependencies = [
      "aws-eventstream"
      "aws-partitions"
      "aws-sigv4"
      "base64"
      "jmespath"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1iy9qkwmv9bwfx7ywbp6v0hj2xc8fcmzvsn1b4yqlvpsrisbb1gg";
      type = "gem";
    };
    version = "3.226.2";
  };
  aws-sdk-dynamodb = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0c0ndind40z2l4hp11sxb25ydl817rx8ghjg5x2pxn2vqahinspz";
      type = "gem";
    };
    version = "1.146.0";
  };
  aws-sdk-ec2 = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10x686y2g03l29yhanfp4mwlanfksn0ywh4vr683wd4jzwk5nfay";
      type = "gem";
    };
    version = "1.536.0";
  };
  aws-sdk-efs = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cxnn8sjhx0gfsrclnf32l5v58xk679h69n1jq9834y7pw09j4lm";
      type = "gem";
    };
    version = "1.96.0";
  };
  aws-sdk-elasticache = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12r5yjg5ziwn7r2k9634p3n7rjjkqzmgd1wmn68q9bkprgi4vpaj";
      type = "gem";
    };
    version = "1.128.0";
  };
  aws-sdk-elasticloadbalancing = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qfnnlyp4crwg0xlmgrk12knb8lpgv7k87hyy2nwzlcj3bva0vva";
      type = "gem";
    };
    version = "1.75.0";
  };
  aws-sdk-elasticloadbalancingv2 = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18bmy2vk6ij9380j9wh1dv97kxkzsfxjzx6v61zivncxql8vq3ar";
      type = "gem";
    };
    version = "1.134.0";
  };
  aws-sdk-iam = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0whgr4hz3ck8xn5ap1baqwxwcx89c1nkcmxb4vg19nnfhjlwgvs2";
      type = "gem";
    };
    version = "1.124.0";
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
      sha256 = "01v0a2213fqrgajvafrpmi3n8pmbj1a2xkxfyv5fsvblakqy6dqp";
      type = "gem";
    };
    version = "1.106.0";
  };
  aws-sdk-rds = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1p8hb163yjmiy2jaa3iqp82233f10n7ynz7r9zf0gsq47d12xlac";
      type = "gem";
    };
    version = "1.283.0";
  };
  aws-sdk-redshift = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06a7f895jsn69yk7vj6qbv5pxpdrgcibqmr4s279y4lfvjxm7cz6";
      type = "gem";
    };
    version = "1.141.0";
  };
  aws-sdk-route53 = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1x3qmpz3phy85m3sk4vxsjgc7lqi04dk19l1kmhdj36n3cmkraar";
      type = "gem";
    };
    version = "1.117.0";
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
      sha256 = "1l10lsri5gk0lynz6p51yckvhxygk4g9myznjz62i4lw26s53m0c";
      type = "gem";
    };
    version = "1.192.0";
  };
  aws-sdk-sns = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15jsyq9qcgldpfgw00bkgzfkcmb4h1wkk6r1qswsb2d7blyb2svh";
      type = "gem";
    };
    version = "1.100.0";
  };
  aws-sdk-sqs = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b0b5kf65aaacacq3l0kg9196zjvigf4k3rwakk82sx40wmchaw4";
      type = "gem";
    };
    version = "1.96.0";
  };
  aws-sigv4 = {
    dependencies = [ "aws-eventstream" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "003ch8qzh3mppsxch83ns0jra8d222ahxs96p9cdrl0grfazywv9";
      type = "gem";
    };
    version = "1.12.1";
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
  bigdecimal = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1p2szbr4jdvmwaaj2kxlbv1rp0m6ycbgfyp0kjkkkswmniv5y21r";
      type = "gem";
    };
    version = "3.2.2";
  };
  jmespath = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cdw9vw2qly7q7r41s7phnac264rbsdqgj4l0h4nqgbjb157g393";
      type = "gem";
    };
    version = "1.6.2";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00q2zznygpbls8asz5knjvvj2brr3ghmqxgr83xnrdj4rk3xwvhr";
      type = "gem";
    };
    version = "1.7.0";
  };
  mini_portile2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12f2830x7pq3kj0v8nz0zjvaw02sv01bqs1zwdrc04704kwcgmqc";
      type = "gem";
    };
    version = "2.8.9";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1raim9ddjh672m32psaa9niw67ywzjbxbdb8iijx3wv9k5b0pk2x";
      type = "gem";
    };
    version = "1.12.2";
  };
  nokogiri = {
    dependencies = [
      "mini_portile2"
      "racc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rb306hbky6cxfyc8vrwpvl40fdapjvhsk62h08gg9wwbn3n8x4c";
      type = "gem";
    };
    version = "1.18.8";
  };
  racc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0byn0c9nkahsl93y9ln5bysq4j31q8xkf2ws42swighxd4lnjzsa";
      type = "gem";
    };
    version = "1.8.1";
  };
  terraforming = {
    dependencies = [
      "aws-sdk-autoscaling"
      "aws-sdk-cloudwatch"
      "aws-sdk-dynamodb"
      "aws-sdk-ec2"
      "aws-sdk-efs"
      "aws-sdk-elasticache"
      "aws-sdk-elasticloadbalancing"
      "aws-sdk-elasticloadbalancingv2"
      "aws-sdk-iam"
      "aws-sdk-kms"
      "aws-sdk-rds"
      "aws-sdk-redshift"
      "aws-sdk-route53"
      "aws-sdk-s3"
      "aws-sdk-sns"
      "aws-sdk-sqs"
      "multi_json"
      "thor"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03fyhqx6bxpbn26pbcz748gz7rh7q3r9r0jimq7vj07fl454fmwh";
      type = "gem";
    };
    version = "0.18.0";
  };
  thor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nmymd86a0vb39pzj2cwv57avdrl6pl3lf5bsz58q594kqxjkw7f";
      type = "gem";
    };
    version = "1.3.2";
  };
}
