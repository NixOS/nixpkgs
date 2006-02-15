source $stdenv/setup

postInstall=postInstall
postInstall() {
    strip -S $out/lib/*/* || true

    # This fixes starting Firefox when there already is a running
    # instance.  The `firefox' wrapper script actually expects to be
    # in the same directory as `run-mozilla.sh', apparently.
    libDir=$(cd $out/lib && ls -d xulrunner-*)
    test -n "$libDir"
    cd $out/bin
    mv xulrunner ../lib/$libDir/
    ln -s ../lib/$libDir/xulrunner .

    echo "running xulrunner --register-global..."
    $out/bin/xulrunner --register-global || true

    # xulrunner wants to create these directories at the first startup
    ensureDir $out/lib/$libDir/extensions
    ensureDir $out/lib/$libDir/updates
}

genericBuild
