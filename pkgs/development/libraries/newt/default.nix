{ lib, fetchurl, stdenv, slang, popt
, python ? null, pythonSupport ? true
}:

stdenv.mkDerivation rec {
  name = "newt-0.52.19";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/n/e/newt/${name}.tar.gz";
    sha256 = "101fzx5n711wj01rpkcixyfc1iklny8r9fdsgimaz5hrq9bdph08";
  };

  postUnpack = ''
    substituteInPlace $sourceRoot/configure \
      --replace "/usr/include/python" "${python}/include/python"
    substituteInPlace $sourceRoot/configure.ac \
      --replace "/usr/include/python" "${python}/include/python"
  '';

  patchPhase = ''
    sed -i -e s,/usr/bin/install,install, -e s,-I/usr/include/slang,, Makefile.in po/Makefile
  '';

  buildInputs = [ slang popt python ];

  NIX_LDFLAGS = "-lncurses";

  crossAttrs = {
    makeFlags = "CROSS_COMPILE=${stdenv.cross.config}-";
  };

  outputs = [ "out" ]
   ++ lib.optional pythonSupport "py";

  # Separate output for snack
  postFixup = lib.optionalString pythonSupport ''
   moveToOutput ${python.sitePackages} "$py"
  '';

  meta = with stdenv.lib; {
    homepage = https://fedorahosted.org/newt/;
    description = "Library for color text mode, widget based user interfaces";

    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ viric ryantm ];
  };
}
