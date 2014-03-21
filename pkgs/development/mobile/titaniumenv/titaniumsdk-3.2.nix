{stdenv, fetchurl, unzip, makeWrapper, python, jdk}:

stdenv.mkDerivation {
  name = "mobilesdk-3.2.2.v20140305122111";
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux") then fetchurl {
    url = http://builds.appcelerator.com.s3.amazonaws.com/mobile/3_2_X/mobilesdk-3.2.2.v20140305122111-linux.zip;
    sha1 = "12dc1bfe8dd73db0650a235492f5f50c7b816d69";
  }
  else if stdenv.system == "x86_64-darwin" then fetchurl {
    url = http://builds.appcelerator.com.s3.amazonaws.com/mobile/3_2_X/mobilesdk-3.2.2.v20140305122111-osx.zip;
    sha1 = "9875b59faf0ab92e8996b58476466405ed60f6e2";
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
   
    # Rename ugly version number
    cd mobilesdk/*
    mv 3.2.2.v20140305122111 3.2.2.GA
    cd 3.2.2.GA
    
    # Zip files do not support timestamps lower than 1980. We have to apply a few work-arounds to cope with that
    # Yes, I know it's nasty :-)
    
    cd android
    
    sed -i -f ${./fixtiverify.sed} builder.py
    sed -i -f ${./fixtiprofiler.sed} builder.py
    sed -i -f ${./fixso.sed} builder.py
    sed -i -f ${./fixnativelibs.sed} builder.py
    
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
    
    mv builder.py .builder.py
    cat > builder.py <<EOF
    #!${python}/bin/python
    
    import os, sys
    
    os.environ['PYTHONPATH'] = '$(echo ${python.modules.sqlite3}/lib/python*/site-packages)'
    os.environ['JAVA_HOME'] = '${if stdenv.system == "x86_64-darwin" then jdk else "${jdk}/lib/openjdk"}'
    
    os.execv('$(pwd)/.builder.py', sys.argv)
    EOF
    
    chmod +x builder.py
    
  '' + stdenv.lib.optionalString (stdenv.system == "x86_64-darwin") ''
    # 'ditto' utility is needed to copy stuff to the Xcode organizer. Dirty, but this allows it to work.
    sed -i -e "s|ditto|/usr/bin/ditto|g" $out/mobilesdk/osx/*/iphone/builder.py
    
    sed -i -e "s|--xcode|--xcode '+process.env['NIX_TITANIUM_WORKAROUND']+'|" $out/mobilesdk/osx/*/iphone/cli/commands/_build.js
  '';
}
