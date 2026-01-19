fixGprProjectDarwinRpath() {
    for f in $(find $out -type f -executable); do
        install_name_tool -id $f $f || true
        for rpath in $(otool -L $f | grep @rpath | awk '{print $1}'); do
            install_name_tool -change $rpath ${!outputLib}/lib/$(basename $rpath) $f || true
        done
    done
}

appendToVar preFixupPhases fixGprProjectDarwinRpath
