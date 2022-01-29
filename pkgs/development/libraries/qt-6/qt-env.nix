{ buildEnv, qtbase }: name: paths:

buildEnv {
  inherit name;
  paths = [ qtbase ] ++ paths;

  pathsToLink = [ "/bin" "/mkspecs" "/include" "/lib" "/share" ];
  extraOutputsToInstall = [ "out" "dev" ];

  # replace symlinks with regular files
  # TODO fix qt.conf to make qmake work
  # TODO Qml2Imports -> what path?
  # TODO use hook to generate qt.conf from the caller's buildInputs?
  #   then call: qmake -qtconf /path/to/qt.conf
  # based on qtbase qt.conf
  postBuild = ''
    rm "$out/bin/qmake"
    cp "${qtbase.dev}/bin/qmake" "$out/bin"

    rm "$out/bin/qt.conf"
    cat >"$out/bin/qt.conf" <<EOF
    [Paths]
    ; Plugins = ${qtbase.qtPluginPrefix}
    ; Qml2Imports = ${qtbase.qtQmlPrefix}
    ; Documentation = ${qtbase.qtDocPrefix}
    Prefix = $out
    HostPrefix = $out
    Libraries = $out/lib
    LibraryExecutables = $out/libexec
    ; fix qmake error: Could not find feature thread
    ; Data has mkspecs
    Data = $dev
    HostData = $dev
    ArchData = $dev
    Binaries = $dev/bin
    Headers = $dev/include
    Plugins = $bin/${qtbase.qtPluginPrefix}
    Documentation = $out/${qtbase.qtDocPrefix}
    ; Qml2Imports = (provided by qtdeclarative)
    EOF
  '';
}
