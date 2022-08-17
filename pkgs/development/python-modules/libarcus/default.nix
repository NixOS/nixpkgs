{ lib, buildPythonPackage, python, fetchFromGitHub
, fetchpatch
, cmake, sip, protobuf, pythonOlder, symlinkJoin, pkg-config, j2cli }:

buildPythonPackage rec {
  pname = "libarcus";
  version = "5.1.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "libArcus";
    rev = version;
    sha256 = "sha256-aGuNE7K5We/8QT8Gl/vBfFn7CXdpqbmiQZLc2JvO6pk=";
  };

  disabled = pythonOlder "3.4";

  propagatedBuildInputs = [ sip ];
  nativeBuildInputs = [ cmake python pkg-config ];
  buildInputs = [ protobuf python ];

  cmakeFlags = [
    "-DPython_SITELIB_LOCAL=${python.sitePackages}"
    "-DARCUS_VERSION=${version}"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  postPatch = ''
    sed -i '2i include(CMakePackageConfigHelpers)' CMakeLists.txt
    sed -i '2i find_package(PkgConfig)' CMakeLists.txt
    sed -i '2i include(GenerateExportHeader)' CMakeLists.txt

    sed -i 's|find_package(cpython REQUIRED)|pkg_check_modules(python REQUIRED IMPORTED_TARGET python)|' CMakeLists.txt
    sed -i 's|cpython::cpython|PkgConfig::python|g' CMakeLists.txt
    cat CMakeLists.txt

    mkdir -p build/pyArcus/
    module_name=pyArcus sip_dir=$(pwd)/python sip_include_dirs=$(pwd)/python build_dir=$(pwd)/build/pyArcus/ \
      ${j2cli}/bin/j2 pyproject.toml.jinja -o pyproject.toml
    ln -s cmake/CMakeBuilder.py CMakeBuilder.py
    ${sip}/bin/sip-build --pep484-pyi --no-protected-is-public # -y pyArcus.pyi

    echo '
    generate_export_header(Arcus
        EXPORT_FILE_NAME src/ArcusExport.h
    )
    include_directories(''${CMAKE_BINARY_DIR}/src)

    install(TARGETS Arcus
        EXPORT Arcus-targets
        RUNTIME DESTINATION ''${CMAKE_INSTALL_BINDIR}
        LIBRARY DESTINATION ''${CMAKE_INSTALL_LIBDIR}
        ARCHIVE DESTINATION ''${CMAKE_INSTALL_LIBDIR}
        PUBLIC_HEADER DESTINATION ''${CMAKE_INSTALL_INCLUDEDIR}/Arcus
    )

    install(EXPORT Arcus-targets
        DESTINATION ''${CMAKE_INSTALL_LIBDIR}/cmake/Arcus
    )'  >> CMakeLists.txt
    # echo '
    # install(TARGETS Arcus
    #     EXPORT Arcus-targets
    #     RUNTIME DESTINATION ''${CMAKE_INSTALL_BINDIR}
    #     LIBRARY DESTINATION ''${CMAKE_INSTALL_LIBDIR}
    #     ARCHIVE DESTINATION ''${CMAKE_INSTALL_LIBDIR}
    #     PUBLIC_HEADER DESTINATION ''${CMAKE_INSTALL_INCLUDEDIR}/Arcus
    # )

    # install(EXPORT Arcus-targets
    #     DESTINATION ''${CMAKE_INSTALL_LIBDIR}/cmake/Arcus
    # )
    # configure_package_config_file(ArcusConfig.cmake.in ''${CMAKE_BINARY_DIR}/arcusConfig.cmake INSTALL_DESTINATION ''${CMAKE_INSTALL_LIBDIR}/cmake/Arcus)
    # write_basic_package_version_file(''${CMAKE_BINARY_DIR}/arcusConfigVersion.cmake VERSION ''${ARCUS_VERSION} COMPATIBILITY SameMajorVersion)

    # install(FILES
    #     ''${CMAKE_BINARY_DIR}/arcusConfig.cmake
    #     ''${CMAKE_BINARY_DIR}/arcusConfigVersion.cmake
    #     DESTINATION ''${CMAKE_INSTALL_LIBDIR}/cmake/arcus
    # )' >> CMakeLists.txt
  '';

  postInstall = ''
  mkdir -p $out/include/Arcus/
  for dir in . ..; do
    cp $dir/src/*.h $out/include/Arcus/
  done
  cp -r ../arcus_include/Arcus/* $out/include/Arcus/
  ls -R $out
  ls -R .
  #die
  '';

  meta = with lib; {
    description = "Communication library between internal components for Ultimaker software";
    homepage = "https://github.com/Ultimaker/libArcus";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar gebner ];
  };
}
