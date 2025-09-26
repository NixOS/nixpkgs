{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  darwin,
  makeWrapper,
  shared-mime-info,
  boost,
  wxGTK32,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wxformbuilder";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "wxFormBuilder";
    repo = "wxFormBuilder";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    leaveDotGit = true;
    postFetch = ''
      substituteInPlace $out/.git-properties \
        --replace-fail "\$Format:%h\$" "$(git -C $out rev-parse --short HEAD)" \
        --replace-fail "\$Format:%(describe)\$" "$(git -C $out rev-parse --short HEAD)"
      rm -rf $out/.git
    '';
    hash = "sha256-e0oYyUv8EjGDVj/TWx2jGaj22YyFJf1xa6lredV1J0Y=";
  };

  postPatch = ''
    substituteInPlace third_party/tinyxml2/cmake/tinyxml2.pc.in \
      --replace-fail '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
    sed -i '/fixup_bundle/d' cmake/macros.cmake
  '';

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.sigtool
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    shared-mime-info
  ];

  buildInputs = [
    boost
    wxGTK32
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv $out/wxFormBuilder.app $out/Applications
    makeWrapper $out/Applications/wxFormBuilder.app/Contents/MacOS/wxFormBuilder $out/bin/wxformbuilder
  '';

  meta = with lib; {
    description = "RAD tool for wxWidgets GUI design";
    homepage = "https://github.com/wxFormBuilder/wxFormBuilder";
    license = licenses.gpl2Only;
    mainProgram = "wxformbuilder";
    maintainers = with maintainers; [
      matthuszagh
      wegank
    ];
    platforms = platforms.unix;
  };
})
