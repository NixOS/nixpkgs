{ bazel
, buildBazelPackage
, fetchFromGitHub
, fetchurl
, glibcLocales
, lib
, pkg-config
, python3
, qtbase
, ruby
, wrapQtAppsHook
}:

buildBazelPackage {
  pname = "mozc";
  version = "unstable-2023-08-18";

  srcs = [
    (fetchFromGitHub rec {
      owner = "google";
      repo = "mozc";
      name = repo;
      fetchSubmodules = true;
      rev = "89c70080d0102e8ed23cae6c05b535dedf506de4";
      hash = "sha256-SSAu9gYTfEbfgORSDyqS0Z02bJDCAEy7nYC3ZcjL8gM=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "merge-ut-dictionaries";
      name = repo;
      rev = "dbf3e9ccd711be39749cbf38baee99adbb2bad6f";
      hash = "sha256-7CfIr7hJChBWFVynCVqw5KYh/lIjl277fqQQ4AuJ7x4=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-alt-cannadic";
      name = repo;
      rev = "f59287e569db3e226378380a34e71275654b46d0";
      hash = "sha256-a9U6mGlGAxbywILeAaWKbt7BFWRPFS+UZvUhliFUseY=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-edict2";
      name = repo;
      rev = "e0cbf7d3192b1cdd38629a720b295bcbd67cd8bd";
      hash = "sha256-jj5eBcmWxLxKC/Q720BPuzxJc9x1Y2RvY0kJfBJkIfE=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-jawiki";
      name = repo;
      rev = "be4da36c087e56a3aa5f835f8d9e810fc1a060ba";
      hash = "sha256-WkP/RugY28TqNwTjbi2V5BsRVLwUIIvOX6zGJmdIDEk=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-neologd";
      name = repo;
      rev = "90e59c7707a5fe250c992c10c6ceb08a7ce7e652";
      hash = "sha256-zY7K/J4OzBTQHrj8sF4s8xPqakoWHHMxWrvnvHT6oxE=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-personal-names";
      name = repo;
      rev = "0e51584283f759cb6bfac1f19eda92c2c524eed4";
      hash = "sha256-8cJmSp7rGxSHy+TElFpkXmNvMxYLw2yiAYJJb2AUyyE=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-place-names";
      name = repo;
      rev = "478004504981e094af407f4fbd64cd65cf2d85dd";
      hash = "sha256-3BwK+RuZMl5+femxQXNhDF/NE3qfX6u/+imqL2Uqd8I=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-skk-jisyo";
      name = repo;
      rev = "43518e6ea033681580a515281668c85eb74a5b14";
      hash = "sha256-05T//ulsS5HvOKPdOEG87/Yp8GgzOB2X3wG8Sds3uUU=";
    })
    (fetchFromGitHub rec {
      owner = "utuhiro78";
      repo = "mozcdic-ut-sudachidict";
      name = repo;
      rev = "1b5ad7cb51325fc9b42732887fede29d6a02bb07";
      hash = "sha256-E4kq3YnxdYRFlv4KLSvf4NRoPhWXL8c89JIvqsjuy3o=";
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
      rev = "be9cd2ac888a34eba30a425c43a7e54f5187a649";
      hash = "sha256-02CE/DJnqNXUF0OH3ptq2sb8UbtqKjLKx7Hf0izq+X4=";
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

  buildInputs = [ qtbase ];

  preBuild = ''
    cd mozc/src
  '';

  LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";
  LC_ALL = "en_US.UTF-8";

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

    sha256 = "sha256-qvUkld0DJePrXFX5OJ/ZOp2KIF1AjU0I8EbOeSiZLEY=";
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

        dicts=(
          alt-cannadic
          edict2
          jawiki
          neologd
          personal-names
          place-names
          skk-jisyo
          sudachidict
        )

        for dict in "''${dicts[@]}"; do
          tar -xf ../../mozcdic-ut-$dict/mozcdic-ut-$dict.txt.tar.bz2
          cat mozcdic-ut-$dict.txt >>mozcdic-ut.txt
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
      asl20
      bsd2
      bsd3
      cc-by-sa-30
      cc-by-sa-40
      gpl2Only
      ipa
      mit
      mspl
      publicDomain
    ];
    maintainers = with maintainers; [ musjj ];
    platforms = platforms.linux;
  };
}
