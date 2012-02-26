# Used during module installation to prevent easy_install and python
# setup.py install/test from downloading

{ stdenv, python }:

stdenv.mkDerivation {
  name = "python-offline-distutils-${python.version}";

  buildInputs = [ python ];

  unpackPhase = "true";
  installPhase = ''
    dst="$out/lib/${python.libPrefix}"
    ensureDir $dst/distutils
    ln -s ${python}/lib/${python.libPrefix}/distutils/* $dst/distutils/
    cat <<EOF > $dst/distutils/distutils.cfg
[easy_install]
allow-hosts = None
EOF
  '';

  meta = {
    description = "distutils configured to disallow downloads";
    longDescription = ''
      A normal distutils with added distutils.cfg to set allow-hosts
      to None. This dissallows easy_install to download any packages.
      It is used by buildPythonPackage to ensure that no packages are
      downloaded during build/test/install.
    '';
    license = stdenv.lib.licenses.psfl;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ simons chaoflow ];
  };
}
