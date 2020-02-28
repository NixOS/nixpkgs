{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "composer/ca-bundle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-ca-bundle-47fe531de31fca4a1b997f87308e7d7804348f7e";
        src = fetchurl {
          url = https://api.github.com/repos/composer/ca-bundle/zipball/47fe531de31fca4a1b997f87308e7d7804348f7e;
          sha256 = "0cvmfh4d5v4ws5sc1c9g57wvq5zfxj9biljq586kcl4j43c6pyis";
        };
      };
    };
    "composer/composer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-composer-1291a16ce3f48bfdeca39d64fca4875098af4d7b";
        src = fetchurl {
          url = https://api.github.com/repos/composer/composer/zipball/1291a16ce3f48bfdeca39d64fca4875098af4d7b;
          sha256 = "0314d43x338rsbqkx8gdhk9s6yn8r7jbfh30iwn2bb3asjj0ymjj";
        };
      };
    };
    "composer/semver" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-semver-c6bea70230ef4dd483e6bbcab6005f682ed3a8de";
        src = fetchurl {
          url = https://api.github.com/repos/composer/semver/zipball/c6bea70230ef4dd483e6bbcab6005f682ed3a8de;
          sha256 = "11f4az7s736nj8n52wjanlpcpfk8ijx9wii5wmwbylp0s4s20ryd";
        };
      };
    };
    "composer/spdx-licenses" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-spdx-licenses-0c3e51e1880ca149682332770e25977c70cf9dae";
        src = fetchurl {
          url = https://api.github.com/repos/composer/spdx-licenses/zipball/0c3e51e1880ca149682332770e25977c70cf9dae;
          sha256 = "11cbifgnby63qfl7xsp5hs1z4x7s5p2p4yxcbh3m3c5wrp8n8ykl";
        };
      };
    };
    "composer/xdebug-handler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-xdebug-handler-1ab9842d69e64fb3a01be6b656501032d1b78cb7";
        src = fetchurl {
          url = https://api.github.com/repos/composer/xdebug-handler/zipball/1ab9842d69e64fb3a01be6b656501032d1b78cb7;
          sha256 = "0h3p8wmabfqrvnx10kn1ayp3x3d9g70l1w8gqbafpcq5kcw4z5g5";
        };
      };
    };
    "dantleech/invoke" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dantleech-invoke-cd7a41cc2a915939fab12720dffe1f41684848f4";
        src = fetchurl {
          url = https://api.github.com/repos/dantleech/invoke/zipball/cd7a41cc2a915939fab12720dffe1f41684848f4;
          sha256 = "1dpgdl9vjvjyrjcsjpinxkgphbgkfz13bxsjlhszr09jw66v9qdh";
        };
      };
    };
    "dnoegel/php-xdg-base-dir" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dnoegel-php-xdg-base-dir-8f8a6e48c5ecb0f991c2fdcf5f154a47d85f9ffd";
        src = fetchurl {
          url = https://api.github.com/repos/dnoegel/php-xdg-base-dir/zipball/8f8a6e48c5ecb0f991c2fdcf5f154a47d85f9ffd;
          sha256 = "02n4b4wkwncbqiz8mw2rq35flkkhn7h6c0bfhjhs32iay1y710fq";
        };
      };
    };
    "jetbrains/phpstorm-stubs" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "jetbrains-phpstorm-stubs-883b6facd78e01c0743b554af86fa590c2573f40";
        src = fetchurl {
          url = https://api.github.com/repos/JetBrains/phpstorm-stubs/zipball/883b6facd78e01c0743b554af86fa590c2573f40;
          sha256 = "1hx3vrqw3k4kp2sjvvckbpn2dghzpacxzs2h4gl09hyj2cdm2rn4";
        };
      };
    };
    "justinrainbow/json-schema" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "justinrainbow-json-schema-44c6787311242a979fa15c704327c20e7221a0e4";
        src = fetchurl {
          url = https://api.github.com/repos/justinrainbow/json-schema/zipball/44c6787311242a979fa15c704327c20e7221a0e4;
          sha256 = "12a75nyv59pd8kx18w7vlsp2xwwjk9ynbzkkx56mcf1payinwpr1";
        };
      };
    };
    "microsoft/tolerant-php-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "microsoft-tolerant-php-parser-c5e2bf5d8c9f4f27eef1370bd39ea2d1f374eeb4";
        src = fetchurl {
          url = https://api.github.com/repos/microsoft/tolerant-php-parser/zipball/c5e2bf5d8c9f4f27eef1370bd39ea2d1f374eeb4;
          sha256 = "1rspicyvlh02mbrdvnfazz0b4w9f81kj267m5qldd0dz5lfmzirq";
        };
      };
    };
    "monolog/monolog" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "monolog-monolog-fa82921994db851a8becaf3787a9e73c5976b6f1";
        src = fetchurl {
          url = https://api.github.com/repos/Seldaek/monolog/zipball/fa82921994db851a8becaf3787a9e73c5976b6f1;
          sha256 = "0vcn1j16pjbya65cd3c8wm4383mi96l5ys195ni8nvchna7a6b6v";
        };
      };
    };
    "ocramius/package-versions" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ocramius-package-versions-1d32342b8c1eb27353c8887c366147b4c2da673c";
        src = fetchurl {
          url = https://api.github.com/repos/Ocramius/PackageVersions/zipball/1d32342b8c1eb27353c8887c366147b4c2da673c;
          sha256 = "1bdi6lfb8l4aa9161a2wa72hcqg8j33irv748sbqgz6rpd88m6ns";
        };
      };
    };
    "phpactor/class-mover" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-class-mover-4023cfd6c4668038bd40ac9b384695d8a9a9dc9d";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/class-mover/zipball/4023cfd6c4668038bd40ac9b384695d8a9a9dc9d;
          sha256 = "1w365ah6rvv1b9bgdzhnxjpam7k5bgiyjglf8j6b4xgwxk32w1nw";
        };
      };
    };
    "phpactor/class-to-file" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-class-to-file-fd360d8c2c2dbd2314ace81f0467bf36269b4ef2";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/class-to-file/zipball/fd360d8c2c2dbd2314ace81f0467bf36269b4ef2;
          sha256 = "19lblx5bl3qhcphgy3r2cywdq38kb23fi2is6ry7aq0vzf0lxbr7";
        };
      };
    };
    "phpactor/class-to-file-extension" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-class-to-file-extension-f7bc66301f996f316386eccda642874e3a4d424e";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/class-to-file-extension/zipball/f7bc66301f996f316386eccda642874e3a4d424e;
          sha256 = "015vs850bsfhh0n3i6pb607dkfd21qw2593p81jq218ha742b7b7";
        };
      };
    };
    "phpactor/code-builder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-code-builder-2ed43ab30433557671b95fe0cbe2b533e2891638";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/code-builder/zipball/2ed43ab30433557671b95fe0cbe2b533e2891638;
          sha256 = "0lf4yg1dfqlbccikm1j0smbxxj19z5p63vizdz97phwv78jbzwwn";
        };
      };
    };
    "phpactor/code-transform" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-code-transform-e6d7c309d4b9e3c92bfb34be980bf3f4d41e8c8b";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/code-transform/zipball/e6d7c309d4b9e3c92bfb34be980bf3f4d41e8c8b;
          sha256 = "03ldnjv908j323wp6ij5cg7iqckag419yi8ywhv51nq3wwl1g952";
        };
      };
    };
    "phpactor/code-transform-extension" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-code-transform-extension-559a3d6264293193e18bcaa6001625944fe0474f";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/code-transform-extension/zipball/559a3d6264293193e18bcaa6001625944fe0474f;
          sha256 = "1q1n4q7iix1lywpprz0safmjyxcb2455hppsx29www7fdf5cvym4";
        };
      };
    };
    "phpactor/completion" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-completion-8532f9f43d67149d7db72415133d7a166a6badaa";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/completion/zipball/8532f9f43d67149d7db72415133d7a166a6badaa;
          sha256 = "00vbpsyif5ddf17nhglh4agm49yl622bknwypk9fjvv8527dwz8a";
        };
      };
    };
    "phpactor/completion-extension" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-completion-extension-50229428b5ffba89683b9e3d6f9dbe44c3111eba";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/completion-extension/zipball/50229428b5ffba89683b9e3d6f9dbe44c3111eba;
          sha256 = "03h7j71g18ih3k98wvz6rjx9607qp8xlrsha67gpd0vm2c2kwf33";
        };
      };
    };
    "phpactor/completion-rpc-extension" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-completion-rpc-extension-f43140000878d36280cbdde4f56e362c2f23f546";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/completion-rpc-extension/zipball/f43140000878d36280cbdde4f56e362c2f23f546;
          sha256 = "1hjcgaqqlmjwfrhdpdmyy6gpr330as57i60954rlybcv34h83gdi";
        };
      };
    };
    "phpactor/completion-worse-extension" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-completion-worse-extension-3f381acce7d3e6b936bc9b711559316c210ceff9";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/completion-worse-extension/zipball/3f381acce7d3e6b936bc9b711559316c210ceff9;
          sha256 = "0dbvf1xq6wg6qqmvw135cmkb8dxp4pz1q3fw5mni8zzc9gpmi0ps";
        };
      };
    };
    "phpactor/composer-autoloader-extension" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-composer-autoloader-extension-6ef27b06a49f39db92380833d24d7f92eca363b6";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/composer-autoloader-extension/zipball/6ef27b06a49f39db92380833d24d7f92eca363b6;
          sha256 = "1fy9135vkv7ldzpz8q8li541683n9qdlahy7cncx92mlz0937rqz";
        };
      };
    };
    "phpactor/config-loader" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-config-loader-61db28afa005ac814d7cf48fce70f07e897e038c";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/config-loader/zipball/61db28afa005ac814d7cf48fce70f07e897e038c;
          sha256 = "09zj6ahzanwkf1cfhjl5pjg972mpi3n7xv91qz493kn4zwxll0q5";
        };
      };
    };
    "phpactor/console-extension" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-console-extension-9ab457cad36db38e78a6044ed5d0f848fe0b453d";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/console-extension/zipball/9ab457cad36db38e78a6044ed5d0f848fe0b453d;
          sha256 = "18255qz4dva8x3bay8i0bdn2y9ga0r3qkva714hxy2sh3ixpn3fm";
        };
      };
    };
    "phpactor/container" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-container-a69e6f13bd8fd3b227efa7b8bf126aa6ed45f0b8";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/container/zipball/a69e6f13bd8fd3b227efa7b8bf126aa6ed45f0b8;
          sha256 = "1fd54h7z7qkd8a1wk7ysplj560z9w8gbbnpw7v0jqhs7phl4qmxc";
        };
      };
    };
    "phpactor/docblock" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-docblock-1e5fe9047565cce85262f2dc1a8cdee59992a592";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/docblock/zipball/1e5fe9047565cce85262f2dc1a8cdee59992a592;
          sha256 = "1cl6i0k9bffx94md28zsmjl06lrzxx3n3wl2gkl01aj1ngh9qbm2";
        };
      };
    };
    "phpactor/extension-manager-extension" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-extension-manager-extension-71cb61651fb7f8a8cb082f773cc8c423a78a7420";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/extension-manager-extension/zipball/71cb61651fb7f8a8cb082f773cc8c423a78a7420;
          sha256 = "0223ajqpkcyjbacmk0gx7145zr3ykf1891xx5f9xwjifsjii5gja";
        };
      };
    };
    "phpactor/file-path-resolver" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-file-path-resolver-ce9d5cd905c538ee12b1cd250e2b029dabfef8c7";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/file-path-resolver/zipball/ce9d5cd905c538ee12b1cd250e2b029dabfef8c7;
          sha256 = "1anrqa7jskfgcvv7w6wv5whs3a28v254k1pfw4az5phdhvmnhn1q";
        };
      };
    };
    "phpactor/file-path-resolver-extension" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-file-path-resolver-extension-b6ba9a84ffd6bd718111aa3586a4c8d9d2d96e10";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/file-path-resolver-extension/zipball/b6ba9a84ffd6bd718111aa3586a4c8d9d2d96e10;
          sha256 = "1iw0vg138jbmdvdsxcgiyhjjbn4j0ym1hc5qx7rvzqni344axzwj";
        };
      };
    };
    "phpactor/logging-extension" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-logging-extension-306149d2ab1582ff389a71fce45d270f5f7c9ac1";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/logging-extension/zipball/306149d2ab1582ff389a71fce45d270f5f7c9ac1;
          sha256 = "07izms1iqsrzzgcx547wgprh1wz0pcqqc8j3w607vrkxi9cv9pk2";
        };
      };
    };
    "phpactor/map-resolver" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-map-resolver-21ef588c9861863d56ffaa7ae19a5e99dc07b30d";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/map-resolver/zipball/21ef588c9861863d56ffaa7ae19a5e99dc07b30d;
          sha256 = "01mp1s2h1l4l9vll21xi8349a6ab8np07vn5hbpjbl4nykyd36dq";
        };
      };
    };
    "phpactor/name-specification" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-name-specification-336e7c7ccf85e7c438ec8397c9e924259f9a135e";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/name/zipball/336e7c7ccf85e7c438ec8397c9e924259f9a135e;
          sha256 = "0rn485l90pww1f3w6y1blrki8c46ggnpi6is1svxcz1x0m1ps9kl";
        };
      };
    };
    "phpactor/path-finder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-path-finder-14f4c7a658ea501e7679d27bbf5d2abec1a9ad07";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/path-finder/zipball/14f4c7a658ea501e7679d27bbf5d2abec1a9ad07;
          sha256 = "1f8w2jm5cnwbx1sz758zf2g9q2bmgj7r11vqz4axfb0z451rcrdy";
        };
      };
    };
    "phpactor/phpactor" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-phpactor-c44f7f34c56660a62c5af0a462a829a983db2d07";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/phpactor/zipball/c44f7f34c56660a62c5af0a462a829a983db2d07;
          sha256 = "05bbh1ynqpvg6icis2674svz6n44h8vd7lbqf51wv0p6cdjyxrjb";
        };
      };
    };
    "phpactor/reference-finder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-reference-finder-e8037b1a08f9fe4d1569b92e3f8e387968cf6410";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/reference-finder/zipball/e8037b1a08f9fe4d1569b92e3f8e387968cf6410;
          sha256 = "1s6klkhp3q4kpn4yr7yg23g3m7gzh65zhxbr97vp61s459ryj6i4";
        };
      };
    };
    "phpactor/reference-finder-extension" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-reference-finder-extension-a0eae6ad2194c48d3908b4d685bd2fd8f8dfb44d";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/reference-finder-extension/zipball/a0eae6ad2194c48d3908b4d685bd2fd8f8dfb44d;
          sha256 = "0y3391d4mhgj6bd7k6h8w4rv9wdbhkk13c01n2bibrf3cg3cp412";
        };
      };
    };
    "phpactor/reference-finder-rpc-extension" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-reference-finder-rpc-extension-d503e508b2ea2789f70696b0becaa97af9a54c80";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/reference-finder-rpc-extension/zipball/d503e508b2ea2789f70696b0becaa97af9a54c80;
          sha256 = "05kvjpj3873r67abcq1ikb35wlnp5v8gx3n3r0w80hlc326v9lxm";
        };
      };
    };
    "phpactor/rpc-extension" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-rpc-extension-8ed9a1709c885b87415341897387cb34dad2bd94";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/rpc-extension/zipball/8ed9a1709c885b87415341897387cb34dad2bd94;
          sha256 = "0zhvcmlsdhn1yjqm1nm8j78rfxq70gq3v4lhw57gs788xjxhgnyp";
        };
      };
    };
    "phpactor/source-code-filesystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-source-code-filesystem-72f53091d3692324ccde5d98cd9b666963884c9f";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/source-code-filesystem/zipball/72f53091d3692324ccde5d98cd9b666963884c9f;
          sha256 = "0akkxjz4pz1kvdavwjnka133qrmpkn6ikgcbwv6rqmq26bwaiqcm";
        };
      };
    };
    "phpactor/source-code-filesystem-extension" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-source-code-filesystem-extension-0a83f0a9c51d3a83b9a3c91290aa822315cb7cf3";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/source-code-filesystem-extension/zipball/0a83f0a9c51d3a83b9a3c91290aa822315cb7cf3;
          sha256 = "0gr073rzbg7k0w4i6b6npp850nknd8nf7w6c53afdcy7sz0b34wi";
        };
      };
    };
    "phpactor/text-document" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-text-document-e4ec801b3569ed7107d53400498e253f1f78524b";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/text-document/zipball/e4ec801b3569ed7107d53400498e253f1f78524b;
          sha256 = "1mpbswvpa4gmp05p75fxr7cj1wr8j5dhqy708c9nqr9mcd17avlr";
        };
      };
    };
    "phpactor/worse-reference-finder-extension" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-worse-reference-finder-extension-f033cc54e7457dd9d5dfd7964bd800cf7fa9f4bb";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/worse-reference-finder-extension/zipball/f033cc54e7457dd9d5dfd7964bd800cf7fa9f4bb;
          sha256 = "0qfi84y2mgswxmarq58fi933g4rfl8bfvd7ynw0422x5miy0k65a";
        };
      };
    };
    "phpactor/worse-reference-finders" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-worse-reference-finders-30945125d5d537e003de04386af2c47057f73fc7";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/worse-reference-finder/zipball/30945125d5d537e003de04386af2c47057f73fc7;
          sha256 = "1qr7g63gbrxh23a11xf055bwqxj8caqc81xf8f979i6c8ky9v3d1";
        };
      };
    };
    "phpactor/worse-reflection" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-worse-reflection-c6fa8bd9813fda04c80c80d1d8f8d45f6452444f";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/worse-reflection/zipball/c6fa8bd9813fda04c80c80d1d8f8d45f6452444f;
          sha256 = "1hzgsmkywxvv3f9wrchx86grv9c636khnrw9rhc2xlq1p1xjc89a";
        };
      };
    };
    "phpactor/worse-reflection-extension" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpactor-worse-reflection-extension-f050c7a070f0bb642093ba52ca699daeb187be9b";
        src = fetchurl {
          url = https://api.github.com/repos/phpactor/worse-reflection-extension/zipball/f050c7a070f0bb642093ba52ca699daeb187be9b;
          sha256 = "0y205ji6ws078slmicvlcv452q3z8vhl5gzj61xsrrzk2akmfdcf";
        };
      };
    };
    "psr/container" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-container-b7ce3b176482dbbc1245ebf52b181af44c2cf55f";
        src = fetchurl {
          url = https://api.github.com/repos/php-fig/container/zipball/b7ce3b176482dbbc1245ebf52b181af44c2cf55f;
          sha256 = "0rkz64vgwb0gfi09klvgay4qnw993l1dc03vyip7d7m2zxi6cy4j";
        };
      };
    };
    "psr/log" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-log-446d54b4cb6bf489fc9d75f55843658e6f25d801";
        src = fetchurl {
          url = https://api.github.com/repos/php-fig/log/zipball/446d54b4cb6bf489fc9d75f55843658e6f25d801;
          sha256 = "04baykaig5nmxsrwmzmcwbs60ixilcx1n0r9wdcnvxnnj64cf2kr";
        };
      };
    };
    "sebastian/diff" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-diff-720fcc7e9b5cf384ea68d9d930d480907a0c1a29";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/diff/zipball/720fcc7e9b5cf384ea68d9d930d480907a0c1a29;
          sha256 = "0i81kz91grz5vzifw114kg6dcfh150019zid7j99j2y5w7s1fqq2";
        };
      };
    };
    "seld/jsonlint" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "seld-jsonlint-e2e5d290e4d2a4f0eb449f510071392e00e10d19";
        src = fetchurl {
          url = https://api.github.com/repos/Seldaek/jsonlint/zipball/e2e5d290e4d2a4f0eb449f510071392e00e10d19;
          sha256 = "10y2d9fjmhnvr9sclmc1phkasplg0iczvj7d2y6i3x3jinb9sgnb";
        };
      };
    };
    "seld/phar-utils" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "seld-phar-utils-8800503d56b9867d43d9c303b9cbcc26016e82f0";
        src = fetchurl {
          url = https://api.github.com/repos/Seldaek/phar-utils/zipball/8800503d56b9867d43d9c303b9cbcc26016e82f0;
          sha256 = "1y7dqszq0rg07s1m7sg56dbqm1l61pfrrlh4mibm97xl4qfjxqza";
        };
      };
    };
    "symfony/console" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-console-4fa15ae7be74e53f6ec8c83ed403b97e23b665e9";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/console/zipball/4fa15ae7be74e53f6ec8c83ed403b97e23b665e9;
          sha256 = "08l9r0mjscj62d80gcrky2vxr3rkc0887bhcrdmj5hfvg5a5ap5p";
        };
      };
    };
    "symfony/filesystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-filesystem-266c9540b475f26122b61ef8b23dd9198f5d1cfd";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/filesystem/zipball/266c9540b475f26122b61ef8b23dd9198f5d1cfd;
          sha256 = "10hyamgfgzp16yl0imv55k3r675zm47lrs1i0mcvqsxqd0gz4pl3";
        };
      };
    };
    "symfony/finder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-finder-ea69c129aed9fdeca781d4b77eb20b62cf5d5357";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/finder/zipball/ea69c129aed9fdeca781d4b77eb20b62cf5d5357;
          sha256 = "1k57fzn92pxvbcvvb9z2j7iibi2y4pg1gn8fcqrn678hdnpg9vl7";
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-fbdeaec0df06cf3d51c93de80c7eb76e271f5a38";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-ctype/zipball/fbdeaec0df06cf3d51c93de80c7eb76e271f5a38;
          sha256 = "0ni2ldyfzdvchi4prlqyy5gr833z5mnnhm65l331jsdvzk2m53hk";
        };
      };
    };
    "symfony/polyfill-mbstring" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-mbstring-34094cfa9abe1f0f14f48f490772db7a775559f2";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-mbstring/zipball/34094cfa9abe1f0f14f48f490772db7a775559f2;
          sha256 = "1lnrmk1yrv9cbs7kb2cwfgqzq1hwl135bhbkr6yyayfk67zs3rqa";
        };
      };
    };
    "symfony/polyfill-php73" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php73-5e66a0fa1070bf46bec4bea7962d285108edd675";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-php73/zipball/5e66a0fa1070bf46bec4bea7962d285108edd675;
          sha256 = "05892z9cwfa7w8l6dc5xbvh7qp0mbyl25ixaz2xdm7yhi3rglymd";
        };
      };
    };
    "symfony/process" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-process-bf9166bac906c9e69fb7a11d94875e7ced97bcd7";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/process/zipball/bf9166bac906c9e69fb7a11d94875e7ced97bcd7;
          sha256 = "1h1q95xkzbj7mjq4rqhwpqabvzqs0i6kv4p94ygqsmfm9zv4vjbx";
        };
      };
    };
    "symfony/service-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-service-contracts-144c5e51266b281231e947b51223ba14acf1a749";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/service-contracts/zipball/144c5e51266b281231e947b51223ba14acf1a749;
          sha256 = "0k76dm3f61w1r5pdjd8a7gb0pckw0z7d965vsya0vbyhywj7l8qg";
        };
      };
    };
    "symfony/yaml" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-yaml-bc63e15160866e8730a1f738541b194c401f72bf";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/yaml/zipball/bc63e15160866e8730a1f738541b194c401f72bf;
          sha256 = "0m5jc417nrbxj1isbjidc23006xnwb9ndv183348w7dqaacqksll";
        };
      };
    };
    "twig/twig" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "twig-twig-18772e0190734944277ee97a02a9a6c6555fcd94";
        src = fetchurl {
          url = https://api.github.com/repos/twigphp/Twig/zipball/18772e0190734944277ee97a02a9a6c6555fcd94;
          sha256 = "05i3h7bklzyrfb9bfhilx4a1m1m85c6hnzq2f9wgnmwbk1i1fa81";
        };
      };
    };
    "webmozart/assert" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "webmozart-assert-aed98a490f9a8f78468232db345ab9cf606cf598";
        src = fetchurl {
          url = https://api.github.com/repos/webmozart/assert/zipball/aed98a490f9a8f78468232db345ab9cf606cf598;
          sha256 = "00w4s4z7vlsyvx3ii7374vgq705a3yi4maw3haa05906srn3d1ik";
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
in
composerEnv.buildPackage {
  inherit packages devPackages noDev;
  name = "phpactor-phpactor";
  src = ./.;
  executable = true;
  symlinkDependencies = false;
  meta = {};
}
