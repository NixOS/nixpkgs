source $stdenv/setup

tar xfvj $src
mkdir -p $out
cp -av $name $out

# Create wrapper scripts so that the GWT compiler/host work

libPath="$libstdcpp5/lib:$glib/lib:$gtk/lib:$atk/lib:$pango/lib:$libX11/lib:$libXt/lib:$out/$name/mozilla-1.7.12"

mkdir -p $out/bin

cat > $out/bin/gwt-compile <<EOF
#!/bin/sh

export LD_LIBRARY_PATH=$libPath
export LIBXCB_ALLOW_SLOPPY_LOCK=1 # Workaround for bug in Java AWT implementation

$jdk/bin/java -Xmx256m -cp "\$CLASSPATH:$out/$name/gwt-user.jar:$out/$name/gwt-dev-linux.jar" com.google.gwt.dev.Compiler \$@
EOF
chmod 755 $out/bin/gwt-compile

cat > $out/bin/gwt-shell <<EOF
#!/bin/sh

export LD_LIBRARY_PATH=$libPath
export LIBXCB_ALLOW_SLOPPY_LOCK=1 # Workaround for bug in Java AWT implementation

$jdk/bin/java -Xmx256m -cp "\$CLASSPATH:$out/$name/gwt-user.jar:$out/$name/gwt-dev-linux.jar" com.google.gwt.dev.GWTShell \$@
EOF
chmod 755 $out/bin/gwt-shell
