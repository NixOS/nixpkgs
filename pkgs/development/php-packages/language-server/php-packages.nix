{ composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null }:

let
  packages = {
    "composer/xdebug-handler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-xdebug-handler-46867cbf8ca9fb8d60c506895449eb799db1184f";
        src = fetchurl {
          url = https://api.github.com/repos/composer/xdebug-handler/zipball/46867cbf8ca9fb8d60c506895449eb799db1184f;
          sha256 = "0y4axhr65ygd2a619xrbfd3yr02jxnazf3clfxrzd63m1jwc5mmx";
        };
      };
    };
    "felixfbecker/advanced-json-rpc" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "felixfbecker-advanced-json-rpc-241c470695366e7b83672be04ea0e64d8085a551";
        src = fetchurl {
          url = https://api.github.com/repos/felixfbecker/php-advanced-json-rpc/zipball/241c470695366e7b83672be04ea0e64d8085a551;
          sha256 = "0pwb1826sf01wv9baziqavd3465629dlnmz9a0slipgcs494znjv";
        };
      };
    };
    "felixfbecker/language-server" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "felixfbecker-language-server-1da3328bc23ebd6418529035d357481c8c028640";
        src = fetchurl {
          url = https://api.github.com/repos/felixfbecker/php-language-server/zipball/1da3328bc23ebd6418529035d357481c8c028640;
          sha256 = "0958bsdipzvhfhxlc1arpr3yf5g6dmq5vw5ms8784jq000s7bbik";
        };
      };
    };
    "felixfbecker/language-server-protocol" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "felixfbecker-language-server-protocol-378801f6139bb74ac215d81cca1272af61df9a9f";
        src = fetchurl {
          url = https://api.github.com/repos/felixfbecker/php-language-server-protocol/zipball/378801f6139bb74ac215d81cca1272af61df9a9f;
          sha256 = "0s1rmz04rr279q899915haiwci037rvrc3swaxksiycnk3x7vf4g";
        };
      };
    };
    "jetbrains/phpstorm-stubs" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "jetbrains-phpstorm-stubs-be2b7a60102f0ca0a9b9007c00268d3150928ab9";
        src = fetchurl {
          url = https://api.github.com/repos/JetBrains/phpstorm-stubs/zipball/be2b7a60102f0ca0a9b9007c00268d3150928ab9;
          sha256 = "0as4flnzmyjsjmsml0fkdy3yq05j3cx2128fk7k66dvin8snhimh";
        };
      };
    };
    "microsoft/tolerant-php-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "microsoft-tolerant-php-parser-e255aa978b45729094da2a1a6f9954044a244ff2";
        src = fetchurl {
          url = https://api.github.com/repos/microsoft/tolerant-php-parser/zipball/e255aa978b45729094da2a1a6f9954044a244ff2;
          sha256 = "0592m2jl4anhpmmi31p8iwrwy7fp7qv4crz89963qf656wkhvc4l";
        };
      };
    };
    "netresearch/jsonmapper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "netresearch-jsonmapper-caf41ab74ac7252f5f46db6c16ab0a8358e2e55c";
        src = fetchurl {
          url = https://api.github.com/repos/cweiske/jsonmapper/zipball/caf41ab74ac7252f5f46db6c16ab0a8358e2e55c;
          sha256 = "10r39pd5d1mam71s6599i3npdqq8ijbi9rz4y7iq2hmlgimaw2pd";
        };
      };
    };
    "phpdocumentor/reflection-common" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpdocumentor-reflection-common-21bdeb5f65d7ebf9f43b1b25d404f87deab5bfb6";
        src = fetchurl {
          url = https://api.github.com/repos/phpDocumentor/ReflectionCommon/zipball/21bdeb5f65d7ebf9f43b1b25d404f87deab5bfb6;
          sha256 = "1yaf1zg9lnkfnq2ndpviv0hg5bza9vjvv5l4wgcn25lx1p8a94w2";
        };
      };
    };
    "phpdocumentor/reflection-docblock" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpdocumentor-reflection-docblock-bdd9f737ebc2a01c06ea7ff4308ec6697db9b53c";
        src = fetchurl {
          url = https://api.github.com/repos/phpDocumentor/ReflectionDocBlock/zipball/bdd9f737ebc2a01c06ea7ff4308ec6697db9b53c;
          sha256 = "12drhwbrzyl7n8kpcnzjdfwzf7fyda2da1sd65s3rqr6q9l0wz1s";
        };
      };
    };
    "phpdocumentor/type-resolver" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpdocumentor-type-resolver-9c977708995954784726e25d0cd1dddf4e65b0f7";
        src = fetchurl {
          url = https://api.github.com/repos/phpDocumentor/TypeResolver/zipball/9c977708995954784726e25d0cd1dddf4e65b0f7;
          sha256 = "0h888r2iy2290yp9i3fij8wd5b7960yi7yn1rwh26x1xxd83n2mb";
        };
      };
    };
    "psr/log" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-log-6c001f1daafa3a3ac1d8ff69ee4db8e799a654dd";
        src = fetchurl {
          url = https://api.github.com/repos/php-fig/log/zipball/6c001f1daafa3a3ac1d8ff69ee4db8e799a654dd;
          sha256 = "1i351p3gd1pgjcjxv7mwwkiw79f1xiqr38irq22156h05zlcx80d";
        };
      };
    };
    "sabre/event" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sabre-event-f5cf802d240df1257866d8813282b98aee3bc548";
        src = fetchurl {
          url = https://api.github.com/repos/sabre-io/event/zipball/f5cf802d240df1257866d8813282b98aee3bc548;
          sha256 = "1003imr8dl8cdpybkg0r959hl0gipfrnidhp7r60bqfyriwczc9a";
        };
      };
    };
    "sabre/uri" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sabre-uri-c260a55cbd2083c03484f56f72fe042fee0c17ed";
        src = fetchurl {
          url = https://api.github.com/repos/sabre-io/uri/zipball/c260a55cbd2083c03484f56f72fe042fee0c17ed;
          sha256 = "0cqgy35w94vm0riijgsn6dj24lr9ngn5in8r3j004bczgc5p3kc7";
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-82ebae02209c21113908c229e9883c419720738a";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-ctype/zipball/82ebae02209c21113908c229e9883c419720738a;
          sha256 = "1p3grd56c4agrv3v5lfnsi0ryghha7f0jx5hqs2lj7hvcx1fzam5";
        };
      };
    };
    "webmozart/assert" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "webmozart-assert-83e253c8e0be5b0257b881e1827274667c5c17a9";
        src = fetchurl {
          url = https://api.github.com/repos/webmozart/assert/zipball/83e253c8e0be5b0257b881e1827274667c5c17a9;
          sha256 = "0d84b0ms9mjpqx368gs7c3qs06mpbx5565j3vs43b1ygnyhhhaqk";
        };
      };
    };
    "webmozart/glob" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "webmozart-glob-3cbf63d4973cf9d780b93d2da8eec7e4a9e63bbe";
        src = fetchurl {
          url = https://api.github.com/repos/webmozart/glob/zipball/3cbf63d4973cf9d780b93d2da8eec7e4a9e63bbe;
          sha256 = "1x5bzc9lyhmh9bf7ji2hs5srz2w7mjk919sm2h68v1x2xn7892s9";
        };
      };
    };
    "webmozart/path-util" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "webmozart-path-util-d939f7edc24c9a1bb9c0dee5cb05d8e859490725";
        src = fetchurl {
          url = https://api.github.com/repos/webmozart/path-util/zipball/d939f7edc24c9a1bb9c0dee5cb05d8e859490725;
          sha256 = "0zv2di0fh3aiwij0nl6595p8qvm9zh0k8jd3ngqhmqnis35kr01l";
        };
      };
    };
  };
  devPackages = {};
in {
  inherit packages devPackages;
}
