{ stdenv
, buildPythonPackage
, fetchurl
, isPyPy
, pkgs
, python
}:

buildPythonPackage rec {
  name = "pyparted-${version}";
  version = "3.10.7";
  disabled = isPyPy;

  src = pkgs.fetchurl {
    url = "https://github.com/rhinstaller/pyparted/archive/v${version}.tar.gz";
    sha256 = "0c9ljrdggwawd8wdzqqqzrna9prrlpj6xs59b0vkxzip0jkf652r";
  };

  postPatch = ''
    sed -i -e 's|mke2fs|${pkgs.e2fsprogs}/bin/mke2fs|' tests/baseclass.py
    sed -i -e '
      s|e\.path\.startswith("/tmp/temp-device-")|"temp-device-" in e.path|
    ' tests/test__ped_ped.py
  '' + stdenv.lib.optionalString stdenv.isi686 ''
    # remove some integers in this test case which overflow on 32bit systems
    sed -i -r -e '/class *UnitGetSizeTestCase/,/^$/{/[0-9]{11}/d}' \
      tests/test__ped_ped.py
  '';

  preConfigure = ''
    PATH="${pkgs.parted}/sbin:$PATH"
  '';

  nativeBuildInputs = [ pkgs.pkgconfig ];
  propagatedBuildInputs = [ pkgs.parted ];

  checkPhase = ''
    patchShebangs Makefile
    make test PYTHON=${python.executable}
  '';

  meta = with stdenv.lib; {
    homepage = "https://fedorahosted.org/pyparted/";
    description = "Python interface for libparted";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };

}
