{ stdenv
, fetchurl
, unzip
, cabextract
, ...
}:

assert stdenv.system == "i686-cygwin";

stdenv.mkDerivation rec {
  name = "jdk-1.6.0_20";

  src = fetchurl {
    url = file:///tmp/jdk-6u20-windows-i586.exe ;
    sha256 = "0w4afz8a9gi1iyhh47gvhiy59dfrzx0fnmywdff3v5cx696w25fh";
  };

  buildInputs = [unzip cabextract]; 

  buildCommand = ''
    cabextract ${src}
    mkdir -p $out
    unzip -d $out tools.zip
    find $out -name '*.exe' | xargs chmod a+x 
    find $out -name '*.dll' | xargs chmod a+x 

    cd $out
    $out/bin/unpack200.exe ./jre/lib/jsse.pack ./jre/lib/jsse.jar
    $out/bin/unpack200.exe ./jre/lib/javaws.pack ./jre/lib/javaws.jar
    $out/bin/unpack200.exe ./jre/lib/plugin.pack ./jre/lib/plugin.jar
    $out/bin/unpack200.exe ./jre/lib/charsets.pack ./jre/lib/charsets.jar
    $out/bin/unpack200.exe ./jre/lib/deploy.pack ./jre/lib/deploy.jar
    $out/bin/unpack200.exe ./jre/lib/rt.pack ./jre/lib/rt.jar
    $out/bin/unpack200.exe ./jre/lib/ext/localedata.pack ./jre/lib/ext/localedata.jar
    $out/bin/unpack200.exe ./lib/tools.pack ./lib/tools.jar

    rm ./jre/lib/jsse.pack \
       ./jre/lib/javaws.pack \
       ./jre/lib/plugin.pack \
       ./jre/lib/charsets.pack \
       ./jre/lib/deploy.pack \
       ./jre/lib/rt.pack \
       ./jre/lib/ext/localedata.pack \
       ./lib/tools.pack
  '';
}
