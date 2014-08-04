{stdenv, fetchurl, unzip, makeWrapper, python, jdk}:

stdenv.mkDerivation {
  name = "mobilesdk-3.3.0.GA";
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux") then fetchurl {
    url = http://builds.appcelerator.com/mobile/3.3.0/mobilesdk-3.3.0.GA-linux.zip;
    sha1 = "9a9cca05a4cf8700df60b7e9d9cd969ecb70d81e";
  }
  else if stdenv.system == "x86_64-darwin" then fetchurl {
    url = http://builds.appcelerator.com/mobile/3.3.0/mobilesdk-3.3.0.GA-osx.zip;
    sha1 = "c6333e4da2564b9c51b865c1db49a062fbc743af";
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
    cd 3.3.0.GA
    
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
