{ lib
, stdenvNoCC
, fetchurl
, unzip
, gtk-engine-murrine
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sweet";
  version = "4.0";

  srcs = [
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Ambar-Blue-Dark-v40.zip";
      hash = "sha256-w4jN6PSUNCuqeRQ5wInb5deMTtfpKOa7lj9pN+b/0hU=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Ambar-Blue-Dark.zip";
      hash = "sha256-2hb2FHWyGSowRdUnrWMJENlqRtSr2CrPtDe3DSZlP8M=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Ambar-Blue-v40.zip";
      hash = "sha256-4B0O9hOI9xtzj2gOX354DxtQyiahK5ezr6q6VBpxOJQ=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Ambar-Blue.zip";
      hash = "sha256-8Aw7CsHRflHoeL/DhpxgxDATaAFm+MTMjeZe9Qg8J8o=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Ambar-v40.zip";
      hash = "sha256-Ih8/d4qHBAaDDHUIdzw7J6jGu5Zg6KTPffEs+jh0VkM=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Ambar.zip";
      hash = "sha256-WdawPwNRW1uVNFIiP7bSQxvcWQtD/i8b4oLplPbPLyU=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Dark-v40.zip";
      hash = "sha256-5vnTneWP5uRFeL6PjuP61OglbNL6+lLGPHmrLeqyk2w=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Dark.zip";
      hash = "sha256-EmXM2/IG82KKm5npl2KLTryhu7Y/5KLKnPv1JxYm0Z4=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-mars-v40.zip";
      hash = "sha256-5t9NsxmbjDg7Nf/BSnbdZhx1wl6PQxXYxKuhlNnIPO4=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-mars.zip";
      hash = "sha256-ZX7Z9gTMVUjFVtdN+FWuHAkV+Yk8vk7D23gr27efpNM=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-v40.zip";
      hash = "sha256-NHSFgj5iybwzcYw0JyMWijhVXSEvhbMhj1KcvTsHpS4=";
    })
    (fetchurl {
      url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet.zip";
      hash = "sha256-R2ULcqjOQ9aPO4c2o5ow81icZGKxA5Qvq7G5XGGC2Og=";
    })
  ];

  nativeBuildInputs = [ unzip ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes/
    cp -a Sweet* $out/share/themes/
    rm $out/share/themes/*/{LICENSE,README*}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Light and dark colorful Gtk3.20+ theme";
    homepage = "https://github.com/EliverLara/Sweet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fuzen d3vil0p3r ];
    platforms = platforms.unix;
  };
})
