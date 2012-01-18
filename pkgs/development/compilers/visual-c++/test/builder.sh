source $stdenv/setup
source $visualcpp/setup
source $windowssdk/setup

mkdir -p $out/bin
cl "$(cygpath -w $src)" /Fe"$(cygpath -w $out/bin/hello.exe)" user32.lib
