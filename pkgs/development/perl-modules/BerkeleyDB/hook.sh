oldPreConfigure=$preConfigure
preConfigure=myPreConfigure
myPreConfigure() {
    echo "LIB = $db4/lib" > config.in
    echo "INCLUDE = $db4/include" >> config.in
    $oldPreConfigure
}
