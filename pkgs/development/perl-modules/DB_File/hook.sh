oldPreConfigure=$preConfigure
preConfigure=myPreConfigure
myPreConfigure() {
    cat > config.in <<EOF
PREFIX = size_t
HASH = u_int32_t
LIB = $db4/lib
INCLUDE = $db4/include
EOF
    $oldPreConfigure
}
