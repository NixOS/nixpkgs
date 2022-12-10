cat <<EOF > linenoise.pc
prefix=$out
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
includedir=\${prefix}/include

Name: linenoise
Description: A minimal, zero-config, BSD licensed, readline replacement.
Requires:
Version: 1.0.10
Cflags: -I\${includedir}/ \${prefix}/src/linenoise.c

EOF
