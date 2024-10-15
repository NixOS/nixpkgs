{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "directx-headers";
  version = "1.614.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "DirectX-Headers";
    rev = "v${version}";
    hash = "sha256-0LaN9D3cKVacMJhZCe9oxDPHpd1jdCAV0ImG2rSgnxc=";
  };

  # Build using meson but do generate a directx-headers-config.cmake
  postPatch = ''
    cat << \EOF > directx-headers.cmake.in
    @PACKAGE_INIT@

    find_library(DX_HEADERS_LIBRARY
      NAMES d3dx12-format-properties
      HINTS "@PACKAGE_CMAKE_INSTALL_LIBDIR@")
    find_library(DX_GUIDS_LIBRARY
      NAMES DirectX-Guids
      HINTS "@PACKAGE_CMAKE_INSTALL_LIBDIR@")

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(directx-headers REQUIRED_VARS DX_HEADERS_LIBRARY DX_GUIDS_LIBRARY)

    if (directx-headers_FOUND)
      if (NOT TARGET Microsoft::DirectX-Headers)
        add_library(Microsoft::DirectX-Headers INTERFACE IMPORTED)
        target_link_libraries(Microsoft::DirectX-Headers INTERFACE "''${DX_HEADERS_LIBRARY}")
        target_include_directories(Microsoft::DirectX-Headers INTERFACE "@DIRECTX_HEADERS_INCLUDE_DIRS@")
      endif()
      if (NOT TARGET Microsoft::DirectX-Guids)
        add_library(Microsoft::DirectX-Guids INTERFACE IMPORTED)
        target_link_libraries(Microsoft::DirectX-Guids INTERFACE "''${DX_GUIDS_LIBRARY}")
        target_include_directories(Microsoft::DirectX-Guids INTERFACE "@DIRECTX_HEADERS_INCLUDE_DIRS@")
      endif()
    endif()
    EOF

    cat << \EOF >> meson.build
    cmake = import('cmake')
    cmake.write_basic_package_version_file(name: 'directx-headers', version: meson.project_version())
    conf = configuration_data()
    install_inc_dirs = []
    foreach d : install_inc_subdirs
      install_inc_dirs += [join_paths(get_option('prefix'), get_option('includedir'), d)]
    endforeach
    conf.set('DIRECTX_HEADERS_INCLUDE_DIRS', ';'.join(install_inc_dirs))
    conf.set('PACKAGE_CMAKE_INSTALL_LIBDIR', join_paths(get_option('prefix'), get_option('libdir')))
    cmake.configure_package_config_file(
        name: 'directx-headers',
        input: 'directx-headers.cmake.in',
        configuration: conf
    )
    EOF
  '';

  nativeBuildInputs = [
    cmake
    meson
    ninja
    pkg-config
  ];

  dontUseCmakeConfigure = true;

  # tests require WSL2
  mesonFlags = [ (lib.mesonBool "build-test" false) ];

  meta = {
    description = "Official D3D12 headers from Microsoft";
    homepage = "https://github.com/microsoft/DirectX-Headers";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ k900 ];
    platforms = lib.platforms.all;
  };
}
