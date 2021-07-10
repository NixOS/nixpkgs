{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "laravel/installer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-installer-81a82f05803d6be1221bd471d241801c393e72b4";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/installer/zipball/81a82f05803d6be1221bd471d241801c393e72b4";
          sha256 = "09z8pf1ybzw4g86fjvgcdy27shcqg6c858klfnv2aclcbnrrinzr";
        };
      };
    };
    "psr/container" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-container-8622567409010282b7aeebe4bb841fe98b58dcaf";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/container/zipball/8622567409010282b7aeebe4bb841fe98b58dcaf";
          sha256 = "0qfvyfp3mli776kb9zda5cpc8cazj3prk0bg0gm254kwxyfkfrwn";
        };
      };
    };
    "symfony/console" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-console-649730483885ff2ca99ca0560ef0e5f6b03f2ac1";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/console/zipball/649730483885ff2ca99ca0560ef0e5f6b03f2ac1";
          sha256 = "029c1a5hg6d8akflinl5k0hpvfaqmj9plbax9ppsjgxj9jba8aid";
        };
      };
    };
    "symfony/deprecation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-deprecation-contracts-5f38c8804a9e97d23e0c8d63341088cd8a22d627";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/deprecation-contracts/zipball/5f38c8804a9e97d23e0c8d63341088cd8a22d627";
          sha256 = "11k6a8v9b6p0j788fgykq6s55baba29lg37fwvmn4igxxkfwmbp3";
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-46cd95797e9df938fdd2b03693b5fca5e64b01ce";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-ctype/zipball/46cd95797e9df938fdd2b03693b5fca5e64b01ce";
          sha256 = "0z4iiznxxs4r72xs4irqqb6c0wnwpwf0hklwn2imls67haq330zn";
        };
      };
    };
    "symfony/polyfill-intl-grapheme" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-grapheme-24b72c6baa32c746a4d0840147c9715e42bb68ab";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-grapheme/zipball/24b72c6baa32c746a4d0840147c9715e42bb68ab";
          sha256 = "1ddgvsr2k585mj2vr3z1q56kxdbb5fin7y0ixhb1791x36km77f3";
        };
      };
    };
    "symfony/polyfill-intl-normalizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-normalizer-8590a5f561694770bdcd3f9b5c69dde6945028e8";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-normalizer/zipball/8590a5f561694770bdcd3f9b5c69dde6945028e8";
          sha256 = "1c60xin00q0d2gbyaiglxppn5hqwki616v5chzwyhlhf6aplwsh3";
        };
      };
    };
    "symfony/polyfill-mbstring" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-mbstring-2df51500adbaebdc4c38dea4c89a2e131c45c8a1";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-mbstring/zipball/2df51500adbaebdc4c38dea4c89a2e131c45c8a1";
          sha256 = "1fbi13p4a6nn01ix3gcj966kq6z8qx03li4vbjylsr9ac2mgnmnn";
        };
      };
    };
    "symfony/polyfill-php73" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php73-fba8933c384d6476ab14fb7b8526e5287ca7e010";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php73/zipball/fba8933c384d6476ab14fb7b8526e5287ca7e010";
          sha256 = "0fc1d60iw8iar2zcvkzwdvx0whkbw8p6ll0cry39nbkklzw85n1h";
        };
      };
    };
    "symfony/polyfill-php80" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php80-eca0bf41ed421bed1b57c4958bab16aa86b757d0";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php80/zipball/eca0bf41ed421bed1b57c4958bab16aa86b757d0";
          sha256 = "1y5kc4vqh920wyjdlgxp23b958g5i9mw10mhbr30vf8j20vf1gra";
        };
      };
    };
    "symfony/process" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-process-714b47f9196de61a196d86c4bad5f09201b307df";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/process/zipball/714b47f9196de61a196d86c4bad5f09201b307df";
          sha256 = "0r81fm2irx0vzwm9g5gj6lkz8adxvzv3d5ydxvn6ndbaznxck0cn";
        };
      };
    };
    "symfony/service-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-service-contracts-f040a30e04b57fbcc9c6cbcf4dbaa96bd318b9bb";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/service-contracts/zipball/f040a30e04b57fbcc9c6cbcf4dbaa96bd318b9bb";
          sha256 = "1i573rmajc33a9nrgwgc4k3svg29yp9xv17gp133rd1i705hwv1y";
        };
      };
    };
    "symfony/string" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-string-bd53358e3eccec6a670b5f33ab680d8dbe1d4ae1";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/string/zipball/bd53358e3eccec6a670b5f33ab680d8dbe1d4ae1";
          sha256 = "0p71gvinzbi0zv6f1dizjxv18rrazv56pmmdxjz59gb0p5m01yhn";
        };
      };
    };
  };
  devPackages = {};
in
composerEnv.buildPackage {
  inherit packages devPackages noDev;
  name = "laravel-installer";
  src = ./.;
  executable = true;
  symlinkDependencies = false;
  meta = {};
}
