source $stdenv/setup

postInstall=postInstall
postInstall() {
    strip -S $out/lib/*/* || true

    # This fixes starting Firefox when there already is a running
    # instance.  The `firefox' wrapper script actually expects to be
    # in the same directory as `run-mozilla.sh', apparently.
    cd $out/bin
    mv xulrunner ../lib/xulrunner-*/
    ln -s ../lib/xulrunner-*/xulrunner .

    echo "running xulrunner --register-global..."
    $out/bin/xulrunner --register-global || true

    # xulrunner wants to create these directories at the first startup
    cd $out
    ensureDir ./lib/xulrunner-*/extensions
    ensureDir ./lib/xulrunner-*/updates
}

genericBuild
