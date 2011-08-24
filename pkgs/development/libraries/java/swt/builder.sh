source $stdenv/setup

unzip $src src.zip
unzip src.zip

export JAVA_HOME=${jdk}
echo $JAVA_HOME=${jdk}
sh ./build.sh make_swt make_atk

ensureDir $out/lib
cp *.so $out/lib

mkdir out
javac -d out/ $(find org/ -name "*.java")

ensureDir $out/jars
cp version.txt out/
cd out && jar -c * > $out/jars/swt.jar
