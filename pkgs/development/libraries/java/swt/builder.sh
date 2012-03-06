source $stdenv/setup

unzip $src src.zip
unzip src.zip

export JAVA_HOME=${jdk}
echo $JAVA_HOME=${jdk}
sh ./build.sh make_swt make_atk

mkdir -p $out/lib
cp *.so $out/lib

mkdir out
javac -d out/ $(find org/ -name "*.java")

mkdir -p $out/jars
cp version.txt out/
cd out && jar -c * > $out/jars/swt.jar
