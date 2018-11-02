{ stdenv, lib, fetchurl, pkgconfig, xapian, python, pythonPackages, isPy3k
, zlib, buildPythonPackage }:

buildPythonPackage rec {
  pname = "xapian-bindings";
  inherit (xapian) version;

  src = fetchurl {
    url = "https://oligarchy.co.uk/xapian/${version}/${pname}-${version}.tar.xz";
    sha256 = "0ll3z3418r7bzxs4kyini2cbci5xl8i5scl3wyx88s2v4ak56bcz";
  };

  buildInputs = [ xapian pythonPackages.sphinx zlib ];
  nativeBuildInputs = [ pkgconfig ];

  configurePhase = ''./configure PYTHON${lib.optionalString (!isPy3k) "2"}${lib.optionalString (isPy3k) "3"}=${python}/bin/${python.executable} --prefix=$out PYTHON_LIB="$out/lib/${python.libPrefix}"'';

  buildPhase = ''
    mkdir -p $out/lib/${python.libPrefix}
    make
  '';

  installPhase = ''
    make install
  '';

  doCheck = (!isPy3k);

  checkPhase = ''
    cd python${lib.optionalString (isPy3k) "3"}$ 
    export PYTHONPATH=$PYTHONPATH:$out/lib/${python.libPrefix}
    ${python}/bin/${python.executable} smoketest.py
    ${python}/bin/${python.executable} pythontest.py
  '';

  meta = with lib; {
    description = "Python Bindings for Xapian";
    homepage = https://xapian.org/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ leenaars ];
  };
}
