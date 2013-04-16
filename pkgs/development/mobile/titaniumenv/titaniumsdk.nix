{stdenv, fetchurl, unzip, makeWrapper, python, jdk}:

stdenv.mkDerivation {
  name = "titanium-mobilesdk-3.1.0.v20130415184552";
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux") then fetchurl {
    url = http://builds.appcelerator.com.s3.amazonaws.com/mobile/3_1_X/mobilesdk-3.1.0.v20130415184552-linux.zip;
    sha1 = "7a8b34b92f6c3eff33eefb9a1b6b0d2e3670001d";
  }
  else if stdenv.system == "x86_64-darwin" then fetchurl {
    url = http://builds.appcelerator.com.s3.amazonaws.com/mobile/3_1_X/mobilesdk-3.1.0.v20130415184552-osx.zip;
    sha1 = "e0ed7e399a104e0838e245550197bf787a66bf98";
  }
  else throw "Platform: ${stdenv.system} not supported!";
  
  buildInputs = [ unzip makeWrapper ];
  
  buildCommand = ''
    mkdir -p $out
    cd $out
    yes y | unzip $src
    
    # Fix shebang header for python scripts
    
    find . -name \*.py | while read i
    do
        sed -i -e "s|#!/usr/bin/env python|#!${python}/bin/python|" $i
    done
   
    # Zip files do not support timestamps lower than 1980. We have to apply a few work-arounds to cope with that
    # Yes, I know it's nasty :-)
    
    cd mobilesdk/*/*/android
    
    sed -i -f ${./fixtiverify.sed} builder.py
    sed -i -f ${./fixtiprofiler.sed} builder.py
    sed -i -f ${./fixso.sed} builder.py
    
    # Patch some executables
    
    ${if stdenv.system == "i686-linux" then
      ''
        patchelf --set-interpreter ${stdenv.gcc.libc}/lib/ld-linux.so.2 titanium_prep.linux32
      ''
      else if stdenv.system == "x86_64-linux" then
      ''
        patchelf --set-interpreter ${stdenv.gcc.libc}/lib/ld-linux-x86-64.so.2 titanium_prep.linux64
      ''
      else ""}
    
    # Wrap builder script
    
    wrapProgram `pwd`/builder.py \
      --prefix PYTHONPATH : ${python.modules.sqlite3}/lib/python*/site-packages \
      --prefix PATH : ${jdk}/bin \
      --prefix JAVA_HOME : ${jdk}
  '' + stdenv.lib.optionalString (stdenv.system == "x86_64-darwin") ''
    # 'ditto' utility is needed to copy stuff to the Xcode organizer. Dirty, but this allows it to work.
    sed -i -e "s|ditto|/usr/bin/ditto|g" $out/mobilesdk/osx/*/iphone/builder.py
  '';
}
