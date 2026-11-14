{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  pkg-config,
  makeWrapper,
  SDL2,
  bullet,
  glm,
  libGL,
  libx11,
  wayland,
  libxkbcommon,
  libdecor,
  zenity,
}:

stdenv.mkDerivation rec {
  pname = "udock2";
  version = "unstable-2023-09-18";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "Udock";
    repo = "Udock2";
    rev = "5ceeb2d0a63e777d5dd47128180a1ec57e1996bb";
    hash = "sha256-WBAkZefWQE2XN785nI3uHE7lVxbbQYjTNT/ZtE5gg+k=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    SDL2
    bullet
    glm
    libGL
    libx11
    wayland
    libxkbcommon
    libdecor
  ];

  postPatch = ''
        sed -i '1s/^\xEF\xBB\xBF//' CMakeLists.txt

        substituteInPlace extern/CMakeLists.txt \
          --replace-fail 'add_subdirectory(bullet3)' '# add_subdirectory(bullet3)' \
          --replace-fail 'add_subdirectory(SDL2)' '# add_subdirectory(SDL2)' \
          --replace-fail 'add_subdirectory(glm)' '# add_subdirectory(glm)'

        substituteInPlace CMakeLists.txt \
          --replace-fail 'add_subdirectory(extern)' '
    add_subdirectory(extern)
    find_package(SDL2 REQUIRED)
    find_package(Bullet REQUIRED)
    find_package(glm REQUIRED)
    list(APPEND UDK_EXTERN_LIBRARIES SDL2::SDL2 ''${BULLET_LIBRARIES} glm::glm)
    list(APPEND UDK_EXTERN_INCLUDES ''${BULLET_INCLUDE_DIRS})
    '
  '';

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DCMAKE_CXX_FLAGS=-DGLM_ENABLE_EXPERIMENTAL"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -v bin/Udock $out/bin/

    cp -rv ${src}/resources ${src}/shaders ${src}/samples $out/bin/

    mkdir -p $out/share/applications
    cat > $out/share/applications/udock2.desktop << EOF
    [Desktop Entry]
    Name=Udock2
    Comment=Interactive multibody protein-protein docking system
    Exec=$out/bin/Udock
    Icon=applications-science
    Type=Application
    Categories=Education;Science;
    EOF

    wrapProgram $out/bin/Udock \
      --chdir $out/bin \
      --prefix PATH : "${lib.makeBinPath [ zenity ]}" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          SDL2
          bullet
          glm
          libGL
          wayland
          libxkbcommon
          libdecor
        ]
      }"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Interactive multibody protein-protein docking system";
    homepage = "http://udock.fr";
    license = licenses.cc-by-nc-sa-30;
    maintainers = with maintainers; [ mattiaskockum ];
    platforms = platforms.linux;
  };
}
