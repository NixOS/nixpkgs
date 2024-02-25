{ bazel
, buildBazelPackage
, fetchFromGitHub
, fetchurl
, glibcLocales
, lib
, pkg-config
, python3
, qtbase
, qtwayland
, ruby
, wrapQtAppsHook
, dictionaries ? [
    "alt-cannadic"
    "edict2"
    "jawiki"
    "neologd"
    "personal-names"
    "place-names"
    "skk-jisyo"
    "sudachidict"
  ]
}:

buildBazelPackage {
  pname = "mozc";
  version = "unstable-2024-02-09";

  srcs = [
    (fetchFromGitHub rec {
      owner = "google";
      repo = "mozc";
      name = repo;
      fetchSubmodules = true;
      rev = "c2fcbf6515c5884437977de46187c16a8cb7bb50";
      hash = "sha256-AcIN5sWPBe4JotAUYv1fytgQw+mJzdFhKuVPLR48soA=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "merge-ut-dictionaries";
      name = repo;
      rev = "a3d6fc4005aff2092657ebca98b9de226e1c617f";
      hash = "sha256-UK29ACZUK9zGfzW7C85uMw2aF5Gk+0aDeUdNV71PY+0=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-alt-cannadic";
      name = repo;
      rev = "4e548e6356b874c76e8db438bf4d8a0b452f2435";
      hash = "sha256-4gzqVoCIhC0k3mh0qbEr8yYttz9YR0fItkFNlu7cYOY=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-edict2";
      name = repo;
      rev = "b2eec665b81214082d61acee1c5a1b5b115baf1a";
      hash = "sha256-LIpGt6xB8dLUnazbJHZk6EH1/ZyAHMIn1m6Qpr2dsHs=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-jawiki";
      name = repo;
      rev = "6e08b8c823f3d2d09064ad2080e7a16552a7b473";
      hash = "sha256-0YwAinlcI6yojCdW1MpLgMZfyYV7gk9Q+Wlu4lR3Hrg=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-neologd";
      name = repo;
      rev = "bf9d0d217107f2fb2e7d1a26648ef429d9fdcd27";
      hash = "sha256-e0iM5fohwpNNhPl9CjkD753/Rgatg7GdwN0NSvlN94c=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-personal-names";
      name = repo;
      rev = "8a500f82c553936cbdd33b85955120e731069d44";
      hash = "sha256-pMyYvl5S0+U++MO5m9rmbtxDzAmO4Xs8sFewOUGqgUA=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-place-names";
      name = repo;
      rev = "a847a02e0137ab9e2fdbbaaf120826f870408ca6";
      hash = "sha256-B0kW8Wa/nCT4KEYl2Rz6gQcj0Po3GxU6i42unHhgZeU=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-skk-jisyo";
      name = repo;
      rev = "ee94f6546ce52edfeec0fd203030f52d4d99656f";
      hash = "sha256-RXxO878ZBkxenrdo7cFom5NjM0m7CdYQk0dFu/HPp/Y=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-sudachidict";
      name = repo;
      rev = "55f61c3fca81dec661c36c73eb29b2631c8ed618";
      hash = "sha256-gNnBcuVU1M7rllfZXIrLg7WYUhKqPJsUjR8Scnq3Fw8=";
    })
    (fetchurl rec {
      name = "jawiki";
      url = "https://dumps.wikimedia.org/${name}/20240120/${name}-20240120-all-titles-in-ns0.gz";
      recursiveHash = true;
      hash = "sha256-Mp7ya2tM6E0IKE6kOYSlRx6gZBS/DK1zAwyT6jvZxrY=";
      downloadToTemp = true;
      postFetch = ''
        mkdir -p "$out"
        install -Dm444 "$downloadedFile" "$out/${name}.gz"
      '';
    })
    (fetchFromGitHub rec {
      owner = "musjj";
      repo = "jp-zip-codes";
      name = repo;
      rev = "cfbb54655223d8e2cea6fedbaef202919d8d62fe";
      hash = "sha256-ZvZL/6yTE6JrBu4ja7HvyBUKWUAIL0jULii5Im+zmLQ=";
    })
  ];

  sourceRoot = ".";

  nativeBuildInputs = [
    glibcLocales
    pkg-config
    python3
    ruby
    wrapQtAppsHook
  ];

  buildInputs = [ qtbase qtwayland ];

  preBuild = ''
    cd mozc/src
  '';

  # Required so that the ruby scripts can work
  env.LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";
  env.LC_ALL = "en_US.UTF-8";

  inherit bazel;
  removeRulesCC = false;
  dontAddBazelOpts = true;

  bazelFlags = [
    "--config"
    "oss_linux"
    "--compilation_mode"
    "opt"
  ];

  bazelTargets = [
    "server:mozc_server"
    "gui/tool:mozc_tool"
  ];

  fetchAttrs = {
    postPatch = ''
      substituteInPlace mozc/src/WORKSPACE.bazel \
        --replace \
          'url = "https://www.post.japanpost.jp/zipcode/dl/kogaki/zip/ken_all.zip"' \
          "url = \"file://$PWD/jp-zip-codes/ken_all.zip\"" \
        --replace \
          'url = "https://www.post.japanpost.jp/zipcode/dl/jigyosyo/zip/jigyosyo.zip"' \
          "url = \"file://$PWD/jp-zip-codes/jigyosyo.zip\""
    '';

    preInstall = ''
      rm -rf $bazelOut/external/qt_linux
    '';

    sha256 = "sha256-gpRLwbYHPW2o9LkOhO10sOVhtXZr7MPfMRdJympwPyk=";
  };

  buildAttrs = {
    postPatch = ''
      sed -ri -e "s|^(LINUX_MOZC_SERVER_DIR = ).+|\1\"$out/lib/mozc\"|" mozc/src/config.bzl

      (
        cd merge-ut-dictionaries/src

        sed -i -e "s|https://raw.githubusercontent.com/google/mozc/master|../../mozc|" remove_duplicate_ut_entries.rb

        sed -i -e '/wget/d' count_word_hits.rb
        sed -i -e "s|^filename = \"jawiki-.*|filename = \"../../jawiki/jawiki.gz\"|" count_word_hits.rb

        [[ -e mozcdic-ut.txt ]] && rm mozcdic-ut.txt

        dictionaries=(
          ${lib.escapeShellArgs dictionaries}
        )
        for name in "''${dictionaries[@]}"; do
          tar -xf ../../mozcdic-ut-$name/mozcdic-ut-$name.txt.tar.bz2
          cat mozcdic-ut-$name.txt >>mozcdic-ut.txt
        done

        ruby remove_duplicate_ut_entries.rb mozcdic-ut.txt
        ruby count_word_hits.rb
        ruby apply_word_hits.rb mozcdic-ut.txt

        cat mozcdic-ut.txt >>../../mozc/src/data/dictionary_oss/dictionary00.txt
      )
    '';

    installPhase = ''
      runHook preInstall

      install -Dm444 -t $out/share/licenses/mozc ../LICENSE
      install -Dm444 -t $out/share/licenses/mozc/Submodules data/installer/credits_en.html

      install -Dm555 -t $out/lib/mozc bazel-bin/server/mozc_server
      install -Dm555 -t $out/lib/mozc bazel-bin/gui/tool/mozc_tool

      runHook postInstall
    '';
  };

  meta = with lib; {
    description = "The Open Source edition of Google Japanese Input bundled with the UT dictionary";
    homepage = "https://github.com/google/mozc";
    license = with licenses; [
      asl20 # abseil-cpp, merge-ut-dictionaries, mozcdic-ut-alt-cannadic,
            # mozcdic-ut-edict2, mozcdic-ut-jawiki, mozcdic-ut-neologd,
            # mecab-ipadic-neologd, mozcdic-ut-personal-names,
            # mozcdic-ut-place-names, mozcdic-ut-skk-jisyo,
            # mozcdic-ut-sudachidict
      bsd2 # japanese-usage-dictionary
      bsd3 # mozc, breakpad, gtest, gyp, japanese-usage-dictionary, protobuf, id.def
      cc-by-sa-30 # jawiki-latest-all-titles, mozcdic-ut-jawiki.txt, jawiki
      cc-by-sa-40 # mozcdic-ut-edict2.txt
      gpl2Only # mozcdic-ut-alt-cannadic.txt
      gpl2Plus # mozcdic-ut-skk-jisyo.txt
      mit # wil
      publicDomain # src/data/test/stress_test, mozcdic-ut-place-names.txt, jp-zip-codes
    ];
    maintainers = with maintainers; [ musjj ];
    platforms = platforms.linux;
  };
}
