{ lib, stdenv
, fetchFromGitHub
, buildPythonPackage
, isPyPy
, pkgs
, python
, six
}:

buildPythonPackage rec {
  pname = "pyparted";
  version = "3.11.7";
  disabled = isPyPy;

  src = fetchFromGitHub {
    repo = pname;
    owner = "dcantrell";
    rev = "v${version}";
    sha256 = "01193fmkss9icjvqpw85szpk8ld1pnha7p9kqm7mpwk6rc6gi2m3";
  };

  postPatch = ''
    sed -i -e 's|mke2fs|${pkgs.e2fsprogs}/bin/mke2fs|' tests/baseclass.py
    sed -i -e '
      s|e\.path\.startswith("/tmp/temp-device-")|"temp-device-" in e.path|
    ' tests/test__ped_ped.py
  '' + lib.optionalString stdenv.isi686 ''
    # remove some integers in this test case which overflow on 32bit systems
    sed -i -r -e '/class *UnitGetSizeTestCase/,/^$/{/[0-9]{11}/d}' \
      tests/test__ped_ped.py
  '';

  patches = [
    ./fix-test-pythonpath.patch
  ];

  preConfigure = ''
    PATH="${pkgs.parted}/sbin:$PATH"
  '';

  nativeBuildInputs = [ pkgs.pkg-config ];
  checkInputs = [ six ];
  propagatedBuildInputs = [ pkgs.parted ];

  checkPhase = ''
    patchShebangs Makefile
    make test PYTHON=${python.executable}
  '';

  meta = with lib; {
    homepage = "https://github.com/dcantrell/pyparted/";
    description = "Python interface for libparted";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lsix ];
  };
}
