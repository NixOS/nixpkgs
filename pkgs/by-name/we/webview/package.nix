{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gtk3,
  gtk4,
  webkitgtk_4_1,
  webkitgtk_6_0,
  webkitgtkApi ? "4.1",
}:

let
  webkitgtkApis = {
    "4.1" = {
      toolkit = gtk3;
      webkitgtk = webkitgtk_4_1;
    };
    "6.0" = {
      toolkit = gtk4;
      webkitgtk = webkitgtk_6_0;
    };
  };
  selected = webkitgtkApis.${webkitgtkApi};

  useWebkitgtk =
    !stdenv.hostPlatform.isDarwin && lib.meta.availableOn stdenv.hostPlatform selected.webkitgtk;
in
assert lib.assertMsg (webkitgtkApis ? ${webkitgtkApi})
  "webview: unsupported webkitgtkApi \"${webkitgtkApi}\", expected one of ${lib.concatStringsSep ", " (lib.attrNames webkitgtkApis)}";

stdenv.mkDerivation (finalAttrs: {
  pname = "webview";
  version = "0.12.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "webview";
    repo = "webview";
    tag = finalAttrs.version;
    hash = "sha256-pmqodl2fIlCNJTZz1U5spW4MpcoMhQt5WFh3+TRny3U=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = lib.optionals useWebkitgtk [
    selected.toolkit
    selected.webkitgtk
  ];

  cmakeFlags = [
    (lib.cmakeBool "WEBVIEW_BUILD_SHARED_LIBRARY" true)
    (lib.cmakeBool "WEBVIEW_BUILD_STATIC_LIBRARY" false)
    (lib.cmakeBool "WEBVIEW_BUILD_TESTS" false)
    (lib.cmakeBool "WEBVIEW_BUILD_EXAMPLES" false)
    (lib.cmakeBool "WEBVIEW_BUILD_DOCS" false)
    (lib.cmakeBool "WEBVIEW_ENABLE_CHECKS" false)
    (lib.cmakeBool "WEBVIEW_INSTALL_TARGETS" true)
  ]
  ++ lib.optional useWebkitgtk (lib.cmakeFeature "WEBVIEW_WEBKITGTK_API" webkitgtkApi);

  meta = {
    description = "Tiny cross-platform webview library for C/C++";
    homepage = "https://github.com/webview/webview";
    license = lib.licenses.mit;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ ners ];
  };
})
