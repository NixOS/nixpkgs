{ stdenv, fetchurl, unzip }:

let
  version = "2.6.2";
in stdenv.mkDerivation {
  name = "tinyxml-${version}";
  
  src = fetchurl {
    url = "mirror://sourceforge/project/tinyxml/tinyxml/${version}/tinyxml_2_6_2.zip";
    sha256 = "04nmw6im2d1xp12yir8va93xns5iz816pwi25n9cql3g3i8bjsxc";
  };
  
  patches = [
    # add pkgconfig file
    ./2.6.2-add-pkgconfig.patch
    
    # http://sourceforge.net/tracker/index.php?func=detail&aid=3031828&group_id=13559&atid=313559
    ./2.6.2-entity.patch
  ];
  
  buildInputs = [ unzip ];
  buildPhase = ''
    # use STL (xbmc requires it)
    sed '1i#define TIXML_USE_STL 1' -i tinyxml.h
    sed '1i#define TIXML_USE_STL 1' -i xmltest.cpp

    # build xmltest
    make 
    
    # build the lib as a shared library
    g++ -Wall -O2 -shared -fpic tinyxml.cpp \
    tinyxmlerror.cpp tinyxmlparser.cpp      \
    tinystr.cpp -o libtinyxml.so
  '';
  
  doCheck = true;
  checkPhase = ''
    ./xmltest
    result=$?
    if [[ $result != 0 ]] ; then
      exit $result
    fi
  '';
  
  installPhase = ''
    mkdir -pv $out/include/
    mkdir -pv $out/lib/pkgconfig/
    mkdir -pv $out/share/doc/tinyxml/
    
    cp -v libtinyxml.so $out/lib/
    cp -v *.h $out/include/
    
    substituteInPlace tinyxml.pc --replace "@out@" "$out"
    substituteInPlace tinyxml.pc --replace "@version@" "${version}"
    cp -v tinyxml.pc $out/lib/pkgconfig/
    
    cp -v docs/* $out/share/doc/tinyxml/
  '';
  
  meta = {
    description = "TinyXML is a simple, small, C++ XML parser that can be easily integrating into other programs.";
    homepage = "http://www.grinninglizard.com/tinyxml/index.html";
    license = "free-non-copyleft";
  };
}
