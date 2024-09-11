{
  bazel_6,
  buildBazelPackage,
  fetchFromGitHub,
  fetchurl,
  glibcLocales,
  lib,
  pkg-config,
  python3,
  qtbase,
  qtwayland,
  ruby,
  wrapQtAppsHook,
  dictionaries ? [
    "alt-cannadic"
    "edict2"
    "jawiki"
    "neologd"
    "personal-names"
    "place-names"
    "skk-jisyo"
    "sudachidict"
  ],
}:

buildBazelPackage {
  pname = "mozc";
  version = "unstable-2024-07-29";

  srcs = [
    (fetchFromGitHub rec {
      owner = "google";
      repo = "mozc";
      name = repo;
      fetchSubmodules = true;
      rev = "5e6abfe1853b080766def432b746a9bed79e54b0";
      hash = "sha256-w0bjoMmq8gL7DSehEG7cKqp5e4kNOXnCYLW31Zl9FRs=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "merge-ut-dictionaries";
      name = repo;
      rev = "1f1cdcf545b952f84fdad78d58c0db7a662b592d";
      hash = "sha256-BrjHLTomoaF/DHmxUEFVzyTWBXfB+LUtt5b/MiuZ8EU=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-alt-cannadic";
      name = repo;
      rev = "50fee0397b87fe508f9edd45bac56f5290d8ce66";
      hash = "sha256-KKUj3d9yR2kTTTFbroZQs+OZR4KUyAUYE/X3z9/vQvM=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-edict2";
      name = repo;
      rev = "b2112277d0d479b9218f42772356da3601b3e8cf";
      hash = "sha256-DIIp8FooWxyHMrQmq+2KUGEmYHKy+H6NtHrvRldxXqc=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-jawiki";
      name = repo;
      rev = "29dd6d3202119d88a2356a11300b7b338f5cb950";
      hash = "sha256-tgg9fOFnRypJjb9jWoTOOu4kbCdzNDry3/fpy5Tms9s=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-neologd";
      name = repo;
      rev = "b7035b88db25ad1a933f05a33f193711c6c3b2db";
      hash = "sha256-JPTrWaDtdNs/Z0uLRwaS8Qc/l4/Y7NtwLanivyefXnk=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-personal-names";
      name = repo;
      rev = "5df5cedaef3b55c509cacfbf3e97ded852535a1b";
      hash = "sha256-zTJVhbZEIG+xiRWAPsK9faxxxnKeHIt/gc7HuAXqOl4=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-place-names";
      name = repo;
      rev = "5c2167541200528d8b25214c52be7a4c3dd3b89b";
      hash = "sha256-GUfze7iSRQiMPExr6tZ3fvO6W+cfU1I4MwXyZzgNrig=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-skk-jisyo";
      name = repo;
      rev = "7300f19e6a3f27334ed7af64589de8782549a13f";
      hash = "sha256-LJ1rP+uyh8K3IWCgKMDYt0EwEDiQqQL+wBdQCFbZM/k=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-sudachidict";
      name = repo;
      rev = "a754f1fff5fded62cc066aa6be0ab0169059a144";
      hash = "sha256-WzhWNpqtiG9TtFHEOSbHG1mbb4ak0zCkO13g9ZWqyBE=";
    })
    (fetchFromGitHub rec {
      owner = "musjj";
      repo = "jawiki-archive";
      name = repo;
      rev = "d205f63665e351ea853edc72157f14daa22a227f";
      hash = "sha256-Jj2vH8UMhgSzWv+RnOipnVNSdeOF6jttcLN/kVYa4D4=";
    })
    (fetchFromGitHub rec {
      owner = "musjj";
      repo = "jp-zip-codes";
      name = repo;
      rev = "995d7cce9ae68a31efe4b5882137dd67ac26f7ff";
      hash = "sha256-VnzczwIbYPUpWpWLMm2TYGqiDxzZaDDKs7xh4F3xA0E=";
    })
  ];

  sourceRoot = ".";

  nativeBuildInputs = [
    glibcLocales
    pkg-config
    python3
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtwayland
  ];

  preBuild = ''
    cd mozc/src
  '';

  bazel = bazel_6;
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

    sha256 = "sha256-EiRTuK6J9vgnw9HQwSpeGQcOp4AcTBluFYjjr69ILv4=";
  };

  buildAttrs = {
    postPatch = ''
      sed -ri -e "s|^(LINUX_MOZC_SERVER_DIR = ).+|\1\"$out/lib/mozc\"|" mozc/src/config.bzl

      (
        cd merge-ut-dictionaries/src

        sed -i -e "s|https://raw.githubusercontent.com/google/mozc/master/src|file://$PWD/../../mozc/src|" remove_duplicate_ut_entries.py

        sed -i -e '/wget/d' count_word_hits.py
        sed -i -e "s|^file_name = \"jawiki-latest-all-titles-in-ns0.gz\"|file_name = \"../../jawiki-archive/jawiki-latest-all-titles-in-ns0.gz\"|" count_word_hits.py

        [[ -e mozcdic-ut.txt ]] && rm mozcdic-ut.txt

        dictionaries=(
          ${lib.escapeShellArgs dictionaries}
        )
        for name in "''${dictionaries[@]}"; do
          tar -xf ../../mozcdic-ut-$name/mozcdic-ut-$name.txt.tar.bz2
          cat mozcdic-ut-$name.txt >>mozcdic-ut.txt
        done

        python remove_duplicate_ut_entries.py mozcdic-ut.txt
        python count_word_hits.py
        python apply_word_hits.py mozcdic-ut.txt

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
      # abseil-cpp, merge-ut-dictionaries, mozcdic-ut-alt-cannadic,
      # mozcdic-ut-edict2, mozcdic-ut-jawiki, mozcdic-ut-neologd,
      # mecab-ipadic-neologd, mozcdic-ut-personal-names,
      # mozcdic-ut-place-names, mozcdic-ut-skk-jisyo,
      # mozcdic-ut-sudachidict
      asl20
      bsd2 # japanese-usage-dictionary
      bsd3 # mozc, breakpad, gtest, gyp, japanese-usage-dictionary, protobuf, id.def
      cc-by-sa-30 # jawiki-latest-all-titles, mozcdic-ut-jawiki.txt, jawiki
      cc-by-sa-40 # mozcdic-ut-edict2.txt
      gpl2Only # mozcdic-ut-alt-cannadic.txt
      gpl2Plus # mozcdic-ut-skk-jisyo.txt
      mit # wil
      naist-2003 # IPAdic
      publicDomain # src/data/test/stress_test, mozcdic-ut-place-names.txt, jp-zip-codes, Okinawa dictionary
      unicode-30 # src/data/unicode, breakpad
    ];
    maintainers = with maintainers; [ musjj ];
    platforms = platforms.linux;
  };
}
