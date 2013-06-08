# Used during module installation to prevent easy_install and python
# setup.py install/test from downloading

{ stdenv, python }:

stdenv.mkDerivation {
  name = "python-offline-distutils-${python.version}";

  buildInputs = [ python ];

  unpackPhase = "true";
  installPhase = ''
    dst="$out/lib/${python.libPrefix}/site-packages"
    ensureDir $dst/distutils
    ln -s ${python}/lib/${python.libPrefix}/distutils/* $dst/distutils/
    cat <<EOF > $dst/distutils/distutils.cfg
[easy_install]
allow-hosts = None
EOF
  '';
}
