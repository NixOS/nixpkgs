source $stdenv/setup

ensureDir $out/bin

wrapper="$out/bin/$launcher"

echo "#! $SHELL -e" > $wrapper
echo "" >> $wrapper
echo "$xulrunner/bin/xulrunner $appfile \"\$@\"" >> $wrapper

chmod +x $wrapper
