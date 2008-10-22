{fetchurl, perl, db4}:

import ../generic perl {
  name = "BerkeleyDB-0.27";
  
  src = fetchurl {
    url = http://nixos.org/tarballs/BerkeleyDB-0.27.tar.gz;
    md5 = "43aa72c0c6941af0d656d749ad543e96";
  };

  preConfigure = ''
    echo "LIB = ${db4}/lib" > config.in
    echo "INCLUDE = ${db4}/include" >> config.in
  '';
}
