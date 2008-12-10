source $stdenv/setup

ensureDir $out/bin

wrapper="$out/bin/$launcher"

if test -e $xulrunner/bin/xulrunner; then
    runner=$xulrunner/bin/xulrunner
elif test -e $xulrunner/bin/firefox; then
    runner="$xulrunner/bin/firefox -app"
else
    echo "XUL runner not found"
    exit 1
fi

cat > $wrapper <<EOF
#! $SHELL -e
exec $runner $appfile "\$@"
EOF

chmod +x $wrapper
