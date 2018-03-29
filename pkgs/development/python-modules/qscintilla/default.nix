{ lib
, buildPythonPackage
, fetchPypi
, python
, qscintillaCpp
, lndir
, pyqt4
}:

let base = import ./base.nix { inherit lib qscintillaCpp; };
in buildPythonPackage (base // rec {
  buildInputs = [ lndir pyqt4.qt qscintillaCpp ];
  propagatedBuildInputs = [ pyqt4 ];

  # TODO: with qscintilla 2.10 this will have to use configure.py
  preConfigure = ''
    mkdir -p $out
    lndir ${pyqt4} $out
    rm -rf "$out/nix-support"
    cd Python
    ${python.executable} ./configure-old.py \
        --destdir $out/lib/${python.libPrefix}/site-packages/PyQt4 \
        --apidir $out/api/${python.libPrefix} \
        -n ${qscintillaCpp}/include \
        -o ${qscintillaCpp}/lib \
        --sipdir $out/share/sip
  '';
})
